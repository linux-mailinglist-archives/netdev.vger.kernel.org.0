Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46E4DFBA9
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 04:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfJVC2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 22:28:54 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32768 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727264AbfJVC2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 22:28:54 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 22:28:50 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 51ED24969E;
        Tue, 22 Oct 2019 13:22:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:mime-version:x-mailer:message-id
        :date:date:subject:subject:from:from:received:received:received;
         s=mail_dkim; t=1571710920; bh=K9mk/w5gpus/Bq9beExMG01id6etjdht7
        bwEwxrHNvg=; b=q/8VbfgL3BuhT/raNtekZrCl7VFqJcLRxISmMvC7uyg7bMsco
        hTDlvuivajSBG77daacHKGWyFlnQPNRV+QqGxmycto42S1QRqdxbP58bfI/Dmc5W
        Vi1LOzdy2/zUc6gL00LJxlEa5JvCYfdLoVJ8OMoECO5CpNlEHeffbVhKhs=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NElHPNb_E0r2; Tue, 22 Oct 2019 13:22:00 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 25EBE4A0F0;
        Tue, 22 Oct 2019 13:21:59 +1100 (AEDT)
Received: from dhost.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id D321D4969E;
        Tue, 22 Oct 2019 13:21:58 +1100 (AEDT)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [net-next] tipc: improve throughput between nodes in netns
Date:   Tue, 22 Oct 2019 09:20:36 +0700
Message-Id: <20191022022036.19961-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, TIPC transports intra-node user data messages directly
socket to socket, hence shortcutting all the lower layers of the
communication stack. This gives TIPC very good intra node performance,
both regarding throughput and latency.

We now introduce a similar mechanism for TIPC data traffic across
network namespaces located in the same kernel. On the send path, the
call chain is as always accompanied by the sending node's network name
space pointer. However, once we have reliably established that the
receiving node is represented by a namespace on the same host, we just
replace the namespace pointer with the receiving node/namespace's
ditto, and follow the regular socket receive patch though the receiving
node. This technique gives us a throughput similar to the node internal
throughput, several times larger than if we let the traffic go though
the full network stacks. As a comparison, max throughput for 64k
messages is four times larger than TCP throughput for the same type of
traffic.

To meet any security concerns, the following should be noted.

- All nodes joining a cluster are supposed to have been be certified
and authenticated by mechanisms outside TIPC. This is no different for
nodes/namespaces on the same host; they have to auto discover each
other using the attached interfaces, and establish links which are
supervised via the regular link monitoring mechanism. Hence, a kernel
local node has no other way to join a cluster than any other node, and
have to obey to policies set in the IP or device layers of the stack.

- Only when a sender has established with 100% certainty that the peer
node is located in a kernel local namespace does it choose to let user
data messages, and only those, take the crossover path to the receiving
node/namespace.

- If the receiving node/namespace is removed, its namespace pointer
is invalidated at all peer nodes, and their neighbor link monitoring
will eventually note that this node is gone.

- To ensure the "100% certainty" criteria, and prevent any possible
spoofing, received discovery messages must contain a proof that the
sender knows a common secret. We use the hash mix of the sending
node/namespace for this purpose, since it can be accessed directly by
all other namespaces in the kernel. Upon reception of a discovery
message, the receiver checks this proof against all the local
namespaces'hash_mix:es. If it finds a match, that, along with a
matching node id and cluster id, this is deemed sufficient proof that
the peer node in question is in a local namespace, and a wormhole can
be opened.

- We should also consider that TIPC is intended to be a cluster local
IPC mechanism (just like e.g. UNIX sockets) rather than a network
protocol, and hence we think it can justified to allow it to shortcut the
lower protocol layers.

Regarding traceability, we should notice that since commit 6c9081a3915d
("tipc: add loopback device tracking") it is possible to follow the node
internal packet flow by just activating tcpdump on the loopback
interface. This will be true even for this mechanism; by activating
tcpdump on the involved nodes' loopback interfaces their inter-name
space messaging can easily be tracked.

