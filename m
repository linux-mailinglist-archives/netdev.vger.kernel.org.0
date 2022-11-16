Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A1A62B5C7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbiKPI60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiKPI6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:58:18 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ED71B1E8;
        Wed, 16 Nov 2022 00:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668589089; x=1700125089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HsDE72d8Fh9Mt5eEQGNpRDrtnnSVdVqypxzJJdLjZA4=;
  b=wAPM1ngBW9K2x7MdhQZHd9+L8XmyVxmLL7y1I+QlARL5ZTF71iPa3upo
   4bUl4CX2KqDicWVxExWIhniz+HAWrZG9mrcj82Y1Q9rkAG+ZBTYT6hSPs
   t6yw4oo47MPD2Xn3CU0KrzSZUARpESvEKr6chyUDtoko5+iWgo0Mg2OQg
   EjXRoJZ2S9bEVkRne6ulJ08fMEiH5Spe/UYyACT8g09I4LEs7u1DrzbXs
   26umvZS8ey9DyIxVSSXiiNHGiqiVdXARzPlaCCKQIxSitoFy2gPg+IKDb
   zP7K3U2k1zdx+1t2IFFmv9963lIjFCVkF4Sq+1wEtLtdtA8fmsHzHXK7L
   w==;
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="123662806"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Nov 2022 01:58:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 16 Nov 2022 01:58:06 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 16 Nov 2022 01:58:02 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 3/8] net: microchip: sparx5: Add VCAP debugFS support
Date:   Wed, 16 Nov 2022 09:57:42 +0100
Message-ID: <20221116085747.3810427-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116085747.3810427-1-steen.hegelund@microchip.com>
References: <20221116085747.3810427-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a debugFS root folder for Sparx5 and add a vcap folder underneath with
the VCAP instances and the ports

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  1 +
 .../ethernet/microchip/sparx5/sparx5_main.c   |  3 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  3 +
 .../microchip/sparx5/sparx5_vcap_debugfs.c    | 23 +++++
 .../microchip/sparx5/sparx5_vcap_debugfs.h    | 33 +++++++
 .../microchip/sparx5/sparx5_vcap_impl.c       | 65 ++-----------
 .../microchip/sparx5/sparx5_vcap_impl.h       | 48 ++++++++++
 drivers/net/ethernet/microchip/vcap/Makefile  |  1 +
 .../net/ethernet/microchip/vcap/vcap_api.h    | 13 ++-
 .../microchip/vcap/vcap_api_debugfs.c         | 91 +++++++++++++++++++
 .../microchip/vcap/vcap_api_debugfs.h         | 41 +++++++++
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  6 +-
 12 files changed, 264 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index cff07b8841bd..d0ed7090aa54 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -12,6 +12,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o sparx5_tc_matchall.o
 
 sparx5-switch-$(CONFIG_SPARX5_DCB) += sparx5_dcb.o
+sparx5-switch-$(CONFIG_DEBUG_FS) += sparx5_vcap_debugfs.o
 
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 0b70c00c6eaa..569917abe1c4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -760,6 +760,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	/* Default values, some from DT */
 	sparx5->coreclock = SPX5_CORE_CLOCK_DEFAULT;
 
