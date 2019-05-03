Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873EF135FF
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 01:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfECXKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 19:10:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:40730 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfECXJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 19:09:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 16:09:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,427,1549958400"; 
   d="scan'208";a="136660079"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 03 May 2019 16:09:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 03/11] i40e: remove error msg when vf with port vlan tries to remove vlan 0
Date:   Fri,  3 May 2019 16:09:31 -0700
Message-Id: <20190503230939.6739-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

VF's attempt to delete vlan 0 when a port vlan is configured is harmless
in this case pf driver just does nothing.  If vf will try to remove
other vlans when a port vlan is configured it will still produce error
as before.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 71cd159e7902..24628de8e624 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2766,7 +2766,8 @@ static int i40e_vc_remove_vlan_msg(struct i40e_vf *vf, u8 *msg)
 
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	if (vsi->info.pvid) {
-		aq_ret = I40E_ERR_PARAM;
+		if (vfl->num_elements > 1 || vfl->vlan_id[0])
+			aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
 
-- 
2.20.1

