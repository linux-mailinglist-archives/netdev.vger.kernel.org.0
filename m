Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347261E979B
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgEaMg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:12468 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728134AbgEaMg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:26 -0400
IronPort-SDR: aLXD1LMAKADM+I7Ip9xEOGIoG87x8Ew5CHvFbZ7MNwiugxBn+No1Avr4sbHataF8XzemnKDC5i
 pn/l0MJSE9zw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:24 -0700
IronPort-SDR: EQRPEvH0gaT+EqfmpzsfCy5dy5jX8IxbHOK3I9srcgjQwrtUYWYO0QpN4cSzypKB7psmtMtP34
 sqG5XEyaLOZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345441"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/14] ice: Allow VF to request reset as soon as it's initialized
Date:   Sun, 31 May 2020 05:36:14 -0700
Message-Id: <20200531123619.2887469-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

A VF driver has the ability to request reset via VIRTCHNL_OP_RESET_VF.
This is a required step in VF driver load. Currently, the PF is only
allowing a VF to request reset using this method after the VF has
already communicated resources via VIRTCHNL_OP_GET_VF_RESOURCES.
However, this is incorrect because the VF can request reset before
requesting resources. Fix this by allowing the VF to request a reset
once it has been initialized.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2916cfb9d032..16a2f2526ccc 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2014,7 +2014,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
  */
 static void ice_vc_reset_vf_msg(struct ice_vf *vf)
 {
-	if (test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
+	if (test_bit(ICE_VF_STATE_INIT, vf->vf_states))
 		ice_reset_vf(vf, false);
 }
 
-- 
2.26.2

