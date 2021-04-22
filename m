Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2477E368394
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhDVPlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236502AbhDVPlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC036140F;
        Thu, 22 Apr 2021 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619106056;
        bh=aEq1+AGRcZe/EhljEcYX2TrbrhkxWjT95pHtw1+Eh+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI3hrRiJC2aJRDbtnYn2d1HxPUEpPB+D3nzby4t+MkupxuBz/LTLwa9e3ydi3KS2U
         XklF5mrbCK0GTDXEAVjMNpXJ5NJl31uaD4YYG0Y/5nkD2Yvwd8m4VU7AxC6NREYNVR
         B4r8yty2E9xTHCvfVLiQJ9XTuxy/NFVT0cDFHR09yy7IJoJlsPOtkSjYMeo74wUz36
         uyIVmwODoQ1AuitB13xHI+hQVTn/Aa8aTvWouvlQcy3XJyxE7YLb8OmtQeJuFxTNBD
         YORJX+xrlxR52Sy60TZ4ewS/UElPPWknN6dJSdXuAFHWTZseKTLWDs57/1ZA7sEmmG
         HGvuvOoXH6x6g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 6/7] netlink: add support for standard stats
Date:   Thu, 22 Apr 2021 08:40:49 -0700
Message-Id: <20210422154050.3339628-7-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422154050.3339628-1-kuba@kernel.org>
References: <20210422154050.3339628-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for standard-based stats.

Unlike ethtool -S eth0 the new stats should be allow cross-vendor
compatibility. The interface depends on bitsets and is rather simple.

 # ethtool -S eth0 --groups eth-phy eth-mac rmon
Stats for eth0:
eth-phy-SymbolErrorDuringCarrier: 1
eth-mac-FramesTransmittedOK: 1
eth-mac-FrameTooLongErrors: 1
rmon-etherStatsUndersizePkts: 1
rmon-etherStatsJabbers: 1
rmon-rx-etherStatsPkts64Octets: 1
rmon-rx-etherStatsPkts128to255Octets: 1
rmon-rx-etherStatsPkts1024toMaxOctets: 0

In JSON form stats are grouped and histograms are broken out:

 # ethtool --json -S eth0 --groups eth-phy eth-mac rmon | jq
 [
  {
    "ifname": "eth0",
    "eth-phy": {
      "SymbolErrorDuringCarrier": 1
    },
    "eth-mac": {
      "FramesTransmittedOK": 1,
      "FrameTooLongErrors": 0
    },
    "rmon": {
      "etherStatsUndersizePkts": 1,
      "etherStatsJabbers": 0,
      "rx-pktsNtoM": [
        {
          "low": 0,
          "high": 64,
          "val": 1
        },
        {
          "low": 128,
          "high": 255,
          "val": 1
        },
        {
          "low": 1024,
          "high": 0,
          "val": 0
        }
      ]
    }
  }
 ]

This allows for easy querying, e.g. to add up all packets larger
than 128 (assuming buckets align):

 # ethtool --json -S eth0 --groups eth-phy eth-mac rmon | \
     jq '.[].rmon."rx-pktsNtoM" | map(select(.low >= 128)) | map(.val) | add'
 1

v2: fix hanging "and"

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Ido Schimmel <idosch@nvidia.com>
---
 Makefile.am            |   1 +
 ethtool.8.in           |  20 +++-
 ethtool.c              |   5 +-
 netlink/desc-ethtool.c |  39 ++++++
 netlink/extapi.h       |   4 +
 netlink/stats.c        | 264 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 330 insertions(+), 3 deletions(-)
 create mode 100644 netlink/stats.c

diff --git a/Makefile.am b/Makefile.am
index f643a24af97a..75c245653cda 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -36,6 +36,7 @@ ethtool_SOURCES += \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
+		  netlink/stats.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
diff --git a/ethtool.8.in b/ethtool.8.in
index fe49b66888c9..d4e01778d738 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -240,6 +240,12 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-S|\-\-statistics
 .I devname
+.RB [\fB\-\-groups
+.RB [\fBeth\-phy\fP]
+.RB [\fBeth\-mac\fP]
+.RB [\fBeth\-ctrl\fP]
+.RN [\fBrmon\fP]
+.RB ]
 .HP
 .B ethtool \-\-phy\-statistics
 .I devname
@@ -652,8 +658,18 @@ Restarts auto-negotiation on the specified Ethernet device, if
 auto-negotiation is enabled.
 .TP
 .B \-S \-\-statistics
