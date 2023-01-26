Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD667D0D5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjAZQCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjAZQCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:02:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BBD53B21
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:02:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50C8618B8
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED29C433EF;
        Thu, 26 Jan 2023 16:02:30 +0000 (UTC)
Subject: [PATCH v2 3/3] net/tls: Support AF_HANDSHAKE in kTLS
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com, bcodding@redhat.com,
        jlayton@redhat.com
Date:   Thu, 26 Jan 2023 11:02:29 -0500
Message-ID: <167474894957.5189.5031816070836427226.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable kernel consumers of TLS to request a TLS handshake, add
support to net/tls/ to send a handshake upcall.

This patch also acts as a template for adding handshake upcall
support to other transport layer security mechanisms.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/net/tls.h              |   16 ++
 include/uapi/linux/handshake.h |   24 ++
 net/handshake/netlink.c        |   18 ++
 net/tls/Makefile               |    2 
 net/tls/tls_handshake.c        |  385 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 444 insertions(+), 1 deletion(-)
 create mode 100644 net/tls/tls_handshake.c

diff --git a/include/net/tls.h b/include/net/tls.h
index 154949c7b0c8..5156c3a80faa 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -512,4 +512,20 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
 #endif
+
+#define TLS_DEFAULT_PRIORITIES		(NULL)
+
+int tls_client_hello_anon(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities);
+int tls_client_hello_x509(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities, key_serial_t cert,
+			  key_serial_t privkey);
+int tls_client_hello_psk(struct socket *sock,
+			 void (*done)(void *data, int status), void *data,
+			 const char *priorities, key_serial_t peerid);
+int tls_server_hello(struct socket *sock, void (*done)(void *data, int status),
+		     void *data, const char *priorities);
+
 #endif /* _TLS_OFFLOAD_H */
diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
index 72facc352c71..ec3f4a5e465f 100644
--- a/include/uapi/linux/handshake.h
+++ b/include/uapi/linux/handshake.h
@@ -18,8 +18,26 @@
 
 enum handshake_protocol {
 	HANDSHAKE_PROTO_UNSPEC = 0,
+	HANDSHAKE_PROTO_TLS_13,
 };
 
+enum handshake_type {
+	HANDSHAKE_TYPE_UNSPEC = 0,
+	HANDSHAKE_TYPE_CLIENTHELLO,
+	HANDSHAKE_TYPE_SERVERHELLO,
+};
+
+enum handshake_auth_type {
+	HANDSHAKE_AUTHTYPE_UNSPEC = 0,
+	HANDSHAKE_AUTHTYPE_UNAUTH,
+	HANDSHAKE_AUTHTYPE_X509,
+	HANDSHAKE_AUTHTYPE_PSK,
+};
+
+#define HANDSHAKE_NO_PEERID		(0)
+#define HANDSHAKE_NO_CERT		(0)
+#define HANDSHAKE_NO_PRIVKEY		(0)
+
 #define HANDSHAKE_GENL_NAME	"HANDSHAKE_GENL"
 #define HANDSHAKE_GENL_VERSION	0x01
 
