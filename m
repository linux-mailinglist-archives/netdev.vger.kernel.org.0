Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C82E3E5008
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 01:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbhHIXgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 19:36:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:30712 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235336AbhHIXgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 19:36:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="300391694"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="300391694"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 16:36:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="483773228"
Received: from anambiarhost.jf.intel.com ([10.166.224.238])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2021 16:36:21 -0700
Subject: [net-next PATCH] net: act_skbedit: Fix tc action skbedit
 queue_mapping
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Date:   Mon, 09 Aug 2021 16:41:09 -0700
Message-ID: <162855246915.98025.18251604658503765863.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For skbedit action queue_mapping to select the transmit queue,
queue_mapping takes the value N for tx-N (where N is the actual
queue number). However, current behavior is the following:
1. Queue selection is off by 1, tx queue N-1 is selected for
   action skbedit queue_mapping N. (If the general syntax for queue
   index is 1 based, i.e., action skbedit queue_mapping N would
   transmit to tx queue N-1, where N >=1, then the last queue cannot
   be used for transmit as this fails the upper bound check.)
2. Transmit to first queue of TCs other than TC0 selects the
   next queue.
3. It is not possible to transmit to the first queue (tx-0) as
   this fails the bounds check, in this case the fallback
   mechanism for hash calculation is used.

Fix the call to skb_set_queue_mapping(), the code retrieving the
transmit queue uses skb_get_rx_queue() which subtracts the queue
index by 1. This makes it so that "action skbedit queue_mapping N"
will transmit to tx-N (including the first and last queue).

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 net/sched/act_skbedit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index e5f3fb8b00e3..a7bba15c74c4 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -59,7 +59,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 	if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
 	    skb->dev->real_num_tx_queues > params->queue_mapping)
-		skb_set_queue_mapping(skb, params->queue_mapping);
+		skb_set_queue_mapping(skb, params->queue_mapping + 1);
 	if (params->flags & SKBEDIT_F_MARK) {
 		skb->mark &= ~params->mask;
 		skb->mark |= params->mark & params->mask;

