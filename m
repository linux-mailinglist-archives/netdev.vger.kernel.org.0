Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA2E4A4F9F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377300AbiAaTne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:43:34 -0500
Received: from mga03.intel.com ([134.134.136.65]:38309 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbiAaTnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 14:43:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643658213; x=1675194213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S63BXheSpHFtx85d/p+Xa7MyM+PygaUaRr6coJ1rhxk=;
  b=PDt6Yu+KppKnRklAedXTdBBN08FikkZOXrRnKLFbcYa8RWMS80u/Qao+
   pUsy1jfFS8Jxm+OgCVP8Ty04ivTI/isrqv3nR56H1tgSMKtuBA53S8bDs
   tJROAskZJc2fLJeqB8+0IoSPUv1/DTC6ANjwPLAdPkh34nhsGtN53hSnj
   tuliyEQvQAh+gwUxCtPauyY6Fihoho3GoLj8gD4krDUfS9BbQHCM6tXy7
   Z+c1c2aU2UovD+csB8QbKWu9JyszYPn5iPS5QBHerT0zEfXBy481zSE1A
   NYl0L9a4qMc+30xdVysqdS0fRukr6HUxvA8PG7nxoPIqfyMxMzeiS4JSi
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247489711"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247489711"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:43:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="537448410"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.255.33.15])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:43:33 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH for-next 1/3] net/ice: add support for DSCP QoS for IIDC
Date:   Mon, 31 Jan 2022 13:43:14 -0600
Message-Id: <20220131194316.1528-2-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220131194316.1528-1-shiraz.saleem@intel.com>
References: <20220131194316.1528-1-shiraz.saleem@intel.com>
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
 include/linux/net/intel/iidc.h           | 5 +++++
 2 files changed, 10 insertions(+)

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
index 1289593..fee9180 100644
--- a/include/linux/net/intel/iidc.h
+++ b/include/linux/net/intel/iidc.h
@@ -32,6 +32,9 @@ enum iidc_rdma_protocol {
 };
 
 #define IIDC_MAX_USER_PRIORITY		8
+#define IIDC_MAX_DSCP_MAPPING          64
+#define IIDC_VLAN_PFC_MODE             0x0
+#define IIDC_DSCP_PFC_MODE             0x1
 
 /* Struct to hold per RDMA Qset info */
 struct iidc_rdma_qset_params {
@@ -60,6 +63,8 @@ struct iidc_qos_params {
 	u8 vport_relative_bw;
 	u8 vport_priority_type;
 	u8 num_tc;
+	u8 pfc_mode;
+	u8 dscp_map[IIDC_MAX_DSCP_MAPPING];
 };
 
 struct iidc_event {
-- 
1.8.3.1