Suggested-by: Jon Maloy <jon.maloy@ericsson.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/discover.c   |  10 ++++-
 net/tipc/msg.h        |  10 +++++
 net/tipc/name_distr.c |   2 +-
 net/tipc/node.c       | 100 ++++++++++++++++++++++++++++++++++++++++--
 net/tipc/node.h       |   4 +-
 net/tipc/socket.c     |   6 +--
 6 files changed, 121 insertions(+), 11 deletions(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index c138d68e8a69..338d402fcf39 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -38,6 +38,8 @@
 #include "node.h"
 #include "discover.h"
=20
+#include <net/netns/hash.h>
+
 /* min delay during bearer start up */
 #define TIPC_DISC_INIT	msecs_to_jiffies(125)
 /* max delay if bearer has no links */
@@ -83,6 +85,7 @@ static void tipc_disc_init_msg(struct net *net, struct =
sk_buff *skb,
 	struct tipc_net *tn =3D tipc_net(net);
 	u32 dest_domain =3D b->domain;
 	struct tipc_msg *hdr;
+	u32 hash;
=20
 	hdr =3D buf_msg(skb);
 	tipc_msg_init(tn->trial_addr, hdr, LINK_CONFIG, mtyp,
@@ -94,6 +97,10 @@ static void tipc_disc_init_msg(struct net *net, struct=
 sk_buff *skb,
 	msg_set_dest_domain(hdr, dest_domain);
 	msg_set_bc_netid(hdr, tn->net_id);
 	b->media->addr2msg(msg_media_addr(hdr), &b->addr);
+	hash =3D tn->random;
+	hash ^=3D net_hash_mix(&init_net);
+	hash ^=3D net_hash_mix(net);
+	msg_set_peer_net_hash(hdr, hash);
 	msg_set_node_id(hdr, tipc_own_id(net));
 }
=20
@@ -242,7 +249,8 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *s=
kb,
 	if (!tipc_in_scope(legacy, b->domain, src))
 		return;
 	tipc_node_check_dest(net, src, peer_id, b, caps, signature,
-			     &maddr, &respond, &dupl_addr);
+			     msg_peer_net_hash(hdr), &maddr, &respond,
+			     &dupl_addr);
 	if (dupl_addr)
 		disc_dupl_alert(b, src, &maddr);
 	if (!respond)
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 0daa6f04ca81..a8d0f28094f2 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -973,6 +973,16 @@ static inline void msg_set_grp_remitted(struct tipc_=
msg *m, u16 n)
 	msg_set_bits(m, 9, 16, 0xffff, n);
 }
=20
+static inline void msg_set_peer_net_hash(struct tipc_msg *m, u32 n)
+{
+	msg_set_word(m, 9, n);
+}
+
+static inline u32 msg_peer_net_hash(struct tipc_msg *m)
+{
+	return msg_word(m, 9);
+}
+
 /* Word 10
  */
 static inline u16 msg_grp_evt(struct tipc_msg *m)
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 836e629e8f4a..5feaf3b67380 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -146,7 +146,7 @@ static void named_distribute(struct net *net, struct =
sk_buff_head *list,
 	struct publication *publ;
 	struct sk_buff *skb =3D NULL;
 	struct distr_item *item =3D NULL;
-	u32 msg_dsz =3D ((tipc_node_get_mtu(net, dnode, 0) - INT_H_SIZE) /
+	u32 msg_dsz =3D ((tipc_node_get_mtu(net, dnode, 0, false) - INT_H_SIZE)=
 /
 			ITEM_SIZE) * ITEM_SIZE;
 	u32 msg_rem =3D msg_dsz;
=20
diff --git a/net/tipc/node.c b/net/tipc/node.c
index f2e3cf70c922..d830c2d1dbe3 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -45,6 +45,8 @@
 #include "netlink.h"
 #include "trace.h"
=20
+#include <net/netns/hash.h>
+
 #define INVALID_NODE_SIG	0x10000
 #define NODE_CLEANUP_AFTER	300000
=20
@@ -126,6 +128,7 @@ struct tipc_node {
 	struct timer_list timer;
 	struct rcu_head rcu;
 	unsigned long delete_at;
+	struct net *pnet;
 };
=20
 /* Node FSM states and events:
@@ -184,7 +187,7 @@ static struct tipc_link *node_active_link(struct tipc=
_node *n, int sel)
 	return n->links[bearer_id].link;
 }
=20
-int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel)
+int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel, bool connected=
)
 {
 	struct tipc_node *n;
 	int bearer_id;
@@ -194,6 +197,14 @@ int tipc_node_get_mtu(struct net *net, u32 addr, u32=
 sel)
 	if (unlikely(!n))
 		return mtu;
=20
+	/* Allow MAX_MSG_SIZE when building connection oriented message
+	 * if they are in the same core network
+	 */
+	if (n->pnet && connected) {
+		tipc_node_put(n);
+		return mtu;
+	}
+
 	bearer_id =3D n->active_links[sel & 1];
 	if (likely(bearer_id !=3D INVALID_BEARER_ID))
 		mtu =3D n->links[bearer_id].mtu;
@@ -361,12 +372,16 @@ static void tipc_node_write_unlock(struct tipc_node=
 *n)
 }
=20
 static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
-					  u8 *peer_id, u16 capabilities)
+					  u8 *peer_id, u16 capabilities,
+					  u32 signature, u32 hash_mixes)
 {
 	struct tipc_net *tn =3D net_generic(net, tipc_net_id);
 	struct tipc_node *n, *temp_node;
+	struct tipc_net *tn_peer;
 	struct tipc_link *l;
+	struct net *tmp;
 	int bearer_id;
+	u32 hash_chk;
 	int i;
=20
 	spin_lock_bh(&tn->node_list_lock);
@@ -400,6 +415,25 @@ static struct tipc_node *tipc_node_create(struct net=
 *net, u32 addr,
 	memcpy(&n->peer_id, peer_id, 16);
 	n->net =3D net;
 	n->capabilities =3D capabilities;
+	n->pnet =3D NULL;
+	for_each_net_rcu(tmp) {
+		tn_peer =3D net_generic(tmp, tipc_net_id);
+		if (!tn_peer)
+			continue;
+		/* Integrity checking whether node exists in namespace or not */
+		if (tn_peer->net_id !=3D tn->net_id)
+			continue;
+		if (memcmp(peer_id, tn_peer->node_id, NODE_ID_LEN))
+			continue;
+
+		hash_chk =3D tn_peer->random;
+		hash_chk ^=3D net_hash_mix(&init_net);
+		hash_chk ^=3D net_hash_mix(tmp);
+		if (hash_chk ^ hash_mixes)
+			continue;
+		n->pnet =3D tmp;
+		break;
+	}
 	kref_init(&n->kref);
 	rwlock_init(&n->lock);
 	INIT_HLIST_NODE(&n->hash);
@@ -979,7 +1013,7 @@ u32 tipc_node_try_addr(struct net *net, u8 *id, u32 =
addr)
=20
 void tipc_node_check_dest(struct net *net, u32 addr,
 			  u8 *peer_id, struct tipc_bearer *b,
-			  u16 capabilities, u32 signature,
+			  u16 capabilities, u32 signature, u32 hash_mixes,
 			  struct tipc_media_addr *maddr,
 			  bool *respond, bool *dupl_addr)
 {
@@ -998,7 +1032,8 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	*dupl_addr =3D false;
 	*respond =3D false;
=20
-	n =3D tipc_node_create(net, addr, peer_id, capabilities);
+	n =3D tipc_node_create(net, addr, peer_id, capabilities, signature,
+			     hash_mixes);
 	if (!n)
 		return;
=20
@@ -1424,6 +1459,52 @@ static int __tipc_nl_add_node(struct tipc_nl_msg *=
msg, struct tipc_node *node)
 	return -EMSGSIZE;
 }
=20
+static void tipc_lxc_xmit(struct net *pnet, struct sk_buff_head *list)
+{
+	struct tipc_msg *hdr =3D buf_msg(skb_peek(list));
+	struct sk_buff_head inputq;
+
+	switch (msg_user(hdr)) {
+	case TIPC_LOW_IMPORTANCE:
+	case TIPC_MEDIUM_IMPORTANCE:
+	case TIPC_HIGH_IMPORTANCE:
+	case TIPC_CRITICAL_IMPORTANCE:
+		if (msg_connected(hdr) || msg_named(hdr)) {
+			spin_lock_init(&list->lock);
+			tipc_sk_rcv(pnet, list);
+			return;
+		}
+		if (msg_mcast(hdr)) {
+			skb_queue_head_init(&inputq);
+			tipc_sk_mcast_rcv(pnet, list, &inputq);
+			__skb_queue_purge(list);
+			skb_queue_purge(&inputq);
+			return;
+		}
+		return;
+	case MSG_FRAGMENTER:
+		if (tipc_msg_assemble(list)) {
+			skb_queue_head_init(&inputq);
+			tipc_sk_mcast_rcv(pnet, list, &inputq);
+			__skb_queue_purge(list);
+			skb_queue_purge(&inputq);
+		}
+		return;
+	case GROUP_PROTOCOL:
+	case CONN_MANAGER:
+		spin_lock_init(&list->lock);
+		tipc_sk_rcv(pnet, list);
+		return;
+	case LINK_PROTOCOL:
+	case NAME_DISTRIBUTOR:
+	case TUNNEL_PROTOCOL:
+	case BCAST_PROTOCOL:
+		return;
+	default:
+		return;
+	};
+}
+
 /**
  * tipc_node_xmit() is the general link level function for message sendi=
ng
  * @net: the applicable net namespace
@@ -1439,6 +1520,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_=
head *list,
 	struct tipc_link_entry *le =3D NULL;
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
+	bool node_up =3D false;
 	int bearer_id;
 	int rc;
=20
@@ -1455,6 +1537,16 @@ int tipc_node_xmit(struct net *net, struct sk_buff=
_head *list,
 		return -EHOSTUNREACH;
 	}
=20
+	node_up =3D node_is_up(n);
+	if (node_up && n->pnet && check_net(n->pnet)) {
+		/* xmit inner linux container */
+		tipc_lxc_xmit(n->pnet, list);
+		if (likely(skb_queue_empty(list))) {
+			tipc_node_put(n);
+			return 0;
+		}
+	}
+
 	tipc_node_read_lock(n);
 	bearer_id =3D n->active_links[selector & 1];
 	if (unlikely(bearer_id =3D=3D INVALID_BEARER_ID)) {
diff --git a/net/tipc/node.h b/net/tipc/node.h
index 291d0ecd4101..2557d40fd417 100644
--- a/net/tipc/node.h
+++ b/net/tipc/node.h
@@ -75,7 +75,7 @@ u32 tipc_node_get_addr(struct tipc_node *node);
 u32 tipc_node_try_addr(struct net *net, u8 *id, u32 addr);
 void tipc_node_check_dest(struct net *net, u32 onode, u8 *peer_id128,
 			  struct tipc_bearer *bearer,
-			  u16 capabilities, u32 signature,
+			  u16 capabilities, u32 signature, u32 hash_mixes,
 			  struct tipc_media_addr *maddr,
 			  bool *respond, bool *dupl_addr);
 void tipc_node_delete_links(struct net *net, int bearer_id);
@@ -92,7 +92,7 @@ void tipc_node_unsubscribe(struct net *net, struct list=
_head *subscr, u32 addr);
 void tipc_node_broadcast(struct net *net, struct sk_buff *skb);
 int tipc_node_add_conn(struct net *net, u32 dnode, u32 port, u32 peer_po=
rt);
 void tipc_node_remove_conn(struct net *net, u32 dnode, u32 port);
-int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel);
+int tipc_node_get_mtu(struct net *net, u32 addr, u32 sel, bool connected=
);
 bool tipc_node_is_up(struct net *net, u32 addr);
 u16 tipc_node_get_capabilities(struct net *net, u32 addr);
 int tipc_nl_node_dump(struct sk_buff *skb, struct netlink_callback *cb);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index d579b64705b1..d34bd2e36050 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -854,7 +854,7 @@ static int tipc_send_group_msg(struct net *net, struc=
t tipc_sock *tsk,
=20
 	/* Build message as chain of buffers */
 	__skb_queue_head_init(&pkts);
-	mtu =3D tipc_node_get_mtu(net, dnode, tsk->portid);
+	mtu =3D tipc_node_get_mtu(net, dnode, tsk->portid, false);
 	rc =3D tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc !=3D dlen))
 		return rc;
@@ -1388,7 +1388,7 @@ static int __tipc_sendmsg(struct socket *sock, stru=
ct msghdr *m, size_t dlen)
 		return rc;
=20
 	__skb_queue_head_init(&pkts);
-	mtu =3D tipc_node_get_mtu(net, dnode, tsk->portid);
+	mtu =3D tipc_node_get_mtu(net, dnode, tsk->portid, false);
 	rc =3D tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc !=3D dlen))
 		return rc;
@@ -1526,7 +1526,7 @@ static void tipc_sk_finish_conn(struct tipc_sock *t=
sk, u32 peer_port,
 	sk_reset_timer(sk, &sk->sk_timer, jiffies + CONN_PROBING_INTV);
 	tipc_set_sk_state(sk, TIPC_ESTABLISHED);
 	tipc_node_add_conn(net, peer_node, tsk->portid, peer_port);
-	tsk->max_pkt =3D tipc_node_get_mtu(net, peer_node, tsk->portid);
+	tsk->max_pkt =3D tipc_node_get_mtu(net, peer_node, tsk->portid, true);
 	tsk->peer_caps =3D tipc_node_get_capabilities(net, peer_node);
 	__skb_queue_purge(&sk->sk_write_queue);
 	if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
--=20
2.20.1

