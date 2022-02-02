Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B84A789E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbiBBTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:19:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:29368 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbiBBTTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 14:19:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643829572; x=1675365572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CATSi5fnZHjv1rp2NgVY8jpYvBJtZBFpvusWuYs37ao=;
  b=fJmt5L0LJlATHCjCBJmRr7dBvPghGLCHRtR3lLExUaB57TGWIDZDeACV
   oaYya79yR9wA5jZn4u1/PTjdpqXvCvLv3V+BAet5J0i4quMo3CJx6OcCS
   VFdjYVdOGCPEbSZmDJ8nHPoWf9AnN9jQYh/s3OVUR9EuYxDkXrLqVkVOC
   E5e8pXM4Kq8SADl8IaTz0D8L2yr2Mqg3i3ef1vdRexq5biVfPc5uYxsAi
   esp3fSvWELuaHkG/fopvb7ZKYGfCQ1LzGfTb5SKPC2QCOw5cECHnePNDr
   jHeIVRk+p+zssw5oStydKQXy1zRudwbFcWwjt5OFtXL21KfquF6OVnpcU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="334360868"
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="334360868"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 11:19:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="538413515"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.255.33.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 11:19:30 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v1 for-next 1/3] net/ice: add support for DSCP QoS for IIDC
Date:   Wed,  2 Feb 2022 13:19:19 -0600
Message-Id: <20220202191921.1638-2-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220202191921.1638-1-shiraz.saleem@intel.com>
References: <20220202191921.1638-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The ice driver provides QoS information to auxiliary drivers through
the exported function ice_get_qos_params. This function doesn't
currently support L3 DSCP QoS.

Add the necessary defines, structure elements and code to support DSCP
QoS through the IIDC functions.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c | 5 +++++
 include/linux/net/intel/iidc.h           | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index fc35801..263a2e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -227,6 +227,11 @@ void ice_get_qos_params(struct ice_pf *pf, struct iidc_qos_params *qos)
 
 	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
 		qos->tc_info[i].rel_bw = dcbx_cfg->etscfg.tcbwtable[i];
+
+	qos->pfc_mode = dcbx_cfg->pfc_mode;
+	if (qos->pfc_mode == IIDC_DSCP_PFC_MODE)
+		for (i = 0; i < IIDC_MAX_DSCP_MAPPING; i++)
+			qos->dscp_map[i] = dcbx_cfg->dscp_map[i];
 }
 EXPORT_SYMBOL_GPL(ice_get_qos_params);
 
diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
index 1289593..dc474de 100644
--- a/include/linux/net/intel/iidc.h
+++ b/include/linux/net/intel/iidc.h
@@ -32,6 +32,8 @@ enum iidc_rdma_protocol {
 };
 
 #define IIDC_MAX_USER_PRIORITY		8
+#define IIDC_MAX_DSCP_MAPPING          64
+#define IIDC_DSCP_PFC_MODE             0x1
 
 /* Struct to hold per RDMA Qset info */
 struct iidc_rdma_qset_params {
@@ -60,6 +62,8 @@ struct iidc_qos_params {
 	u8 vport_relative_bw;
 	u8 vport_priority_type;
 	u8 num_tc;
+	u8 pfc_mode;
+	u8 dscp_map[IIDC_MAX_DSCP_MAPPING];
 };
 
 struct iidc_event {
-- 
1.8.3.1

