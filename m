Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F060230E998
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhBDBt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:49:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233218AbhBDBt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 20:49:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612403312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4XEMHF1mP4DsRxVnHlZa06ZthIOc9catFtAT0yfOnXE=;
        b=fhSN6MStj06RIslGo/k5sfJL0zPFhEtti68PF4E3KvA3Ev5QZCsU6aVAW6QaheiJo7c1zN
        qe67GjtFFsgQav6jKtIO0Y2Epzgl6iuzWtb9oJNVRv/jw2B0/S+zyvbw2i3JXsETucPkeN
        3CA/Ojh6plDs7uzG7lZ9N96miFwJSTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-xYRud-VNMkKp2T98O8LIDg-1; Wed, 03 Feb 2021 20:48:30 -0500
X-MC-Unique: xYRud-VNMkKp2T98O8LIDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD19015721;
        Thu,  4 Feb 2021 01:48:29 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-166.rdu2.redhat.com [10.10.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52B705D9EF;
        Thu,  4 Feb 2021 01:48:29 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id A6842C2CDA; Wed,  3 Feb 2021 22:48:26 -0300 (-03)
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next v2] netlink: add tracepoint at NL_SET_ERR_MSG
Date:   Wed,  3 Feb 2021 22:48:16 -0300
Message-Id: <4546b63e67b2989789d146498b13cc09e1fdc543.1612403190.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Often userspace won't request the extack information, or they don't log it
because of log level or so, and even when they do, sometimes it's not
enough to know exactly what caused the error.

Netlink extack is the standard way of reporting erros with descriptive
error messages. With a trace point on it, we then can know exactly where
the error happened, regardless of userspace app. Also, we can even see if
the err msg was overwritten.

The wrapper do_trace_netlink_extack() is because trace points shouldn't be
called from .h files, as trace points are not that small, and the function
call to do_trace_netlink_extack() on the macros is not protected by
tracepoint_enabled() because the macros are called from modules, and this
would require exporting some trace structs. As this is error path, it's
better to export just the wrapper instead.

v2: removed leftover tracepoint declaration
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/linux/netlink.h        |  6 ++++++
 include/trace/events/netlink.h | 29 +++++++++++++++++++++++++++++
 net/netlink/af_netlink.c       |  8 ++++++++
 3 files changed, 43 insertions(+)
 create mode 100644 include/trace/events/netlink.h

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 9f118771e24808623287d46157046749ec96a2b5..0bcf98098c5a01dd3e2c373692d8f28c6dc5e0f8 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -11,6 +11,8 @@
 
 struct net;
 
+void do_trace_netlink_extack(const char *msg);
+
 static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
 {
 	return (struct nlmsghdr *)skb->data;
@@ -90,6 +92,8 @@ struct netlink_ext_ack {
 	static const char __msg[] = msg;		\
 	struct netlink_ext_ack *__extack = (extack);	\
 							\
+	do_trace_netlink_extack(__msg);			\
+							\
 	if (__extack)					\
 		__extack->_msg = __msg;			\
 } while (0)
@@ -110,6 +114,8 @@ struct netlink_ext_ack {
 	static const char __msg[] = msg;			\
 	struct netlink_ext_ack *__extack = (extack);		\
 								\
+	do_trace_netlink_extack(__msg);				\
+								\
 	if (__extack) {						\
 		__extack->_msg = __msg;				\
 		__extack->bad_attr = (attr);			\
diff --git a/include/trace/events/netlink.h b/include/trace/events/netlink.h
new file mode 100644
index 0000000000000000000000000000000000000000..3b7be3b386a4f3976738a107fe4b7e0915ae58bb
--- /dev/null
+++ b/include/trace/events/netlink.h
@@ -0,0 +1,29 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM netlink
+
+#if !defined(_TRACE_NETLINK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NETLINK_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(netlink_extack,
+
+	TP_PROTO(const char *msg),
+
+	TP_ARGS(msg),
+
+	TP_STRUCT__entry(
+		__string(	msg,	msg	)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg, msg);
+	),
+
+	TP_printk("msg=%s", __get_str(msg))
+);
+
+#endif /* _TRACE_NETLINK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index daca50d6bb1283f3b04b585217f2aea6ba279b8b..dd488938447f9735daf1fb727c339a9874bab38b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -67,6 +67,8 @@
 #include <net/sock.h>
 #include <net/scm.h>
 #include <net/netlink.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/netlink.h>
 
 #include "af_netlink.h"
 
@@ -147,6 +149,12 @@ static BLOCKING_NOTIFIER_HEAD(netlink_chain);
 
 static const struct rhashtable_params netlink_rhashtable_params;
 
+void do_trace_netlink_extack(const char *msg)
+{
+	trace_netlink_extack(msg);
+}
+EXPORT_SYMBOL(do_trace_netlink_extack);
+
 static inline u32 netlink_group_mask(u32 group)
 {
 	return group ? 1 << (group - 1) : 0;
-- 
2.29.2

