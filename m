Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0E1799BA
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgCDUZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:25:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:33566 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:25:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E4F2AE99;
        Wed,  4 Mar 2020 20:25:36 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4CAFEE037F; Wed,  4 Mar 2020 21:25:36 +0100 (CET)
Message-Id: <64325650e41b075ec5cb285b58cb447e7e00df4d.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 12/25] move shared code into a common file
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:25:36 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move code which is going to be shared between ioctl and netlink
implementation into a common file common.c and declarations into header
file common.h.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am |   2 +-
 common.c    | 145 +++++++++++++++++++++++++++++++++++++++++++++++++
 common.h    |  26 +++++++++
 ethtool.c   | 151 +++-------------------------------------------------
 4 files changed, 179 insertions(+), 145 deletions(-)
 create mode 100644 common.c
 create mode 100644 common.h

diff --git a/Makefile.am b/Makefile.am
index 0aa88ead27d5..90723a49b591 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -6,7 +6,7 @@ EXTRA_DIST = LICENSE ethtool.8 ethtool.spec.in aclocal.m4 ChangeLog autogen.sh
 
 sbin_PROGRAMS = ethtool
 ethtool_SOURCES = ethtool.c uapi/linux/ethtool.h internal.h \
-		  uapi/linux/net_tstamp.h rxclass.c
+		  uapi/linux/net_tstamp.h rxclass.c common.c common.h
 ethtool_CFLAGS = $(AM_CFLAGS)
 ethtool_LDADD = $(LDADD)
 if ETHTOOL_ENABLE_PRETTY_DUMP
