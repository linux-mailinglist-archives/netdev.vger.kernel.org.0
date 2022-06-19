Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB21055094B
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 10:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiFSIPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 04:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiFSIPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 04:15:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C87E03A
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 01:15:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsUZ8v4YGrIvuEdsly8KnSBID5MGborGGeaV7cQWKp7A+DLjlH82kA+rtpkYoaYfvyDRRRx2RHkVGAfVZeyhZqzszP7k0MuiWKY5en1uydlirfyNou1J2JvbTYrFA5ArwFSDvsiceanxMDHNI2miKEFbtdamj7oNQHk5oW7grYFDdHJ6LEeSN9onyq1l1UOu//GW1T9pYxz6yq66PyoGA6HFcS/z9WZLLxa4fqZdg95PALpVyZ3YZY6HEwinoramC0xFVUKxv1qD+voMxYaanctqKps2T0PEgdUv25Djj+vgLgddoTme1G9p1NGWqJrx0STPWFk/Eai+63Y37k0VKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TE7MCrvOXZV1gN+Wmpxk7GsZUetSMq933ifJ2+NruU8=;
 b=lQ4ME9kE23/aencRfhh8NTllAh+RAv6OnveY3g+EcU2bxaZgjhTwTUrw5Gy9PprGzsx0wbOsX5AU/C19yVr3QVL/lBsTZG2ISFl+GQGkDVh7tE7bHAyqfTd3Z12slbLYOhKqD2wv222YMnID36bVHuLYIM5VqpElfithJdrrlQfUYHOEQ0UlIOjEszEVEhJCG4yhMmPfT1CT5mzBUziWcrNk5STYl/ECWeZfRbqd6EqLnasyvNBf7ooyhKJFwIlg65g5dZG5Qld1w1CtyAP02gK6ODLt0leKCspTFIRp2JduMCQJTLsCDstk+7PhbTcgQlxO1e3uLVyA7vJHE/n25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TE7MCrvOXZV1gN+Wmpxk7GsZUetSMq933ifJ2+NruU8=;
 b=rz88OaeKiMe8aJi+bE0b7ft4s8tfyYmBQ6/Y7zo5jnaRYgJZtq60Qrt86xJs/KczOyWjnJbnwIO1wi6v907+r8UEq4JD7zC0r/fuX1oNYXN19haLqkbAx353kNyReCfteLWFJTrvsHCWDLKDfrdGyQ2uZmJgXgxcXD6ywlK+Z2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB2460.namprd13.prod.outlook.com (2603:10b6:5:cb::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.10; Sun, 19 Jun
 2022 08:15:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.013; Sun, 19 Jun 2022
 08:15:48 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] Revert "nfp: update nfp_X logging definitions"
