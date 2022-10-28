Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E3610F52
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiJ1LEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJ1LEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34434193E9;
        Fri, 28 Oct 2022 04:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955079; x=1698491079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v1Ngafe2wl2d7dOs7kYteJsD+qfKwftFJr4pbNJ45/k=;
  b=eLfswNb01TmWOTPLk51/bjv3SSuBOWshk4WVOOSdoNpLebZzfUOSWrxi
   hu/G0q58eD0l2n3As52fkZjPmcgDYLossk23bL0tzVZWH6fr5rJC7RkIw
   K5UC9qF5Mw4lImEyByMCta/xRgJXN67iIPDkqrWS6aEqZ1tEexq3JIYjg
   jRotuO1ok+ieOwMc1WIoRyeSyAZeICjg7yMTlE1Pukx8Gfvl/W4jy35sI
   CeyEfXCm42u/EFeBLewlfeVIpsg/CU9KlfW1Hawg1YxgkpvYQVb+mRtI0
   jcPARx4Z9VbXp7LJE1oVMheAaEdJw9UC7IzPTtQmmg5okEudt38NTAsSe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766553"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766553"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698117"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698117"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:35 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH net-next v3 8/9] ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 28 Oct 2022 04:04:19 -0700
Message-Id: <20221028110420.3451088-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221028110420.3451088-1-jacob.e.keller@intel.com>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ravb implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
function to calculate the new addend.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: linux-renesas-soc@vger.kernel.org
---
 drivers/net/ethernet/renesas/ravb_ptp.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 87c4306d66ec..6e4ef7af27bf 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -88,24 +88,17 @@ static int ravb_ptp_update_compare(struct ravb_private *priv, u32 ns)
 }
 
 /* PTP clock operations */
-static int ravb_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ravb_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ravb_private *priv = container_of(ptp, struct ravb_private,
 						 ptp.info);
 	struct net_device *ndev = priv->ndev;
 	unsigned long flags;
-	u32 diff, addend;
-	bool neg_adj = false;
+	u32 addend;
 	u32 gccr;
 
-	if (ppb < 0) {
-		neg_adj = true;
-		ppb = -ppb;
-	}
-	addend = priv->ptp.default_addend;
-	diff = div_u64((u64)addend * ppb, NSEC_PER_SEC);
-
-	addend = neg_adj ? addend - diff : addend + diff;
+	addend = (u32)adjust_by_scaled_ppm(priv->ptp.default_addend,
+					   scaled_ppm);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -295,7 +288,7 @@ static const struct ptp_clock_info ravb_ptp_info = {
 	.max_adj	= 50000000,
 	.n_ext_ts	= N_EXT_TS,
 	.n_per_out	= N_PER_OUT,
-	.adjfreq	= ravb_ptp_adjfreq,
+	.adjfine	= ravb_ptp_adjfine,
 	.adjtime	= ravb_ptp_adjtime,
 	.gettime64	= ravb_ptp_gettime64,
 	.settime64	= ravb_ptp_settime64,
-- 
2.38.0.83.gd420dda05763

