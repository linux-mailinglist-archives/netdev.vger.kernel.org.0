Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A07649C03
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiLLKYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiLLKX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:23:59 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF9155AF;
        Mon, 12 Dec 2022 02:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670840638; x=1702376638;
  h=from:to:cc:subject:date:message-id;
  bh=cSezcPU4RnzjT9e4GFD3iSBpI5IOqBgS6srRdet/9GA=;
  b=DaA3Fc8tYBStak08DLfSPuoIPT39RotNQ49mdZEmzdtXRwLL/3CE//UT
   X1mUcoLkyP2hTmmPna09tobn/wynzWE5FOcC9yl6yamzoqUXtBeHERF4b
   YkoWbyZ3Quot0Qf/Rk6b2ctYZBJJzlb+XUbwDIE39VAPbKT6rn86UWEUA
   0w3PDI6C6A1YG233Gh9ZDVpdL3LDnOAiQD01pTBiRWEXFfERo8jD/7f2u
   RYWkaE/oIDgkoGuWv1JG28uorse9HSrjw6T1NdbKcUHshaXQ/4y+/arNu
   tpm5SjLAUVRX0/ktKRKrJijbmxZKTW5jJyBiq1tHOL9/26hMgLhNpa3oi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="301241842"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="301241842"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 02:23:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="772544399"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="772544399"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.111])
  by orsmga004.jf.intel.com with ESMTP; 12 Dec 2022 02:23:54 -0800
From:   Lai Peter Jun Ann <jun.ann.lai@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Lai Peter Jun Ann <jun.ann.lai@intel.com>
Subject: [PATCH net-next 1/1] taprio: Add boundary check for sched-entry values
Date:   Mon, 12 Dec 2022 18:23:51 +0800
Message-Id: <1670840632-8754-1-git-send-email-jun.ann.lai@intel.com>
X-Mailer: git-send-email 1.9.1
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

Adds boundary checks for the gatemask provided against the number of
traffic class defined and the interval times for each sched-entry.

Without this check, the user would not know that the gatemask provided is
invalid and the driver has already truncated the gatemask provided to
match the number of traffic class defined.

The interval times is also checked for values less than 0 or for invalid
inputs such as 00000.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
---
 net/sched/sch_taprio.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 570389f..76a461d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -786,7 +786,8 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct sched_entry *entry,
-			    struct netlink_ext_ack *extack)
+			    struct netlink_ext_ack *extack,
+			    u8 num_tc)
 {
 	int min_duration = length_to_duration(q, ETH_ZLEN);
 	u32 interval = 0;
@@ -806,11 +807,16 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 	/* The interval should allow at least the minimum ethernet
 	 * frame to go out.
 	 */
-	if (interval < min_duration) {
+	if (interval < min_duration || !interval) {
 		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
 		return -EINVAL;
 	}
 
+	if (entry->gate_mask >= BIT_MASK(num_tc)) {
+		NL_SET_ERR_MSG(extack, "Traffic Class defined less than gatemask");
+		return -EINVAL;
+	}
+
 	entry->interval = interval;
 
 	return 0;
@@ -818,7 +824,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 
 static int parse_sched_entry(struct taprio_sched *q, struct nlattr *n,
 			     struct sched_entry *entry, int index,
-			     struct netlink_ext_ack *extack)
+			     struct netlink_ext_ack *extack,
+			     u8 num_tc)
 {
 	struct nlattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = { };
 	int err;
@@ -832,12 +839,13 @@ static int parse_sched_entry(struct taprio_sched *q, struct nlattr *n,
 
 	entry->index = index;
 
-	return fill_sched_entry(q, tb, entry, extack);
+	return fill_sched_entry(q, tb, entry, extack, num_tc);
 }
 
 static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
 			    struct sched_gate_list *sched,
-			    struct netlink_ext_ack *extack)
+			    struct netlink_ext_ack *extack,
+			    u8 num_tc)
 {
 	struct nlattr *n;
 	int err, rem;
@@ -860,7 +868,7 @@ static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
 			return -ENOMEM;
 		}
 
-		err = parse_sched_entry(q, n, entry, i, extack);
+		err = parse_sched_entry(q, n, entry, i, extack, num_tc);
 		if (err < 0) {
 			kfree(entry);
 			return err;
@@ -877,7 +885,8 @@ static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
 
 static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
-				 struct netlink_ext_ack *extack)
+				 struct netlink_ext_ack *extack,
+				 u8 num_tc)
 {
 	int err = 0;
 
@@ -897,7 +906,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST])
 		err = parse_sched_list(q, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST],
-				       new, extack);
+				       new, extack, num_tc);
 	if (err < 0)
 		return err;
 
@@ -1541,14 +1550,17 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	unsigned long flags;
 	ktime_t start;
 	int i, err;
+	u8 num_tc = 0;
 
 	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
 					  taprio_policy, extack);
 	if (err < 0)
 		return err;
 
-	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
+	if (tb[TCA_TAPRIO_ATTR_PRIOMAP]) {
 		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
+		num_tc = mqprio->num_tc;
+	}
 
 	err = taprio_new_flags(tb[TCA_TAPRIO_ATTR_FLAGS],
 			       q->flags, extack);
@@ -1585,7 +1597,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
-	err = parse_taprio_schedule(q, tb, new_admin, extack);
+	err = parse_taprio_schedule(q, tb, new_admin, extack, num_tc);
 	if (err < 0)
 		goto free_sched;
 
-- 
1.9.1

