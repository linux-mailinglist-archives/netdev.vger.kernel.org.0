Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4C35B11F7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiIHBOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIHBOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:14:31 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEB9958B
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662599669; x=1694135669;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PwS2c341IBy7CnbS/049DNnhbYAtdftlwZmU8hsfgys=;
  b=m+QVYUv0uyvFmppSOkFo9rKPkPX7LBvKzz6iiOLcqtEuADKL3+mz3mAu
   rSLlsAh+snq4tlAy+TAfFrd5tRkqxzN/ibJXUNCEbrEH95J7S7fR35bu6
   Ye9hzcDxPUaNBXngB2a6dLJeSUpuYcZ+BYT+dbsHl3J8W9kdUBHkhLzj1
   CUrB2fSd+QkIjEXZcYg4TrphQVMIYvtTb5/viI4BDm5Z/V9eDqqa02XC9
   /WZnRszE3v2iJj7ixNYQLKjCl9bp+6JXRplHGA/evQyWIlgAO7j75AnWj
   IPAuyQMF84r6X0TdJNkQq9Uq+cWwvtbX8ApcZ7H+DhVhdyQU9qD2Foxto
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="284054994"
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="284054994"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 18:14:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,298,1654585200"; 
   d="scan'208";a="683034303"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga004.fm.intel.com with ESMTP; 07 Sep 2022 18:14:27 -0700
Subject: [net-next PATCH v2 1/4] act_skbedit: Add support for action skbedit
 RX queue mapping
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Wed, 07 Sep 2022 18:24:02 -0700
Message-ID: <166260024268.81018.16643044761694552448.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skbedit action in tc allows the selection of transmit queue
in an interface with multiple queues. This patch extends this
ability of skedit action by supporting the selection of receive
queue on which the packets would arrive.

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 net/sched/act_skbedit.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index e3bd11dfe1ca..9b8274d09117 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -37,6 +37,24 @@ static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
 	return netdev_cap_txqueue(skb->dev, queue_mapping);
 }
 
+static void tcf_skbedit_act_txq(struct tcf_skbedit_params *params,
+				struct sk_buff *skb)
+{
+	if (skb->dev->real_num_tx_queues > params->queue_mapping) {
+#ifdef CONFIG_NET_EGRESS
+		netdev_xmit_skip_txqueue(true);
+#endif
+		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
+	}
+}
+
+static void tcf_skbedit_act_rxq(struct tcf_skbedit_params *params,
+				struct sk_buff *skb)
+{
+	if (skb->dev->real_num_rx_queues > params->queue_mapping)
+		skb_record_rx_queue(skb, params->queue_mapping);
+}
+
 static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 			   struct tcf_result *res)
 {
@@ -71,12 +89,11 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 			break;
 		}
 	}
-	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
-	    skb->dev->real_num_tx_queues > params->queue_mapping) {
-#ifdef CONFIG_NET_EGRESS
-		netdev_xmit_skip_txqueue(true);
-#endif
-		skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb));
+	if (params->flags & SKBEDIT_F_QUEUE_MAPPING) {
+		if (!skb_at_tc_ingress(skb))
+			tcf_skbedit_act_txq(params, skb);
+		else
+			tcf_skbedit_act_rxq(params, skb);
 	}
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;

