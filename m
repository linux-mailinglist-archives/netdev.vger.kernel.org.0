Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1684CC7B2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbiCCVPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiCCVP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D186532E5
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342082; x=1677878082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=grW/gRb1Y2zVSRhI1qNQaubTZkb+e2wDx99jkVSNOX8=;
  b=IOygDYfAQzsdGe4rMl882nzZDtxLvjukOHZzioYuvHzw2Fs/AJ5DAWpI
   huL/SgJPWZrKV/7OzkK4dslfFtn5Hnjni4OqKTABgZ5C2rusIURI1DzD+
   Wm7VY+xpr+OGcOGosQ5pHrczeMqt7Bazkjfp5ezL7mRhVwg2Jqt+nygW6
   /sC0UpbXvhb++wymXkGhqKnddLcJaap33HHKewSVKlrdYLRrNX+ymURt4
   QSWPq7rVlbK1KCBrsZMKfdeX5Q5VVJhUaSPBw4kmQuyQ6JBxbmgRW3KYy
   B7OwVXRXfxDgAKaHT4ueB3Q1Tm+Fz1EmosOpqXNbpesX8B/sS6nl3Kkp5
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245723"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245723"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347711"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 06/11] ice: remove checks in ice_vc_send_msg_to_vf
Date:   Thu,  3 Mar 2022 13:14:44 -0800
Message-Id: <20220303211449.899956-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_vc_send_msg_to_vf function is used by the PF to send a response
to a VF. This function has overzealous checks to ensure its not passed a
NULL VF pointer and to ensure that the passed in struct ice_vf has a
valid vf_id sub-member.

These checks have existed since commit 1071a8358a28 ("ice: Implement
virtchnl commands for AVF support") and function as simple sanity
checks.

We are planning to refactor the ice driver to use a hash table along
with appropriate locks in a future refactor. This change will modify how
the ice_validate_vf_id function works. Instead of a simple >= check to
ensure the VF ID is between some range, it will check the hash table to
see if the specified VF ID is actually in the table. This requires that
the function properly lock the table to prevent race conditions.

The checks may seem ok at first glance, but they don't really provide
much benefit.

In order for ice_vc_send_msg_to_vf to have these checks fail, the
callers must either (1) pass NULL as the VF, (2) construct an invalid VF
pointer manually, or (3) be using a VF pointer which becomes invalid
after they obtain it properly using ice_get_vf_by_id.

For (1), a cursory glance over callers of ice_vc_send_msg_to_vf can show
that in most cases the functions already operate assuming their VF
pointer is valid, such as by derferencing vf->pf or other members.

They obtain the VF pointer by accessing the VF array using the VF ID,
which can never produce a NULL value (since its a simple address
operation on the array it will not be NULL.

The sole exception for (1) is that ice_vc_process_vf_msg will forward a
NULL VF pointer to this function as part of its goto error handler
logic. This requires some minor cleanup to simply exit immediately when
an invalid VF ID is detected (Rather than use the same error flow as
the rest of the function).

For (2), it is unexpected for a flow to construct a VF pointer manually
instead of accessing the VF array. Defending against this is likely to
just hide bad programming.

For (3), it is definitely true that VF pointers could become invalid,
for example if a thread is processing a VF message while the VF gets
removed. However, the correct solution is not to add additional checks
like this which do not guarantee to prevent the race. Instead we plan to
solve the root of the problem by preventing the possibility entirely.

This solution will require the change to a hash table with proper
locking and reference counts of the VF structures. When this is done,
ice_validate_vf_id will require locking of the hash table. This will be
problematic because all of the callers of ice_vc_send_msg_to_vf will
already have to take the lock to obtain the VF pointer anyways. With a
mutex, this leads to a double lock that could hang the kernel thread.

Avoid this by removing the checks which don't provide much value, so
that we can safely add the necessary protections properly.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 885de0675d2a..c8f2473684ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2208,13 +2208,7 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 	struct ice_pf *pf;
 	int aq_ret;
 
-	if (!vf)
-		return -EINVAL;
-
 	pf = vf->pf;
-	if (ice_validate_vf_id(pf, vf->vf_id))
-		return -EINVAL;
-
 	dev = ice_pf_to_dev(pf);
 
 	/* single place to detect unsuccessful return values */
@@ -5726,8 +5720,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 
 	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id)) {
-		err = -EINVAL;
-		goto error_handler;
+		dev_err(dev, "Unable to locate VF for message from VF ID %d, opcode %d, len %d\n",
+			vf_id, v_opcode, msglen);
+		return;
 	}
 
 	vf = &pf->vf[vf_id];
-- 
2.31.1

