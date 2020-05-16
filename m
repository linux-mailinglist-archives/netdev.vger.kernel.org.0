Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBDD1D5DA9
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgEPBal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:39711 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgEPBaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:39 -0400
IronPort-SDR: Ye9N/BiwNpSCffPL8Eqpwi95+Z3tXenV46vhrkPShYWl2RGgOyFhPCZnJwD3xQQFpZvsAq4Hck
 9B2wpFVO+FQg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:38 -0700
IronPort-SDR: 2NJZSlfaDRqSQ9FxKYl9UkVlYXXY48U0DfEnwvlji/AyzGvkZuZcksFeuyHK9bTxkVPUpEbSaf
 m98CrBcLy8DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569384"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, linville@tuxdriver.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [ethtool RFC 2/3] ethtool: Add support for configuring frame preemption
Date:   Fri, 15 May 2020 18:30:25 -0700
Message-Id: <20200516013026.3174098-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516013026.3174098-1-vinicius.gomes@intel.com>
References: <20200516013026.3174098-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The configuration knobs that can be set are:
  - enabling/disabling frame preemption per-device;
  - setting the mask of preemptible queues;
  - configuring the minimum fragment size;

The values that can be retrieved from the hardware are:
  - if frame preemption is supported;
  - if frame preemption is active;
  - which queues can be set as preemptible;
  - which queues are set as preemptible;
  - the current minimum fragment size;

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 ethtool.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 900880a..4c69d1c 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1573,6 +1573,28 @@ static void dump_fec(u32 fec)
 		fprintf(stdout, " LLRS");
 }
 
+static void dump_fpcmd(struct ethtool_fp *fpcmd)
+{
+	fprintf(stdout, "	support: ");
+	if (fpcmd->fp_supported)
+		fprintf(stdout, "supported\n");
+	else
+		fprintf(stdout, "not supported\n");
+
+	fprintf(stdout, "	status: ");
+	if (fpcmd->fp_enabled)
+		fprintf(stdout, "enabled\n");
+	else
+		fprintf(stdout, "disabled\n");
+
+	fprintf(stdout, "	supported queues: %#x\n",
+		fpcmd->supported_queues_mask);
+	fprintf(stdout, "	preemptible queues: %#x\n",
+		fpcmd->preemptible_queues_mask);
+	fprintf(stdout, "	minimum fragment size: %d\n",
+		fpcmd->min_frag_size);
+}
+
 #define N_SOTS 7
 
 static char *so_timestamping_labels[N_SOTS] = {
@@ -4731,6 +4753,63 @@ static int do_seee(struct cmd_context *ctx)
 	return 0;
 }
 
+static int do_get_preempt(struct cmd_context *ctx)
+{
+	struct ethtool_fp fpcmd;
+
+	if (ctx->argc != 0)
+		exit_bad_args();
+
+	fpcmd.cmd = ETHTOOL_GFP;
+	if (send_ioctl(ctx, &fpcmd)) {
+		perror("Cannot get frame preemption settings");
+		return 1;
+	}
+
+	fprintf(stdout, "Frame preemption Settings for %s:\n", ctx->devname);
+	dump_fpcmd(&fpcmd);
+
+	return 0;
+}
+
+static int do_set_preempt(struct cmd_context *ctx)
+{
+	int fp_c = -1, preempt_queues_mask_c = -1, min_frag_c = -1;
+	int change = -1;
+	struct ethtool_fp fpcmd;
+	struct cmdline_info cmdline_fp[] = {
+		{ "fp", CMDL_BOOL, &fp_c, &fpcmd.fp_enabled },
+		{ "preemptible-queues-mask", CMDL_U32, &preempt_queues_mask_c,
+		  &fpcmd.preemptible_queues_mask },
+		{ "min-frag-size", CMDL_U32, &min_frag_c,
+		  &fpcmd.min_frag_size },
+	};
+
+	if (ctx->argc == 0)
+		exit_bad_args();
+
+	parse_generic_cmdline(ctx, &change, cmdline_fp,
+			      ARRAY_SIZE(cmdline_fp));
+
+	fpcmd.cmd = ETHTOOL_GFP;
+	if (send_ioctl(ctx, &fpcmd)) {
+		perror("Cannot get frame preemption settings");
+		return 1;
+	}
+
+	do_generic_set(cmdline_fp, ARRAY_SIZE(cmdline_fp), &change);
+
+	if (change) {
+		fpcmd.cmd = ETHTOOL_SFP;
+		if (send_ioctl(ctx, &fpcmd)) {
+			perror("Cannot set frame preemption settings");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static int do_get_phy_tunable(struct cmd_context *ctx)
 {
 	int argc = ctx->argc;
@@ -5505,6 +5584,19 @@ static const struct option args[] = {
 		.help	= "Set FEC settings",
 		.xhelp	= "		[ encoding auto|off|rs|baser|llrs [...]]\n"
 	},
+	{
+		.opts	= "--show-frame-preemption",
+		.func	= do_get_preempt,
+		.help	= "Show Frame Preemption settings",
+	},
+	{
+		.opts	= "--set-frame-preemption",
+		.func	= do_set_preempt,
+		.help	= "Set Frame Preemption settings",
+		.xhelp	= "		[ fp on|off ]\n"
+			  "		[ preemptible-queues-mask %x ]\n"
+			  "		[ min-frag-size %d ]\n",
+	},
 	{
 		.opts	= "-Q|--per-queue",
 		.func	= do_perqueue,
-- 
2.26.2