diff --git a/common.c b/common.c
new file mode 100644
index 000000000000..f9c41a32d3a3
--- /dev/null
+++ b/common.c
@@ -0,0 +1,145 @@
+/*
+ * common.h - common code header
+ *
+ * Data and functions shared by ioctl and netlink implementation.
+ */
+
+#include "internal.h"
+#include "common.h"
+
+#ifndef HAVE_NETIF_MSG
+enum {
+	NETIF_MSG_DRV		= 0x0001,
+	NETIF_MSG_PROBE		= 0x0002,
+	NETIF_MSG_LINK		= 0x0004,
+	NETIF_MSG_TIMER		= 0x0008,
+	NETIF_MSG_IFDOWN	= 0x0010,
+	NETIF_MSG_IFUP		= 0x0020,
+	NETIF_MSG_RX_ERR	= 0x0040,
+	NETIF_MSG_TX_ERR	= 0x0080,
+	NETIF_MSG_TX_QUEUED	= 0x0100,
+	NETIF_MSG_INTR		= 0x0200,
+	NETIF_MSG_TX_DONE	= 0x0400,
+	NETIF_MSG_RX_STATUS	= 0x0800,
+	NETIF_MSG_PKTDATA	= 0x1000,
+	NETIF_MSG_HW		= 0x2000,
+	NETIF_MSG_WOL		= 0x4000,
+};
+#endif
+
+const struct flag_info flags_msglvl[] = {
+	{ "drv",	NETIF_MSG_DRV },
+	{ "probe",	NETIF_MSG_PROBE },
+	{ "link",	NETIF_MSG_LINK },
+	{ "timer",	NETIF_MSG_TIMER },
+	{ "ifdown",	NETIF_MSG_IFDOWN },
+	{ "ifup",	NETIF_MSG_IFUP },
+	{ "rx_err",	NETIF_MSG_RX_ERR },
+	{ "tx_err",	NETIF_MSG_TX_ERR },
+	{ "tx_queued",	NETIF_MSG_TX_QUEUED },
+	{ "intr",	NETIF_MSG_INTR },
+	{ "tx_done",	NETIF_MSG_TX_DONE },
+	{ "rx_status",	NETIF_MSG_RX_STATUS },
+	{ "pktdata",	NETIF_MSG_PKTDATA },
+	{ "hw",		NETIF_MSG_HW },
+	{ "wol",	NETIF_MSG_WOL },
+	{}
+};
+const unsigned int n_flags_msglvl = ARRAY_SIZE(flags_msglvl) - 1;
+
+void print_flags(const struct flag_info *info, unsigned int n_info, u32 value)
+{
+	const char *sep = "";
+
+	while (n_info) {
+		if (value & info->value) {
+			printf("%s%s", sep, info->name);
+			sep = " ";
+			value &= ~info->value;
+		}
+		++info;
+		--n_info;
+	}
+
+	/* Print any unrecognised flags in hex */
+	if (value)
+		printf("%s%#x", sep, value);
+}
+
+static char *unparse_wolopts(int wolopts)
+{
+	static char buf[16];
+	char *p = buf;
+
+	memset(buf, 0, sizeof(buf));
+
+	if (wolopts) {
+		if (wolopts & WAKE_PHY)
+			*p++ = 'p';
+		if (wolopts & WAKE_UCAST)
+			*p++ = 'u';
+		if (wolopts & WAKE_MCAST)
+			*p++ = 'm';
+		if (wolopts & WAKE_BCAST)
+			*p++ = 'b';
+		if (wolopts & WAKE_ARP)
+			*p++ = 'a';
+		if (wolopts & WAKE_MAGIC)
+			*p++ = 'g';
+		if (wolopts & WAKE_MAGICSECURE)
+			*p++ = 's';
+		if (wolopts & WAKE_FILTER)
+			*p++ = 'f';
+	} else {
+		*p = 'd';
+	}
+
+	return buf;
+}
+
+int dump_wol(struct ethtool_wolinfo *wol)
+{
+	fprintf(stdout, "	Supports Wake-on: %s\n",
+		unparse_wolopts(wol->supported));
+	fprintf(stdout, "	Wake-on: %s\n",
+		unparse_wolopts(wol->wolopts));
+	if (wol->supported & WAKE_MAGICSECURE) {
+		int i;
+		int delim = 0;
+
+		fprintf(stdout, "        SecureOn password: ");
+		for (i = 0; i < SOPASS_MAX; i++) {
+			fprintf(stdout, "%s%02x", delim ? ":" : "",
+				wol->sopass[i]);
+			delim = 1;
+		}
+		fprintf(stdout, "\n");
+	}
+
+	return 0;
+}
+
+void dump_mdix(u8 mdix, u8 mdix_ctrl)
+{
+	fprintf(stdout, "	MDI-X: ");
+	if (mdix_ctrl == ETH_TP_MDI) {
+		fprintf(stdout, "off (forced)\n");
+	} else if (mdix_ctrl == ETH_TP_MDI_X) {
+		fprintf(stdout, "on (forced)\n");
+	} else {
+		switch (mdix) {
+		case ETH_TP_MDI:
+			fprintf(stdout, "off");
+			break;
+		case ETH_TP_MDI_X:
+			fprintf(stdout, "on");
+			break;
+		default:
+			fprintf(stdout, "Unknown");
+			break;
+		}
+		if (mdix_ctrl == ETH_TP_MDI_AUTO)
+			fprintf(stdout, " (auto)");
+		fprintf(stdout, "\n");
+	}
+}
diff --git a/common.h b/common.h
new file mode 100644
index 000000000000..3a680114a7c2
--- /dev/null
+++ b/common.h
@@ -0,0 +1,26 @@
+/*
+ * common.h - common code header
+ *
+ * Declarations for data and functions shared by ioctl and netlink code.
+ */
+
+#ifndef ETHTOOL_COMMON_H__
+#define ETHTOOL_COMMON_H__
+
+#include "internal.h"
+
+#define KERNEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
+
+struct flag_info {
+	const char *name;
+	u32 value;
+};
+
+extern const struct flag_info flags_msglvl[];
+extern const unsigned int n_flags_msglvl;
+
+void print_flags(const struct flag_info *info, unsigned int n_info, u32 value);
+int dump_wol(struct ethtool_wolinfo *wol);
+void dump_mdix(u8 mdix, u8 mdix_ctrl);
+
+#endif /* ETHTOOL_COMMON_H__ */
diff --git a/ethtool.c b/ethtool.c
index 97eaa58a3090..c2b7cc8c0502 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -48,32 +48,13 @@
 #include <linux/sockios.h>
 #include <linux/netlink.h>
 
