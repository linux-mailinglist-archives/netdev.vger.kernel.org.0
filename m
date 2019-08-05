Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22D8822D3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbfHEQpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:45:55 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:40054 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729270AbfHEQpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BE91CC01D3;
        Mon,  5 Aug 2019 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023530; bh=ioVAbVTrp1gtNxHKmKRDAI7LBoyQFB7nOdhp6renXbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=eEQUHpKQREg6IkNlc2rx6Dqge3j7QbMfr18MQd2OjgqJfSQmb2RfMWJA9CCPgKAk9
         1VGxK19ro1OCgK8vMGGi0vpN6U13eXjET2PiZ/aignDSOLNwr5rrlOduW18UMk4hOi
         SfcKhYIGGK7h7y5hdKFd4cI2LE/oWtjMEBxMGpE83PHTtgfFG1klKQJDXLDlc5Av5O
         58/JL2dLPn8vwZQPH9V/m2ONJ2tpuJOKTiHeqXY1oqCo9Mayv0OnCrhg9cM+9kR8B/
         eXki6gH52olkYqz25KOSB82ZsrcU0iVDRjpzVWxFJQtldVC9jJstAvLTwzsPD3t0VS
         llkhW07ks6lHw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 858C1A00A9;
        Mon,  5 Aug 2019 16:45:28 +0000 (UTC)
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
Subject: [PATCH net-next 25/26] net: stmmac: selftests: Add selftest for VLAN TX Offload
Date:   Mon,  5 Aug 2019 18:44:52 +0200
Message-Id: <4bde6753c9ec8aebdc981857715c8ecd0b12e2d1.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 81 ++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index acfab86431b1..a0da35b2b4c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -731,6 +731,9 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 	struct ethhdr *ehdr;
 	struct udphdr *uhdr;
 	struct iphdr *ihdr;
+	u16 proto;
+
+	proto = tpriv->double_vlan ? ETH_P_8021AD : ETH_P_8021Q;
 
 	skb = skb_unshare(skb, GFP_ATOMIC);
 	if (!skb)
@@ -740,6 +743,12 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
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
@@ -1084,6 +1093,70 @@ static int stmmac_test_reg_sar(struct stmmac_priv *priv)
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
+	tpriv->pt.type = htons(ETH_P_IP);
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
+	ret = __stmmac_test_loopback(priv, &attr);
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
@@ -1161,6 +1234,14 @@ static const struct stmmac_test {
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

