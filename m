Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4765296B72
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460804AbgJWIvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:51:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:3681 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460748AbgJWIvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 04:51:32 -0400
IronPort-SDR: c5CT5yZ2pIQbKok5sZvAIzp05EM3u7J6L3i/RILt/Cd4gsXzqiuLV5LyYr4B4bE0jeMRUB9Qj4
 JQZTekCnA5eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="165055355"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="165055355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 01:51:32 -0700
IronPort-SDR: hDUlTG/KaLUMQTN6xxE8syzzmbKqwBq4XWZTOQAyXbCi07LvZLv/0kQ8k0awOP0/dlWUzuyPHH
 eaB55I3DSEtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="523436304"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2020 01:51:29 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        yilun.xu@intel.com, hao.wu@intel.com
Subject: [RFC PATCH 3/6] fpga: dfl: add an API to get the base device for dfl device
Date:   Fri, 23 Oct 2020 16:45:42 +0800
Message-Id: <1603442745-13085-4-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an API for dfl devices to find which physical device
owns the DFL.

This patch makes preparation for supporting DFL Ether Group private
feature driver. It uses this information to determine which retimer
device physically connects to which ether group.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/fpga/dfl.c  | 9 +++++++++
 include/linux/dfl.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index ca3c678..52d18e6 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -558,6 +558,15 @@ int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev)
 }
 EXPORT_SYMBOL_GPL(dfl_dev_get_vendor_net_cfg);
 
+struct device *dfl_dev_get_base_dev(struct dfl_device *dfl_dev)
+{
+	if (!dfl_dev || !dfl_dev->cdev)
+		return NULL;
+
+	return dfl_dev->cdev->parent;
+}
+EXPORT_SYMBOL_GPL(dfl_dev_get_base_dev);
+
 #define is_header_feature(feature) ((feature)->id == FEATURE_ID_FIU_HEADER)
 
 /**
diff --git a/include/linux/dfl.h b/include/linux/dfl.h
index 5ee2b1e..dd313f2 100644
--- a/include/linux/dfl.h
+++ b/include/linux/dfl.h
@@ -68,6 +68,7 @@ struct dfl_driver {
 #define to_dfl_drv(d) container_of(d, struct dfl_driver, drv)
 
 int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev);
+struct device *dfl_dev_get_base_dev(struct dfl_device *dfl_dev);
 
 /*
  * use a macro to avoid include chaining to get THIS_MODULE.
-- 
2.7.4

