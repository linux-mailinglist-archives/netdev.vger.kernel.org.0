Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDE9333C26
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhCJME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbhCJMEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:48 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0490CC061762
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:48 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x9so27607869edd.0
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sox2Ii9W50FhUaR8bUHhhLyqmibUnWMc7Ry439DSURE=;
        b=SDC9p8JqmmfrDqbr+eGudgzwqTkCJMgdqNa4jzAdvp8MNScih2frdKBv8wyRE6CdS8
         cT3NICesJLD6MALwqx/lpBYqxwAPYR0z0mAoxcRYMGN5kRLNFrIuIEUq5GOJe3y7teLG
         tvM+jwooa/ORN8Q2E9+zhjt/IOzEzwq+5JcnoO7S2AFLedYeHDV/yGiZeDAWOYrHF3tw
         m6gXpCEu1GAVbRAKPP9FscSxpn4wl5y9R6VXhIAqCOiu9BbgKyaeaiR0X+2IJj4L1C5R
         xsqyM7QaurIpE9Mee4e/rIE1yqSMktxwdUeqhlF4If4Ja+H9WWLMAmARBlCQS7GR5YaR
         PWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sox2Ii9W50FhUaR8bUHhhLyqmibUnWMc7Ry439DSURE=;
        b=J39f8MI4Dag3oWLvRgPzG3fCwAeit6nryFYwI6rT+cM+ESgwTRkVDNnxIT7pRlTpYv
         NeoZAfBoHQOvtWPhEemjKv9+L+/M+/p4onc3TTh1iO1FZznk0ByzW4X3+OyxcrdwdRCv
         zIi+kfevI2Wp4NI6ObKV1WrgjBmZ2pGUFudoozQ/SgxNmb7EXF5ttRM4EDk9QtmGkGrA
         iLmmnUF6dFePPLNl3laGwMRXh+53uvyL3G0CS3F23b1FIQYxlMSAVZMZfKz+tGzqLqJ0
         lLv0XwmXLk9AxawiSMsoGHY3VliXG1gxJ1Wcb2x1SFKR5eNeRDN5zUHwbr8KZ3mjZGBA
         vZ5Q==
X-Gm-Message-State: AOAM533alfdpjWh3mitaD25tpYZMGFeol8D1sHPy+wdLiurXEMZY22Dl
        EGO0tTWzaGQTiW4BskqtVYo=
X-Google-Smtp-Source: ABdhPJzJDbXQGEp7eVN1xXjORdIJ+Nh0ugIsaSRJFZgj1rV/C0Ty9mz0PI9tdQfYdS9eQ+x5Dsrd9w==
X-Received: by 2002:aa7:d841:: with SMTP id f1mr2813198eds.286.1615377886815;
        Wed, 10 Mar 2021 04:04:46 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:46 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 06/12] net: enetc: pass bd_count as an argument to enetc_setup_cbdr
Date:   Wed, 10 Mar 2021 14:03:45 +0200
Message-Id: <20210310120351.542292-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes no sense from an API perspective to first initialize some
portion of struct enetc_cbdr outside enetc_setup_cbdr, then leave that
function to initialize the rest. enetc_setup_cbdr should be able to
perform all initialization given a zero-initialized struct enetc_cbdr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c      | 6 ++----
 drivers/net/ethernet/freescale/enetc/enetc.h      | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c | 5 +++--
 drivers/net/ethernet/freescale/enetc/enetc_pf.c   | 3 +--
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index a32283533408..06fcab53c471 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1054,9 +1054,6 @@ void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 	priv->bdr_int_num = cpus;
 	priv->ic_mode = ENETC_IC_RX_ADAPTIVE | ENETC_IC_TX_MANUAL;
 	priv->tx_ictt = ENETC_TXIC_TIMETHR;
-
-	/* SI specific */
-	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
 }
 
 int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
@@ -1064,7 +1061,8 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 	struct enetc_si *si = priv->si;
 	int err;
 
-	err = enetc_setup_cbdr(priv->dev, &si->hw, &si->cbd_ring);
+	err = enetc_setup_cbdr(priv->dev, &si->hw, ENETC_CBDR_DEFAULT_SIZE,
+			       &si->cbd_ring);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 19772be63a2c..af8b8be114bd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -312,7 +312,7 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 void enetc_set_ethtool_ops(struct net_device *ndev);
 
 /* control buffer descriptor ring (CBDR) */
-int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
+int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw, int bd_count,
 		     struct enetc_cbdr *cbdr);
 void enetc_teardown_cbdr(struct enetc_cbdr *cbdr);
 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index bee453be2240..073e56dcca4e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -3,10 +3,10 @@
 
 #include "enetc.h"
 
-int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
+int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw, int bd_count,
 		     struct enetc_cbdr *cbdr)
 {
-	int size = cbdr->bd_count * sizeof(struct enetc_cbd);
+	int size = bd_count * sizeof(struct enetc_cbd);
 
 	cbdr->bd_base = dma_alloc_coherent(dev, size, &cbdr->bd_dma_base,
 					   GFP_KERNEL);
@@ -23,6 +23,7 @@ int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw,
 	cbdr->next_to_clean = 0;
 	cbdr->next_to_use = 0;
 	cbdr->dma_dev = dev;
+	cbdr->bd_count = bd_count;
 
 	cbdr->pir = hw->reg + ENETC_SICBDRPIR;
 	cbdr->cir = hw->reg + ENETC_SICBDRCIR;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 4dd7199d5007..bf70b8f9943f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1087,8 +1087,7 @@ static void enetc_init_unused_port(struct enetc_si *si)
 	struct enetc_hw *hw = &si->hw;
 	int err;
 
-	si->cbd_ring.bd_count = ENETC_CBDR_DEFAULT_SIZE;
-	err = enetc_setup_cbdr(dev, hw, &si->cbd_ring);
+	err = enetc_setup_cbdr(dev, hw, ENETC_CBDR_DEFAULT_SIZE, &si->cbd_ring);
 	if (err)
 		return;
 
-- 
2.25.1

