Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAC635E930
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348661AbhDMWpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:45:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16583 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348641AbhDMWpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:45:32 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FKgbx4fTMz18JCT;
        Wed, 14 Apr 2021 06:42:53 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.70.201) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 06:45:03 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <henry.w.tieman@intel.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <linuxarm@openeuler.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH V2 net] ice: Re-organizes reqstd/avail {R,T}XQ check/code for efficiency+readability
Date:   Tue, 13 Apr 2021 23:44:46 +0100
Message-ID: <20210413224446.16612-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.70.201]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user has explicitly requested the number of {R,T}XQs, then it is
unnecessary to get the count of already available {R,T}XQs from the
PF avail_{r,t}xqs bitmap. This value will get overridden by user specified
value in any case.

This patch does minor re-organization of the code for improving the flow
and readabiltiy. This scope of improvement was found during the review of
the ICE driver code.

FYI, I could not test this change due to unavailability of the hardware.
It would be helpful if somebody can test this patch and provide Tested-by
Tag. Many thanks!

Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
Cc: intel-wired-lan@lists.osuosl.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
--
Change V1->V2
 (*) Fixed the comments from Anthony Nguyen(Intel)
     Link: https://lkml.org/lkml/2021/4/12/1997
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d13c7fc8fb0a..d77133d6baa7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -161,12 +161,13 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-		vsi->alloc_txq = min3(pf->num_lan_msix,
-				      ice_get_avail_txq_count(pf),
-				      (u16)num_online_cpus());
 		if (vsi->req_txq) {
 			vsi->alloc_txq = vsi->req_txq;
 			vsi->num_txq = vsi->req_txq;
+		} else {
+			vsi->alloc_txq = min3(pf->num_lan_msix,
+					      ice_get_avail_txq_count(pf),
+					      (u16)num_online_cpus());
 		}
 
 		pf->num_lan_tx = vsi->alloc_txq;
@@ -175,12 +176,13 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
 			vsi->alloc_rxq = 1;
 		} else {
-			vsi->alloc_rxq = min3(pf->num_lan_msix,
-					      ice_get_avail_rxq_count(pf),
-					      (u16)num_online_cpus());
 			if (vsi->req_rxq) {
 				vsi->alloc_rxq = vsi->req_rxq;
 				vsi->num_rxq = vsi->req_rxq;
+			} else {
+				vsi->alloc_rxq = min3(pf->num_lan_msix,
+						      ice_get_avail_rxq_count(pf),
+						      (u16)num_online_cpus());
 			}
 		}
 
-- 
2.17.1

