Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BFA222880
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgGPQr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:47:29 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:16119
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728257AbgGPQr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 12:47:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iV5GgYSU+G+JmcCuklEDZet4TVMq/c5JMO2OI7W63njzSClcRgOE2jG8E3DlUmYXPiVuiu8r1Mvwm8omQO0yj3wBs3SeM/9cx6dFGiIC5XyHZLzhMxUvgEkBSm43+GzP+r+GY+kH7BgFjgEUaof9M+fBUZ1EEO+8V9bVme/RNGHkuB/66eGrrhIRGrmXOs5XPf1D9iXkIeGwVB29CSM4BpC5dnikutb+MzcyWlrx85hGgdkUbzb0ufQpN2/9Ey4vexx8H+dnZup3vaCVWmbcDEaGk4Y3Pxgmj/vs4o0lY6cz3hAeaLHAF+2YM4utVizZRkviKI2iVf+6jYr+GazOHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+39mgXAMQgOR1YsDle/4rI/r/7BBzZNzlAvz3QUzX94=;
 b=Wzj9gyOpwm6nxIvtgMh2Pl2YfEjjBQN93EKk0R/LGA5HF7bkSIVr0UtU0ut6ZjAXEgZN4KldpW/7uJFDmXn9Jo0AXC8GdL5G4stY+enyO6fpqcwPwKdgWoPbkXnKFpgMPC1wFNbCOMW9j+gb2LkbdBZodFqDpCgTfYw5hWLWIHrQL5yCk4xNxqL+Oe4iBduebuXZWQtRQqikql+eNg/WN5mODGI/qC/9PAwf0lHNWLMSg7MGMhuK+6Y2pvO+zRvHCZH0E5564el3luM4UEFAGGGD+nOFTz2bZC5OBsHKL/v/+RkHoJSEIbpQGtHTKavlEcLOwCWonWe0ZWU5/ElNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+39mgXAMQgOR1YsDle/4rI/r/7BBzZNzlAvz3QUzX94=;
 b=ohWiqDSqdO7KTp4rMHnP2kCxW09GdD+8gpEKirWBSUiqF1TuJ8SxMqLZe1tP4EYZ5TNFzS2hPfm7/Zj26wuCurfwBuzLz66NrpBBUKuu/VU79fpYqfBP05hZiyCcpdoLbtyIuDDMeMpjCrgVoj9ITFVNliopLlf1m/xAylJDrt8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.24; Thu, 16 Jul 2020 16:47:22 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 16:47:22 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v3 1/2] tc: Look for blocks in qevents
Date:   Thu, 16 Jul 2020 19:47:07 +0300
Message-Id: <212fc3e148879b60c08f6afceae77d78489914aa.1594917961.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594917961.git.petrm@mellanox.com>
References: <cover.1594917961.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0002.eurprd02.prod.outlook.com (2603:10a6:208:3e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 16:47:21 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 085a38f0-ee42-47de-5c9d-08d829a7e933
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB38340E886F4220E3E9E38692DB7F0@HE1PR0502MB3834.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Fr/cY5Y7GsTJ+pWjhKe+D++CyZDCSaicLuTzqFUhCW4bzhtZuCXALOrbTU/x9SnNyhlYVeYyn9Q3jW2NP9h+lNpaYzr1jR7gepcIsXJ2bFoHwxNeMNMJ8Xx95dQjdqDGpEiwbL/DtSBE1hUBnHuXTikBrLSz3PGCMsFJuRY0/uoTzJzCMAm/C0OhxLanw4wpYd1pD+hs+51h0ZjPYBuC8hHREKW1xLqdPKWnCftfof0gxzMVixBj8ayuCig997laC2Bjk002s2WLwaeyDg2ZWuFe85ooJgGsr0gyx2fRkCKF6Rm/7n2xe6cRjQk6nq0bo69C02rSr8c2vSrEFeTSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(83380400001)(86362001)(2906002)(8676002)(8936002)(478600001)(6512007)(107886003)(6486002)(66556008)(54906003)(66946007)(6506007)(26005)(186003)(52116002)(6916009)(316002)(36756003)(5660300002)(66476007)(2616005)(4326008)(6666004)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J1taMHd2oOsrtDSJXxETFgOHMzn8S/i4Oo/l5fR4oyM1NBe5nkK0Tj+uBpRqnRfvdvhE7A1pzE4W832DG7trAG8mMNxfLCEQNyMAkq2U/nj+8XnyIDvjvL8I0hr+1LrmTk4lznKoE/avWjnRTBaKUWoufTyn6xaYpTam8fYfdFMy96uWtzpQ8OHp2eqMONYVgeO/QO3aTV7x6xQwJyCAuYSMfODQPvBitHgC/Qs6XB+G0dEL8Hbp4GYb/YHAB+Tbza4lqtfn4DAZ6qkZLrEOmqMLDcZMbEbrYDGz58RTaw+Ddm42TtW5suzOEW0tvFp1su/9QFFIHHfRmzhpoyOwTEeHJpzftB600hVon33itV1r9TqVmBLdW6xOY1AKzHI2vnHVJSokIzjUag8n2c53MYnqf20jnwrxk6+WAYWNhkfzd46FVbasaWz2TCni7HNXK8nOoBv4WRCvDlfnQsa2gh6yBa0kgI/WWdLViD6/CXvfQIdHaZNUVN2K/P966t+P
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085a38f0-ee42-47de-5c9d-08d829a7e933
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 16:47:22.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuwsUIhBoxjp8LgXxcA3arqvcqPZ6Jk2HzjW5pZEWGNMpieH9ggJynwJ912eJ1Qpbc5fM3niX0gEbhKnuEZNbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3834
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a list of filters at a given block is requested, tc first validates
that the block exists before doing the filter query. Currently the
validation routine checks ingress and egress blocks. But now that blocks
can be bound to qevents as well, qevent blocks should be looked for as
well.

In order to support that, extend struct qdisc_util with a new callback,
has_block. That should report whether, give the attributes in TCA_OPTIONS,
a blocks with a given number is bound to a qevent. In
tc_qdisc_block_exists_cb(), invoke that callback when set.

Add a helper to the tc_qevent module that walks the list of qevents and
looks for a given block. This is meant to be used by the individual qdiscs.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v3:
    - Do not pass &ctx->found directly to has_block. Do it through a
      helper variable, so that the callee does not overwrite the result
      already stored in ctx->found.
    
    v2:
    - In tc_qdisc_block_exists_cb(), do not initialize 'q'.
    - Propagate upwards errors from q->has_block.

 tc/tc_qdisc.c  | 18 ++++++++++++++++++
 tc/tc_qevent.c | 15 +++++++++++++++
 tc/tc_qevent.h |  2 ++
 tc/tc_util.h   |  2 ++
 4 files changed, 37 insertions(+)

diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 8eb08c34..b79029d9 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -478,6 +478,9 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 	struct tcmsg *t = NLMSG_DATA(n);
 	struct rtattr *tb[TCA_MAX+1];
 	int len = n->nlmsg_len;
+	struct qdisc_util *q;
+	const char *kind;
+	int err;
 
 	if (n->nlmsg_type != RTM_NEWQDISC)
 		return 0;
@@ -506,6 +509,21 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 		if (block == ctx->block_index)
 			ctx->found = true;
 	}
