Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C79583CC8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiG1LDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbiG1LDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:03:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97AA664D6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659006195; x=1690542195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X3bB9yEDKxVaC7ppovPFDXtxDekCqFRuI5n1bOVei1I=;
  b=n9vZGU/RkpQjFF9FGNV/zPJl33WPC5Rtma3IFuLFDKOHj6iGCNoQecdy
   8CzsOOb1PzB7dwstwNgoXRSmfKGOrREI3QNlS/5wU50kXZTBpbSnJXfVQ
   EwozLREG88qqGrnxFCRDvUobp7HGk7aVa4PrtK3uDlpbEeH2xzytndNLj
   yLuIxAluNen1p6Ey/TNOSMtlv1Mbr4FYeIxDnX8/7CTCsfHEbcgwuuPPk
   wv8k6BR+f7F/CWLci+u6kUc+vURDn+mR+HFvmxNRdCbpTfOS8IBEOnqsF
   sr7HGR0FpZ8pAHdpSM0CfNJYbSVTBl1rHKQIW/YWoiLipkiIKgnXIqSeA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="314272186"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="314272186"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 04:03:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="777092527"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jul 2022 04:03:13 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26SB3BbL019284;
        Thu, 28 Jul 2022 12:03:12 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute-next v3 2/3] lib: Introduce ppp protocols
Date:   Thu, 28 Jul 2022 13:01:16 +0200
Message-Id: <20220728110117.492855-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220728110117.492855-1-wojciech.drewek@intel.com>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPP protocol field uses different values than ethertype. Introduce
utilities for translating PPP protocols from strings to values
and vice versa. Use generic API from utils in order to get
proto id and name.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/rt_names.h            |  3 ++
 include/uapi/linux/ppp_defs.h | 37 +++++++++++++++++++++++++
 lib/Makefile                  |  2 +-
 lib/ppp_proto.c               | 52 +++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 1 deletion(-)
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
diff --git a/lib/ppp_proto.c b/lib/ppp_proto.c
new file mode 100644
index 000000000000..a63466432888
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
+	return proto_n2a(id, buf, len, ppp_proto_names, len_tb);
+}
+
+int ppp_proto_a2n(unsigned short *id, const char *buf)
+{
+	size_t len_tb = ARRAY_SIZE(ppp_proto_names);
+
+	return proto_a2n(id, buf, ppp_proto_names, len_tb);
+}
-- 
2.31.1

