Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082B519E131
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 00:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgDCW4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 18:56:03 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:20484
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbgDCW4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 18:56:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpM09Z4/soh2yBsmAJsCkKndc5Iia/ZhKuwANF5uKXrGUZKmcfNVRpG8fcZb9YgCSMCMiyU2ai+Ojzpw2SSPtzWAmtLNOFc2/1imJ91mm7SxXCanmnGGeCKxNiM6Kqg7OLWpY0wwyWmZ/hL0xHn8/90nAeNRu1IsNCMGTkVagFpN31HXTWr6sEDiYV0XcvRMHJj8aF5bVoPpvTjrDwfiu7zJ3yZfjAzhrhqxn0npxbO+OGcCELLDyrQQVA2EJSiBpymo9KNi1dJNZgsvSNw02Ku8NXrD/tnnybl99hns3DosfGtW0Q1wOLcY0u3XFver7zrAo79uPSk8dyjo/tdyww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upYkbKEy9lDSjiqVIezoAZAezxSZe0pStJ7H10sTZaY=;
 b=d5w1DoICUPPQunG20Mtiyc7YM9KS2n5TrdPOWmXgGddSUDBUvZomC1/0DQGbXNz67e/Paz631q/vdqSeGjgyPkIzj0P+4nWrasE/bSAauttRdDQhBT23JdVfvcGVoQMQ8F3i5DfKJe1OOUuWD0AGuFtUjQNNnM24Hn3Iijr7GTulZotE7jZvE6vf6up4pcnCW2K7AnNw6J4r0aRChm7glVTE5bb/+OOvzkViPFgMbQ3Z8g4eqnOiLGhLwgyF55J4Gh+OjGigbUFSgTIm+SVZbmSf25Kh9hVPC+pZ3y91/dBzFGj+10bVE9hs1nr/QbjC0//93fPwC0rT3xP70jVPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upYkbKEy9lDSjiqVIezoAZAezxSZe0pStJ7H10sTZaY=;
 b=Vsu6n4kMN4rRbE+ZuWfJlsd252ThzRHbl1/1Gzgd2HTk4fweU1Unv5WFYPKqMSLXuiF4tazUB4WqfDHmtxaPinrz+fhIxpCGYkYqcSMyi+18/19pyMn2J9f9bNyVBKN81zH7VZAS7nvTlRr51MvQ+TNPjDF1xvf6Sgcec88ynZA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3148.eurprd05.prod.outlook.com (2603:10a6:7:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Fri, 3 Apr 2020 22:55:54 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Fri, 3 Apr 2020
 22:55:54 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Xin Long <lucien.xin@gmail.com>,
        William Tu <u9012063@gmail.com>
Subject: [PATCH iproute2-next v2] ip: link_gre: Do not send ERSPAN attributes to GRE tunnels
Date:   Sat,  4 Apr 2020 01:55:34 +0300
Message-Id: <d8dd14970b391c9c7e9ed11377d43dc56435eca5.1585954448.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P192CA0021.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Fri, 3 Apr 2020 22:55:52 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c6cf7ae-b76e-42e3-a578-08d7d82229ad
X-MS-TrafficTypeDiagnostic: HE1PR05MB3148:|HE1PR05MB3148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3148F793CC775BAC09BAEEBEDBC70@HE1PR05MB3148.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(52116002)(5660300002)(316002)(86362001)(26005)(36756003)(66946007)(8936002)(81156014)(54906003)(2906002)(66556008)(66476007)(6916009)(81166006)(8676002)(6512007)(4326008)(956004)(186003)(16526019)(6506007)(6486002)(6666004)(478600001)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N/klVc0Le/J76RRE050NBOz9yL5hWApiZSpBK/n8p3St0tNBkF+meslbuyA44SWR/pRU+E1krQVRkik9O2RTjYICYKEmVlWRSpZ+1+depGQA001CjO7In/pZOKHbMh2EKVZRZdTgQ3aYhIypHAnwabZpl3zBQAg/CmN+sGH2ds+LmWpAqS8hq3hBOEn07nf902Ci4I+ETe0sV3u8+yUpB2aPhk5bEosDYDa2CwJdq9cCcfSS7XzamLkg3lWNcdRHEzYO1jcSMJ/lKh/cvlvG/cttKA/vKK5RFOmPZQwsKOaSDKNcI75FTKeGa9IuTicvHXUPfgxmLn7cfqchwgyIdR/tKMYcaIk+nzEMZ5lycr28cIoU0EfnhWgjET0wzAZv8gCMVHAlnSt9rUedqGLNI+lLJqITs55JF7H70vOpyL0Cb4KErFghn2OfdimwAoyy
X-MS-Exchange-AntiSpam-MessageData: xFUITF171MwxztRiIh3vm42Mrbqqyx7dqzdaFuA1aAXnGevCPfSXW47k41qvJf8ebLKwfMiQyCRDq9PFRaaEV53qNE7ljNLTMHLNOgMFd2x3ytfrfqLa/spuVPSv6zIWY+17GyTigVCXu8rJkrTorA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c6cf7ae-b76e-42e3-a578-08d7d82229ad
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 22:55:54.0185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: coS7Lz2fq84VJXAsfbG/X834FVba5OFPcv7Md1pIYWQFBNqdN+4LCbzK78NnmuG1/8Uj4fnECGwkAh73cR06/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit referenced below, ip link started sending ERSPAN-specific
attributes even for GRE and gretap tunnels. Fix by more carefully
distinguishing between the GRE/tap and ERSPAN modes. Do not show
ERSPAN-related help in GRE/tap mode, likewise do not accept ERSPAN
arguments, or send ERSPAN attributes.

Fixes: 83c543af872e ("erspan: set erspan_ver to 1 by default")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: William Tu <u9012063@gmail.com>
---

Notes:
    v2:
    - Resend.

 ip/link_gre.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index e42f21ae..d616a970 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -23,8 +23,15 @@
 #include "ip_common.h"
 #include "tunnel.h"
 
+static bool gre_is_erspan(struct link_util *lu)
+{
+	return !strcmp(lu->id, "erspan");
+}
+
 static void gre_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 {
+	bool is_erspan = gre_is_erspan(lu);
+
 	fprintf(f,
 		"Usage: ... %-9s	[ remote ADDR ]\n"
 		"			[ local ADDR ]\n"
@@ -44,18 +51,20 @@ static void gre_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 		"			[ encap-dport PORT ]\n"
 		"			[ [no]encap-csum ]\n"
 		"			[ [no]encap-csum6 ]\n"
-		"			[ [no]encap-remcsum ]\n"
-		"			[ erspan_ver version ]\n"
-		"			[ erspan IDX ]\n"
-		"			[ erspan_dir { ingress | egress } ]\n"
-		"			[ erspan_hwid hwid ]\n"
+		"			[ [no]encap-remcsum ]\n", lu->id);
+	if (is_erspan)
+		fprintf(f,
+			"			[ erspan_ver version ]\n"
+			"			[ erspan IDX ]\n"
+			"			[ erspan_dir { ingress | egress } ]\n"
+			"			[ erspan_hwid hwid ]\n");
+	fprintf(f,
 		"\n"
 		"Where:	ADDR := { IP_ADDRESS | any }\n"
 		"	TOS  := { NUMBER | inherit }\n"
 		"	TTL  := { 1..255 | inherit }\n"
 		"	KEY  := { DOTTED_QUAD | NUMBER }\n"
-		"	MARK := { 0x0..0xffffffff }\n",
-		lu->id);
+		"	MARK := { 0x0..0xffffffff }\n");
 }
 
 static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
