Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EA86D50EF
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjDCSqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbjDCSqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3094216
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:46:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29014627C1
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04700C433EF;
        Mon,  3 Apr 2023 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680547583;
        bh=F1jGv2H7NT1BBWnFkHQ3ZWoSitR6j0sj1tqIUbyY4Eg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZiOC5IDT5u1LwxMbQZD7X19RTJb1eOzQybXwntZGJxXeAWVweXrj9CnV282uHPtRJ
         pDhdTZA8nJCVitk5OoMUyE5W0ewXjwHIRWSNpSMacKJwYEGQeCfZXpa7xkFE2SeQWH
         9sudR8Gau7Z/f4o9ALIvKkACPbZa0juqbHF/EFbXxgJNdH7+Fh2cEl6BWwhk81VmHH
         2VSpU5ev+1ep3zi8kzbYvXxQMAGADMo+121Rw+HEO6re5f07YmKqo7eTlE8DCx1Tr6
         +ldSMwvKQ40VVXLg1Af46JmPdstJCjobUAkdCBi7ZKP6pYQgF+6hOOckjh/txyl8qb
         sFeRvi2HoQMvQ==
Subject: [PATCH v8 4/4] SUNRPC: Recognize control messages in server-side TCP
 socket code
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        borisp@nvidia.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Mon, 03 Apr 2023 14:46:22 -0400
Message-ID: <168054758210.2138.1989237707178061880.stgit@klimt.1015granger.net>
In-Reply-To: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

To support kTLS, the server-side TCP socket code needs to watch for
CMSGs, just like on the client side.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/net/tls.h             |    2 ++
 include/trace/events/sunrpc.h |   39 +++++++++++++++++++++++++++++++++
 net/sunrpc/svcsock.c          |   49 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 154949c7b0c8..6056ce5a2aa5 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -69,6 +69,8 @@ extern const struct tls_cipher_size_desc tls_cipher_size_desc[];
 
 #define TLS_CRYPTO_INFO_READY(info)	((info)->cipher_type)
 
+#define TLS_RECORD_TYPE_ALERT		0x15
+#define TLS_RECORD_TYPE_HANDSHAKE	0x16
 #define TLS_RECORD_TYPE_DATA		0x17
 
 #define TLS_AAD_SPACE_SIZE		13
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 3ca54536f8f7..3ffb82956bd1 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -49,6 +49,19 @@ TRACE_DEFINE_ENUM(AF_INET6);
 		{ AF_INET,		"AF_INET" },		\
 		{ AF_INET6,		"AF_INET6" })
 
+/*
+ * From https://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml
+ */
+#define rpc_show_tls_content_type(type) \
+	__print_symbolic(type, \
+		{ 20,		"change cipher spec" }, \
+		{ 21,		"alert" }, \
+		{ 22,		"handshake" }, \
+		{ 23,		"application data" }, \
+		{ 24,		"heartbeat" }, \
+		{ 25,		"tls12_cid" }, \
+		{ 26,		"ACK" })
+
 DECLARE_EVENT_CLASS(rpc_xdr_buf_class,
 	TP_PROTO(
 		const struct rpc_task *task,
@@ -2254,6 +2267,32 @@ DECLARE_EVENT_CLASS(svcsock_accept_class,
 DEFINE_ACCEPT_EVENT(accept);
 DEFINE_ACCEPT_EVENT(getpeername);
 
+TRACE_EVENT(svcsock_tls_ctype,
+	TP_PROTO(
+		const struct svc_xprt *xprt,
+		unsigned char ctype
+	),
+
+	TP_ARGS(xprt, ctype),
+
+	TP_STRUCT__entry(
+		SVC_XPRT_ENDPOINT_FIELDS(xprt)
+
+		__field(unsigned long, ctype)
+	),
+
+	TP_fast_assign(
+		SVC_XPRT_ENDPOINT_ASSIGNMENTS(xprt);
+
+		__entry->ctype = ctype;
+	),
+
+	TP_printk(SVC_XPRT_ENDPOINT_FORMAT " %s",
+		SVC_XPRT_ENDPOINT_VARARGS,
+		rpc_show_tls_content_type(__entry->ctype)
+	)
+);
+
 DECLARE_EVENT_CLASS(cache_event,
 	TP_PROTO(
 		const struct cache_detail *cd,
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 03a4f5615086..c8cbe3b5182d 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -43,6 +43,7 @@
 #include <net/udp.h>
 #include <net/tcp.h>
 #include <net/tcp_states.h>
+#include <net/tls.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
 #include <asm/ioctls.h>
@@ -216,6 +217,50 @@ static int svc_one_sock_name(struct svc_sock *svsk, char *buf, int remaining)
 	return len;
 }
 
+static int
+svc_tcp_sock_process_cmsg(struct svc_sock *svsk, struct msghdr *msg,
+			  struct cmsghdr *cmsg, int ret)
+{
+	if (cmsg->cmsg_level == SOL_TLS &&
+	    cmsg->cmsg_type == TLS_GET_RECORD_TYPE) {
+		u8 content_type = *((u8 *)CMSG_DATA(cmsg));
+
+		trace_svcsock_tls_ctype(&svsk->sk_xprt, content_type);
+		switch (content_type) {
+		case TLS_RECORD_TYPE_DATA:
+			/* TLS sets EOR at the end of each application data
+			 * record, even though there might be more frames
+			 * waiting to be decrypted.
+			 */
+			msg->msg_flags &= ~MSG_EOR;
+			break;
+		case TLS_RECORD_TYPE_ALERT:
+			ret = -ENOTCONN;
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	}
+	return ret;
+}
+
+static int
+svc_tcp_sock_recv_cmsg(struct svc_sock *svsk, struct msghdr *msg)
+{
+	union {
+		struct cmsghdr	cmsg;
+		u8		buf[CMSG_SPACE(sizeof(u8))];
+	} u;
+	int ret;
+
+	msg->msg_control = &u;
+	msg->msg_controllen = sizeof(u);
+	ret = sock_recvmsg(svsk->sk_sock, msg, MSG_DONTWAIT);
+	if (unlikely(msg->msg_controllen != sizeof(u)))
+		ret = svc_tcp_sock_process_cmsg(svsk, msg, &u.cmsg, ret);
+	return ret;
+}
+
 #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
 static void svc_flush_bvec(const struct bio_vec *bvec, size_t size, size_t seek)
 {
@@ -263,7 +308,7 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst *rqstp, size_t buflen,
 		iov_iter_advance(&msg.msg_iter, seek);
 		buflen -= seek;
 	}
-	len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
+	len = svc_tcp_sock_recv_cmsg(svsk, &msg);
 	if (len > 0)
 		svc_flush_bvec(bvec, len, seek);
 
@@ -877,7 +922,7 @@ static ssize_t svc_tcp_read_marker(struct svc_sock *svsk,
 		iov.iov_base = ((char *)&svsk->sk_marker) + svsk->sk_tcplen;
 		iov.iov_len  = want;
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, want);
-		len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
+		len = svc_tcp_sock_recv_cmsg(svsk, &msg);
 		if (len < 0)
 			return len;
 		svsk->sk_tcplen += len;


