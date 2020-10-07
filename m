Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFAC286B5E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgJGXLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:11:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:53903 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgJGXLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 19:11:06 -0400
IronPort-SDR: vgkYuUZ+oRQ28rbY7nPw1zLjsMpKXl+l7jt12vqsBE13jti1T4qxAjB3ursBtcWICsAlOUDZaf
 6TfQJ/wjFoSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="249880367"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="249880367"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
IronPort-SDR: +Wo74Ikk6dARc7Edl1Aa777ju7Z119hDZPA6NyXhb8V/2ln7ovl5gUJUag/dWnmv9A8pV0RUjo
 UwYNndBaYtiw==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="461557636"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 2/3] i40e: Fix MAC address setting for a VF via Host/VM
Date:   Wed,  7 Oct 2020 16:10:49 -0700
Message-Id: <20201007231050.1438704-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

Fix MAC setting flow for the PF driver.

Without this change the MAC address setting was interpreted
incorrectly in the following use cases:
1) Print incorrect VF MAC or zero MAC
ip link show dev $pf
2) Don't preserve MAC between driver reload
rmmod iavf; modprobe iavf
3) Update VF MAC when macvlan was set
ip link add link $vf address $mac $vf.1 type macvlan
4) Failed to update mac address when VF was trusted
ip link set dev $vf address $mac

This includes all other configurations including above commands.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 26 +++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index c96e2f2d4cba..4919d22d7b6b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2713,6 +2713,10 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 				spin_unlock_bh(&vsi->mac_filter_hash_lock);
 				goto error_param;
 			}
+			if (is_valid_ether_addr(al->list[i].addr) &&
+			    is_zero_ether_addr(vf->default_lan_addr.addr))
+				ether_addr_copy(vf->default_lan_addr.addr,
+						al->list[i].addr);
 		}
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
@@ -2740,6 +2744,7 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 {
 	struct virtchnl_ether_addr_list *al =
 	    (struct virtchnl_ether_addr_list *)msg;
+	bool was_unimac_deleted = false;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
 	i40e_status ret = 0;
@@ -2759,6 +2764,8 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 			ret = I40E_ERR_INVALID_MAC_ADDR;
 			goto error_param;
 		}
+		if (ether_addr_equal(al->list[i].addr, vf->default_lan_addr.addr))
+			was_unimac_deleted = true;
 	}
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
@@ -2779,10 +2786,25 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 		dev_err(&pf->pdev->dev, "Unable to program VF %d MAC filters, error %d\n",
 			vf->vf_id, ret);
 
+	if (vf->trusted && was_unimac_deleted) {
+		struct i40e_mac_filter *f;
+		struct hlist_node *h;
+		u8 *macaddr = NULL;
+		int bkt;
+
+		/* set last unicast mac address as default */
+		spin_lock_bh(&vsi->mac_filter_hash_lock);
+		hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
+			if (is_valid_ether_addr(f->macaddr))
+				macaddr = f->macaddr;
+		}
+		if (macaddr)
+			ether_addr_copy(vf->default_lan_addr.addr, macaddr);
+		spin_unlock_bh(&vsi->mac_filter_hash_lock);
+	}
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
-				       ret);
+	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR, ret);
 }
 
 /**
-- 
2.26.2

