Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A719846BA
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfHGIEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:04:21 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:33680 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728110AbfHGID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:03:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D95E4C0FF6;
        Wed,  7 Aug 2019 08:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565165008; bh=CWL5q+RjjFO+sLUFL/cpxniTQdsrFh3E/iTbIYja0To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=HmuESkzY61SXKhn5erC/Ny1ivIleW5EpCLjON4EMe4uO2G0AuwWxHO6stHq6xARm5
         oMHEe7XOXYXgSSEmgQe/Nj/7ZO3z3IBAs9oG5/aSETs+PaffqXLNdfr8qGhHunJYkI
         XepqccGoYPwtICM50Mev9wYnUTJinA6X95jsR9y62RKAix50fszj6HJJQqD1YA/xHp
         THZ3WXKKRl58AuvZZyenomP18ApjZ+iL94SWVHEwruaiYLY1rpEdHhP5dc66rDfsbX
         sLNsUeP4q+jSjCR8SEOBcJrhfSHEcBn1vPJH97cmFHG3hfpi46JlLf07uroCEvXgiT
         3GcMwpIFvCgkA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 91ACEA0072;
        Wed,  7 Aug 2019 08:03:26 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 07/10] net: stmmac: selftests: Add test for VLAN and Double VLAN Filtering
Date:   Wed,  7 Aug 2019 10:03:15 +0200
Message-Id: <1ac029b83cd39415c95eb1ee0df8d9cb779bbcae.1565164730.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565164729.git.joabreu@synopsys.com>
References: <cover.1565164729.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565164729.git.joabreu@synopsys.com>
References: <cover.1565164729.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest for VLAN and Double VLAN Filtering in stmmac.

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 205 +++++++++++++++++++++
 1 file changed, 205 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 83b775a8cedc..6b08bb15af15 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -715,6 +715,203 @@ static int stmmac_test_rss(struct stmmac_priv *priv)
 	return __stmmac_test_loopback(priv, &attr);
 }
 
