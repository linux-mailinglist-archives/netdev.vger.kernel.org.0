Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE77A38CD23
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238737AbhEUSVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:21:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:33081 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238557AbhEUSVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 14:21:44 -0400
IronPort-SDR: 7X00ne44RXpzOhsDVoHhtUGdoeYGJoHRJWNbsUrW41RNfEwL/fii0rGSnbY+lanVxNXWW6VRZj
 a/9XXMqhhjhg==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262760040"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262760040"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 11:19:58 -0700
IronPort-SDR: xriJKHd43Qb//c7OfLoHX/32BVT4xIb0aY8kKTvP6q6knWMeksx8bj0jFMZpU363WjknUVH7V7
 sWW0cwW/FPXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="545488384"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 21 May 2021 11:19:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, anthony.l.nguyen@intel.com,
        david.m.ertman@intel.com
Subject: [PATCH net-next v1 5/6] i40e: Prep i40e header for aux bus conversion
Date:   Fri, 21 May 2021 11:22:04 -0700
Message-Id: <20210521182205.3823642-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
References: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add the definitions to the i40e client header file in
preparation to convert i40e to use the new auxiliary bus
infrastructure. This header is shared between the 'i40e'
Intel networking driver providing RDMA support and the
'irdma' driver.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/net/intel/i40e_client.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index f41387a8969f..adacbecd888f 100644
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
@@ -100,6 +103,11 @@ struct i40e_info {
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
@@ -187,6 +195,8 @@ static inline bool i40e_client_is_registered(struct i40e_client *client)
 	return test_bit(__I40E_CLIENT_REGISTERED, &client->state);
 }
 
+void i40e_client_device_register(struct i40e_info *ldev, struct i40e_client *client);
+void i40e_client_device_unregister(struct i40e_info *ldev);
 /* used by clients */
 int i40e_register_client(struct i40e_client *client);
 int i40e_unregister_client(struct i40e_client *client);
-- 
2.26.2

