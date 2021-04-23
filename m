Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0BE368991
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbhDWABo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:01:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17391 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDWABn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:01:43 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRDsl4mgRzlZ7c;
        Fri, 23 Apr 2021 07:59:07 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.31.136) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 23 Apr 2021 08:00:56 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <intel-wired-lan@lists.osuosl.org>
Subject: [PATCH V3 net] ice: Re-organizes reqstd/avail {R,T}XQ check/code for efficiency
Date:   Fri, 23 Apr 2021 01:00:18 +0100
Message-ID: <20210423000018.20244-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.31.136]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user has explicitly requested the number of {R,T}XQs, then it is
unnecessary to get the count of already available {R,T}XQs from the
PF avail_{r,t}xqs bitmap. This value will get overridden by user specified
value in any case.

Re-organize this code for improving the flow, readability and efficiency.
This scope of improvement was found during the review of the ICE driver
code.

Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
Cc: intel-wired-lan@lists.osuosl.org
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
Change:
V2->V3
 (*) Addressed some comments from Paul Menzel
     Link: https://lkml.org/lkml/2021/4/21/136
V1->V2
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

