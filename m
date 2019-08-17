Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E027791283
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfHQSzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:55:44 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:52474 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbfHQSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:54:58 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7B6C5C0C4D;
        Sat, 17 Aug 2019 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068098; bh=RVdfzAnkLd2cFbezBg+5+IcJ5jUr94r8t2wC6fXWHBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=fqGFp86KDvPB2tbQFDTC2IJ2j6VbZCB/3O07q0YxVTVEwUEeeVpvVWHX8epyVgfth
         UaLR2VXR/jt6HQ4wrvOv1yhgVniWEQSK5jnYsf/62c1+KCoaTMZqJcoC2EX6rNOE+C
         5gOTo9wOMPKFESeVHnB8GrS4ggsruj+8AJek9fRCc5lZvGFvigXFXi198WE7j9HUql
         JaBSOjX7kovNzkLKr1mC5XnOD4PW/WSAY/jGAmzgSW8RNVlCQOHrr79R9sKJCopvIM
         OpNuaJ0uc5b2fUBy5/NayCcDCNNULyW/oM3EqldiYj6hzWAGlnAWcnRelVGpGy+D2I
         4GVPqC/Iu+K5A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 20D4CA0082;
        Sat, 17 Aug 2019 18:54:56 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 12/12] net: stmmac: selftests: Add selftest for VLAN TX Offload
Date:   Sat, 17 Aug 2019 20:54:51 +0200
Message-Id: <7b3d9c56e7a010c47c994341f03f962090b3ee68.1566067803.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2 new selftests for VLAN Insertion offloading. Tests are for inner
and outer VLAN offloading.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 96 +++++++++++++++++++++-
 1 file changed, 94 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index acfab86431b1..ecc8602c6799 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -296,7 +296,9 @@ static int __stmmac_test_loopback(struct stmmac_priv *priv,
 	tpriv->pt.dev = priv->dev;
 	tpriv->pt.af_packet_priv = tpriv;
 	tpriv->packet = attr;
-	dev_add_pack(&tpriv->pt);
+
+	if (!attr->dont_wait)
+		dev_add_pack(&tpriv->pt);
 
 	skb = stmmac_test_get_udp_skb(priv, attr);
 	if (!skb) {
@@ -319,7 +321,8 @@ static int __stmmac_test_loopback(struct stmmac_priv *priv,
 	ret = !tpriv->ok;
 
 cleanup:
-	dev_remove_pack(&tpriv->pt);
+	if (!attr->dont_wait)
+		dev_remove_pack(&tpriv->pt);
 	kfree(tpriv);
 	return ret;
 }
@@ -731,6 +734,9 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 	struct ethhdr *ehdr;
 	struct udphdr *uhdr;
 	struct iphdr *ihdr;
+	u16 proto;
+
+	proto = tpriv->double_vlan ? ETH_P_8021AD : ETH_P_8021Q;
 
 	skb = skb_unshare(skb, GFP_ATOMIC);
 	if (!skb)
@@ -740,6 +746,12 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 		goto out;
 	if (skb_headlen(skb) < (STMMAC_TEST_PKT_SIZE - ETH_HLEN))
 		goto out;
+	if (tpriv->vlan_id) {
+		if (skb->vlan_proto != htons(proto))
+			goto out;
+		if (skb->vlan_tci != tpriv->vlan_id)
+			goto out;
+	}
 
 	ehdr = (struct ethhdr *)skb_mac_header(skb);
 	if (!ether_addr_equal(ehdr->h_dest, tpriv->packet->dst))
@@ -1084,6 +1096,78 @@ static int stmmac_test_reg_sar(struct stmmac_priv *priv)
 	return ret;
 }
 
+static int stmmac_test_vlanoff_common(struct stmmac_priv *priv, bool svlan)
+{
+	struct stmmac_packet_attrs attr = { };
+	struct stmmac_test_priv *tpriv;
+	struct sk_buff *skb = NULL;
+	int ret = 0;
+	u16 proto;
+
+	if (!priv->dma_cap.vlins)
+		return -EOPNOTSUPP;
+
+	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
+	if (!tpriv)
+		return -ENOMEM;
+
+	proto = svlan ? ETH_P_8021AD : ETH_P_8021Q;
+
+	tpriv->ok = false;
+	tpriv->double_vlan = svlan;
+	init_completion(&tpriv->comp);
+
+	tpriv->pt.type = svlan ? htons(ETH_P_8021Q) : htons(ETH_P_IP);
+	tpriv->pt.func = stmmac_test_vlan_validate;
+	tpriv->pt.dev = priv->dev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = &attr;
+	tpriv->vlan_id = 0x123;
+	dev_add_pack(&tpriv->pt);
+
+	ret = vlan_vid_add(priv->dev, htons(proto), tpriv->vlan_id);
+	if (ret)
+		goto cleanup;
+
+	attr.dst = priv->dev->dev_addr;
+
+	skb = stmmac_test_get_udp_skb(priv, &attr);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto vlan_del;
+	}
+
+	__vlan_hwaccel_put_tag(skb, htons(proto), tpriv->vlan_id);
+	skb->protocol = htons(proto);
+
+	skb_set_queue_mapping(skb, 0);
+	ret = dev_queue_xmit(skb);
+	if (ret)
+		goto vlan_del;
+
+	wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
+	ret = tpriv->ok ? 0 : -ETIMEDOUT;
+
+vlan_del:
+	vlan_vid_del(priv->dev, htons(proto), tpriv->vlan_id);
+cleanup:
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
+static int stmmac_test_vlanoff(struct stmmac_priv *priv)
+{
+	return stmmac_test_vlanoff_common(priv, false);
+}
+
+static int stmmac_test_svlanoff(struct stmmac_priv *priv)
+{
+	if (!priv->dma_cap.dvlan)
+		return -EOPNOTSUPP;
+	return stmmac_test_vlanoff_common(priv, true);
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1161,6 +1245,14 @@ static const struct stmmac_test {
 		.name = "SA Replacement (reg)",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_reg_sar,
+	}, {
+		.name = "VLAN TX Insertion   ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_vlanoff,
+	}, {
+		.name = "SVLAN TX Insertion  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_svlanoff,
 	},
 };
 
-- 
2.7.4

