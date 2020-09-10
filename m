Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7952639FD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgIJCQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:16:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:21906 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730061AbgIJCOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:14:40 -0400
IronPort-SDR: xxbTvvcLflG8MzlgaHVnvdltA3DMVna+0tW6l26a6uDbThQBtCeKPVCyLn+agEoHp+F5bByMVV
 iCzagq83VT9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="155837772"
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="155837772"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:03:24 -0700
IronPort-SDR: 0h2UBeSZTVkWS2KVqBjQfCyvYGeAXglfznFaTqhR5Swn2JJZ1Xx7nwUhER5blYHvJ/1vmm3f1v
 jdadoq8f1lWA==
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="341733575"
Received: from rbentz-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.86.17])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:03:23 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us,
        syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com
Subject: [PATCH net v1] taprio: Fix allowing too small intervals
Date:   Wed,  9 Sep 2020 17:03:11 -0700
Message-Id: <20200910000311.521452-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that the user specifies an interval that couldn't allow
any packet to be transmitted. This also avoids the issue of the
hrtimer handler starving the other threads because it's running too
often.

The solution is to reject interval sizes that according to the current
link speed wouldn't allow any packet to be transmitted.

Reported-by: syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_taprio.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index fe53c1e38c7d..b0ad7687ee2c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -777,9 +777,11 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
 };
 
-static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
+static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
+			    struct sched_entry *entry,
 			    struct netlink_ext_ack *extack)
 {
+	int min_duration = length_to_duration(q, ETH_ZLEN);
 	u32 interval = 0;
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
@@ -794,7 +796,10 @@ static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
 		interval = nla_get_u32(
 			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
 
-	if (interval == 0) {
+	/* The interval should allow at least the minimum ethernet
+	 * frame to go out.
+	 */
+	if (interval < min_duration) {
 		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
 		return -EINVAL;
 	}
@@ -804,8 +809,9 @@ static int fill_sched_entry(struct nlattr **tb, struct sched_entry *entry,
 	return 0;
 }
 
-static int parse_sched_entry(struct nlattr *n, struct sched_entry *entry,
-			     int index, struct netlink_ext_ack *extack)
+static int parse_sched_entry(struct taprio_sched *q, struct nlattr *n,
+			     struct sched_entry *entry, int index,
+			     struct netlink_ext_ack *extack)
 {
 	struct nlattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = { };
 	int err;
@@ -819,10 +825,10 @@ static int parse_sched_entry(struct nlattr *n, struct sched_entry *entry,
 
 	entry->index = index;
 
-	return fill_sched_entry(tb, entry, extack);
+	return fill_sched_entry(q, tb, entry, extack);
 }
 
-static int parse_sched_list(struct nlattr *list,
+static int parse_sched_list(struct taprio_sched *q, struct nlattr *list,
 			    struct sched_gate_list *sched,
 			    struct netlink_ext_ack *extack)
 {
@@ -847,7 +853,7 @@ static int parse_sched_list(struct nlattr *list,
 			return -ENOMEM;
 		}
 
-		err = parse_sched_entry(n, entry, i, extack);
+		err = parse_sched_entry(q, n, entry, i, extack);
 		if (err < 0) {
 			kfree(entry);
 			return err;
@@ -862,7 +868,7 @@ static int parse_sched_list(struct nlattr *list,
 	return i;
 }
 
-static int parse_taprio_schedule(struct nlattr **tb,
+static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 				 struct sched_gate_list *new,
 				 struct netlink_ext_ack *extack)
 {
@@ -883,8 +889,8 @@ static int parse_taprio_schedule(struct nlattr **tb,
 		new->cycle_time = nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
 
 	if (tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST])
-		err = parse_sched_list(
-			tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], new, extack);
+		err = parse_sched_list(q, tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST],
+				       new, extack);
 	if (err < 0)
 		return err;
 
@@ -1473,7 +1479,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
-	err = parse_taprio_schedule(tb, new_admin, extack);
+	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
 
-- 
2.28.0

