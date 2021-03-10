Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E7D333C24
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhCJMEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbhCJMEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:47 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD98C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:46 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w9so27617503edc.11
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XUi8gowQSgFvmLf+t1J83hXEcoJ+WnDjt01OgciC29U=;
        b=gI5Q8Pl7X0lXfDwjTy5CVLjOWopeB+wwIn2H/u5uAWutL5ZQGNErSOotuS+3/KJxm2
         HEq7VUq+xn+v3TMwS2Ia1R9c82BMdnuDrOEVyob+TxmbLTCiGxD+nu+22w1+uuKkKdaM
         WvlK4QGmmVTPuKnga5ozRbaU9io6nTgTpCN0huDqFzuq7zs+JSx5P3VhoQn9yCwGk6Il
         aPDQ5J4XnoX4//2VpwsftrkWa3QEVflxofnOUfm/seJu95t045zU3BAgvEZgyNaaDhVS
         ENSmmv80jfXr5umA+btihQ/3r9YnNpfT5hjBI+fFkbAmAU4ZGyD7LGLpF4tWZqc2njSd
         qTMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XUi8gowQSgFvmLf+t1J83hXEcoJ+WnDjt01OgciC29U=;
        b=INYdCYKo8T1F+Q38VEhgBLDQ60rv9DOeMJNSbwoyAEoZhOfpo2FrJw/dBqXFDTQ3q2
         MF4lYgzr8+U0VO/t7woK7DNVKqiACLO5eO8Bgh2HFLZKBJZnVKGMZI1oyzNN5K4bEYxQ
         F4HVod7zISXh+pY1I28qu4LSR5akJCfxOjgICGwOv83Y1RlpfWkoi8nXXsDHBXwc4JOo
         UitjEv2K27JGoqZU5pT5ZNuKPQGeFl2/CdM1uTCl9umgaS7PxHDaISMvevsJIjMcylwB
         vTxRx4yOrXjXA8sgPDeXzq29JvzsQAalJO8fixmhpoQ7GAyZ1OolbL9btyslsSQALR3G
         dYMw==
X-Gm-Message-State: AOAM531LJYAml4WV1lFj9zCedvxYy0gjk/ubKQCkhqdV28VHSP8ZIZRm
        7JT6SZ+GcBIRRYQ+P34IaX/IsevYClc=
X-Google-Smtp-Source: ABdhPJzCjQyx1kyRcIfVtb8jBcd3CO9mEL21KOE7dJEIl/Q9nLaMeQGH/ni5iI2JC2COwMZ+mtqgWw==
X-Received: by 2002:aa7:c044:: with SMTP id k4mr2828210edo.47.1615377885116;
        Wed, 10 Mar 2021 04:04:45 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:44 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 04/12] net: enetc: save the mode register address inside struct enetc_cbdr
Date:   Wed, 10 Mar 2021 14:03:43 +0200
Message-Id: <20210310120351.542292-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_clear_cbdr depends on struct enetc_hw because it must disable the
ring through a register write. We'd like to remove that dependency, so
let's do what's already done with the producer and consumer indices,
which is to save the iomem address in a variable kept in struct enetc_cbdr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |  4 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 ++-
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 19 ++++++++++---------
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  2 +-
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 57073c3c679e..b1077a6e2b2b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1078,7 +1078,7 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 	return 0;
 
 err_alloc_cls:
-	enetc_clear_cbdr(&si->hw);
+	enetc_clear_cbdr(&si->cbd_ring);
 	enetc_free_cbdr(&si->cbd_ring);
 
 	return err;
@@ -1088,7 +1088,7 @@ void enetc_free_si_resources(struct enetc_ndev_priv *priv)
 {
 	struct enetc_si *si = priv->si;
 
-	enetc_clear_cbdr(&si->hw);
+	enetc_clear_cbdr(&si->cbd_ring);
 	enetc_free_cbdr(&si->cbd_ring);
 
 	kfree(priv->cls_rules);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 1f2e9bec1b30..9d4dbeef61ac 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -98,6 +98,7 @@ struct enetc_cbdr {
 	void *bd_base; /* points to Rx or Tx BD ring */
 	void __iomem *pir;
 	void __iomem *cir;
+	void __iomem *mr; /* mode register */
 
 	int bd_count; /* # of BDs */
 	int next_to_use;
@@ -314,7 +315,7 @@ void enetc_set_ethtool_ops(struct net_device *ndev);
 int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
 		     struct enetc_cbdr *cbdr);
 void enetc_free_cbdr(struct enetc_cbdr *cbdr);
-void enetc_clear_cbdr(struct enetc_hw *hw);
+void enetc_clear_cbdr(struct enetc_cbdr *cbdr);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 			    char *mac_addr, int si_map);
 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index 4de31b283319..bb20a58e8830 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -24,6 +24,10 @@ int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
 	cbdr->next_to_use = 0;
 	cbdr->dma_dev = dev;
 
+	cbdr->pir = hw->reg + ENETC_SICBDRPIR;
+	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
+	cbdr->mr = hw->reg + ENETC_SICBDRMR;
+
 	/* set CBDR cache attributes */
 	enetc_wr(hw, ENETC_SICAR2,
 		 ENETC_SICAR_RD_COHERENT | ENETC_SICAR_WR_COHERENT);
@@ -32,14 +36,10 @@ int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
 	enetc_wr(hw, ENETC_SICBDRBAR1, upper_32_bits(cbdr->bd_dma_base));
 	enetc_wr(hw, ENETC_SICBDRLENR, ENETC_RTBLENR_LEN(cbdr->bd_count));
 
-	enetc_wr(hw, ENETC_SICBDRPIR, 0);
-	enetc_wr(hw, ENETC_SICBDRCIR, 0);
-
+	enetc_wr_reg(cbdr->pir, cbdr->next_to_clean);
+	enetc_wr_reg(cbdr->cir, cbdr->next_to_use);
 	/* enable ring */
-	enetc_wr(hw, ENETC_SICBDRMR, BIT(31));
-
-	cbdr->pir = hw->reg + ENETC_SICBDRPIR;
-	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
+	enetc_wr_reg(cbdr->mr, BIT(31));
 
 	return 0;
 }
@@ -54,9 +54,10 @@ void enetc_free_cbdr(struct enetc_cbdr *cbdr)
 	cbdr->dma_dev = NULL;
 }
 
-void enetc_clear_cbdr(struct enetc_hw *hw)
+void enetc_clear_cbdr(struct enetc_cbdr *cbdr)
 {
-	enetc_wr(hw, ENETC_SICBDRMR, 0);
+	/* disable ring */
+	enetc_wr_reg(cbdr->mr, 0);
 }
 
 static void enetc_clean_cbdr(struct enetc_cbdr *ring)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 31d229e0912a..f083d49d7772 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1095,7 +1095,7 @@ static void enetc_init_unused_port(struct enetc_si *si)
 	enetc_init_port_rfs_memory(si);
 	enetc_init_port_rss_memory(si);
 
-	enetc_clear_cbdr(hw);
+	enetc_clear_cbdr(&si->cbd_ring);
 	enetc_free_cbdr(&si->cbd_ring);
 }
 
-- 
2.25.1

