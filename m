Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3FD5183A1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbiECMBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiECMBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:31 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFBE2E6A0
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heBnbI/SXQPfWw/HNUD6k7rZ42zNDFb65wain9Attu1ytsP5998GiH7xEkozbBZqWD5w+XFCGufjUwnapeNGvFjK9aYgcldibU9Se+DwilvaRuB0XrbS8AkWKnOdcWt/7OvPqTTO/tXHeDlpwyziNmHKkyUQAtqeApxAK6b9D31csNPzsQxlcMtM5BfAzBW+Zx8mIEsk/xfaxej47TwhSxb48AeYlNMyJaJtR3PUr6T49Yz3stzbr2OyalJmvgbzP4bZI15exgYhZgqPQzrE0eKXBycye7OgACy5sAvYMr/Nzi73JOiGRWbSwn4LovV5EoaTBRG8+RJkxX2Jq+hWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OISQ4WW5Wt5BjgCvi3n7jql5wEL6vqi3Eil0dqImHU4=;
 b=c9GVLVvkF/+vN+O3WCe/1wxsMK7sZmW8rDQsgClksqahDDVclMGvL6mv9L3tX8RibAcwuXegXiS9CY0H7YQc2tJ5MSocWZwp4Nh3AVXPS730DoV3Z5trmLKJy1hgOmiLkm1GNFbJjcNwnJ9SVVI1zWgXvsvtp3o9vb+NptXZ/K8W60pmcv4bu8msPjMJaQ/mroUUV3KTgkceXnV0EqeVu4bHHxPXfr/TpBfVX3YDy0gV9aDitx7D03u+2zMOUR7FqElG+8MNCvxr2ZGpCcbIx41M3lA9l/6NN2R3txf6951rKdoW2T9qhMp0EHtETWwEq9lsV1azAGP4+82M7G3GdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OISQ4WW5Wt5BjgCvi3n7jql5wEL6vqi3Eil0dqImHU4=;
 b=A37fgD2KL/Sy8BPyB7L6Dp3zj4f4guK0yl/pxwnMpV5MX8HIfzy1Cerk7UZM5OgfL9eAqWCRjghmQ2djtKPk6eZRu1ZsT953tSiz2yfksCH3FNJGVAeWP+h6wMTfFkYg67PDEcF74yDq95v2h2CiBDXS4rq2AKAoXgny+tUvDic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB7PR04MB5513.eurprd04.prod.outlook.com (2603:10a6:10:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:56 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net 5/6] net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
