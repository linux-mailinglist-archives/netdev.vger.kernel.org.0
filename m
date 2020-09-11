Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BAB26767E
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgIKXWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:22:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:17589 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgIKXWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:22:16 -0400
IronPort-SDR: nb5Crpl+j5YKhWmR+Wg6tBGWWzC1iFgbPWe3viEeI3fUrUOB7Omz7vbrf/mEs+0OclujWyd9tw
 Np8gRz1zHbmQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="220426160"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="220426160"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:13 -0700
IronPort-SDR: YIK7YzG4AjJiS0zRJ6RUA5TjScRYeYJUsu/pdoCkI55HuKipibVhFwA9M6DM5m7X6UT9MAHsg2
 TP08+I9/HqQQ==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="505656581"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [RESEND net 1/4] i40e: fix return of uninitialized aq_ret in i40e_set_vsi_promisc
Date:   Fri, 11 Sep 2020 16:22:04 -0700
Message-Id: <20200911232207.3417169-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
References: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c: In function ‘i40e_set_vsi_promisc’:
drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:1176:14: error: ‘aq_ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
  i40e_status aq_ret;

In case the code inside the if statement and the for loop does not get
executed aq_ret will be uninitialized when the variable gets returned at
the end of the function.

Avoid this by changing num_vlans from int to u16, so aq_ret always gets
set. Making this change in additional places as num_vlans should never
be negative.

Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8e133d6545bd..5defcb777e92 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1115,7 +1115,7 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 {
 	struct i40e_mac_filter *f;
-	int num_vlans = 0, bkt;
+	u16 num_vlans = 0, bkt;
 
 	hash_for_each(vsi->mac_filter_hash, bkt, f, hlist) {
 		if (f->vlan >= 0 && f->vlan <= I40E_MAX_VLANID)
@@ -1134,8 +1134,8 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
  *
  * Called to get number of VLANs and VLAN list present in mac_filter_hash.
  **/
-static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, int *num_vlans,
-					   s16 **vlan_list)
+static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, u16 *num_vlans,
+				    s16 **vlan_list)
 {
 	struct i40e_mac_filter *f;
 	int i = 0;
@@ -1169,7 +1169,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, int *num_vlans,
  **/
 static i40e_status
 i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
-		     bool unicast_enable, s16 *vl, int num_vlans)
+		     bool unicast_enable, s16 *vl, u16 num_vlans)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
@@ -1258,7 +1258,7 @@ static i40e_status i40e_config_vf_promiscuous_mode(struct i40e_vf *vf,
 	i40e_status aq_ret = I40E_SUCCESS;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi;
-	int num_vlans;
+	u16 num_vlans;
 	s16 *vl;
 
 	vsi = i40e_find_vsi_from_id(pf, vsi_id);
-- 
2.26.2

