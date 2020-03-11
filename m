Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11C71824F0
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgCKWdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbgCKWdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:14 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C38B220754;
        Wed, 11 Mar 2020 22:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965994;
        bh=VKi8UoBUI8w1b/UV+pMJ68ce2qfx1EuYk7fHciB2ZbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+J7Gh3YGwLDUH8DKKBuUE3gAHGajIUJ5j0LUeWRVbWkyp5G3Wp7fBL7LvccP+FKs
         jtI7uHw4F3YFYIOrx6p343VDXAod4hkpsWYCMnwDtgD5Ald3O8XQ+83rjsuUAkG+2I
         kkVwIQmRMEgI0gog7QJHHMgYY8WAbOO0FqhY/hFU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/15] net: hns: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:52 -0700
Message-Id: <20200311223302.2171564-6-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311223302.2171564-1-kuba@kernel.org>
References: <20200311223302.2171564-1-kuba@kernel.org>
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
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 5 +++++
 include/linux/ethtool.h                          | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 717fccc2efba..49624acf2473 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -1264,6 +1264,11 @@ static int hns_get_rxnfc(struct net_device *netdev,
 }
 
 static const struct ethtool_ops hns_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE |
+				     ETHTOOL_COALESCE_USECS_LOW_HIGH |
+				     ETHTOOL_COALESCE_MAX_FRAMES_LOW_HIGH,
 	.get_drvinfo = hns_nic_get_drvinfo,
 	.get_link  = hns_nic_get_link,
 	.get_ringparam = hns_get_ringparam,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index acfce915a02b..be355f37337d 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -214,6 +214,11 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_USECS_LOW_HIGH					\
 	(ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_TX_USECS_LOW | \
 	 ETHTOOL_COALESCE_RX_USECS_HIGH | ETHTOOL_COALESCE_TX_USECS_HIGH)
+#define ETHTOOL_COALESCE_MAX_FRAMES_LOW_HIGH	\
+	(ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW |	\
+	 ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW |	\
+	 ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH |	\
+	 ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH)
 #define ETHTOOL_COALESCE_PKT_RATE_RX_USECS				\
 	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX |				\
 	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
-- 
2.24.1

