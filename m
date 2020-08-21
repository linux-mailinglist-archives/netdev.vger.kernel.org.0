Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4DD24D319
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgHUKsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgHUKr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:47:56 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CCECC061388
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:47:55 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 0CDF186BF1;
        Fri, 21 Aug 2020 11:47:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006864; bh=lryyFmy1NCdQp7vGJthyiVU+lTUQJhoa/c0WwS33hmg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=208/9]=20l2tp:=20remove=20tunnel
         =20and=20session=20debug=20flags=20field|Date:=20Fri,=2021=20Aug=2
         02020=2011:47:27=20+0100|Message-Id:=20<20200821104728.23530-9-tpa
         rkin@katalix.com>|In-Reply-To:=20<20200821104728.23530-1-tparkin@k
         atalix.com>|References:=20<20200821104728.23530-1-tparkin@katalix.
         com>;
        b=RNH3pUWelsO5ze6MI7uwDWeHTKth48/GPsMtD2NxwFgm0yT1VWasYX9RqqsM+RUp2
         f2AE6EsnjNF3CdctlACFzOerIsz1/qsv8QRvH0L5KAEy2UzLQ9FNc0OkTTg+qWuMss
         nL4n/GcPnDZlT+GQz2pyUyhxLwdpBCvSH3OOtnFEq5PrhN4wm0uIY9lflncVs8DIup
         UqTkptYIIGBA1P/ghLqjL3OftEsDAPMcur/Meuz4PqZFhn/TLXH1XOHsYWXG81Q++0
         dopblXgYS51r3BZhagocMZTGWBSoGEsjFvrGq3tLe8+NGcYSMKW6wA353ZgdUqcBDP
         GwXtp8+LvzMkA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 8/9] l2tp: remove tunnel and session debug flags field
Date:   Fri, 21 Aug 2020 11:47:27 +0100
Message-Id: <20200821104728.23530-9-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The l2tp subsystem now uses standard kernel logging APIs for
informational and warning messages, and tracepoints for debug
information.

Now that the tunnel and session debug flags are unused, remove the field
from the core structures.

Various system calls (in the case of l2tp_ppp) and netlink messages
handle the getting and setting of debug flags.  To avoid userspace
breakage don't modify the API of these calls; simply ignore set
requests, and send dummy data for get requests.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 include/uapi/linux/if_pppol2tp.h |  2 +-
 include/uapi/linux/l2tp.h        |  6 ++++--
 net/l2tp/l2tp_core.c             |  8 --------
 net/l2tp/l2tp_core.h             |  4 ----
 net/l2tp/l2tp_debugfs.c          |  4 ++--
 net/l2tp/l2tp_netlink.c          | 16 ++--------------
 net/l2tp/l2tp_ppp.c              | 15 ++++++++-------
 7 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/include/uapi/linux/if_pppol2tp.h b/include/uapi/linux/if_pppol2tp.h
index 060b4d1f3129..a91044328bc9 100644
--- a/include/uapi/linux/if_pppol2tp.h
+++ b/include/uapi/linux/if_pppol2tp.h
@@ -75,7 +75,7 @@ struct pppol2tpv3in6_addr {
 };
 
 /* Socket options:
- * DEBUG	- bitmask of debug message categories
+ * DEBUG	- bitmask of debug message categories (not used)
  * SENDSEQ	- 0 => don't send packets with sequence numbers
  *		  1 => send packets with sequence numbers
  * RECVSEQ	- 0 => receive packet sequence numbers are optional
diff --git a/include/uapi/linux/l2tp.h b/include/uapi/linux/l2tp.h
index 61158f5a1a5b..88a0d32b8c07 100644
--- a/include/uapi/linux/l2tp.h
+++ b/include/uapi/linux/l2tp.h
@@ -108,7 +108,7 @@ enum {
 	L2TP_ATTR_VLAN_ID,		/* u16 (not used) */
 	L2TP_ATTR_COOKIE,		/* 0, 4 or 8 bytes */
 	L2TP_ATTR_PEER_COOKIE,		/* 0, 4 or 8 bytes */
-	L2TP_ATTR_DEBUG,		/* u32, enum l2tp_debug_flags */
+	L2TP_ATTR_DEBUG,		/* u32, enum l2tp_debug_flags (not used) */
 	L2TP_ATTR_RECV_SEQ,		/* u8 */
 	L2TP_ATTR_SEND_SEQ,		/* u8 */
 	L2TP_ATTR_LNS_MODE,		/* u8 */
