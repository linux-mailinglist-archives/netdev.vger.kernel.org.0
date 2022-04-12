Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C625A4FE4B5
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbiDLP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiDLP2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:28:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B7C1CFCF
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:26:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBYSBRZNFGBFZZbxXpN+UTYf8caLNpVA1XiXk7ncv3TLEQZODbp5BlTAWjwSZ+CS/O6IxNaqXaaJ3o+/0fhhkI7KQcrancpCxth9sbY+WJmQ06fY01ersxfB2W3nu1NxdMchXkzjDNJBF42XvHo1HhckETgx1QKXUaZB+vjGQpQZUVl7gz0j0TN0KnrJ9DXU7bi8wjQE/ISqEB7mVNEa5lfsp2rj/ctx5B9UqKoWtJVoxA+rzWu4QXXmOtWZ61rybu4WqNwiVbK+70uuAHpkR9/Ag89j3dTkyrStJrRme0OJE6B4kq8yAo8HY05p+qDCCXvkx0Ka8Ic0NWrZAfjL3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFWAFki9nfHwTWSqjTTggSMIRCKhnNefIFJUjr+/cdI=;
 b=GQE0vLIgVIu3Xw8qZmHausDO3ci79WbGDTZT0vDyMUKT0wyVmOOe5d4Zn2Bh0zUy4TIlYjqY5XYGa12Ja/L4EL2Ob3W8Yon8Vfs7/GEZL7Qxl3mMsz8r268t2MklrjV/TppAjc7GcPxYqu/HLHBONiVb2Uf/iHuzbqt7UnW+ES+hi+ankQJCATyU5Vw4sY5f4IIeWPArLN8/JEZa8Q3l5EojjlVdb7AZpXIyWAqTUKu7dqIX38IqP//9T9GH4j3cB5PdPQHd+vny5FdnexUQ5/qyzbeJDrvf0zIjLdms/cTf+QfnpdlSr/D1fJnXB18sXBzk5PBet2bhpjmFEV626Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFWAFki9nfHwTWSqjTTggSMIRCKhnNefIFJUjr+/cdI=;
 b=MFYo6HpgMiqKyhiKW05AdPEaa8CUiZxEVpvaPvrYdaueB+HEfEyqpUdEczvDxZAIFYIVyaQVh1cd6My1xgzhAdjAZ1AiQJtaA0APzmOPcoRWvP+Bmo+t2+KaFgl/IcIXcgehNcHwy7VibpsGkjycf+71PgzqrQ6IgvhJ1oQYFK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5663.namprd13.prod.outlook.com (2603:10b6:806:21e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.17; Tue, 12 Apr
 2022 15:26:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8c8a:96b7:33a6:4da5]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8c8a:96b7:33a6:4da5%7]) with mapi id 15.20.5164.020; Tue, 12 Apr 2022
 15:26:12 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Dylan Muller <dylan.muller@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: update nfp_X logging definitions
