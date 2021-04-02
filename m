Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8511535292D
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 11:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhDBJ5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 05:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbhDBJ5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 05:57:18 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43ABFC06178A
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 02:57:16 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j25so3319981pfe.2
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R025QGe++ldrNnNDz/NuwITmuuEJjJwstiIZlcwZwPI=;
        b=nsxxLtXW6FAF3rO4o1w2iRtqoTStyGzxzw/axa1SySrMUwhWJwPlrf13qfCsh7MHyW
         lJ9aNl490D7j4AG+SA23Wa1HwNxDLiaqnRrj22j2hD0xkXvt4R91XqtUJVNinSsa3Cnc
         l/wvAhxYkUv8BJRYMCLMg9RRoRTLet1uyHEv2cbw5BYcJ+ayPQTRXjS/W3sbXz1ES2hv
         iNkiaGHwboZ6j203v0A4TdJwC2btBRJuUF8bVK3IFoT3CXpWnAndpyIfM29SzhkKUDWP
         8qxO7LpcolfWUEBBomRW2bzUcrcCFvQfETCV4YITEkvA6Cj85mHVTx8bvWepseM3FV1r
         ESMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R025QGe++ldrNnNDz/NuwITmuuEJjJwstiIZlcwZwPI=;
        b=Xq8U+CnFVke0TjFBgI51KbpreVZD5ZIS3lbujpPebXFUM0sfztKBTojmrMhCcBJLBH
         a8Gf65henZei8wR7a9cMkLxRpau4ygzKhOTo1t0aDEVwQkzH9DWIDlyjVOdPryjPHyjq
         3Zwa9VFqoKFLY6PWeTO2G9eg+J2wigWN6J+0dg/ZRW1iqqahjxbsbQ4SwjHWu5sb+p94
         OEg0NucXIM5QsTa4nkGR8WbHdT9lZ0hO61KP5kvtvIpT7U9h8h1SlU7hSCTI+VOrozU6
         uj3Pa33kLDrFBwpawoi9Wh14fnYissBzdQC7FMDwtCmECEAiQc4KY7lcjTm34dA0CWx5
         y7qw==
X-Gm-Message-State: AOAM531Rhq/7hdjyMySX2uzpjcm8yINDsqkUd0jZmFfzYRaQMdVlnNq5
        JmHQ60vfWL/ZhKB0JZOqh07uuKmhmSqzmQ==
X-Google-Smtp-Source: ABdhPJyphBvLInxlubuO78dmDpEe9TRBpna5kJUalU4rFa5Ksx/gUfTSOiaXFL4N0exIM7eAKPbXlw==
X-Received: by 2002:a65:4243:: with SMTP id d3mr11586191pgq.180.1617357435763;
        Fri, 02 Apr 2021 02:57:15 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id d13sm8009505pgb.6.2021.04.02.02.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:57:15 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 3/3] dpaa2-eth: export the rx copybreak value as an ethtool tunable
Date:   Fri,  2 Apr 2021 12:55:32 +0300
Message-Id: <20210402095532.925929-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210402095532.925929-1-ciorneiioana@gmail.com>
References: <20210402095532.925929-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

It's useful, especially for debugging purposes, to have the Rx copybreak
value changeable at runtime. Export it as an ethtool tunable.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  2 +
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 40 +++++++++++++++++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 535b9079943c..e0c3c58e2ac7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -423,11 +423,12 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 					   void *fd_vaddr)
 {
 	u16 fd_offset = dpaa2_fd_get_offset(fd);
+	struct dpaa2_eth_priv *priv = ch->priv;
 	u32 fd_length = dpaa2_fd_get_len(fd);
 	struct sk_buff *skb = NULL;
 	unsigned int skb_len;
 
-	if (fd_length > DPAA2_ETH_DEFAULT_COPYBREAK)
+	if (fd_length > priv->rx_copybreak)
 		return NULL;
 
 	skb_len = fd_length + dpaa2_eth_needed_headroom(NULL);
@@ -441,7 +442,7 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 
 	memcpy(skb->data, fd_vaddr + fd_offset, fd_length);
 
-	dpaa2_eth_recycle_buf(ch->priv, ch, dpaa2_fd_get_addr(fd));
+	dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(fd));
 
 	return skb;
 }
@@ -4333,6 +4334,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	skb_queue_head_init(&priv->tx_skbs);
 
+	priv->rx_copybreak = DPAA2_ETH_DEFAULT_COPYBREAK;
+
 	/* Obtain a MC portal */
 	err = fsl_mc_portal_allocate(dpni_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
 				     &priv->mc_io);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index f8d2b4769983..cdb623d5f2c1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -571,6 +571,8 @@ struct dpaa2_eth_priv {
 	struct devlink *devlink;
 	struct dpaa2_eth_trap_data *trap_data;
 	struct devlink_port devlink_port;
+
+	u32 rx_copybreak;
 };
 
 struct dpaa2_eth_devlink_priv {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index bf59708b869e..ad5e374eeccf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -782,6 +782,44 @@ static int dpaa2_eth_get_ts_info(struct net_device *dev,
 	return 0;
 }
 
+static int dpaa2_eth_get_tunable(struct net_device *net_dev,
+				 const struct ethtool_tunable *tuna,
+				 void *data)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err = 0;
+
+	switch (tuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)data = priv->rx_copybreak;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int dpaa2_eth_set_tunable(struct net_device *net_dev,
+				 const struct ethtool_tunable *tuna,
+				 const void *data)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err = 0;
+
+	switch (tuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		priv->rx_copybreak = *(u32 *)data;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
 const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
 	.nway_reset = dpaa2_eth_nway_reset,
@@ -796,4 +834,6 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_rxnfc = dpaa2_eth_get_rxnfc,
 	.set_rxnfc = dpaa2_eth_set_rxnfc,
 	.get_ts_info = dpaa2_eth_get_ts_info,
+	.get_tunable = dpaa2_eth_get_tunable,
+	.set_tunable = dpaa2_eth_set_tunable,
 };
-- 
2.30.0