+
+	kind = rta_getattr_str(tb[TCA_KIND]);
+	q = get_qdisc_kind(kind);
+	if (!q)
+		return -1;
+	if (q->has_block) {
+		bool found = false;
+
+		err = q->has_block(q, tb[TCA_OPTIONS], ctx->block_index, &found);
+		if (err)
+			return err;
+		if (found)
+			ctx->found = true;
+	}
+
 	return 0;
 }
 
diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
index 1f8e6506..2c010fcf 100644
--- a/tc/tc_qevent.c
+++ b/tc/tc_qevent.c
@@ -92,6 +92,21 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
 		close_json_array(PRINT_ANY, "");
 }
 
+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx)
+{
+	if (!qevents)
+		return false;
+
+	for (; qevents->id; qevents++) {
+		struct qevent_base *qeb = qevents->data;
+
+		if (qeb->block_idx == block_idx)
+			return true;
+	}
+
+	return false;
+}
+
 int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n)
 {
 	int err;
diff --git a/tc/tc_qevent.h b/tc/tc_qevent.h
index 574e7cff..d60c3f75 100644
--- a/tc/tc_qevent.h
+++ b/tc/tc_qevent.h
@@ -2,6 +2,7 @@
 #ifndef _TC_QEVENT_H_
 #define _TC_QEVENT_H_
 
+#include <stdbool.h>
 #include <linux/types.h>
 #include <libnetlink.h>
 
@@ -37,6 +38,7 @@ int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv);
 int qevents_read(struct qevent_util *qevents, struct rtattr **tb);
 int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n);
 void qevents_print(struct qevent_util *qevents, FILE *f);
+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx);
 
 struct qevent_plain {
 	struct qevent_base base;
diff --git a/tc/tc_util.h b/tc/tc_util.h
index edc39138..c8af4e95 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -5,6 +5,7 @@
 #define MAX_MSG 16384
 #include <limits.h>
 #include <linux/if.h>
+#include <stdbool.h>
 
 #include <linux/pkt_sched.h>
 #include <linux/pkt_cls.h>
@@ -40,6 +41,7 @@ struct qdisc_util {
 	int (*parse_copt)(struct qdisc_util *qu, int argc,
 			  char **argv, struct nlmsghdr *n, const char *dev);
 	int (*print_copt)(struct qdisc_util *qu, FILE *f, struct rtattr *opt);
+	int (*has_block)(struct qdisc_util *qu, struct rtattr *opt, __u32 block_idx, bool *p_has);
 };
 
 extern __u16 f_proto;
-- 
2.20.1

