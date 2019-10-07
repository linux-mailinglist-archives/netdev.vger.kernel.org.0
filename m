Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17E2FCDF0B
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfJGKQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:16:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfJGKQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:16:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CAFC9301899C;
        Mon,  7 Oct 2019 10:16:48 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5F3360606;
        Mon,  7 Oct 2019 10:16:47 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org
Subject: [PATCH] ss: allow dumping kTLS info
Date:   Mon,  7 Oct 2019 12:16:44 +0200
Message-Id: <2531403b243c1c60afc175c164a02096ffcf89a5.1570442363.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 07 Oct 2019 10:16:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

now that INET_DIAG_INFO requests can dump TCP ULP information, extend 'ss'
to allow diagnosing kTLS when it is attached to a TCP socket. While at it,
import kTLS uAPI definitions from the latest net-next tree.

CC: Andrea Claudi <aclaudi@redhat.com>
Co-developed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/tls.h | 127 +++++++++++++++++++++++++++++++++++++++
 misc/ss.c                |  89 +++++++++++++++++++++++++++
 2 files changed, 216 insertions(+)
 create mode 100644 include/uapi/linux/tls.h

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
new file mode 100644
index 000000000000..bcd2869ed472
--- /dev/null
+++ b/include/uapi/linux/tls.h
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
+/*
+ * Copyright (c) 2016-2017, Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _UAPI_LINUX_TLS_H
+#define _UAPI_LINUX_TLS_H
+
+#include <linux/types.h>
+
+/* TLS socket options */
+#define TLS_TX			1	/* Set transmit parameters */
+#define TLS_RX			2	/* Set receive parameters */
+
+/* Supported versions */
+#define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
+#define TLS_VERSION_MAJOR(ver)	(((ver) >> 8) & 0xFF)
+
+#define TLS_VERSION_NUMBER(id)	((((id##_VERSION_MAJOR) & 0xFF) << 8) |	\
+				 ((id##_VERSION_MINOR) & 0xFF))
+
+#define TLS_1_2_VERSION_MAJOR	0x3
+#define TLS_1_2_VERSION_MINOR	0x3
+#define TLS_1_2_VERSION		TLS_VERSION_NUMBER(TLS_1_2)
+
+#define TLS_1_3_VERSION_MAJOR	0x3
+#define TLS_1_3_VERSION_MINOR	0x4
+#define TLS_1_3_VERSION		TLS_VERSION_NUMBER(TLS_1_3)
+
+/* Supported ciphers */
+#define TLS_CIPHER_AES_GCM_128				51
+#define TLS_CIPHER_AES_GCM_128_IV_SIZE			8
+#define TLS_CIPHER_AES_GCM_128_KEY_SIZE		16
+#define TLS_CIPHER_AES_GCM_128_SALT_SIZE		4
+#define TLS_CIPHER_AES_GCM_128_TAG_SIZE		16
+#define TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE		8
+
+#define TLS_CIPHER_AES_GCM_256				52
+#define TLS_CIPHER_AES_GCM_256_IV_SIZE			8
+#define TLS_CIPHER_AES_GCM_256_KEY_SIZE		32
+#define TLS_CIPHER_AES_GCM_256_SALT_SIZE		4
+#define TLS_CIPHER_AES_GCM_256_TAG_SIZE		16
+#define TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE		8
+
+#define TLS_CIPHER_AES_CCM_128				53
+#define TLS_CIPHER_AES_CCM_128_IV_SIZE			8
+#define TLS_CIPHER_AES_CCM_128_KEY_SIZE		16
+#define TLS_CIPHER_AES_CCM_128_SALT_SIZE		4
+#define TLS_CIPHER_AES_CCM_128_TAG_SIZE		16
+#define TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE		8
+
+#define TLS_SET_RECORD_TYPE	1
+#define TLS_GET_RECORD_TYPE	2
+
+struct tls_crypto_info {
+	__u16 version;
+	__u16 cipher_type;
+};
+
+struct tls12_crypto_info_aes_gcm_128 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_AES_GCM_128_IV_SIZE];
+	unsigned char key[TLS_CIPHER_AES_GCM_128_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_AES_GCM_128_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE];
+};
+
+struct tls12_crypto_info_aes_gcm_256 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_AES_GCM_256_IV_SIZE];
+	unsigned char key[TLS_CIPHER_AES_GCM_256_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_AES_GCM_256_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE];
+};
+
+struct tls12_crypto_info_aes_ccm_128 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_AES_CCM_128_IV_SIZE];
+	unsigned char key[TLS_CIPHER_AES_CCM_128_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_AES_CCM_128_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE];
+};
+
+enum {
+	TLS_INFO_UNSPEC,
+	TLS_INFO_VERSION,
+	TLS_INFO_CIPHER,
+	TLS_INFO_TXCONF,
+	TLS_INFO_RXCONF,
+	__TLS_INFO_MAX,
+};
+#define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
+
+#define TLS_CONF_BASE 1
+#define TLS_CONF_SW 2
+#define TLS_CONF_HW 3
+#define TLS_CONF_HW_RECORD 4
+
+#endif /* _UAPI_LINUX_TLS_H */
diff --git a/misc/ss.c b/misc/ss.c
index 363b4c8d87cd..c93d72c3f9f5 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -51,6 +51,7 @@
 #include <linux/tipc.h>
 #include <linux/tipc_netlink.h>
 #include <linux/tipc_sockets_diag.h>
