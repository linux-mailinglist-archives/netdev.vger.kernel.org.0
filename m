Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD256E5F94
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjDRLQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjDRLP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:56 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE8126AD;
        Tue, 18 Apr 2023 04:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv5B7AoPqtImOlehtkpdN0UUysRp0RXYAmY8UpBMmsu19KPsEyAyASsWphLmRCIWWp4FROs8AvZsnQSN/wLqHFkr1wlJ0gowvNWxnAmPSxILgbS8uVjqBox42BLPaHH22xqXeGlGEZYrxfkuzs9IFFuVoPRq78tnlvTMRoaV+AHJMAvbgGIBFVG98kTOy29ayo44DVzcznzK9JAGYU8n5g0t5OrCijFDGtiEh4BjUW9VLaGBqL4AzLQQ/u8Sa9upGbXzOxB0x4ID3V14f8SnT0cqeInYeNGSIyU8qC1/7HyVsVzGL+JdHxgjxWEklSJIfX/jpYx+BF49IkQhDhkrJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/WbGqpZdzz7a1IaX8ZTpWons9aKUG8SCU8qFLaYAZk=;
 b=ig/yTjcb3EghKiX8SwcNs3ktMsuH9M8hjmgSnz+evxvQk/KJOoWal+z2zgoHWyFh/Rf1UfHqZB3MjNOLXbjdn/8NfSK3yggOb7vEW6cR8JRtrNeQOWGlERIAuyi5h7hjtiyWPhWIxR7sokf4Cp7rBIdNbJ8xxMUTvHy0uHU5SiWTpxE3Naq20qwGKZVIq187Y96d1cWAMuuA+4j8maZDTHfVOX3Pb7KYJcq2JYozL2apr1Zk7qCvmJHan4MPHuybS03r2hJwNZNBLZ7NScIyy/dVGLsnaw+8y0tE+VOWrAaHvWfiymw4bd5JcdUVYtkx7Ta4hUzS+hagkq4Zj59wkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/WbGqpZdzz7a1IaX8ZTpWons9aKUG8SCU8qFLaYAZk=;
 b=Q7/LfCeI9cb9eOuBc9mTXcJGuFa5cpDmKJ4eikwsdAcFplE3KKM9JPLotdVHzeVEI0I5MAp7RGZHMOSAuZ9WPnkWUEzQgB/W5GSFcYNHgpjFyHSCFTcul4g0B6tIAaC//SO0SvK9u0ulfV32DaRGDYlzg3SBqJube97aKJw0QHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:23 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 6/9] selftests: forwarding: sch_tbf_*: Add a pre-run hook
