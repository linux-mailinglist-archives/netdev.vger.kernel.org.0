Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D1C17C38F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgCFRFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:05:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:43684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCFRFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:05:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69616B216;
        Fri,  6 Mar 2020 17:05:10 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 136C6E00E7; Fri,  6 Mar 2020 18:05:10 +0100 (CET)
Message-Id: <5cdb94b000c60287e8dfffa20926329f18199128.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 14/25] netlink: partial netlink handler for gset
 (no option)
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:05:10 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Partially implement "ethtool <dev>" subcommand. This commit retrieves and
displays information provided by ETHTOOL_MSG_LINKINFO_GET,
ETHTOOL_MSG_LINKMODES_GET and ETHTOOL_MSG_LINKSTATE_GET netlink requests,
i.e. everything except wake-on-lan and debugging (msglevel).

Also register the callbacks in monitor so that corresponding notifications
can be displayed with "ethtool --monitor".

v2:
  - print banner only once unless monitor or wildcard (dump request)
  - suppress error messages for -EOPNOTSUPP responses
  - only show "No data available" if there is no reply at all
  - more readable nl_gset()
v3:
  - fix gcc9 compiler warning

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am        |   1 +
 ethtool.c          |   1 +
 netlink/extapi.h   |   3 +
 netlink/monitor.c  |  16 ++
 netlink/netlink.h  |   4 +
 netlink/settings.c | 647 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 672 insertions(+)
 create mode 100644 netlink/settings.c

diff --git a/Makefile.am b/Makefile.am
index 616c45007fbd..eeb36a279045 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,6 +29,7 @@ ethtool_SOURCES += \
 		  netlink/msgbuff.c netlink/msgbuff.h netlink/nlsock.c \
 		  netlink/nlsock.h netlink/strset.c netlink/strset.h \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
+		  netlink/settings.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.c b/ethtool.c
index c2b7cc8c0502..a69233bd73fc 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5805,6 +5805,7 @@ int main(int argc, char **argp)
 	}
 	if ((*argp)[0] == '-')
 		exit_bad_args();
+	nlfunc = nl_gset;
 	func = do_gset;
 	no_dev = false;
 
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 1d5b68226af4..8608ea7f51f5 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -15,6 +15,7 @@ struct nl_context;
 int netlink_init(struct cmd_context *ctx);
 void netlink_done(struct cmd_context *ctx);
 