-Queries the specified network device for NIC- and driver-specific
-statistics.
+Queries the specified network device for standard (IEEE, IETF, etc.), or NIC-
+and driver-specific statistics. NIC- and driver-specific statistics are
+requested when no group of statistics is specified.
+
+NIC- and driver-specific statistics and standard statistics are independent,
+devices may implement either, both or none. There is little commonality between
+naming of NIC- and driver-specific statistics across vendors.
+.RS 4
+.TP
+.B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\fBrmon\fP]
+Request groups of standard device statistics.
+.RE
 .TP
 .B \-\-phy\-statistics
 Queries the specified network device for PHY specific statistics.
diff --git a/ethtool.c b/ethtool.c
index f4a7d396f487..b23fb05a3016 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5761,7 +5761,10 @@ static const struct option args[] = {
 	{
 		.opts	= "-S|--statistics",
 		.func	= do_gnicstats,
-		.help	= "Show adapter statistics"
+		.nlchk	= nl_gstats_chk,
+		.nlfunc	= nl_gstats,
+		.help	= "Show adapter statistics",
+		.xhelp	= "               [ --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]\n"
 	},
 	{
 		.opts	= "--phy-statistics",
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 7d14c8b38571..8ea7c53a7a5f 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -326,6 +326,43 @@ static const struct pretty_nla_desc __fec_desc[] = {
 	NLATTR_DESC_U32(ETHTOOL_A_FEC_ACTIVE),
 };
 
+static const struct pretty_nla_desc __stats_grp_stat_desc[] = {
+	NLATTR_DESC_U64(0),  NLATTR_DESC_U64(1),  NLATTR_DESC_U64(2),
+	NLATTR_DESC_U64(3),  NLATTR_DESC_U64(4),  NLATTR_DESC_U64(5),
+	NLATTR_DESC_U64(6),  NLATTR_DESC_U64(7),  NLATTR_DESC_U64(8),
+	NLATTR_DESC_U64(9),  NLATTR_DESC_U64(10), NLATTR_DESC_U64(11),
+	NLATTR_DESC_U64(12), NLATTR_DESC_U64(13), NLATTR_DESC_U64(14),
+	NLATTR_DESC_U64(15), NLATTR_DESC_U64(16), NLATTR_DESC_U64(17),
+	NLATTR_DESC_U64(18), NLATTR_DESC_U64(19), NLATTR_DESC_U64(20),
+	NLATTR_DESC_U64(21), NLATTR_DESC_U64(22), NLATTR_DESC_U64(23),
+	NLATTR_DESC_U64(24), NLATTR_DESC_U64(25), NLATTR_DESC_U64(26),
+	NLATTR_DESC_U64(27), NLATTR_DESC_U64(28), NLATTR_DESC_U64(29),
+};
+
+static const struct pretty_nla_desc __stats_grp_hist_desc[] = {
+	NLATTR_DESC_U32(ETHTOOL_A_STATS_GRP_HIST_BKT_LOW),
+	NLATTR_DESC_U32(ETHTOOL_A_STATS_GRP_HIST_BKT_HI),
+	NLATTR_DESC_U64(ETHTOOL_A_STATS_GRP_HIST_VAL),
+};
+
+static const struct pretty_nla_desc __stats_grp_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STATS_GRP_UNSPEC),
+	NLATTR_DESC_INVALID(ETHTOOL_A_STATS_GRP_PAD),
+	NLATTR_DESC_U32(ETHTOOL_A_STATS_GRP_ID),
+	NLATTR_DESC_U32(ETHTOOL_A_STATS_GRP_SS_ID),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_GRP_STAT, stats_grp_stat),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_GRP_HIST_RX, stats_grp_hist),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_GRP_HIST_TX, stats_grp_hist),
+};
+
+static const struct pretty_nla_desc __stats_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STATS_UNSPEC),
+	NLATTR_DESC_INVALID(ETHTOOL_A_STATS_PAD),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_HEADER, header),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_GROUPS, bitset),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STATS_GRP, stats_grp),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -358,6 +395,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_TUNNEL_INFO_GET, tunnel_info),
 	NLMSG_DESC(ETHTOOL_MSG_FEC_GET, fec),
 	NLMSG_DESC(ETHTOOL_MSG_FEC_SET, fec),