Date:   Tue, 18 Apr 2023 14:14:56 +0300
Message-Id: <20230418111459.811553-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f37e036-6e70-4036-7611-08db3ffe3456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPFwC3lhJDHCmig+8RI9Bm4q5c69JL3UpFF5mPt5A5gbc2Tsi4f9DKMn/Rl4zvEBo8odhlRLNXQy6dEa/P8hOD2YPXPwdjvCIHWdYRMcVsRWjqsRq1XCCBp4g51EpAau6MVb//Kmz9ISuuXhnBy87VQD4KSrFfi8Ode4mCjI+pvIJ7fG5Kq+ftaamNFpi3h9cNHD976llIhca3gBuuUyHQ/bOiQUoYNdC2dWBOjnxA293+6dolnBXpGEDYTWiIMQd+GCMH4iQcqvIM2nmgTA0wLpzrE+dTrVOHDiVMdZLQ8N8nVTs2dFxAYnhGOx7pHEkE4T1e8v4PyfP5WBQ8m76fqgHIul/2DYAlTpaxSHJpeYBWGg/apVTicqk2Ja10dAPBPUDwsil5COi/wq0gX4GqlQR6mbgF6EG4g7boaq4WzFk3oYIWDZsNW8GvTJTjzuXDBW6FEdV05zGOA/15I8o7sWmy5ypTzrVqOXR9UEqRe9Zy0sqJEeYtnQ5etmxAKHCR1UTkxqjgVJ7eW+Xdo3BjS2aVdUZX4gUFZIAFL2YR6baH+RDXguwrE/PpiK3wpaswN96yjFONQTaTPa72mAlxcUkFdioBlWQKRQoHArS3SuG/VwxpxwjR/gMZSBJ8dH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w/Yp7vLnaB5LbTqSC/aaNj0NbMQd4mX0cvR1lSzsGqwwTLb6yHHMLbMI+qRo?=
 =?us-ascii?Q?Hm0y2tRQePw9f7VlGf3jeiiRd31p76tivovL5JwCf0Gb/qTaAL0WRFsDXPjE?=
 =?us-ascii?Q?1D42yB50Xf9G3jARNS9HMonM2jyRlHUaFCUDfBLw/mFJA8ku6WLVpfy5sjJn?=
 =?us-ascii?Q?9t/7Vb3L/nxttEtfSbOpKHfa4hwB8qviXfcRKB4wOtKstTsve3ki4lUiXdbV?=
 =?us-ascii?Q?ft+6q+DUSz1PJx4kwcqZqA6zjrs8Vi4BL+3RcxfF8MTWDom/G6zIX0qMn9a5?=
 =?us-ascii?Q?Unpv3+AcxCYXd73nI0Xe5AMjKEUOG/Xc1Sp96UV6+RbLHr4V4SkXi+cXVQQY?=
 =?us-ascii?Q?c0DD9EK/fcno53y2C2JwAH+VkoxVPH+3RjiIRmmtiL8VPEeV/eLTrhiC+k6h?=
 =?us-ascii?Q?u6RAoqxVqHf0vEuL7qgViCKhRupXZAQt9wDosAM7NqhtklDkTTnN3bKiwxu3?=
 =?us-ascii?Q?4PdGXgg5KbF//OYwEyMRh9wNGPw3UrsDLDogQIE/QMkiIJly582kSBWMOHob?=
 =?us-ascii?Q?MlOd+dcnsBqBI3/NmUqwJvQVbnfm+Ip6OOfCSnRE9PXkSvYiOo8Ohh1cIqyq?=
 =?us-ascii?Q?svh0xJG+IRo3znyx+GtmRsGwR5bdyVo4WaYi/QNyzycX3kH1PzQ2ZMgvLqO7?=
 =?us-ascii?Q?nomj4Q6uO1ZtcRuj+6hDfBr0x48LpCUKxhBHU9zOHNrSdZeNpGrfn36pqzKk?=
 =?us-ascii?Q?j3kGxBa1vK9sntusmD1YKTlaRPm2kNcY/yAeTwJsvPTAgbT6AFWsh2nR2idF?=
 =?us-ascii?Q?/W5PuzAQLXxJyvbF6rA3r08l2ZlaPhPWugGfI1v6x1Fe2jb2xfpYxwkyFjBW?=
 =?us-ascii?Q?R6BzEBlVIk1A/vQBGq98TxqsMAPZKJjhPzAjsmiT2ZU3KgaQpkT3vOxTcE9s?=
 =?us-ascii?Q?pLhfTLoQosJfbav+TNpohlVGQKn7JrDCRCM6CvCr4jik4xkuNWfIYx1gu9Dg?=
 =?us-ascii?Q?kY5P/zBXLn4mTXjVNO4J8ycpjLRsr1ZIpGqxfHuNzwpM68aukYhsz9zsjZ/1?=
 =?us-ascii?Q?RbDZI3yZ4+4WooV3/frkQuJU9JK37HybaM/Jx0GEak8wJMs506YOhE2bDdFa?=
 =?us-ascii?Q?GPLIZcOPJCBnvcKiRgoD64qVMvGfMj7t+7EpUGDd/5JW7iQLGaGg6cIgF/ci?=
 =?us-ascii?Q?odysQDnwx7/YxvzNMR5uUH31iKhE8yddtfqFJpU4QygmDcchLrkOfXaQH+y6?=
 =?us-ascii?Q?e0wouu1QNOu555pPWTrvR3h5IfAwc4XmcrNW9FUHm+QN6mxKmzVIZI2cOBVg?=
 =?us-ascii?Q?11biHdLKLCjx7c5FzZJXyjdPDHt9A3i8fuXGsivMklq6w3L4Zzkf4+V6PfMa?=
 =?us-ascii?Q?sVd6dmDvjdP4CdH5Jom3xY1ip+1ubvPgPA8VylT4E9qneUFUDBIppXxkv6km?=
 =?us-ascii?Q?Uk32hmDB6NtQix1gdXsrCu8vfC6YwY7f2b7EL1qMKiUAdZIrhjYQBH7rf4fk?=
 =?us-ascii?Q?XtyAneZmZ/sN0ZqOw6LZ2v9C9hAP+qskA4VhSqT3bh9mTuOwp3t6mBsLNCo1?=
 =?us-ascii?Q?PMACeNkRP0sktttgYY4wTo1JTvbM9FuxpBpaZCr3RTeL4Ym5u+o1n+6g/RL5?=
 =?us-ascii?Q?Y254utTWYwxxwyLRv33B2YBGZaMLqh3cyX/DnO6phbWmOQB6OuC1Pnv5shgD?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f37e036-6e70-4036-7611-08db3ffe3456
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:23.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47JhNNU+7/t34hqu8VNdws7CCkEoGo4FZphESo3iv5M3t42EkI3oNfxkoXLC14ppMwp9Ew9bWv2ih9ayTdqHzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The driver-specific wrappers of these selftests invoke bail_on_lldpad to
make sure that LLDPAD doesn't trample the configuration. The function
bail_on_lldpad is going to move to lib.sh in the next patch. With that, it
won't be visible for the wrappers before sourcing the framework script. And
after sourcing it, it is too late: the selftest will have run by then.

