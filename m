Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3C013F96B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgAPQwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgAPQwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DEC521582;
        Thu, 16 Jan 2020 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193556;
        bh=4+Jc9X+Bm+QQga3/srXTli+03HcHZcAlLxin47yvUVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlfMSBJoUSuKN8sDQwRfcqH1v4OndOIGTW9HfQybzIbhiAlqtQJ9Ie2x1TUFzxuX8
         MA4GnuC02Ml+02/L07fyVTjjM1NE+pWv5z01pcBofWvz0nJ3vvV5bn/Z/ajNv2Tn9A
         gts/xBuYtgve9yHMwGSUbpWP4GUgBqfR3uTNsUFE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 102/205] hv_netvsc: flag software created hash value
Date:   Thu, 16 Jan 2020 11:41:17 -0500
Message-Id: <20200116164300.6705-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <sthemmin@microsoft.com>

[ Upstream commit df9f540ca74297a84bafacfa197e9347b20beea5 ]

When the driver needs to create a hash value because it
was not done at higher level, then the hash should be marked
as a software not hardware hash.

Fixes: f72860afa2e3 ("hv_netvsc: Exclude non-TCP port numbers from vRSS hashing")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 78e3e689a733..0dee358864f3 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -285,9 +285,9 @@ static inline u32 netvsc_get_hash(
 		else if (flow.basic.n_proto == htons(ETH_P_IPV6))
 			hash = jhash2((u32 *)&flow.addrs.v6addrs, 8, hashrnd);
 		else
-			hash = 0;
+			return 0;
 
-		skb_set_hash(skb, hash, PKT_HASH_TYPE_L3);
+		__skb_set_sw_hash(skb, hash, false);
 	}
 
 	return hash;
@@ -795,8 +795,7 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	    skb->protocol == htons(ETH_P_IP))
 		netvsc_comp_ipcsum(skb);
 
-	/* Do L4 checksum offload if enabled and present.
-	 */
+	/* Do L4 checksum offload if enabled and present. */
 	if (csum_info && (net->features & NETIF_F_RXCSUM)) {
 		if (csum_info->receive.tcp_checksum_succeeded ||
 		    csum_info->receive.udp_checksum_succeeded)
-- 
2.20.1

