Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A911048C8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUDBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:01:19 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33035 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbfKUDBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:01:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id BC5684AF1E;
        Thu, 21 Nov 2019 14:01:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:mime-version:x-mailer:message-id
        :date:date:subject:subject:from:from:received:received:received;
         s=mail_dkim; t=1574305276; bh=gtlIVY48RyfRp/t62KUQbinD3IsJ7UWlz
        L8VfWzhsog=; b=Gs+OiO9pO6ZvuVjtRFdJNHb5m6zOIRPz9bxXyC2apZfMf2UiP
        f4xxzYLasrNdUoMCSW6NY5X3nwr+AZA05XznY0Dgte3B6yHkO27trz103TTqNwlW
        LytNTuB4G9o0qWRkHgH7Z6KvdZYzuqjMRV/Uq1PqseOpVpT/IiHBaxIXqo=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rhquVEPWG6LG; Thu, 21 Nov 2019 14:01:16 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 691654AF1C;
        Thu, 21 Nov 2019 14:01:16 +1100 (AEDT)
Received: from tipc.example.com (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 513814AED8;
        Thu, 21 Nov 2019 14:01:15 +1100 (AEDT)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
        netdev@vger.kernel.org
Subject: [net-next] tipc: update replicast capability for broadcast send link
Date:   Thu, 21 Nov 2019 10:01:09 +0700
Message-Id: <20191121030109.4754-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up a cluster with non-replicast/replicast capability
supported. This capability will be disabled for broadcast send link
in order to be backwards compatible.

However, when these non-support nodes left and be removed out the cluster=
.
We don't update this capability on broadcast send link. Then, some of
features that based on this capability will also disabling as unexpected.

In this commit, we make sure the broadcast send link capabilities will
be re-calculated as soon as a node removed/rejoined a cluster.

Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/bcast.c | 4 ++--
 net/tipc/bcast.h | 2 +-
 net/tipc/link.c  | 2 +-
 net/tipc/node.c  | 8 +++++++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index f41096a759fa..55aeba681cf4 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -87,9 +87,9 @@ int tipc_bcast_get_mtu(struct net *net)
 	return tipc_link_mss(tipc_bc_sndlink(net));
 }
=20
-void tipc_bcast_disable_rcast(struct net *net)
+void tipc_bcast_toggle_rcast(struct net *net, bool supp)
 {
-	tipc_bc_base(net)->rcast_support =3D false;
+	tipc_bc_base(net)->rcast_support =3D supp;
 }
=20
 static void tipc_bcbase_calc_bc_threshold(struct net *net)
diff --git a/net/tipc/bcast.h b/net/tipc/bcast.h
index dadad953e2be..9e847d9617d3 100644
--- a/net/tipc/bcast.h
+++ b/net/tipc/bcast.h
@@ -85,7 +85,7 @@ void tipc_bcast_remove_peer(struct net *net, struct tip=
c_link *rcv_bcl);
 void tipc_bcast_inc_bearer_dst_cnt(struct net *net, int bearer_id);
 void tipc_bcast_dec_bearer_dst_cnt(struct net *net, int bearer_id);
 int  tipc_bcast_get_mtu(struct net *net);
-void tipc_bcast_disable_rcast(struct net *net);
+void tipc_bcast_toggle_rcast(struct net *net, bool supp);
 int tipc_mcast_xmit(struct net *net, struct sk_buff_head *pkts,
 		    struct tipc_mc_method *method, struct tipc_nlist *dests,
 		    u16 *cong_link_cnt);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index fb72031228c9..24d4d10756d3 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -550,7 +550,7 @@ bool tipc_link_bc_create(struct net *net, u32 ownnode=
, u32 peer,
=20
 	/* Disable replicast if even a single peer doesn't support it */
 	if (link_is_bc_rcvlink(l) && !(peer_caps & TIPC_BCAST_RCAST))
-		tipc_bcast_disable_rcast(net);
+		tipc_bcast_toggle_rcast(net, false);
=20
 	return true;
 }
diff --git a/net/tipc/node.c b/net/tipc/node.c
index aaf595613e6e..ab04e00cb95b 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -496,6 +496,9 @@ struct tipc_node *tipc_node_create(struct net *net, u=
32 addr, u8 *peer_id,
 			tn->capabilities &=3D temp_node->capabilities;
 		}
=20
+		tipc_bcast_toggle_rcast(net,
+					(tn->capabilities & TIPC_BCAST_RCAST));
+
 		goto exit;
 	}
 	n =3D kzalloc(sizeof(*n), GFP_ATOMIC);
@@ -557,6 +560,7 @@ struct tipc_node *tipc_node_create(struct net *net, u=
32 addr, u8 *peer_id,
 	list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
 		tn->capabilities &=3D temp_node->capabilities;
 	}
+	tipc_bcast_toggle_rcast(net, (tn->capabilities & TIPC_BCAST_RCAST));
 	trace_tipc_node_create(n, true, " ");
 exit:
 	spin_unlock_bh(&tn->node_list_lock);
@@ -740,7 +744,8 @@ static bool tipc_node_cleanup(struct tipc_node *peer)
 	list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
 		tn->capabilities &=3D temp_node->capabilities;
 	}
-
+	tipc_bcast_toggle_rcast(peer->net,
+				(tn->capabilities & TIPC_BCAST_RCAST));
 	spin_unlock_bh(&tn->node_list_lock);
 	return deleted;
 }
@@ -2198,6 +2203,7 @@ int tipc_nl_peer_rm(struct sk_buff *skb, struct gen=
l_info *info)
 	list_for_each_entry_rcu(temp_node, &tn->node_list, list) {
 		tn->capabilities &=3D temp_node->capabilities;
 	}
+	tipc_bcast_toggle_rcast(net, (tn->capabilities & TIPC_BCAST_RCAST));
 	err =3D 0;
 err_out:
 	tipc_node_put(peer);
--=20
2.20.1

