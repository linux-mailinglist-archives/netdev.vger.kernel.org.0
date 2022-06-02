Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A22653B319
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 07:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiFBFgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 01:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiFBFgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 01:36:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5F1D52
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 22:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwTuliza7iNiHmO9jasleHSzUa7GANip4FS/GyVqvaJLn3sCvMHU1PQmMQaFi9/NK+Ss99gTspjOFAuVPpO47I4KOGX9esMtkloMHiGgqysIsnr60Q62xaV/dulyjXCyPOW+6VTamO57aBHBwNAREqTkZYngXAvhXLgUPUEyYChWHpQtD9DOJA6eNB3AgDBSxHcJEArurlO9h0b/QsVz39UTEQa51apblCg7lakoCRVNwIPjkL/pkVB7nDSEeRjb7mxXuUSm4R0aPcSGgdm12evGHETaogwC/V4bMc0vqT+YR+QBd/AT/53LGKVn/efS6Fx29gj/EY3SzU5HpG+QlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cGmyHujEAkVe3dxXl+DoKdC/BVh88J25AvWZRvCeJw=;
 b=MwlxzmgmglAJ3+bUrMWZgBm4KHCeoFZ7xd26RuXT/GM+aeTORszxVLYp+hiz6pb/HjmyavnQjvhtDtLxIhmGjGivmb9WAMmcrsd8uazDEcqI/cJsTjXZox3CaMrpoO4pNS/EjmNWKrvsmGb6wl60vgfRIvKtrFJBHstWgqHrlrR7W6eIslEbtS9VkRmlRLtpWNhuZj5FGOiC1K8X9zeeHUP1uk2xSIpDz5yuACM5SLqSW/9YU454xSE9NBzlagUV8xdaid1pIx6QjVZGkugrap3+zLDpQIIBoGwDbVUtluv7H/wCwAD5nWPKyYdP9wQTIH3kl/9Y5TXuU9VcoWoLrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cGmyHujEAkVe3dxXl+DoKdC/BVh88J25AvWZRvCeJw=;
 b=bcWF+VNpDIwxXb0lOOZ54knaT+k2SdSl+DYV/G3DfJA35iM8ahFkGdD06by3wUXg9DMCBg59befVLsv7mYabkQ4tdWPCyS2SAdqPJG+Cx/mU+bzFp8VK0vwwamz0gajuepuvcaJ7AIoefrl1JtRuzX8n3r0yG0jh1iz4Q9Kttro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB2987.namprd13.prod.outlook.com (2603:10b6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 2 Jun 2022 05:36:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%7]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 05:36:43 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH ethtool] ethtool: fec: Change the prompt string to adapt to current situations
