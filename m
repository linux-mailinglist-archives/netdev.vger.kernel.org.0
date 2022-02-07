Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6584ACDD7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbiBHBGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343831AbiBGX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:59:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B597EC0612A4;
        Mon,  7 Feb 2022 15:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644278376; x=1675814376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=etl+A5AoqaVpogl33TwujZ6kc3H2Nvo93/bcogwNizQ=;
  b=PFysukoKvhrl5uNiVxkRhqe4h8GqkufIZkJt+0IKIebhL208JZDy/uyK
   +4Mq3OiWn+p0Bw83pLU3080lFrj1WAIX2/K9TiRhnqtM9nw4h/354HGOq
   bgrAwx5J4lpM2hJgyuwawJ9X3VxpghQKC08/T4unyTuPfnbVCup6kB/f5
   DS+jvAQrUkuwgMWwvIDh52Ig/+fMc3Rmdz+K3rZm0Py8QhGIW7flzMoQc
   Y6bvuMOuDHmefjEPIKxa+cViCX+5OzV/eJga3GBOUp97YAQp9Yn8DO3xI
   yKwW9fKxVTuljIbd8xujH/MsRxTQPfljX0cZ3bd9ri7IoLr4uTT8BLyEK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248782183"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="248782183"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:59:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="621728150"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2022 15:59:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, jgg@nvidia.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 1/1] ice: add support for DSCP QoS for IDC
Date:   Mon,  7 Feb 2022 15:59:21 -0800
Message-Id: <20220207235921.1303522-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
References: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The ice driver provides QoS information to auxiliary drivers
through the exported function ice_get_qos_params.  This function
doesn't currently support L3 DSCP QoS.

Add the necessary defines, structure elements and code to support
DSCP QoS through the IIDC functions.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c | 5 +++++
 include/linux/net/intel/iidc.h           | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index fc3580167e7b..263a2e7577a2 100644
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
index 1289593411d3..1c1332e4df26 100644
--- a/include/linux/net/intel/iidc.h
+++ b/include/linux/net/intel/iidc.h
@@ -32,6 +32,8 @@ enum iidc_rdma_protocol {
 };
 
 #define IIDC_MAX_USER_PRIORITY		8
+#define IIDC_MAX_DSCP_MAPPING		64
+#define IIDC_DSCP_PFC_MODE		0x1
 
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
2.31.1

