Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A746824D314
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgHUKr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:47:57 -0400
Received: from mail.katalix.com ([3.9.82.81]:45440 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727824AbgHUKrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 06:47:47 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 9D6E286BE8;
        Fri, 21 Aug 2020 11:47:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598006863; bh=IF0OpCG17juDa0Io64tX1GHARi+wTm4xk8YtXUnq9is=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=205/9]=20l2tp:=20add=20tracepoin
         t=20definitions=20in=20trace.h|Date:=20Fri,=2021=20Aug=202020=2011
         :47:24=20+0100|Message-Id:=20<20200821104728.23530-6-tparkin@katal
         ix.com>|In-Reply-To:=20<20200821104728.23530-1-tparkin@katalix.com
         >|References:=20<20200821104728.23530-1-tparkin@katalix.com>;
        b=LcJzAaHt9eLXYxDbs5cORpu45BbaJUPrf1Z0MsLvSsmSzJ1a/DsD2RuTtVObsFGgC
         5AQbt8ICQGwpJO1u+UwNNU553PsORTBSpKwwuCxzcUt+Q3cYjrqNUx9Wj2X+p1+7Av
         08ZSh4mm6VtQ8BbUgrm3yYz2G1r04YfGI8C6cHRk8nR/ll4rk3A39FbtxxaLoKWCTi
         pHqKgp2ZVOqbPdVhPbLmafSCsViO30QSx60q6UDXzvZj+I6FL/IrwgREME8jBDxRXi
         bwfajaG3jnG/E4hORIu0gzuoFkHDj+az3HuWOKzmmTI7KmW8k0OTuUgpo2ncnM2dBS
         CGBYUZmDzTIkQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 5/9] l2tp: add tracepoint definitions in trace.h
Date:   Fri, 21 Aug 2020 11:47:24 +0100
Message-Id: <20200821104728.23530-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821104728.23530-1-tparkin@katalix.com>
References: <20200821104728.23530-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp can provide a better debug experience using tracepoints rather than
printk-style logging.

Add tracepoint definitions in trace.h for use in the l2tp subsystem
code.

