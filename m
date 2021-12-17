Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8F5478D99
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbhLQOWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:22 -0500
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com ([104.47.70.105]:16746
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237125AbhLQOWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kO9tWuQGstERlS5MnhIc16rp6dvSfujaUuuDPlxcKu7pfeAZSicSTcXPBUW1WuAp2H3FSiFELX7R9AfcqeFLclKWwlcLhCp4rr+yCb4CyJ7+1018iOCOEeoy5H+ZiftCDBaeI76TbyF25oyi8Gnjnio8D81B/gJqeSdMDmhrb4YjqsQm/K5RHoPXw4VuetbPNf8GXcAK78f8eHQQLbFP1SblGXvYBTK35IjKJRffcw1Lc46UeMIVxMyjB3XsLlKgYtJQNbC7gIYlDYwYVvpqIt57Jyao2L4FTc6ZkbVXb6DSyONs9W/RPRW5+zeklbOJrsahNcPc7hzxdG96IqILiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hs+dKXZZSvKbfLQWptjH8Rwe19bdXbG1jYOuLoqdAlU=;
 b=UekPM0jjh+S5Ap3pY0WazDaCK2u9yVble6r3T+8At3Rhb63mS5ugMckHZ39TlY9h8r3bobIY32H1r6WHFCenDjNE61CkXL440uJw5/C2ig7A0MLadFM/gRC2h7H1So42+v8gOtjKKDWaboB3qlP0PmPl2bsNj9KNtd4WEMHtTh+cmf40fwzD83pNamOFwIVBggQve5R9bINQtGroDxT337MND5S17pJxITO1gufgqAE/Gtdqaz8dkKzFL2gYz9VDvYjxvbLdZQda/hcYRZYTb+P6W6CTnX7C/AR82PlTNgzfUbX4avB/0cUc7OjNE2QA+g0dqCgeRWT6lgXq+LnElg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hs+dKXZZSvKbfLQWptjH8Rwe19bdXbG1jYOuLoqdAlU=;
 b=qFKxl9s/eKMrMWTxmMCrtTFr7qHGddfKM96KR13D7kpftgJ5bPNMOovyhWouUGY2thFGZlH6ttlABx7TibZB341zEoAFBYpNSMbugC3NnesNFNarEYQoGQS8ievn9ElqOlkvpbxCzuTk7l3enBEOJvXc+7FKL264aTDkmBKua2w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5469.namprd13.prod.outlook.com (2603:10b6:510:142::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v7 net-next 02/12] flow_offload: reject to offload tc actions in offload drivers
Date:   Fri, 17 Dec 2021 15:21:40 +0100
Message-Id: <20211217142150.17838-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a189f3f4-9de9-4e70-051c-08d9c168a089
X-MS-TrafficTypeDiagnostic: PH0PR13MB5469:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54694E7A80B9BD2D50BCBCD1E8789@PH0PR13MB5469.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NNJnrvcSL0FB4Foe5XdKEK+IFQyIq3Mm8xKI0y6Nse+2QL1ObVERIuXU7eUbyHxJby6/NUbPEXiBV7EC1H6BEJm9L+8yS6yL5WiaeG4vWC2uv4rteoircZkS2ZLwckon4v6gy5tCevf48ABNsdGJwwBepO07Dk68cPKEvRnl6XifA3xPmXCTCifcSieU+EUt6c4N1N7lK/mMTLuevKIS1cRGN3f4O764k/9qnUSD+o+c5HMwPpV8N0PbIJDF/iikNxfVOagu8MCJE+SrGcyJgRQOzpgTba+KvSxCwAepX7bp0mdq0A96wkJfNHGpFg0DDTKDraSu4b+IRsaO9IZoxOviCuuf3zwA+rONd7ylvTskYK0XL1Z/q9c8tskixXuXlenS6K/lfTtVpS3A1rTVtbT2sJmAMZ+k4c0UwsvfEYOjqF61gjUa6e1hfBUPW+EhOE74Spvyqva4v/dG7zYTxLfahEHjzfALnZZVdAbyideRthgkw3iKQwDRQeXcbNjAadqEX+ph2GRPxYmc5g0BJIjpHqO4Nkc2+3pdAE0tFQ449PEMYyWDEM8ycffzY3itcbHxEHgPSL0ZQRQbDJrj4YA3ZtY1DIysHDDRsn6pUGGSh5Ci85LdnXI4Vy2A3nBs772brn7Mdn6bXIYUXhV11mBq/y2elFNo8MfL6FfUEmkZ8nAVNfTuJITGpTV+gkjIvOg8tsVzlMIGXrJfJFPPLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(376002)(136003)(346002)(396003)(7416002)(5660300002)(83380400001)(36756003)(6666004)(186003)(44832011)(1076003)(107886003)(6506007)(2906002)(6512007)(6486002)(52116002)(66476007)(66556008)(4326008)(38100700002)(66946007)(54906003)(110136005)(508600001)(8936002)(86362001)(316002)(8676002)(2616005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Jg6vAwX7MDhfymcbMB7P+nftmoVvmfHdbnYeeOtSyxA65ez6iIHXrpr6eSS?=
 =?us-ascii?Q?UwnNawu5SwUkPtJwEK9EZgzp7dI41WGbizCscC6ITxroTCopIXWb58EmuLmD?=
 =?us-ascii?Q?LJpRQwMSmsWppWeoO35fqCGiFhrlX+5nAC0ry2OzDMumQUjuukEct3nePHWH?=
 =?us-ascii?Q?bw3pELHmfCuT/n8JXplQzkeUeEtfl6lTQhI9b25A4HaYo/qmLSPkgyU/cBTE?=
 =?us-ascii?Q?FEYK3tTvyRUJLm9F+Y+7P0qGRWWUh3n2kVEBBEqAh6u9O/AUq8RScG2jDXJY?=
 =?us-ascii?Q?MtRRwBVSej2eSQOL7X65JAfqV3oYp0/EP4UWn7ZPB1L/J4XzXeDueMmdu+re?=
 =?us-ascii?Q?nKELfKvJvloMXcPtwIhgsbIC00W041DDeAeoe2HVBo2+sWURAyM59YP4RY/u?=
 =?us-ascii?Q?mIwzndoYOrLyHDm7uNLm2DhhQbkJTHJQ0rSk48fZYH2KapMjSVQgK6gIfkhZ?=
 =?us-ascii?Q?emdQ7zE1wDsevIHAGdPS6zkA5jnnwDAjX7jPTdasG7vL8/xMDofkRyZNMloj?=
 =?us-ascii?Q?4Fb2VrRaLa+vXhCdKtgNn9UJXiRufc+rJSYnUsNmb5YZycNrw7UxmD/I9985?=
 =?us-ascii?Q?Cbz5lCIUyFM5RXga6NxyNGCOn0a87piRXJaDLfO2l2UXcJFfSx1r8scWmgi/?=
 =?us-ascii?Q?gSZMQjSLkPCxCSkeIrFYuqAD7Y0otZ08GGsgecg/11A8ljCyqQgYuqBb792V?=
 =?us-ascii?Q?+7K2M6mkNFzlHqvez94LgYLafg36AoD19DIyKjWST/u2+5sXQ9ySGo9wPJ+q?=
 =?us-ascii?Q?QuIzC1Fbs3m0f5jOFFq5WShdROLB1elwRfub9oYdXwX6gtZgHQ69EO4Lip80?=
 =?us-ascii?Q?FshnThMJEI1NS+MQHgy24RLdi1MLq49MEW6w/P51xXW/AnP0x6bFu71Z7yQw?=
 =?us-ascii?Q?JdgP/jV9VCKFpaYWTWlC+bGDu0WSUbnfi3kHbRbPPjZUarNHPCFxPbxunavv?=
 =?us-ascii?Q?jTZzAYFZJxacTQSzhTQc6jfC1JutEdRTSm+TebsdpWL0RN7je7s63hv576rm?=
 =?us-ascii?Q?CCdy8gO0Jb5UBqayNHMgDUiXHYyuK2WmJ7b21tAnG5fVMQ0xBE41FRgN2QtF?=
 =?us-ascii?Q?uhtyVC1DSa9KDz5nRIzp+HAKXWBoQwU+l64sND7WUm/Y5ZY19bARsCf0+3el?=
 =?us-ascii?Q?MJgs7LPHTUpR/xQjWukmr07u6X9LHL6s9+oquaYmZ+M1yH14iVbGO4rKoMMo?=
 =?us-ascii?Q?onnM4WtjeopBh+HOnF+G93U09jkntnJnJIN3Qg8xQ1buytpR1///YwigyuGc?=
 =?us-ascii?Q?VOP5G9bNKJ0M0t8+8voM6ryWMyFH4gfJ7RkFAABI2+ouKp4wM52CHDMrXt/J?=
 =?us-ascii?Q?D5+zmMK6ZRmmhVhQSKo61iMc7/3ZkNAWyYFtdCCaEfBucyEK1pEqo7hiQl7E?=
 =?us-ascii?Q?atVOcBwgaIGq1HhMknODEcAqIgLVezg66l+GX6NqnaJtpEdj9XO0b1mZktma?=
 =?us-ascii?Q?yFg+akPpC6ZfCWlXfQjpgHoc5ZVAaxbMOoFDopD7Xd7dnsehTRJheNk1+Htu?=
 =?us-ascii?Q?4tbiiyT35rNXzE1+p5CYE11Dv05rCPkyRMKsIhR7clQ71W4GC/X86rlcbzZr?=
 =?us-ascii?Q?9VKUAABSMMCK7xNNS9YTwk3UbCA9T53dhhf44DD4AoMw/No4fr09WlGX0CYI?=
 =?us-ascii?Q?udU+jlCtCw9MQdNV/TYyEJ8MLg43brVIEJL75HmUsERshZJbuteflBP4P722?=
 =?us-ascii?Q?nUm7r2BzsDy/KmrJTiVttnk5y2CApSc+Vt9TllI5Q2UNCvowiCgRU76tnuWE?=
 =?us-ascii?Q?Tjr1JMFrDQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a189f3f4-9de9-4e70-051c-08d9c168a089
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:16.5561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvcYVobSWhxdq1aAo1pBT0o6MEt3oJiAwEFBDb326Lnt2pGcigIPPomaNG3s+xwMNjrrRhYdJ8VUfTRPADf15LAYYGkm8S6p6ocbAB3w8fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5469
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

A follow-up patch will allow users to offload tc actions independent of
classifier in the software datapath.

In preparation for this, teach all drivers that support offload of the flow
tables to reject such configuration as currently none of them support it.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 +++
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 1471b6130a2b..d8afcf8d6b30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1962,7 +1962,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index fcb0892c08a9..0991345c4ae5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -517,6 +517,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 224089d04d98..f97eff5afd12 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1867,6 +1867,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
-- 
2.20.1