Date:   Thu,  2 Jun 2022 07:36:26 +0200
Message-Id: <20220602053626.62512-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdfa4ef7-5188-4e06-7e35-08da4459e002
X-MS-TrafficTypeDiagnostic: DM6PR13MB2987:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB298706F2A74D69F12F670CFEE8DE9@DM6PR13MB2987.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3XXu0uz+4CIKTZO8SUXDPS+hiS9Ja0Zwv+NE6n6lLObmkEJyrzmyn49eQ2j5KEvthQC7bQarJqg63Z3w20/V/hkQu5xx4xoXm67Y1qR9gWDfdsyIuGt2H7SGCoEQALqOjMd2yPvtHI6zayr/04ffQjfJp/fJl6LxS01ZzC+l5RQ3VjwQ5s73KZc6cXvlgf42vJySZF9HVHOYcTSsMdqJgJCWH6bgfxa6ff6SVYJpFIUQQ0mKPRk+K71BIFZ8t+vR1lEjcwtoAeWW+RAJCn6kc7A3t7Xijb9Z5mukx9o2njXoPXDznbJULGabKXet7YiDEwG21F11Kl+wAbq3JprePnA/D6mSoZkTyb0rut4QPzincLunbuVOBQSnFF53LDE6aXgGkPZVsD+SRtWTYcfq3Y0kXs+Z4VK1UsF95muogLFidqnADnsTvoifxyDFpgSd0silXT60h/NyROMkKM7G4zrW2wkN04qnzfXM/YzFj8PwFQzdhf8GTO3vjKT/VY5J8NnWqxDC+JF/95c8IXxNxyXebHl/xOy+QqUulApcm3Ss79X98Jl87Bx3cfIpFcOjLzEIquRqiw/GZwTqbynUUyphikzmFvo1LL7u2FebOFHHO8O7DuzoWZlC5isRRjYz2UgLmtDjMUV/e41aJYz+MO9Axi40wPJVNFsIVJwNpa8hUZtKtp9bPtEO31dtjXVNQN2sqjiBUUXHboU1gm7yFxxkqNjyykJLfwAlY2bUp3MBjsm2Vd0S48DbfMHqqC1x99ah7hOaOm7MpitUo5jtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(366004)(346002)(396003)(39840400004)(136003)(38100700002)(186003)(6512007)(5660300002)(52116002)(8936002)(508600001)(2906002)(966005)(6486002)(44832011)(36756003)(6506007)(6666004)(54906003)(6916009)(83380400001)(4326008)(1076003)(316002)(41300700001)(66946007)(86362001)(2616005)(66556008)(66476007)(8676002)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sz+DQzKiKzX4eL1A2YgsVxW7lGWmFX4j4ugrSBgCqdxj5D0KIZ4dsVQ3iTpb?=
 =?us-ascii?Q?m/D8n6MJ788jTEhkB4TwewElEfxxgsoE/zsGDmsF8s6PoPKCCwMHXrK7MPQl?=
 =?us-ascii?Q?qDUxx0pHvEYb++GFYkrRcjV7h3NrSCmZkXN8AS1enZKjTlEzdBwmktKEb0B1?=
 =?us-ascii?Q?RJ6HjQenB8N0P6Ewet0AXvm2pWUQypeL65IgQSGlKWyu8pKE/9i67AlMkF8F?=
 =?us-ascii?Q?f04cBftH7YT3S/8zRn19aDV/ZgdQJ3J6lFQCYQo+jGZRmWH8skXj0fq01kKl?=
 =?us-ascii?Q?VytuxMqXF+9TobOQyyuzRPXnUb2FcIi7P5+U+Xkp1gj1H5XvIh85jhLGKC0H?=
 =?us-ascii?Q?9IqavcPclVoPJtaZoCkCDwziSFiLwWNUEhDfwpkmgyEtzSRasmDztNHCAyRd?=
 =?us-ascii?Q?p+9XlcJf9GSi2ZRBJK+3as7BDL4G6qmSyqjRAvka6AdIP1jqFeWFYMQtErBR?=
 =?us-ascii?Q?rS/3oqLZrlcn/p0idR0UQclu/qpfjk2bcfDiXHbMw2wApedIRj93csM64R2F?=
 =?us-ascii?Q?xt7aFQy+sgyWbeiKEguQSHV4ETKcSXyo0j17fQCB6E8c+cnLf+r3Zf7RsnY5?=
 =?us-ascii?Q?ybUFoyi7UnFcN5X2LragcsJuWCiAeb4aETe6AZ3qtAftzF6ENDLqE59lwjLS?=
 =?us-ascii?Q?Nc4jVKNRj2WPCDB61QsU3+sr6o9YP9M9EE52XMsosBogwjxy7/v/wUqVRaGL?=
 =?us-ascii?Q?tQRnSRfZI4yBogntdWpkVDUf1F9VDSv24fkuLZy5IjCcu7bMZcpN+TfhiIrP?=
 =?us-ascii?Q?jZ79xw3uqXYFUXf0l3AYn/nXtQHCLKsTXLB04jqnzs2LlnB9qu5G0IsbBd+b?=
 =?us-ascii?Q?A5LWALaFtXP1HPLC97Igl3MP1nHn5JSG21k2cvt0rrSy5/rKn/sMKn0+h/sZ?=
 =?us-ascii?Q?Coho3kNKcyWDQz/8Z9ooZ0EZB2BtNe5nef1rdvMS7W/8ZUASxYdbqd5/oq9r?=
 =?us-ascii?Q?poOqBLhjfNMlCJcCqET3iP0LTRjfDY61x0RXdD5Qblz4cI+d9m3iXg5BlvJ4?=
 =?us-ascii?Q?8VKnpF27ylh2YzwOUz0xT99Xpmj5f2bn8uK1cclXzTou/OPDNnWjCdxg+MNj?=
 =?us-ascii?Q?Hm5Lewwe0Xlxd+R4zeG7EvmoIS2iH0WMRl2HTccBXrWl5owh2tR1C4Pa9xmt?=
 =?us-ascii?Q?8yKfj3jRhsPiyOWjaeIvPgQMFz+ltvJE4YP1e9mH4JnRKgLd6JddQR+zYnFc?=
 =?us-ascii?Q?zvdq9VDPiiWPiXAbgSvnDqD+bAouiFL2zLj2TlgPcppstxZ7Q95k/sqwIdvk?=
 =?us-ascii?Q?fwtvzXxsbleEbYT7E06Tne+H9qNdW0l26w53YaA3A86JFbcNQwpAufixzNb9?=
 =?us-ascii?Q?AB5hiyPlmyfSWuQEoW4CqoCP0vG+wtmRtwCYq/GIhGoEHpzdPs9Wde/U45VG?=
 =?us-ascii?Q?WIUoa6/0EenMCasWssBPcI4CHa+leCvgGnArujsbQP3zU+Zvh5Azk5+TC49P?=
 =?us-ascii?Q?oAlZsfodkM+NhPzFhsrG66VVbpNGwKIxUN2RBh1BpJauF3Ae8VkH7XaiIM/N?=
 =?us-ascii?Q?AgI1o7WNIOcQv33Q8A+QVHkpgGuFkU0jjHuCF+eNS8uADLpJ0t4wUsQDTshE?=
 =?us-ascii?Q?J7YEgd1W0SKqlrGxOlwaCzItmLcvxLdAokwKjb5PXw/T7zt7pJTgi0Nx0mmy?=
 =?us-ascii?Q?5ZAupK5dnqw09Aa9LffPJV+0Oo2nFIM6AfEurXqkFLDmFsOrsxIzfKlbxkb5?=
 =?us-ascii?Q?cKyeWaiqwIcKLGStiNTb5GJblzTqF1a6Mzw8F/rlyc3E6f6QqfOgico+BhhV?=
 =?us-ascii?Q?IyvZBeL0VlufWsNwUvz5qEXALC0Pcu4mXeqbPRfiu/dXsJRXRM4Lf+6VY94F?=
