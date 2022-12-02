Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71CC64008B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 07:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiLBG0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 01:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiLBG0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 01:26:49 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38912A457
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 22:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669962409; x=1701498409;
  h=from:to:cc:subject:date:message-id;
  bh=RraBzLSBKBPCSip5Z6OJ3v8/o7m6/8Cn24GXK68mGng=;
  b=PNx365Wkugnaqg2F+FuHMYdB74XjbaO1No6bpSCnSWtAaf8vPM2eNaaZ
   iQr9B5yXjClULICI3R6Jn8LyM6cl94qiJBRjW7gTHyF8LBwK5hlmjyEvV
   PIBSCbUrJf9Hfxyngdq2HLV1wZCiLDWjlhmS08Vk9X6JaXNGKbFVL+HfN
   51oh9Ilace1ZgVO43vfeoydFkmNomsqcEoag92vpYyIZ1+rSpxwio8U+/
   uirt/oEJ//oyehtje8gHnmqMncAxqd+t7PEJDUpfhqEPpNQaiY51CVFac
   YSECzAATBH1oF9zfz8AgCFB6iAENePN0hrsOH8Yh54TPUikfEUViVlvgo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317030488"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="317030488"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:26:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638654048"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638654048"
Received: from ssid-ilbpg3-teeminta.png.intel.com ([10.88.227.74])
  by orsmga007.jf.intel.com with ESMTP; 01 Dec 2022 22:26:46 -0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH iproute2-next 1/1] taprio: fix wrong for loop condition in add_tc_entries()
Date:   Fri,  2 Dec 2022 14:25:42 +0800
Message-Id: <1669962342-2806-1-git-send-email-tee.min.tan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
X-Spam-Status: No, score=-1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The for loop in add_tc_entries() mistakenly included the last entry
index+1. Fix it to correctly loop the max_sdu entry between tc=0 and
num_max_sdu_entries-1.

Fixes: b10a6509c195 ("taprio: support dumping and setting per-tc max SDU")
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
---
 tc/q_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index ded385ca..a7c01ae0 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -157,7 +157,7 @@ static void add_tc_entries(struct nlmsghdr *n, __u32 max_sdu[TC_QOPT_MAX_QUEUE],
 	struct rtattr *l;
 	__u32 tc;
 
-	for (tc = 0; tc <= num_max_sdu_entries; tc++) {
+	for (tc = 0; tc < num_max_sdu_entries; tc++) {
 		l = addattr_nest(n, 1024, TCA_TAPRIO_ATTR_TC_ENTRY | NLA_F_NESTED);
 
 		addattr_l(n, 1024, TCA_TAPRIO_TC_ENTRY_INDEX, &tc, sizeof(tc));
-- 
2.25.1

