Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7FF18A5B2
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgCRVDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbgCRUzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:55:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620AC208E0;
        Wed, 18 Mar 2020 20:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564941;
        bh=Mvf0nlAPOIsBi6bXbdEjMKe94UpF17RxnZ9l1Xzf/ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdid3Yv4vDnPO5apwlycxxfJvbgAzmvl0FK/Jb9ZO38wfCakKTcwN6hxJXVPxEk0Q
         nSL6OkCUlf/xEonR5UVILaObuLuBegSw2w7kpFeJu4jyxOiwDtMRvWoEFn7Zj2MuFG
         eW4EzoqTmq26ULqfQEpbOh+HYGe5B3IC4BmZR2As=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/37] ipvlan: don't deref eth hdr before checking it's set
Date:   Wed, 18 Mar 2020 16:54:58 -0400
Message-Id: <20200318205509.17053-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205509.17053-1-sashal@kernel.org>
References: <20200318205509.17053-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit ad8192767c9f9cf97da57b9ffcea70fb100febef ]

IPvlan in L3 mode discards outbound multicast packets but performs
the check before ensuring the ether-header is set or not. This is
an error that Eric found through code browsing.

Fixes: 2ad7bf363841 (“ipvlan: Initial check-in of the IPVLAN driver.”)
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 1a8132eb2a3ec..9b5aaafea1549 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -504,19 +504,21 @@ static int ipvlan_process_outbound(struct sk_buff *skb)
 	struct ethhdr *ethh = eth_hdr(skb);
 	int ret = NET_XMIT_DROP;
 
-	/* In this mode we dont care about multicast and broadcast traffic */
-	if (is_multicast_ether_addr(ethh->h_dest)) {
-		pr_debug_ratelimited("Dropped {multi|broad}cast of type=[%x]\n",
-				     ntohs(skb->protocol));
-		kfree_skb(skb);
-		goto out;
-	}
-
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
 	 * will have L2; which need to discarded and processed further
 	 * in the net-ns of the main-device.
 	 */
 	if (skb_mac_header_was_set(skb)) {
+		/* In this mode we dont care about
+		 * multicast and broadcast traffic */
+		if (is_multicast_ether_addr(ethh->h_dest)) {
+			pr_debug_ratelimited(
+				"Dropped {multi|broad}cast of type=[%x]\n",
+				ntohs(skb->protocol));
+			kfree_skb(skb);
+			goto out;
+		}
+
 		skb_pull(skb, sizeof(*ethh));
 		skb->mac_header = (typeof(skb->mac_header))~0U;
 		skb_reset_network_header(skb);
-- 
2.20.1

