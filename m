Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82FA44B2C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfFMSxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:53:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:64320 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbfFMSxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:53:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 11:53:29 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2019 11:53:29 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/12] i40e: add constraints for accessing veb array
Date:   Thu, 13 Jun 2019 11:53:38 -0700
Message-Id: <20190613185347.16361-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

Add veb array access boundary checks.
Ensure veb array index is smaller than I40E_MAX_VEB.

Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 320562b39686..12ae4d99109b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8570,7 +8570,7 @@ static void i40e_link_event(struct i40e_pf *pf)
 	/* Notify the base of the switch tree connected to
 	 * the link.  Floating VEBs are not notified.
 	 */
-	if (pf->lan_veb != I40E_NO_VEB && pf->veb[pf->lan_veb])
+	if (pf->lan_veb < I40E_MAX_VEB && pf->veb[pf->lan_veb])
 		i40e_veb_link_event(pf->veb[pf->lan_veb], new_link);
 	else
 		i40e_vsi_link_event(vsi, new_link);
@@ -12519,7 +12519,7 @@ int i40e_is_vsi_uplink_mode_veb(struct i40e_vsi *vsi)
 	struct i40e_pf *pf = vsi->back;
 
 	/* Uplink is not a bridge so default to VEB */
-	if (vsi->veb_idx == I40E_NO_VEB)
+	if (vsi->veb_idx >= I40E_MAX_VEB)
 		return 1;
 
 	veb = pf->veb[vsi->veb_idx];
@@ -13577,7 +13577,7 @@ static void i40e_setup_pf_switch_element(struct i40e_pf *pf,
 		/* Main VEB? */
 		if (uplink_seid != pf->mac_seid)
 			break;
-		if (pf->lan_veb == I40E_NO_VEB) {
+		if (pf->lan_veb >= I40E_MAX_VEB) {
 			int v;
 
 			/* find existing or else empty VEB */
@@ -13587,13 +13587,15 @@ static void i40e_setup_pf_switch_element(struct i40e_pf *pf,
 					break;
 				}
 			}
-			if (pf->lan_veb == I40E_NO_VEB) {
+			if (pf->lan_veb >= I40E_MAX_VEB) {
 				v = i40e_veb_mem_alloc(pf);
 				if (v < 0)
 					break;
 				pf->lan_veb = v;
 			}
 		}
+		if (pf->lan_veb >= I40E_MAX_VEB)
+			break;
 
 		pf->veb[pf->lan_veb]->seid = seid;
 		pf->veb[pf->lan_veb]->uplink_seid = pf->mac_seid;
@@ -13747,7 +13749,7 @@ static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit)
 		/* Set up the PF VSI associated with the PF's main VSI
 		 * that is already in the HW switch
 		 */
-		if (pf->lan_veb != I40E_NO_VEB && pf->veb[pf->lan_veb])
+		if (pf->lan_veb < I40E_MAX_VEB && pf->veb[pf->lan_veb])
 			uplink_seid = pf->veb[pf->lan_veb]->seid;
 		else
 			uplink_seid = pf->mac_seid;
-- 
2.21.0

