Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080D429EED2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgJ2Oxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgJ2Oxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603983213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WuSaw54N2WNnWs+yiS2iuACMZJVkFJJ9zkoidtfL5A0=;
        b=F4C95iZ2AtVJnfN2Mv1PseSqYLkWWgyRLh4bwAWUI7WHTBKwucX1KnFqu4Gok1l5VBHlM6
        MBxdoAJZm5V/VxHGIyU4vyyg8JATjOwBNCIdwTqmVdC8+KJKpOZXuo+lBLu/fa4vilXsrd
        Dk/8wna3nNv6Rg5OgHhHTiyOswM1Wp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-SMNuPuw6OKaAqFD8S8cXEA-1; Thu, 29 Oct 2020 10:53:28 -0400
X-MC-Unique: SMNuPuw6OKaAqFD8S8cXEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B839939C1A;
        Thu, 29 Oct 2020 14:53:27 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-253.ams2.redhat.com [10.36.114.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 526855B4A4;
        Thu, 29 Oct 2020 14:53:26 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org
Subject: [PATCH net] net: openvswitch: silence suspicious RCU usage warning
Date:   Thu, 29 Oct 2020 15:53:21 +0100
Message-Id: <160398318667.8898.856205445259063348.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 net/openvswitch/datapath.c   |    8 ++++----
 net/openvswitch/flow_table.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 832f898edb6a..020f8539fede 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1695,6 +1695,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto err_destroy_ports;
 
+	/* So far only local changes have been made, now need the lock. */
+	ovs_lock();
+
 	/* Set up our datapath device. */
 	parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
 	parms.type = OVS_VPORT_TYPE_INTERNAL;
@@ -1707,9 +1710,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto err_destroy_meters;
 
-	/* So far only local changes have been made, now need the lock. */
-	ovs_lock();
-
 	vport = new_vport(&parms);
 	if (IS_ERR(vport)) {
 		err = PTR_ERR(vport);
@@ -1725,7 +1725,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				ovs_dp_reset_user_features(skb, info);
 		}
 
-		ovs_unlock();
 		goto err_destroy_meters;
 	}
 
@@ -1742,6 +1741,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 err_destroy_meters:
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