+	sparx5->debugfs_root = debugfs_create_dir("sparx5", NULL);
+
 	ports = of_get_child_by_name(np, "ethernet-ports");
 	if (!ports) {
 		dev_err(sparx5->dev, "no ethernet-ports child node found\n");
@@ -903,6 +905,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 {
 	struct sparx5 *sparx5 = platform_get_drvdata(pdev);
 
+	debugfs_remove_recursive(sparx5->debugfs_root);
 	if (sparx5->xtr_irq) {
 		disable_irq(sparx5->xtr_irq);
 		sparx5->xtr_irq = -ENXIO;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 5985f2087d7f..4a574cdcb584 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -17,6 +17,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/hrtimer.h>
+#include <linux/debugfs.h>
 
 #include "sparx5_main_regs.h"
 
@@ -292,6 +293,8 @@ struct sparx5 {
 	struct vcap_control *vcap_ctrl;
 	/* PGID allocation map */
 	u8 pgid_map[PGID_TABLE_SIZE];
+	/* Common root for debugfs */
+	struct dentry *debugfs_root;
 };
 
 /* sparx5_switchdev.c */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
new file mode 100644
index 000000000000..2cb061e891c5
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver VCAP debugFS implementation
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include "sparx5_vcap_debugfs.h"
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+#include "sparx5_vcap_impl.h"
+#include "sparx5_vcap_ag_api.h"
+
+/* Provide port information via a callback interface */
+int sparx5_port_info(struct net_device *ndev,
+		     struct vcap_admin *admin,
+		     struct vcap_output_print *out)
+{
+	/* this will be added later */
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.h
new file mode 100644
index 000000000000..f9ede03441f2
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Microchip Sparx5 Switch driver VCAP implementation
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#ifndef __SPARX5_VCAP_DEBUGFS_H__
+#define __SPARX5_VCAP_DEBUGFS_H__
+
+#include <linux/netdevice.h>
+
+#include <vcap_api.h>
+#include <vcap_api_client.h>
+
+#if defined(CONFIG_DEBUG_FS)
+
+/* Provide port information via a callback interface */
+int sparx5_port_info(struct net_device *ndev,
+		     struct vcap_admin *admin,
+		     struct vcap_output_print *out);
+
+#else
+
+static inline int sparx5_port_info(struct net_device *ndev,
+				   struct vcap_admin *admin,
+				   struct vcap_output_print *out)
+{
+	return 0;
+}
+
+#endif
+
+#endif /* __SPARX5_VCAP_DEBUGFS_H__ */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index e8f3d030eba2..e70ff1aa6d57 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -12,10 +12,12 @@
 
 #include "vcap_api.h"
 #include "vcap_api_client.h"
+#include "vcap_api_debugfs.h"
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
 #include "sparx5_vcap_impl.h"
 #include "sparx5_vcap_ag_api.h"
+#include "sparx5_vcap_debugfs.h"
 
 #define SUPER_VCAP_BLK_SIZE 3072 /* addresses per Super VCAP block */
 #define STREAMSIZE (64 * 4)  /* bytes in the VCAP cache area */
@@ -30,54 +32,6 @@
 	 ANA_ACL_VCAP_S2_KEY_SEL_IP6_UC_KEY_SEL_SET(_v6_uc) | \
 	 ANA_ACL_VCAP_S2_KEY_SEL_ARP_KEY_SEL_SET(_arp))
 
-/* IS2 port keyset selection control */
-
-/* IS2 non-ethernet traffic type keyset generation */
-enum vcap_is2_port_sel_noneth {
-	VCAP_IS2_PS_NONETH_MAC_ETYPE,
-	VCAP_IS2_PS_NONETH_CUSTOM_1,
-	VCAP_IS2_PS_NONETH_CUSTOM_2,
-	VCAP_IS2_PS_NONETH_NO_LOOKUP
-};
-
-/* IS2 IPv4 unicast traffic type keyset generation */
-enum vcap_is2_port_sel_ipv4_uc {
-	VCAP_IS2_PS_IPV4_UC_MAC_ETYPE,
-	VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER,
-	VCAP_IS2_PS_IPV4_UC_IP_7TUPLE,
-};
-
-/* IS2 IPv4 multicast traffic type keyset generation */
-enum vcap_is2_port_sel_ipv4_mc {
-	VCAP_IS2_PS_IPV4_MC_MAC_ETYPE,
-	VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER,
-	VCAP_IS2_PS_IPV4_MC_IP_7TUPLE,
-	VCAP_IS2_PS_IPV4_MC_IP4_VID,
-};
-
-/* IS2 IPv6 unicast traffic type keyset generation */
-enum vcap_is2_port_sel_ipv6_uc {
-	VCAP_IS2_PS_IPV6_UC_MAC_ETYPE,
-	VCAP_IS2_PS_IPV6_UC_IP_7TUPLE,
-	VCAP_IS2_PS_IPV6_UC_IP6_STD,
-	VCAP_IS2_PS_IPV6_UC_IP4_TCP_UDP_OTHER,
-};
-
-/* IS2 IPv6 multicast traffic type keyset generation */
-enum vcap_is2_port_sel_ipv6_mc {
-	VCAP_IS2_PS_IPV6_MC_MAC_ETYPE,
-	VCAP_IS2_PS_IPV6_MC_IP_7TUPLE,
-	VCAP_IS2_PS_IPV6_MC_IP6_VID,
-	VCAP_IS2_PS_IPV6_MC_IP6_STD,
-	VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER,
-};
-
-/* IS2 ARP traffic type keyset generation */
-enum vcap_is2_port_sel_arp {
-	VCAP_IS2_PS_ARP_MAC_ETYPE,
-	VCAP_IS2_PS_ARP_ARP,
-};
-
 static struct sparx5_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
 	int vinst; /* instance number within the same type */
@@ -548,15 +502,6 @@ static void sparx5_vcap_move(struct net_device *ndev, struct vcap_admin *admin,
 	sparx5_vcap_wait_super_update(sparx5);
 }
 
-/* Provide port information via a callback interface */
-static int sparx5_port_info(struct net_device *ndev, enum vcap_type vtype,
-			    int (*pf)(void *out, int arg, const char *fmt, ...),
-			    void *out, int arg)
-{
-	/* this will be added later */
-	return 0;
-}
-
 /* Enable all lookups in the VCAP instance */
 static int sparx5_vcap_enable(struct net_device *ndev,
 			      struct vcap_admin *admin,
@@ -702,6 +647,7 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 	const struct sparx5_vcap_inst *cfg;
 	struct vcap_control *ctrl;
 	struct vcap_admin *admin;
+	struct dentry *dir;
 	int err = 0, idx;
 
 	/* Create a VCAP control instance that owns the platform specific VCAP
@@ -740,6 +686,11 @@ int sparx5_vcap_init(struct sparx5 *sparx5)
 			sparx5_vcap_port_key_selection(sparx5, admin);
 		list_add_tail(&admin->list, &ctrl->list);
 	}
+	dir = vcap_debugfs(sparx5->dev, sparx5->debugfs_root, ctrl);
+	for (idx = 0; idx < SPX5_PORTS; ++idx)
+		if (sparx5->ports[idx])
+			vcap_port_debugfs(sparx5->dev, dir, ctrl,
+					  sparx5->ports[idx]->ndev);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 8e44ebd76b41..8a6b7e3d2618 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -17,4 +17,52 @@
 #define SPARX5_VCAP_CID_IS2_MAX \
 	(VCAP_CID_INGRESS_STAGE2_L3 + VCAP_CID_LOOKUP_SIZE - 1) /* IS2 Max */
 
+/* IS2 port keyset selection control */
+
+/* IS2 non-ethernet traffic type keyset generation */
+enum vcap_is2_port_sel_noneth {
+	VCAP_IS2_PS_NONETH_MAC_ETYPE,
+	VCAP_IS2_PS_NONETH_CUSTOM_1,
+	VCAP_IS2_PS_NONETH_CUSTOM_2,
+	VCAP_IS2_PS_NONETH_NO_LOOKUP
+};
+
+/* IS2 IPv4 unicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv4_uc {
+	VCAP_IS2_PS_IPV4_UC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV4_UC_IP4_TCP_UDP_OTHER,
+	VCAP_IS2_PS_IPV4_UC_IP_7TUPLE,
+};
+
+/* IS2 IPv4 multicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv4_mc {
+	VCAP_IS2_PS_IPV4_MC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV4_MC_IP4_TCP_UDP_OTHER,
+	VCAP_IS2_PS_IPV4_MC_IP_7TUPLE,
+	VCAP_IS2_PS_IPV4_MC_IP4_VID,
+};
+
+/* IS2 IPv6 unicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv6_uc {
+	VCAP_IS2_PS_IPV6_UC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV6_UC_IP_7TUPLE,
+	VCAP_IS2_PS_IPV6_UC_IP6_STD,
+	VCAP_IS2_PS_IPV6_UC_IP4_TCP_UDP_OTHER,
+};
+
+/* IS2 IPv6 multicast traffic type keyset generation */
+enum vcap_is2_port_sel_ipv6_mc {
+	VCAP_IS2_PS_IPV6_MC_MAC_ETYPE,
+	VCAP_IS2_PS_IPV6_MC_IP_7TUPLE,
+	VCAP_IS2_PS_IPV6_MC_IP6_VID,
+	VCAP_IS2_PS_IPV6_MC_IP6_STD,
+	VCAP_IS2_PS_IPV6_MC_IP4_TCP_UDP_OTHER,
+};
+
+/* IS2 ARP traffic type keyset generation */
+enum vcap_is2_port_sel_arp {
+	VCAP_IS2_PS_ARP_MAC_ETYPE,
+	VCAP_IS2_PS_ARP_ARP,
+};
+
 #endif /* __SPARX5_VCAP_IMPL_H__ */
diff --git a/drivers/net/ethernet/microchip/vcap/Makefile b/drivers/net/ethernet/microchip/vcap/Makefile
index b377569f92d8..0adb8f5a8735 100644
--- a/drivers/net/ethernet/microchip/vcap/Makefile
+++ b/drivers/net/ethernet/microchip/vcap/Makefile
@@ -5,5 +5,6 @@
 
 obj-$(CONFIG_VCAP) += vcap.o
 obj-$(CONFIG_VCAP_KUNIT_TEST) +=  vcap_model_kunit.o
+vcap-$(CONFIG_DEBUG_FS) += vcap_api_debugfs.o
 
 vcap-y += vcap_api.o
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index bfb8ad535074..e71e7d3d79c2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -203,6 +203,13 @@ struct vcap_keyset_list {
 	enum vcap_keyfield_set *keysets; /* the list of keysets */
 };
 
+/* Client output printf-like function with destination */
+struct vcap_output_print {
+	__printf(2, 3)
+	void (*prf)(void *out, const char *fmt, ...);
+	void *dst;
+};
+
 /* Client supplied VCAP callback operations */
 struct vcap_operations {
 	/* validate port keyset operation */
@@ -252,10 +259,8 @@ struct vcap_operations {
 	/* informational */
 	int (*port_info)
 		(struct net_device *ndev,
-		 enum vcap_type vtype,
-		 int (*pf)(void *out, int arg, const char *fmt, ...),
-		 void *out,
-		 int arg);
+		 struct vcap_admin *admin,
+		 struct vcap_output_print *out);
 	/* enable/disable the lookups in a vcap instance */
 	int (*enable)
 		(struct net_device *ndev,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
new file mode 100644
index 000000000000..7264435af980
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip VCAP API debug file system support
+ *
+ * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/netdevice.h>
+
+#include "vcap_api_debugfs.h"
+
+struct vcap_admin_debugfs_info {
+	struct vcap_control *vctrl;
+	struct vcap_admin *admin;
+};
+
+struct vcap_port_debugfs_info {
+	struct vcap_control *vctrl;
+	struct net_device *ndev;
+};
+
+/* Show the port configuration and status */
+static int vcap_port_debugfs_show(struct seq_file *m, void *unused)
+{
+	struct vcap_port_debugfs_info *info = m->private;
+	struct vcap_admin *admin;
+	struct vcap_output_print out = {
+		.prf = (void *)seq_printf,
+		.dst = m,
+	};
+
+	list_for_each_entry(admin, &info->vctrl->list, list) {
+		if (admin->vinst)
+			continue;
+		info->vctrl->ops->port_info(info->ndev, admin, &out);
+	}
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(vcap_port_debugfs);
+
+void vcap_port_debugfs(struct device *dev, struct dentry *parent,
+		       struct vcap_control *vctrl,
+		       struct net_device *ndev)
+{
+	struct vcap_port_debugfs_info *info;
+
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return;
+
+	info->vctrl = vctrl;
+	info->ndev = ndev;
+	debugfs_create_file(netdev_name(ndev), 0444, parent, info, &vcap_port_debugfs_fops);
+}
+EXPORT_SYMBOL_GPL(vcap_port_debugfs);
+
+/* Show the raw VCAP instance data (rules with address info) */
+static int vcap_raw_debugfs_show(struct seq_file *m, void *unused)
+{
+	/* The output will be added later */
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(vcap_raw_debugfs);
+
+struct dentry *vcap_debugfs(struct device *dev, struct dentry *parent,
+			    struct vcap_control *vctrl)
+{
+	struct vcap_admin_debugfs_info *info;
+	struct vcap_admin *admin;
+	struct dentry *dir;
+	char name[50];
+
+	dir = debugfs_create_dir("vcaps", parent);
+	if (PTR_ERR_OR_ZERO(dir))
+		return NULL;
+	list_for_each_entry(admin, &vctrl->list, list) {
+		sprintf(name, "raw_%s_%d", vctrl->vcaps[admin->vtype].name, admin->vinst);
+		info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+		if (!info)
+			return NULL;
+		info->vctrl = vctrl;
+		info->admin = admin;
+		debugfs_create_file(name, 0444, dir, info,
+				    &vcap_raw_debugfs_fops);
+	}
+	return dir;
+}
+EXPORT_SYMBOL_GPL(vcap_debugfs);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
new file mode 100644
index 000000000000..9f2c59b5f6f5
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API
+ */
+
+#ifndef __VCAP_API_DEBUGFS__
+#define __VCAP_API_DEBUGFS__
+
+#include <linux/types.h>
+#include <linux/debugfs.h>
+#include <linux/netdevice.h>
+
+#include "vcap_api.h"
+
+#if defined(CONFIG_DEBUG_FS)
+
+void vcap_port_debugfs(struct device *dev, struct dentry *parent,
+		       struct vcap_control *vctrl,
+		       struct net_device *ndev);
+
+/* Create a debugFS entry for a vcap instance */
+struct dentry *vcap_debugfs(struct device *dev, struct dentry *parent,
+			    struct vcap_control *vctrl);
+
+#else
+
+static inline void vcap_port_debugfs(struct device *dev, struct dentry *parent,
+				     struct vcap_control *vctrl,
+				     struct net_device *ndev)
+{
+}
+
+static inline struct dentry *vcap_debugfs(struct device *dev,
+					  struct dentry *parent,
+					  struct vcap_control *vctrl)
+{
+	return NULL;
+}
+
+#endif
+#endif /* __VCAP_API_DEBUGFS__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index 6858e44ce4a5..a3dc1b2d029c 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -204,9 +204,9 @@ static void test_cache_move(struct net_device *ndev, struct vcap_admin *admin,
 }
 
 /* Provide port information via a callback interface */
-static int vcap_test_port_info(struct net_device *ndev, enum vcap_type vtype,
-			       int (*pf)(void *out, int arg, const char *fmt, ...),
-			       void *out, int arg)
+static int vcap_test_port_info(struct net_device *ndev,
+			       struct vcap_admin *admin,
+			       struct vcap_output_print *out)
 {
 	return 0;
 }
-- 
2.38.1

