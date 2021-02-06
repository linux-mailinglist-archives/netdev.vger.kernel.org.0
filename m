Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9767C311B20
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhBFEt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:49:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:21611 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhBFErA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:47:00 -0500
IronPort-SDR: x0Rl6jp+TW0ykcE3P8LFA94IisWPGjKd7JkxkiYU4+mY1pfoWUhrhD7+051Xi2PsMxYar3xqLR
 km6V1NWx2ozg==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194696"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194696"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:12 -0800
IronPort-SDR: mxU7vjp3C5XEyCaF1VjQd1R0L+qIF/m8rRmlNc2FLGJ0y5aYZH6HSXX8uPM8Seeb7AEMJw67Zn
 EU5r3PF6r1Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751067"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, kernel test robot <lkp@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 09/11] ice: Replace one-element array with flexible-array member
Date:   Fri,  5 Feb 2021 20:40:59 -0800
Message-Id: <20210206044101.636242-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in
struct ice_res_tracker, instead of a one-element array and use the
struct_size() helper to calculate the size for the allocations.

Also, notice that the code below suggests that, currently, two too many
bytes are being allocated with devm_kzalloc(), as the total number of
entries (pf->irq_tracker->num_entries) for pf->irq_tracker->list[] is
_vectors_ and sizeof(*pf->irq_tracker) also includes the size of the
one-element array _list_ in struct ice_res_tracker.

drivers/net/ethernet/intel/ice/ice_main.c:3511:
3511         /* populate SW interrupts pool with number of OS granted IRQs. */
3512         pf->num_avail_sw_msix = (u16)vectors;
3513         pf->irq_tracker->num_entries = (u16)vectors;
3514         pf->irq_tracker->end = pf->irq_tracker->num_entries;

With this change, the right amount of dynamic memory is now allocated
because, contrary to one-element arrays which occupy at least as much
space as a single object of the type, flexible-array members don't
occupy such space in the containing structure.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays

Built-tested-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fa1e128c24ec..fca428c879ec 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -166,7 +166,7 @@ struct ice_tc_cfg {
 struct ice_res_tracker {
 	u16 num_entries;
 	u16 end;
-	u16 list[1];
+	u16 list[];
 };
 
 struct ice_qs_cfg {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 643fbc8d6b6a..f6177591978d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3495,9 +3495,9 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 		return vectors;
 
 	/* set up vector assignment tracking */
-	pf->irq_tracker =
-		devm_kzalloc(ice_pf_to_dev(pf), sizeof(*pf->irq_tracker) +
-			     (sizeof(u16) * vectors), GFP_KERNEL);
+	pf->irq_tracker = devm_kzalloc(ice_pf_to_dev(pf),
+				       struct_size(pf->irq_tracker, list, vectors),
+				       GFP_KERNEL);
 	if (!pf->irq_tracker) {
 		ice_dis_msix(pf);
 		return -ENOMEM;
-- 
2.26.2

