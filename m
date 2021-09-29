Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC141C967
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346279AbhI2QDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:50 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24142 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345596AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbK3ZjVz1DHMT;
        Wed, 29 Sep 2021 23:56:45 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:04 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 060/167] net: sctp: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:47 +0800
Message-ID: <20210929155334.12454-61-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/sctp/offload.c | 12 +++++++++---
 net/sctp/output.c  |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index eb874e3c399a..c49464811614 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -39,6 +39,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	netdev_features_t tmp;
 	struct sctphdr *sh;
 
 	if (!skb_is_gso_sctp(skb))
@@ -50,7 +51,9 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 
 	__skb_pull(skb, sizeof(*sh));
 
-	if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
+	netdev_feature_copy(&tmp, features);
+	netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &tmp);
+	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 		struct skb_shared_info *pinfo = skb_shinfo(skb);
 		struct sk_buff *frag_iter;
@@ -68,12 +71,15 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 	}
 
-	segs = skb_segment(skb, (features | NETIF_F_HW_CSUM) & ~NETIF_F_SG);
+	netdev_feature_copy(&tmp, features);
+	netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT, &tmp);
+	netdev_feature_clear_bit(NETIF_F_SG_BIT, &tmp);
+	segs = skb_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out;
 
 	/* All that is left is update SCTP CRC if necessary */
-	if (!(features & NETIF_F_SCTP_CRC)) {
+	if (!netdev_feature_test_bit(NETIF_F_SCTP_CRC_BIT, features)) {
 		for (skb = segs; skb; skb = skb->next) {
 			if (skb->ip_summed == CHECKSUM_PARTIAL) {
 				sh = sctp_hdr(skb);
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 4dfb5ea82b05..bbaadde69358 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -543,7 +543,7 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 	if (sctp_checksum_disable)
 		return 1;
 
-	if (!(tp->dst->dev->features & NETIF_F_SCTP_CRC) ||
+	if (!netdev_feature_test_bit(NETIF_F_SCTP_CRC_BIT, tp->dst->dev->features) ||
 	    dst_xfrm(tp->dst) || packet->ipfragok || tp->encap_port) {
 		struct sctphdr *sh =
 			(struct sctphdr *)skb_transport_header(head);
-- 
2.33.0

