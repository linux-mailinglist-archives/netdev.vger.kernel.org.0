Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BA6320059
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 22:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBSVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 16:36:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:25147 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhBSVgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 16:36:05 -0500
IronPort-SDR: mVsEZXXnAqQeBODupUYmjothA5o9CjL6SVFp5U78kAfktzQAsZuzPLc2+feZZ1zQQxcg+PXkvg
 CFMCZBr4ktyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="248034130"
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="248034130"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 13:35:06 -0800
IronPort-SDR: 0OU0NCt8TfA9oD+weCea9GNJhTAEwvAmw+kJpIaUYWZSx20tVLJ45QBOHxJEQ4XARI+RTpmv4+
 CJphoNDNPlPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="428012024"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2021 13:35:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        =?UTF-8?q?Andrzej=20Sawu=C5=82a?= <andrzej.sawula@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 3/8] i40e: Add zero-initialization of AQ command structures
Date:   Fri, 19 Feb 2021 13:36:01 -0800
Message-Id: <20210219213606.2567536-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
References: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Zero-initialize AQ command data structures to comply with
API specifications.

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Fixes: f4492db16df8 ("i40e: Add NPAR BW get and set functions")
Signed-off-by: Andrzej Sawuła <andrzej.sawula@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 84916261f5df..90c6c991aebc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7667,6 +7667,8 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 	if (filter->flags >= ARRAY_SIZE(flag_table))
 		return I40E_ERR_CONFIG;
 
+	memset(&cld_filter, 0, sizeof(cld_filter));
+
 	/* copy element needed to add cloud filter from filter */
 	i40e_set_cld_element(filter, &cld_filter);
 
@@ -7734,6 +7736,8 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 	    !ipv6_addr_any(&filter->ip.v6.src_ip6))
 		return -EOPNOTSUPP;
 
+	memset(&cld_filter, 0, sizeof(cld_filter));
+
 	/* copy element needed to add cloud filter from filter */
 	i40e_set_cld_element(filter, &cld_filter.element);
 
@@ -11709,6 +11713,8 @@ i40e_status i40e_set_partition_bw_setting(struct i40e_pf *pf)
 	struct i40e_aqc_configure_partition_bw_data bw_data;
 	i40e_status status;
 
+	memset(&bw_data, 0, sizeof(bw_data));
+
 	/* Set the valid bit for this PF */
 	bw_data.pf_valid_bits = cpu_to_le16(BIT(pf->hw.pf_id));
 	bw_data.max_bw[pf->hw.pf_id] = pf->max_bw & I40E_ALT_BW_VALUE_MASK;
-- 
2.26.2