+static int stmmac_test_vlan_validate(struct sk_buff *skb,
+				     struct net_device *ndev,
+				     struct packet_type *pt,
+				     struct net_device *orig_ndev)
+{
+	struct stmmac_test_priv *tpriv = pt->af_packet_priv;
+	struct stmmachdr *shdr;
+	struct ethhdr *ehdr;
+	struct udphdr *uhdr;
+	struct iphdr *ihdr;
+
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
+	if (skb_linearize(skb))
+		goto out;
+	if (skb_headlen(skb) < (STMMAC_TEST_PKT_SIZE - ETH_HLEN))
+		goto out;
+
+	ehdr = (struct ethhdr *)skb_mac_header(skb);
+	if (!ether_addr_equal(ehdr->h_dest, tpriv->packet->dst))
+		goto out;
+
+	ihdr = ip_hdr(skb);
+	if (tpriv->double_vlan)
+		ihdr = (struct iphdr *)(skb_network_header(skb) + 4);
+	if (ihdr->protocol != IPPROTO_UDP)
+		goto out;
+
+	uhdr = (struct udphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
+	if (uhdr->dest != htons(tpriv->packet->dport))
+		goto out;
+
+	shdr = (struct stmmachdr *)((u8 *)uhdr + sizeof(*uhdr));
+	if (shdr->magic != cpu_to_be64(STMMAC_TEST_PKT_MAGIC))
+		goto out;
+
+	tpriv->ok = true;
+	complete(&tpriv->comp);
+
+out:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int stmmac_test_vlanfilt(struct stmmac_priv *priv)
+{
+	struct stmmac_packet_attrs attr = { };
+	struct stmmac_test_priv *tpriv;
+	struct sk_buff *skb = NULL;
+	int ret = 0, i;
+
+	if (!priv->dma_cap.vlhash)
+		return -EOPNOTSUPP;
+
+	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
+	if (!tpriv)
+		return -ENOMEM;
+
+	tpriv->ok = false;
+	init_completion(&tpriv->comp);
+
+	tpriv->pt.type = htons(ETH_P_IP);
+	tpriv->pt.func = stmmac_test_vlan_validate;
+	tpriv->pt.dev = priv->dev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = &attr;
+
+	/*
+	 * As we use HASH filtering, false positives may appear. This is a
+	 * specially chosen ID so that adjacent IDs (+4) have different
+	 * HASH values.
+	 */
+	tpriv->vlan_id = 0x123;
+	dev_add_pack(&tpriv->pt);
+
+	ret = vlan_vid_add(priv->dev, htons(ETH_P_8021Q), tpriv->vlan_id);
+	if (ret)
+		goto cleanup;
+
+	for (i = 0; i < 4; i++) {
+		attr.vlan = 1;
+		attr.vlan_id_out = tpriv->vlan_id + i;
+		attr.dst = priv->dev->dev_addr;
+		attr.sport = 9;
+		attr.dport = 9;
+
+		skb = stmmac_test_get_udp_skb(priv, &attr);
+		if (!skb) {
+			ret = -ENOMEM;
+			goto vlan_del;
+		}
+
+		skb_set_queue_mapping(skb, 0);
+		ret = dev_queue_xmit(skb);
+		if (ret)
+			goto vlan_del;
+
+		wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
+		ret = !tpriv->ok;
+		if (ret && !i) {
+			goto vlan_del;
+		} else if (!ret && i) {
+			ret = -1;
+			goto vlan_del;
+		} else {
+			ret = 0;
+		}
+
+		tpriv->ok = false;
+	}
+
+vlan_del:
+	vlan_vid_del(priv->dev, htons(ETH_P_8021Q), tpriv->vlan_id);
+cleanup:
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
+static int stmmac_test_dvlanfilt(struct stmmac_priv *priv)
+{
+	struct stmmac_packet_attrs attr = { };
+	struct stmmac_test_priv *tpriv;
+	struct sk_buff *skb = NULL;
+	int ret = 0, i;
+
+	if (!priv->dma_cap.vlhash)
+		return -EOPNOTSUPP;
+
+	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
+	if (!tpriv)
+		return -ENOMEM;
+
+	tpriv->ok = false;
+	tpriv->double_vlan = true;
+	init_completion(&tpriv->comp);
+
+	tpriv->pt.type = htons(ETH_P_8021Q);
+	tpriv->pt.func = stmmac_test_vlan_validate;
+	tpriv->pt.dev = priv->dev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = &attr;
+
+	/*
+	 * As we use HASH filtering, false positives may appear. This is a
+	 * specially chosen ID so that adjacent IDs (+4) have different
+	 * HASH values.
+	 */
+	tpriv->vlan_id = 0x123;
+	dev_add_pack(&tpriv->pt);
+
+	ret = vlan_vid_add(priv->dev, htons(ETH_P_8021AD), tpriv->vlan_id);
+	if (ret)
+		goto cleanup;
+
+	for (i = 0; i < 4; i++) {
+		attr.vlan = 2;
+		attr.vlan_id_out = tpriv->vlan_id + i;
+		attr.dst = priv->dev->dev_addr;
+		attr.sport = 9;
+		attr.dport = 9;
+
+		skb = stmmac_test_get_udp_skb(priv, &attr);
+		if (!skb) {
+			ret = -ENOMEM;
+			goto vlan_del;
+		}
+
+		skb_set_queue_mapping(skb, 0);
+		ret = dev_queue_xmit(skb);
+		if (ret)
+			goto vlan_del;
+
+		wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
+		ret = !tpriv->ok;
+		if (ret && !i) {
+			goto vlan_del;
+		} else if (!ret && i) {
+			ret = -1;
+			goto vlan_del;
+		} else {
+			ret = 0;
+		}
+
+		tpriv->ok = false;
+	}
+
+vlan_del:
+	vlan_vid_del(priv->dev, htons(ETH_P_8021AD), tpriv->vlan_id);
+cleanup:
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -764,6 +961,14 @@ static const struct stmmac_test {
 		.name = "RSS                  ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_rss,
+	}, {
+		.name = "VLAN Filtering       ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_vlanfilt,
+	}, {
+		.name = "Double VLAN Filtering",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_dvlanfilt,
 	},
 };
 
-- 
2.7.4

