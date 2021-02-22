Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B4321CF6
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhBVQ3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:29:12 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:32820 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231725AbhBVQ1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2C+KauK5gZ/RdommxEl+TrbuudLez7C1bij2S/qAJFQ=;
        b=WSTNHYz5s6qt/MiVwYbz6488DMw5CRymJM0KgYA2LlXXh5MsNl1h35lSw/9aC19cmVPPDi
        jLHYqdTiWR9egrLqCLiZdFmZYmwrr1ZFk0LDUS1fJZ1r8thGY99mlSCrg9VEfzO7exJM0t
        JCFMHB7OdpOBQPJgy2tf6KzwVl/aYmM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ace57776 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:26:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 4/7] wireguard: peer: put frequently used members above cache lines
Date:   Mon, 22 Feb 2021 17:25:46 +0100
Message-Id: <20210222162549.3252778-5-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The is_dead boolean is checked for every single packet, while the
internal_id member is used basically only for pr_debug messages. So it
makes sense to hoist up is_dead into some space formerly unused by a
struct hole, while demoting internal_api to below the lowest struct
cache line.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/peer.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/peer.h b/drivers/net/wireguard/peer.h
index 23af40922997..aaff8de6e34b 100644
--- a/drivers/net/wireguard/peer.h
+++ b/drivers/net/wireguard/peer.h
@@ -39,6 +39,7 @@ struct wg_peer {
 	struct crypt_queue tx_queue, rx_queue;
 	struct sk_buff_head staged_packet_queue;
 	int serial_work_cpu;
+	bool is_dead;
 	struct noise_keypairs keypairs;
 	struct endpoint endpoint;
 	struct dst_cache endpoint_cache;
@@ -61,9 +62,8 @@ struct wg_peer {
 	struct rcu_head rcu;
 	struct list_head peer_list;
 	struct list_head allowedips_list;
-	u64 internal_id;
 	struct napi_struct napi;
-	bool is_dead;
+	u64 internal_id;
 };
 
 struct wg_peer *wg_peer_create(struct wg_device *wg,
-- 
2.30.1