One option might be to source NUM_NETIFS=0 lib.sh from the wrapper, but
even if that worked (it might, it might not), that seems cumbersome. lib.sh
is doing fair amount of stuff, and even if it works today, it does not look
particularly solid as a solution.

Instead, introduce a hook, sch_tbf_pre_hook(), that when available, gets
invoked. Move the bail to the hook.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: new patch from Petr

 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh  | 6 +++++-
 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh | 6 +++++-
 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh | 6 +++++-
 tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh | 4 ++++
 tools/testing/selftests/net/forwarding/sch_tbf_root.sh    | 4 ++++
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
index c6ce0b448bf3..b9b4cdf14ceb 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
@@ -2,7 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+
+sch_tbf_pre_hook()
+{
+	bail_on_lldpad
+}
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
index 8d245f331619..dff9810ee04f 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
@@ -2,7 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+
+sch_tbf_pre_hook()
+{
+	bail_on_lldpad
+}
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
index 013886061f15..75406bd7036e 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
@@ -2,7 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+
+sch_tbf_pre_hook()
+{
+	bail_on_lldpad
+}
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
index 75a37c189ef3..df9bcd6a811a 100644
--- a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
@@ -57,6 +57,10 @@ tbf_root_test()
 	tc qdisc del dev $swp2 root
 }
 
+if type -t sch_tbf_pre_hook >/dev/null; then
+	sch_tbf_pre_hook
+fi
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_root.sh b/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
index 72aa21ba88c7..96c997be0d03 100755
--- a/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
@@ -23,6 +23,10 @@ tbf_test()
 	tc qdisc del dev $swp2 root
 }
 
+if type -t sch_tbf_pre_hook >/dev/null; then
+	sch_tbf_pre_hook
+fi
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.34.1

