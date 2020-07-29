Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218B0232293
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgG2QYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:42161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgG2QYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:14 -0400
IronPort-SDR: IjwKoH2/CWwoUw3cvGQmzUUh31khv29/CVf4s21prlwp2fuGHZQImqkPGSoX6mtttuUoOLEZpd
 jTTc2MaePr3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982329"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982329"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:14 -0700
IronPort-SDR: GM8kji+txR0ukR9sDUvZq8XYXPzyuLp/l5BnEt3emRHpKE4GJyD1oOEAzxOWrfnRTgDzCJw3GZ
 WYL+8Ax/+oGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087563"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Kiran Patil <kiran.patil@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 05/15] ice: return correct error code from ice_aq_sw_rules
Date:   Wed, 29 Jul 2020 09:23:55 -0700
Message-Id: <20200729162405.1596435-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Patil <kiran.patil@intel.com>

Return ICE_ERR_DOES_NOT_EXIST return code if admin command error code is
ICE_AQ_RC_ENOENT (not exist). ice_aq_sw_rules is used when switch
rule is getting added/deleted/updated. In case of delete/update
switch rule, admin command can return ICE_AQ_RC_ENOENT error code
if such rule does not exist, hence return ICE_ERR_DOES_NOT_EXIST error
code from ice_aq_sw_rule, so that caller of this function can decide
how to handle ICE_ERR_DOES_NOT_EXIST.

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index ccbe1cc64295..c3a6c41385ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -495,6 +495,7 @@ ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
 		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd *cd)
 {
 	struct ice_aq_desc desc;
+	enum ice_status status;
 
 	if (opc != ice_aqc_opc_add_sw_rules &&
 	    opc != ice_aqc_opc_update_sw_rules &&
@@ -506,7 +507,12 @@ ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 	desc.params.sw_rules.num_rules_fltr_entry_index =
 		cpu_to_le16(num_rules);
-	return ice_aq_send_cmd(hw, &desc, rule_list, rule_list_sz, cd);
+	status = ice_aq_send_cmd(hw, &desc, rule_list, rule_list_sz, cd);
+	if (opc != ice_aqc_opc_add_sw_rules &&
+	    hw->adminq.sq_last_status == ICE_AQ_RC_ENOENT)
+		status = ICE_ERR_DOES_NOT_EXIST;
+
+	return status;
 }
 
 /* ice_init_port_info - Initialize port_info with switch configuration data
-- 
2.26.2

