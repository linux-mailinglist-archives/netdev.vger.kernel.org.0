Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9D5355FF2
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347397AbhDGAQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:16:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:60808 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245292AbhDGAQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:16:02 -0400
IronPort-SDR: vQZP1sOmftov7UdAgJRLb9cjSfff1/NXUasFAp8PajZ4GH41er6lUSluMBmH7IaMYQ1K4jrqeZ
 nqC8TCqb/AdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="173263118"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="173263118"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:15:53 -0700
IronPort-SDR: yRZocOxsW1hXle6CjPJWG0KCE1J0iEHPYDoF+iAqN6UJ3Y/t9dLK/bwSlpfqFFMgvkTgg/e7Eh
 Nm1GwpxfBygQ==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="396440830"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.32.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:15:52 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v4 resend 06/23] i40e: Prep i40e header for aux bus conversion
Date:   Tue,  6 Apr 2021 19:14:45 -0500
Message-Id: <20210407001502.1890-7-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210407001502.1890-1-shiraz.saleem@intel.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the definitions and private ops to the i40e client
header file in preparation to convert i40e to use
the new auxiliary bus infrastructure. This header
is shared between the 'i40e' Intel networking driver
providing RDMA support and the 'irdma' driver.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 include/linux/net/intel/i40e_client.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index f41387a..f4302f6 100644
--- a/include/linux/net/intel/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -4,6 +4,8 @@
 #ifndef _I40E_CLIENT_H_
 #define _I40E_CLIENT_H_
 
+#include <linux/auxiliary_bus.h>
+
 #define I40E_CLIENT_STR_LENGTH 10
 
 /* Client interface version should be updated anytime there is a change in the
@@ -78,6 +80,7 @@ struct i40e_info {
 	u8 lanmac[6];
 	struct net_device *netdev;
 	struct pci_dev *pcidev;
+	struct auxiliary_device *aux_dev;
 	u8 __iomem *hw_addr;
 	u8 fid;	/* function id, PF id or VF id */
 #define I40E_CLIENT_FTYPE_PF 0
@@ -90,6 +93,7 @@ struct i40e_info {
 	struct i40e_qvlist_info *qvlist_info;
 	struct i40e_params params;
 	struct i40e_ops *ops;
+	struct i40e_client *client;
 
 	u16 msix_count;	 /* number of msix vectors*/
 	/* Array down below will be dynamically allocated based on msix_count */
@@ -100,6 +104,11 @@ struct i40e_info {
 	u32 fw_build;                   /* firmware build number */
 };
 
+struct i40e_auxiliary_device {
+	struct auxiliary_device aux_dev;
+	struct i40e_info *ldev;
+};
+
 #define I40E_CLIENT_RESET_LEVEL_PF   1
 #define I40E_CLIENT_RESET_LEVEL_CORE 2
 #define I40E_CLIENT_VSI_FLAG_TCP_ENABLE  BIT(1)
@@ -125,6 +134,11 @@ struct i40e_ops {
 			       struct i40e_client *client,
 			       bool is_vf, u32 vf_id,
 			       u32 flag, u32 valid_flag);
+
+	int (*client_device_register)(struct i40e_info *ldev);
+
+	void (*client_device_unregister)(struct i40e_info *ldev);
+
 };
 
 struct i40e_client_ops {
-- 
1.8.3.1

