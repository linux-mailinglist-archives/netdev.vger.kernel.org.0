Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE985746B4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiGNI1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiGNI1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:27:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA693AE67
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657787249; x=1689323249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nSy3ObsbX++OR1AAw+VgO1Xh02y07OlU/A4sL2Hso6c=;
  b=erjEtoYjmob03Ff6kKHj1deeQzggwy5j8nPFac65kUEX5/uh2VvUMUiL
   3vdrrvrexuKF+qCRET9sH+mU8iSREbYhd7S76t0dKf6+og20DvqZMzZHS
   /mzbmDNPOTADZeRp/O/HqK9EVypMjibtgVsHCvVPTXYHUTEWCAyFGzTEi
   875XziaDatK4UD0B8dAY7jzWkmLBV16cpINLHaPYoeaNlWHkbrIFdFW5A
   ++QRys1BDc8f9W4mE15TIThscLpgJtMeaVJwj/0hDSxd8E/C1m23Ur4lc
   C2I+Zuo8LB6npHmyDt1QI9rNxbuQEc1noPsyquMeHVMzpcR0/3pcs4c8I
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="283007014"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="283007014"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 01:27:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="628624175"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 14 Jul 2022 01:27:28 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26E8RQl7029602;
        Thu, 14 Jul 2022 09:27:27 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next 1/2] lib: Introduce ppp protocols
Date:   Thu, 14 Jul 2022 10:25:21 +0200
Message-Id: <20220714082522.54913-2-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220714082522.54913-1-wojciech.drewek@intel.com>
References: <20220714082522.54913-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPP protocol field uses different values than ethertype. Introduce
utilities for translating PPP protocols from strings to values
and vice versa. Existing helper functions were moved from
lib/ll_proto.c to lib/utils.c.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/rt_names.h            |  3 ++
 include/uapi/linux/ppp_defs.h | 37 +++++++++++++++++++++++++
 include/utils.h               | 10 +++++++
 lib/Makefile                  |  2 +-
 lib/ll_proto.c                | 33 ++++++----------------
 lib/ppp_proto.c               | 52 +++++++++++++++++++++++++++++++++++
 lib/utils.c                   | 34 +++++++++++++++++++++++
 7 files changed, 145 insertions(+), 26 deletions(-)
 create mode 100644 include/uapi/linux/ppp_defs.h
 create mode 100644 lib/ppp_proto.c

diff --git a/include/rt_names.h b/include/rt_names.h
index 1835f3be2bed..6358650db404 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -31,6 +31,9 @@ int ll_addr_a2n(char *lladdr, int len, const char *arg);
 const char * ll_proto_n2a(unsigned short id, char *buf, int len);
 int ll_proto_a2n(unsigned short *id, const char *buf);
 
+const char *ppp_proto_n2a(unsigned short id, char *buf, int len);
+int ppp_proto_a2n(unsigned short *id, const char *buf);
+
 const char *nl_proto_n2a(int id, char *buf, int len);
 int nl_proto_a2n(__u32 *id, const char *arg);
 
diff --git a/include/uapi/linux/ppp_defs.h b/include/uapi/linux/ppp_defs.h
new file mode 100644
index 000000000000..0013dc77e3b9
--- /dev/null
+++ b/include/uapi/linux/ppp_defs.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * ppp_defs.h - PPP definitions.
+ *
+ * Copyright 1994-2000 Paul Mackerras.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 as published by the Free Software Foundation.
+ */
+
+/*
+ * Protocol field values.
+ */
+#define PPP_IP		0x21	/* Internet Protocol */
+#define PPP_AT		0x29	/* AppleTalk Protocol */
+#define PPP_IPX		0x2b	/* IPX protocol */
+#define	PPP_VJC_COMP	0x2d	/* VJ compressed TCP */
+#define	PPP_VJC_UNCOMP	0x2f	/* VJ uncompressed TCP */
+#define PPP_MP		0x3d	/* Multilink protocol */
+#define PPP_IPV6	0x57	/* Internet Protocol Version 6 */
+#define PPP_COMPFRAG	0xfb	/* fragment compressed below bundle */
+#define PPP_COMP	0xfd	/* compressed packet */
+#define PPP_MPLS_UC	0x0281	/* Multi Protocol Label Switching - Unicast */
+#define PPP_MPLS_MC	0x0283	/* Multi Protocol Label Switching - Multicast */
+#define PPP_IPCP	0x8021	/* IP Control Protocol */
+#define PPP_ATCP	0x8029	/* AppleTalk Control Protocol */
+#define PPP_IPXCP	0x802b	/* IPX Control Protocol */
+#define PPP_IPV6CP	0x8057	/* IPv6 Control Protocol */
+#define PPP_CCPFRAG	0x80fb	/* CCP at link level (below MP bundle) */
+#define PPP_CCP		0x80fd	/* Compression Control Protocol */
+#define PPP_MPLSCP	0x80fd	/* MPLS Control Protocol */
+#define PPP_LCP		0xc021	/* Link Control Protocol */
+#define PPP_PAP		0xc023	/* Password Authentication Protocol */
+#define PPP_LQR		0xc025	/* Link Quality Report protocol */
+#define PPP_CHAP	0xc223	/* Cryptographic Handshake Auth. Protocol */
+#define PPP_CBCP	0xc029	/* Callback Control Protocol */
diff --git a/include/utils.h b/include/utils.h
index 9765fdd231df..0c9022760916 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -369,4 +369,14 @@ void inc_indent(struct indent_mem *mem);
 void dec_indent(struct indent_mem *mem);
 void print_indent(struct indent_mem *mem);
 