+#include "common.h"
 #include "netlink/extapi.h"
 
 #ifndef MAX_ADDR_LEN
 #define MAX_ADDR_LEN	32
 #endif
 
-#ifndef HAVE_NETIF_MSG
-enum {
-	NETIF_MSG_DRV		= 0x0001,
-	NETIF_MSG_PROBE		= 0x0002,
-	NETIF_MSG_LINK		= 0x0004,
-	NETIF_MSG_TIMER		= 0x0008,
-	NETIF_MSG_IFDOWN	= 0x0010,
-	NETIF_MSG_IFUP		= 0x0020,
-	NETIF_MSG_RX_ERR	= 0x0040,
-	NETIF_MSG_TX_ERR	= 0x0080,
-	NETIF_MSG_TX_QUEUED	= 0x0100,
-	NETIF_MSG_INTR		= 0x0200,
-	NETIF_MSG_TX_DONE	= 0x0400,
-	NETIF_MSG_RX_STATUS	= 0x0800,
-	NETIF_MSG_PKTDATA	= 0x1000,
-	NETIF_MSG_HW		= 0x2000,
-	NETIF_MSG_WOL		= 0x4000,
-};
-#endif
-
 #ifndef NETLINK_GENERIC
 #define NETLINK_GENERIC	16
 #endif
@@ -121,29 +102,6 @@ struct cmdline_info {
 	void *seen_val;
 };
 
-struct flag_info {
-	const char *name;
-	u32 value;
-};
-
-static const struct flag_info flags_msglvl[] = {
-	{ "drv",	NETIF_MSG_DRV },
-	{ "probe",	NETIF_MSG_PROBE },
-	{ "link",	NETIF_MSG_LINK },
-	{ "timer",	NETIF_MSG_TIMER },
-	{ "ifdown",	NETIF_MSG_IFDOWN },
-	{ "ifup",	NETIF_MSG_IFUP },
-	{ "rx_err",	NETIF_MSG_RX_ERR },
-	{ "tx_err",	NETIF_MSG_TX_ERR },
-	{ "tx_queued",	NETIF_MSG_TX_QUEUED },
-	{ "intr",	NETIF_MSG_INTR },
-	{ "tx_done",	NETIF_MSG_TX_DONE },
-	{ "rx_status",	NETIF_MSG_RX_STATUS },
-	{ "pktdata",	NETIF_MSG_PKTDATA },
-	{ "hw",		NETIF_MSG_HW },
-	{ "wol",	NETIF_MSG_WOL },
-};
-
 struct off_flag_def {
 	const char *short_name;
 	const char *long_name;
@@ -426,26 +384,6 @@ static void flag_to_cmdline_info(const char *name, u32 value,
 	cli->seen_val = mask;
 }
 
-static void
-print_flags(const struct flag_info *info, unsigned int n_info, u32 value)
-{
-	const char *sep = "";
-
-	while (n_info) {
-		if (value & info->value) {
-			printf("%s%s", sep, info->name);
-			sep = " ";
-			value &= ~info->value;
-		}
-		++info;
-		--n_info;
-	}
-
-	/* Print any unrecognised flags in hex */
-	if (value)
-		printf("%s%#x", sep, value);
-}
-
 static int rxflow_str_to_type(const char *str)
 {
 	int flow_type = 0;
@@ -904,31 +842,9 @@ dump_link_usettings(const struct ethtool_link_usettings *link_usettings)
 		(link_usettings->base.autoneg == AUTONEG_DISABLE) ?
 		"off" : "on");
 
-	if (link_usettings->base.port == PORT_TP) {
-		fprintf(stdout, "	MDI-X: ");
-		if (link_usettings->base.eth_tp_mdix_ctrl == ETH_TP_MDI) {
-			fprintf(stdout, "off (forced)\n");
-		} else if (link_usettings->base.eth_tp_mdix_ctrl
-			   == ETH_TP_MDI_X) {
-			fprintf(stdout, "on (forced)\n");
-		} else {
-			switch (link_usettings->base.eth_tp_mdix) {
-			case ETH_TP_MDI:
-				fprintf(stdout, "off");
-				break;
-			case ETH_TP_MDI_X:
-				fprintf(stdout, "on");
-				break;
-			default:
-				fprintf(stdout, "Unknown");
-				break;
-			}
-			if (link_usettings->base.eth_tp_mdix_ctrl
-			    == ETH_TP_MDI_AUTO)
-				fprintf(stdout, " (auto)");
-			fprintf(stdout, "\n");
-		}
-	}
+	if (link_usettings->base.port == PORT_TP)
+		dump_mdix(link_usettings->base.eth_tp_mdix,
+			  link_usettings->base.eth_tp_mdix_ctrl);
 
 	return 0;
 }
