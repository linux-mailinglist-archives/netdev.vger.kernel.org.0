Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA52220E6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGPKsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:48:31 -0400
Received: from mail-db8eur05on2081.outbound.protection.outlook.com ([40.107.20.81]:6113
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbgGPKs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 06:48:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1draLQmL0+ktSjBNkfoZhoXPKJxwFa1aywpcWzjC3YHz9dvNcIt7XIwrAHHDIY/24WJLeBEFLwyh2whpOnYqan56geKMR7X4rYuiETvGzjuO/TJWqH7bT91H47Eel+T8fBKerIcXClYrSvu37PRncfuMXSIYmfauUBOY7zWguLfBpjJS0UzgWqeo7KhiuoNUOJn+90yrSJP7q0PogkVMuwYAt7whyXFDn8OfYr/SMhBC9eKw7Y9FcfAwK7rF2OZ0ldo5kkNRRbJGvpbNb8b9vZp7P4JqMm1nAV8eTjFpJbPSPzSaF+sTdGYSBsk1G5gCTovdrJNxvyvXaHSf1lsyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZqg6ButjNkTivqL3Yzkigxu9ls5tpts8pFZ8GweI6Y=;
 b=Q2dTFahkN/ZhCarkHTfjY6Igfytjqfpg5ULxFCt/m/q0OEeqTpzIdnMMb1z+kSK2Qp9RucEkwF6XV1HJX9e6Qt0gTxgGPwCdDKGW8iq2ax6juNjJIAgYA2Iw/MFuHm+3KieapohVsZjwlO2Ob0YJTi+X0Kjo471cs+FcVKmbWHqCWtVwEWoMExOJT04415zHz7BGP16FjGKe0PpomAyfTfmiyUrfUo/zAQtI/SEyb+Hz4iDusE4NXBwXfVRDN/9VSB8SYTDeU5+oMhW8IeuNF1cZzHibfmMzw05d/dGsEWXTuyRrAkvgX0Xl8pShbLzRDUCooAsw8RGFlono9igNog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZqg6ButjNkTivqL3Yzkigxu9ls5tpts8pFZ8GweI6Y=;
 b=si+C2Spy2LLVU5XBW+aCeMCOJcVbY3G15+yK8ZEFbEw9k8tY6xgerhEIf0+8g2e6otpM8Uo1boIdTvKeZAklypLQyJ+Wo7zgSlkqXsMrVeMqE3RElM2L0uO8bsVqNTKtNTSR2eTDCJFVnH0S1iTH+fh/AI9KN9y1TWJ9Paesqpo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB2940.eurprd05.prod.outlook.com (2603:10a6:3:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Thu, 16 Jul 2020 10:48:25 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 10:48:25 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next 1/2] tc: Look for blocks in qevents
Date:   Thu, 16 Jul 2020 13:47:59 +0300
Message-Id: <bcc2005258f2453a788af112eb574d40c58890ab.1594896187.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594896187.git.petrm@mellanox.com>
References: <cover.1594896187.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0046.eurprd03.prod.outlook.com (2603:10a6:208::23)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0046.eurprd03.prod.outlook.com (2603:10a6:208::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 10:48:23 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 409f9b28-fdae-4a54-712e-08d82975c3a4
X-MS-TrafficTypeDiagnostic: HE1PR0502MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB29400C666C859DF4D6416560DB7F0@HE1PR0502MB2940.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbGQOXxFbJ95AddBXe4lL8CvhiGm84mPAoL9ySmL254r0YDGPqExwNDSAdZJcySkhfCnBCcUMM9qUpLRoT8VTgu6sM3N9JvLA0xHQQGcVnG1XGoEPxS8gSQx5wwhOmidDJ4yGTBgdqa5W1UwDcXhE9nA/CkXqHJcxB+tjwg/D/+6PkYEeaXOH0S6fys2+PZ8f6T1n5GuFrsgKqPu+77Ehj9trQx/ygf4NWkYvCGVw2AYR2VPbgF44OIbNAqgEAUfTzPU4sT7qPGVhTUBa2VJKQYLIsKYrPYPJhBNej5s9++2uI0vqauJM2gzTsUvntNbb4Mot1Gc/VTleROO5RoTBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(83380400001)(6916009)(4326008)(5660300002)(8936002)(478600001)(66556008)(6486002)(16526019)(52116002)(6666004)(36756003)(66946007)(86362001)(8676002)(6506007)(107886003)(186003)(2616005)(66476007)(26005)(2906002)(6512007)(54906003)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a4ZNUOtSWqEFT38vlOsXqWbq5jwDPtNwg9aCFSAxArS12sZtUc8KWaoi9/38T4iUE3THbOTbJ8jLpez2v/QVygGKsOf/7uC4VeTgTLdVMq4rtGnfIsb7L3COU9HJtxLkFdXB0s81g1va0WxZaWmJUV/IYna39DGtaywY2Rw2KT/c7bR0+8AnIdx4BKnsJo5yM2h5lPlRNDXI4JJh1VPvr9RfH1xrlO/PRPZYERonA2cVE1VFyZY+UUgkXjMAGPsrlYs3yC3K/Jv6Ztm7YNmBhDgha8ei1YvdCLWhVGqGTjYqWF0PY1ufqKnVDx4GmlpaZI2JUbAtXla53Fdopvr/qEPOjGGhQDVZInAQSDyw/5G1vqbySWkq2R4kspQ3KeFGgPZdfkuSEstuar0uQU0q5OSYkWLBnyayJ9DG2MIr2Pl23uB86U1HVBZZ33ajbRpMyi/1E2CSgvXBHM1KLlSnsusR/TGuA2zQMtAlZpMCuiH1wxc/Cldzu7PQoLdMS/Gy
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409f9b28-fdae-4a54-712e-08d82975c3a4
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 10:48:24.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LsXWhx+BSfxsXl3/0QWQ+tOvm3wQAfzMTkif06QC/UtNzdaljc4T15aKtW6dNQqMEFVW8AtTGROqCTSxYF+iBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB2940
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
 tc/tc_qdisc.c  | 10 ++++++++++
 tc/tc_qevent.c | 15 +++++++++++++++
 tc/tc_qevent.h |  2 ++
 tc/tc_util.h   |  2 ++
 4 files changed, 29 insertions(+)

diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 8eb08c34..bea8d3c0 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -477,7 +477,9 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 	struct tc_qdisc_block_exists_ctx *ctx = arg;
 	struct tcmsg *t = NLMSG_DATA(n);
 	struct rtattr *tb[TCA_MAX+1];
+	struct qdisc_util *q = NULL;
 	int len = n->nlmsg_len;
+	const char *kind;
 
 	if (n->nlmsg_type != RTM_NEWQDISC)
 		return 0;
@@ -506,6 +508,14 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
 		if (block == ctx->block_index)
 			ctx->found = true;
 	}
+
+	kind = rta_getattr_str(tb[TCA_KIND]);
+	q = get_qdisc_kind(kind);
+	if (!q)
+		return -1;
+	if (q->has_block)
+		q->has_block(q, tb[TCA_OPTIONS], ctx->block_index, &ctx->found);
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

