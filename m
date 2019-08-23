Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E9F9B8F9
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfHWXiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:38:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:14902 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfHWXhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354414"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/14] ice: Don't call synchronize_irq() for VF's from the host
Date:   Fri, 23 Aug 2019 16:37:39 -0700
Message-Id: <20190823233750.7997-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we will call synchronize_irq() from the host for VF's. This is
not correct, so don't allow it.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d6279dfe029e..c067ef6be7f4 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2817,6 +2817,10 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 
 	ice_flush(hw);
 
+	/* don't call synchronize_irq() for VF's from the host */
+	if (vsi->type == ICE_VSI_VF)
+		return;
+
 	ice_for_each_q_vector(vsi, i)
 		synchronize_irq(pf->msix_entries[i + base].vector);
 }
-- 
2.21.0

