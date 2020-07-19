Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175632257FB
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 08:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgGTGsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 02:48:00 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:26651 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGTGsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 02:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6313; q=dns/txt; s=iport;
  t=1595227678; x=1596437278;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+7UkMYs6Rc84hn5GaN4by2UTJXDHkJPYkfwAtokv/+k=;
  b=lFuZ6r/Ek0nbGM6fIxuu4WqXuGlvyGS9EkyR4bWkeSFUd5s+sa37b+ix
   yJcPpgtsKGT8SIQ+RMtbIs3v4NquU8J59P1Mtsbm9roopkhTnj45+s/ta
   hQ4VJCMSfBN/fcA3FET2MtNSLX1nZB2/GUuS+vhVKn2NBP7oE73C2zV1b
   M=;
X-IronPort-AV: E=Sophos;i="5.75,374,1589241600"; 
   d="scan'208";a="526334663"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 20 Jul 2020 06:47:58 +0000
Received: from 240m5avmarch.cisco.com (240m5avmarch.cisco.com [10.193.164.12])
        (authenticated bits=0)
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPSA id 06K6lqaQ029533
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 20 Jul 2020 06:47:57 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     netdev@vger.kernel.org, edumazet@google.com,
        linville@tuxdriver.com, mkubecek@suse.cz
Cc:     govind.varadar@gmail.com, benve@cisco.com,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH ethtool v3 1/2] ethtool: add support for get/set ethtool_tunable
Date:   Sun, 19 Jul 2020 16:59:27 -0700
Message-Id: <20200719235928.336953-1-gvaradar@cisco.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.12, 240m5avmarch.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE options.

Tested rx-copybreak on enic driver. Tested ETHTOOL_TUNABLE_STRING
options with test/debug changes in kernel.

Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
---
v3:
* Remove handling of string type tunables

v2:
* Fix alignments and braces.
* Move union definition outside struct.
* Make seen type int.
* Use uniform C90 types in union.
* Remove NULL assignment and memset to 0.
* Change variable name from tinfo to tunables_info.
* Use ethtool_tunable_info_val in print_tunable()
* Remove one-letter command line option.
* Use PRI* for int type in print_tunable().

 ethtool.c | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 194 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 07006b0..d37c223 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -40,6 +40,7 @@
 #include <sys/utsname.h>
 #include <limits.h>
 #include <ctype.h>
+#include <inttypes.h>
 
 #include <sys/socket.h>
 #include <netinet/in.h>
@@ -4686,6 +4687,183 @@ static int do_seee(struct cmd_context *ctx)
 	return 0;
 }
 
