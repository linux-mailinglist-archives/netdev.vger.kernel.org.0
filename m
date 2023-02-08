Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB98668EFCA
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjBHNbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjBHNbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:31:40 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C68474C4;
        Wed,  8 Feb 2023 05:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675863099; x=1707399099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cb2fmUJNKf9jp0dPCHeaHoLfrF2oW+dEQC2UUuvVm/I=;
  b=GIcrIgOCwmSFC9RPuX5RNW4Sfw2lVgxXua0u7Qp23YN2H2YZDQNmNAXR
   iGO0RGZtxqC312N5r83KPEETIVMAUYM/zYCWOKFHupn+oQNwTVQjD15oM
   KymST6+We7Sck154Ga0ePjpZPEkroGnhPtIGTzksNRhs10vabg6E1AXud
   Gq1ovf36jN3kc4HOxzP+1QnQ9qsW5lE/oOxNH331iCpoCnCFezSAsl6fg
   cbZf3+Nab0E7n1E7Nv/w1uhOv9auDP9CUBvv6LUQ5gmdhPsbBxd5lF+Zr
   cWYWs9nnjIBPFa0p5Cm9FKystjLxuQ+sPCM/jNgaeLQ+OYO/9OhKKo+WW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="416017519"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="416017519"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 05:31:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="617215420"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="617215420"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 08 Feb 2023 05:31:22 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E3581252; Wed,  8 Feb 2023 15:32:00 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 3/3] openvswitch: Use string_is_terminated() helper
Date:   Wed,  8 Feb 2023 15:31:53 +0200
Message-Id: <20230208133153.22528-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
References: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
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

Use string_is_terminated() helper instead of cpecific memchr() call.
This shows better the intention of the call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3: renamed to string_is_terminated (Jakub)
v2: added tag and updated subject (Simon)
 net/openvswitch/conntrack.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 2172930b1f17..f95272ebfa08 100644
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
+			if (!string_is_terminated(*helper, nla_len(a))) {
 				OVS_NLERR(log, "Invalid conntrack helper");
 				return -EINVAL;
 			}
@@ -1404,7 +1405,7 @@ static int parse_ct(const struct nlattr *attr, struct ovs_conntrack_info *info,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 		case OVS_CT_ATTR_TIMEOUT:
 			memcpy(info->timeout, nla_data(a), nla_len(a));
-			if (!memchr(info->timeout, '\0', nla_len(a))) {
+			if (!string_is_terminated(info->timeout, nla_len(a))) {
 				OVS_NLERR(log, "Invalid conntrack timeout");
 				return -EINVAL;
 			}
-- 
2.39.1