@@ -1000,58 +916,6 @@ static int parse_wolopts(char *optstr, u32 *data)
 	return 0;
 }
 
-static char *unparse_wolopts(int wolopts)
-{
-	static char buf[16];
-	char *p = buf;
-
-	memset(buf, 0, sizeof(buf));
-
-	if (wolopts) {
-		if (wolopts & WAKE_PHY)
-			*p++ = 'p';
-		if (wolopts & WAKE_UCAST)
-			*p++ = 'u';
-		if (wolopts & WAKE_MCAST)
-			*p++ = 'm';
-		if (wolopts & WAKE_BCAST)
-			*p++ = 'b';
-		if (wolopts & WAKE_ARP)
-			*p++ = 'a';
-		if (wolopts & WAKE_MAGIC)
-			*p++ = 'g';
-		if (wolopts & WAKE_MAGICSECURE)
-			*p++ = 's';
-		if (wolopts & WAKE_FILTER)
-			*p++ = 'f';
-	} else {
-		*p = 'd';
-	}
-
-	return buf;
-}
-
-static int dump_wol(struct ethtool_wolinfo *wol)
-{
-	fprintf(stdout, "	Supports Wake-on: %s\n",
-		unparse_wolopts(wol->supported));
-	fprintf(stdout, "	Wake-on: %s\n",
-		unparse_wolopts(wol->wolopts));
-	if (wol->supported & WAKE_MAGICSECURE) {
-		int i;
-		int delim = 0;
-
-		fprintf(stdout, "        SecureOn password: ");
-		for (i = 0; i < SOPASS_MAX; i++) {
-			fprintf(stdout, "%s%02x", delim?":":"", wol->sopass[i]);
-			delim = 1;
-		}
-		fprintf(stdout, "\n");
-	}
-
-	return 0;
-}
-
 static int parse_rxfhashopts(char *optstr, u32 *data)
 {
 	*data = 0;
@@ -2839,8 +2703,7 @@ static int do_gset(struct cmd_context *ctx)
 		fprintf(stdout, "	Current message level: 0x%08x (%d)\n"
 			"			       ",
 			edata.data, edata.data);
-		print_flags(flags_msglvl, ARRAY_SIZE(flags_msglvl),
-			    edata.data);
+		print_flags(flags_msglvl, n_flags_msglvl, edata.data);
 		fprintf(stdout, "\n");
 		allfail = 0;
 	} else if (errno != EOPNOTSUPP) {
@@ -2886,13 +2749,13 @@ static int do_sset(struct cmd_context *ctx)
 	int msglvl_changed = 0;
 	u32 msglvl_wanted = 0;
 	u32 msglvl_mask = 0;
-	struct cmdline_info cmdline_msglvl[ARRAY_SIZE(flags_msglvl)];
+	struct cmdline_info cmdline_msglvl[n_flags_msglvl];
 	int argc = ctx->argc;
 	char **argp = ctx->argp;
 	int i;
 	int err = 0;
 
-	for (i = 0; i < ARRAY_SIZE(flags_msglvl); i++)
+	for (i = 0; i < n_flags_msglvl; i++)
 		flag_to_cmdline_info(flags_msglvl[i].name,
 				     flags_msglvl[i].value,
 				     &msglvl_wanted, &msglvl_mask,
-- 
2.25.1

