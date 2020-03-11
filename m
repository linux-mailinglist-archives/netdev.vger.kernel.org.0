Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4395F1824FC
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbgCKWde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731364AbgCKWdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:15 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9976720749;
        Wed, 11 Mar 2020 22:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965995;
        bh=g2SriYnAS21u7zm1RLNEUQ0AkgFJvyOpK+X54vIlHdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3snNr6C79WCRppA9bF+NhLhpoP1jvG0vBk84ootO8anuAj3XMK2103Agd2dISZWY
         xAPRhtgc6s+BgYKNfxTz4niSrG8mB45xoDONssz52nUkRAHFcxNAMrDqsy8NeEF92h
         yrXDQPIAfGOHF1/BOOxu86Xk8qRNyd8ZV62dKDt0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/15] net: hns3: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:53 -0700
Message-Id: <20200311223302.2171564-7-kuba@kernel.org>
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
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 3f59a1924390..28b81f24afa1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1390,7 +1390,13 @@ static int hns3_set_fecparam(struct net_device *netdev,
 	return ops->set_fec(handle, fec_mode);
 }
 
+#define HNS3_ETHTOOL_COALESCE	(ETHTOOL_COALESCE_USECS |		\
+				 ETHTOOL_COALESCE_USE_ADAPTIVE |	\
+				 ETHTOOL_COALESCE_RX_USECS_HIGH |	\
+				 ETHTOOL_COALESCE_TX_USECS_HIGH)
+
 static const struct ethtool_ops hns3vf_ethtool_ops = {
+	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.get_drvinfo = hns3_get_drvinfo,
 	.get_ringparam = hns3_get_ringparam,
 	.set_ringparam = hns3_set_ringparam,
@@ -1416,6 +1422,7 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 };
 
 static const struct ethtool_ops hns3_ethtool_ops = {
+	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.self_test = hns3_self_test,
 	.get_drvinfo = hns3_get_drvinfo,
 	.get_link = hns3_get_link,
-- 
2.24.1