Date:   Sun, 19 Jun 2022 10:15:30 +0200
Message-Id: <20220619081530.228400-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0101.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0628de58-6eda-430a-c1bc-08da51cbeace
X-MS-TrafficTypeDiagnostic: DM6PR13MB2460:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB2460CB5D5723139A4D8D4896E8B19@DM6PR13MB2460.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmz6XoPtgnXI0saqlPgrJGcE0DCmioToB6XX7p1YhWYmao36SASK1TuEsu/CNiYWKop8tWJSqJeKK8nkR+Nv9cCOrr7hWkiCB8UWjlBfFD1xTgi22UwfBWRorPHtxB2Qrho4oixPwH7rhwhLnvR0uqxWbixGQLN4ORlwsAYf8255308tjl5oRIzOiXCgX6YG+j0gNkaDQWM/6LT3jMUlB0fqTO0vpi+7dIMP0xMMyeza/UWNBOvx+Kv1S17VdUI6THIKafAUfWU7ghyLj/8fVo+kZRo6Gn/+4EprzPXgRvvrnk/taUESN0jBYX56NPpySIcRQySg4wZywhB5IMt9nzW9ftCs2U9tRN4fvvBZuhZaRsM3SrAC2Nuy7hEDBp0eoSCIViJudzJjvIiCFuc3qgV4Ey9XNi5OdMJnUkfCCARjr4H8DoZ0hCiKd6ht7JKSsdh0ihikA8g/KPad5ILzxqQ7gv0vPQE/MKZQSCq5sqyeKLiYhtP/YHk1sxcF7cGo1N78NOWH6bw63HRVjMnouR+YgBr0CDSWdjn6sDn96yR6Y6Ki5NNGDzT7cD16WX9TXGrmYcAEU/3apJo/pZuHiTm6ZDt/saOCBRYznOLVKauwYv1qdJ/QFqAfmv4umqf7o0N/MLJJMj8JFO8p8ilSLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39830400003)(366004)(107886003)(186003)(86362001)(83380400001)(38100700002)(1076003)(66476007)(110136005)(66946007)(66556008)(8676002)(316002)(4326008)(36756003)(5660300002)(6486002)(6506007)(6512007)(41300700001)(52116002)(508600001)(8936002)(6666004)(15650500001)(44832011)(2906002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YbI6FcFarpvC7IimUzbRzsgKXD8lunSOE6RehL4EzQXmk3Ofs6VWcGsWWfBG?=
 =?us-ascii?Q?FGCn5yO1x0kLyfaAZ819+ZBKfRb4pKsCS6QYhclc8m65dJMY5Z7GAKZevOpK?=
 =?us-ascii?Q?QLRmsaY5TeIyz5ycLtNRLxd2dH7D+mJpqYMTKGHKoPrv3+tXRQMzKt582Hbb?=
 =?us-ascii?Q?lQb1D2AazA7QylQ6+kAv9mCdOrmz6UhlDIuxG9vkrliIpssJyW/bNORfluyY?=
 =?us-ascii?Q?fqjeeH41RU0S1t2Rq9DSX6+yHgKERccYfyMXs7t56CxNvq1yXmwl00LeFdPn?=
 =?us-ascii?Q?hOBrF3q9E5A1alcVTX+2zokjcvtNjSUSy9AFuBjkenHN8e2oy6nUIukpRZ0u?=
 =?us-ascii?Q?mDVFpqMAXX6ENxBpfjANURgQbH1hogHAqyR2hDhqrj7JHi8dTXYy3oifuPyW?=
 =?us-ascii?Q?lX+JCxHcMUIw4cUzR+7U9PQpGD2NyMIxCJpqlDZBndkDMlckETLvQzKRfDJz?=
 =?us-ascii?Q?yuf1ceP1cgSgs4ZpaCAvVd+yngLdrw1ujuQIQB8hI0YG3bZsHciDS8efqNni?=
 =?us-ascii?Q?9LfGrsvdNMQ0hD1dbe3wKvAX0R3Z9X0nQEA7mz1fYIK3wk2ykq0nQ7nnc3JY?=
 =?us-ascii?Q?ArqkvucISNM/q/Bp5/sLQEy36umpZ/ewXipB728opQsJkeZswjwq/L7M7G8b?=
 =?us-ascii?Q?1YfH86azQsoHaJOcE16yFt9SozskrLJMY2JlfczgRclL6KgU5hPZ6l3lrVFK?=
 =?us-ascii?Q?/eaheuwPcu2wsnpLGxyqrIx2BWUTLxZS0P2tZxQmHvjbYxZJQpGuHAEjhp0T?=
 =?us-ascii?Q?xfOruybNL8RjVD/KkrLWReoKE3pcR1UdsEq/ccxLSdPKjHM++OcVt/J0CaAq?=
 =?us-ascii?Q?fPXueaTlPKJKwo5QTkO6Y8EmPLI0+YVMKSgG4loVdf09BNndFwHaOr+mbRaz?=
 =?us-ascii?Q?YQJ54VIOhAxuyNcMRUm1mVSy0qxHIHQgrxag1cOUjAthfIFi9Ux/0RaXTLh8?=
 =?us-ascii?Q?Is4q07ije694V7IVDT7fkIokaccWITnsn4CV1IUXUMGNCK2Kh2gEjoXGtPZG?=
 =?us-ascii?Q?KhfjKaAhUDY7abI7BeZEYnCg1WczrURtbinPRFsvgG7VIlzcobDeQeTPJ6JJ?=
 =?us-ascii?Q?ZgTv3CfmAFFT8JP2hM7C8PWZnp+Ji3wBJ+0XMCvtMnp13bdLtRZuQKNnKPzA?=
 =?us-ascii?Q?0qWCBBrKsXNeO7ZNUWA3D5KpDjRkdiidi3+tN8ltW74xvuw9FFFQIlSfR7kU?=
 =?us-ascii?Q?2mUcaEQv8kdUBFyB2LdaGfRsjI0ZsDoIvFwK6a8ex2d6+WIp6ZhKpXcew9mn?=
 =?us-ascii?Q?nH8NcA1YMpwmxkZpAElrfa69OHpkMDqb6Tygv34EVsCvHbd89TsH5h8Xg/3V?=
 =?us-ascii?Q?iBfkQaZyhrQuc1pAcYd8bkxkoeCUEGZR4PoEzR1ITXYkf/NCsRO+SFNVNAQG?=
 =?us-ascii?Q?qc+ehiBARO3blISWdSpRoZ9oFSiM2RMFJ9/k3IBgPKyT/CcQWWIRNPbo/AJ9?=
 =?us-ascii?Q?U5s8mYoLuJewooDzZ+ZdeRV6m37V1oDuZppzsRDGz5yyjMn6gWRZdB2/iRfB?=
 =?us-ascii?Q?3DramkLf1iHmAEUVYMKfWKasEwcIpGe6MxuZkFKHwta33QrDm87Zg/tNadUE?=
 =?us-ascii?Q?2Lii+3COEPwWM/G9wNwcry7BMmQny3MscayiPLQgCP/69uXwFDDDq5rvLT2a?=
 =?us-ascii?Q?Yho1JOTuwYnaI+vLkzbidL2XAj/cf6AHjD461FGYWV7iLmQxofRM5TTyNiA4?=
 =?us-ascii?Q?hCl5c8cBUGritoMWED3hxR4XaXjh45/kXVLvPkAEvoxMHqJ3mOPydK+20oBE?=
 =?us-ascii?Q?yim+HCr0grxnSEz5KhAsI/tzKU2XQ7/v0rEGEIhkaoMr5SHDXRF2NDD5WVnK?=
X-MS-Exchange-AntiSpam-MessageData-1: DPbRT/bv4Q6rIZKn1WbETJ2Wr4q+OhOPYdg=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0628de58-6eda-430a-c1bc-08da51cbeace
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 08:15:48.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvypx128Dr9BxgtxPUsug53yKWMA13UEW8LMniZqQl8+yr7+zBjPE4iNCFGf6QVSjhQRbDFqY/s6bOMlePeUl3hGp876YzgerqO8d2K2qjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2460
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 9386ebccfc59 ("nfp: update nfp_X logging definitions")

The reverted patch was intended to improve logging for the NFP driver by
including information such as the source code file and number in log
messages.

Unfortunately our experience is that this has not improved things as
we had hoped. The resulting logs are inconsistent with (most) other
kernel log messages. And rely on knowledge of the source code version
in order for the extra information to be useful.

Thus, revert the change.

We acknowledge that Jakub Kicinski <kuba@kernel.org> foresaw this problem.

Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfpcore/nfp_cpp.h  | 26 +++++--------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
index ddb34bfb9bef..3d379e937184 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
@@ -13,36 +13,22 @@
 #include <linux/ctype.h>
 #include <linux/types.h>
 #include <linux/sizes.h>
-#include <linux/stringify.h>
 
 #ifndef NFP_SUBSYS
 #define NFP_SUBSYS "nfp"
 #endif
 
-#define string_format(x) __FILE__ ":" __stringify(__LINE__) ": " x
-
-#define __nfp_err(cpp, fmt, args...) \
-	dev_err(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define __nfp_warn(cpp, fmt, args...) \
-	dev_warn(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define __nfp_info(cpp, fmt, args...) \
-	dev_info(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define __nfp_dbg(cpp, fmt, args...) \
-	dev_dbg(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define __nfp_printk(level, cpp, fmt, args...) \
-	dev_printk(level, nfp_cpp_device(cpp)->parent,  \
-		   NFP_SUBSYS ": " fmt, ## args)
-
 #define nfp_err(cpp, fmt, args...) \
-	__nfp_err(cpp, string_format(fmt), ## args)
+	dev_err(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
 #define nfp_warn(cpp, fmt, args...) \
-	__nfp_warn(cpp, string_format(fmt), ## args)
+	dev_warn(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
 #define nfp_info(cpp, fmt, args...) \
-	__nfp_info(cpp, string_format(fmt), ## args)
+	dev_info(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
 #define nfp_dbg(cpp, fmt, args...) \
-	__nfp_dbg(cpp, string_format(fmt), ## args)
+	dev_dbg(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
 #define nfp_printk(level, cpp, fmt, args...) \
-	__nfp_printk(level, cpp, string_format(fmt), ## args)
+	dev_printk(level, nfp_cpp_device(cpp)->parent,	\
+		   NFP_SUBSYS ": " fmt,	## args)
 
 #define PCI_64BIT_BAR_COUNT             3
 
-- 
2.30.2

