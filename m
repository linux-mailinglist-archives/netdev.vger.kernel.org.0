Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8BD301130
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbhAVXwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:52:51 -0500
Received: from mga05.intel.com ([192.55.52.43]:55261 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbhAVXvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:51:14 -0500
IronPort-SDR: jg4hrYYgHQytb6RlX5l7EG0VXKD4VzJzx/0d1QIjs0z3Vb4POqLW0VS4nkS6hNoM/kYN7UoToi
 Rf9Kf5aik+iw==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="264346866"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="264346866"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:10 -0800
IronPort-SDR: 3mM751FnDYpXM1ZaaG1bX5tdTsiGuw49VBC1f8Yq6NlyrJlJ1ErusgmzT4ZYDBgOp121PvzOlp
 18T5eQULFE4A==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="574869429"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.251.4.95])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:09 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH 05/22] i40e: Prep i40e header for aux bus conversion
Date:   Fri, 22 Jan 2021 17:48:10 -0600
Message-Id: <20210122234827.1353-6-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
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

