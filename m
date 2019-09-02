Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB06A50C7
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbfIBID1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:03:27 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51426 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729954AbfIBICS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:18 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AED08C0438;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=/MasdnODAJKEeH9TitBj6mYJC/lGR8OKb/0AXAK0+ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YUT83e9PcMthqHTF3hahkdErxCAMXoCE0ZDhtMpc186kRRBCay/6Ea3Dxo7JsEOGu
         qFfUiS5ZToKJ+Fox6+bg1IEjaDPgOjlqd4Lm2rt81kC2+emY+a5u3xfZJNwcyEGOdA
         4BwA1TjGOeIRCIYuXSnr9rhG74GfVJluss16COhgWzAXIZJydhZGwlROs+OK0l7IW7
         vCT1i8ycy4lAPDDWwgH1tc9aJURpsIR4mfBTY8KxbbAB+3gVu3EpeantFP/aWnkd27
         R54D8mO/+gpnAOmCdkYr1A2Q1ZzUcCOQ3oh7aEnTwHkQhxDh2EQCGeMd/pL7euE5By
         ZBUnz6o4PsNng==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 73665A0078;
        Mon,  2 Sep 2019 08:02:15 +0000 (UTC)
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
Subject: [PATCH net-next 07/13] net: stmmac: selftests: Implement the ARP Offload test
Date:   Mon,  2 Sep 2019 10:01:49 +0200
Message-Id: <dadd04bc5a62a1467a60f33ac6369159f5528fd5.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a test for ARP Offload feature.

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 110 +++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 8e9d0aeda817..f531dbe038df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -196,6 +196,24 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 	return skb;
 }
 
+static struct sk_buff *stmmac_test_get_arp_skb(struct stmmac_priv *priv,
+					       struct stmmac_packet_attrs *attr)
+{
+	__be32 ip_src = htonl(attr->ip_src);
+	__be32 ip_dst = htonl(attr->ip_dst);
+	struct sk_buff *skb = NULL;
+
+	skb = arp_create(ARPOP_REQUEST, ETH_P_ARP, ip_dst, priv->dev, ip_src,
+			 NULL, attr->src, attr->dst);
+	if (!skb)
+		return NULL;
+
+	skb->pkt_type = PACKET_HOST;
+	skb->dev = priv->dev;
+
+	return skb;
+}
+
 struct stmmac_test_priv {
 	struct stmmac_packet_attrs *packet;
 	struct packet_type pt;
@@ -1396,6 +1414,94 @@ static int stmmac_test_l4filt_sa_udp(struct stmmac_priv *priv)
 	return __stmmac_test_l4filt(priv, 0, dummy_port, 0, ~0, true);
 }
 
+static int stmmac_test_arp_validate(struct sk_buff *skb,
+				    struct net_device *ndev,
+				    struct packet_type *pt,
+				    struct net_device *orig_ndev)
+{
+	struct stmmac_test_priv *tpriv = pt->af_packet_priv;
+	struct ethhdr *ehdr;
+	struct arphdr *ahdr;
+
+	ehdr = (struct ethhdr *)skb_mac_header(skb);
+	if (!ether_addr_equal(ehdr->h_dest, tpriv->packet->src))
+		goto out;
+
+	ahdr = arp_hdr(skb);
+	if (ahdr->ar_op != htons(ARPOP_REPLY))
+		goto out;
+
+	tpriv->ok = true;
+	complete(&tpriv->comp);
+out:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int stmmac_test_arpoffload(struct stmmac_priv *priv)
+{
+	unsigned char src[ETH_ALEN] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06};
+	unsigned char dst[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	struct stmmac_packet_attrs attr = { };
+	struct stmmac_test_priv *tpriv;
+	struct sk_buff *skb = NULL;
+	u32 ip_addr = 0xdeadcafe;
+	u32 ip_src = 0xdeadbeef;
+	int ret;
+
+	if (!priv->dma_cap.arpoffsel)
+		return -EOPNOTSUPP;
+
+	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
+	if (!tpriv)
+		return -ENOMEM;
+
+	tpriv->ok = false;
+	init_completion(&tpriv->comp);
+
+	tpriv->pt.type = htons(ETH_P_ARP);
+	tpriv->pt.func = stmmac_test_arp_validate;
+	tpriv->pt.dev = priv->dev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = &attr;
+	dev_add_pack(&tpriv->pt);
+
+	attr.src = src;
+	attr.ip_src = ip_src;
+	attr.dst = dst;
+	attr.ip_dst = ip_addr;
+
+	skb = stmmac_test_get_arp_skb(priv, &attr);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
+	if (ret)
+		goto cleanup;
+
+	ret = dev_set_promiscuity(priv->dev, 1);
+	if (ret)
+		goto cleanup;
+
+	skb_set_queue_mapping(skb, 0);
+	ret = dev_queue_xmit(skb);
+	if (ret)
+		goto cleanup_promisc;
+
+	wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
+	ret = tpriv->ok ? 0 : -ETIMEDOUT;
+
+cleanup_promisc:
+	dev_set_promiscuity(priv->dev, -1);
+cleanup:
+	stmmac_set_arp_offload(priv, priv->hw, false, 0x0);
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1505,6 +1611,10 @@ static const struct stmmac_test {
 		.name = "L4 SA UDP Filtering ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_l4filt_sa_udp,
+	}, {
+		.name = "ARP Offload         ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_arpoffload,
 	},
 };
 
-- 
2.7.4

