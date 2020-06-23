Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86D4204F75
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbgFWKpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:45:05 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:11647
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732282AbgFWKpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:45:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOs4ppgLT2J5aPnURLfzOdgRJqtiAccMGgIzU9bD+fKuao6UqnT/OrYIvijvK5pr0b2H1XSC67S6H4x6CpPFF1Te7Fsvmq42wN5gDKxad8Jfz3ZLrOU9+nT23V8hezSYQIBwx5tminI0ADyRw08JDnkcUcNgLDfVswYHy5pbKNI9J2S6199htgAsjDZ1JvBbWRYOfYXatFd4/JiFFgTRZsLA5+osg+yM/F/3g8tj/p0bSNb1pt2b3jVSVkgr7Imz0lH/Cr3dmKgZcVFO1mPrRAGTk2uN3RixeKk8d7H0i2slTHq28FAuPqbUI9q5p5VA2JUtkrsjtIKeJaHU//Db7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GMMWjzgyj+1pDLGUKKqEwHUPPqu8O/0h2TysAGnwwU=;
 b=HKZ4/+e4Hy4o7nH6eO5RzpEB/1OtQRJ+jkbCe2lQxVYkg2B5RO8FvECENt2vU2K0O54sjXryQG0NU0KlmdxBcJR1prErLJJ5EP8gGpkzGwOCd9jbE/2bI2Pxin1HNjWy18QMnHMGLxidghbL4WDBIhsj2hnwLRyvS8tEhDvyyYnTJlVdcup77+Urij6ZryJMZ81qoRovDqpkzAm7i+yyvqhvKpxda202o5Mhbq1csVUZYwaS6XnUix5vODArJ0B5j6R4/zyRa5xFAShvcBRlrBRh+to8hR0iE1bamvgzqZ02Np/uzKUGS7WNXAIxXMEMKRUnDVdU7gOWFnaqYYp64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GMMWjzgyj+1pDLGUKKqEwHUPPqu8O/0h2TysAGnwwU=;
 b=XNtu84894lZVKIQd4dbwdpmCMQkEPi9yyDhoHFv0Z3wJO8jusEUuoTqiZxMoiUp3Hg5YWAYIsldASfXF8+1Wp/FRpLCXVQIreZTT0EmZcaMdd9YN0NiaghxnhhhcBqLHcypjKDa+DHDfPtEdkFHxgc8w1BM0J+SKpF/kiTHy+Hk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6034.eurprd05.prod.outlook.com (2603:10a6:208:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 10:44:54 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:44:54 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 2/4] devlink: Move devlink port code at start to reuse