+#include <linux/tls.h>
 
 /* AF_VSOCK/PF_VSOCK is only provided since glibc 2.18 */
 #ifndef PF_VSOCK
@@ -2751,6 +2752,72 @@ static void print_md5sig(struct tcp_diag_md5sig *sig)
 	print_escape_buf(sig->tcpm_key, sig->tcpm_keylen, " ,");
 }
 
+static void tcp_tls_version(struct rtattr *attr)
+{
+	u_int16_t val;
+
+	if (!attr)
+		return;
+	val = rta_getattr_u16(attr);
+
+	switch (val) {
+	case TLS_1_2_VERSION:
+		out(" version: 1.2");
+		break;
+	case TLS_1_3_VERSION:
+		out(" version: 1.3");
+		break;
+	default:
+		out(" version: unknown(%hu)", val);
+		break;
+	}
+}
+
+static void tcp_tls_cipher(struct rtattr *attr)
+{
+	u_int16_t val;
+
+	if (!attr)
+		return;
+	val = rta_getattr_u16(attr);
+
+	switch (val) {
+	case TLS_CIPHER_AES_GCM_128:
+		out(" cipher: aes-gcm-128");
+		break;
+	case TLS_CIPHER_AES_GCM_256:
+		out(" cipher: aes-gcm-256");
+		break;
+	}
+}
+
+static void tcp_tls_conf(const char *name, struct rtattr *attr)
+{
+	u_int16_t val;
+
+	if (!attr)
+		return;
+	val = rta_getattr_u16(attr);
+
+	switch (val) {
+	case TLS_CONF_BASE:
+		out(" %s: none", name);
+		break;
+	case TLS_CONF_SW:
+		out(" %s: sw", name);
+		break;
+	case TLS_CONF_HW:
+		out(" %s: hw", name);
+		break;
+	case TLS_CONF_HW_RECORD:
+		out(" %s: hw-record", name);
+		break;
+	default:
+		out(" %s: unknown(%hu)", name, val);
+		break;
+	}
+}
+
 #define TCPI_HAS_OPT(info, opt) !!(info->tcpi_options & (opt))
 
 static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
@@ -2906,6 +2973,28 @@ static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 			print_md5sig(sig++);
 		}
 	}
+	if (tb[INET_DIAG_ULP_INFO]) {
+		struct rtattr *ulpinfo[INET_ULP_INFO_MAX + 1] = { 0 };
+
+		parse_rtattr_nested(ulpinfo, INET_ULP_INFO_MAX,
+				    tb[INET_DIAG_ULP_INFO]);
+
+		if (ulpinfo[INET_ULP_INFO_NAME])
+			out(" tcp-ulp-%s",
+			    rta_getattr_str(ulpinfo[INET_ULP_INFO_NAME]));
+
+		if (ulpinfo[INET_ULP_INFO_TLS]) {
+			struct rtattr *tlsinfo[TLS_INFO_MAX + 1] = { 0 };
+
+			parse_rtattr_nested(tlsinfo, TLS_INFO_MAX,
+					    ulpinfo[INET_ULP_INFO_TLS]);
+
+			tcp_tls_version(tlsinfo[TLS_INFO_VERSION]);
+			tcp_tls_cipher(tlsinfo[TLS_INFO_CIPHER]);
+			tcp_tls_conf("rxconf", tlsinfo[TLS_INFO_RXCONF]);
+			tcp_tls_conf("txconf", tlsinfo[TLS_INFO_TXCONF]);
+		}
+	}
 }
 
 static const char *format_host_sa(struct sockaddr_storage *sa)
-- 
2.21.0

