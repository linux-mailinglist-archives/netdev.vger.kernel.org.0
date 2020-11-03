Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C890E2A3ED6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgKCI0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:26:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCI0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604391959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=F3Q6OwRRuOv3Iqdl0fc7MADaK1OnFq88ajJ4vbl3/iM=;
        b=BaqDPvhyKwEhKRl06TZ2kRElKi84EAaBo+K9Itpi2RB+tyZEXQBiA+UBN+oy59Cn7Dtjk9
        x7/OuJb28Xh5UXCH/yv/6G4PDvkVNZDRmrUj1gHe/ve079E5faOKwk4hUhWBBidgQ8PIqU
        ssdr6sb/ft59ExFYrcfV8TG20xgYAKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-PmJrK8sLPg-hc5fFyfGr1g-1; Tue, 03 Nov 2020 03:25:55 -0500
X-MC-Unique: PmJrK8sLPg-hc5fFyfGr1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 848F31006CA0;
        Tue,  3 Nov 2020 08:25:54 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-253.ams2.redhat.com [10.36.114.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 566EF60BF1;
        Tue,  3 Nov 2020 08:25:53 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org
Subject: [PATCH net v2] net: openvswitch: silence suspicious RCU usage warning
Date:   Tue,  3 Nov 2020 09:25:49 +0100
Message-Id: <160439190002.56943.1418882726496275961.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence suspicious RCU usage warning in ovs_flow_tbl_masks_cache_resize()
by replacing rcu_dereference() with rcu_dereference_ovsl().

In addition, when creating a new datapath, make sure it's configured under
the ovs_lock.

Fixes: 9bf24f594c6a ("net: openvswitch: make masks cache size configurable")
Reported-by: syzbot+9a8f8bfcc56e8578016c@syzkaller.appspotmail.com
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
v2: - Moved local variable initialization above lock
    - Renamed jump label to indicate unlocking

 net/openvswitch/datapath.c   |   14 +++++++-------
 net/openvswitch/flow_table.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 832f898edb6a..9d6ef6cb9b26 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1703,13 +1703,13 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	parms.port_no = OVSP_LOCAL;
 	parms.upcall_portids = a[OVS_DP_ATTR_UPCALL_PID];
 
-	err = ovs_dp_change(dp, a);
-	if (err)
-		goto err_destroy_meters;
-
 	/* So far only local changes have been made, now need the lock. */
 	ovs_lock();
 
+	err = ovs_dp_change(dp, a);
+	if (err)
+		goto err_unlock_and_destroy_meters;
+
 	vport = new_vport(&parms);
 	if (IS_ERR(vport)) {
 		err = PTR_ERR(vport);
@@ -1725,8 +1725,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
-		ovs_unlock();
-		goto err_destroy_meters;
+		goto err_unlock_and_destroy_meters;
 	}
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
@@ -1741,7 +1740,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_datapath_genl_family, reply, info);
 	return 0;
 
-err_destroy_meters:
+err_unlock_and_destroy_meters:
+	ovs_unlock();
 	ovs_meters_exit(dp);
 err_destroy_ports:
 	kfree(dp->ports);
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index f3486a37361a..c89c8da99f1a 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -390,7 +390,7 @@ static struct mask_cache *tbl_mask_cache_alloc(u32 size)
 }
 int ovs_flow_tbl_masks_cache_resize(struct flow_table *table, u32 size)
 {
-	struct mask_cache *mc = rcu_dereference(table->mask_cache);
+	struct mask_cache *mc = rcu_dereference_ovsl(table->mask_cache);
 	struct mask_cache *new;
 
 	if (size == mc->cache_size)

