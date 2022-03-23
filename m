Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733774E5268
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243121AbiCWMrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbiCWMrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:47:16 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2F97C151;
        Wed, 23 Mar 2022 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648039547; x=1679575547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GyXNqf4GNLod3cqKTITvf8LiaDU11jwMImeBJOPCznE=;
  b=Qqk8B2ELOoesTpK/imtY5oZPB0ysAIDMbDdhAfhbTEwvD8TTVAecK3JH
   qUx1Q/iOqNP2RSlezeqyFvrheKIJzPzYuXudMe0dnIia2iNB2wnW2yLvg
   6EYat3pwH2MXHEbxAst7Eox9W6gWAi5Zdm2vABlg36JQfkEeEb+an+3mM
   tLJZhUH/KoRYSSSYf4H75vRPjHyyTxP0a18RNozNp16FUO1Hzw4PtRkuQ
   MXl0hx2OuK/At2YqkdqCk/IWDYWi+gvmpWK4GLjPpl7C3M2riWSrTSQs7
   AFXum0f3WKTVYiwvgVM8+BU4qc91ygikbdTjyPJo5JMxEIsgsX9JxqdYd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="318809750"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="318809750"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 05:45:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="785776616"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 23 Mar 2022 05:45:44 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22NCjeuE017350;
        Wed, 23 Mar 2022 12:45:42 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net 2/2] ice: don't allow to run ice_send_event_to_aux() in atomic ctx
Date:   Wed, 23 Mar 2022 13:43:53 +0100
Message-Id: <20220323124353.2762181-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
References: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_send_event_to_aux() eventually descends to mutex_lock()
(-> might_sched()), so it must not be called under non-task
context. However, at least two fixes have happened already for the
bug splats occurred due to this function being called from atomic
context.
To make the emergency landings softer, bail out early when executed
in non-task context emitting a warn splat only once. This way we
trade some events being potentially lost for system stability and
avoid any related hangs and crashes.

Fixes: 348048e724a0e ("ice: Implement iidc operations")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_idc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index fc3580167e7b..5559230eff8b 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -34,6 +34,9 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 {
 	struct iidc_auxiliary_drv *iadrv;
 
+	if (WARN_ON_ONCE(!in_task()))
+		return;
+
 	if (!pf->adev)
 		return;
 
-- 
2.35.1

