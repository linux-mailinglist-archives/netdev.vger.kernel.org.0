Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA67689B02
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbjBCOHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbjBCOHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:07:10 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22140A7007;
        Fri,  3 Feb 2023 06:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675433093; x=1706969093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IEFz6QAgddcxfiR8Ghuc1c4KiIs3u68VGpMZSHRqEKw=;
  b=Ubsm4zv1GRZ82C4LmE/Vy2+1GtyKsmbzpIBUgdeMF6l2GOA6rf1eeOvm
   jYG/7wMY7P9DqCjareBV0asKvkV1ypKZvOyJvYHtRWR3tznirONGHFZmo
   ZIeNDjpoG3993di2+XfvLkpcbePKt/MTXb67fSM0SEmedQU3IGxLU/l2i
   c7FER57Y4QWukiyzh2DOSWvi7h4gCRlMTNUDrSzw0QOkGYtvXkrgcbHIa
   0WFrz9BtxqDsKK85sVT8fINCWgwsZETbOg5jzBMoeAyaYirRvru9r3mdB
   DqKXwrjlEuXDRN22oFK4+eaTKdfXLy5vF7f4cBKp/D9tcOYaJOdq+8uo1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="391149052"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="391149052"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:04:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="808370499"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="808370499"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2023 06:04:45 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E1EF73CC; Fri,  3 Feb 2023 16:05:22 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net
Cc:     Andy Shevchenko <andy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH v1 3/3] openvswitch: Use string_is_valid() helper
Date:   Fri,  3 Feb 2023 16:05:01 +0200
Message-Id: <20230203140501.67659-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
References: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use string_is_valid() helper instead of cpecific memchr() call.
This shows better the intention of the call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/openvswitch/conntrack.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 2172930b1f17..1d65805e79b4 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -9,6 +9,7 @@
 #include <linux/udp.h>
 #include <linux/sctp.h>
 #include <linux/static_key.h>
+#include <linux/string_helpers.h>
 #include <net/ip.h>
 #include <net/genetlink.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -1383,7 +1384,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 #endif
 		case OVS_CT_ATTR_HELPER:
 			*helper = nla_data(a);
-			if (!memchr(*helper, '\0', nla_len(a))) {
+			if (!string_is_valid(*helper, nla_len(a))) {
 				OVS_NLERR(log, "Invalid conntrack helper");
 				return -EINVAL;
 			}
@@ -1404,7 +1405,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 		case OVS_CT_ATTR_TIMEOUT:
 			memcpy(info->timeout, nla_data(a), nla_len(a));
-			if (!memchr(info->timeout, '\0', nla_len(a))) {
+			if (!string_is_valid(info->timeout, nla_len(a))) {
 				OVS_NLERR(log, "Invalid conntrack timeout");
 				return -EINVAL;
 			}
-- 
2.39.1

