Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C625B8BE8
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiINPeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiINPdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:35 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2056.outbound.protection.outlook.com [40.107.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B073748CAB;
        Wed, 14 Sep 2022 08:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFRbJ+wJy17UdGAQGAF9V9XIC+UFPOhCOvt8SFJbApECWUbdG1IGmF+PTNihlt82wHgKLsACcnyjqJyE9ndKsWFbtcpVwdnp7XxyVxe0jD93FDJH5l4gOTR4HH5MwGkCR3Aoc/s5UsuzQ1xIe7m/XWg5KayfzjiboQbUF0UH6uKY4LWTja9Ym/2Xd/vvD572IJ46sn29kiStryEjYH/YSIMC6oSectr/VzQTLu/srXWjQVc1a8d9OyAd5XZkIf+YclKlMgH77iTQiFwXe/Si6u9WJgm/aZiIFWlcM2akoO6jGmxL7j/T413aFcVWzp8U9JgNL5qa0b1S5eaxdRoE8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1nxBu7zFNRKZDIi1t7Hsqxq59vzmm67YpCQQvlJ2A4=;
 b=AYc5UJX4jpVMJgeVNLQ/EaD9JW37tSxADIuDfY244qs6wgQnT3+30kJGPqeb2Ph1KpkSCm1fGXxXyXlxPtrjMGRZ9bVv/9PlshGbR+8jEsf627Ef1Yqw+WjORoIUMxDgTyKYi8FfRK9igwA4j3d20JVwjhkkXbMD06HHJRVGgbLbQc0qtfl8JPJfqKH2eGfcxH8hTrTVxWlbHrtM53MimlPanS6k3fnwF1n4eAZVcji9nllg2BFa5c4YjDC0phyHN2q33C0ovfZcvKG0bBTyGTXJdgIKIFrvwl5hgA2RfdaqDb0YoxdEXYIGJJYt+6FO2UcMgDZRGFiIRoz7Am5q2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1nxBu7zFNRKZDIi1t7Hsqxq59vzmm67YpCQQvlJ2A4=;
 b=gsfmzWPSUvtMvM9V4h+0aj3eq938g9j1fwN/D+uuGcZC89tu8W/UVX+UzRcnSdcffPgNcTHRvpkWcreV6KMefzRJ2Y+f8CcDAgyqpW1lcfLp2m+ROvpOrh1wU1xH9kpn0i+OXrd5Fb6+6YZizSJRGDouNIyRiG5U9aFfssQG0yg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/13] net/sched: taprio: add extack messages in taprio_init
