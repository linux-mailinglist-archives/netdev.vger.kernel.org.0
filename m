Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1295A5F19
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiH3JSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiH3JSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:18:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E59D7D1E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661851126; x=1693387126;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PwS2c341IBy7CnbS/049DNnhbYAtdftlwZmU8hsfgys=;
  b=c/ZOe5tQ9WaVbwUysSznyl7DiqURgPKM+VD7yK/rWC8hSx53Aegflpvk
   77T1riugW7f8Y7a7i1bdUMO6Yqfl1h8J5NGUcDYfngBFdZspygBBGB951
   c8P44LHrO/dCxnQkeubp8tb2NqY/fmzgmdKzLYq5uuHj2fRYb5rE0idBa
   uic4sy1X4WBNNJJqDM55g+CTeq7gsw/nqEh0DjcUJmMBgXoMj2comNnQU
   IXx/7RgD4c9rGB4NAJ5irdMn4IxI3OjFkA3YLJHDrZ1sXzDXGxgLT/7/z
   /+ZztsVJFhgJHFJxFVhYIxmB9ZWZWTMCoFp4SeIB08v3l3KAvwRRbrZ3x
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="381424501"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="381424501"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:18:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="700921397"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Aug 2022 02:18:45 -0700
Subject: [net-next PATCH 1/3] act_skbedit: Add support for action skbedit RX
 queue mapping
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.h.duyck@intel.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Tue, 30 Aug 2022 02:28:44 -0700
Message-ID: <166185172440.65874.8891046979376146714.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
References: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