Add preprocessor definitions for the length of session and tunnel names
in l2tp_core.h so we can reuse these in trace.h.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h |   6 +-
 net/l2tp/trace.h     | 196 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 3468d6b177a0..835c4645a0ec 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -66,6 +66,7 @@ struct l2tp_session_cfg {
  * Is linked into a per-tunnel session hashlist; and in the case of an L2TPv3 session into
  * an additional per-net ("global") hashlist.
  */
+#define L2TP_SESSION_NAME_MAX 32
 struct l2tp_session {
 	int			magic;		/* should be L2TP_SESSION_MAGIC */
 	long			dead;
@@ -90,7 +91,7 @@ struct l2tp_session {
 	struct hlist_node	hlist;		/* hash list node */
 	refcount_t		ref_count;
 
-	char			name[32];	/* for logging */
+	char			name[L2TP_SESSION_NAME_MAX]; /* for logging */
 	char			ifname[IFNAMSIZ];
 	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
 	unsigned int		send_seq:1;	/* send packets with sequence numbers? */
@@ -154,6 +155,7 @@ struct l2tp_tunnel_cfg {
  * Maintains a hashlist of sessions belonging to the tunnel instance.
  * Is linked into a per-net list of tunnels.
  */
+#define L2TP_TUNNEL_NAME_MAX 20
 struct l2tp_tunnel {
 	int			magic;		/* Should be L2TP_TUNNEL_MAGIC */
 
@@ -170,7 +172,7 @@ struct l2tp_tunnel {
 	u32			peer_tunnel_id;
 	int			version;	/* 2=>L2TPv2, 3=>L2TPv3 */
 
-	char			name[20];	/* for logging */
+	char			name[L2TP_TUNNEL_NAME_MAX]; /* for logging */
 	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 	struct l2tp_stats	stats;
diff --git a/net/l2tp/trace.h b/net/l2tp/trace.h
index 652778291b77..8596eaa12a2e 100644
--- a/net/l2tp/trace.h
+++ b/net/l2tp/trace.h
@@ -5,6 +5,202 @@
 #if !defined(_TRACE_L2TP_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_L2TP_H
 
+#include <linux/tracepoint.h>
+#include <linux/l2tp.h>
+#include "l2tp_core.h"
+
+#define encap_type_name(e) { L2TP_ENCAPTYPE_##e, #e }
+#define show_encap_type_name(val) \
+	__print_symbolic(val, \
+			encap_type_name(UDP), \
+			encap_type_name(IP))
+
+#define pw_type_name(p) { L2TP_PWTYPE_##p, #p }
+#define show_pw_type_name(val) \
+	__print_symbolic(val, \
+	pw_type_name(ETH_VLAN), \
+	pw_type_name(ETH), \
+	pw_type_name(PPP), \
+	pw_type_name(PPP_AC), \
+	pw_type_name(IP))
+
+DECLARE_EVENT_CLASS(tunnel_only_evt,
+	TP_PROTO(struct l2tp_tunnel *tunnel),
+	TP_ARGS(tunnel),
+	TP_STRUCT__entry(
+		__array(char, name, L2TP_TUNNEL_NAME_MAX)
+	),
+	TP_fast_assign(
+		memcpy(__entry->name, tunnel->name, L2TP_TUNNEL_NAME_MAX);
+	),
+	TP_printk("%s", __entry->name)
+);
+
+DECLARE_EVENT_CLASS(session_only_evt,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session),
+	TP_STRUCT__entry(
+		__array(char, name, L2TP_SESSION_NAME_MAX)
+	),
+	TP_fast_assign(
+		memcpy(__entry->name, session->name, L2TP_SESSION_NAME_MAX);
+	),
+	TP_printk("%s", __entry->name)
+);
+
+TRACE_EVENT(register_tunnel,
+	TP_PROTO(struct l2tp_tunnel *tunnel),
+	TP_ARGS(tunnel),
+	TP_STRUCT__entry(
+		__array(char, name, L2TP_TUNNEL_NAME_MAX)
+		__field(int, fd)
+		__field(u32, tid)
+		__field(u32, ptid)
+		__field(int, version)
+		__field(enum l2tp_encap_type, encap)
+	),
+	TP_fast_assign(
+		memcpy(__entry->name, tunnel->name, L2TP_TUNNEL_NAME_MAX);
+		__entry->fd = tunnel->fd;
+		__entry->tid = tunnel->tunnel_id;
+		__entry->ptid = tunnel->peer_tunnel_id;
+		__entry->version = tunnel->version;
+		__entry->encap = tunnel->encap;
+	),
+	TP_printk("%s: type=%s encap=%s version=L2TPv%d tid=%u ptid=%u fd=%d",
+		__entry->name,
+		__entry->fd > 0 ? "managed" : "unmanaged",
+		show_encap_type_name(__entry->encap),
+		__entry->version,
+		__entry->tid,
+		__entry->ptid,
+		__entry->fd)
+);
+
+DEFINE_EVENT(tunnel_only_evt, delete_tunnel,
+	TP_PROTO(struct l2tp_tunnel *tunnel),
+	TP_ARGS(tunnel)
+);
+
+DEFINE_EVENT(tunnel_only_evt, free_tunnel,
+	TP_PROTO(struct l2tp_tunnel *tunnel),
+	TP_ARGS(tunnel)
+);
+
+TRACE_EVENT(register_session,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session),
+	TP_STRUCT__entry(
+		__array(char, name, L2TP_SESSION_NAME_MAX)
+		__field(u32, tid)
+		__field(u32, ptid)
+		__field(u32, sid)
+		__field(u32, psid)
+		__field(enum l2tp_pwtype, pwtype)
+	),
+	TP_fast_assign(
+		memcpy(__entry->name, session->name, L2TP_SESSION_NAME_MAX);
+		__entry->tid = session->tunnel ? session->tunnel->tunnel_id : 0;
+		__entry->ptid = session->tunnel ? session->tunnel->peer_tunnel_id : 0;
+		__entry->sid = session->session_id;
+		__entry->psid = session->peer_session_id;
+		__entry->pwtype = session->pwtype;
+	),
+	TP_printk("%s: pseudowire=%s sid=%u psid=%u tid=%u ptid=%u",
+		__entry->name,
+		show_pw_type_name(__entry->pwtype),
+		__entry->sid,
+		__entry->psid,
+		__entry->sid,
+		__entry->psid)
+);
+
+DEFINE_EVENT(session_only_evt, delete_session,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session)
+);
+
+DEFINE_EVENT(session_only_evt, free_session,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session)
+);
+
+DEFINE_EVENT(session_only_evt, session_seqnum_lns_enable,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session)
+);
+
+DEFINE_EVENT(session_only_evt, session_seqnum_lns_disable,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session)
+);
+
+DECLARE_EVENT_CLASS(session_seqnum_evt,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session),
+	TP_STRUCT__entry(
+		__array(char, name, L2TP_SESSION_NAME_MAX)
+		__field(u32, ns)
+		__field(u32, nr)
+	),
+	TP_fast_assign(
+		memcpy(__entry->name, session->name, L2TP_SESSION_NAME_MAX);
+		__entry->ns = session->ns;
+		__entry->nr = session->nr;
+	),
+	TP_printk("%s: ns=%u nr=%u",
+		__entry->name,
+		__entry->ns,
+		__entry->nr)
+);
+
+DEFINE_EVENT(session_seqnum_evt, session_seqnum_update,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session)
+);
+
+DEFINE_EVENT(session_seqnum_evt, session_seqnum_reset,
+	TP_PROTO(struct l2tp_session *session),
+	TP_ARGS(session)
+);
+
+DECLARE_EVENT_CLASS(session_pkt_discard_evt,
+	TP_PROTO(struct l2tp_session *session, u32 pkt_ns),
+	TP_ARGS(session, pkt_ns),
+	TP_STRUCT__entry(
+		__array(char, name, L2TP_SESSION_NAME_MAX)
+		__field(u32, pkt_ns)
+		__field(u32, my_nr)
+		__field(u32, reorder_q_len)
+	),
+	TP_fast_assign(
+		memcpy(__entry->name, session->name, L2TP_SESSION_NAME_MAX);
+		__entry->pkt_ns = pkt_ns,
+		__entry->my_nr = session->nr;
+		__entry->reorder_q_len = skb_queue_len(&session->reorder_q);
+	),
+	TP_printk("%s: pkt_ns=%u my_nr=%u reorder_q_len=%u",
+		__entry->name,
+		__entry->pkt_ns,
+		__entry->my_nr,
+		__entry->reorder_q_len)
+);
+
+DEFINE_EVENT(session_pkt_discard_evt, session_pkt_expired,
+	TP_PROTO(struct l2tp_session *session, u32 pkt_ns),
+	TP_ARGS(session, pkt_ns)
+);
+
+DEFINE_EVENT(session_pkt_discard_evt, session_pkt_outside_rx_window,
+	TP_PROTO(struct l2tp_session *session, u32 pkt_ns),
+	TP_ARGS(session, pkt_ns)
+);
+
+DEFINE_EVENT(session_pkt_discard_evt, session_pkt_oos,
+	TP_PROTO(struct l2tp_session *session, u32 pkt_ns),
+	TP_ARGS(session, pkt_ns)
+);
+
 #endif /* _TRACE_L2TP_H */
 
 /* This part must be outside protection */
-- 
2.17.1

