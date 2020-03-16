Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9086D187431
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbgCPUrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732537AbgCPUrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD01206C0;
        Mon, 16 Mar 2020 20:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391642;
        bh=euIWzGNH9+S/ctmKpMSkTr1QPPfHc+OCzxezSmAGOrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWlQMC6fjfJGA+6YIvXDSm5FVeU/DhHRzEesbtoBrrBqzljV3yEluyncqXWivpk2R
         ojOOefF1JbiqtSIJjWR/6y3Zidq/rVbdpwGospCQlQK0Ddd177kvWipR9q+MRXKBtV
         lzNu4AfiwgNUzMf1h8r5MjI85iriuNTd3i+ScQIA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/9] net: sfc: reject unsupported coalescing params
Date:   Mon, 16 Mar 2020 13:47:04 -0700
Message-Id: <20200316204712.3098382-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.
The check for use_adaptive_tx_coalesce will now be done by
the core.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/sfc/ethtool.c        | 6 +++---
 drivers/net/ethernet/sfc/falcon/ethtool.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 9a637cd67f43..04e88d05e8ff 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -232,9 +232,6 @@ static int efx_ethtool_set_coalesce(struct net_device *net_dev,
 	bool adaptive, rx_may_override_tx;
 	int rc;
 
-	if (coalesce->use_adaptive_tx_coalesce)
-		return -EINVAL;
-
 	efx_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &adaptive);
 
 	if (coalesce->rx_coalesce_usecs != rx_usecs)
@@ -1138,6 +1135,9 @@ static int efx_ethtool_set_fecparam(struct net_device *net_dev,
 }
 
 const struct ethtool_ops efx_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USECS_IRQ |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_drvinfo		= efx_ethtool_get_drvinfo,
 	.get_regs_len		= efx_ethtool_get_regs_len,
 	.get_regs		= efx_ethtool_get_regs,
diff --git a/drivers/net/ethernet/sfc/falcon/ethtool.c b/drivers/net/ethernet/sfc/falcon/ethtool.c
index 08bd6a321918..db90d94e24c9 100644
--- a/drivers/net/ethernet/sfc/falcon/ethtool.c
+++ b/drivers/net/ethernet/sfc/falcon/ethtool.c
@@ -603,9 +603,6 @@ static int ef4_ethtool_set_coalesce(struct net_device *net_dev,
 	bool adaptive, rx_may_override_tx;
 	int rc;
 
-	if (coalesce->use_adaptive_tx_coalesce)
-		return -EINVAL;
-
 	ef4_get_irq_moderation(efx, &tx_usecs, &rx_usecs, &adaptive);
 
 	if (coalesce->rx_coalesce_usecs != rx_usecs)
@@ -1311,6 +1308,9 @@ static int ef4_ethtool_get_module_info(struct net_device *net_dev,
 }
 
 const struct ethtool_ops ef4_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USECS_IRQ |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_drvinfo		= ef4_ethtool_get_drvinfo,
 	.get_regs_len		= ef4_ethtool_get_regs_len,
 	.get_regs		= ef4_ethtool_get_regs,
-- 
2.24.1

