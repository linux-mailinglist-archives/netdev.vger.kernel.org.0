Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D300E599EBD
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349767AbiHSPct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbiHSPcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:32:43 -0400
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694A2101C54
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:32:41 -0700 (PDT)
Received: from dev006.ch-qa.sw.ru ([172.29.1.11])
        by relay.virtuozzo.com with esmtp (Exim 4.95)
        (envelope-from <andrey.zhadchenko@virtuozzo.com>)
        id 1oP3wc-00Gb30-A2;
        Fri, 19 Aug 2022 17:31:21 +0200
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org, aconole@redhat.com
Subject: [PATCH net-next v2 3/3] openvswitch: add OVS_DP_ATTR_PER_CPU_PIDS to get requests
Date:   Fri, 19 Aug 2022 18:30:44 +0300
Message-Id: <20220819153044.423233-4-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
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
Add pids to generic datapath reply. Adjust reply allocation to reserve
memory for pids and move it under ovs_lock() to ensure than number of
pids is unchanged while we adding them to nlmsg.

Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 net/openvswitch/datapath.c | 88 +++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 20c9964b74cc..865c848a041b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1506,9 +1506,11 @@ static struct genl_family dp_flow_genl_family __ro_after_init = {
 	.module = THIS_MODULE,
 };
 
-static size_t ovs_dp_cmd_msg_size(void)
+static size_t ovs_dp_cmd_msg_size(struct datapath *dp)
 {
 	size_t msgsize = NLMSG_ALIGN(sizeof(struct ovs_header));
+	struct dp_nlsk_pids *pids = ovsl_dereference(dp->upcall_portids);
+
 
 	msgsize += nla_total_size(IFNAMSIZ);
 	msgsize += nla_total_size_64bit(sizeof(struct ovs_dp_stats));
@@ -1516,6 +1518,9 @@ static size_t ovs_dp_cmd_msg_size(void)
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_USER_FEATURES */
 	msgsize += nla_total_size(sizeof(u32)); /* OVS_DP_ATTR_MASKS_CACHE_SIZE */
 
+	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && pids)
+		msgsize += nla_total_size_64bit(sizeof(u32) * pids->n_pids);
+
 	return msgsize;
 }
 
@@ -1527,6 +1532,7 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 	struct ovs_dp_stats dp_stats;
 	struct ovs_dp_megaflow_stats dp_megaflow_stats;
 	int err;
+	struct dp_nlsk_pids *pids = ovsl_dereference(dp->upcall_portids);
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_datapath_genl_family,
 				 flags, cmd);
@@ -1556,6 +1562,11 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 			ovs_flow_tbl_masks_cache_size(&dp->table)))
 		goto nla_put_failure;
 
+	if (dp->user_features & OVS_DP_F_DISPATCH_UPCALL_PER_CPU && pids &&
+	    nla_put_64bit(skb, OVS_DP_ATTR_PER_CPU_PIDS, sizeof(u32) * pids->n_pids,
+			  &pids->pids, OVS_DP_ATTR_PAD))
+		goto nla_put_failure;
+
 	genlmsg_end(skb, ovs_header);
 	return 0;
 
@@ -1565,9 +1576,9 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
-static struct sk_buff *ovs_dp_cmd_alloc_info(void)
+static struct sk_buff *ovs_dp_cmd_alloc_info(struct datapath *dp)
 {
-	return genlmsg_new(ovs_dp_cmd_msg_size(), GFP_KERNEL);
+	return genlmsg_new(ovs_dp_cmd_msg_size(dp), GFP_KERNEL);
 }
 
 /* Called with rcu_read_lock or ovs_mutex. */
@@ -1745,14 +1756,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
 		goto err;
 
-	reply = ovs_dp_cmd_alloc_info();
-	if (!reply)
-		return -ENOMEM;
-
-	err = -ENOMEM;
 	dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 	if (dp == NULL)
-		goto err_destroy_reply;
+		return -ENOMEM;
 
 	ovs_dp_set_net(dp, sock_net(skb->sk));
 
@@ -1785,9 +1791,15 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
 
