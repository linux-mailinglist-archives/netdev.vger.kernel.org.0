Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDF6EA04F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjDTXyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTXxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3885859D7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034822; x=1713570822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88YG4bHmgSL0YxNdZ1E3zZNiCuV1ncTXF4C/UKZlfW8=;
  b=FkSzaP+OaQETPCIRnCrFv9UUJlaov/Qp/B5H6asDV7P5yPUmxKP7ppHj
   2hd7OpfVOuNpb0njFotSoxVTbNDfQ0jPUcXl/llNLX+CPbG3PsLTllHjp
   ZTbklPtjm8sQrxT5XbTla/kCTTcQexcYk2GOzsOkOAAF9kg71iP19pmQL
   Z60Hr9/XEDye5ooRxrT0EsRxNHMqnsI/RaoujlgJLp4XmULwUME6y3ub0
   N6Zm9RLDKcyvSypZkyJMAugzDmBKIyC0xjisLG89MjHnkqO8eG3QJYYF7
   NU9t/py4sfgqNW4jRSeRJpvl5C4LKq930yHn6Ip51tSVuMv9m7RhWrw7F
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368453"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368453"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714251"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714251"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Schmidt <mschmidt@redhat.com>, anthony.l.nguyen@intel.com,
        johan@kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 5/6] ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
Date:   Thu, 20 Apr 2023 16:50:32 -0700
Message-Id: <20230420235033.2971567-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
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

From: Michal Schmidt <mschmidt@redhat.com>

The 'buf_cpy'-related code in ice_sq_send_cmd_retry() looks broken.
'buf' is nowhere copied into 'buf_cpy'.

The reason this does not cause problems is that all commands for which
'is_cmd_for_retry' is true go with a NULL buf.

Let's remove 'buf_cpy'. Add a WARN_ON in case the assumption no longer
holds in the future.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3638598d732b..c6200564304e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1619,7 +1619,6 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 {
 	struct ice_aq_desc desc_cpy;
 	bool is_cmd_for_retry;
-	u8 *buf_cpy = NULL;
 	u8 idx = 0;
 	u16 opcode;
 	int status;
@@ -1629,11 +1628,8 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	memset(&desc_cpy, 0, sizeof(desc_cpy));
 
 	if (is_cmd_for_retry) {
-		if (buf) {
-			buf_cpy = kzalloc(buf_size, GFP_KERNEL);
-			if (!buf_cpy)
-				return -ENOMEM;
-		}
+		/* All retryable cmds are direct, without buf. */
+		WARN_ON(buf);
 
 		memcpy(&desc_cpy, desc, sizeof(desc_cpy));
 	}
@@ -1645,17 +1641,12 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		    hw->adminq.sq_last_status != ICE_AQ_RC_EBUSY)
 			break;
 
-		if (buf_cpy)
-			memcpy(buf, buf_cpy, buf_size);
-
 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
 
 		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
 
 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
 
-	kfree(buf_cpy);
-
 	return status;
 }
 
-- 
2.38.1

