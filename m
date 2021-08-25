Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871943F7130
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbhHYIjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 04:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbhHYIjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 04:39:41 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A86CC061757;
        Wed, 25 Aug 2021 01:38:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 17so22349619pgp.4;
        Wed, 25 Aug 2021 01:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BQ5Km8P5KshreDxxyfZN+g53ic8Bq6hG2JyV+9iqoI8=;
        b=iFFhRGxdH+NeAiYMTNireqJG2l/UYCQOXCnjGSnQFMArA+eGw+8wfcveq4IT1WeYKO
         vw9beeyxSi1qsmdxVK+o1EtnDn1hsXbzej53jUICNyISg+TOszHId1hpnMAiKOQgItMN
         kgjGP5fOoO3lA5RtBPE+vl1CcGSFnrb5cLOFth5/THAWxRSYhSkehomdaP7hjebMYKJe
         jDpyYTwcHhjogeVhzTMCUj+5MehL8zyfHoPWzTruofKv/nLlfbHZD0NK9ARqn+2ivJeG
         iTYteEct0Urw0+NoBAS9aZ2aAcY7qfQAPGNM8D85H0lHlcUOrK9MUBD0KPuGQMd90irH
         3TKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BQ5Km8P5KshreDxxyfZN+g53ic8Bq6hG2JyV+9iqoI8=;
        b=JYnvFrdJK+YuMNsHcnqafx0425d2mTHsQagjeVRPlv4GGn/VWqc7AoU/LzzllJHe/p
         TPtWWPU6ZC7CXeui7e7a+L+xRH9ZGFAui2KQO0a4jr6GMoYF6/rNO+G9T2v61bUs7jbe
         2auGdLguKOa5B8dUNW39UpbxR5j5ySTl0rS1BhxRh5dQWdcXM9m3aDAnIk9yIdrQxe4j
         DvbzXtnPNhAthG3ZOY/GDqoj57g5O1RtCh+gQ3TJA+HS5zn7tqIMsfNKkDbavbf6U+7H
         7mN24o5G1mndHr3VfoROAIGAjMgm8yOHzhE4Tx3PhYAXtP4Y1SykQ8MZAG4y6pquFIev
         ee1w==
X-Gm-Message-State: AOAM5302LMhMGNXiyCWKLRynCrLWICqoFvye1mAWhj20HfCXsiG4qQwy
        eQ8uN+Wi+v7NQXzOzUSk3uA=
X-Google-Smtp-Source: ABdhPJxdfhF4L9hI63/ncflJW8yqJrHcIQJNGKtQAmcyZJAyAWmfBEqk0nGVgPCddFeurrjP49SaEA==
X-Received: by 2002:a05:6a00:22d2:b0:3eb:b41:583 with SMTP id f18-20020a056a0022d200b003eb0b410583mr21417058pfj.73.1629880735662;
        Wed, 25 Aug 2021 01:38:55 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id p18sm24872294pgk.28.2021.08.25.01.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 01:38:55 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 2/2] net: dsa: tag_mtk: handle VLAN tag insertion on TX
Date:   Wed, 25 Aug 2021 16:38:31 +0800
Message-Id: <20210825083832.2425886-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210825083832.2425886-1-dqfext@gmail.com>
References: <20210825083832.2425886-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Advertise TX VLAN offload features, and handle VLAN tag insertion in
the tag_xmit function.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 net/dsa/tag_mtk.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 415d8ece242a..e407abefa06c 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -22,7 +22,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u8 xmit_tpid;
 	u8 *mtk_tag;
 
 	/* Build the special tag after the MAC Source Address. If VLAN header
@@ -31,33 +30,31 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * the both special and VLAN tag at the same time and then look up VLAN
 	 * table with VID.
 	 */
-	switch (skb->protocol) {
-	case htons(ETH_P_8021Q):
-		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_8100;
-		break;
-	case htons(ETH_P_8021AD):
-		xmit_tpid = MTK_HDR_XMIT_TAGGED_TPID_88A8;
-		break;
-	default:
-		xmit_tpid = MTK_HDR_XMIT_UNTAGGED;
-		skb_push(skb, MTK_HDR_LEN);
-		dsa_alloc_etype_header(skb, MTK_HDR_LEN);
-	}
-
+	skb_push(skb, MTK_HDR_LEN);
+	dsa_alloc_etype_header(skb, MTK_HDR_LEN);
 	mtk_tag = dsa_etype_header_pos_tx(skb);
 
-	/* Mark tag attribute on special tag insertion to notify hardware
-	 * whether that's a combined special tag with 802.1Q header.
-	 */
-	mtk_tag[0] = xmit_tpid;
-	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
-
-	/* Tag control information is kept for 802.1Q */
-	if (xmit_tpid == MTK_HDR_XMIT_UNTAGGED) {
-		mtk_tag[2] = 0;
-		mtk_tag[3] = 0;
+	if (skb_vlan_tag_present(skb)) {
+		switch (skb->vlan_proto) {
+		case htons(ETH_P_8021Q):
+			mtk_tag[0] = MTK_HDR_XMIT_TAGGED_TPID_8100;
+			break;
+		case htons(ETH_P_8021AD):
+			mtk_tag[0] = MTK_HDR_XMIT_TAGGED_TPID_88A8;
+			break;
+		default:
+			return NULL;
+		}
+
+		((__be16 *)mtk_tag)[1] = htons(skb_vlan_tag_get(skb));
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		mtk_tag[0] = MTK_HDR_XMIT_UNTAGGED;
+		((__be16 *)mtk_tag)[1] = 0;
 	}
 
+	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
+
 	return skb;
 }
 
@@ -96,6 +93,7 @@ static const struct dsa_device_ops mtk_netdev_ops = {
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
 	.needed_headroom = MTK_HDR_LEN,
+	.features	= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.25.1