-	err = ovs_dp_change(dp, a);
-	if (err)
+	reply = ovs_dp_cmd_alloc_info(dp);
+	if (!reply) {
+		err = -ENOMEM;
 		goto err_unlock_and_destroy_meters;
+	}
+
+	err = ovs_dp_change(dp, a);
+	if (err)
+		goto err_destroy_reply;
 
 	vport = new_vport(&parms);
 	if (IS_ERR(vport)) {
@@ -1822,6 +1834,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 err_destroy_pids:
 	if (rcu_dereference_raw(dp->upcall_portids))
 		kfree(rcu_dereference_raw(dp->upcall_portids));
+err_destroy_reply:
+	kfree_skb(reply);
 err_unlock_and_destroy_meters:
 	ovs_unlock();
 	ovs_meters_exit(dp);
@@ -1833,8 +1847,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_flow_tbl_destroy(&dp->table);
 err_destroy_dp:
 	kfree(dp);
-err_destroy_reply:
-	kfree_skb(reply);
 err:
 	return err;
 }
@@ -1881,15 +1893,17 @@ static int ovs_dp_cmd_del(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	int err;
 
-	reply = ovs_dp_cmd_alloc_info();
-	if (!reply)
-		return -ENOMEM;
-
 	ovs_lock();
 	dp = lookup_datapath(sock_net(skb->sk), info->userhdr, info->attrs);
 	err = PTR_ERR(dp);
 	if (IS_ERR(dp))
-		goto err_unlock_free;
+		goto err_unlock;
+
+	reply = ovs_dp_cmd_alloc_info(dp);
+	if (!reply) {
+		err = -ENOMEM;
+		goto err_unlock;
+	}
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_DEL);
@@ -1902,9 +1916,8 @@ static int ovs_dp_cmd_del(struct sk_buff *skb, struct genl_info *info)
 
 	return 0;
 
-err_unlock_free:
+err_unlock:
 	ovs_unlock();
-	kfree_skb(reply);
 	return err;
 }
 
@@ -1914,19 +1927,21 @@ static int ovs_dp_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	int err;
 
-	reply = ovs_dp_cmd_alloc_info();
-	if (!reply)
-		return -ENOMEM;
-
 	ovs_lock();
 	dp = lookup_datapath(sock_net(skb->sk), info->userhdr, info->attrs);
 	err = PTR_ERR(dp);
 	if (IS_ERR(dp))
-		goto err_unlock_free;
+		goto err_unlock;
+
+	reply = ovs_dp_cmd_alloc_info(dp);
+	if (!reply) {
+		err = -ENOMEM;
+		goto err_unlock;
+	}
 
 	err = ovs_dp_change(dp, info->attrs);
 	if (err)
-		goto err_unlock_free;
+		goto err_free;
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_SET);
@@ -1937,9 +1952,10 @@ static int ovs_dp_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	return 0;
 
-err_unlock_free:
-	ovs_unlock();
+err_free:
 	kfree_skb(reply);
+err_unlock:
+	ovs_unlock();
 	return err;
 }
 
@@ -1949,16 +1965,19 @@ static int ovs_dp_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	struct datapath *dp;
 	int err;
 
-	reply = ovs_dp_cmd_alloc_info();
-	if (!reply)
-		return -ENOMEM;
-
 	ovs_lock();
 	dp = lookup_datapath(sock_net(skb->sk), info->userhdr, info->attrs);
 	if (IS_ERR(dp)) {
 		err = PTR_ERR(dp);
-		goto err_unlock_free;
+		goto err_unlock;
 	}
+
+	reply = ovs_dp_cmd_alloc_info(dp);
+	if (!reply) {
+		err = -ENOMEM;
+		goto err_unlock;
+	}
+
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_GET);
 	BUG_ON(err < 0);
@@ -1966,9 +1985,8 @@ static int ovs_dp_cmd_get(struct sk_buff *skb, struct genl_info *info)
 
 	return genlmsg_reply(reply, info);
 
-err_unlock_free:
+err_unlock:
 	ovs_unlock();
-	kfree_skb(reply);
 	return err;
 }
 
-- 
2.31.1

