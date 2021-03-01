Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931043282EC
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhCAQCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbhCAQCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 11:02:53 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F65DC061756;
        Mon,  1 Mar 2021 08:02:12 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id c19so11552292pjq.3;
        Mon, 01 Mar 2021 08:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yAJ35ttTIYDaI03L0R6KlFCI401JDb9oaNvf3irJiO8=;
        b=iISj92BVreEJ2LpNvSZhMhGd9VC2A8DXy5c/sz+6O+U98rLX64zXTc7BQBbxaf6zQz
         ZfXL7f34UG/6Z2mgnb0M5b3eAUaAzsclp0olHTOagY4kIHZvgX1Zx6JDdDY8ub9MWU/Q
         u+kXGN6FjS/GHk4NlyKbpMf1xy2ragULlAN5wXe2rYxFJZpFR+7tXpZuxSnqLNKB3uf2
         rSO+E+2rgqj4LBVYc/97+9biZHhp3FmgemkmXDRpEsju/3VI+skwPimvKRz6RA7H0Dz/
         FgkC0vww9nDqhbxdiaLNcvYqNYIpa0hR9KgJTdHtQuqeLbutWB0tB+ZU1kxln5PEnr9v
         WH3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yAJ35ttTIYDaI03L0R6KlFCI401JDb9oaNvf3irJiO8=;
        b=WZ7P8J6FXM4Jxh74Yw0yTTYWOyNPjpXXzKQ4sirgGxwaaogu+nPYj13Iao5w4Adf7E
         HDwhUotR8RQTbCAKN5nQqa+MFHau1LGqTQXgQblANCVq6vxoYiOEoZcBOZduFaqixj0I
         pYU5svwMixL4Xd3nMCiYDVRm6J/zKBISKpj41bzl4gtiOeZccIfisDUeROA4PPxnVeYu
         4MdmmlF1s2Yq4DGBBN5lBqDGG4WRRBhwZPiHBlcHmn8K00YNZ5omVWDU92y4r8mRTaTo
         0FaPhs7VwLjrkYK5ngTNrsWL3bTxxisJ1NuGVQHQn6yd/LaV1jkfLLBOk+h4ywcByAbI
         2woQ==
X-Gm-Message-State: AOAM5300+RfmcJHZ6i0QYGi8CUWt//QyP5UF4R1F9VRUEUyBbq4ZStfy
        t2D9SE09DJwILugmBM3r8bk=
X-Google-Smtp-Source: ABdhPJzsVR8mOsz7Yc3zfxrjeSBvYYK+Rd3GpMC4Y0Eqqbf19NW2wIrBiZKvhPI39QJ6IqtFa5m8aw==
X-Received: by 2002:a17:90a:ce82:: with SMTP id g2mr15022366pju.193.1614614531638;
        Mon, 01 Mar 2021 08:02:11 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.27.50])
        by smtp.gmail.com with ESMTPSA id o9sm16604078pfh.47.2021.03.01.08.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:02:10 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilario Gelmetti <iochesonome@gmail.com>
Subject: [PATCH net] net: dsa: tag_mtk: fix 802.1ad VLAN egress
Date:   Tue,  2 Mar 2021 00:01:59 +0800
Message-Id: <20210301160159.7622-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A different TPID bit is used for 802.1ad VLAN frames.

Reported-by: Ilario Gelmetti <iochesonome@gmail.com>
Fixes: f0af34317f4b ("net: dsa: mediatek: combine MediaTek tag with VLAN tag")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 net/dsa/tag_mtk.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 38dcdded74c0..59748487664f 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -13,6 +13,7 @@
 #define MTK_HDR_LEN		4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
+#define MTK_HDR_XMIT_TAGGED_TPID_88A8	2
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
 #define MTK_HDR_XMIT_SA_DIS		BIT(6)
@@ -21,8 +22,8 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 xmit_tpid;
 	u8 *mtk_tag;
-	bool is_vlan_skb = true;
 	unsigned char *dest = eth_hdr(skb)->h_dest;
 	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
 				!is_broadcast_ether_addr(dest);
@@ -33,10 +34,17 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * the both special and VLAN tag at the same time and then look up VLAN
 	 * table with VID.
 	 */
-	if (!skb_vlan_tagged(skb)) {
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
+		break;
+	case htons(ETH_P_8021AD):
+		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
+		break;
+	default:
+		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
-		is_vlan_skb = false;
 	}
 
 	mtk_tag = skb->data + 2 * ETH_ALEN;
@@ -44,8 +52,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	/* Mark tag attribute on special tag insertion to notify hardware
 	 * whether that's a combined special tag with 802.1Q header.
 	 */
-	mtk_tag[0] = is_vlan_skb ? MTK_HDR_XMIT_TAGGED_TPID_8100 :
-		     MTK_HDR_XMIT_UNTAGGED;
+	mtk_tag[0] = xmit_tpid;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
 	/* Disable SA learning for multicast frames */
@@ -53,7 +60,7 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
 
 	/* Tag control information is kept for 802.1Q */
-	if (!is_vlan_skb) {
+	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
 		mtk_tag[2] = 0;
 		mtk_tag[3] = 0;
 	}
-- 
2.25.1

