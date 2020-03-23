Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6462918F968
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCWQMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:12:42 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:18336
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727458AbgCWQMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 12:12:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icdonooB7Bejcgko3KpbuskOK7H0Sr7LeWXo7nfKbQQ0htIKjpdERQemL2MK45m8y7oyVFeFUjw8KgxNDgpH48AQO0R1jJMwr4ljIt3JoeGqNfVsdyyKhZ2SIJx+IHrZVnh5gTyNwyJi8ulXeRTZ1JkX/g8t/WO7mTDHBpmkI7ouQjm05OXSY500q4GWYdryd5yDdD06Bjk+aRKU5MdfUKdaOZmfYtRgyNb4tYOA/THA5+b/K0RSd3WGzREck9uqzMMQMmUx5+jhnCSIJ7BoUqUnMYAZISQNo6XD/i3Qm3TRG/r3q7+gZseFwouDhA2Ge6XrNc+DqE+qEqOqgKhGlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJo3CUH6D7c37Fhl+f5u/iCluKw/GWUHLiPG1hWQusw=;
 b=iKZ6EsGV8reGM2XrV1zyF1jtR/PScjUUYmbSHvgPuUlW6DXcbTPOv4pQvbn3mHYUBMcB9WnwLhY6D4aLN2Q721z+5JRE8oQKuPMge1bdxhAtyU8OuWuoZ9z5KFoMz3KlfM67bh5dwCIxLQdDQqZfYn1giBzmlj76dIE88OF91mWlORq53k94Rfc/XJ9xvC+W2IDjEECLKHHOvpVAjd2wJLxUrYZY6yNd8c8nsIPtwo1dT4BiwtAjcsE/viN0gNPXHSxu8A9noX3tKWjB87a5UPFLkAHh9MlZxParga+VL7+I1lKgXIBlW6IzPmsGTaDWWiQSvyGl+dHizX14hkRXgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJo3CUH6D7c37Fhl+f5u/iCluKw/GWUHLiPG1hWQusw=;
 b=qFp6mqkjZ/x3kbXabGrmmJb/0AozSdsHKptw+3bp8bU12TojNI/bOJildWXUrY7zHBq6pluVPil/m8ehRnSxKL5ar02Cd8pq2E8Cf+wc8pxaXlD2se3fg+iShuWcD4SyeaOWZphx8JiOHTEqbE+fk07wgDqwAyjOG6M3F6eWj0c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4713.eurprd05.prod.outlook.com (20.176.165.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Mon, 23 Mar 2020 16:12:36 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 16:12:36 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next v2 2/2] tc: q_red: Support 'nodrop' flag
Date:   Mon, 23 Mar 2020 18:12:21 +0200
Message-Id: <00c7299b47f6b089e79245040484de106254016e.1584979543.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1584979543.git.petrm@mellanox.com>
References: <cover.1584979543.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0041.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::16) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Mon, 23 Mar 2020 16:12:35 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb87bd38-0951-4ac4-f6a2-08d7cf45008a
X-MS-TrafficTypeDiagnostic: HE1PR05MB4713:|HE1PR05MB4713:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB47133DB517A0C337926D1625DBF00@HE1PR05MB4713.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(52116002)(6666004)(6486002)(81156014)(86362001)(6916009)(81166006)(8676002)(8936002)(66556008)(186003)(66476007)(66946007)(16526019)(26005)(6506007)(5660300002)(54906003)(956004)(6512007)(2906002)(2616005)(966005)(316002)(36756003)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4713;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +A1LjtoJFcmrMg0lugjkEjCDW9RqpfFMkiTFfe45LJZ3foOWMk6ux1kLlpBamjoxWG7fELq/O+sfBJ2C5OH2PnhK14TCzPYI5R8ORLmGT+HM4A1GuHvwuwxBgO5qPMDs+jz5MHBQg8BqoxxTsM9o96hYfViKWwNP841B3TsOXk0linkvox/9cdZCF+KbLlkR31STyEP/zG3a/JAP2Z448JJawcKoW78RxQsdr78BOp2ue7JUnIoO6btAzPqstgvyhC1MO+35WwYmZR07woWjER5pnLKwaXzEdip6tEPECEeKkFRYhQ6C8rUmscG/q5OCyuWo5KhuomGWPI3YYv15FeVobwDD7zVw+OCARPIATc6cmzQVnxkfCHSHMI6C6AvKKBM9Pw0TcyXSHyNyA1iwYGiD7Oqn2Zy1k8StWJVrLbXapFzj3e/Qe7v7/vmYedMYVPvH/K1jlzyCkoUqab5O1GLYN9uoUmsBJeHIkFO3OITVj1CuqG4qmn8UH4McAx/arwOemJco66zaXoWaY7HPow==
X-MS-Exchange-AntiSpam-MessageData: LJvqmBfu2coYgau6kiS2XNB9KynLCajqKUxjfNGuA8jkQMn8+I8/3TWJ0XSpdy6cveql4/AVf/uknzL9N5aZPaAhqtfdEFP71ENde4foNd9VpDjWqr1M6WvzFrz4FNJ0L0qFE4DgwPGDwIESJcm6aA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb87bd38-0951-4ac4-f6a2-08d7cf45008a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 16:12:36.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwzyJo14eEP96liKipCxSHUNipGODk/2lNIociVCVoqvGWB7j7JlPQFJvWrDeP89BSU/jkUVvPjdWJ11K86UkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4713
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recognize the new configuration option of the RED Qdisc, "nodrop". Add
support for passing flags through TCA_RED_FLAGS, and use it when passing
TC_RED_NODROP flag.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - When dumping, read TCA_RED_FLAGS as nla_bitfield32 instead of u32.

 man/man8/tc-red.8 |  6 +++++-
 tc/q_red.c        | 25 ++++++++++++++++++++-----
 tc/tc_red.c       |  5 +++++
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/man/man8/tc-red.8 b/man/man8/tc-red.8
index dd1ab74c..b5aaa986 100644
--- a/man/man8/tc-red.8
+++ b/man/man8/tc-red.8
@@ -13,7 +13,7 @@ bytes
 bytes
 .B [ burst
 packets
-.B ] [ ecn ] [ harddrop] [ bandwidth
+.B ] [ ecn ] [ harddrop ] [ nodrop ] [ bandwidth
 rate
 .B ] [ probability
 chance
@@ -123,6 +123,10 @@ If average flow queue size is above
 .B max
 bytes, this parameter forces a drop instead of ecn marking.
 .TP
+nodrop
+With this parameter, traffic that should be marked, but is not ECN-capable, is
+enqueued. Without the parameter it is early-dropped.
+.TP
 adaptive
 (Added in linux-3.3) Sets RED in adaptive mode as described in http://icir.org/floyd/papers/adaptiveRed.pdf
 .nf
diff --git a/tc/q_red.c b/tc/q_red.c
index 6256420f..53181c82 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -30,12 +30,17 @@ static void explain(void)
 	fprintf(stderr,
 		"Usage: ... red	limit BYTES [min BYTES] [max BYTES] avpkt BYTES [burst PACKETS]\n"
 		"		[adaptive] [probability PROBABILITY] [bandwidth KBPS]\n"
-		"		[ecn] [harddrop]\n");
+		"		[ecn] [harddrop] [nodrop]\n");
 }
 
