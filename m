Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9B4DCAAF
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiCQQED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiCQQEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:04:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFE2214045
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647532964; x=1679068964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N5WcnLyTv1HxbEBY89Ery+zpzkLorFUTIcoInwUomH8=;
  b=gmvYoiTY3kD/AcFcFEddcbGbLTgHbC35EJK2BrUV/zfEaSA6h4+WKXkS
   LMaKJVUDJUj5gepvMtNW/lvQy8QslYJCnvSppID+qcs5iHWA0cpll+C18
   IQZL+c+2sn7TwCKSvME10P0M9pXQ6qZT8aPjxN/YcbXKDfO2vGka21N1+
   GJU/VatAJH5ub8M77Ipa1W01MBrl9T+O2xcPvJ5JPkFSfYp/G3UwhqQDk
   Qv3/L3ZIOD9b6h1l6ibPMujo2rPXQ9EI7DadYpvOJeGdbpR50pSZ1BSbF
   oNxQUlFNJtNvdbJcPnZJ04XW107deG+i72jIV3G2t4DLTD31IrSSwf9Bb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="236845994"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="236845994"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 09:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="581339486"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 17 Mar 2022 09:02:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/2] igb: zero hwtstamp by default
Date:   Thu, 17 Mar 2022 09:02:36 -0700
Message-Id: <20220317160236.3534321-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
References: <20220317160236.3534321-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang static analysis reports this representative issue
igb_ptp.c:997:3: warning: The left operand of '+' is a
  garbage value
  ktime_add_ns(shhwtstamps.hwtstamp, adjust);
  ^            ~~~~~~~~~~~~~~~~~~~~

shhwtstamps.hwtstamp is set by a call to
igb_ptp_systim_to_hwtstamp().  In the switch-statement
for the hw type, the hwtstamp is zeroed for matches
but not the default case.  Move the memset out of
switch-statement.  This degarbages the default case
and reduces the size.

Some whitespace cleanup of empty lines

Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 6580fcddb4be..02fec948ce64 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -165,23 +165,21 @@ static void igb_ptp_systim_to_hwtstamp(struct igb_adapter *adapter,
 	unsigned long flags;
 	u64 ns;
 
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+
 	switch (adapter->hw.mac.type) {
 	case e1000_82576:
 	case e1000_82580:
 	case e1000_i354:
 	case e1000_i350:
 		spin_lock_irqsave(&adapter->tmreg_lock, flags);
-
 		ns = timecounter_cyc2time(&adapter->tc, systim);
-
 		spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
 		hwtstamps->hwtstamp = ns_to_ktime(ns);
 		break;
 	case e1000_i210:
 	case e1000_i211:
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
 		/* Upper 32 bits contain s, lower 32 bits contain ns. */
 		hwtstamps->hwtstamp = ktime_set(systim >> 32,
 						systim & 0xFFFFFFFF);
-- 
2.31.1

