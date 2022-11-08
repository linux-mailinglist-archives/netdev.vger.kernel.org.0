Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF0362207B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKHXwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiKHXwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:52:01 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A874D5E3E9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667951520; x=1699487520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DfQgAO/er0vA5EzvWFiCTjqX9GINX/3c+bqAZP731ao=;
  b=DvYqypz4fnW4giHoF6fzIT2kjgjy+5JXwq3ZlsWFX1yomMakkA+buEZo
   lEQsB9Hlu50nMVrdyHWrwSt5+DqPbZNv1wZguK49oJ9gp9HZKMUIru/NQ
   reZF3jJAgEQHOMaEBndsIjNVw9w7KbWm9sTJjPIO+wEI4r/ICXKcHapSd
   ned45qMT1zcXZxrOfQ23sJGw7wbgykFpWLqbgFYYDx1Nyyiu1vRmqToFt
   3T50BgBy0jPQDDAmvjfIUs1d9goJX4rO4nuVrWP0QWXbP5a8wixhDZIm7
   D+FT+yAbAwY3dzEu2l3PLJRzktBy+0cFzXos2JdmWVEIbC2MWWOjnx8W6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290556986"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290556986"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 15:51:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="667777837"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="667777837"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2022 15:51:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/3] ice: use int for n_per_out loop
Date:   Tue,  8 Nov 2022 15:51:15 -0800
Message-Id: <20221108235116.3522941-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
References: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In ice_ptp_enable_all_clkout and ice_ptp_disable_all_clkout we use a uint
for a for loop iterating over the n_per_out value from the struct
ptp_clock_info. The struct member is a signed int, and the use of uint
generates a -Wsign-compare warning:

  drivers/net/ethernet/intel/ice/ice_ptp.c: In function ‘ice_ptp_enable_all_clkout’:
  drivers/net/ethernet/intel/ice/ice_ptp.c:1710:23: error: comparison of integer expressions of different signedness: ‘uint’ {aka ‘unsigned int’} and ‘int’ [-Werror=sign-compare]
   1710 |         for (i = 0; i < pf->ptp.info.n_per_out; i++)
        |                       ^
  cc1: all warnings being treated as errors

While we don't generally compile with -Wsign-compare, its still a good idea
not to mix types. Fix the two functions to use a plain signed integer.

Fixes: 9ee313433c48 ("ice: restart periodic outputs around time changes")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 011b727ab190..be147fb641ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1688,7 +1688,7 @@ static int ice_ptp_cfg_clkout(struct ice_pf *pf, unsigned int chan,
  */
 static void ice_ptp_disable_all_clkout(struct ice_pf *pf)
 {
-	uint i;
+	int i;
 
 	for (i = 0; i < pf->ptp.info.n_per_out; i++)
 		if (pf->ptp.perout_channels[i].ena)
@@ -1705,7 +1705,7 @@ static void ice_ptp_disable_all_clkout(struct ice_pf *pf)
  */
 static void ice_ptp_enable_all_clkout(struct ice_pf *pf)
 {
-	uint i;
+	int i;
 
 	for (i = 0; i < pf->ptp.info.n_per_out; i++)
 		if (pf->ptp.perout_channels[i].ena)
-- 
2.35.1

