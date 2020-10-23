Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C94B296B75
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460818AbgJWIvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:51:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:3681 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460795AbgJWIvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 04:51:33 -0400
IronPort-SDR: hGJGRNE7NdbC0jztt4g4ekXhURPV867uv0//Fxpk9r88nbwNSxhr0GzLsNkeo78YarfwAPyKlz
 rY/KH1uQ7r3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="165055350"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="165055350"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 01:51:28 -0700
IronPort-SDR: K4oZfZCCnO0lV5Rn2qZ7ySCvU6HqdSLW0sPdJrAi4l+j3GDk+sfRQG1GIORXFNbCIC9XxOdcd6
 KJ+YtQwPiQPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="523436281"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2020 01:51:24 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        yilun.xu@intel.com, hao.wu@intel.com
Subject: [RFC PATCH 2/6] fpga: dfl: export network configuration info for DFL based FPGA
Date:   Fri, 23 Oct 2020 16:45:41 +0800
Message-Id: <1603442745-13085-3-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes preparation for supporting DFL Ether Group private
feature driver, which reads bitstream_id.vendor_net_cfg field to
determin the interconnection of network components on FPGA device.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/fpga/dfl-fme-main.c | 10 ++--------
 drivers/fpga/dfl.c          | 21 +++++++++++++++++++++
 drivers/fpga/dfl.h          | 12 ++++++++++++
 include/linux/dfl.h         |  2 ++
 4 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
index 77ea04d..a2b8ba0 100644
--- a/drivers/fpga/dfl-fme-main.c
+++ b/drivers/fpga/dfl-fme-main.c
@@ -46,14 +46,8 @@ static DEVICE_ATTR_RO(ports_num);
 static ssize_t bitstream_id_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
-	void __iomem *base;
-	u64 v;
-
-	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
-
-	v = readq(base + FME_HDR_BITSTREAM_ID);
-
-	return scnprintf(buf, PAGE_SIZE, "0x%llx\n", (unsigned long long)v);
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+			 (unsigned long long)dfl_get_bitstream_id(dev));
 }
 static DEVICE_ATTR_RO(bitstream_id);
 
diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index bc35750..ca3c678 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -537,6 +537,27 @@ void dfl_driver_unregister(struct dfl_driver *dfl_drv)
 }
 EXPORT_SYMBOL(dfl_driver_unregister);
 
+int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev)
+{
+	struct device *fme_dev;
+	u64 v;
+
+	if (!dfl_dev)
+		return -EINVAL;
+
+	if (dfl_dev->type == FME_ID)
+		fme_dev = dfl_dev->dev.parent;
+	else
+		fme_dev = dfl_dev->cdev->fme_dev;
+
+	if (!fme_dev)
+		return -EINVAL;
+
+	v = dfl_get_bitstream_id(fme_dev);
+	return (int)FIELD_GET(FME_BID_VENDOR_NET_CFG, v);
+}
+EXPORT_SYMBOL_GPL(dfl_dev_get_vendor_net_cfg);
+
 #define is_header_feature(feature) ((feature)->id == FEATURE_ID_FIU_HEADER)
 
 /**
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index 2b82c96..6c7a6961 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -104,6 +104,9 @@
 #define FME_CAP_CACHE_SIZE	GENMASK_ULL(43, 32)	/* cache size in KB */
 #define FME_CAP_CACHE_ASSOC	GENMASK_ULL(47, 44)	/* Associativity */
 
+/* FME BITSTREAM_ID Register Bitfield */
+#define FME_BID_VENDOR_NET_CFG	GENMASK_ULL(35, 32)     /* vendor net cfg */
+
 /* FME Port Offset Register Bitfield */
 /* Offset to port device feature header */
 #define FME_PORT_OFST_DFH_OFST	GENMASK_ULL(23, 0)
@@ -397,6 +400,15 @@ static inline bool is_dfl_feature_present(struct device *dev, u16 id)
 	return !!dfl_get_feature_ioaddr_by_id(dev, id);
 }
 
+static inline u64 dfl_get_bitstream_id(struct device *dev)
+{
+	void __iomem *base;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
+
+	return readq(base + FME_HDR_BITSTREAM_ID);
+}
+
 static inline
 struct device *dfl_fpga_pdata_to_parent(struct dfl_feature_platform_data *pdata)
 {
diff --git a/include/linux/dfl.h b/include/linux/dfl.h
index e1b2471..5ee2b1e 100644
--- a/include/linux/dfl.h
+++ b/include/linux/dfl.h
@@ -67,6 +67,8 @@ struct dfl_driver {
 #define to_dfl_dev(d) container_of(d, struct dfl_device, dev)
 #define to_dfl_drv(d) container_of(d, struct dfl_driver, drv)
 
+int dfl_dev_get_vendor_net_cfg(struct dfl_device *dfl_dev);
+
 /*
  * use a macro to avoid include chaining to get THIS_MODULE.
  */
-- 
2.7.4

