Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33613502A0
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbhCaOrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:47:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56188 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbhCaOqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:46:34 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lRc72-0001aa-G4; Wed, 31 Mar 2021 14:46:28 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chinh T Cao <chinh.t.cao@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ice: Fix potential infinite loop when using u8 loop counter
Date:   Wed, 31 Mar 2021 15:46:28 +0100
Message-Id: <20210331144628.1423252-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A for-loop is using a u8 loop counter that is being compared to
a u32 cmp_dcbcfg->numapp to check for the end of the loop. If
cmp_dcbcfg->numapp is larger than 255 then the counter j will wrap
around to zero and hence an infinite loop occurs. Fix this by making
counter j the same type as cmp_dcbcfg->numapp.

Addresses-Coverity: ("Infinite loop")
Fixes: aeac8ce864d9 ("ice: Recognize 860 as iSCSI port in CEE mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 43c6af42de8a..ee4f320d4823 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -747,8 +747,8 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 		   struct ice_port_info *pi)
 {
 	u32 status, tlv_status = le32_to_cpu(cee_cfg->tlv_status);
-	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift;
-	u8 i, j, err, sync, oper, app_index, ice_app_sel_type;
+	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift, j;
+	u8 i, err, sync, oper, app_index, ice_app_sel_type;
 	u16 app_prio = le16_to_cpu(cee_cfg->oper_app_prio);
 	u16 ice_aqc_cee_app_mask, ice_aqc_cee_app_shift;
 	struct ice_dcbx_cfg *cmp_dcbcfg, *dcbcfg;
-- 
2.30.2

