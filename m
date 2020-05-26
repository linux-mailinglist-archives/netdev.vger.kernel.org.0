Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E261E27FD
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEZRKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:40 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbgEZRKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUrYkZlAtA4tn1FK6CCD2WRKrzd+HEWJnYUWe64+V9fICFqB3lc2vUdbJcykgSyQN3wuPzSPUXMuEZ1PAcptzsZHhgpIznHmuO5JzJ4Gj14koFyUyhtQkEPot0kXJB3ZfpkkESmmkGRGaW3rvJOngxPeC0B87jsBdnaKMysGTygKLJSS7/1EFH66Vi1aPnbDpGuBS3PDt2pfnR+6rszg4w9pYdEw2E5R9ya0jyz3SMw1gJmN9xHrGRfX6NlGIzvnGjmKVdgzV81ySo0tHWCF00FGHRx4RRSyC1i2wLY6hGfeA7bzMhk8ldgwlArOv80vLIM4MSR9v4hWwnj8DAGAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+57hAT6sJTVnYQl4H3ReYUIqovuLnXzDH/iVfmOQtmY=;
 b=aUuLrmOodriZMK6wijb0nQ2q/B9S+F2WiWenUeFerixVmmLA5URmvndQZ2XGPcfAl8VzyP92zSaiQgXGkila6HKi7mznI0l93HSPbqMxd3bp2VXc9CmAb982ctiqVe4GHwvn6cPjCOhar98c8VURj6fP29xMd3Hk+lbOnzuw9DkybbV1su0paa9i4oSABfxkEnJVWFtDoRUgXnliGxCMRAQwqqsUV0zJgo7bWDEbYyjwzSwlbOkmiBZBnbj5W3lm1+pfa2Q8/pCLFOj/yHuVBMzjUkSQh693HXmi0w5H5JF/zfYd5OtKe6a9ua5crVGXnYehLYYb+PQyCFEo5Cjfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+57hAT6sJTVnYQl4H3ReYUIqovuLnXzDH/iVfmOQtmY=;
 b=fTr2TfapOi2N3K1CyzNo3Do1BAMM1zL/7IoMFLx8LWPbtEEDHQAtOv3nRyKDEPGUe+nPtEGKRplZZVnx8LVbW0ls9l0UqH2WBV+ILnnGkQPWBEbM5B23pCKgMhL0UiHvHMfLQ9Fd8XBnthdTnEZ0ROlbSq73qKwDje/yUF5E+po=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:33 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:33 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH net-next 2/3] net: sched: sch_red: Split init and change callbacks
Date:   Tue, 26 May 2020 20:10:06 +0300
Message-Id: <b761925f786dc812c75e4d0e71c288909248216f.1590512901.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1590512901.git.petrm@mellanox.com>
References: <cover.1590512901.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:31 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b1533a9-7d57-44e3-e11f-08d80197b2ea
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3225C5F80F7434011A1490C0DBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I3jvxfjW5WDjb9TdnpRANZ0ZpnB+t2eFGyxN1vxL1HY1/mQm38hkSv9z8LQWlZVn3rJtpNMGP7YdkoC0RilzgLjps3+kjUHFk0mI7gDATNzb6ZbZ5PEfh3Npb2HNXq5McuFVzlv6DOPMK7Xrj1SqvZZKg6RfBwu9o+GFT2VP14yPOm+oFjiYZDHVYEfA6nSF0vJhzRSSt9BxUrjk4plI8YHCGJq0dYLO5i0JwcaoSXgJoGL4hDHb04ZWFvW8Rj97cnDApRkBiaNuOrKWUdgFfnOQLJuPcFjd+H/qt2+lBRTSZxnEiliAdymugfs17ZzmTUsYAARutBgnvaf/SsxDDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M8FdRTQXUBzsUkj52q2h/p4UNrVHhvStzc3C6tARMayGFUegQv/SpKzpHTM1hysdGwI8hLlFLsQ/eDt/qD8q6E1OyIsYSRzOY+MQpYMSCJJnDZ/P2L9ZLEkzdPSELZGm9MmY/HqcPYa5Kbtl1TUwt+zc04rAiIozoW6zoXvlhSEjKVo+u+ZopCibZ+hZ2owBw8H7553ri0Ss12I4N6/v3/Sa68cSPQWg80PtkXj6K4BpeHQE6KuMFPsoMJxiB33EV5zlxxEaxg7x4BCpxqGE2EJDsFbRNqY1NoPokrG/EavCJJ1XPMG9ggPa5E6Bb6aNbiCsYru3gVBQ4ZZEiy5w0cKCCbBQG/zYZqrMZbwSZN6x8jNn9xCdEgmLmyjS8sczUEt1fzmzU1MCQpGB+cpBwmIHXvZn9t81rrjcWIxmTgy0o1PdbiIVdgG0ovxz61Y7jRJGWVYTFpY+zPItL5UZkCE9Trs36X8eqPigyFZH0e/24bFDaaucUDMzgYDuEbhE
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1533a9-7d57-44e3-e11f-08d80197b2ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:32.8890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hdvFG3W2bnF9veMEBM7jeI97f6L/suQx5ZpG+jWE3bJgA+9+cTL6wv3PckzatAhbx+MwN1xGBUPZdsjIMatIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following patches, RED will get two qevents. The implementation will
be clearer if the callback for change is not a pure subset of the callback
for init. Split the two and promote attribute parsing to the callbacks
themselves from the common code, because it will be handy there.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 net/sched/sch_red.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 555a1b9e467f..c52a40ad5e59 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -215,12 +215,11 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
 	[TCA_RED_FLAGS] = NLA_POLICY_BITFIELD32(TC_RED_SUPPORTED_FLAGS),
 };
 
-static int red_change(struct Qdisc *sch, struct nlattr *opt,
-		      struct netlink_ext_ack *extack)
+static int __red_change(struct Qdisc *sch, struct nlattr **tb,
+			struct netlink_ext_ack *extack)
 {
 	struct Qdisc *old_child = NULL, *child = NULL;
 	struct red_sched_data *q = qdisc_priv(sch);
-	struct nlattr *tb[TCA_RED_MAX + 1];
 	struct nla_bitfield32 flags_bf;
 	struct tc_red_qopt *ctl;
 	unsigned char userbits;
@@ -228,14 +227,6 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	int err;
 	u32 max_P;
 
-	if (opt == NULL)
-		return -EINVAL;
-
-	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
-					  NULL);
-	if (err < 0)
-		return err;
-
 	if (tb[TCA_RED_PARMS] == NULL ||
 	    tb[TCA_RED_STAB] == NULL)
 		return -EINVAL;
@@ -323,11 +314,39 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 		    struct netlink_ext_ack *extack)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
+	struct nlattr *tb[TCA_RED_MAX + 1];
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
+					  extack);
+	if (err < 0)
+		return err;
 
 	q->qdisc = &noop_qdisc;
 	q->sch = sch;
 	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
-	return red_change(sch, opt, extack);
+	return __red_change(sch, tb, extack);
+}
+
+static int red_change(struct Qdisc *sch, struct nlattr *opt,
+		      struct netlink_ext_ack *extack)
+{
+	struct red_sched_data *q = qdisc_priv(sch);
+	struct nlattr *tb[TCA_RED_MAX + 1];
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
+					  extack);
+	if (err < 0)
+		return err;
+
+	return __red_change(sch, tb, extack);
 }
 
 static int red_dump_offload_stats(struct Qdisc *sch)
-- 
2.20.1

