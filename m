Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2928917EE68
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCJCPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgCJCPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:18 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B3E24673;
        Tue, 10 Mar 2020 02:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806518;
        bh=6wq17jL7F5R2BpngskcvUwbg8cdLgnNKd/Lp7H5blDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lbps7qdjUb0+gJTbt4tRUgG9Up3N1AbZDrc1xYxra4cVkW5wRpef4PjuNrygBE3dP
         dDTeM2dDAMSTP3JMqVKbuYF4XsHLpA8YOZwT2tOJf+o2EM8H1b9dzXqdfsVa6mWNLy
         X3sgg6L5t8qHRQelVNEAsNSCCx5d1/wDjhTVw/50=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/15] net: aquantia: reject all unsupported coalescing params
Date:   Mon,  9 Mar 2020 19:14:59 -0700
Message-Id: <20200310021512.1861626-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310021512.1861626-1-kuba@kernel.org>
References: <20200310021512.1861626-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver only rejected some of the unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c   | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 0bdaa0d785b7..6781256a318a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -386,21 +386,10 @@ static int aq_ethtool_set_coalesce(struct net_device *ndev,
 
 	cfg = aq_nic_get_cfg(aq_nic);
 
-	/* This is not yet supported
-	 */
-	if (coal->use_adaptive_rx_coalesce || coal->use_adaptive_tx_coalesce)
-		return -EOPNOTSUPP;
-
 	/* Atlantic only supports timing based coalescing
 	 */
 	if (coal->rx_max_coalesced_frames > 1 ||
-	    coal->rx_coalesce_usecs_irq ||
-	    coal->rx_max_coalesced_frames_irq)
-		return -EOPNOTSUPP;
-
-	if (coal->tx_max_coalesced_frames > 1 ||
-	    coal->tx_coalesce_usecs_irq ||
-	    coal->tx_max_coalesced_frames_irq)
+	    coal->tx_max_coalesced_frames > 1)
 		return -EOPNOTSUPP;
 
 	/* We do not support frame counting. Check this
@@ -742,6 +731,8 @@ static int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
 }
 
 const struct ethtool_ops aq_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES,
 	.get_link            = aq_ethtool_get_link,
 	.get_regs_len        = aq_ethtool_get_regs_len,
 	.get_regs            = aq_ethtool_get_regs,
-- 
2.24.1

