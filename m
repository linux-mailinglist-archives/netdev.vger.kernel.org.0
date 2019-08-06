Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0537483325
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbfHFNnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:43:41 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:59126 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731584AbfHFNm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:42:57 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9C836C21CA;
        Tue,  6 Aug 2019 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565098977; bh=CWL5q+RjjFO+sLUFL/cpxniTQdsrFh3E/iTbIYja0To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=jB3PDldCCPHz6QSDrnidNC87dgTOgaHQlgGGbojv6FDIzu8GB4rBF6tFkteeDgyvh
         El9JIQst7bDywEujhwYzNu+/vkB5JkIM6Q0EcIFy9nEz42rZHlS3zICK4RFrrhT8+f
         nT8tEaWMU/NXtobEHMLDTR2Oidk3wYD3RCGPv5BX1GwoEK8S9Mpc9TyCfejAyp96+n
         SowVRBuEldRW2NtKci9J2/MSByUAzPF9MBKo3XyCL1EeEJ1gqsD6tL6o3ZjqMtwxYK
         Czqn6uNJuLjRGvFyz6GOFhg0bAVijET+8yW9ORLnOBnWxqq9yCaZvWCcQ7NT6JPU+l
         zOvAJaUNV7PrA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 3628DA0071;
        Tue,  6 Aug 2019 13:42:55 +0000 (UTC)
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
Subject: [PATCH net-next v2 07/10] net: stmmac: selftests: Add test for VLAN and Double VLAN Filtering
Date:   Tue,  6 Aug 2019 15:42:48 +0200
Message-Id: <783f26120102caf81d602abb504d8b14f3aea7b2.1565098881.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
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