+#define RED_SUPPORTED_FLAGS (TC_RED_HISTORIC_FLAGS | TC_RED_NODROP)
+
 static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			 struct nlmsghdr *n, const char *dev)
 {
+	struct nla_bitfield32 flags_bf = {
+		.selector = RED_SUPPORTED_FLAGS,
+	};
 	struct tc_red_qopt opt = {};
 	unsigned int burst = 0;
 	unsigned int avpkt = 0;
@@ -95,13 +100,15 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				return -1;
 			}
 		} else if (strcmp(*argv, "ecn") == 0) {
-			opt.flags |= TC_RED_ECN;
+			flags_bf.value |= TC_RED_ECN;
 		} else if (strcmp(*argv, "harddrop") == 0) {
-			opt.flags |= TC_RED_HARDDROP;
+			flags_bf.value |= TC_RED_HARDDROP;
+		} else if (strcmp(*argv, "nodrop") == 0) {
+			flags_bf.value |= TC_RED_NODROP;
 		} else if (strcmp(*argv, "adaptative") == 0) {
-			opt.flags |= TC_RED_ADAPTATIVE;
+			flags_bf.value |= TC_RED_ADAPTATIVE;
 		} else if (strcmp(*argv, "adaptive") == 0) {
-			opt.flags |= TC_RED_ADAPTATIVE;
+			flags_bf.value |= TC_RED_ADAPTATIVE;
 		} else if (strcmp(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -154,6 +161,7 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 	addattr_l(n, 1024, TCA_RED_STAB, sbuf, 256);
 	max_P = probability * pow(2, 32);
 	addattr_l(n, 1024, TCA_RED_MAX_P, &max_P, sizeof(max_P));
+	addattr_l(n, 1024, TCA_RED_FLAGS, &flags_bf, sizeof(flags_bf));
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -161,6 +169,7 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_RED_MAX + 1];
+	struct nla_bitfield32 *flags_bf;
 	struct tc_red_qopt *qopt;
 	__u32 max_P = 0;
 
@@ -183,6 +192,12 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	    RTA_PAYLOAD(tb[TCA_RED_MAX_P]) >= sizeof(__u32))
 		max_P = rta_getattr_u32(tb[TCA_RED_MAX_P]);
 
+	if (tb[TCA_RED_FLAGS] &&
+	    RTA_PAYLOAD(tb[TCA_RED_FLAGS]) >= sizeof(*flags_bf)) {
+		flags_bf = RTA_DATA(tb[TCA_RED_FLAGS]);
+		qopt->flags = flags_bf->value;
+	}
+
 	print_uint(PRINT_JSON, "limit", NULL, qopt->limit);
 	print_string(PRINT_FP, NULL, "limit %s ", sprint_size(qopt->limit, b1));
 	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
diff --git a/tc/tc_red.c b/tc/tc_red.c
index 681ca297..88f5ff35 100644
--- a/tc/tc_red.c
+++ b/tc/tc_red.c
@@ -116,4 +116,9 @@ void tc_red_print_flags(__u32 flags)
 		print_bool(PRINT_ANY, "adaptive", "adaptive ", true);
 	else
 		print_bool(PRINT_ANY, "adaptive", NULL, false);
+
+	if (flags & TC_RED_NODROP)
+		print_bool(PRINT_ANY, "nodrop", "nodrop ", true);
+	else
+		print_bool(PRINT_ANY, "nodrop", NULL, false);
 }
-- 
2.20.1