Date:   Tue, 23 Jun 2020 10:44:23 +0000
Message-Id: <20200623104425.2324-3-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623104425.2324-1-parav@mellanox.com>
References: <20200623104425.2324-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0201CA0035.namprd02.prod.outlook.com (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:44:53 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab56f526-280d-447d-3d86-08d8176276f6
X-MS-TrafficTypeDiagnostic: AM0PR05MB6034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB603414CBAB98DF2D3F0F66B8D1940@AM0PR05MB6034.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cSB+MZf8kucqmr/KBRJ2XJLo7PJo1I5qMe4eQ5HC5ja31cvV9XRyu32xr3alGPudejAKDTHhSgHgKefs8LuIQgPx7kdorSCq1YSmylz885R2iGCQzcCrmKyBPQh/uvXQBccj3IW5tsOOR/CLhIYUmrjEB1NXB9g0go/pGocMgIBCGCLIHver0Uvlrt3qCbxq4IRDgFl1y4mtRPHMPUeY9t3XkRVbQQJf1DxjqtE6ekCzkMWUSMVxsZcQmK86rvaeVlhSi+kWuO979UbHhTatLwwnzXs0tpaZKgpcW1ZGkPiKQ3qUgN2m3XAXsieAvx4m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(5660300002)(66556008)(66946007)(66476007)(1076003)(478600001)(6666004)(316002)(16526019)(186003)(26005)(8676002)(52116002)(6506007)(107886003)(83380400001)(6512007)(86362001)(8936002)(4326008)(956004)(2616005)(6486002)(36756003)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xC7LDhk+6jsfIRAbY1YYAtwuhM03VOzvOpqmiMAJEFr4PP82uFQSDuthBb0NmbTvk04nwZ0b+Q77WQfrFbPUKxl99e1FFQ0ChxxWJhfGK1Oa+Rq7oAqoYb7Yl9+cxOW3ntE1pmMLqHWJnEjzWwOTNdkyvjzdtiwSSr6TSyvKrMfQFHD6+M7bZ+2/ypeu3HRmdqUYvnnxZpWAeDGXOewqtCJJjBH73FDhWj4NhTiKKmie9zs8HiXpT+Ufd8Qo0/Lg1tF5AZWZh6Dqy3SacK93yJp5IfbEGpuQ/A4uyul/ZG/dTelrEtd14kCqCTkhIJ8W5x957WJ4WB/bevazHDtCG4QVMW0gqY09pxtVAVX6BvQeW+/gHvW4283TQ+nlvepuTIuIOU4G1O3C1unUrr+92oY6WwzP3UObsWq43BCNgflIr0aneNg/sqjfxw3QLy3jdP9e/LhWlH8zfqGOXXa634dbixxQVvigw2VbRLQEY6ZTDZWWWNSftl3nwnrkj9Fj
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab56f526-280d-447d-3d86-08d8176276f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:44:54.4667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +i4zWh9TR2b7PMmYocUWxS1U7lklxOhf2vtDAqy/Bq+8OdPfS1SW1j4z2Zzh7l1wjsKEgew9aGfG6wYlzADg1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reuse print routines for port function in subsequent patch, move
print routine specific to devlink device at start of the file.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 242 +++++++++++++++++++++++-----------------------
 1 file changed, 121 insertions(+), 121 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 507972c3..b7699f30 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -429,6 +429,127 @@ static void __pr_out_indent_newline(struct dl *dl)
 		pr_out(" ");
 }
 
+static bool is_binary_eol(int i)
+{
+	return !(i%16);
+}
+
+static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
+{
+	int i = 0;
+
+	while (i < len) {
+		if (dl->json_output)
+			print_int(PRINT_JSON, NULL, NULL, data[i]);
+		else
+			pr_out("%02x ", data[i]);
+		i++;
+		if (!dl->json_output && is_binary_eol(i))
+			__pr_out_newline();
+	}
+	if (!dl->json_output && !is_binary_eol(i))
+		__pr_out_newline();
+}
+
+static void pr_out_name(struct dl *dl, const char *name)
+{
+	__pr_out_indent_newline(dl);
+	if (dl->json_output)
+		print_string(PRINT_JSON, name, NULL, NULL);
+	else
+		pr_out("%s:", name);
+}
+
+static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
+{
+	__pr_out_indent_newline(dl);
+	if (val == (uint64_t) -1)
+		return print_string_name_value(name, "unlimited");
+
+	if (dl->json_output)
+		print_u64(PRINT_JSON, name, NULL, val);
+	else
+		pr_out("%s %"PRIu64, name, val);
+}
+
+static void pr_out_section_start(struct dl *dl, const char *name)
+{
+	if (dl->json_output) {
+		open_json_object(NULL);
+		open_json_object(name);
+	}
+}
+
+static void pr_out_section_end(struct dl *dl)
+{
+	if (dl->json_output) {
+		if (dl->arr_last.present)
+			close_json_array(PRINT_JSON, NULL);
+		close_json_object();
+		close_json_object();
+	}
+}
+
+static void pr_out_array_start(struct dl *dl, const char *name)
+{
+	if (dl->json_output) {
+		open_json_array(PRINT_JSON, name);
+	} else {
+		__pr_out_indent_inc();
+		__pr_out_newline();
+		pr_out("%s:", name);
+		__pr_out_indent_inc();
+		__pr_out_newline();
+	}
+}
+
+static void pr_out_array_end(struct dl *dl)
+{
+	if (dl->json_output) {
+		close_json_array(PRINT_JSON, NULL);
+	} else {
+		__pr_out_indent_dec();
+		__pr_out_indent_dec();
+	}
+}
+
+static void pr_out_object_start(struct dl *dl, const char *name)
+{
+	if (dl->json_output) {
+		open_json_object(name);
+	} else {
+		__pr_out_indent_inc();
+		__pr_out_newline();
+		pr_out("%s:", name);
+		__pr_out_indent_inc();
+		__pr_out_newline();
+	}
+}
+
+static void pr_out_object_end(struct dl *dl)
+{
+	if (dl->json_output) {
+		close_json_object();
+	} else {
+		__pr_out_indent_dec();
+		__pr_out_indent_dec();
+	}
+}
+
+static void pr_out_entry_start(struct dl *dl)
+{
+	if (dl->json_output)
+		open_json_object(NULL);
+}
+
+static void pr_out_entry_end(struct dl *dl)
+{
+	if (dl->json_output)
+		close_json_object();
+	else
+		__pr_out_newline();
+}
+
 static void check_indent_newline(struct dl *dl)
 {
 	__pr_out_indent_newline(dl);
@@ -1950,49 +2071,6 @@ static void pr_out_port_handle_end(struct dl *dl)
 		pr_out("\n");
 }
 