@@ -28,6 +46,12 @@ enum handshake_genl_attrs {
 	HANDSHAKE_GENL_ATTR_SOCKFD,
 	HANDSHAKE_GENL_ATTR_STATUS,
 	HANDSHAKE_GENL_ATTR_PROTOCOL,
+	HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+	HANDSHAKE_GENL_ATTR_AUTH_TYPE,
+	HANDSHAKE_GENL_ATTR_TLS_PRIORITIES,
+	HANDSHAKE_GENL_ATTR_X509_CERT_SERIAL,
+	HANDSHAKE_GENL_ATTR_X509_PRIVKEY_SERIAL,
+	HANDSHAKE_GENL_ATTR_PSK_SERIAL,
 	__HANDSHAKE_GENL_ATTR_MAX
 };
 #define HANDSHAKE_GENL_ATTR_MAX	(__HANDSHAKE_GENL_ATTR_MAX - 1)
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 1d209473f106..d993f284ae0a 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -132,6 +132,24 @@ handshake_genl_policy[HANDSHAKE_GENL_ATTR_MAX + 1] = {
 	[HANDSHAKE_GENL_ATTR_PROTOCOL] = {
 		.type = NLA_U32
 	},
+	[HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_AUTH_TYPE] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_TLS_PRIORITIES] = {
+		.type = NLA_STRING
+	},
+	[HANDSHAKE_GENL_ATTR_X509_CERT_SERIAL] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_X509_PRIVKEY_SERIAL] = {
+		.type = NLA_U32
+	},
+	[HANDSHAKE_GENL_ATTR_PSK_SERIAL] = {
+		.type = NLA_U32
+	},
 };
 
 static const struct genl_ops handshake_genl_ops[] = {
diff --git a/net/tls/Makefile b/net/tls/Makefile
index e41c800489ac..7e56b57f14f6 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
+tls-y := tls_handshake.o tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_handshake.c b/net/tls/tls_handshake.c
new file mode 100644
index 000000000000..c718cafd8676
--- /dev/null
+++ b/net/tls/tls_handshake.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Establish a TLS session for a kernel socket consumer
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2021-2023, Oracle and/or its affiliates.
+ */
+
+/**
+ * DOC: kTLS handshake overview
+ *
+ * When a kernel TLS consumer wants to establish a TLS session, it
+ * makes an AF_TLSH Listener ready. When user space accepts on that
+ * listener, the kernel fabricates a user space socket endpoint on
+ * which a user space TLS library can perform the TLS handshake.
+ *
+ * Closing the user space descriptor signals to the kernel that the
+ * library handshake process is complete. If the library has managed
+ * to initialize the socket's TLS crypto_info, the kernel marks the
+ * handshake as a success.
+ */
+
+#include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <net/sock.h>
+
+#include <net/tls.h>
+#include <net/handshake.h>
+
+#include <uapi/linux/handshake.h>
+
+static void tlsh_handshake_done(struct handshake_info *hsi);
+
+struct tlsh_sock_info {
+	struct handshake_info	tsi_handshake_info;
+
+	void			(*tsi_handshake_done)(void *data, int status);
+	void			*tsi_handshake_data;
+
+	char			*tsi_tls_priorities;
+	key_serial_t		tsi_peerid;
+	key_serial_t		tsi_certificate;
+	key_serial_t		tsi_privkey;
+
+};
+
+static struct tlsh_sock_info *tlsh_sock_info_alloc(struct socket *sock,
+						   const char *priorities)
+{
+	struct tlsh_sock_info *tsi;
+
+	tsi = kzalloc(sizeof(*tsi), GFP_KERNEL);
+	if (!tsi)
+		return NULL;
+
+	if (priorities != TLS_DEFAULT_PRIORITIES && strlen(priorities)) {
+		tsi->tsi_tls_priorities = kstrdup(priorities, GFP_KERNEL);
+		if (!tsi->tsi_tls_priorities) {
+			kfree(tsi);
+			return NULL;
+		}
+	}
+
+	tsi->tsi_handshake_info.hi_done = tlsh_handshake_done,
+	tsi->tsi_handshake_info.hi_data = sock->sk;
+	tsi->tsi_peerid = HANDSHAKE_NO_PEERID;
+	tsi->tsi_certificate = HANDSHAKE_NO_CERT;
+	tsi->tsi_privkey = HANDSHAKE_NO_PRIVKEY;
+	return tsi;
+}
+
+static void tlsh_sock_info_free(struct tlsh_sock_info *tsi)
+{
+	if (tsi)
+		kfree(tsi->tsi_tls_priorities);
+	kfree(tsi);
+}
+
+static bool tlsh_crypto_info_initialized(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+
+	return ctx &&
+		TLS_CRYPTO_INFO_READY(&ctx->crypto_send.info) &&
+		TLS_CRYPTO_INFO_READY(&ctx->crypto_recv.info);
+}
+
+/**
+ * tlsh_handshake_done - call the handshake "done" callback for @sk.
+ * @hsi: socket on which the handshake was performed
+ *
+ */
+static void tlsh_handshake_done(struct handshake_info *hsi)
+{
+	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
+						  tsi_handshake_info);
+	void (*done)(void *data, int status) = tsi->tsi_handshake_done;
+	struct sock *sk = hsi->hi_data;
+
+	done(tsi->tsi_handshake_data,
+	     tlsh_crypto_info_initialized(sk) ? 0 : -EACCES);
+	tlsh_sock_info_free(tsi);
+}
+
+/*
+ * Specifically for kernel TLS consumers: enable only TLS v1.3 and the
+ * ciphers that are supported by kTLS.
+ *
+ * This list is generated by hand from the supported ciphers found
+ * in include/uapi/linux/tls.h.
+ */
+#define KTLS_PRIORITIES \
+	"SECURE256:+SECURE128:-COMP-ALL" \
+	":-VERS-ALL:+VERS-TLS1.3:%NO_TICKETS" \
+	":-CIPHER-ALL:+CHACHA20-POLY1305:+AES-256-GCM:+AES-128-GCM:+AES-128-CCM"
+
+static int tlsh_genl_tls_priorities(struct sk_buff *msg,
+				    struct tlsh_sock_info *tsi)
+{
+	int ret;
+
+	if (tsi->tsi_tls_priorities)
+		ret = nla_put(msg, HANDSHAKE_GENL_ATTR_TLS_PRIORITIES,
+			      strlen(tsi->tsi_tls_priorities),
+			      tsi->tsi_tls_priorities);
+	else
+		ret = nla_put(msg, HANDSHAKE_GENL_ATTR_TLS_PRIORITIES,
+			      strlen(KTLS_PRIORITIES), KTLS_PRIORITIES);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static int tlsh_genl_ch_anon_reply(struct sk_buff *msg,
+				   struct handshake_info *hsi)
+{
+	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
+						  tsi_handshake_info);
+	int ret;
+
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_PROTOCOL,
+			  HANDSHAKE_PROTO_TLS_13);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  HANDSHAKE_TYPE_CLIENTHELLO);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_AUTH_TYPE,
+			  HANDSHAKE_AUTHTYPE_UNAUTH);
+	if (ret < 0)
+		return ret;
+	return tlsh_genl_tls_priorities(msg, tsi);
+}
+
+/**
+ * tls_client_hello_anon - request an anonymous TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string, or NULL
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_anon(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities)
+{
+	struct tlsh_sock_info *tsi;
+	int rc;
+
+	tsi = tlsh_sock_info_alloc(sock, priorities);
+	if (!tsi)
+		return -ENOMEM;
+
+
+	tsi->tsi_handshake_done = done;
+	tsi->tsi_handshake_data = data;
+
+	tsi->tsi_handshake_info.hi_fd_parms_reply = tlsh_genl_ch_anon_reply;
+
+	rc = handshake_enqueue_sock(sock, &tsi->tsi_handshake_info);
+	if (rc)
+		tlsh_sock_info_free(tsi);
+	return rc;
+}
+EXPORT_SYMBOL(tls_client_hello_anon);
+
+static int tlsh_genl_ch_x509_reply(struct sk_buff *msg,
+				   struct handshake_info *hsi)
+{
+	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
+						  tsi_handshake_info);
+	int ret;
+
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_PROTOCOL,
+			  HANDSHAKE_PROTO_TLS_13);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  HANDSHAKE_TYPE_CLIENTHELLO);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_AUTH_TYPE,
+			  HANDSHAKE_AUTHTYPE_X509);
+	if (ret < 0)
+		return ret;
+	ret = tlsh_genl_tls_priorities(msg, tsi);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_X509_CERT_SERIAL,
+			  tsi->tsi_certificate);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_X509_PRIVKEY_SERIAL,
+			  tsi->tsi_privkey);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+/**
+ * tls_client_hello_x509 - request an x.509-based TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @cert: serial number of key containing client's x.509 certificate
+ * @privkey: serial number of key containing client's private key
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_x509(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities, key_serial_t cert,
+			  key_serial_t privkey)
+{
+	struct tlsh_sock_info *tsi;
+	int rc;
+
+	tsi = tlsh_sock_info_alloc(sock, priorities);
+	if (!tsi)
+		return -ENOMEM;
+
+	tsi->tsi_handshake_done = done;
+	tsi->tsi_handshake_data = data;
+
+	tsi->tsi_handshake_info.hi_fd_parms_reply = tlsh_genl_ch_x509_reply;
+	tsi->tsi_certificate = cert;
+	tsi->tsi_privkey = privkey;
+
+	rc = handshake_enqueue_sock(sock, &tsi->tsi_handshake_info);
+	if (rc)
+		tlsh_sock_info_free(tsi);
+	return rc;
+}
+EXPORT_SYMBOL(tls_client_hello_x509);
+
+static int tlsh_genl_ch_psk_reply(struct sk_buff *msg,
+				  struct handshake_info *hsi)
+{
+	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
+						  tsi_handshake_info);
+	int ret;
+
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_PROTOCOL,
+			  HANDSHAKE_PROTO_TLS_13);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  HANDSHAKE_TYPE_CLIENTHELLO);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_AUTH_TYPE,
+			  HANDSHAKE_AUTHTYPE_PSK);
+	if (ret < 0)
+		return ret;
+	ret = tlsh_genl_tls_priorities(msg, tsi);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_PSK_SERIAL,
+			  tsi->tsi_peerid);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+/**
+ * tls_client_hello_psk - request a PSK-based TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ * @peerid: serial number of key containing TLS identity
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_client_hello_psk(struct socket *sock,
+			 void (*done)(void *data, int status), void *data,
+			 const char *priorities, key_serial_t peerid)
+{
+	struct tlsh_sock_info *tsi;
+	int rc;
+
+	tsi = tlsh_sock_info_alloc(sock, priorities);
+	if (!tsi)
+		return -ENOMEM;
+
+	tsi->tsi_handshake_done = done;
+	tsi->tsi_handshake_data = data;
+
+	tsi->tsi_handshake_info.hi_fd_parms_reply = tlsh_genl_ch_psk_reply;
+	tsi->tsi_peerid = peerid;
+
+	rc = handshake_enqueue_sock(sock, &tsi->tsi_handshake_info);
+	if (rc)
+		tlsh_sock_info_free(tsi);
+	return rc;
+}
+EXPORT_SYMBOL(tls_client_hello_psk);
+
+static int tlsh_genl_sh_reply(struct sk_buff *msg, struct handshake_info *hsi)
+{
+	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
+						  tsi_handshake_info);
+	int ret;
+
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_PROTOCOL,
+			  HANDSHAKE_PROTO_TLS_13);
+	if (ret < 0)
+		return ret;
+	ret = nla_put_u32(msg, HANDSHAKE_GENL_ATTR_HANDSHAKE_TYPE,
+			  HANDSHAKE_TYPE_SERVERHELLO);
+	if (ret < 0)
+		return ret;
+	return tlsh_genl_tls_priorities(msg, tsi);
+}
+
+/**
+ * tls_server_hello - request a server TLS handshake on a socket
+ * @sock: connected socket on which to perform the handshake
+ * @done: function to call when the handshake has completed
+ * @data: token to pass back to @done
+ * @priorities: GnuTLS TLS priorities string
+ *
+ * Return values:
+ *   %0: Handshake request enqueue; ->done will be called when complete
+ *   %-ENOENT: No user agent is available
+ *   %-ENOMEM: Memory allocation failed
+ */
+int tls_server_hello(struct socket *sock, void (*done)(void *data, int status),
+		     void *data, const char *priorities)
+{
+	struct tlsh_sock_info *tsi;
+	int rc;
+
+	tsi = tlsh_sock_info_alloc(sock, priorities);
+	if (!tsi)
+		return -ENOMEM;
+
+	tsi->tsi_handshake_done = done;
+	tsi->tsi_handshake_data = data;
+
+	tsi->tsi_handshake_info.hi_fd_parms_reply = tlsh_genl_sh_reply;
+
+	rc = handshake_enqueue_sock(sock, &tsi->tsi_handshake_info);
+	if (rc)
+		tlsh_sock_info_free(tsi);
+	return rc;
+}
+EXPORT_SYMBOL(tls_server_hello);


