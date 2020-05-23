Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FF71DF553
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387741AbgEWGtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387734AbgEWGtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:49:15 -0400
IronPort-SDR: SayvWuRGz2QvO1r7XZRCpno4oEhB/IPsTcn0hgaqO2jEPE8ADA0SLQ5PAOmRI4YFR4s1dRHD4y
 /n0BHU1aGLgw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:51 -0700
IronPort-SDR: RS26UcjmTwKm4E7J0yp8+BeciT7k2bwL2u9tZGzPREfJyxVreGghM+p4JAm03zae/qW/MPUhlz
 6rBfsOgHpFog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966920"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 16/16] ice: cleanup unsigned loops
Date:   Fri, 22 May 2020 23:48:47 -0700
Message-Id: <20200523064847.3972158-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Fix loop variables that are comparing or assigning signed against
unsigned values, mostly by declaring loop counters as unsigned.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c      |  9 +++++----
 drivers/net/ethernet/intel/ice/ice_ethtool.c     | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_main.c        |  4 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  4 ++--
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index c4c12414083a..93cf70d06fe5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -671,7 +671,7 @@ static bool
 ice_dcbnl_find_app(struct ice_dcbx_cfg *cfg,
 		   struct ice_dcb_app_priority_table *app)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < cfg->numapps; i++) {
 		if (app->selector == cfg->app[i].selector &&
@@ -746,7 +746,8 @@ static int ice_dcbnl_delapp(struct net_device *netdev, struct dcb_app *app)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct ice_dcbx_cfg *old_cfg, *new_cfg;
-	int i, j, ret = 0;
+	unsigned int i, j;
+	int ret = 0;
 
 	if (pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED)
 		return -EINVAL;
@@ -869,7 +870,7 @@ void ice_dcbnl_set_all(struct ice_vsi *vsi)
 	struct ice_port_info *pi;
 	struct dcb_app sapp;
 	struct ice_pf *pf;
-	int i;
+	unsigned int i;
 
 	if (!netdev)
 		return;
@@ -941,7 +942,7 @@ ice_dcbnl_flush_apps(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
 		     struct ice_dcbx_cfg *new_cfg)
 {
 	struct ice_vsi *main_vsi = ice_get_main_vsi(pf);
-	int i;
+	unsigned int i;
 
 	if (!main_vsi)
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f39d4eb7fd8b..fd1849155d85 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -205,7 +205,7 @@ ice_get_regs(struct net_device *netdev, struct ethtool_regs *regs, void *p)
 	struct ice_pf *pf = np->vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	u32 *regs_buf = (u32 *)p;
-	int i;
+	unsigned int i;
 
 	regs->version = 1;
 
@@ -308,7 +308,7 @@ ice_get_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
  */
 static bool ice_active_vfs(struct ice_pf *pf)
 {
-	int i;
+	unsigned int i;
 
 	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
@@ -378,7 +378,7 @@ static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
 		0x00000000, 0xFFFFFFFF
 	};
 	u32 val, orig_val;
-	int i;
+	unsigned int i;
 
 	orig_val = rd32(hw, reg);
 	for (i = 0; i < ARRAY_SIZE(patterns); ++i) {
@@ -431,7 +431,7 @@ static u64 ice_reg_test(struct net_device *netdev)
 			GLINT_ITR(2, 1) - GLINT_ITR(2, 0)},
 		{GLINT_CTL, 0xffff0001, 1, 0}
 	};
-	int i;
+	unsigned int i;
 
 	netdev_dbg(netdev, "Register test\n");
 	for (i = 0; i < ARRAY_SIZE(ice_reg_list); ++i) {
@@ -3759,10 +3759,10 @@ ice_get_module_eeprom(struct net_device *netdev,
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	bool is_sfp = false;
+	unsigned int i;
 	u16 offset = 0;
 	u8 value = 0;
 	u8 page = 0;
-	int i;
 
 	status = ice_aq_sff_eeprom(hw, 0, addr, offset, page, 0,
 				   &value, 1, 0, NULL);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6e6df4d690cc..1c255b27244c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -452,7 +452,7 @@ static void
 ice_prepare_for_reset(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
-	int i;
+	unsigned int i;
 
 	/* already prepared for reset */
 	if (test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
@@ -1188,8 +1188,8 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
+	unsigned int i;
 	u32 reg;
-	int i;
 
 	if (!test_and_clear_bit(__ICE_MDD_EVENT_PENDING, pf->state)) {
 		/* Since the VF MDD event logging is rate limited, check if
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 95e8bca562e5..9b09a111321c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -80,7 +80,7 @@ ice_vc_vf_broadcast(struct ice_pf *pf, enum virtchnl_ops v_opcode,
 		    enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
 {
 	struct ice_hw *hw = &pf->hw;
-	int i;
+	unsigned int i;
 
 	ice_for_each_vf(pf, i) {
 		struct ice_vf *vf = &pf->vf[i];
@@ -325,7 +325,7 @@ void ice_free_vfs(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
-	int tmp, i;
+	unsigned int tmp, i;
 
 	if (!pf->vf)
 		return;
-- 
2.26.2