@@ -177,7 +177,9 @@ enum l2tp_seqmode {
 };
 
 /**
- * enum l2tp_debug_flags - debug message categories for L2TP tunnels/sessions
+ * enum l2tp_debug_flags - debug message categories for L2TP tunnels/sessions.
+ *
+ * Unused.
  *
  * @L2TP_MSG_DEBUG: verbose debug (if compiled in)
  * @L2TP_MSG_CONTROL: userspace - kernel interface
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 651c08dc9bcf..e6e26123dee6 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1405,16 +1405,12 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	tunnel->version = version;
 	tunnel->tunnel_id = tunnel_id;
 	tunnel->peer_tunnel_id = peer_tunnel_id;
-	tunnel->debug = L2TP_DEFAULT_DEBUG_FLAGS;
 
 	tunnel->magic = L2TP_TUNNEL_MAGIC;
 	sprintf(&tunnel->name[0], "tunl %u", tunnel_id);
 	rwlock_init(&tunnel->hlist_lock);
 	tunnel->acpt_newsess = true;
 
-	if (cfg)
-		tunnel->debug = cfg->debug;
-
 	tunnel->encap = encap;
 
 	refcount_set(&tunnel->ref_count, 1);
@@ -1612,12 +1608,8 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 		INIT_HLIST_NODE(&session->hlist);
 		INIT_HLIST_NODE(&session->global_hlist);
 
-		/* Inherit debug options from tunnel */
-		session->debug = tunnel->debug;
-
 		if (cfg) {
 			session->pwtype = cfg->pw_type;
-			session->debug = cfg->debug;
 			session->send_seq = cfg->send_seq;
 			session->recv_seq = cfg->recv_seq;
 			session->lns_mode = cfg->lns_mode;
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 7a06ac135a9b..07249c5f22ef 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -51,7 +51,6 @@ struct l2tp_session_cfg {
 	unsigned int		lns_mode:1;	/* behave as LNS?
 						 * LAC enables sequence numbers under LNS control.
 						 */
-	int			debug;		/* bitmask of debug message categories */
 	u16			l2specific_type; /* Layer 2 specific type */
 	u8			cookie[8];	/* optional cookie */
 	int			cookie_len;	/* 0, 4 or 8 bytes */
@@ -98,7 +97,6 @@ struct l2tp_session {
 	unsigned int		lns_mode:1;	/* behave as LNS?
 						 * LAC enables sequence numbers under LNS control.
 						 */
-	int			debug;		/* bitmask of debug message categories */
 	int			reorder_timeout; /* configured reorder timeout (in jiffies) */
 	int			reorder_skip;	/* set if skip to next nr */
 	enum l2tp_pwtype	pwtype;
@@ -132,7 +130,6 @@ struct l2tp_session {
 
 /* L2TP tunnel configuration */
 struct l2tp_tunnel_cfg {
-	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 
 	/* Used only for kernel-created sockets */
@@ -173,7 +170,6 @@ struct l2tp_tunnel {
 	int			version;	/* 2=>L2TPv2, 3=>L2TPv3 */
 
 	char			name[L2TP_TUNNEL_NAME_MAX]; /* for logging */
-	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 	struct l2tp_stats	stats;
 
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 96cb9601c21b..bca75bef8282 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -167,7 +167,7 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 		   tunnel->sock ? refcount_read(&tunnel->sock->sk_refcnt) : 0,
 		   refcount_read(&tunnel->ref_count));
 	seq_printf(m, " %08x rx %ld/%ld/%ld rx %ld/%ld/%ld\n",
-		   tunnel->debug,
+		   0,
 		   atomic_long_read(&tunnel->stats.tx_packets),
 		   atomic_long_read(&tunnel->stats.tx_bytes),
 		   atomic_long_read(&tunnel->stats.tx_errors),
@@ -192,7 +192,7 @@ static void l2tp_dfs_seq_session_show(struct seq_file *m, void *v)
 		   session->recv_seq ? 'R' : '-',
 		   session->send_seq ? 'S' : '-',
 		   session->lns_mode ? "LNS" : "LAC",
-		   session->debug,
+		   0,
 		   jiffies_to_msecs(session->reorder_timeout));
 	seq_printf(m, "   offset 0 l2specific %hu/%hu\n",
 		   session->l2specific_type, l2tp_get_l2specific_len(session));
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index def78eebca4c..31a1e27eab20 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -229,9 +229,6 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 			goto out;
 	}
 
-	if (attrs[L2TP_ATTR_DEBUG])
-		cfg.debug = nla_get_u32(attrs[L2TP_ATTR_DEBUG]);
-
 	ret = -EINVAL;
 	switch (cfg.encap) {
 	case L2TP_ENCAPTYPE_UDP:
@@ -307,9 +304,6 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 		goto out;
 	}
 
-	if (info->attrs[L2TP_ATTR_DEBUG])
-		tunnel->debug = nla_get_u32(info->attrs[L2TP_ATTR_DEBUG]);
-
 	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
 				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
@@ -400,7 +394,7 @@ static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int fla
 	if (nla_put_u8(skb, L2TP_ATTR_PROTO_VERSION, tunnel->version) ||
 	    nla_put_u32(skb, L2TP_ATTR_CONN_ID, tunnel->tunnel_id) ||
 	    nla_put_u32(skb, L2TP_ATTR_PEER_CONN_ID, tunnel->peer_tunnel_id) ||
-	    nla_put_u32(skb, L2TP_ATTR_DEBUG, tunnel->debug) ||
+	    nla_put_u32(skb, L2TP_ATTR_DEBUG, 0) ||
 	    nla_put_u16(skb, L2TP_ATTR_ENCAP_TYPE, tunnel->encap))
 		goto nla_put_failure;
 
@@ -605,9 +599,6 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			cfg.ifname = nla_data(info->attrs[L2TP_ATTR_IFNAME]);
 	}
 
-	if (info->attrs[L2TP_ATTR_DEBUG])
-		cfg.debug = nla_get_u32(info->attrs[L2TP_ATTR_DEBUG]);
-
 	if (info->attrs[L2TP_ATTR_RECV_SEQ])
 		cfg.recv_seq = nla_get_u8(info->attrs[L2TP_ATTR_RECV_SEQ]);
 
@@ -689,9 +680,6 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 		goto out;
 	}
 
-	if (info->attrs[L2TP_ATTR_DEBUG])
-		session->debug = nla_get_u32(info->attrs[L2TP_ATTR_DEBUG]);
-
 	if (info->attrs[L2TP_ATTR_RECV_SEQ])
 		session->recv_seq = nla_get_u8(info->attrs[L2TP_ATTR_RECV_SEQ]);
 
@@ -730,7 +718,7 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 	    nla_put_u32(skb, L2TP_ATTR_SESSION_ID, session->session_id) ||
 	    nla_put_u32(skb, L2TP_ATTR_PEER_CONN_ID, tunnel->peer_tunnel_id) ||
 	    nla_put_u32(skb, L2TP_ATTR_PEER_SESSION_ID, session->peer_session_id) ||
-	    nla_put_u32(skb, L2TP_ATTR_DEBUG, session->debug) ||
+	    nla_put_u32(skb, L2TP_ATTR_DEBUG, 0) ||
 	    nla_put_u16(skb, L2TP_ATTR_PW_TYPE, session->pwtype))
 		goto nla_put_failure;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index bd6bb17dfadb..450637ffa557 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -702,7 +702,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 		if (!tunnel) {
 			struct l2tp_tunnel_cfg tcfg = {
 				.encap = L2TP_ENCAPTYPE_UDP,
-				.debug = 0,
 			};
 
 			/* Prevent l2tp_tunnel_register() from trying to set up
@@ -1147,7 +1146,7 @@ static int pppol2tp_tunnel_setsockopt(struct sock *sk,
 
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
-		tunnel->debug = val;
+		/* Tunnel debug flags option is deprecated */
 		break;
 
 	default:
@@ -1199,7 +1198,7 @@ static int pppol2tp_session_setsockopt(struct sock *sk,
 		break;
 
 	case PPPOL2TP_SO_DEBUG:
-		session->debug = val;
+		/* Session debug flags option is deprecated */
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
@@ -1271,7 +1270,8 @@ static int pppol2tp_tunnel_getsockopt(struct sock *sk,
 
 	switch (optname) {
 	case PPPOL2TP_SO_DEBUG:
-		*val = tunnel->debug;
+		/* Tunnel debug flags option is deprecated */
+		*val = 0;
 		break;
 
 	default:
@@ -1304,7 +1304,8 @@ static int pppol2tp_session_getsockopt(struct sock *sk,
 		break;
 
 	case PPPOL2TP_SO_DEBUG:
-		*val = session->debug;
+		/* Session debug flags option is deprecated */
+		*val = 0;
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
@@ -1496,7 +1497,7 @@ static void pppol2tp_seq_tunnel_show(struct seq_file *m, void *v)
 		   (tunnel == tunnel->sock->sk_user_data) ? 'Y' : 'N',
 		   refcount_read(&tunnel->ref_count) - 1);
 	seq_printf(m, " %08x %ld/%ld/%ld %ld/%ld/%ld\n",
-		   tunnel->debug,
+		   0,
 		   atomic_long_read(&tunnel->stats.tx_packets),
 		   atomic_long_read(&tunnel->stats.tx_bytes),
 		   atomic_long_read(&tunnel->stats.tx_errors),
@@ -1542,7 +1543,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 		   session->recv_seq ? 'R' : '-',
 		   session->send_seq ? 'S' : '-',
 		   session->lns_mode ? "LNS" : "LAC",
-		   session->debug,
+		   0,
 		   jiffies_to_msecs(session->reorder_timeout));
 	seq_printf(m, "   %hu/%hu %ld/%ld/%ld %ld/%ld/%ld\n",
 		   session->nr, session->ns,
-- 
2.17.1

