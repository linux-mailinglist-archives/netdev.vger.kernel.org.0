Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7717EE6E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCJCPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbgCJCP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:27 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB7624654;
        Tue, 10 Mar 2020 02:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806527;
        bh=6bRE9PkgYVxymzD8kC9xhQkhNEMxK8hdIufntyLFnTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvU3OyaThMhb1tgSm+TSKmGi4o7QcpigUqitrnIRNO6Lv854xGJE80ua4wIZAh9tu
         LzBR1w3zd7EXQKRwQ3GDTvFgOXSRoP07VwT0nhJ6bkdaWvuTNTJallW1XxF5AbAwy/
         S/RncS0+SuzK7BXel08ONZu910sG6wY/+6D8maHU=
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
Subject: [PATCH net-next 09/15] net: liquidio: reject unsupported coalescing params
Date:   Mon,  9 Mar 2020 19:15:06 -0700
Message-Id: <20200310021512.1861626-10-kuba@kernel.org>
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

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c | 11 +++++++++++
 include/linux/ethtool.h                            |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
index 2b27e3aad9db..16eebfc52109 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_ethtool.c
@@ -3097,7 +3097,17 @@ static int lio_set_fecparam(struct net_device *netdev,
 	return 0;
 }
 
+#define LIO_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_RX_USECS |		\
+				 ETHTOOL_COALESCE_MAX_FRAMES |		\
+				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
+				 ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW |	\
+				 ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW |	\
+				 ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH |	\
+				 ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH |	\
+				 ETHTOOL_COALESCE_PKT_RATE_RX_USECS)
+
 static const struct ethtool_ops lio_ethtool_ops = {
+	.supported_coalesce_params = LIO_ETHTOOL_COALESCE,
 	.get_link_ksettings	= lio_get_link_ksettings,
 	.set_link_ksettings	= lio_set_link_ksettings,
 	.get_fecparam		= lio_get_fecparam,
@@ -3128,6 +3138,7 @@ static const struct ethtool_ops lio_ethtool_ops = {
 };
 
 static const struct ethtool_ops lio_vf_ethtool_ops = {
+	.supported_coalesce_params = LIO_ETHTOOL_COALESCE,
 	.get_link_ksettings	= lio_get_link_ksettings,
 	.get_link		= ethtool_op_get_link,
 	.get_drvinfo		= lio_get_vf_drvinfo,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e464c946bca4..9efeebde3514 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -211,6 +211,11 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ)
 #define ETHTOOL_COALESCE_USE_ADAPTIVE					\
 	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX | ETHTOOL_COALESCE_USE_ADAPTIVE_TX)
+#define ETHTOOL_COALESCE_PKT_RATE_RX_USECS				\
+	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX |				\
+	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
+	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
+	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 
 /**
  * struct ethtool_ops - optional netdev operations
-- 
2.24.1

