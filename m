Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E242D41BFDF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244690AbhI2H2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:42 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33108 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244648AbhI2H2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:30 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 8D52C214E2; Wed, 29 Sep 2021 15:26:48 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 06/10] mctp: Add tracepoints for tag/key handling
Date:   Wed, 29 Sep 2021 15:26:10 +0800
Message-Id: <20210929072614.854015-7-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

The tag allocation, release and bind events are somewhat opaque outside
the kernel; this change adds a few tracepoints to assist in
instrumentation and debugging.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 include/trace/events/mctp.h | 75 +++++++++++++++++++++++++++++++++++++
 net/mctp/af_mctp.c          |  6 +++
 net/mctp/route.c            | 12 +++++-
 3 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 include/trace/events/mctp.h

diff --git a/include/trace/events/mctp.h b/include/trace/events/mctp.h
new file mode 100644
index 000000000000..175b057c507f
--- /dev/null
+++ b/include/trace/events/mctp.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mctp
+
+#if !defined(_TRACE_MCTP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MCTP_H
+
+#include <linux/tracepoint.h>
+
+#ifndef __TRACE_MCTP_ENUMS
+#define __TRACE_MCTP_ENUMS
+enum {
+	MCTP_TRACE_KEY_TIMEOUT,
+	MCTP_TRACE_KEY_REPLIED,
+	MCTP_TRACE_KEY_INVALIDATED,
+	MCTP_TRACE_KEY_CLOSED,
+};
+#endif /* __TRACE_MCTP_ENUMS */
+
+TRACE_DEFINE_ENUM(MCTP_TRACE_KEY_TIMEOUT);
+TRACE_DEFINE_ENUM(MCTP_TRACE_KEY_REPLIED);
+TRACE_DEFINE_ENUM(MCTP_TRACE_KEY_INVALIDATED);
+TRACE_DEFINE_ENUM(MCTP_TRACE_KEY_CLOSED);
+
+TRACE_EVENT(mctp_key_acquire,
+	TP_PROTO(const struct mctp_sk_key *key),
+	TP_ARGS(key),
+	TP_STRUCT__entry(
+		__field(__u8,	paddr)
+		__field(__u8,	laddr)
+		__field(__u8,	tag)
+	),
+	TP_fast_assign(
+		__entry->paddr = key->peer_addr;
+		__entry->laddr = key->local_addr;
+		__entry->tag = key->tag;
+	),
+	TP_printk("local %d, peer %d, tag %1x",
+		__entry->laddr,
+		__entry->paddr,
+		__entry->tag
+	)
+);
+
+TRACE_EVENT(mctp_key_release,
+	TP_PROTO(const struct mctp_sk_key *key, int reason),
+	TP_ARGS(key, reason),
+	TP_STRUCT__entry(
+		__field(__u8,	paddr)
+		__field(__u8,	laddr)
+		__field(__u8,	tag)
+		__field(int,	reason)
+	),
+	TP_fast_assign(
+		__entry->paddr = key->peer_addr;
+		__entry->laddr = key->local_addr;
+		__entry->tag = key->tag;
+		__entry->reason = reason;
+	),
+	TP_printk("local %d, peer %d, tag %1x %s",
+		__entry->laddr,
+		__entry->paddr,
+		__entry->tag,
+		__print_symbolic(__entry->reason,
+				 { MCTP_TRACE_KEY_TIMEOUT, "timeout" },
+				 { MCTP_TRACE_KEY_REPLIED, "replied" },
+				 { MCTP_TRACE_KEY_INVALIDATED, "invalidated" },
+				 { MCTP_TRACE_KEY_CLOSED, "closed" })
+	)
+);
+
+#endif
+
+#include <trace/define_trace.h>
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 46e5ede385cb..28cb1633bed6 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -16,6 +16,9 @@
 #include <net/mctpdevice.h>
 #include <net/sock.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/mctp.h>
+
 /* socket implementation */
 
 static int mctp_release(struct socket *sock)
@@ -239,6 +242,7 @@ static void mctp_sk_expire_keys(struct timer_list *timer)
 		spin_lock(&key->lock);
 
 		if (!time_after_eq(key->expiry, jiffies)) {
+			trace_mctp_key_release(key, MCTP_TRACE_KEY_TIMEOUT);
 			key->valid = false;
 			hlist_del_rcu(&key->hlist);
 			hlist_del_rcu(&key->sklist);
@@ -310,6 +314,8 @@ static void mctp_sk_unhash(struct sock *sk)
 		hlist_del(&key->sklist);
 		hlist_del(&key->hlist);
 
+		trace_mctp_key_release(key, MCTP_TRACE_KEY_CLOSED);
+
 		spin_lock(&key->lock);
 		if (key->reasm_head)
 			kfree_skb(key->reasm_head);
diff --git a/net/mctp/route.c b/net/mctp/route.c
index c342adf4f97f..acc5bb39e16d 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -23,10 +23,11 @@
 #include <net/netlink.h>
 #include <net/sock.h>
 
+#include <trace/events/mctp.h>
+
 static const unsigned int mctp_message_maxlen = 64 * 1024;
 static const unsigned long mctp_key_lifetime = 6 * CONFIG_HZ;
 
-
 /* route output callbacks */
 static int mctp_route_discard(struct mctp_route *route, struct sk_buff *skb)
 {
@@ -332,6 +333,8 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 				/* we've hit a pending reassembly; not much we
 				 * can do but drop it
 				 */
+				trace_mctp_key_release(key,
+						       MCTP_TRACE_KEY_REPLIED);
 				__mctp_key_unlock_drop(key, net, f);
 				key = NULL;
 			}
@@ -365,12 +368,16 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			if (rc)
 				kfree(key);
 
+			trace_mctp_key_acquire(key);
+
 			/* we don't need to release key->lock on exit */
 			key = NULL;
 
 		} else {
 			if (key->reasm_head || key->reasm_dead) {
 				/* duplicate start? drop everything */
+				trace_mctp_key_release(key,
+						       MCTP_TRACE_KEY_INVALIDATED);
 				__mctp_key_unlock_drop(key, net, f);
 				rc = -EEXIST;
 				key = NULL;
@@ -396,6 +403,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		if (!rc && flags & MCTP_HDR_FLAG_EOM) {
 			sock_queue_rcv_skb(key->sk, key->reasm_head);
 			key->reasm_head = NULL;
+			trace_mctp_key_release(key, MCTP_TRACE_KEY_REPLIED);
 			__mctp_key_unlock_drop(key, net, f);
 			key = NULL;
 		}
@@ -572,6 +580,8 @@ static int mctp_alloc_local_tag(struct mctp_sock *msk,
 	if (tagbits) {
 		key->tag = __ffs(tagbits);
 		mctp_reserve_tag(net, key, msk);
+		trace_mctp_key_acquire(key);
+
 		*tagp = key->tag;
 		rc = 0;
 	}
-- 
2.30.2

