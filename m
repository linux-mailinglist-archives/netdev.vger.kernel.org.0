Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB79D3082AF
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhA2Atp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:49:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:27157 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhA2Ar6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:47:58 -0500
IronPort-SDR: MNYgh+q8K+Ov7NuhCaZT2fVtXHTM3/i5x95zbAvi0d/5xIRLTfnaPjCB50K3vpxTlvWM7nvjB4
 kzhUgQgMh8yQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438973"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438973"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:52 -0800
IronPort-SDR: 1R5UcZ0YainoeJqCo5fNWWdXtLpg/34qC9d+6CzVgqdZHJp5jRM85to8Pu3YaHkjIKS3z98LLK
 vmoo8hn610og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778718"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, kernel test robot <lkp@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 13/15] ice: Replace one-element array with flexible-array member
Date:   Thu, 28 Jan 2021 16:43:30 -0800
Message-Id: <20210129004332.3004826-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
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
index 56725356a17b..45bbae68b014 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -164,7 +164,7 @@ struct ice_tc_cfg {
 struct ice_res_tracker {
 	u16 num_entries;
 	u16 end;
-	u16 list[1];
+	u16 list[];
 };
 
 struct ice_qs_cfg {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5219aa70b530..ff6190bffff6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3499,9 +3499,9 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
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

