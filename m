Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B175407892
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhIKODy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 10:03:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56516 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhIKODx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 10:03:53 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18BCYd9h020862;
        Sat, 11 Sep 2021 14:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=icI4OzlJuvPlxzco+Wt1J38LLdSCpelQqeMeI0FLOVg=;
 b=eqkzyuJvK4ZTWv7Dcj/2jGObqJyIEl19xPv05rfmHA6WVHxLn9km8kMUsZxbNEXz/+Pw
 AU7r99EkrV3OT5uBFZZZE2Z9rk5v9ObO1hQKzWLMI4Q2VZUNlA0Aqhs8lKBeNKEpzDPF
 M+pl0kWthGJI85DEcbJc7kELc2b/psZ1On9Cy0swTVEDVrE8DJd4E9U9bDQmxNFG7y28
 /bM9GaHApdF8ggZiv9ZsCOuNmeJ3cw+KbglNdn0L/jTEf1i/pIxRK1Ahh9VNLHKgpa68
 vFxM/okZayOL1hhMv7Xufys/bnKfLz5oZUfC64bbQKSBdbrEOrOvLeSoWIQ8AkjCJzkJ UA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=icI4OzlJuvPlxzco+Wt1J38LLdSCpelQqeMeI0FLOVg=;
 b=zOGteZSwqU5S1NVtvYhWFXZxitjNKvt9wr5q5SbxgYkiXwNaadImsOiVNioVAUkHRRxp
 R/JlZF7shCmXPNvrSb7zoTy7/TY6ZrGJ1BJnY6+SIYp3FhWJkNic8g2UZrKnH8lz209N
 EY0ZTAeeL19J9Ml4rbekR//OJUic7daAAXfOoSdU2AnYlcpvqtkl52394qbJwkMuLwSD
 dkGp65T0hcs2Uy8WVY9dqPe3yGha2LuUsRp1HduJoMahtG+3TX087HeRaLwc3k2rgLhl
 GlF/E8RmdgnRsnC+X+3N+BGPYtGmRHUYZSzyp/gjnkvoF6a8a4me8fM0Mi0CuLxzb/Yg oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0k210k0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:02:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18BE0NrK101548;
        Sat, 11 Sep 2021 14:02:31 GMT
Received: from lab02.no.oracle.com (lab02.no.oracle.com [10.172.144.56])
        by aserp3030.oracle.com with ESMTP id 3b0jg9vga0-1;
        Sat, 11 Sep 2021 14:02:31 +0000
From:   =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stable@vger.kernel.org, dledford@redhat.com, jgg@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnault@redhat.com
Subject: [PATCH 4.19] netns: protect netns ID lookups with RCU
Date:   Sat, 11 Sep 2021 16:02:29 +0200
Message-Id: <1631368949-22789-1-git-send-email-haakon.bugge@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109110096
X-Proofpoint-GUID: bGx_5KKy-RBlGA93QQ6Ou5PTmV51AxgG
X-Proofpoint-ORIG-GUID: bGx_5KKy-RBlGA93QQ6Ou5PTmV51AxgG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

__peernet2id() can be protected by RCU as it only calls idr_for_each(),
which is RCU-safe, and never modifies the nsid table.

rtnl_net_dumpid() can also do lockless lookups. It does two nested
idr_for_each() calls on nsid tables (one direct call and one indirect
call because of rtnl_net_dumpid_one() calling __peernet2id()). The
netnsid tables are never updated. Therefore it is safe to not take the
nsid_lock and run within an RCU-critical section instead.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

A nice side-effect of replacing spin_{lock,unlock}_bh() with
rcu_spin_{lock,unlock}() in peernet2id() is that it avoids the
situation where SoftIRQs get enabled whilst IRQs are turned off.

From bugzilla.redhat.com/show_bug.cgi?id=1384179 (an ancient
4.9.0-0.rc0 kernel):

dump_stack+0x86/0xc3
__warn+0xcb/0xf0
warn_slowpath_null+0x1d/0x20
__local_bh_enable_ip+0x9d/0xc0
_raw_spin_unlock_bh+0x35/0x40
peernet2id+0x54/0x80
netlink_broadcast_filtered+0x220/0x3c0
netlink_broadcast+0x1d/0x20
audit_log+0x6a/0x90
security_set_bools+0xee/0x200
[]

Note, security_set_bools() calls write_lock_irq(). peernet2id() calls
spin_unlock_bh().

From an internal (UEK) stack trace based on the v4.14.35 kernel (LTS
4.14.231):

