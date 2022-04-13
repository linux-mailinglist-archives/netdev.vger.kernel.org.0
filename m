Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009BE4FFC29
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237242AbiDMRNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbiDMRNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:13:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5CF6B098;
        Wed, 13 Apr 2022 10:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649869869; x=1681405869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/LMMe7XEkZ85zUug7mkQeJZU2UTIEWt65zgjv8cOKpc=;
  b=Zio2YsNCcnryIE242CtuDFehvMOtab/F31B2hP7HG0VDSQzqfu9wTTw6
   8bjpbPUrtXkneTx1pGWsofN1CFFES5jbuytOajG5PLm3pIonblbTikz/r
   N0sNKApRzR2oT/rvmLs26EbHUOXpb9nR2x0MP84rX+i5+aCEOGxd772kC
   lAPshFzVhhZ9N13Iv/hNziZFJfgwuiXoes3wFjGLLw3+FZ2KTalIV0mLV
   lA3bpSViXFvHbZhKbd7LaiCswzVturd1b4blb9YKGqTNu7B/v7fF/0eDr
   YrZUrJ6PHTXIKoqi0mRKrIcHHcngdG36LrqEnowSuXrmZRXs1EOk2ESun
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="349158022"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="349158022"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 10:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573360525"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 10:11:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, stable@vger.kernel.org,
        James Hutchinson <jahutchinson99@googlemail.com>,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 4/4] e1000e: Fix possible overflow in LTR decoding
Date:   Wed, 13 Apr 2022 10:08:14 -0700
Message-Id: <20220413170814.2066855-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
References: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
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

From: Sasha Neftin <sasha.neftin@intel.com>

When we decode the latency and the max_latency, u16 value may not fit
the required size and could lead to the wrong LTR representation.

Scaling is represented as:
scale 0 - 1         (2^(5*0)) = 2^0
scale 1 - 32        (2^(5 *1))= 2^5
scale 2 - 1024      (2^(5 *2)) =2^10
scale 3 - 32768     (2^(5 *3)) =2^15
scale 4 - 1048576   (2^(5 *4)) = 2^20
scale 5 - 33554432  (2^(5 *4)) = 2^25
scale 4 and scale 5 required 20 and 25 bits respectively.
scale 6 reserved.

Replace the u16 type with the u32 type and allow corrected LTR
representation.

Cc: stable@vger.kernel.org
Fixes: 44a13a5d99c7 ("e1000e: Fix the max snoop/no-snoop latency for 10M")
Reported-by: James Hutchinson <jahutchinson99@googlemail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215689
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Tested-by: James Hutchinson <jahutchinson99@googlemail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index d60e2016d03c..e6c8e6d5234f 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1009,8 +1009,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
-	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
-	u16 lat_enc_d = 0;	/* latency decoded */
+	u32 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u32 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
-- 
2.31.1

