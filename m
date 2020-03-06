Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF32B17B382
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCFBG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgCFBGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 20:06:53 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EFC22146E;
        Fri,  6 Mar 2020 01:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583456813;
        bh=T6cn0wHytPI/i5tO/aLymuIVcVVaOSY4AMgguxIiZ6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ss6+rX3vSW20OZ+dJk5Jy601slJGsh4cB8F5Jwqec3EJ+RxT9LNNHRZ4lZ9wbYFMN
         sjL/Gh1OS5xLhDggS0VzUabXakN8H5Xv97uoMglIbDdRe9/4nnhtDtu+BHkKX8tygj
         39cfUWrpF0482oyY5S3yizG4DVsAlXJQuuj3VBiA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-um@lists.infradead.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org, edumazet@google.com,
        jasowang@redhat.com, mkubecek@suse.cz, hayeswang@realtek.com,
        doshir@vmware.com, pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/7] vmxnet3: let core reject the unsupported coalescing parameters
Date:   Thu,  5 Mar 2020 17:06:00 -0800
Message-Id: <20200306010602.1620354-6-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306010602.1620354-1-kuba@kernel.org>
References: <20200306010602.1620354-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver correctly rejects all unsupported parameters.
As a side effect of these changes the error code for
unsupported params changes from EINVAL to EOPNOTSUPP.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 1e4b9ba70983..6528940ce5f3 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -780,27 +780,6 @@ vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 	if (!VMXNET3_VERSION_GE_3(adapter))
 		return -EOPNOTSUPP;
 
-	if (ec->rx_coalesce_usecs_irq ||
-	    ec->rx_max_coalesced_frames_irq ||
-	    ec->tx_coalesce_usecs ||
-	    ec->tx_coalesce_usecs_irq ||
-	    ec->tx_max_coalesced_frames_irq ||
-	    ec->stats_block_coalesce_usecs ||
-	    ec->use_adaptive_tx_coalesce ||
-	    ec->pkt_rate_low ||
-	    ec->rx_coalesce_usecs_low ||
-	    ec->rx_max_coalesced_frames_low ||
-	    ec->tx_coalesce_usecs_low ||
-	    ec->tx_max_coalesced_frames_low ||
-	    ec->pkt_rate_high ||
-	    ec->rx_coalesce_usecs_high ||
-	    ec->rx_max_coalesced_frames_high ||
-	    ec->tx_coalesce_usecs_high ||
-	    ec->tx_max_coalesced_frames_high ||
-	    ec->rate_sample_interval) {
-		return -EINVAL;
-	}
-
 	if ((ec->rx_coalesce_usecs == 0) &&
 	    (ec->use_adaptive_rx_coalesce == 0) &&
 	    (ec->tx_max_coalesced_frames == 0) &&
@@ -891,6 +870,9 @@ vmxnet3_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
 }
 
 static const struct ethtool_ops vmxnet3_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.get_drvinfo       = vmxnet3_get_drvinfo,
 	.get_regs_len      = vmxnet3_get_regs_len,
 	.get_regs          = vmxnet3_get_regs,
-- 
2.24.1

