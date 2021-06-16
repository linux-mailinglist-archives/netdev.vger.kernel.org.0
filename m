Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8163A9AA8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 14:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhFPMpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 08:45:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62370 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230197AbhFPMpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 08:45:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15GCeSWQ001972;
        Wed, 16 Jun 2021 05:43:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=eyy0zAZgGdCbAdlJA26EvkHg/KFbvfJU89xAlF+xIFg=;
 b=gM1k7+Sid39iRoYCmg/LA21gHkcYImidzi1M45ng5qELMJlLs8HpLNz2SrKKoMxjWGx2
 Rybc6jGucRIIqn9cb1aM0czdHonGEhB5fh8T831PJwe5rpHzVij6pPUbW1mUiAvCOaZP
 CILog0S16AXXq29m4hc7AbyC64KfVoP6ijhJKw5jk2yMhkceylufUMVWQ5krrLN8OCir
 RqDTc+6hsPgdHnddg3kI+v6hEvejGitv3VA3wBFzzL6Rkq1eT5qedC1JTaf+WtCtX815
 it22It59fe02efb1mMlpnJ9ygCrEjnDDKUL6GVG083FXND+C9N+MqGHICDZtQ5qNjrdM 2g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 396tagxapv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 05:43:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Jun
 2021 05:43:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Jun 2021 05:43:06 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 727B75B6965;
        Wed, 16 Jun 2021 05:43:03 -0700 (PDT)
From:   <sgoutham@marvell.com>
To:     <mkubecek@suse.cz>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH ethtool] ethtool: Support ntuple rule count change
Date:   Wed, 16 Jun 2021 18:13:00 +0530
Message-ID: <1623847380-16590-1-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: m7qaCqR-Gj9ayuNMQQ9f5AYQmqS00-t6
X-Proofpoint-GUID: m7qaCqR-Gj9ayuNMQQ9f5AYQmqS00-t6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-16_07:2021-06-15,2021-06-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Some NICs share resources like packet filters across multiple
interfaces they support, between SRIOV PF and VFs and/or between
multiple PFs. From HW point of view it is allowed to use all
MCAM filters for a single interface. Currently ethtool doesn't
support modifying filter count so that user can allocate more filters
to one interface and less to others. This patch adds ETHTOOL_SRXCLSRLCNT
ioctl command for modifying filter count.

example command:
./ethtool -U eth0 rule-count 256

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 ethtool.c            | 11 +++++++++++
 internal.h           |  1 +
 rxclass.c            | 15 +++++++++++++++
 uapi/linux/ethtool.h |  1 +
 4 files changed, 28 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 8ed5a33..d4d0dab 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3797,6 +3797,16 @@ static int do_srxclass(struct cmd_context *ctx)
 				" classification rule\n");
 			return 1;
 		}
+	} else if (!strcmp(ctx->argp[0], "rule-count")) {
+		int count = get_uint_range(ctx->argp[1], 0, INT_MAX);
+
+		err = rxclass_set_rule_count(ctx, count);
+
+		if (err < 0) {
+			fprintf(stderr, "Couldn't set"
+				" the desired ntuple rule count\n");
+			return 1;
+		}
 	} else {
 		exit_bad_args();
 	}
@@ -5818,6 +5828,7 @@ static const struct option args[] = {
 			  "			[ context %d ]\n"
 			  "			[ loc %d]] |\n"
 			  "		delete %d\n"
+			  "		rule-count %d\n"
 	},
 	{
 		.opts	= "-T|--show-time-stamping",
diff --git a/internal.h b/internal.h
index 27da8ea..ce76394 100644
--- a/internal.h
+++ b/internal.h
@@ -372,6 +372,7 @@ int rxclass_rule_get(struct cmd_context *ctx, __u32 loc);
 int rxclass_rule_ins(struct cmd_context *ctx,
 		     struct ethtool_rx_flow_spec *fsp, __u32 rss_context);
 int rxclass_rule_del(struct cmd_context *ctx, __u32 loc);
+int rxclass_set_rule_count(struct cmd_context *ctx, __u32 count);
 
 /* Module EEPROM parsing code */
 void sff8079_show_all(const __u8 *id);
diff --git a/rxclass.c b/rxclass.c
index 6cf81fd..9d29dde 100644
--- a/rxclass.c
+++ b/rxclass.c
@@ -616,6 +616,21 @@ int rxclass_rule_del(struct cmd_context *ctx, __u32 loc)
 	return err;
 }
 
+int rxclass_set_rule_count(struct cmd_context *ctx, __u32 count)
+{
+	struct ethtool_rxnfc nfccmd;
+	int err;
+
+	/* notify netdev of rule count config */
+	nfccmd.cmd = ETHTOOL_SRXCLSRLCNT;
+	nfccmd.rule_cnt = count;
+	err = send_ioctl(ctx, &nfccmd);
+	if (err < 0)
+		perror("rmgr: Cannot set RX class rule count");
+
+	return err;
+}
+
 typedef enum {
 	OPT_NONE = 0,
 	OPT_S32,
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index c6ec111..a43074a 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1550,6 +1550,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_SRXCLSRLCNT	0x00000052 /* Set RX class rule count */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
-- 
2.7.4