Date:   Wed, 14 Sep 2022 18:32:53 +0300
Message-Id: <20220914153303.1792444-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: bb23f6bd-6a71-4109-f0ac-08da96667a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6o7ZsW6QI6gki3k/cgmeUzP/fr4qI9ZhFD+cJBl83KeZtJyQpAoVmOzgpRpUIte0jziHuznk4wVjtabEwIWaVcTlC3iX7vBnCbaqXXXYs2/IwQyyt3IqhpNOkIlb/f5jA3KYfuhfs24EcA3AXqobZzLAr0jUSvSWLbHGORX/QcntD9vdVthsWDZu5mM/O0n7JsZ2gUQXhTL7RRzB8eaAQjHRgVS/2CYU/HRAGduWtDQr6mqPlScobTZoixpKX9sEUPK8wvStx6jxBmX8bU/6KAUpeKUQxFIv2VeGtkb9n31XbN7j96Md8NGFCFxxx8t476GJ1lQhfOexAt3agwPcEss1N3byqP1fe3jUU706kSz5YX7Qvx85k+vemUscIFvU8D+WP12h/l8kCY4jCxHcuLD/0/bsotuil+Mb0xWCuSOwFEqv1vlZXpJGS+TyOCwo0uTTDVTeQ15Lxfyi487VPZywCIeE33G344tQWMNCqP7SPbTCx1Xyf5iOc7W34HVj1jVeuoXBP8W3tfw+F2SYysDeRJdQEAG4foe67Kr2f0T5I7VlI0IM6eKiGkYagnL0gt1z4agDwEeZBW2H3HTMf3waRiEyg69k4L1a6sBnq95CDl0m3xiYrmPy0zTJ1MKiXG1jhUm7tbmM6l/m9NwkYKVoN09cA0ZnBBrMn10z/+zhJWaCkjkzzNuI+Nl8dp/tqkGRFgAHqbFKJtWRvw0sb69RuBloPnhjuX99YtPIbJBZUsph8w3DzAC5iPo6roMcViWLQVeRXFEW4fq0EhfOjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4744005)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y8qkXJfbKSboRzLnJzRyDwuSVAv1FHsijUY7/YPvWMFr8d7ypLDI81BpWuns?=
 =?us-ascii?Q?qtXGX53Rt3axFTRNLPHK1lkQRi7rWHqa5iOW98GcWAEMZgld1jsxBMyCDGjU?=
 =?us-ascii?Q?GgHHr/3eo5urQ0nCHSZaBCnHvFnCoOB8nektuh//TRviyFkzkPuLHFhbTve/?=
 =?us-ascii?Q?SVj2VTDb//sQ/5ppyEHJoOYhoLBJkjJQCREZOh2IcorM82Ck9iD+3RZS9Cj+?=
 =?us-ascii?Q?VJmHGk5t9B8Br0u0SjnBu9EIuNVVaOl5iuqL+XmhPB01VqH5byY7h+iOsUiK?=
 =?us-ascii?Q?mtZytCi94O8fis+j2YCT7c8Vjtx2x5a8QPDcWkeB3U6h67Bit5ZBH0PO467P?=
 =?us-ascii?Q?SBXCLbMKpeJCK36uL2g5p8jnEK8uuLqjwXzJbOnEe1lKocvKXjp8A15PmJYN?=
 =?us-ascii?Q?UsaEa289hfqnXT0eZ3o49VDaJkgml/9DXXQPiq+IUknqlu0k1m2MPSHcm8Iq?=
 =?us-ascii?Q?4+pLRJEySfVDvF6BOXPc1wXMU4Q8do0kcwt+agU0XQD7ImW+qLvhRhhfN15d?=
 =?us-ascii?Q?sZTGXRilHnDrWbc/v8bBPq7+gYkNQCw9+lAtQxbH6URt88CGWqOrhXBlsVC9?=
 =?us-ascii?Q?au21/CpWUc8SXIG58fwDelTi1QKre8xKSTSbmoQ/wLZEZnSJ+B58ZV0dklWA?=
 =?us-ascii?Q?4F4v0+r8TJ+Hcz1zzzwkuEogvU026Mxklv3p4oZ8TIfdT42ptLgWI1dn0kQR?=
 =?us-ascii?Q?R3IvI9aJgLgRZZovzx1SlaEA8OOOJZRYypM9oggg+uBZoId8krPUP8PFt0Y3?=
 =?us-ascii?Q?1fNqjlhS0xtSuHbxFm01KuDmhXt/9iqBvQk515k2mi7xy5nR4sT+gC2jEjhx?=
 =?us-ascii?Q?BXsgP6Td8l9Katx9iJ+Q8MyUTw7H4NEwr7qSmFKEu5tm/Tr1xj6DxXRJhpgj?=
 =?us-ascii?Q?LbI8eIWmwuyYzzCvH8FHfJK7reeErvGH0yDqfGGBI/DjuBVACw7oDl1itaJ9?=
 =?us-ascii?Q?MKgJeO9Kpt/F9akXM5A4phLGlEclakQlMZxwWi+eIgOgW/HveNvB3sLexMUK?=
 =?us-ascii?Q?51gGHOUKNfuNYe6iW5P7gIsmKBivXs9rbAR0+roDXJh8j8+6Xl1jF2sFpMON?=
 =?us-ascii?Q?qzONf+n18lGy0FA46ZPuMYO38CK5F4lBHQLN/3t2wZpztxDt1obJ6jKlzt3D?=
 =?us-ascii?Q?LsJMpitiKvEZ7KF64w/y412gyqQV0EsR238KEXjuX8WDgPlt+Q7MqGyI7kCV?=
 =?us-ascii?Q?95OryMNqmp6xqtz23FblunRsbLhIq006Fyvu802YTdafngsQfWeZIS1v78/y?=
 =?us-ascii?Q?rKsrfgAvAij6Qb5vM5zjqJD2qjohu7fDV3xgxmmh7rEOymS8pCLwU95Q0D41?=
 =?us-ascii?Q?rH8IPyCLQkkMwIJEe/vPduPk5u5G+5v4WcMD1Y0cSXoCrMYB2JJslRtjrqFY?=
 =?us-ascii?Q?2Y01sGX8Meveu77EENiBnCDkbNl7p+ugF3kj8mHPvCSdrUalj3R+YbRY+S5X?=
 =?us-ascii?Q?75Xzp6rq+KG4Susk/ngMYORo4OV5JyGCZOx4EUItiwr3d+oct7slF9Fha/+e?=
 =?us-ascii?Q?b63xKnbhpKXmiRcY2QwsinVu2tOzdQuuruy4NpfSBr+eblQ713JnZvfNBVdW?=
 =?us-ascii?Q?4mcVt4xO1tu18gXnQ/R4KwAqeYF6TJb9bW1Z0ELh5MY6s7xtgSPP/NREKDcl?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb23f6bd-6a71-4109-f0ac-08da96667a66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:31.3556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+0Mwn1bgcX2xNjLR72SH1Vz6pqxG/XAp++ptMK5lLmQ+0yOXHbfdoTLdzfRkfASL6fXsViH7iO8h8vCASzaeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop contributing to the proverbial user unfriendliness of tc, and tell
the user what is wrong wherever possible.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 226aa6efb365..2a4b8f59f444 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1675,11 +1675,15 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	list_add(&q->taprio_list, &taprio_list);
 	spin_unlock(&taprio_list_lock);
 
-	if (sch->parent != TC_H_ROOT)
+	if (sch->parent != TC_H_ROOT) {
+		NL_SET_ERR_MSG_MOD(extack, "Can only be attached as root qdisc");
 		return -EOPNOTSUPP;
+	}
 
-	if (!netif_is_multiqueue(dev))
+	if (!netif_is_multiqueue(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multi-queue device is required");
 		return -EOPNOTSUPP;
+	}
 
 	/* pre-allocate qdisc, attachment can't fail */
 	q->qdiscs = kcalloc(dev->num_tx_queues,
-- 
2.34.1

