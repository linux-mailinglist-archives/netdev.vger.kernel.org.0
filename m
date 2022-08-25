Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD5A5A0716
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiHYCF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiHYCFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:05:55 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9685818E2C
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 19:05:54 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oR2EC-0002yC-Oz;
        Thu, 25 Aug 2022 04:05:52 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, i.maximets@ovn.org,
        aconole@redhat.com
Subject: [PATCH net-next v3 2/2] openvswitch: add OVS_DP_ATTR_PER_CPU_PIDS to get requests
Date:   Thu, 25 Aug 2022 05:04:50 +0300
Message-Id: <20220825020450.664147-3-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
References: <20220825020450.664147-1-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CRIU needs OVS_DP_ATTR_PER_CPU_PIDS to checkpoint/restore newest
openvswitch versions.
Add pids to generic datapath reply. Limit exported pids amount to
nr_cpu_ids.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---

v3:
Greatly reduce patch size by allocating message big enough to fit reply
in all cases. Now there is no need to move allocation under the lock.
Remove unnecessary 64bit aligning for pids nlattr.


 net/openvswitch/datapath.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 2ca86b53c032..7bcb36705518 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1515,6 +1515,7 @@ static size_t ovs_dp_cmd_msg_size(void)
 	msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_megaflow_stats));
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_USER_FEATURES */
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_MASKS_CACHE_SIZE */
+	msgsize += nla_total_size(sizeof(u32) * nr_cpu_ids); /* OVS_DP_ATTR_PER_CPU_PIDS */
 
 	return msgsize;
 }
@@ -1526,7 +1527,8 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 	struct ovs_header *ovs_header;
 	struct ovs_dp_stats dp_stats;
 	struct ovs_dp_megaflow_stats dp_megaflow_stats;
-	int err;
+	struct dp_nlsk_pids *pids = ovsl_dereference(dp->upcall_portids);
+	int err, pids_len;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_datapath_genl_family,
 				 flags, cmd);
@@ -1556,6 +1558,12 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 			ovs_flow_tbl_masks_cache_size(&dp->table)))
 		goto nla_put_failure;
 
+	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && pids) {
+		pids_len = min(pids->n_pids, nr_cpu_ids) * sizeof(u32);
+		if (nla_put(skb, OVS_DP_ATTR_PER_CPU_PIDS, pids_len, &pids->pids))
+			goto nla_put_failure;
+	}
+
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
-- 
2.31.1

