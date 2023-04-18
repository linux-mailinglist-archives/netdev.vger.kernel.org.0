Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248BA6E5F98
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjDRLQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjDRLP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:56 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0E87ED1;
        Tue, 18 Apr 2023 04:15:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKiWqHDcznDvL2KWlDuoCc9W/dcsRQLykNPrYN4whE1A5RYKjP8A+QCiOJPX4RF/YwFdbGIojLVwF93LeOuI0LxouuIjmY53PYt3v6PPheiOdzR5SObELbEKnjhHoLSrxZyqTsbTbJUlOq4wb+KEtIfQTXX0d5Smgkrp8SAfFQyBz+OTXpadWIobjktFBDKxsi2BVhQtWQHKpGb843ELI9eOmM5Cc1RLc+yC/ASTOuiErM5lyw/Sk38bqcQFetQpJ8y1GSA1mqJqnaMKkek5Oqk8QuSKc6JYcxeP7VWnhCWa4BI9EreuVq+1WtAa/ky8F8o0VVwEzsAuByHTRtG7QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNJoeWLjyVB2LWaj/CAkCgVQequpiOHssTo2XTeNbkU=;
 b=mlY2IXqFazMO+1KbN5ldQ/NSH7iZZ+ME7tigEUtO99rTzGh7YDumOhYQyHc41n1/johevuquX857F/ybkm5jeK7vWbeLHy6ccM0/SghLsrfmD76IbD8aVuiSSMGUNy62iJO7ZtDsJ3UlpmvzczqY7K1/Hu0wwhXJJZaoKh3z7CgxYnDaZ2evcqFKEs2x6CUp25Z5bU1oShgYYb2ok3zfLNZ2YJnV3DeXd03cgzvfodKnaTGjEb/Rpa1niZCHF+wta5Qgx64OUYT4JYQ0sruTL1PMzRvrR3b4Z+bQuczlU43UvTq5eZrT47VP4jfBNuCJgCy/pQfMOIgbaANLGcadPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNJoeWLjyVB2LWaj/CAkCgVQequpiOHssTo2XTeNbkU=;
 b=IxtuU/kkUhDeLHSzuCEzkfO3aJVxazESK5FjSTkQ/KvcxkTxLhUPSv8ggBROSnYmicFKRxt0hIs2ynSgW3a9kZfKn5c3q6PFNJTfzIhJUlaY4g16Dbj9Er2UKLj7Lizdrfw3+UbVdVCxrwbJpk+Vzfb4IsODqYFZOehURWK5OTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:26 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:26 +0000
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
Subject: [PATCH v2 net-next 8/9] selftests: forwarding: introduce helper for standard ethtool counters
Date:   Tue, 18 Apr 2023 14:14:58 +0300
Message-Id: <20230418111459.811553-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8155f5dc-4a08-4e57-3759-08db3ffe35e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zv1+RJTdlaMt84O1ADRtfLJSXFVeMyXJa7sH8+KxETEDMdgcTomCRQV2ZlbGvWJWGDmmygKUu3RH8oldU2HBahZMG2JmCp/uKyGlOaOHsB8ycKJTfMEkK6fBNZl30lgsoIaYkMU8KB8lkf8BMDERSr/FEo/BrATcbD/h8Z1nitMgb2Ii1uajdf4aBNT9cBWEF98KX44mlY+SRTBniGJ2/KnAulHplEdxxV+C+gZocGrJVigU0AbEOgiQUj0Z9/IC/iDLArg3aftlWXYNZ/bYHjuuSxCElsaXAoGtKodFfFarbi/jceb9XSS5TUS24eZ3WUEibSdV6QvQNSbEA/EliKS8eLDzhZkeKbfTnUeDHVHoJPCVinugg/75PbrHR5lzvu6VCk6OFW3u+LF6dCoMgAFrzGyEg7TpHFQABl7hY5nxIl9rCs0gIhn6hWYV3pjl51YWga0h46p9hNZuV7EXlIKvFnumrR6+ZhwTXxFd1R0xwrhL1XRZWrp0rMUSVrV3NBz7xSuhtvrLeugs5aSE8zuastCN3mk8C2aUZWD7oy2aCzhic68A/z8B8Y5jqBP5GBYrJZRlFF3cclZXmkiWG6lzybDJ+H5HUhPWAPFZFRn37Rqyiwgcjm+iqARtE8Ye
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dc7sx8EWNVzq27W11WWtliuWmWgHwS04w8zcQSMewuzlq1xShZWu2dFkdAFQ?=
 =?us-ascii?Q?nLZe2DdoXpnzGbwL4v3tJlMu9uFATL/Vza4LnYAzCDsMvmYrH/CEey8sTB9D?=
 =?us-ascii?Q?4nUTx09k2qlACPP22X/a/KgtkgKeGKnilVRAqovEVyHehqWe0tC+hFPYfZQP?=
 =?us-ascii?Q?dQV+q+JRrY+nEkP3gXgo6Eqqd0jlrOZSj7Gjy4jhh8j04uJzsKobTrsN5M5Q?=
 =?us-ascii?Q?XBjq55hUd2mEbGkZ6pTZRAMHNUUqcO/PCi71HyGxylJLZuxXKh5BcZqNxf2F?=
 =?us-ascii?Q?BbTJXakm3Fy7qVw0t5HTKM4u3vC3XgQez1hRsgY0te6qxWzTt5IozqpJaH24?=
 =?us-ascii?Q?hd7jolwN6bowlXUsqjC6Fp+kXRo32bRMZx6XX7M8PvO+dSBtUogOupQ10/ez?=
 =?us-ascii?Q?KxYCxY+MAHWK6H/pUkEgPw+fdTUD+UzkXuYfhz/4udwGsrDdofu0ukcvTPHa?=
 =?us-ascii?Q?T/qLiBJRhUutBbh6B++R6emEbArxmMTI/zSqT2NDHWPtehcgRIAvZz0BRDpr?=
 =?us-ascii?Q?+cB1YM0Z/N41560rb8DdFcaJMF2fo2+LSHTeq39cri7TV32TRoR5SSpsWhSv?=
 =?us-ascii?Q?yFXMIddXwTCFd9z76QsuVw929BbndLbHQCkherkpmf4Ge8HwEE1wzeqdy35W?=
 =?us-ascii?Q?pg42viz6TlEAgubwuE5fbGSuIVTs8YeLWisgVjjDTU1wVk0U2w6iFeZcG1FP?=
 =?us-ascii?Q?W+7o6gdJYQaRpsESndO/Qn7zAZADh583gj2G+Z2DoF8vtdhi9aFjmrg5BuaQ?=
 =?us-ascii?Q?cEBFMfPKSzI3qxNw3/HNd2hN3bEf6azXRiWb83VxQtLkn4LqMYZxR+Exylen?=
 =?us-ascii?Q?oQ8rPcdriTWXvZ4hyS8n4NQL+1MM8x+EjHy16K4hZ9SyJcgacRwgHNwdDsao?=
 =?us-ascii?Q?rwQp8lFGONfnhYe23iIFgGhv7NPi47rkiThzWrYY3pfczlfMGifVKSkjFlXS?=
 =?us-ascii?Q?1JTG38C9QBncssaK12ZzicQFOjFojr4kwqco0U0B02gTEUrhDOHrjW+cGioc?=
 =?us-ascii?Q?il8GBvdZstTQoUWgLHgo0DEoqB8zaRdT/fHhRWW9B2groykKH0v/ctnoVGFR?=
 =?us-ascii?Q?BSrflkxiYMbMKGqRahehRX6k4Jdy4v9pmPz43mzVYDNR8Ee/nT7Y19v/r0T3?=
 =?us-ascii?Q?rMKIXyvGfVVIXHsBuQ0JH2H9/m7CInupxXkaYWWL9j51/XK6Ikzn9J7ppbWf?=
 =?us-ascii?Q?G7w+vegWrmcI7ffygsfAV928WHDTxNR9jgt3r7tMlyT5YTb1RLfjQA5UZT2K?=
 =?us-ascii?Q?vcUb8cU1gv9XMiyIjk5fT0xwLK8vHzSA7A41xdAfPyW17nyAECbT2sl1ruyy?=
 =?us-ascii?Q?klc3u5Zf9FLj9d4ksuPgHfX7KcKMnjcTn5XLtJ7ygRFDo4QfG3rqVYeWPHWa?=
 =?us-ascii?Q?RNKxTP1whBU+AqmpV67AT6qE2F5PmNd0gDqDnqrNVilfauXB/+VWDH50f4nI?=
 =?us-ascii?Q?Mm3w863YslyteeaOJpLqkrd+4xnYU4UAgxJtqGkWEnhrtpSLHOVmNftkjmdf?=
 =?us-ascii?Q?+oLYHfC3eQibKutRM2kJxgZ3ZolKn+1qwH3X3u9e9mHEd5xVnYfrMN6BZ5W+?=
 =?us-ascii?Q?V5qOafUllIz90pWDaqdFSW9CMkTbdBLFJcgy7q42DxuSGcz/1bfl2d3EbWgx?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8155f5dc-4a08-4e57-3759-08db3ffe35e2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:26.2991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIGkp3fhnqsnS4TwdmxDV+4fmJY+QKAzkI64e8W2tXKqVOFSYHD2dgNgjOYLouvEL+jTUp2KAYIRZ/g/jhEgSQ==
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

Counters for the MAC Merge layer and preemptible MAC have standardized
so far on using structured ethtool stats as opposed to the driver
specific names and meanings.

Benefit from that rare opportunity and introduce a helper to lib.sh for
querying standardized counters, in the hope that these will take off for
other uses as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 tools/testing/selftests/net/forwarding/lib.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index efd48e1cadd2..36e47c9d7cca 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -787,6 +787,17 @@ ethtool_stats_get()
 	ethtool -S $dev | grep "^ *$stat:" | head -n 1 | cut -d: -f2
 }
 
+ethtool_std_stats_get()
+{
+	local dev=$1; shift
+	local grp=$1; shift
+	local name=$1; shift
+	local src=$1; shift
+
+	ethtool --json -S $dev --groups $grp -- --src $src | \
+		jq '.[]."'"$grp"'"."'$name'"'
+}
+
 qdisc_stats_get()
 {
 	local dev=$1; shift
-- 
2.34.1

