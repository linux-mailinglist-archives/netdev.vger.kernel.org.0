Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE7263A04
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbgIJCRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:17:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:25575 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730553AbgIJCO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:14:59 -0400
IronPort-SDR: ew0IfTQKCOMzVC76Czq+t3HMl9W3jGtcz3nKDgM7W8TQ3XV2hqQJBc8KW68lWnRtQpXGUuLFLz
 mN3Qq7lGc8Pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="157721714"
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="157721714"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:22 -0700
IronPort-SDR: qWbUNeJ5wR8Lb0SiPyhxkohsHklI7F84SOTjVKSt/7D5FqS9diqPVhdLGdKpVmOtlE4UOy5cUb
 S1c7ru0UfB2A==
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="341733830"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 1/4] i40e: fix return of uninitialized aq_ret in i40e_set_vsi_promisc
Date:   Wed,  9 Sep 2020 17:04:08 -0700
Message-Id: <20200910000411.2658780-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
References: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
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

