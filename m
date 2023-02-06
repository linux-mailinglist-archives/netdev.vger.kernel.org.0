Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91D868C2B4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjBFQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjBFQNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:13:13 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C496C2FCEB;
        Mon,  6 Feb 2023 08:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675699964; x=1707235964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l/z8Ht549NtECTSxHC6f4gPVeQdnVs1kMMhg97KXrdY=;
  b=ElcICijSmWubzlx63RORU8S54xKAXeKuIJfW4fAiZL35b0B+szfKbYQT
   8sMKt/VJWfDQ1VLROOD3MiwjyMp2la/R6woUEM398MNUCsjlLBPMnPZu9
   +ap2LkR3vw+seZRhG8+qTOQ3bbtQPNeL3PQ67Vj8CEGUYL09Kh4PAti0q
   +xkFWtlxXVJefPmlUc/cmkRF8rKwn7loJkhRDkmD4lLJznpC2umbm/6hi
   PQM0HuSqql/lJCLk6p0MfZGkGoL78R2e726JMWB7F/q9vg/j3tAcRLw3c
   V5tXSZUZGIEoVB2HVyxqPwPZxAA+wUaA6vqqW2ALHuVCANUFSFsC4S7m2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="393840633"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="393840633"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 08:12:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="696902426"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="696902426"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 06 Feb 2023 08:12:37 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 02DAC27B; Mon,  6 Feb 2023 18:13:15 +0200 (EET)
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
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 3/3] openvswitch: Use string_is_valid() helper
Date:   Mon,  6 Feb 2023 18:13:14 +0200
Message-Id: <20230206161314.15667-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206161314.15667-1-andriy.shevchenko@linux.intel.com>
References: <20230206161314.15667-1-andriy.shevchenko@linux.intel.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2: added tag and updated subject (Simon)
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

