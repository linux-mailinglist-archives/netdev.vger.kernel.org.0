Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF7869A23B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBPXV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjBPXVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:21:50 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A20F52CDE;
        Thu, 16 Feb 2023 15:21:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPf5EoEtSQNuladMyIBV2oEH0JK7CFcMbnzTtQbYXKITCDnJEcZN8vnn5kljb1FC48Jm2YMn5PEs4K3YqAJGfyKbghbJyiYKSHLPLQ1zHg8sVo3MFuSj/Pf4+alCAfVN7ncKY8cP90fXa7DwO2hCDWHr7uv2S9FHct5jLa6mAMNTXjmy9LiohkbMR4Dbq2r6LWTaFp14E+cznHWan3uWIDHVsP1Wn86AhDbVhtx+YSPpoVN0B1aaXdnIJwnF3W5xM6N5yIIIq36mGsCYcRemDfwsvFxroaCGXWFT/HL2bpFtivAobgq8O/FUeXRdotOWTd146PKV1+DVQKTyJFOcvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=141wq/zDW3i/p2w4llBv4/GzapNf8wupXTTUdv63uK4=;
 b=AikfUcg3xfd2xTCFJOPnAJj3GlHUjHwFA4OOU9+KmqzEOol0DnuRyIbjzfxY5urtjTy7R6btT1x2VJ/ZJZJsg83gT/94FQYe/sRGtbmwf9gxxNtyP9FjQDbJaOLSRNCA9piS3TYDM3BavCQ4Obld1PMiximvYVa0x9zOi+7k3nzlUW2vf6MYt0Ay7b4mwZMmFBM93Wnn46aHPVzjPj2Tv7u/Znxl37oScSjCwvspOYfmaCbNlQLoRofiA/XLTiQwmrK50jdqSXSSBGMX+nP9UotHULX8SB+eAIDZ5z4gRITe/JZ/7r/kG0zWwsNeCpfFU4hk0CtKNjuH9GtUpXkW1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=141wq/zDW3i/p2w4llBv4/GzapNf8wupXTTUdv63uK4=;
 b=N9QLubz0iFo5Bcg6Ih+EfYLaPkNYyf1/vrdI0vPs282SaM8UOaEdOjZVa5qKqcI4zHxcMquUm9j68j3lMqTV0CVMsKTz2iOWCx0J5D9caIk+Ov5/Op+tSaMew/BBpP+y7ps3V5imUR/fukpw3Itt44jJsF7cLOGlGZTzFKigy0E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/12] net: ethtool: fix __ethtool_dev_mm_supported() implementation
