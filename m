Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494C462D2CC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 06:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiKQFeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 00:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiKQFdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 00:33:22 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2618D6CA1E
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 21:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668663202; x=1700199202;
  h=from:to:cc:subject:date:message-id;
  bh=VDOqyz/7sl1ct6WZT8pNPxiN4VjbD/HdIT87JuwuUxA=;
  b=iw7Isu15WxfLRKx11XqxuB5cPqKTgmE3Kb6x3A4pu1CjTZ3LoD+RptBV
   jZwUZCf84zpL5MnHVXeK1yeSsVcujsZEf+fFp7BpjXQxwjPQu+5hC/r3U
   24WN0+SU7KkH51tkUo5Mhu0Knh68CIfZ8iGshyRqvm6QGZGxtJNxLY2N0
   tRN/pwqWa+2oNJ5Dqp1aZh1MQuL9gN11Ra8Egl31nXmSd4jC7gOac/pQz
   VqIax/mh3iZB0M0FUo/or9SZaEp9iD4rzaMWz1CHRLOqO0CTgHiwRQLo2
   0FSnwEQCqPAvGOyNePLRUJxSKx6EnZV0Ki7sz+8GpAXepaP6/tVgfxrdz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="292468498"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="292468498"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 21:33:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="782071615"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="782071615"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.111])
  by fmsmga001.fm.intel.com with ESMTP; 16 Nov 2022 21:33:18 -0800
From:   Lai Peter Jun Ann <jun.ann.lai@intel.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Lai Peter Jun Ann <jun.ann.lai@intel.com>
Subject: [PATCH iproute2-next v1] tc_util: Fix no error return when large parent id used
Date:   Thu, 17 Nov 2022 13:33:17 +0800
Message-Id: <1668663197-22115-1-git-send-email-jun.ann.lai@intel.com>
X-Mailer: git-send-email 1.9.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix the issue where there is no error return
when large value of parent ID is being used. The return value by
stroul() is unsigned long int. Hence the datatype for maj and min
should defined as unsigned long to avoid overflow issue.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
---
 tc/tc_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 44137ad..334334d 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -93,7 +93,7 @@ ok:
 
 int get_tc_classid(__u32 *h, const char *str)
 {
-	__u32 maj, min;
+	unsigned long maj, min;
 	char *p;
 
 	maj = TC_H_ROOT;
-- 
1.9.1

