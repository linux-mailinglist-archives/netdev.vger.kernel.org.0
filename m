Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC1B5AF6AB
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiIFVNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIFVNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:13:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA2BB8A60
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662498787; x=1694034787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frFzYomJ1jxfm2mMzirWGrJ3Ri0SsWoP+z5ewEBhTTU=;
  b=YoR8c4QN/KF8I4rbQntCOrIYOxbduyGbm9UerVlltu044Fw9trYS3UtY
   23bKekRtsUfzHg7FnJXnY09r+MZ/kDi0V3O3KMcCuPwl90qEkphZOi4+g
   +TW2ecdYL5XEpknr4cFjmTK9neFabyX475CZ4IQ7/DnkyfQB3Jjb2PJui
   wHCPnY1t0G5gQQYTjiANooUzEmVwbVoeGAwGQ89PFVTtHXd8FxOsGqX+K
   /U6E0kYvqDZYileyyHlqfyXW+aqxQaFswYV+AxDANZ2gorSK9naIFaHe3
   ws9QVwSmF8XAyaujPYmQLYmsHzepWhydn3e3lmKIZvvshNkBQnmozTmzM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="295441849"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="295441849"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:13:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="591421361"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2022 14:13:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/5] ice: Check if reset in progress while waiting for offsets
Date:   Tue,  6 Sep 2022 14:12:59 -0700
Message-Id: <20220906211302.3501186-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
References: <20220906211302.3501186-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Michalik <michal.michalik@intel.com>

Occasionally while waiting to valid offsets from hardware we get reset.
Add check for reset before proceeding to execute scheduled work.

Co-developed-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 5a2fd4d690f3..26020f3f0a43 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1242,6 +1242,9 @@ static void ice_ptp_wait_for_offset_valid(struct kthread_work *work)
 	hw = &pf->hw;
 	dev = ice_pf_to_dev(pf);
 
+	if (ice_is_reset_in_progress(pf->state))
+		return;
+
 	if (ice_ptp_check_offset_valid(port)) {
 		/* Offsets not ready yet, try again later */
 		kthread_queue_delayed_work(pf->ptp.kworker,
-- 
2.35.1

