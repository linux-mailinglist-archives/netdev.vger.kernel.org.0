Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664C666E8B7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjAQVrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjAQVpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:45:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C3D70C78
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D15EBB81331
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 20:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136FDC433EF;
        Tue, 17 Jan 2023 20:08:17 +0000 (UTC)
Subject: [PATCH RFC 3/3] net/tls: Create a fixed TLS handshake API
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com
Date:   Tue, 17 Jan 2023 15:08:16 -0500
Message-ID: <167398609604.5631.1363657967245128346.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
References: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
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

We don't want to perturb API consumers whenever the upcall mechanism
is changed or replaced. The handshake API therefore is not a part of
the listen/accept upcall mechanism, but is a separate fixed
component.

Create the consumer handshake API in its own source file to make it
straightforward to modify the handshake mechanism later.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/tls/Makefile        |    3 +-
 net/tls/tls_handshake.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 net/tls/tls_handshake.c

diff --git a/net/tls/Makefile b/net/tls/Makefile
index 05fbff53ae09..a8bf6aa72e54 100644
--- a/net/tls/Makefile
+++ b/net/tls/Makefile
@@ -7,7 +7,8 @@ CFLAGS_trace.o := -I$(src)
 
 obj-$(CONFIG_TLS) += tls.o
 
-tls-y := af_tlsh.o tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
+tls-y := af_tlsh.o tls_handshake.o tls_main.o tls_sw.o tls_proc.o \
+	 trace.o tls_strp.o
 
 tls-$(CONFIG_TLS_TOE) += tls_toe.o
 tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
diff --git a/net/tls/tls_handshake.c b/net/tls/tls_handshake.c
new file mode 100644
index 000000000000..f3726eeb55db
--- /dev/null
+++ b/net/tls/tls_handshake.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * TLS handshake consumer API
+ *
+ * Author: Chuck Lever <chuck.lever@oracle.com>
+ *
+ * Copyright (c) 2023, Oracle and/or its affiliates.
+ *
+ * When a kernel TLS consumer wants to establish a TLS session, it
+ * uses the API calls in this file to request a TLS handshake.
+ *
+ * This is an asynchronous API. These calls do not sleep.
+ */
+
+#include <linux/types.h>
+#include <linux/socket.h>
+
+#include <net/tls.h>
+#include <net/tlsh.h>
+
+#include "tls.h"
+
+/**
+ * tls_client_hello_anon - request an anonymous TLS handshake on a socket
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
+int tls_client_hello_anon(struct socket *sock,
+			  void (*done)(void *data, int status), void *data,
+			  const char *priorities)
+{
+	/* Use the listen/accept upcall mechanism */
+	return tlsh_client_hello_anon(sock, done, data, priorities);
+}
+EXPORT_SYMBOL(tls_client_hello_anon);
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
+	/* Use the listen/accept upcall mechanism */
+	return tlsh_client_hello_x509(sock, done, data, priorities, cert,
+				      privkey);
+}
+EXPORT_SYMBOL(tls_client_hello_x509);
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
+	/* Use the listen/accept upcall mechanism */
+	return tlsh_client_hello_psk(sock, done, data, priorities, peerid);
+}
+EXPORT_SYMBOL(tls_client_hello_psk);