@@ -93,6 +102,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u16 encapdport = 0;
 	__u8 metadata = 0;
 	__u32 fwmark = 0;
+	bool is_erspan = gre_is_erspan(lu);
 	__u32 erspan_idx = 0;
 	__u8 erspan_ver = 1;
 	__u8 erspan_dir = 0;
@@ -334,19 +344,19 @@ get_failed:
 			NEXT_ARG();
 			if (get_u32(&fwmark, *argv, 0))
 				invarg("invalid fwmark\n", *argv);
-		} else if (strcmp(*argv, "erspan") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan") == 0) {
 			NEXT_ARG();
 			if (get_u32(&erspan_idx, *argv, 0))
 				invarg("invalid erspan index\n", *argv);
 			if (erspan_idx & ~((1<<20) - 1) || erspan_idx == 0)
 				invarg("erspan index must be > 0 and <= 20-bit\n", *argv);
-		} else if (strcmp(*argv, "erspan_ver") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan_ver") == 0) {
 			NEXT_ARG();
 			if (get_u8(&erspan_ver, *argv, 0))
 				invarg("invalid erspan version\n", *argv);
 			if (erspan_ver != 1 && erspan_ver != 2)
 				invarg("erspan version must be 1 or 2\n", *argv);
-		} else if (strcmp(*argv, "erspan_dir") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan_dir") == 0) {
 			NEXT_ARG();
 			if (matches(*argv, "ingress") == 0)
 				erspan_dir = 0;
@@ -354,7 +364,7 @@ get_failed:
 				erspan_dir = 1;
 			else
 				invarg("Invalid erspan direction.", *argv);
-		} else if (strcmp(*argv, "erspan_hwid") == 0) {
+		} else if (is_erspan && strcmp(*argv, "erspan_hwid") == 0) {
 			NEXT_ARG();
 			if (get_u16(&erspan_hwid, *argv, 0))
 				invarg("invalid erspan hwid\n", *argv);
@@ -402,7 +412,7 @@ get_failed:
 		addattr32(n, 1024, IFLA_GRE_LINK, link);
 	addattr_l(n, 1024, IFLA_GRE_TTL, &ttl, 1);
 	addattr32(n, 1024, IFLA_GRE_FWMARK, fwmark);
-	if (erspan_ver) {
+	if (is_erspan) {
 		addattr8(n, 1024, IFLA_GRE_ERSPAN_VER, erspan_ver);
 		if (erspan_ver == 1 && erspan_idx != 0) {
 			addattr32(n, 1024, IFLA_GRE_ERSPAN_INDEX, erspan_idx);
-- 
2.20.1