+/* copy of net/ethtool/common.c */
+char
+tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_ID_UNSPEC]		= "Unspec",
+	[ETHTOOL_RX_COPYBREAK]		= "rx-copybreak",
+	[ETHTOOL_TX_COPYBREAK]		= "tx-copybreak",
+	[ETHTOOL_PFC_PREVENTION_TOUT]	= "pfc-prevention-tout",
+};
+
+union ethtool_tunable_info_val {
+	uint8_t u8;
+	uint16_t u16;
+	uint32_t u32;
+	uint64_t u64;
+	int8_t s8;
+	int16_t s16;
+	int32_t s32;
+	int64_t s64;
+};
+
+struct ethtool_tunable_info {
+	enum tunable_id t_id;
+	enum tunable_type_id t_type_id;
+	size_t size;
+	cmdline_type_t type;
+	union ethtool_tunable_info_val wanted;
+	int seen;
+};
+
+static struct ethtool_tunable_info tunables_info[] = {
+	{ .t_id		= ETHTOOL_RX_COPYBREAK,
+	  .t_type_id	= ETHTOOL_TUNABLE_U32,
+	  .size		= sizeof(u32),
+	  .type		= CMDL_U32,
+	},
+	{ .t_id		= ETHTOOL_TX_COPYBREAK,
+	  .t_type_id	= ETHTOOL_TUNABLE_U32,
+	  .size		= sizeof(u32),
+	  .type		= CMDL_U32,
+	},
+	{ .t_id		= ETHTOOL_PFC_PREVENTION_TOUT,
+	  .t_type_id	= ETHTOOL_TUNABLE_U16,
+	  .size		= sizeof(u16),
+	  .type		= CMDL_U16,
+	},
+};
+#define TUNABLES_INFO_SIZE	ARRAY_SIZE(tunables_info)
+
+static int do_stunable(struct cmd_context *ctx)
+{
+	struct cmdline_info cmdline_tunable[TUNABLES_INFO_SIZE];
+	struct ethtool_tunable_info *tinfo = tunables_info;
+	int changed = 0;
+	int i;
+
+	for (i = 0; i < TUNABLES_INFO_SIZE; i++) {
+		cmdline_tunable[i].name = tunable_strings[tinfo[i].t_id];
+		cmdline_tunable[i].type = tinfo[i].type;
+		cmdline_tunable[i].wanted_val = &tinfo[i].wanted;
+		cmdline_tunable[i].seen_val = &tinfo[i].seen;
+	}
+
+	parse_generic_cmdline(ctx, &changed, cmdline_tunable, TUNABLES_INFO_SIZE);
+	if (!changed)
+		exit_bad_args();
+
+	for (i = 0; i < TUNABLES_INFO_SIZE; i++) {
+		struct ethtool_tunable *tuna;
+		size_t size;
+		int ret;
+
+		if (!tinfo[i].seen)
+			continue;
+
+		size = sizeof(*tuna) + tinfo[i].size;
+		tuna = calloc(1, size);
+		if (!tuna) {
+			perror(tunable_strings[tinfo[i].t_id]);
+			return 1;
+		}
+		tuna->cmd = ETHTOOL_STUNABLE;
+		tuna->id = tinfo[i].t_id;
+		tuna->type_id = tinfo[i].t_type_id;
+		tuna->len = tinfo[i].size;
+		memcpy(tuna->data, &tinfo[i].wanted, tuna->len);
+		ret = send_ioctl(ctx, tuna);
+		if (ret) {
+			perror(tunable_strings[tuna->id]);
+			return ret;
+		}
+		free(tuna);
+	}
+	return 0;
+}
+
+static void print_tunable(struct ethtool_tunable *tuna)
+{
+	char *name = tunable_strings[tuna->id];
+	union ethtool_tunable_info_val *val;
+
+	val = (union ethtool_tunable_info_val *)tuna->data;
+	switch (tuna->type_id) {
+	case ETHTOOL_TUNABLE_U8:
+		fprintf(stdout, "%s: %" PRIu8 "\n", name, val->u8);
+		break;
+	case ETHTOOL_TUNABLE_U16:
+		fprintf(stdout, "%s: %" PRIu16 "\n", name, val->u16);
+		break;
+	case ETHTOOL_TUNABLE_U32:
+		fprintf(stdout, "%s: %" PRIu32 "\n", name, val->u32);
+		break;
+	case ETHTOOL_TUNABLE_U64:
+		fprintf(stdout, "%s: %" PRIu64 "\n", name, val->u64);
+		break;
+	case ETHTOOL_TUNABLE_S8:
+		fprintf(stdout, "%s: %" PRId8 "\n", name, val->s8);
+		break;
+	case ETHTOOL_TUNABLE_S16:
+		fprintf(stdout, "%s: %" PRId16 "\n", name, val->s16);
+		break;
+	case ETHTOOL_TUNABLE_S32:
+		fprintf(stdout, "%s: %" PRId32 "\n", name, val->s32);
+		break;
+	case ETHTOOL_TUNABLE_S64:
+		fprintf(stdout, "%s: %" PRId64 "\n", name, val->s64);
+		break;
+	default:
+		fprintf(stdout, "%s: Unknown format\n", name);
+	}
+}
+
+static int do_gtunable(struct cmd_context *ctx)
+{
+	struct ethtool_tunable_info *tinfo = tunables_info;
+	char **argp = ctx->argp;
+	int argc = ctx->argc;
+	int i;
+	int j;
+
+	if (argc < 1)
+		exit_bad_args();
+
+	for (i = 0; i < argc; i++) {
+		int valid = 0;
+
+		for (j = 0; j < TUNABLES_INFO_SIZE; j++) {
+			char *ts = tunable_strings[tinfo[j].t_id];
+			struct ethtool_tunable *tuna;
+			int ret;
+
+			if (strcmp(argp[i], ts))
+				continue;
+			valid = 1;
+
+			tuna = calloc(1, sizeof(*tuna) + tinfo[j].size);
+			if (!tuna) {
+				perror(ts);
+				return 1;
+			}
+			tuna->cmd = ETHTOOL_GTUNABLE;
+			tuna->id = tinfo[j].t_id;
+			tuna->type_id = tinfo[j].t_type_id;
+			tuna->len = tinfo[j].size;
+			ret = send_ioctl(ctx, tuna);
+			if (ret) {
+				fprintf(stderr, "%s: Cannot get tunable\n", ts);
+				return ret;
+			}
+			print_tunable(tuna);
+			free(tuna);
+		}
+		if (!valid)
+			exit_bad_args();
+	}
+	return 0;
+}
+
 static int do_get_phy_tunable(struct cmd_context *ctx)
 {
 	int argc = ctx->argc;
@@ -5439,6 +5617,22 @@ static const struct option args[] = {
 			  "		[ fast-link-down ]\n"
 			  "		[ energy-detect-power-down ]\n"
 	},
+	{
+		.opts	= "--get-tunable",
+		.func	= do_gtunable,
+		.help	= "Get tunable",
+		.xhelp	= "		[ rx-copybreak ]\n"
+			  "		[ tx-copybreak ]\n"
+			  "		[ pfc-precention-tout ]\n"
+	},
+	{
+		.opts	= "--set-tunable",
+		.func	= do_stunable,
+		.help	= "Set tunable",
+		.xhelp	= "		[ rx-copybreak N]\n"
+			  "		[ tx-copybreak N]\n"
+			  "		[ pfc-precention-tout N]\n"
+	},
 	{
 		.opts	= "--reset",
 		.func	= do_reset,
-- 
2.27.0

