Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58D5A50BF
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfIBIDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:03:02 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51462 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730018AbfIBICS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:18 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1D37BC043F;
        Mon,  2 Sep 2019 08:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=Xxu8DBtQIODTKuymZxxeRybWui0XYpKFM+1XHky3mfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=chr5YtTAJHV+/3iEMdrvVnv1/v269V2pF+X5gmdOzDQFHnEK5zGqEIRlb5MHbhV6L
         WKk7PHLw3/CqIouROVFaEjmsuRFNxy26xLcgRQHcqBfH2N6Z2s6UUV/2uBmA4Pj5ED
         HferFIY4Jklam/HD8tgq/XaRN0RQQiFRsyqBgENlmLCCG4RTxu1k+Fa38Azu75mNnW
         A1BApHy5TgoxCefFPFSeL8smrX0KC/Vf76MhCfXZSYoV8d4crz043uOjoVTc5ff05T
         f/Gq7C6TJ76G/1/LHwKjiOJEOllIwzm3Ox3F/1RRtlKPNIjf/jamcPo/3B8zxESBFz
         3hjQIPK+/N35g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id CEB8CA008A;
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
Subject: [PATCH net-next 13/13] net: stmmac: selftests: Add Jumbo Frame tests
Date:   Mon,  2 Sep 2019 10:01:55 +0200
Message-Id: <9ddd6fe0609a57fe1e974b5af69f562189dd08cf.1567410971.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test to validate the Jumbo Frame support in stmmac in single
channel and multichannel mode.

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 65 +++++++++++++++++++++-
 1 file changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index f531dbe038df..ff499b91ea9f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -43,9 +43,11 @@ struct stmmac_packet_attrs {
 	int dont_wait;
 	int timeout;
 	int size;
+	int max_size;
 	int remove_sa;
 	u8 id;
 	int sarc;
+	u16 queue_mapping;
 };
 
 static u8 stmmac_test_next_id;
@@ -73,12 +75,14 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 	else
 		size += sizeof(struct udphdr);
 
-	skb = netdev_alloc_skb(priv->dev, size);
+	if (attr->max_size && (attr->max_size > size))
+		size = attr->max_size;
+
+	skb = netdev_alloc_skb_ip_align(priv->dev, size);
 	if (!skb)
 		return NULL;
 
 	prefetchw(skb->data);
-	skb_reserve(skb, NET_IP_ALIGN);
 
 	if (attr->vlan > 1)
 		ehdr = skb_push(skb, ETH_HLEN + 8);
@@ -147,6 +151,9 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 		uhdr->source = htons(attr->sport);
 		uhdr->dest = htons(attr->dport);
 		uhdr->len = htons(sizeof(*shdr) + sizeof(*uhdr) + attr->size);
+		if (attr->max_size)
+			uhdr->len = htons(attr->max_size -
+					  (sizeof(*ihdr) + sizeof(*ehdr)));
 		uhdr->check = 0;
 	}
 
@@ -162,6 +169,10 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 		iplen += sizeof(*thdr);
 	else
 		iplen += sizeof(*uhdr);
+
+	if (attr->max_size)
+		iplen = attr->max_size - sizeof(*ehdr);
+
 	ihdr->tot_len = htons(iplen);
 	ihdr->frag_off = 0;
 	ihdr->saddr = htonl(attr->ip_src);
@@ -178,6 +189,8 @@ static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
 
 	if (attr->size)
 		skb_put(skb, attr->size);
+	if (attr->max_size && (attr->max_size > skb->len))
+		skb_put(skb, attr->max_size - skb->len);
 
 	skb->csum = 0;
 	skb->ip_summed = CHECKSUM_PARTIAL;
@@ -324,7 +337,7 @@ static int __stmmac_test_loopback(struct stmmac_priv *priv,
 		goto cleanup;
 	}
 
-	skb_set_queue_mapping(skb, 0);
+	skb_set_queue_mapping(skb, attr->queue_mapping);
 	ret = dev_queue_xmit(skb);
 	if (ret)
 		goto cleanup;
@@ -1502,6 +1515,44 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
 	return ret;
 }
 
+static int __stmmac_test_jumbo(struct stmmac_priv *priv, u16 queue)
+{
+	struct stmmac_packet_attrs attr = { };
+	int size = priv->dma_buf_sz;
+
+	/* Only XGMAC has SW support for multiple RX descs in same packet */
+	if (priv->plat->has_xgmac)
+		size = priv->dev->max_mtu;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.max_size = size - ETH_FCS_LEN;
+	attr.queue_mapping = queue;
+
+	return __stmmac_test_loopback(priv, &attr);
+}
+
+static int stmmac_test_jumbo(struct stmmac_priv *priv)
+{
+	return __stmmac_test_jumbo(priv, 0);
+}
+
+static int stmmac_test_mjumbo(struct stmmac_priv *priv)
+{
+	u32 chan, tx_cnt = priv->plat->tx_queues_to_use;
+	int ret;
+
+	if (tx_cnt <= 1)
+		return -EOPNOTSUPP;
+
+	for (chan = 0; chan < tx_cnt; chan++) {
+		ret = __stmmac_test_jumbo(priv, chan);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1615,6 +1666,14 @@ static const struct stmmac_test {
 		.name = "ARP Offload         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_arpoffload,
+	}, {
+		.name = "Jumbo Frame         ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_jumbo,
+	}, {
+		.name = "Multichannel Jumbo  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_mjumbo,
 	},
 };
 
-- 
2.7.4

