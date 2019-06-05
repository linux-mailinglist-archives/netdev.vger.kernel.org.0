Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1720364E1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 21:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFETpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 15:45:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:35209 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfFETpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 15:45:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 12:45:06 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 05 Jun 2019 12:45:06 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Lihong Yang <lihong.yang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/2] i40e: Check and set the PF driver state first in i40e_ndo_set_vf_mac
Date:   Wed,  5 Jun 2019 12:45:16 -0700
Message-Id: <20190605194516.10125-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194516.10125-1-jeffrey.t.kirsher@intel.com>
References: <20190605194516.10125-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lihong Yang <lihong.yang@intel.com>

The PF driver state flag __I40E_VIRTCHNL_OP_PENDING needs to be
checked and set at the beginning of i40e_ndo_set_vf_mac. Otherwise,
if there are error conditions before it, the flag will be cleared
unexpectedly by this function to cause potential race conditions.
Hence move the check to the top of this function.

Signed-off-by: Lihong Yang <lihong.yang@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index f14367834318..09a7fd4d24e8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3943,6 +3943,11 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	int bkt;
 	u8 i;
 
+	if (test_and_set_bit(__I40E_VIRTCHNL_OP_PENDING, pf->state)) {
+		dev_warn(&pf->pdev->dev, "Unable to configure VFs, other operation is pending.\n");
+		return -EAGAIN;
+	}
+
 	/* validate the request */
 	ret = i40e_validate_vf(pf, vf_id);
 	if (ret)
@@ -3967,11 +3972,6 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		goto error_param;
 	}
 
-	if (test_and_set_bit(__I40E_VIRTCHNL_OP_PENDING, pf->state)) {
-		dev_warn(&pf->pdev->dev, "Unable to configure VFs, other operation is pending.\n");
-		return -EAGAIN;
-	}
-
 	if (is_multicast_ether_addr(mac)) {
 		dev_err(&pf->pdev->dev,
 			"Invalid Ethernet address %pM for VF %d\n", mac, vf_id);
-- 
2.21.0

