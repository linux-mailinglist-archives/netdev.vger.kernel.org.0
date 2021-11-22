Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CBE45966C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239948AbhKVVPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:15:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:19484 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232757AbhKVVPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 16:15:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="215593732"
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="215593732"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 13:12:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,255,1631602800"; 
   d="scan'208";a="570478272"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2021 13:12:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: [PATCH net-next 1/3] devlink: Add 'enable_iwarp' generic device param
Date:   Mon, 22 Nov 2021 13:11:17 -0800
Message-Id: <20211122211119.279885-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add a new device generic parameter to enable and disable
iWARP functionality on a multi-protocol RDMA device.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4878907e9232..b7dfe693a332 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -109,6 +109,9 @@ own name.
      - Boolean
      - When enabled, the device driver will instantiate VDPA networking
        specific auxiliary device of the devlink device.
+   * - ``enable_iwarp``
+     - Boolean
+     - Enable handling of iWARP traffic in the device.
    * - ``internal_err_reset``
      - Boolean
      - When enabled, the device driver will reset the device on internal
diff --git a/include/net/devlink.h b/include/net/devlink.h
index aab3d007c577..e3c88fabd700 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -485,6 +485,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -534,6 +535,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_VNET_NAME "enable_vnet"
 #define DEVLINK_PARAM_GENERIC_ENABLE_VNET_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME "enable_iwarp"
+#define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5ad72dbfcd07..d144a62cbf73 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4432,6 +4432,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_VNET_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_VNET_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.31.1

