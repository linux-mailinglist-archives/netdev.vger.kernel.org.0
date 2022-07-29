Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA34584DB0
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiG2Iwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 04:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiG2Iwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 04:52:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C9E82FBE
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659084752; x=1690620752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3V+xJ4ZyOeisbavQVLL4H2S0QWR5g7DWtK5RYeupCCA=;
  b=AuxDcOQVCUHDvmqU/gOHFAIhPdPKv5vS5NlHs3/2n/iJzu/L8yyBJ3GM
   FAtHqgXygIE5tKitlR6RklXBpFFegHE49ih/e0Gzw8EqLYOcMBtF8wPOW
   7qON6m3nEGJY/AEVkVEE4DYxXJ7gfYdv4xd9C90Igq1VPmZiZWR0vijeL
   18Wp8dawOsCvfLU47ga1jWzoI0c/01FaY5v5cqC+CS5krNY9FaS+XWMkc
   +R/5bqF2bn5aTr/sQzD9uHLSZw8uTdlOSEt3FZk6CfsBiAu56T/MzCz4G
   DSoPef/rDLIPgLZU2p4mBNFGbTujcmgXyR1DCxGeeFPetKlXRF7NQ8ON/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="289496139"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="289496139"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 01:52:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="551668950"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 29 Jul 2022 01:52:29 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26T8qR3B020937;
        Fri, 29 Jul 2022 09:52:28 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute-next v4 2/3] lib: Introduce ppp protocols
Date:   Fri, 29 Jul 2022 10:50:34 +0200
Message-Id: <20220729085035.535788-3-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729085035.535788-1-wojciech.drewek@intel.com>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
v4: ppp_defs.h removed
---
 include/rt_names.h |  3 +++
 lib/Makefile       |  2 +-
 lib/ppp_proto.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)
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

