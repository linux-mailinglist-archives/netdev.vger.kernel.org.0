Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D2F9128A
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfHQS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:56:01 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53896 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726089AbfHQSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:54:58 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 36558C0E47;
        Sat, 17 Aug 2019 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068097; bh=Xz26BZZOJit3JigreKorMytvcGTIkOB52bvcggv67Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=mZjFubm+xr8+O6xgLmM40IaSQZ1VVIYCxMbp2pkaz7tzhNXm30LN1piAHhGj3sYOU
         OTsHMQLZm1Qoz9hqEwbEJf1ypRq+crcDb6ZLYZQV5QdVkwZAb1UGJ6bu4rHwSmkzPG
         mEJKxyQTIsATJHCrBUgxSAR/JxBmZ2j9WJRgdy1YWr7bSRBLZhGVJxlWNPiAS2d3Wy
         JtE8iOdkA6uzyQX0QN6adxMhdrTq9yeIH3r+Yqh5e9GUimsG7TFk+tHk/sfQzEDOid
         y0kSIyZjMhel/n7VixWIYLbfHNGRFJA97e5J0fpp9jmSlJccr4TyQ8FJIOhZqKg+JU
         JtgkiBhCReNRw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E6034A0079;
        Sat, 17 Aug 2019 18:54:55 +0000 (UTC)
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
Subject: [PATCH net-next v3 09/12] net: stmmac: selftests: Add tests for SA Insertion/Replacement
Date:   Sat, 17 Aug 2019 20:54:48 +0200
Message-Id: <072518f78634fba212122d4a5039ecaedf3ff675.1566067803.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 4 new tests:
	- SA Insertion (register based)
	- SA Insertion (descriptor based)
	- SA Replacament (register based)
	- SA Replacement (descriptor based)

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 98 +++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index abab84f2ef8b..acfab86431b1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -45,6 +45,7 @@ struct stmmac_packet_attrs {
 	int size;
 	int remove_sa;
 	u8 id;
+	int sarc;
 };
 
 static u8 stmmac_test_next_id;
@@ -230,7 +231,10 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 		if (!ether_addr_equal(ehdr->h_dest, tpriv->packet->dst))
 			goto out;
 	}
-	if (tpriv->packet->src) {
+	if (tpriv->packet->sarc) {
+		if (!ether_addr_equal(ehdr->h_source, ehdr->h_dest))
+			goto out;
+	} else if (tpriv->packet->src) {
 		if (!ether_addr_equal(ehdr->h_source, tpriv->packet->src))
 			goto out;
 	}
@@ -1004,6 +1008,82 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 }
 #endif
 
+static int stmmac_test_desc_sai(struct stmmac_priv *priv)
+{
+	unsigned char src[ETH_ALEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	attr.remove_sa = true;
+	attr.sarc = true;
+	attr.src = src;
+	attr.dst = priv->dev->dev_addr;
+
+	priv->sarc_type = 0x1;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+
+	priv->sarc_type = 0x0;
+	return ret;
+}
+
+static int stmmac_test_desc_sar(struct stmmac_priv *priv)
+{
+	unsigned char src[ETH_ALEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	attr.sarc = true;
+	attr.src = src;
+	attr.dst = priv->dev->dev_addr;
+
+	priv->sarc_type = 0x2;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+
+	priv->sarc_type = 0x0;
+	return ret;
+}
+
+static int stmmac_test_reg_sai(struct stmmac_priv *priv)
+{
+	unsigned char src[ETH_ALEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	attr.remove_sa = true;
+	attr.sarc = true;
+	attr.src = src;
+	attr.dst = priv->dev->dev_addr;
+
+	if (stmmac_sarc_configure(priv, priv->ioaddr, 0x2))
+		return -EOPNOTSUPP;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+
+	stmmac_sarc_configure(priv, priv->ioaddr, 0x0);
+	return ret;
+}
+
+static int stmmac_test_reg_sar(struct stmmac_priv *priv)
+{
+	unsigned char src[ETH_ALEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	attr.sarc = true;
+	attr.src = src;
+	attr.dst = priv->dev->dev_addr;
+
+	if (stmmac_sarc_configure(priv, priv->ioaddr, 0x3))
+		return -EOPNOTSUPP;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+
+	stmmac_sarc_configure(priv, priv->ioaddr, 0x0);
+	return ret;
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1065,6 +1145,22 @@ static const struct stmmac_test {
 		.name = "Flexible RX Parser   ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_rxp,
+	}, {
+		.name = "SA Insertion (desc)  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_desc_sai,
+	}, {
+		.name = "SA Replacement (desc)",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_desc_sar,
+	}, {
+		.name = "SA Insertion (reg)  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_reg_sai,
+	}, {
+		.name = "SA Replacement (reg)",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_reg_sar,
 	},
 };
 
-- 
2.7.4

