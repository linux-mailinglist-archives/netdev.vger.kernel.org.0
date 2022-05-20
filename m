Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A45D52E1B9
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344345AbiETBQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344335AbiETBQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:16:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D21138BC4
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653009360; x=1684545360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GvvOSRP3CzY8wou3e94OjmzfEqmZRYgWGPqWk9AlwqA=;
  b=LT8M4iu9Yptt7Xwc2A4mPMsq6XE0s/vSY0uXMdzXk/8N6S6Ti15rcbc5
   maL5HSohFmmFxiT1EWb/TFggSrht/zRt4WZiUTh5g1iAovi1m+gQ6LHs7
   tW44bShcqcoNcDRq9BLfNaQs7R5lG2onexdH7zkGJBbYOyApH3kYx8cY0
   Pv4/9XPlD/2o+PYRMxcolm4ZhkcxD+oP/5elZxtS6hI9ybmOvetbvGnDS
   X6gj/OzUPSb4DxOqhb+LIi961RHLafzrQ/APLkPwigKEmXnYR8FtXGS0S
   GWZKt9z26W76jgo4w727xwACW7cJQzC9kmKRMIk1YSvbuTa6jwJKQe0OG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="333064158"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="333064158"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570534548"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 18:15:54 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v5 05/11] igc: Optimze TX buffer sizes for TSN
Date:   Thu, 19 May 2022 18:15:32 -0700
Message-Id: <20220520011538.1098888-6-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220520011538.1098888-1-vinicius.gomes@intel.com>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 64KB buffer space shared for TX and RX (including the BMC).
We were only reserving 22KB for TX, increase each TX buffer (per
queue) by 2KB, the total is now 30KB for TX.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f609b2dbbc28..62fff53254dd 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -395,7 +395,7 @@
 #define I225_TXPBSIZE_DEFAULT	0x04000014 /* TXPBSIZE default */
 #define IGC_RXPBS_CFG_TS_EN	0x80000000 /* Timestamp in Rx buffer */
 
-#define IGC_TXPBSIZE_TSN	0x04145145 /* 5k bytes buffer for each queue */
+#define IGC_TXPBSIZE_TSN	0x041c71c7 /* 7KB buffer for each queue + 2KB for BMC */
 #define IGC_RXPBSIZE_TSN	0x0000f08f /* 15KB for EXP + 15KB for BE + 2KB for BMC */
 #define IGC_RXPBSIZE_SIZE_MASK	0x0001FFFF
 
-- 
2.35.3

