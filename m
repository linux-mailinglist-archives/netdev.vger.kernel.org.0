Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381A63519DD
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhDAR4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbhDARv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:51:29 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3849BC03114A
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 09:43:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id e7so2653625edu.10
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/76YHoYgZCtB5bLfWXgnw3f01zAtb9JZmKGdBG6u+Eo=;
        b=dWIw00ZO9lvagWWTzj5aby9oZPghy8dzLaugJeKXyoHkKzmjhlzCyZsppiotiVPqlT
         amT+cZqrKl7+zqTHoCJSbGn3raVv6KhBzFlKf4hAvibxM/kwP4iWS+1UYyBvUoE+orla
         5zmsrQZKQ/WGiFuQvPHYjUzFpAzQr/fYvJLMnEVn7esPHF412f4FZ5xR5qTP4fPfL+Jx
         ddYANHCL+Geisj18Ejr4t+zqfNdVtM/E6COOA0/5KuN+svxBFgCkShvKP30CiNYjxLGF
         IkrCGGoqpiLfD9v5Drry5fA6PB9JnaGM0uB6J3G2kj0pEBQuoY6Et8ceaexqkR1GLppz
         hhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/76YHoYgZCtB5bLfWXgnw3f01zAtb9JZmKGdBG6u+Eo=;
        b=XVz/SePbJknc3B3RCNczpMSUZ83z8v3Tpasb6e1xG7CGEe7V+ySTW4p90VD/xANF2C
         uLvnL4M+i4IiPZe7cMdQYN674CH0Jvenl9Z583Kj7T5Xc3hPcTeev6uNmLS0EGo+wA7w
         9T4PFprMAGF8hL1rNS5du1iFokeIVcYdVsjW9rhv/Ne5yePC3f4Ifh7pOQzABzR6biGL
         Bmp/YjlOpFMfDMjR804HmFM/QnO+JxwaqoOZ5k36KoTNQnymDDEFLao+fG4IZKX2kbA3
         a9E4F5pLuzrSo0pxwXW/Gspw8Tj/tmFoT+kngxlK6XagU0NuJbmvNdb3dZtQ1cICppWj
         jN4g==
X-Gm-Message-State: AOAM530yBy/f8WpjiGh/aXzqHWNqpwQkA1ya/H2ZnekBTNh1xtKXmI6R
        tETO2zxsZ0CVFa5w3b4+B9E=
X-Google-Smtp-Source: ABdhPJx0kZaoQ94CUQ0oN7egUu1UEbUqkc68J5ghFTlG2CnPd9Uxk1AXRKiOi16ZeTWEyjxVlio+3Q==
X-Received: by 2002:a05:6402:698:: with SMTP id f24mr10809436edy.262.1617295399986;
        Thu, 01 Apr 2021 09:43:19 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w24sm3821270edt.44.2021.04.01.09.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:43:19 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-eth: export the rx copybreak value as an ethtool tunable
Date:   Thu,  1 Apr 2021 19:39:56 +0300
Message-Id: <20210401163956.766628-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210401163956.766628-1-ciorneiioana@gmail.com>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

It's useful, especially for debugging purposes, to have the Rx copybreak
value changeable at runtime. Export it as an ethtool tunable.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  2 +
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 40 +++++++++++++++++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 200831b41078..e9d606f99377 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -422,11 +422,12 @@ struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 				    const struct dpaa2_fd *fd, void *fd_vaddr)
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
@@ -440,7 +441,7 @@ struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 
 	memcpy(skb->data, fd_vaddr + fd_offset, fd_length);
 
-	dpaa2_eth_recycle_buf(ch->priv, ch, dpaa2_fd_get_addr(fd));
+	dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(fd));
 
 	return skb;
 }
@@ -4332,6 +4333,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
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