-static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
-{
-	__pr_out_indent_newline(dl);
-	if (val == (uint64_t) -1)
-		return print_string_name_value(name, "unlimited");
-
-	if (dl->json_output)
-		print_u64(PRINT_JSON, name, NULL, val);
-	else
-		pr_out("%s %"PRIu64, name, val);
-}
-
-static bool is_binary_eol(int i)
-{
-	return !(i%16);
-}
-
-static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
-{
-	int i = 0;
-
-	while (i < len) {
-		if (dl->json_output)
-			print_int(PRINT_JSON, NULL, NULL, data[i]);
-		else
-			pr_out("%02x ", data[i]);
-		i++;
-		if (!dl->json_output && is_binary_eol(i))
-			__pr_out_newline();
-	}
-	if (!dl->json_output && !is_binary_eol(i))
-		__pr_out_newline();
-}
-
-static void pr_out_name(struct dl *dl, const char *name)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_string(PRINT_JSON, name, NULL, NULL);
-	else
-		pr_out("%s:", name);
-}
-
 static void pr_out_region_chunk_start(struct dl *dl, uint64_t addr)
 {
 	if (dl->json_output) {
@@ -2034,84 +2112,6 @@ static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
 	pr_out_region_chunk_end(dl);
 }
 
-static void pr_out_section_start(struct dl *dl, const char *name)
-{
-	if (dl->json_output) {
-		open_json_object(NULL);
-		open_json_object(name);
-	}
-}
-
-static void pr_out_section_end(struct dl *dl)
-{
-	if (dl->json_output) {
-		if (dl->arr_last.present)
-			close_json_array(PRINT_JSON, NULL);
-		close_json_object();
-		close_json_object();
-	}
-}
-
-static void pr_out_array_start(struct dl *dl, const char *name)
-{
-	if (dl->json_output) {
-		open_json_array(PRINT_JSON, name);
-	} else {
-		__pr_out_indent_inc();
-		__pr_out_newline();
-		pr_out("%s:", name);
-		__pr_out_indent_inc();
-		__pr_out_newline();
-	}
-}
-
-static void pr_out_array_end(struct dl *dl)
-{
-	if (dl->json_output) {
-		close_json_array(PRINT_JSON, NULL);
-	} else {
-		__pr_out_indent_dec();
-		__pr_out_indent_dec();
-	}
-}
-
-static void pr_out_object_start(struct dl *dl, const char *name)
-{
-	if (dl->json_output) {
-		open_json_object(name);
-	} else {
-		__pr_out_indent_inc();
-		__pr_out_newline();
-		pr_out("%s:", name);
-		__pr_out_indent_inc();
-		__pr_out_newline();
-	}
-}
-
-static void pr_out_object_end(struct dl *dl)
-{
-	if (dl->json_output) {
-		close_json_object();
-	} else {
-		__pr_out_indent_dec();
-		__pr_out_indent_dec();
-	}
-}
-
-static void pr_out_entry_start(struct dl *dl)
-{
-	if (dl->json_output)
-		open_json_object(NULL);
-}
-
-static void pr_out_entry_end(struct dl *dl)
-{
-	if (dl->json_output)
-		close_json_object();
-	else
-		__pr_out_newline();
-}
-
 static void pr_out_stats(struct dl *dl, struct nlattr *nla_stats)
 {
 	struct nlattr *tb[DEVLINK_ATTR_STATS_MAX + 1] = {};
-- 
2.25.4

