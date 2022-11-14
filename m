Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817D16280EF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiKNNMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237967AbiKNNMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:38 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA6A2BB1D
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431547; x=1699967547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=unS16nVWy3isgLs85nEntpNArvPSZg+8ZBDHAbDTZtc=;
  b=NkCU/8CdQD/DFnNQCnf4mLUMz11a4P5b5Sb8cwnkbiW1wYCva+aPexYC
   NzFJXvcF8UreOmN9vnIOrAKrPgpu5osOAeYXITFUmtnPwpKTDBd4zGQOx
   UMUASHnD3C233uXiu86u0FsGf2cM50JsiJFfC+Kb4+AyIkYDw+DKefi8e
   f5xNWN07cDSnchOETMp9zjfRuwIvY4eBq2QGwUtd7uWPqREu4TnGs7+YT
   ePFVNOGN5jiSQfZxwxifjgqgCcExO+jLrwfWwv4XoYm55vqOK2wxEojXt
   8BPMW3kumB/wmsGE54lR4YryBuWcfcYHdkmOtkYReqRGfqfuui9GcsYTI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313110604"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="313110604"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616306013"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616306013"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:22 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 07/13] ice: sync netdev filters after clearing VSI
Date:   Mon, 14 Nov 2022 13:57:49 +0100
Message-Id: <20221114125755.13659-8-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In driver reload path the netdev isn't removed, but VSI is. Remove
filters on netdev right after removing them on VSI.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index 40e678cfb507..aff7a141c30d 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -208,6 +208,11 @@ static int ice_fltr_remove_eth_list(struct ice_vsi *vsi, struct list_head *list)
 void ice_fltr_remove_all(struct ice_vsi *vsi)
 {
 	ice_remove_vsi_fltr(&vsi->back->hw, vsi->idx);
+	/* sync netdev filters if exist */
+	if (vsi->netdev) {
+		__dev_uc_unsync(vsi->netdev, NULL);
+		__dev_mc_unsync(vsi->netdev, NULL);
+	}
 }
 
 /**
-- 
2.36.1

