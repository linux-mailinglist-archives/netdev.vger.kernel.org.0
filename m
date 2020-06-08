Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEF61F2F52
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgFIAte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:49:34 -0400
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:37410 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730606AbgFIAtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 20:49:24 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2020 20:49:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=6424; q=dns/txt; s=iport;
  t=1591663763; x=1592873363;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8vdurk/ZsmBaxOp9TaxlROeZOEUcrSM6BQt+lcqn7HA=;
  b=e3L//fD76BZONct97M6NvMotvOYPjXkZP2jcS7vl6ZTCH0nhbGGuSKrB
   LmeVb/6XRP8lsNiZ+qXBvzucucPwCir4xB+6hsJjiD4HdAaXVn6/aoPlT
   jhEVR6oPkMkE7ug+X8/5Q5OL06SstG8O/sJuH3DRW2/NjTt8Q7m3X/Pmp
   k=;
X-IronPort-AV: E=Sophos;i="5.73,490,1583193600"; 
   d="scan'208";a="770875394"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 09 Jun 2020 00:42:12 +0000
Received: from 240m5avmarch.cisco.com (240m5avmarch.cisco.com [10.193.164.12])
        (authenticated bits=0)
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPSA id 0590g7nI009323
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 9 Jun 2020 00:42:12 GMT
From:   Govindarajulu Varadarajan <gvaradar@cisco.com>
To:     netdev@vger.kernel.org, edumazet@google.com, linville@tuxdriver.com
Cc:     govind.varadar@gmail.com,
        Govindarajulu Varadarajan <gvaradar@cisco.com>
Subject: [PATCH ethtool 1/2] ethtool: add support for get/set ethtool_tunable
Date:   Mon,  8 Jun 2020 10:52:54 -0700
Message-Id: <20200608175255.3353-1-gvaradar@cisco.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: gvaradar@cisco.com
X-Outbound-SMTP-Client: 10.193.164.12, 240m5avmarch.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ETHTOOL_GTUNABLE and ETHTOOL_STUNABLE options.

Tested rx-copybreak on enic driver. Tested ETHTOOL_TUNNABLE_STRING
options with test/debug changes in kernel.

Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
---
 ethtool.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 227 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 900880a..6cff5dd 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4731,6 +4731,217 @@ static int do_seee(struct cmd_context *ctx)
 	return 0;
 }
 