Date:   Tue, 12 Apr 2022 17:26:00 +0200
Message-Id: <20220412152600.190317-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0019.eurprd07.prod.outlook.com
 (2603:10a6:205:1::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b147f0e-414a-4f0e-6bd8-08da1c98c706
X-MS-TrafficTypeDiagnostic: SN4PR13MB5663:EE_
X-Microsoft-Antispam-PRVS: <SN4PR13MB566366FF7FB9AB3B88CB5628E8ED9@SN4PR13MB5663.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CU9ZGNRdBPYqSkCHJuBvKFR6RNb+ivqsMVJEBwVyjzSr2hVl3VXmAz/KJU1P4h+UbH4o2TEEo2I1znYftbw0tFyU4ws2I8YpcQWgx2+4/3cd/ry0bUnM6oN0b/vv9htGWsoymc6hyvl/OVQVrt5K/y12NUT5D9e+qeW6eodw7H+J7VnbFYhSROeYaOc8Qi0w4DZPgGbsGHBm4hbQoC+dga30B+MCBBrbJWTlEkMdOAG1tphte6pG+fA4txf4XyHSYDpV9NWF9dvEZ2fmSoYLCWJH9jqvoKNE2wG0YGfR18XGbnLLtO3g8BeoKey+uKo2Te2aYlDiWBlVWobQhl7RpAKa+c5jNbXJg6N/tzaPchQE1riZZ4jtmge9EuU2Gv+DchT/NsGQ+GL1S1JjPgVg9futnlW0BB4bNZUrE8c8EKpJNtpENoPdPSxWwv/Mbv4fkkpqH94r7mOtSiMa8sO+o2jknVqTBW6xYSk6G5cDfm/aTfjNJMXjgGssay0OGGlv48vHlWwpKaY2S5R4fRq7vA9sZBO557E3qYBRdWd6DwxH3zsZDHSHRiFd1pAK80ZCFGZe0vGw8qnb+Q5MQeEWE/uFQfWRWHuuR71YHoDTB7B+HXD3W1iOrVVtKWkj6rOOucjYvSBhfIW3dOtkyAlh2GazgQqzZchKJ4cDKR8rQ9pQD2Hu1QcyZFsDyOmIl2T6EuGF8rFf2SAE2SioJU0pZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(346002)(376002)(39830400003)(136003)(83380400001)(86362001)(508600001)(2906002)(5660300002)(54906003)(1076003)(36756003)(6486002)(15650500001)(38100700002)(8936002)(6512007)(52116002)(6506007)(316002)(110136005)(66556008)(66946007)(66476007)(186003)(44832011)(2616005)(6666004)(8676002)(107886003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2QFMWh30nQ124G7QpFfBF3JQj2ZRugGsjdnV++OU7k+7U6bQ8Y12ukA4mIM?=
 =?us-ascii?Q?sLGnfcsS3mxKUgcN4CJ+HFrvK3eLJlc1qjuw9g5GqTa/3UdMYx2u1I7yU2PX?=
 =?us-ascii?Q?ce5D1y42u96kxzYeVpUImJRk31Fgb+qDAOs+yfk6JXa+gDoVAI2oTpFo/1Wi?=
 =?us-ascii?Q?SHKY23SUNYGsOcQxikNnREEZ5Yj5HoGN5MFV076pxfWJDwkCz6DB0d4Y8e3I?=
 =?us-ascii?Q?PnzLbN9lrYrT2CjSwxbXYQyuh6n1wrHoNIjVopRwL703QrXqhn/LtgkasLIi?=
 =?us-ascii?Q?I5KtMKniinwk4Ks+tm4jPkO2VeMsP1HN9HJ3ku5gtcMrqY4Y63ZYdon+Krvi?=
 =?us-ascii?Q?TNP+6OUEJjfdYglhwUVQMnluwmFFm74BboAtNzgeBafdm2Au4pfCqlKxWw5F?=
 =?us-ascii?Q?DOByWa1KvGPiPz6WJoR79vxiK4Ua1GwT9FaMEiQKzrs+7xu2sD7po3IkYofP?=
 =?us-ascii?Q?fx9p2w1Hczx5CxaZIvSAkWhWRRMfzoz0SfkFUn9qgqekcFN0Hu2XcN0xIJjJ?=
 =?us-ascii?Q?9c9ZWbVPVVak4++UDMY+cMTOXfB/Fvy/NxX0kAUHnWWCz6kSBmrh0SHNzAtO?=
 =?us-ascii?Q?qafTf6RLHbCjj0O1T1NhLrHaM6XXzeNKAuN/L2Pa3yHRWkzdIq7jEns6ouEh?=
 =?us-ascii?Q?ZuDtPSzhQO2kGkY+zPWBGEQFWznPzmvG01qJxRNulNNHeRN75C5APqg0FoQl?=
 =?us-ascii?Q?RqfETH+JXt4DdHhBeQrgFoN/YVZbH61O+hkCFeQEwDzSGqNNB/r4UoLg1OT8?=
 =?us-ascii?Q?Fg5dJX8sJowzlwtVFBMhC9hc/LRDCkuntNzVN4R44EIc84029ZyHXCLT7Iil?=
 =?us-ascii?Q?LB8up4eNs+cidPmexvDqBAIZMJ0objnYj2VhRhfPL+y1EvksIBhU3cp3K0gg?=
 =?us-ascii?Q?a43Jvlxyvp+EJDUe1ya4Dp/M2qklHQUL0iz46qtEer540Ghl96n5sORbSofH?=
 =?us-ascii?Q?IjnIfqXP+EDVF7JYpMB7bzJQmNx8wQrJeFM0DZ+8vuX3npCLzkLhj+3S3atg?=
 =?us-ascii?Q?hmOo5V9d+A51oQPfoKs/gGp8xrGpEfPH2bOKHl+UiOfMs1woRyiSqtUpf/0p?=
 =?us-ascii?Q?SEwGEMdcCdV1Sp+xYYo/N2ywd89D2sdlQEp+62RE6ZR9xPyM41LSeJ4r+y2b?=
 =?us-ascii?Q?hQE2d6kyzUBCPrOl/EJV2e1XP40o2uUYGwsipSbj3uv7yrC6+szcsvfJGDhY?=
 =?us-ascii?Q?vDUrI+h+ijqrTUI9RGW4W245HV3STU178DNzdyI4WB8KaJUbuO7LmAJKR6pT?=
 =?us-ascii?Q?aQqFn7sUQx7n3PavHBI8SSdUvlZSRVvZsF/YZURsKNGqzuSb/lCfoiFcFqVf?=
 =?us-ascii?Q?PD+MkPZ/4IAqIq7hdosg8n9VnVsEWwEvwn++a2OEvUeGXTEnQzZ2pUUGwm9j?=
 =?us-ascii?Q?LmgfMSg6NyEYEqk2lizdBtXrifBVY2jU0uPJ3VbYRdypG4FhZFQ1FMgLoo+D?=
 =?us-ascii?Q?/ju00QVhF9tf9uEFdGMJyQedHWifBRfba7sVSeyDyKZATpGt10lhjwhJ2mbf?=
 =?us-ascii?Q?hBHjQReTrjzM9Df5Bq1GymADJzgB/OekmNDaszpxp0yjJhLbyxJ3/YEwqikM?=
 =?us-ascii?Q?QSYhLILTFBvHzzc0eT3XKhD+hPOktHPRU8vu8FCvEbNfLNOk9ChjJxKIrhi7?=
 =?us-ascii?Q?Ed8XatNmlJBQMGd1lJqUhDia0kY8MKMFf0pLKDsEdLZO2XgA+YXC5VED9cPe?=
 =?us-ascii?Q?KyqtMc8XV7AEUP5fyYTEDo7Wg31zJb/G8wPDiMB+cbUS/QK5UuH+ZkHbJZu5?=
 =?us-ascii?Q?Ndl7FgK9k4j0gMvpnAGPgM6Ka9Tj/WKZ7tck6c7jBavmKgTXyxv6byN6vWD5?=
X-MS-Exchange-AntiSpam-MessageData-1: FqzlFbS7arbHyTH4Blmuy3VOtpHDYoXMNlQ=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b147f0e-414a-4f0e-6bd8-08da1c98c706
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 15:26:12.7289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UQleu+cT1FmMvDSOM28OM6HdsXdTEU6dB8ND4gyziDmUQuKXeZnROYqoPU7N+nBec87jPntgVJgh7rc6CLtQPKxmndWmhcGkvXIBr3nBI7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5663
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dylan Muller <dylan.muller@corigine.com>

Previously it was not possible to determine which code path was responsible
for generating a certain message after a call to the nfp_X messaging
definitions for cases of duplicate strings. We therefore modify nfp_err,
nfp_warn, nfp_info, nfp_dbg and nfp_printk to print the corresponding file
and line number where the nfp_X definition is used.

Signed-off-by: Dylan Muller <dylan.muller@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfpcore/nfp_cpp.h  | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
index 3d379e937184..ddb34bfb9bef 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h
@@ -13,22 +13,36 @@
 #include <linux/ctype.h>
 #include <linux/types.h>
 #include <linux/sizes.h>
+#include <linux/stringify.h>
 
 #ifndef NFP_SUBSYS
 #define NFP_SUBSYS "nfp"
 #endif
 
-#define nfp_err(cpp, fmt, args...) \
+#define string_format(x) __FILE__ ":" __stringify(__LINE__) ": " x
+
+#define __nfp_err(cpp, fmt, args...) \
 	dev_err(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define nfp_warn(cpp, fmt, args...) \
+#define __nfp_warn(cpp, fmt, args...) \
 	dev_warn(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define nfp_info(cpp, fmt, args...) \
+#define __nfp_info(cpp, fmt, args...) \
 	dev_info(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
-#define nfp_dbg(cpp, fmt, args...) \
+#define __nfp_dbg(cpp, fmt, args...) \
 	dev_dbg(nfp_cpp_device(cpp)->parent, NFP_SUBSYS ": " fmt, ## args)
+#define __nfp_printk(level, cpp, fmt, args...) \
+	dev_printk(level, nfp_cpp_device(cpp)->parent,  \
+		   NFP_SUBSYS ": " fmt, ## args)
+
+#define nfp_err(cpp, fmt, args...) \
+	__nfp_err(cpp, string_format(fmt), ## args)
+#define nfp_warn(cpp, fmt, args...) \
+	__nfp_warn(cpp, string_format(fmt), ## args)
+#define nfp_info(cpp, fmt, args...) \
+	__nfp_info(cpp, string_format(fmt), ## args)
+#define nfp_dbg(cpp, fmt, args...) \
+	__nfp_dbg(cpp, string_format(fmt), ## args)
 #define nfp_printk(level, cpp, fmt, args...) \
-	dev_printk(level, nfp_cpp_device(cpp)->parent,	\
-		   NFP_SUBSYS ": " fmt,	## args)
+	__nfp_printk(level, cpp, string_format(fmt), ## args)
 
 #define PCI_64BIT_BAR_COUNT             3
 
-- 
2.30.2