X-MS-Exchange-AntiSpam-MessageData-1: 2Ss6lL/g2mtdYvMs/QMGJ8BdPckGvigybro=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfa4ef7-5188-4e06-7e35-08da4459e002
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 05:36:42.8946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7gECqH2m3MwfhxStnyNQiMUF1j8S8imTTtvxsNsyljrplDhnvn7gbXN9vvDcwXXghTWLZgeNIaWQamFhixhBEm85GpyfUai/qtCTKrZToY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2987
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Majority upstream drivers uses `Configured FEC encodings` to report
supported modes. At which point it is better to change the text in
ethtool user space that changes the meaning of the field, which is
better to suit for the current situations.

So changing `Configured FEC encodings` to `Supported/Configured FEC
encodings` to adapt to both implementations.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---

This patch resulted from a discussion on netdev regarding
updating the behaviour of the NFP driver. It was concluded in
that thread that it would be better to update the ethtool documentation
to reflect current implementations of the feature.

Ref: [PATCH net] nfp: correct the output of `ethtool --show-fec <intf>`
     https://lore.kernel.org/netdev/20220530084842.21258-1-simon.horman@corigine.com/
---
 ethtool.c     | 2 +-
 netlink/fec.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 277253090245..8654f70de03b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5567,7 +5567,7 @@ static int do_gfec(struct cmd_context *ctx)
 	}
 
 	fprintf(stdout, "FEC parameters for %s:\n", ctx->devname);
-	fprintf(stdout, "Configured FEC encodings:");
+	fprintf(stdout, "Supported/Configured FEC encodings:");
 	dump_fec(feccmd.fec);
 	fprintf(stdout, "\n");
 
diff --git a/netlink/fec.c b/netlink/fec.c
index f2659199c157..1762ae349ca6 100644
--- a/netlink/fec.c
+++ b/netlink/fec.c
@@ -153,7 +153,7 @@ int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	print_string(PRINT_ANY, "ifname", "FEC parameters for %s:\n",
 		     nlctx->devname);
 
-	open_json_array("config", "Configured FEC encodings:");
+	open_json_array("support/config", "Supported/Configured FEC encodings:");
 	fa = tb[ETHTOOL_A_FEC_AUTO] && mnl_attr_get_u8(tb[ETHTOOL_A_FEC_AUTO]);
 	if (fa)
 		print_string(PRINT_ANY, NULL, " %s", "Auto");
-- 
2.30.2