Date:   Fri, 17 Feb 2023 01:21:18 +0200
Message-Id: <20230216232126.3402975-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: bf211a17-582e-4b54-1267-08db107491e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwVGus31ktGIs3FnlHjKyfxkv0+87hTnQvFIotv8tHLy+2/GhByAigpVvzTRy6YufycW95ufggrZIKNP32oAhRc3+4Pkry6hdD1GcY1sbnSRr1fI6XiQUdn+hEJw1qZX5rAmk86ynPtux4ZuWhThamGwvJGcF7w54DU9tsFTR8T0WKDbqOatHlgJ72uxvLmSQaziclONtyOgSaEU1wFG4WIaQ1Vk1cDO4lDie2RLGbl6QBMeF8S7W5jYPYyuLgfHbXkMSjfhS6F491r05IMYTB35F//CL5WeNjFf9Wh0/G4KFRWvrhr80gSEeEqU5KUcDBN4D3QUcjvn78fdiGtHWwPAOpaDAx5zhF8Hw/XXo+aBs6fntnZ2yXRUGBN2AtAH7q7Jdp/xbK+HxecPu31aQShcKyMLpcALrSehi0BPEUi3Z24nET1P+v6h46luRwld02hva4iZwZyAKBl3kBVs3Jsc+4N1TQwC+BcxWKTtSL6KQOH3E/EmP66kratDzQGhD/+yXVWx5cTg+81MJ04CUstL2rgjWQO1+ZTjDsb+rxBLzYctp/p+wwzNm8rOI43PI/Qajh9voyC+4obSRLiNaYgkDpNAXPxT1QdZ1RXd6nDXUnaFZS7O9oAmiaqThvts+qOIoJxTpNuy3ZRN5x1CJWs1KIzG+8PtTUJO1bbyHJVPpgSKpDoWLjfxw2ug5+3NyRrNmyAZYckdstyDdaUccg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(4744005)(83380400001)(66476007)(2616005)(966005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q5GKpGFej0wUG0BKBx/0Pt4RjxHg4371mzAzY/igz5FEJMMlFOs1K4rVrs5w?=
 =?us-ascii?Q?8N2O01+pgVi3qMblXoUPTr9RURB24z7ibta0Lb2XbgmcBWqayhefiKqueeVy?=
 =?us-ascii?Q?AOCF0SDXqZfmCJiphiWBHrVfy4fALZgegobRxrjapzt0rruihN2sBxt7+DMQ?=
 =?us-ascii?Q?1N7OmPKz2Yi6asdTuFaJl9LS+nJPi7LFh2W2hBWDcOvJW5eM8vjlPoun/u/O?=
 =?us-ascii?Q?Lin2uZ9Vm242hjHPguZXAfivvMyhrz6kYZ/DgR93ALMxcqdU8f3WPSI4Oeu/?=
 =?us-ascii?Q?CLAgc1Ddx1xk6b48bqDXsQRq4UqryV3WEceCuHN5tQlub7mHwcA6dfek1x1m?=
 =?us-ascii?Q?tNpsr5oQrij5IC5nwp/qvZcLoN83JBvrKU696LTW2c1MH9JCUMbZ5EzGbWBl?=
 =?us-ascii?Q?gUD2JJE+TaF8hVNJ5I2Bw2jlEd1wVhyfHX61XXESDJ9OuKKTvHp6zTQCV0MW?=
 =?us-ascii?Q?vY1xUg50f1KrByckbAs+PIaVkj6QurqP1hYWdTuWnMW5Lg390+I+LqsWcwcS?=
 =?us-ascii?Q?MAlFwcUT0nsqXSZXr0OaEDQpd52M/kM/GkEF5WX4dT+i08L+vE4uJNDGg0Ne?=
 =?us-ascii?Q?7Vea+EmA8uk2r+m+yLwMEqzZ9qOqr8PW0XfnPsxNT9vlKKfz+f5ncmlN0aZ7?=
 =?us-ascii?Q?P6mJcyxxoWS2CydhW2OBc3u4VltmkG3v5jED/NT0tVEo7yiRWaI5FkWB+0HD?=
 =?us-ascii?Q?9I21JKKSgeJcwkwr8aRbXKDPESBk1m2tgxOuTkRxJ09oa+yZhFzG3gtEPNUl?=
 =?us-ascii?Q?JlP5PzV1ale6YCvJXMzzMolzWfW9aGu0J6Z/m+t9qVmNKV3QmZ2DJJuxuvd4?=
 =?us-ascii?Q?Zs/WuIwUrZtuQhf3848TY3pfr+OF84NhUPtZ+lKniu0OhI/bwNWJQaFRggzq?=
 =?us-ascii?Q?0bNTCwuZ+7vsQIApHS6IvQ+mVPFDyLZ1ZGkYpWMzXaii2zPS5O3ZntpJHdjp?=
 =?us-ascii?Q?aAoQGr17Piqvm4Bp5HgwIuRiqvfansjalw1MmMlE2uHoMZZFrzCejpKAALPN?=
 =?us-ascii?Q?z0VY1IB1GDD4gOmPDyYRDC9A0E84z8hflqrpgVb86Utc7jrnmTeA0N9zG/0y?=
 =?us-ascii?Q?z6o4TX1rqKgQzmUKlQ5NjCMaERPTOrMgn7HDmXYzG7TaQ+pmop4qoE8KNBWb?=
 =?us-ascii?Q?2bFzI0bjzhwT+mT4hzdot0mYMkClSyr/Nv0Gri0N1rntfit7czd4A/WYz1bw?=
 =?us-ascii?Q?NIHORwc2eZnR16+ZTJ+iPnl5YrpF1fA9bJzhH4wW0xm2jrBXCQ1vRS449f3j?=
 =?us-ascii?Q?znu6sFCFJUSBtEg/Vk8HxB8dI5cBpoMPYuBQ6P2s6r0IUT6wvLqGICP3oIlg?=
 =?us-ascii?Q?hjZgb8fHj2771kHESV0dRhjD2mLff3NFHExhe8GRWFiYb39hwbFuri8XjPhB?=
 =?us-ascii?Q?RxrgynxvJLGYALybEKMxvkLrGaiHwcLKhVow8Ky46ihhET2aP/DazfE5yneX?=
 =?us-ascii?Q?spNbVZ09RfSoFzAbrY88h4D+Px5/AiCJF4OhugKrHQ+UV+tPRvX52AZ/XgX+?=
 =?us-ascii?Q?BB50CwUgqHcepPAU3tooe6L53vhURY7is70FYKAEppjztCSbfWhGBGcimdnE?=
 =?us-ascii?Q?2eUyak7xdAmsAsjisApCjJ1K8B3utN5w6EOtD1EYf6MwQ5eoVlx0IIX3k2ms?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf211a17-582e-4b54-1267-08db107491e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:45.4931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyiAG/xLy48Wpmf0m2pjgpD2VB4BIvrad2585H7mxPgc8ZVkoQxX8XZ0JDLp8lUdNp7Zby3mJvrs53zSMubO6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC Merge layer is supported when ops->get_mm() returns 0.
The implementation was changed during review, and in this process, a bug
was introduced.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230111161706.1465242-5-vladimir.oltean@nxp.com/
Fixes: 04692c9020b7 ("net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index e612856eed8c..fce3cc2734f9 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -247,5 +247,5 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 	if (ops && ops->get_mm)
 		ret = ops->get_mm(dev, &state);
 
-	return !!ret;
+	return !ret;
 }
-- 
2.34.1

