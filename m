Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFDC34EEB6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhC3RAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:00:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:6378 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232246AbhC3RAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:00:10 -0400
IronPort-SDR: O6s80OI8IuGP05p29mRbqPznGA+3s/hm4WiRb6bkfbOZDK6JULHOhV0GYEaLy95qaCBLVraxpF
 9aJ/bleJOXeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="189569208"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="189569208"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 10:00:10 -0700
IronPort-SDR: 9LNk5POMM8cAwowL9hubFwCgF8JBx8E5SqCFiiK2NpNC81rKR+IPl6ohPPZcIpnYHLSxzwl8zs
 JUDFUdJFx6jA==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="610174690"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.112.111])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 10:00:08 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v3 06/23] i40e: Prep i40e header for aux bus conversion
Date:   Tue, 30 Mar 2021 11:59:05 -0500
Message-Id: <20210330165922.2006-7-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330165922.2006-1-shiraz.saleem@intel.com>
References: <20210330165922.2006-1-shiraz.saleem@intel.com>
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