queued_spin_lock_slowpath+0xb/0xf
_raw_spin_lock_irqsave+0x46/0x48
send_mad+0x3d2/0x590 [ib_core]
ib_sa_path_rec_get+0x223/0x4d0 [ib_core]
path_rec_start+0xa3/0x140 [ib_ipoib]
ipoib_start_xmit+0x2b0/0x6a0 [ib_ipoib]
dev_hard_start_xmit+0xb2/0x237
sch_direct_xmit+0x114/0x1bf
__dev_queue_xmit+0x592/0x818
dev_queue_xmit+0x10/0x12
arp_xmit+0x38/0xa6
arp_send_dst.part.16+0x61/0x84
arp_process+0x825/0x889
arp_rcv+0x140/0x1c9
__netif_receive_skb_core+0x401/0xb39
__netif_receive_skb+0x18/0x59
netif_receive_skb_internal+0x45/0x119
napi_gro_receive+0xd8/0xf6
ipoib_ib_handle_rx_wc+0x1ca/0x520 [ib_ipoib]
ipoib_poll+0xcd/0x150 [ib_ipoib]
net_rx_action+0x289/0x3f4
__do_softirq+0xe1/0x2b5
do_softirq_own_stack+0x2a/0x35
</IRQ>
do_softirq+0x4d/0x6a
__local_bh_enable_ip+0x57/0x59
_raw_spin_unlock_bh+0x23/0x25
peernet2id+0x51/0x73
netlink_broadcast_filtered+0x223/0x41b
netlink_broadcast+0x1d/0x1f
rdma_nl_multicast+0x22/0x30 [ib_core]
send_mad+0x3e5/0x590 [ib_core]
ib_sa_path_rec_get+0x223/0x4d0 [ib_core]
rdma_resolve_route+0x287/0x810 [rdma_cm]
rds_rdma_cm_event_handler_cmn+0x311/0x7d0 [rds_rdma]
rds_rdma_cm_event_handler_worker+0x22/0x30 [rds_rdma]
process_one_work+0x169/0x3a6
worker_thread+0x4d/0x3e5
kthread+0x105/0x138
ret_from_fork+0x24/0x49

Here, pay attention to ib_nl_make_request() which calls
spin_lock_irqsave() on a global lock just before calling
rdma_nl_multicast(). Thereafter, peernet2id() enables SoftIRQs, and
ipoib starts and calls the same path and ends up trying to acquire the
same global lock again.

(cherry picked from commit 2dce224f469f060b9998a5a869151ef83c08ce77)

Fixes: fba143c66abb ("netns: avoid disabling irq for netns id")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>

Conflicts:
	net/core/net_namespace.c

		* rtnl_valid_dump_net_req() has a very minimal
                  implementation in 4.19, hence only a simple
                  substituting of spin_{lock,unlock}_bh() with
                  rcu_spin_{lock,unlock}() was required
---
 net/core/net_namespace.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 939d8a3..26d70c0 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -192,9 +192,9 @@ static int net_eq_idr(int id, void *net, void *peer)
 	return 0;
 }
 
-/* Should be called with nsid_lock held. If a new id is assigned, the bool alloc
- * is set to true, thus the caller knows that the new id must be notified via
- * rtnl.
+/* Must be called from RCU-critical section or with nsid_lock held. If
+ * a new id is assigned, the bool alloc is set to true, thus the
+ * caller knows that the new id must be notified via rtnl.
  */
 static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 {
@@ -218,7 +218,7 @@ static int __peernet2id_alloc(struct net *net, struct net *peer, bool *alloc)
 	return NETNSA_NSID_NOT_ASSIGNED;
 }
 
-/* should be called with nsid_lock held */
+/* Must be called from RCU-critical section or with nsid_lock held */
 static int __peernet2id(struct net *net, struct net *peer)
 {
 	bool no = false;
@@ -261,9 +261,10 @@ int peernet2id(struct net *net, struct net *peer)
 {
 	int id;
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	id = __peernet2id(net, peer);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
+
 	return id;
 }
 EXPORT_SYMBOL(peernet2id);
@@ -837,6 +838,7 @@ struct rtnl_net_dump_cb {
 	int s_idx;
 };
 
+/* Runs in RCU-critical section. */
 static int rtnl_net_dumpid_one(int id, void *peer, void *data)
 {
 	struct rtnl_net_dump_cb *net_cb = (struct rtnl_net_dump_cb *)data;
@@ -867,9 +869,9 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 		.s_idx = cb->args[0],
 	};
 
-	spin_lock_bh(&net->nsid_lock);
+	rcu_read_lock();
 	idr_for_each(&net->netns_ids, rtnl_net_dumpid_one, &net_cb);
-	spin_unlock_bh(&net->nsid_lock);
+	rcu_read_unlock();
 
 	cb->args[0] = net_cb.idx;
 	return skb->len;
-- 
1.8.3.1

