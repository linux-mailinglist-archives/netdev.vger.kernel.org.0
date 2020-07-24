Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D495522C090
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgGXIVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:21:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51013 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726554AbgGXIVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 04:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595578868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FdxpIjtDXHJMG7USfFQLKQNEuA9T+M74yKPl1TbvbXk=;
        b=Smdh9ERnY/FIuQh9SweRfmYBSwrudYQNLJcFQ/kcJslr0+mC4wFi/evUUsxv8uBFlHQZuR
        lb/gOwIycKoaa5pO4rLRj02WPpmTVQuk+irCIla9OvXWhD5zH2xaL/qfWtvZbVet+wyO8s
        OHbf2YobCNfcXDKajvhPuK4L9qdl27A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-t-FFXzZrNDesxxDWk4ftqw-1; Fri, 24 Jul 2020 04:21:06 -0400
X-MC-Unique: t-FFXzZrNDesxxDWk4ftqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 810B210CE788;
        Fri, 24 Jul 2020 08:21:05 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-133.ams2.redhat.com [10.36.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32E975D9E2;
        Fri, 24 Jul 2020 08:21:04 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net-next] net: openvswitch: fixes potential deadlock in dp cleanup code
Date:   Fri, 24 Jul 2020 10:20:59 +0200
Message-Id: <159557885902.884526.12945945970267356485.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch introduced a deadlock, this patch fixes it by making
sure the work is canceled without holding the global ovs lock. This is
done by moving the reorder processing one layer up to the netns level.

Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
Reported-by: syzbot+2c4ff3614695f75ce26c@syzkaller.appspotmail.com
Reported-by: syzbot+bad6507e5db05017b008@syzkaller.appspotmail.com
Reviewed-by: Paolo <pabeni@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/openvswitch/datapath.c |   23 ++++++++++++-----------
 net/openvswitch/datapath.h |    4 +---
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 95805f0e27bd..6b6822f82f70 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1655,7 +1655,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto err_destroy_reply;
 
 	ovs_dp_set_net(dp, sock_net(skb->sk));
-	INIT_DELAYED_WORK(&dp->masks_rebalance, ovs_dp_masks_rebalance);
 
 	/* Allocate table. */
 	err = ovs_flow_tbl_init(&dp->table);
@@ -1715,9 +1714,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_net = net_generic(ovs_dp_get_net(dp), ovs_net_id);
 	list_add_tail_rcu(&dp->list_node, &ovs_net->dps);
 
-	schedule_delayed_work(&dp->masks_rebalance,
-			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
-
 	ovs_unlock();
 
 	ovs_notify(&dp_datapath_genl_family, reply, info);
@@ -1762,9 +1758,6 @@ static void __dp_destroy(struct datapath *dp)
 
 	/* RCU destroy the flow table */
 	call_rcu(&dp->rcu, destroy_dp_rcu);
-
-	/* Cancel remaining work. */
-	cancel_delayed_work_sync(&dp->masks_rebalance);
 }
 
 static int ovs_dp_cmd_del(struct sk_buff *skb, struct genl_info *info)
@@ -2349,14 +2342,18 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 static void ovs_dp_masks_rebalance(struct work_struct *work)
 {
-	struct datapath *dp = container_of(work, struct datapath,
-					   masks_rebalance.work);
+	struct ovs_net *ovs_net = container_of(work, struct ovs_net,
+					       masks_rebalance.work);
+	struct datapath *dp;
 
 	ovs_lock();
-	ovs_flow_masks_rebalance(&dp->table);
+
+	list_for_each_entry(dp, &ovs_net->dps, list_node)
+		ovs_flow_masks_rebalance(&dp->table);
+
 	ovs_unlock();
 
-	schedule_delayed_work(&dp->masks_rebalance,
+	schedule_delayed_work(&ovs_net->masks_rebalance,
 			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
 }
 
@@ -2454,6 +2451,9 @@ static int __net_init ovs_init_net(struct net *net)
 
 	INIT_LIST_HEAD(&ovs_net->dps);
 	INIT_WORK(&ovs_net->dp_notify_work, ovs_dp_notify_wq);
+	INIT_DELAYED_WORK(&ovs_net->masks_rebalance, ovs_dp_masks_rebalance);
+	schedule_delayed_work(&ovs_net->masks_rebalance,
+			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
 	return ovs_ct_init(net);
 }
 
@@ -2508,6 +2508,7 @@ static void __net_exit ovs_exit_net(struct net *dnet)
 
 	ovs_unlock();
 
+	cancel_delayed_work_sync(&ovs_net->masks_rebalance);
 	cancel_work_sync(&ovs_net->dp_notify_work);
 }
 
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 697a2354194b..24fcec22fde2 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -84,9 +84,6 @@ struct datapath {
 
 	/* Switch meters. */
 	struct dp_meter_table meter_tbl;
-
-	/* re-balance flow masks timer */
-	struct delayed_work masks_rebalance;
 };
 
 /**
@@ -135,6 +132,7 @@ struct dp_upcall_info {
 struct ovs_net {
 	struct list_head dps;
 	struct work_struct dp_notify_work;
+	struct delayed_work masks_rebalance;
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
 	struct ovs_ct_limit_info *ct_limit_info;
 #endif

