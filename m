Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A539D4626FC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhK2W76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbhK2W7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:59:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8EDC08EC28
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 09:48:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E36FB8111B
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24B3C53FAD
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OuwYNhbM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638208100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/3bonQViHsboctTvyrm0YSZ77JkTXKXdjpqXCNJMMI=;
        b=OuwYNhbMoBH2Elaa2zV+eBZMAsUCqB39Xq2xi7NL0slz4vA4jJ3bGVnbreMUNQYtVOJRA1
        0dT4PY6TlGrg4I3L3eJq35zvdyITji15fqtM3wIcCHKs4yFoNdEhx+0uWxjtSGfAOm1Nn9
        Qtu84L5eIuKTKRvItPga2DuP4TqceO0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fbab86cf (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 29 Nov 2021 17:48:20 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 03/10] wireguard: selftests: actually test for routing loops
Date:   Mon, 29 Nov 2021 10:39:22 -0500
Message-Id: <20211129153929.3457-4-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We previously removed the restriction on looping to self, and then added
a test to make sure the kernel didn't blow up during a routing loop. The
kernel didn't blow up, thankfully, but on certain architectures where
skb fragmentation is easier, such as ppc64, the skbs weren't actually
being discarded after a few rounds through. But the test wasn't catching
this. So actually test explicitly for massive increases in tx to see if
we have a routing loop. Note that the actual loop problem will need to
be addressed in a different commit.

Fixes: b673e24aad36 ("wireguard: socket: remove errant restriction on looping to self")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index ebc4ee0fe179..2e5c1630885e 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -276,7 +276,11 @@ n0 ping -W 1 -c 1 192.168.241.2
 n1 wg set wg0 peer "$pub2" endpoint 192.168.241.2:7
 ip2 link del wg0
 ip2 link del wg1
-! n0 ping -W 1 -c 10 -f 192.168.241.2 || false # Should not crash kernel
+read _ _ tx_bytes_before < <(n0 wg show wg1 transfer)
+! n0 ping -W 1 -c 10 -f 192.168.241.2 || false
+sleep 1
+read _ _ tx_bytes_after < <(n0 wg show wg1 transfer)
+(( tx_bytes_after - tx_bytes_before < 70000 ))
 
 ip0 link del wg1
 ip1 link del wg0
-- 
2.34.1

