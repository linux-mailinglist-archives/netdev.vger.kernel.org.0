Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FF546204E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbhK2TYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355311AbhK2TWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:22:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E775C09B109;
        Mon, 29 Nov 2021 07:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC83761569;
        Mon, 29 Nov 2021 15:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD277C53FCB;
        Mon, 29 Nov 2021 15:39:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DDJKsn8S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wPKQLr6K4vQwPPM+B1SBNoGkaia7G0hvSiXt3SxPlE=;
        b=DDJKsn8Swx90XSg5Rui/6UUL8Q7tTzz8OFEtxLd4yYi2pIpNCf7S/daBBQKcR5dGA0OpdF
        MRjpHTVti4HS7BXvmNMxxMnfJEFQuMBc4QbeKMM27PjYK6qB9O2+nH/eMQV3kmQ4RMvc3E
        m6G251R6PSWjSP2EuYzIL8QJ7aFOkp4=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 372bfa0c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:50 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Streun Fabio <fstreun@student.ethz.ch>, stable@vger.kernel.org
Subject: [PATCH net 08/10] wireguard: receive: drop handshakes if queue lock is contended
Date:   Mon, 29 Nov 2021 10:39:27 -0500
Message-Id: <20211129153929.3457-9-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we're being delivered packets from multiple CPUs so quickly that the
ring lock is contended for CPU tries, then it's safe to assume that the
queue is near capacity anyway, so just drop the packet rather than
spinning. This helps deal with multicore DoS that can interfere with
data path performance. It _still_ does not completely fix the issue, but
it again chips away at it.

Reported-by: Streun Fabio <fstreun@student.ethz.ch>
Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index f4e537e3e8ec..7b8df406c773 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -554,9 +554,19 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
 	case cpu_to_le32(MESSAGE_HANDSHAKE_INITIATION):
 	case cpu_to_le32(MESSAGE_HANDSHAKE_RESPONSE):
 	case cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE): {
-		int cpu;
-		if (unlikely(!rng_is_initialized() ||
-			     ptr_ring_produce_bh(&wg->handshake_queue.ring, skb))) {
+		int cpu, ret = -EBUSY;
+
+		if (unlikely(!rng_is_initialized()))
+			goto drop;
+		if (atomic_read(&wg->handshake_queue_len) > MAX_QUEUED_INCOMING_HANDSHAKES / 2) {
+			if (spin_trylock_bh(&wg->handshake_queue.ring.producer_lock)) {
+				ret = __ptr_ring_produce(&wg->handshake_queue.ring, skb);
+				spin_unlock_bh(&wg->handshake_queue.ring.producer_lock);
+			}
+		} else
+			ret = ptr_ring_produce_bh(&wg->handshake_queue.ring, skb);
+		if (ret) {
+	drop:
 			net_dbg_skb_ratelimited("%s: Dropping handshake packet from %pISpfsc\n",
 						wg->dev->name, skb);
 			goto err;
-- 
2.34.1