+	NLMSG_DESC(ETHTOOL_MSG_STATS_GET, stats),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -395,6 +433,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY, tunnel_info),
 	NLMSG_DESC(ETHTOOL_MSG_FEC_GET_REPLY, fec),
 	NLMSG_DESC(ETHTOOL_MSG_FEC_NTF, fec),
+	NLMSG_DESC(ETHTOOL_MSG_STATS_GET_REPLY, stats),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index d6036a39e920..97113eb98ca0 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -41,6 +41,8 @@ int nl_cable_test_tdr(struct cmd_context *ctx);
 int nl_gtunnels(struct cmd_context *ctx);
 int nl_gfec(struct cmd_context *ctx);
 int nl_sfec(struct cmd_context *ctx);
+bool nl_gstats_chk(struct cmd_context *ctx);
+int nl_gstats(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
@@ -92,6 +94,8 @@ static inline void nl_monitor_usage(void)
 #define nl_gtunnels		NULL
 #define nl_gfec			NULL
 #define nl_sfec			NULL
+#define nl_gstats_chk		NULL
+#define nl_gstats		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/stats.c b/netlink/stats.c
new file mode 100644
index 000000000000..e3ca58b0010c
--- /dev/null
+++ b/netlink/stats.c
@@ -0,0 +1,264 @@
+/*
+ * stats.c - netlink implementation of stats
+ *
+ * Implementation of "ethtool -S <dev> [--groups <types>] etc."
+ */
+
+#include <errno.h>
+#include <ctype.h>
+#include <inttypes.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "parser.h"
+#include "strset.h"
+
+static int parse_rmon_hist_one(const char *grp_name, const struct nlattr *hist,
+			       const char *dir)
+{
+	const struct nlattr *tb[ETHTOOL_A_STATS_GRP_HIST_VAL + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	unsigned long long val;
+	unsigned int low, hi;
+	int ret;
+
+	ret = mnl_attr_parse_nested(hist, attr_cb, &tb_info);
+	if (ret < 0) {
+		fprintf(stderr, "invalid kernel response - malformed histogram entry\n");
+		return 1;
+	}
+
+	if (!tb[ETHTOOL_A_STATS_GRP_HIST_BKT_LOW] ||
+	    !tb[ETHTOOL_A_STATS_GRP_HIST_BKT_HI] ||
+	    !tb[ETHTOOL_A_STATS_GRP_HIST_VAL]) {
+		fprintf(stderr, "invalid kernel response - histogram entry missing attributes\n");
+		return 1;
+	}
+
+	low = mnl_attr_get_u32(tb[ETHTOOL_A_STATS_GRP_HIST_BKT_LOW]);
+	hi = mnl_attr_get_u32(tb[ETHTOOL_A_STATS_GRP_HIST_BKT_HI]);
+	val = mnl_attr_get_u64(tb[ETHTOOL_A_STATS_GRP_HIST_VAL]);
+
+	if (!is_json_context()) {
+		fprintf(stdout, "%s-%s-etherStatsPkts", dir, grp_name);
+
+		if (low && hi) {
+			fprintf(stdout, "%uto%uOctets: %llu\n", low, hi, val);
+		} else if (hi) {
+			fprintf(stdout, "%uOctets: %llu\n", hi, val);
+		} else if (low) {
+			fprintf(stdout, "%utoMaxOctets: %llu\n", low, val);
+		} else {
+			fprintf(stderr, "invalid kernel response - bad histogram entry bounds\n");
+			return 1;
+		}
+	} else {
+		open_json_object(NULL);
+		print_uint(PRINT_JSON, "low", NULL, low);
+		print_uint(PRINT_JSON, "high", NULL, hi);
+		print_u64(PRINT_JSON, "val", NULL, val);
+		close_json_object();
+	}
+
+	return 0;
+}
+
+static int parse_rmon_hist(const struct nlattr *grp, const char *grp_name,
+			   const char *name, const char *dir, unsigned int type)
+{
+	const struct nlattr *attr;
+
+	open_json_array(name, "");
+
+	mnl_attr_for_each_nested(attr, grp) {
+		if (mnl_attr_get_type(attr) == type &&
+		    parse_rmon_hist_one(grp_name, attr, dir))
+			goto err_close_rmon;
+	}
+	close_json_array("");
+
+	return 0;
+
+err_close_rmon:
+	close_json_array("");
+	return 1;
+}
+
+static int parse_grp(struct nl_context *nlctx, const struct nlattr *grp,
+		     const struct stringset *std_str)
+{
+	const struct nlattr *tb[ETHTOOL_A_STATS_GRP_SS_ID + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	bool hist_rx = false, hist_tx = false;
+	const struct stringset *stat_str;
+	const struct nlattr *attr, *stat;
+	const char *std_name, *name;
+	unsigned int ss_id, id, s;
+	unsigned long long val;
+	int ret;
+
+	ret = mnl_attr_parse_nested(grp, attr_cb, &tb_info);
+	if (ret < 0)
+		return 1;
+
+	if (!tb[ETHTOOL_A_STATS_GRP_ID])
+		return 1;
+	if (!tb[ETHTOOL_A_STATS_GRP_SS_ID])
+		return 0;
+
+	id = mnl_attr_get_u32(tb[ETHTOOL_A_STATS_GRP_ID]);
+	ss_id = mnl_attr_get_u32(tb[ETHTOOL_A_STATS_GRP_SS_ID]);
+
+	stat_str = global_stringset(ss_id, nlctx->ethnl2_socket);
+
+	std_name = get_string(std_str, id);
+	open_json_object(std_name);
+
+	mnl_attr_for_each_nested(attr, grp) {
+		switch (mnl_attr_get_type(attr)) {
+		case ETHTOOL_A_STATS_GRP_STAT:
+			break;
+		case ETHTOOL_A_STATS_GRP_HIST_RX:
+			hist_rx = true;
+			continue;
+		case ETHTOOL_A_STATS_GRP_HIST_TX:
+			hist_tx = true;
+			continue;
+		default:
+			continue;
+		}
+
+		stat = mnl_attr_get_payload(attr);
+		ret = mnl_attr_validate(stat, MNL_TYPE_U64);
+		if (ret) {
+			fprintf(stderr, "invalid kernel response - bad statistic entry\n");
+			goto err_close_grp;
+		}
+		s = mnl_attr_get_type(stat);
+		name = get_string(stat_str, s);
+		if (!name || !name[0])
+			continue;
+
+		if (!is_json_context())
+			fprintf(stdout, "%s-%s: ", std_name, name);
+
+		val = mnl_attr_get_u64(stat);
+		print_u64(PRINT_ANY, name, "%llu\n", val);
+	}
+
+	if (hist_rx)
+		parse_rmon_hist(grp, std_name, "rx-pktsNtoM", "rx",
+				ETHTOOL_A_STATS_GRP_HIST_RX);
+	if (hist_tx)
+		parse_rmon_hist(grp, std_name, "tx-pktsNtoM", "tx",
+				ETHTOOL_A_STATS_GRP_HIST_TX);
+
+	close_json_object();
+
+	return 0;
+
+err_close_grp:
+	close_json_object();
+	return 1;
+}
+
+static int stats_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_STATS_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	const struct stringset *std_str;
+	const struct nlattr *attr;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_STATS_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	ret = netlink_init_ethnl2_socket(nlctx);
+	if (ret < 0)
+		return err_ret;
+	std_str = global_stringset(ETH_SS_STATS_STD, nlctx->ethnl2_socket);
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "Standard stats for %s:\n",
+		     nlctx->devname);
+
+	mnl_attr_for_each(attr, nlhdr, GENL_HDRLEN) {
+		if (mnl_attr_get_type(attr) == ETHTOOL_A_STATS_GRP) {
+			ret = parse_grp(nlctx, attr, std_str);
+			if (ret)
+				goto err_close_dev;
+		}
+	}
+
+	close_json_object();
+
+	return MNL_CB_OK;
+
+err_close_dev:
+	close_json_object();
+	return err_ret;
+}
+
+static const struct bitset_parser_data stats_parser_data = {
+	.no_mask	= true,
+	.force_hex	= false,
+};
+
+static const struct param_parser stats_params[] = {
+	{
+		.arg		= "--groups",
+		.type		= ETHTOOL_A_STATS_GROUPS,
+		.handler	= nl_parse_bitset,
+		.handler_data	= &stats_parser_data,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_gstats(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_STATS_GET,
+				      ETHTOOL_A_STATS_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	nlctx->cmd = "-S";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+
+	ret = nl_parser(nlctx, stats_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, stats_reply_cb);
+	delete_json_obj();
+	return ret;
+}
+
+bool nl_gstats_chk(struct cmd_context *ctx)
+{
+	return ctx->argc;
+}
-- 
2.30.2