+struct proto {
+	int id;
+	const char *name;
+};
+
+int __proto_a2n(unsigned short *id, const char *buf,
+		const struct proto *proto_tb, size_t tb_len);
+const char *__proto_n2a(unsigned short id, char *buf, int len,
+			const struct proto *proto_tb, size_t tb_len);
+
 #endif /* __UTILS_H__ */
diff --git a/lib/Makefile b/lib/Makefile
index 6c98f9a61fdb..ddedd37feb32 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o utils_math.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o json_print_math.o \
-	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o
+	names.o color.o bpf_legacy.o bpf_glue.o exec.o fs.o cg_map.o ppp_proto.o
 
 ifeq ($(HAVE_ELF),y)
 ifeq ($(HAVE_LIBBPF),y)
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 342ea2eefa4c..f067516cde9e 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -28,10 +28,8 @@
 
 
 #define __PF(f,n) { ETH_P_##f, #n },
-static const struct {
-	int id;
-	const char *name;
-} llproto_names[] = {
+
+static const struct proto llproto_names[] = {
 __PF(LOOP,loop)
 __PF(PUP,pup)
 __PF(PUPAT,pupat)
@@ -90,31 +88,16 @@ __PF(TEB,teb)
 };
 #undef __PF
 
-
-const char * ll_proto_n2a(unsigned short id, char *buf, int len)
+const char *ll_proto_n2a(unsigned short id, char *buf, int len)
 {
-        int i;
+	size_t len_tb = ARRAY_SIZE(llproto_names);
 
-	id = ntohs(id);
-
-        for (i=0; !numeric && i<sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
-                 if (llproto_names[i].id == id)
-			return llproto_names[i].name;
-	}
-        snprintf(buf, len, "[%d]", id);
-        return buf;
+	return __proto_n2a(id, buf, len, llproto_names, len_tb);
 }
 
 int ll_proto_a2n(unsigned short *id, const char *buf)
 {
-        int i;
-        for (i=0; i < sizeof(llproto_names)/sizeof(llproto_names[0]); i++) {
-                 if (strcasecmp(llproto_names[i].name, buf) == 0) {
-			 *id = htons(llproto_names[i].id);
-			 return 0;
-		 }
-	}
-	if (get_be16(id, buf, 0))
-		return -1;
-	return 0;
+	size_t len_tb = ARRAY_SIZE(llproto_names);
+
+	return __proto_a2n(id, buf, llproto_names, len_tb);
 }
diff --git a/lib/ppp_proto.c b/lib/ppp_proto.c
new file mode 100644
index 000000000000..1c035095f375
--- /dev/null
+++ b/lib/ppp_proto.c
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Utilities for translating PPP protocols from strings
+ * and vice versa.
+ *
+ * Authors:     Wojciech Drewek <wojciech.drewek@intel.com>
+ */
+
+#include <linux/ppp_defs.h>
+#include <linux/if_ether.h>
+#include "utils.h"
+#include "rt_names.h"
+
+static const struct proto ppp_proto_names[] = {
+	{PPP_IP, "ip"},
+	{PPP_AT, "at"},
+	{PPP_IPX, "ipx"},
+	{PPP_VJC_COMP, "vjc_comp"},
+	{PPP_VJC_UNCOMP, "vjc_uncomp"},
+	{PPP_MP, "mp"},
+	{PPP_IPV6, "ipv6"},
+	{PPP_COMPFRAG, "compfrag"},
+	{PPP_COMP, "comp"},
+	{PPP_MPLS_UC, "mpls_uc"},
+	{PPP_MPLS_MC, "mpls_mc"},
+	{PPP_IPCP, "ipcp"},
+	{PPP_ATCP, "atcp"},
+	{PPP_IPXCP, "ipxcp"},
+	{PPP_IPV6CP, "ipv6cp"},
+	{PPP_CCPFRAG, "ccpfrag"},
+	{PPP_CCP, "ccp"},
+	{PPP_MPLSCP, "mplscp"},
+	{PPP_LCP, "lcp"},
+	{PPP_PAP, "pap"},
+	{PPP_LQR, "lqr"},
+	{PPP_CHAP, "chap"},
+	{PPP_CBCP, "cbcp"},
+};
+
+const char *ppp_proto_n2a(unsigned short id, char *buf, int len)
+{
+	size_t len_tb = ARRAY_SIZE(ppp_proto_names);
+
+	return __proto_n2a(id, buf, len, ppp_proto_names, len_tb);
+}
+
+int ppp_proto_a2n(unsigned short *id, const char *buf)
+{
+	size_t len_tb = ARRAY_SIZE(ppp_proto_names);
+
+	return __proto_a2n(id, buf, ppp_proto_names, len_tb);
+}
diff --git a/lib/utils.c b/lib/utils.c
index 53d310060284..6b88ba31b335 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1925,3 +1925,37 @@ void print_indent(struct indent_mem *mem)
 	if (mem->indent_level)
 		printf("%s", mem->indent_str);
 }
+
+const char *__proto_n2a(unsigned short id, char *buf, int len,
+			const struct proto *proto_tb, size_t tb_len)
+{
+	int i;
+
+	id = ntohs(id);
+
+	for (i = 0; !numeric && i < tb_len; i++) {
+		if (proto_tb[i].id == id)
+			return proto_tb[i].name;
+	}
+
+	snprintf(buf, len, "[%d]", id);
+
+	return buf;
+}
+
+int __proto_a2n(unsigned short *id, const char *buf,
+		const struct proto *proto_tb, size_t tb_len)
+{
+	int i;
+
+	for (i = 0; i < tb_len; i++) {
+		if (strcasecmp(proto_tb[i].name, buf) == 0) {
+			*id = htons(proto_tb[i].id);
+			return 0;
+		}
+	}
+	if (get_be16(id, buf, 0))
+		return -1;
+
+	return 0;
+}
-- 
2.31.1