+/* copy of net/ethtool/common.c */
+char
+tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_ID_UNSPEC]     = "Unspec",
+	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
+	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
+	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
+};
+
+struct ethtool_tunable_info {
+	enum tunable_id t_id;
+	enum tunable_type_id t_type_id;
+	size_t size;
+	cmdline_type_t type;
+	union val {
+		u8 u8;
+		u16 u16;
+		u32 u32;
+		u64 u64;
+		int8_t s8;
+		int16_t s16;
+		int32_t s32;
+		int64_t s64;
+		void *str;
+	} seen;
+	union val wanted;
+};
+
+struct ethtool_tunable_info tinfo[] = {
+	{ .t_id = ETHTOOL_RX_COPYBREAK,
+	  .t_type_id = ETHTOOL_TUNABLE_U32,
+	  .size = sizeof(u32),
+	  .type = CMDL_U32,
+	},
+	{ .t_id = ETHTOOL_TX_COPYBREAK,
+	  .t_type_id = ETHTOOL_TUNABLE_U32,
+	  .size = sizeof(u32),
+	  .type = CMDL_U32,
+	},
+	{ .t_id = ETHTOOL_PFC_PREVENTION_TOUT,
+	  .t_type_id = ETHTOOL_TUNABLE_U16,
+	  .size = sizeof(u16),
+	  .type = CMDL_U16,
+	},
+};
+#define TINFO_SIZE	ARRAY_SIZE(tinfo)
+
+static int do_stunable(struct cmd_context *ctx)
+{
+	struct cmdline_info cmdline_tunable[TINFO_SIZE];
+	int changed = 0;
+	int i;
+
+	for (i = 0; i < TINFO_SIZE; i++) {
+		cmdline_tunable[i].name = tunable_strings[tinfo[i].t_id];
+		cmdline_tunable[i].type = tinfo[i].type;
+		cmdline_tunable[i].wanted_val = &tinfo[i].wanted;
+		cmdline_tunable[i].seen_val = &tinfo[i].seen;
+	}
+
+	parse_generic_cmdline(ctx, &changed, cmdline_tunable, TINFO_SIZE);
+	if (!changed)
+		exit_bad_args();
+
+	for (i = 0; i < TINFO_SIZE; i++) {
+		char **val = (char **)&tinfo[i].wanted;
+		struct ethtool_tunable *tuna;
+		size_t size;
+		int *seen;
+		int ret;
+
+		seen = (int *)(&tinfo[i].seen);
+		if (!*seen)
+			continue;
+
+		size = sizeof(*tuna);
+		if (tinfo[i].type == CMDL_STR) {
+			size +=  strlen(*val) + 1;
+		} else {
+			size += tinfo[i].size;
+		}
+		tuna = calloc(1, size);
+		if (!tuna) {
+			perror(tunable_strings[tinfo[i].t_id]);
+			return 1;
+		}
+		tuna->cmd = ETHTOOL_STUNABLE;
+		tuna->id = tinfo[i].t_id;
+		tuna->type_id = tinfo[i].t_type_id;
+		if (tinfo[i].type == CMDL_STR) {
+			tuna->len = strlen(*val) + 1;
+			memcpy(tuna->data, *val, strlen(*val) + 1);
+		} else {
+			tuna->len = tinfo[i].size;
+			memcpy(tuna->data, &tinfo[i].wanted, tuna->len);
+		}
+		ret = send_ioctl(ctx, tuna);
+		if (ret) {
+			perror(tunable_strings[tuna->id]);
+			return ret;
+		}
+		free(tuna);
+		tuna = NULL;
+		/* reset seen and wanted to 0 */
+		memset(&tinfo[i].seen, 0, sizeof(tinfo[i].seen));
+		memset(&tinfo[i].wanted, 0, sizeof(tinfo[i].seen));
+	}
+	return 0;
+}
+
+static void print_tunable(struct ethtool_tunable *tuna)
+{
+	char *name = tunable_strings[tuna->id];
+	u8 *val_u8;
+	u16 *val_u16;
+	u32 *val_u32;
+	u64 *val_u64;
+	int8_t *val_s8;
+	int16_t *val_s16;
+	int32_t *val_s32;
+	long long int *val_s64;
+	char *val_str;
+
+	switch (tuna->type_id) {
+	case ETHTOOL_TUNABLE_U8:
+		val_u8 = (u8 *)tuna->data;
+		fprintf(stdout, "%s: %u\n", name, *val_u8);
+		break;
+	case ETHTOOL_TUNABLE_U16:
+		val_u16 = (u16 *)tuna->data;
+		fprintf(stdout, "%s: %u\n", name, *val_u16);
+		break;
+	case ETHTOOL_TUNABLE_U32:
+		val_u32 = (u32 *)tuna->data;
+		fprintf(stdout, "%s: %u\n", name, *val_u32);
+		break;
+	case ETHTOOL_TUNABLE_U64:
+		val_u64 = (u64 *)tuna->data;
+		fprintf(stdout, "%s: %llu\n", name, *val_u64);
+		break;
+	case ETHTOOL_TUNABLE_S8:
+		val_s8 = (int8_t *)tuna->data;
+		fprintf(stdout, "%s: %d\n", name, *val_s8);
+		break;
+	case ETHTOOL_TUNABLE_S16:
+		val_s16 = (int16_t *)tuna->data;
+		fprintf(stdout, "%s: %d\n", name, *val_s16);
+		break;
+	case ETHTOOL_TUNABLE_S32:
+		val_s32 = (int32_t *)tuna->data;
+		fprintf(stdout, "%s: %d\n", name, *val_s32);
+		break;
+	case ETHTOOL_TUNABLE_S64:
+		val_s64 = (long long int *)tuna->data;
+		fprintf(stdout, "%s: %lld\n", name, *val_s64);
+		break;
+	case ETHTOOL_TUNABLE_STRING:
+		val_str = (char *)tuna->data;
+		fprintf(stdout, "%s: %s\n", name, val_str);
+		break;
+	default:
+		fprintf(stdout, "%s: Unknown format\n", name);
+	}
+}
+
+static int do_gtunable(struct cmd_context *ctx)
+{
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
+		for (j = 0; j < TINFO_SIZE; j++) {
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
+			tuna = NULL;
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
@@ -5468,6 +5679,22 @@ static const struct option args[] = {
 			  "		[ fast-link-down ]\n"
 			  "		[ energy-detect-power-down ]\n"
 	},
+	{
+		.opts	= "-b|--get-tunable",
+		.func	= do_gtunable,
+		.help	= "Get tunable",
+		.xhelp	= "		[ rx-copybreak ]\n"
+			  "		[ tx-copybreak ]\n"
+			  "		[ pfc-precention-tout ]\n"
+	},
+	{
+		.opts	= "-B|--set-tunable",
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

