Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908C1380B5D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhENOQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:16:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:41443 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhENOQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:16:23 -0400
IronPort-SDR: xH4Et7AxIyOhFhcVqsnmYzQCzhOmE9/A1xyYDpfj0iHjpi7E6fmCS+pOjSf791XKD+6Vt6K4hp
 sozFvd38zvyQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="198227393"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="198227393"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:10 -0700
IronPort-SDR: LNHqaQEJ1CA0hikKQ9op2at0wD8qiQupqXE9ELeG4iwrJWmzWZIQBQOwA2ngGlfQJUMrrE1bJ9
 R6+WzU8Fh+Cw==
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="542867702"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.97.94])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:09 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v5 05/22] i40e: Prep i40e header for aux bus conversion
Date:   Fri, 14 May 2021 09:11:57 -0500
Message-Id: <20210514141214.2120-6-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210514141214.2120-1-shiraz.saleem@intel.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the definitions to the i40e client header file in
preparation to convert i40e to use the new auxiliary bus
infrastructure. This header is shared between the 'i40e'
Intel networking driver providing RDMA support and the
'irdma' driver.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 include/linux/net/intel/i40e_client.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index f41387a..c1c15ab6a 100644
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
@@ -187,6 +196,8 @@ static inline bool i40e_client_is_registered(struct i40e_client *client)
 	return test_bit(__I40E_CLIENT_REGISTERED, &client->state);
 }
 
+int i40e_client_device_register(struct i40e_info *ldev);
+void i40e_client_device_unregister(struct i40e_info *ldev);
 /* used by clients */
 int i40e_register_client(struct i40e_client *client);
 int i40e_unregister_client(struct i40e_client *client);
-- 
1.8.3.1