+int nl_gset(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -34,6 +35,8 @@ static inline void nl_monitor_usage(void)
 {
 }
 
+#define nl_gset			NULL
+
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
 #endif /* ETHTOOL_EXTAPI_H__ */
diff --git a/netlink/monitor.c b/netlink/monitor.c
index 300fd5bc2e51..e8fdcd2b93ef 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -15,6 +15,14 @@ static struct {
 	uint8_t		cmd;
 	mnl_cb_t	cb;
 } monitor_callbacks[] = {
+	{
+		.cmd	= ETHTOOL_MSG_LINKMODES_NTF,
+		.cb	= linkmodes_reply_cb,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKINFO_NTF,
+		.cb	= linkinfo_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
@@ -70,6 +78,14 @@ static struct monitor_option monitor_opts[] = {
 		.pattern	= "|--all",
 		.cmd		= 0,
 	},
+	{
+		.pattern	= "-s|--change",
+		.cmd		= ETHTOOL_MSG_LINKINFO_NTF,
+	},
+	{
+		.pattern	= "-s|--change",
+		.cmd		= ETHTOOL_MSG_LINKMODES_NTF,
+	},
 };
 
 static bool pattern_match(const char *s, const char *pattern)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index be44f9c16f19..16754899976d 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -30,6 +30,7 @@ struct nl_context {
 	bool			is_monitor;
 	uint32_t		filter_cmds[CMDMASK_WORDS];
 	const char		*filter_devname;
+	bool			no_banner;
 };
 
 struct attr_tb_info {
@@ -46,6 +47,9 @@ int attr_cb(const struct nlattr *attr, void *data);
 const char *get_dev_name(const struct nlattr *nest);
 int get_dev_info(const struct nlattr *nest, int *ifindex, char *ifname);
 
+int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+
 static inline void copy_devname(char *dst, const char *src)
 {
 	strncpy(dst, src, ALTIFNAMSIZ);
diff --git a/netlink/settings.c b/netlink/settings.c
new file mode 100644
index 000000000000..25d0f02210b5
--- /dev/null
+++ b/netlink/settings.c
@@ -0,0 +1,647 @@
+/*
+ * settings.c - netlink implementation of settings commands
+ *
+ * Implementation of "ethtool <dev>" and "ethtool -s <dev> ...".
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "strset.h"
+#include "bitset.h"
+
+/* GET_SETTINGS */
+
+enum link_mode_class {
+	LM_CLASS_UNKNOWN,
+	LM_CLASS_REAL,
+	LM_CLASS_AUTONEG,
+	LM_CLASS_PORT,
+	LM_CLASS_PAUSE,
+	LM_CLASS_FEC,
+};
+
+struct link_mode_info {
+	enum link_mode_class	class;
+	u32			speed;
+	u8			duplex;
+};
+
+static const char *const names_duplex[] = {
+	[DUPLEX_HALF]		= "Half",
+	[DUPLEX_FULL]		= "Full",
+};
+
+static const char *const names_port[] = {
+	[PORT_TP]		= "Twisted Pair",
+	[PORT_AUI]		= "AUI",
+	[PORT_BNC]		= "BNC",
+	[PORT_MII]		= "MII",
+	[PORT_FIBRE]		= "FIBRE",
+	[PORT_DA]		= "Direct Attach Copper",
+	[PORT_NONE]		= "None",
+	[PORT_OTHER]		= "Other",
+};
+
+static const char *const names_transceiver[] = {
+	[XCVR_INTERNAL]		= "internal",
+	[XCVR_EXTERNAL]		= "external",
+};
+
+/* the practice of putting completely unrelated flags into link mode bitmaps
+ * is rather unfortunate but as even ethtool_link_ksettings preserved that,
+ * there is little chance of getting them separated any time soon so let's
+ * sort them out ourselves
+ */
+static const struct link_mode_info link_modes[] = {
+	[ETHTOOL_LINK_MODE_10baseT_Half_BIT] =
+		{ LM_CLASS_REAL,	10,	DUPLEX_HALF },
+	[ETHTOOL_LINK_MODE_10baseT_Full_BIT] =
+		{ LM_CLASS_REAL,	10,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100baseT_Half_BIT] =
+		{ LM_CLASS_REAL,	100,	DUPLEX_HALF },
+	[ETHTOOL_LINK_MODE_100baseT_Full_BIT] =
+		{ LM_CLASS_REAL,	100,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_1000baseT_Half_BIT] =
+		{ LM_CLASS_REAL,	1000,	DUPLEX_HALF },
+	[ETHTOOL_LINK_MODE_1000baseT_Full_BIT] =
+		{ LM_CLASS_REAL,	1000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_Autoneg_BIT] =
+		{ LM_CLASS_AUTONEG },
+	[ETHTOOL_LINK_MODE_TP_BIT] =
+		{ LM_CLASS_PORT },
+	[ETHTOOL_LINK_MODE_AUI_BIT] =
+		{ LM_CLASS_PORT },
+	[ETHTOOL_LINK_MODE_MII_BIT] =
+		{ LM_CLASS_PORT },
+	[ETHTOOL_LINK_MODE_FIBRE_BIT] =
+		{ LM_CLASS_PORT },
+	[ETHTOOL_LINK_MODE_BNC_BIT] =
+		{ LM_CLASS_PORT },
+	[ETHTOOL_LINK_MODE_10000baseT_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_Pause_BIT] =
+		{ LM_CLASS_PAUSE },
+	[ETHTOOL_LINK_MODE_Asym_Pause_BIT] =
+		{ LM_CLASS_PAUSE },
+	[ETHTOOL_LINK_MODE_2500baseX_Full_BIT] =
+		{ LM_CLASS_REAL,	2500,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_Backplane_BIT] =
+		{ LM_CLASS_PORT },
+	[ETHTOOL_LINK_MODE_1000baseKX_Full_BIT] =
+		{ LM_CLASS_REAL,	1000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseKR_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT] =
+		{ LM_CLASS_REAL,	20000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT] =
+		{ LM_CLASS_REAL,	20000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT] =
+		{ LM_CLASS_REAL,	40000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT] =
+		{ LM_CLASS_REAL,	40000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT] =
+		{ LM_CLASS_REAL,	40000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT] =
+		{ LM_CLASS_REAL,	40000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_56000baseKR4_Full_BIT] =
+		{ LM_CLASS_REAL,	56000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_56000baseCR4_Full_BIT] =
+		{ LM_CLASS_REAL,	56000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_56000baseSR4_Full_BIT] =
+		{ LM_CLASS_REAL,	56000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_56000baseLR4_Full_BIT] =
+		{ LM_CLASS_REAL,	56000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_25000baseCR_Full_BIT] =
+		{ LM_CLASS_REAL,	25000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_25000baseKR_Full_BIT] =
+		{ LM_CLASS_REAL,	25000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_25000baseSR_Full_BIT] =
+		{ LM_CLASS_REAL,	25000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_1000baseX_Full_BIT] =
+		{ LM_CLASS_REAL,	1000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseCR_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseSR_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseLR_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_10000baseER_Full_BIT] =
+		{ LM_CLASS_REAL,	10000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_2500baseT_Full_BIT] =
+		{ LM_CLASS_REAL,	2500,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_5000baseT_Full_BIT] =
+		{ LM_CLASS_REAL,	5000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_FEC_NONE_BIT] =
+		{ LM_CLASS_FEC },
+	[ETHTOOL_LINK_MODE_FEC_RS_BIT] =
+		{ LM_CLASS_FEC },
+	[ETHTOOL_LINK_MODE_FEC_BASER_BIT] =
+		{ LM_CLASS_FEC },
+	[ETHTOOL_LINK_MODE_50000baseKR_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseSR_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseCR_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_50000baseDR_Full_BIT] =
+		{ LM_CLASS_REAL,	50000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseKR2_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseSR2_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseCR2_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseLR2_ER2_FR2_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100000baseDR2_Full_BIT] =
+		{ LM_CLASS_REAL,	100000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_200000baseKR4_Full_BIT] =
+		{ LM_CLASS_REAL,	200000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_200000baseSR4_Full_BIT] =
+		{ LM_CLASS_REAL,	200000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT] =
+		{ LM_CLASS_REAL,	200000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT] =
+		{ LM_CLASS_REAL,	200000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT] =
+		{ LM_CLASS_REAL,	200000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_100baseT1_Full_BIT] =
+		{ LM_CLASS_REAL,	100,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_1000baseT1_Full_BIT] =
+		{ LM_CLASS_REAL,	1000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT] =
+		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT] =
+		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT] =
+		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT] =
+		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
+	[ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT] =
+		{ LM_CLASS_REAL,	400000,	DUPLEX_FULL },
+};
+const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
+
+static bool lm_class_match(unsigned int mode, enum link_mode_class class)
+{
+	unsigned int mode_class = (mode < link_modes_count) ?
+				   link_modes[mode].class : LM_CLASS_UNKNOWN;
+
+	return mode_class == class ||
+	       (class == LM_CLASS_REAL && mode_class == LM_CLASS_UNKNOWN);
+}
+
+static void print_enum(const char *const *info, unsigned int n_info,
+		       unsigned int val, const char *label)
+{
+	if (val >= n_info || !info[val])
+		printf("\t%s: Unknown! (%d)\n", label, val);
+	else
+		printf("\t%s: %s\n", label, info[val]);
+}
+
+static int dump_pause(const struct nlattr *attr, bool mask, const char *label)
+{
+	bool pause, asym;
+	int ret = 0;
+
+	pause = bitset_get_bit(attr, mask, ETHTOOL_LINK_MODE_Pause_BIT, &ret);
+	if (ret < 0)
+		goto err;
+	asym = bitset_get_bit(attr, mask, ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      &ret);
+	if (ret < 0)
+		goto err;
+
+	printf("\t%s", label);
+	if (pause)
+		printf("%s\n", asym ?  "Symmetric Receive-only" : "Symmetric");
+	else
+		printf("%s\n", asym ? "Transmit-only" : "No");
+
+	return 0;
+err:
+	fprintf(stderr, "malformed netlink message (pause modes)\n");
+	return ret;
+}
+
+static void print_banner(struct nl_context *nlctx)
+{
+	if (nlctx->no_banner)
+		return;
+	printf("Settings for %s:\n", nlctx->devname);
+	nlctx->no_banner = true;
+}
+
+static int dump_link_modes(struct nl_context *nlctx,
+			   const struct nlattr *bitset, bool mask,
+			   unsigned int class, const char *before,
+			   const char *between, const char *after,
+			   const char *if_none)
+{
+	const struct nlattr *bitset_tb[ETHTOOL_A_BITSET_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(bitset_tb);
+	const unsigned int before_len = strlen(before);
+	const struct nlattr *bits;
+	const struct nlattr *bit;
+	bool first = true;
+	int prev = -2;
+	int ret;
+
+	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
+	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
+	if (ret < 0)
+		goto err_nonl;
+	if (!bits) {
+		const struct stringset *lm_strings;
+		unsigned int count;
+		unsigned int idx;
+		const char *name;
+
+		ret = netlink_init_ethnl2_socket(nlctx);
+		if (ret < 0)
+			goto err_nonl;
+		lm_strings = global_stringset(ETH_SS_LINK_MODES,
+					      nlctx->ethnl2_socket);
+		bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
+			      bitset_tb[ETHTOOL_A_BITSET_VALUE];
+		ret = -EFAULT;
+		if (!bits || !bitset_tb[ETHTOOL_A_BITSET_SIZE])
+			goto err_nonl;
+		count = mnl_attr_get_u32(bitset_tb[ETHTOOL_A_BITSET_SIZE]);
+		if (mnl_attr_get_payload_len(bits) / 4 < (count + 31) / 32)
+			goto err_nonl;
+
+		printf("\t%s", before);
+		for (idx = 0; idx < count; idx++) {
+			const uint32_t *raw_data = mnl_attr_get_payload(bits);
+			char buff[14];
+
+			if (!(raw_data[idx / 32] & (1U << (idx % 32))))
+				continue;
+			if (!lm_class_match(idx, class))
+				continue;
+			name = get_string(lm_strings, idx);
+			if (!name) {
+				snprintf(buff, sizeof(buff), "BIT%u", idx);
+				name = buff;
+			}
+			if (first)
+				first = false;
+			/* ugly hack to preserve old output format */
+			if (class == LM_CLASS_REAL && (prev == idx - 1) &&
+			    prev < link_modes_count &&
+			    link_modes[prev].class == LM_CLASS_REAL &&
+			    link_modes[prev].duplex == DUPLEX_HALF)
+				putchar(' ');
+			else if (between)
+				printf("\t%s", between);
+			else
+				printf("\n\t%*s", before_len, "");
+			printf("%s", name);
+			prev = idx;
+		}
+		goto after;
+	}
+
+	printf("\t%s", before);
+	mnl_attr_for_each_nested(bit, bits) {
+		const struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1] = {};
+		DECLARE_ATTR_TB_INFO(tb);
+		unsigned int idx;
+		const char *name;
+
+		if (mnl_attr_get_type(bit) != ETHTOOL_A_BITSET_BITS_BIT)
+			continue;
+		ret = mnl_attr_parse_nested(bit, attr_cb, &tb_info);
+		if (ret < 0)
+			goto err;
+		ret = -EFAULT;
+		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
+		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
+			goto err;
+		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
+			continue;
+
+		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
+		name = mnl_attr_get_str(tb[ETHTOOL_A_BITSET_BIT_NAME]);
+		if (!lm_class_match(idx, class))
+			continue;
+		if (first) {
+			first = false;
+		} else {
+			/* ugly hack to preserve old output format */
+			if ((class == LM_CLASS_REAL) && (prev == idx - 1) &&
+			    (prev < link_modes_count) &&
+			    (link_modes[prev].class == LM_CLASS_REAL) &&
+			    (link_modes[prev].duplex == DUPLEX_HALF))
+				putchar(' ');
+			else if (between)
+				printf("\t%s", between);
+			else
+				printf("\n\t%*s", before_len, "");
+		}
+		printf("%s", name);
+		prev = idx;
+	}
+after:
+	if (first && if_none)
+		printf("%s", if_none);
+	printf(after);
+
+	return 0;
+err:
+	putchar('\n');
+err_nonl:
+	fflush(stdout);
+	fprintf(stderr, "malformed netlink message (link_modes)\n");
+	return ret;
+}
+
+static int dump_our_modes(struct nl_context *nlctx, const struct nlattr *attr)
+{
+	bool autoneg;
+	int ret;
+
+	print_banner(nlctx);
+	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_PORT,
+			      "Supported ports: [ ", " ", " ]\n", NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_REAL,
+			      "Supported link modes:   ", NULL, "\n",
+			      "Not reported");
+	if (ret < 0)
+		return ret;
+	ret = dump_pause(attr, true, "Supported pause frame use: ");
+	if (ret < 0)
+		return ret;
+
+	autoneg = bitset_get_bit(attr, true, ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 &ret);
+	if (ret < 0)
+		return ret;
+	printf("\tSupports auto-negotiation: %s\n", autoneg ? "Yes" : "No");
+
+	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_FEC,
+			      "Supported FEC modes: ", " ", "\n",
+			      "Not reported");
+	if (ret < 0)
+		return ret;
+
+	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_REAL,
+			      "Advertised link modes:  ", NULL, "\n",
+			      "Not reported");
+	if (ret < 0)
+		return ret;
+
+	ret = dump_pause(attr, false, "Advertised pause frame use: ");
+	if (ret < 0)
+		return ret;
+	autoneg = bitset_get_bit(attr, false, ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 &ret);
+	if (ret < 0)
+		return ret;
+	printf("\tAdvertised auto-negotiation: %s\n", autoneg ? "Yes" : "No");
+
+	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_FEC,
+			      "Advertised FEC modes: ", " ", "\n",
+			      "Not reported");
+	return ret;
+}
+
+static int dump_peer_modes(struct nl_context *nlctx, const struct nlattr *attr)
+{
+	bool autoneg;
+	int ret;
+
+	print_banner(nlctx);
+	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_REAL,
+			      "Link partner advertised link modes:  ",
+			      NULL, "\n", "Not reported");
+	if (ret < 0)
+		return ret;
+
+	ret = dump_pause(attr, false,
+			 "Link partner advertised pause frame use: ");
+	if (ret < 0)
+		return ret;
+
+	autoneg = bitset_get_bit(attr, false,
+				 ETHTOOL_LINK_MODE_Autoneg_BIT, &ret);
+	if (ret < 0)
+		return ret;
+	printf("\tLink partner advertised auto-negotiation: %s\n",
+	       autoneg ? "Yes" : "No");
+
+	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_FEC,
+			      "Link partner advertised FEC modes: ",
+			      " ", "\n", "No");
+	return ret;
+}
+
+int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_LINKMODES_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_LINKMODES_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (tb[ETHTOOL_A_LINKMODES_OURS]) {
+		ret = dump_our_modes(nlctx, tb[ETHTOOL_A_LINKMODES_OURS]);
+		if (ret < 0)
+			goto err;
+	}
+	if (tb[ETHTOOL_A_LINKMODES_PEER]) {
+		ret = dump_peer_modes(nlctx, tb[ETHTOOL_A_LINKMODES_PEER]);
+		if (ret < 0)
+			goto err;
+	}
+	if (tb[ETHTOOL_A_LINKMODES_SPEED]) {
+		uint32_t val = mnl_attr_get_u32(tb[ETHTOOL_A_LINKMODES_SPEED]);
+
+		print_banner(nlctx);
+		if (val == 0 || val == (uint16_t)(-1) || val == (uint32_t)(-1))
+			printf("\tSpeed: Unknown!\n");
+		else
+			printf("\tSpeed: %uMb/s\n", val);
+	}
+	if (tb[ETHTOOL_A_LINKMODES_DUPLEX]) {
+		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_DUPLEX]);
+
+		print_banner(nlctx);
+		print_enum(names_duplex, ARRAY_SIZE(names_duplex), val,
+			   "Duplex");
+	}
+	if (tb[ETHTOOL_A_LINKMODES_AUTONEG]) {
+		int autoneg = mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_AUTONEG]);
+
+		print_banner(nlctx);
+		printf("\tAuto-negotiation: %s\n",
+		       (autoneg == AUTONEG_DISABLE) ? "off" : "on");
+	}
+
+	return MNL_CB_OK;
+err:
+	if (nlctx->is_monitor || nlctx->is_dump)
+		return MNL_CB_OK;
+	fputs("No data available\n", stdout);
+	nlctx->exit_code = 75;
+	return MNL_CB_ERROR;
+}
+
+int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_LINKINFO_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	int port = -1;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_LINKINFO_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (tb[ETHTOOL_A_LINKINFO_PORT]) {
+		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_PORT]);
+
+		print_banner(nlctx);
+		print_enum(names_port, ARRAY_SIZE(names_port), val, "Port");
+		port = val;
+	}
+	if (tb[ETHTOOL_A_LINKINFO_PHYADDR]) {
+		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_PHYADDR]);
+
+		print_banner(nlctx);
+		printf("\tPHYAD: %u\n", val);
+	}
+	if (tb[ETHTOOL_A_LINKINFO_TRANSCEIVER]) {
+		uint8_t val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TRANSCEIVER]);
+		print_banner(nlctx);
+		print_enum(names_transceiver, ARRAY_SIZE(names_transceiver),
+			   val, "Transceiver");
+	}
+	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX] &&
+	    port == PORT_TP) {
+		uint8_t mdix = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX]);
+		uint8_t mdix_ctrl =
+			mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]);
+
+		print_banner(nlctx);
+		dump_mdix(mdix, mdix_ctrl);
+	}
+
+	return MNL_CB_OK;
+}
+
+int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_LINKSTATE_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_LINKSTATE_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	if (tb[ETHTOOL_A_LINKSTATE_LINK]) {
+		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_LINK]);
+
+		print_banner(nlctx);
+		printf("\tLink detected: %s\n", val ? "yes" : "no");
+	}
+
+	return MNL_CB_OK;
+}
+
+static int gset_request(struct nl_socket *nlsk, uint8_t msg_type,
+			uint16_t hdr_attr, mnl_cb_t cb)
+{
+	int ret;
+
+	ret = nlsock_prep_get_request(nlsk, msg_type, hdr_attr, 0);
+	if (ret < 0)
+		return ret;
+	return nlsock_send_get_request(nlsk, cb);
+}
+
+int nl_gset(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	nlctx->suppress_nlerr = 1;
+
+	ret = gset_request(nlsk, ETHTOOL_MSG_LINKMODES_GET,
+			   ETHTOOL_A_LINKMODES_HEADER, linkmodes_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
+	ret = gset_request(nlsk, ETHTOOL_MSG_LINKINFO_GET,
+			   ETHTOOL_A_LINKINFO_HEADER, linkinfo_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
+	ret = gset_request(nlsk, ETHTOOL_MSG_LINKSTATE_GET,
+			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
+	if (!nlctx->no_banner) {
+		printf("No data available\n");
+		return 75;
+	}
+
+	return 0;
+}
-- 
2.25.1