Date:   Tue,  3 May 2022 14:57:27 +0300
Message-Id: <20220503115728.834457-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503115728.834457-1-vladimir.oltean@nxp.com>
References: <20220503115728.834457-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::22) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12855711-2fce-4d97-c077-08da2cfc2991
X-MS-TrafficTypeDiagnostic: DB7PR04MB5513:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5513A6ED79842A58B6519EADE0C09@DB7PR04MB5513.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PF3zmxDUB1KpBEr7YCWdjw4W1D/hPTgWKhFctfTUzLkX6VoDTxSfrwnZZzaYFG85RWNDfgg8nwU17hvZH9zU122PvXNy7Da21oHwtriKbP5XyDbB/uCHgA2T7s6SnhsHytfAKCPoIAzA07qvAu4Mz4SnDmQx/5hJRcuNLXEfm3CqXTn7fwudGqP6JTQ+TiklxqfK0JWQaY8poAcKHIIGQEi7sde0eG13KqDA1WO8sKkRvcpGzCZIjNT0Wf3d3LJk02EhO3/W5JiJM6yOSynpnvC5TiXOjw/T6gSGJ/O4eNgWi1DZsZo94vPJ40VC04gvZDIo9wjwx353wRg/pXWNw6vRG3dwzM6X0i6uHhXzpjVM+lf++cYInCkOVwkZWNZZkp228XaPrkzDaaJp1u1UXOsxZ1h+yUEAI8bDlVPlPDnnpgpYMnfLEyEh2XEz/LlaSdoBcPxuMSDWrn6dB2Akwh3jpRgd1n3XTUPi8no7AIyWcqMlIxCaQT4sSPLGekJVndSKifzmBggOVC7lqlt6g13YmD+RVzDiiYv5MtzjREnrzOhRVXla/xmF3uC7Q3LXE0wC+wzh+WlB+yx0AeRBV0Ln+Zy78Ab4Nqab4ySfbKnb1Z2lphX84nZa6BFaIwDRYu9NOuHqRK5XE1glOvKWaUp8gdlxHc8/1H8HF+ZxkwUAth7a5wOyBdG94l3tjAERNdI5vVdDBKxaybA0SeHyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(26005)(6512007)(6506007)(83380400001)(2616005)(186003)(54906003)(1076003)(86362001)(8936002)(4326008)(8676002)(66476007)(66556008)(66946007)(6486002)(6666004)(2906002)(316002)(7416002)(508600001)(5660300002)(44832011)(38350700002)(38100700002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tuS1wkrzzjw1xSWQjDSHRfJUYoye/lrfAIANAKCeGPdazXyDpZqixWFaRzRq?=
 =?us-ascii?Q?twJL9SHQj4/ewAQpFtDm/5tegWhh5bYaZSU7su/l8iTkyL1Se0mjwLEvQIqs?=
 =?us-ascii?Q?RcGLLlCY12h7gUAbY11S08uqRTz6XfuzUIiHp6bQ+bbAVBo8GvGV9wtLhtxv?=
 =?us-ascii?Q?1lE1vm9H//vpalA4/gWZiTasc2/ZO0MugdnDyvyoAvfhE3+rq6JKoUliD/0W?=
 =?us-ascii?Q?Vhs79KfDidcb2iFm+LusZtIuDn69QLTnScJ0aMTE+4wZsUpOAvoNeWZf9+pD?=
 =?us-ascii?Q?Poa60smEwd99rEIyeXQ9gEZmIA/OcCSTcqibc6bRufQXxzmTgNCwcEHlm3HJ?=
 =?us-ascii?Q?FN/VGPsV7p8xEaoEchdt7P8snl2G2xuCVldMbWC6PU2lZTIABOm8WIvKTzEW?=
 =?us-ascii?Q?8FJMhbnhclEuy+hqkTs/xhT0k5WNe4MlmRAsJmkTCaDyiE4bpst87efz0haf?=
 =?us-ascii?Q?ruWAz0G0QK7cp8SR6uwAt1mIDqkrUOeX7lMgFkUyp8Oq/TGMNXm9eon9ZdR2?=
 =?us-ascii?Q?lz1he7jKPh5NlvNfQveSYdb0gmvvVilGqXHgqjrFdd5nOWpi8DWB/2Ublffb?=
 =?us-ascii?Q?oOMR9mMAb80fKYCuyMiIwMOH92xRep0vUhNYPYnr9Ixzp4rve4XesZ7/G0QQ?=
 =?us-ascii?Q?H74irmUAEbBh7plrj7mSzvft7x3lSw8G394xk3iZY4pkXjsyRS1xy7m0C4QP?=
 =?us-ascii?Q?of16Wcr4/UXyH0yHzGF3W5BHI9tb8HK2Ao97u1QxI88AQqxF/B7cRvuaB+fv?=
 =?us-ascii?Q?1tGoaIizsOdtMLEEVIhD4eWbzjJjtAnU1TYREqbXWqFhu39xxHP91w7I4FRF?=
 =?us-ascii?Q?7q4L+tfHUt6lWXV0Y8ANZVuZmrxP3dlw6Zdt95XU8g9jI3/7KjrQZ1tgwH37?=
 =?us-ascii?Q?XfMpYnW35XadJKDtMKDM9r4aF4jD3S3tlip9XypgZwjZ7WHcAh8SyQkFbX81?=
 =?us-ascii?Q?LGmvS89rew5CBai4vqh4e+Y9t/exo9XjY+Fg/woGSQNMI8uOB6P78wfVTj6M?=
 =?us-ascii?Q?8vc7f2dNP+7Lvw1eMuz3EraXnlVl883e9Hs7kPCjJDzq6blVsmsYoqdMiGXR?=
 =?us-ascii?Q?PkJhtFgqznE49pMKAykHREKNRaYCDlatjPcR8Ai1opkxx8aDEq2Y/RWF8QH8?=
 =?us-ascii?Q?tAzszQ7NTTvRJFPO2c5/cbNdmUBaVNqDrK1a4D23tBTYH0M8H4neFpGFAv5E?=
 =?us-ascii?Q?fcICIRzZnQNgZjY1ud1w3dJlZdqdOwURa+xfDx2ftQE1eMYtNMA0c4rAuYa1?=
 =?us-ascii?Q?ysCC+ZuwLkdRkecfOWb41mhkrL5xKLfmhuiJPjuP/MjrAVN99p7b8fRk3Xo7?=
 =?us-ascii?Q?PFt6uWNarzA524LxnreujKJXumOANSOoFk3vgv0KG4SoxgRYpcVcQgtydO/H?=
 =?us-ascii?Q?XX1TgnasjS5BZNDW2RXAX9xJtz/bGS6uTqjL6/+mx3on6QN9F3/mmZpHszLG?=
 =?us-ascii?Q?T41EjFcI7SIuN+jIpgA5XyYC4yNDb6w5608rg/abKoK1vJxoFzMaZDVnWBnb?=
 =?us-ascii?Q?LH2gApWZSXm9RRbjFyVK51/Eq2HN52PUpSp2pq+45ozZeVoPWA/3qph73Up1?=
 =?us-ascii?Q?TLTe02bozrHvFsZd2lPWo0T0H0r1S9+50a45D18wbfK9fd1/WTShJrqCuV2j?=
 =?us-ascii?Q?Dn20ZsHQp1QCTTuj0EPTAcjuvE/q3eHnUB1uykg9OkmO0g/PRKSs+kJYlt0s?=
 =?us-ascii?Q?S3HaisAAqj669saM/YKNPqJf739bI1smxSpHPVPF125Il6eRKS64vIbJIItM?=
 =?us-ascii?Q?P1Us8LE5YRZyDww5wjsU2KPvjNKXOBs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12855711-2fce-4d97-c077-08da2cfc2991
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:56.8863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjKtipX74NQQpFauWH0J6ECOQv6y/VABBFiWFr1OILnALh7g4tHyiLRY2WCkSiHnxtq/9KqZedMqavrGaiHYGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the CPU port was added to the destination port mask of a packet, it
can never be cleared, so even packets marked as dropped by the MASK_MODE
of a VCAP IS2 filter will still reach it. This is why we need the
OCELOT_POLICER_DISCARD to "kill dropped packets dead" and make software
stop seeing them.

We disallow policer rules from being put on any other chain than the one
for the first lookup, but we don't do this for "drop" rules, although we
should. This change is merely ascertaining that the rules dont't
(completely) work and letting the user know.

The blamed commit is the one that introduced the multi-chain architecture
in ocelot. Prior to that, we should have always offloaded the filters to
VCAP IS2 lookup 0, where they did work.

Fixes: 1397a2eb52e2 ("net: mscc: ocelot: create TCAM skeleton from tc filter chains")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b8617e940063..e598308ef09d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -280,9 +280,10 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_TRAP:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Trap action can only be offloaded to VCAP IS2");
+						   "Trap action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
-- 
2.25.1

