Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC83717EE77
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCJCPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbgCJCPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:20 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9C124677;
        Tue, 10 Mar 2020 02:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806519;
        bh=cJoOQNDhsYa/lr962lA1vHSjvWEC02LRZp4LODa2ZZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9Ho95GNrZhp/sPrjiSKDRl6tmEC+Sxobe+jCTDcyD4+tj+Tf7u3iOzCGbeY1mpcn
         5iaV125BwTzOSKLbyN4aC9GnlmJVE4AdOxKjPWQg9VFnKdk9shLoJK2mRpnF72AGFI
         ebOPW8Cg4REZCaHY4ncynQzJbYSsf8FnZBpGMWWo=
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
Subject: [PATCH net-next 03/15] net: systemport: reject unsupported coalescing params
Date:   Mon,  9 Mar 2020 19:15:00 -0700
Message-Id: <20200310021512.1861626-4-kuba@kernel.org>
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

This driver did not previously reject most of unsupported
parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index a2cf2ed8d278..bea2dbc0e469 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -623,8 +623,7 @@ static int bcm_sysport_set_coalesce(struct net_device *dev,
 		return -EINVAL;
 
 	if ((ec->tx_coalesce_usecs == 0 && ec->tx_max_coalesced_frames == 0) ||
-	    (ec->rx_coalesce_usecs == 0 && ec->rx_max_coalesced_frames == 0) ||
-	    ec->use_adaptive_tx_coalesce)
+	    (ec->rx_coalesce_usecs == 0 && ec->rx_max_coalesced_frames == 0))
 		return -EINVAL;
 
 	for (i = 0; i < dev->num_tx_queues; i++)
@@ -2209,6 +2208,9 @@ static int bcm_sysport_set_rxnfc(struct net_device *dev,
 }
 
 static const struct ethtool_ops bcm_sysport_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_drvinfo		= bcm_sysport_get_drvinfo,
 	.get_msglevel		= bcm_sysport_get_msglvl,
 	.set_msglevel		= bcm_sysport_set_msglvl,
-- 
2.24.1

