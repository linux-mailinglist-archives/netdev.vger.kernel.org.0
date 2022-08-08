Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4595B58C89A
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbiHHMvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 08:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiHHMvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 08:51:46 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70071.outbound.protection.outlook.com [40.107.7.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0088DED8
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 05:51:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1sVZC3/7NMDGpicQ8sGpMbcwvxFKPm2+K+zWYztIiK8uK2ZX86i9mt3JOOBX9UTg6ZtBCAMSTzZh4woxMsTncHDe84ms7tixCU7myWCp2qgTZ4oLEP7Xi0pZHJfWcvE3XDee3LpgSg1doRL3itDjbDId/OMv65ScWkQzrZWBiTQchVyj/nU+ipLbswtPARA9rSsdvIvyvUd+GpaOtYzgASa9qE+PCg+iWxp6pIxd5sVdHO686Up5RWi2MF8Pw1kOxCJ552tz4dpsIWFcrH/siILfP9iaidz90EoDbBRFjJ3sr2TnY+u519mN91gKof6lxxoT61CHeGRwFn4e1bXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWa7oVSglUKT7Qj3fPFVL3bFC02NgVtgW4stKK7oIRE=;
 b=jWRGFxKzb2VEYfooZCm5mYHcsRKhvkUfLEJOeW/leM8YuF6QdH4HOwEL+3l0VAR7+DaYzUz3s95sz9yrXCCK4TavzYUbKtILo5cHvazpL61T3uCf7LhJ+U6EaezQ/G86/LJj79XQq4gpSLDYLhb2ItSAAccqiWEijnLJ08ysp2WOBOc0yyR10rRfaLjk0n4TKn2nJ61bLVeRiJ34+auV/vd8sJcCarlxx8hm1j0dXEQWmEGhqLvYLdiSSTG8oc5ra7sDqb12D3bdZynKrzaeSjgr+DSDDkB5HXPHtynTMR/3NwaRD7nC+tw/UuCtknHBHto1OKs8f5bHOeNxJSPTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWa7oVSglUKT7Qj3fPFVL3bFC02NgVtgW4stKK7oIRE=;
 b=FY7xHixHAhMT8W6Z3xPr7GxvPf+sM47WuPrEaso5epq8A95BXd5+GIY90Lxm+a6vaHoquMvOnn2HwE4/qkuuxSqRIlKCuzEXE/ElM64dPh+54i1fcQR3N8Q7Q9ABPSPJ18AvVzxTU61NALKwq92cBvEbk45yVCGZaDvFkFETQ/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8405.eurprd04.prod.outlook.com (2603:10a6:102:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Mon, 8 Aug
 2022 12:51:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 12:51:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] net: dsa: felix: suppress non-changes to the tagging protocol
Date:   Mon,  8 Aug 2022 15:51:27 +0300
Message-Id: <20220808125127.3344094-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0009.eurprd04.prod.outlook.com
 (2603:10a6:208:122::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c043e4af-7a96-4e62-d5e2-08da793cbd6a
X-MS-TrafficTypeDiagnostic: PAXPR04MB8405:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iz6ivTAeh+HwmxQdXy0wwCbpVe4JoVhBpc8Gjfwd6Jjwsn2pA5zrjFTZKOanoXo1K1FV5jpnHzvQXGn0VIBNVn+qVWAZbB1gRgFgx7rgHqQU5H36AnV+8z/8uBWS1k+8OJst/WUw9KFNt/t5fb1BxNDYbzqiItaYH5LyLXo1Q551fhPEqAceyr1HzYdUbD+zDf/orAFGjmEp7T/6ocanT1DL30sbXSGBaQfYvdGlvuIGzkAMqm1sZwWtW+1tYfT3Q0o3ZIplbTMAc0A10s7WTZIArBzFmkcxOQYfSbIMvd+qbtghuOwuRQyx4PVFyB3W730NdfZeowD+CR3D8SzlEaw82RwqIZn7r0G1J3ot3cJm26yGhWKBbBkl0bKLz9/+iEmgLVu0SRnJXa/oNWtZ1uo5PALEnAyGjHDp4jY5NyPg4y9Fhh5lZ2ilWqBzvdqodRltq9caA8XGbvAEpvJFQbxUjG6yY69t5U0TJmawpeZFg0cuiqosvr4FbnNmmAxxqvQmIdTwu4+/EsatLqHnFDBBJmzarVH6ar197VR1Ex8yzuqfwHhGmi59Wnh7xjAR4l170XD8v62g5IDCChx54jvum9S+DIv0JqnWmnTWn18rAPVaW5pC9VSXEVy0BzXngjsaaxvGmNDJ0rlR+bNxxJeRY/nWgMARL5z1jlBAMELLZZ0CfZ12GN+N1JefobZiMaYGGw8qpasVmAvMQUiSNTe1FKXgdiUJM/Dcl2+EchMJGji+AMPTtjdRUA2ilGkod1/ZTBJYTJN6xqIn61BUSf4CeXX8t1Iu6GeEnGhT2So=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(5660300002)(4326008)(7416002)(44832011)(478600001)(1076003)(52116002)(6486002)(8676002)(8936002)(26005)(6666004)(41300700001)(6512007)(2616005)(6506007)(86362001)(66476007)(66556008)(66946007)(2906002)(38100700002)(38350700002)(36756003)(186003)(6916009)(54906003)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?peA+uhyR9U4LORXeaq67hsHIwRtuTr4bcO4f/gyzJn6HoiMMSCykyxJNS0o/?=
 =?us-ascii?Q?hxFQRQ8atQ/pBaBuWx6wAkdyDRr6fSstd9KfaS8UKKDT78flJG3xTVweKhac?=
 =?us-ascii?Q?3qXH2yrX8G4Z/V4248FLc61xDertMn96WL3TWUSqQDEvPSuWL5UAAmqCrMeO?=
 =?us-ascii?Q?ZgLfJdFvYlGJWmmaOf1kf8gLbY0FQrcLiAvep5SQACGSCh/ihr8M1fbKU67L?=
 =?us-ascii?Q?rLs7K/W72at6iE4BP+YfwcnevTMAjoLN0zdJvoG0LCvst47F6oqpmafW+len?=
 =?us-ascii?Q?ddOxmeah+JnobVWMr4kUb7Oej+b62W+araH/4cIRshJfbQ5yYAYZ0que72pH?=
 =?us-ascii?Q?/Ht/QAa/c7tn65301jLqmRqL4be0Gayu9OkoQAosYEwhJ/kMCWqHOF5f00HR?=
 =?us-ascii?Q?r77a8SHouRYLTWVqLi2T+UkPkJGXwQD938Ke8Yd5q4Pbonlu9BggWAo1YIAF?=
 =?us-ascii?Q?Z/O+jj1MoWi3ZTJ3jyVubl3NFG+rlU++Npla+Pr+IYleXmex0GZlppJ5IqeB?=
 =?us-ascii?Q?84wyNkHjPOEh6yP2vYa4TUHmWrgar91N5Irccsas8BQeuUE5tuJxKRu47zL8?=
 =?us-ascii?Q?JqS2WHiuJYdjhjKe1oNPkgjB0zcOwMWBpr3gYPL43vh3N36vy9qtH52CbbEB?=
 =?us-ascii?Q?+G4PgatiF4NxprHhuZkQ/BWyC4bjOGn32l7TO+2Z2P7P4RGJdamlYYkipGem?=
 =?us-ascii?Q?rtLgx/GfsMCV49WDB63/0Z3qlo7njYIFDCg8tRL81Ps+8Hia/hip26bZV6V8?=
 =?us-ascii?Q?vHVKFwRx3iU3CRhyz9l0DTMNNnv2IuGlIBtNgL58tuuFUQ7mTPu4/++7B69p?=
 =?us-ascii?Q?gMWBK7+QYGM38OfYD/B6SeHskkRo/EPCT+W6LnNUdtIBadZK0hYV2yAXTPvb?=
 =?us-ascii?Q?eQq7DkwzH6JRQRah5TvT2/4Oemmw+rQ4aE4uhq7iL/o30tgCm/5wLnUgXPuE?=
 =?us-ascii?Q?lP2ygsZLfp0meYXbMyqnllI6PgSEUUNER/Vf8PxLDSMXfFvPPpF2Jancbd/P?=
 =?us-ascii?Q?TQh2TDdIyn/FViv5c6bIoL+Dk46iQRpL4SKQRs9PVYZGiE6Z552xVDVDL4DC?=
 =?us-ascii?Q?lDkSRYCfMaP0ZUEsafMENuH9Wtl7spCnzTdsSrvtMPWIWIIOzvrLldl/qkbt?=
 =?us-ascii?Q?S/TBxwypCQF9xfozM0Vj0pWuaRAsOJJsTMj4Rb122M+H4kPPnHS5e8wwhdLC?=
 =?us-ascii?Q?X6aW/NXw9UcsxXE0uYDQ0B5hIANZxYol3kFtSjyIqUHNGH7IGZ4B25fti52N?=
 =?us-ascii?Q?vrdb1nFFRBnLY5IOwbnhVHD0b838Y5N1nUWvYFbTN6eoFiCuSepBrvKF0ZTT?=
 =?us-ascii?Q?Rt/c0/hRXJSTqbUPd1nxUMRngOVL4UfZb5Qut8Scj3X0GVkxKAEYka95NzZU?=
 =?us-ascii?Q?n30bC3CW13M1p+F5nEhnthCqb2JOnJg9c2CYrWNZLB0YcYE0DHv4g+b4X6d0?=
 =?us-ascii?Q?8pP7U6fz1o5y5y9RnQTBQOZrY7olAn8xff/iYTIro4lxl3GPulDEFciPWqnm?=
 =?us-ascii?Q?EzPjX8qq9HnL0OK6e2GF0T4+aLamXTyotz3fMbiv0BPW9GxGjiFY4quucJEn?=
 =?us-ascii?Q?+DT/K5E4tMzhWzE236dfXV+0nLJ9+VpodPm7WieXcS0WRnCcyU4ux9VxFwUY?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c043e4af-7a96-4e62-d5e2-08da793cbd6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 12:51:41.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0DCPSFQA79T34fNIKTUn+2Pb75W/BodpkdrWpuaeKEXEndHn0fXKou2RuRt4ejXq6r5X41zMSk8kh9TDBT/Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8405
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The way in which dsa_tree_change_tag_proto() works is that when
dsa_tree_notify() fails, it doesn't know whether the operation failed
mid way in a multi-switch tree, or it failed for a single-switch tree.
So even though drivers need to fail cleanly in
ds->ops->change_tag_protocol(), DSA will still call dsa_tree_notify()
again, to restore the old tag protocol for potential switches in the
tree where the change did succeeed (before failing for others).

This means for the felix driver that if we report an error in
felix_change_tag_protocol(), we'll get another call where proto_ops ==
old_proto_ops. If we proceed to act upon that, we may do unexpected
things. For example, we will call dsa_tag_8021q_register() twice in a
row, without any dsa_tag_8021q_unregister() in between. Then we will
actually call dsa_tag_8021q_unregister() via old_proto_ops->teardown,
which (if it manages to run at all, after walking through corrupted data
structures) will leave the ports inoperational anyway.

The bug can be readily reproduced if we force an error while in
tag_8021q mode; this crashes the kernel.

echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
echo edsa > /sys/class/net/eno2/dsa/tagging # -EPROTONOSUPPORT

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000014
Call trace:
 vcap_entry_get+0x24/0x124
 ocelot_vcap_filter_del+0x198/0x270
 felix_tag_8021q_vlan_del+0xd4/0x21c
 dsa_switch_tag_8021q_vlan_del+0x168/0x2cc
 dsa_switch_event+0x68/0x1170
 dsa_tree_notify+0x14/0x34
 dsa_port_tag_8021q_vlan_del+0x84/0x110
 dsa_tag_8021q_unregister+0x15c/0x1c0
 felix_tag_8021q_teardown+0x16c/0x180
 felix_change_tag_protocol+0x1bc/0x230
 dsa_switch_event+0x14c/0x1170
 dsa_tree_change_tag_proto+0x118/0x1c0

Fixes: 7a29d220f4c0 ("net: dsa: felix: reimplement tagging protocol change with function pointers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b8ef3f333520..9aa47752369a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -683,6 +683,9 @@ static int felix_change_tag_protocol(struct dsa_switch *ds,
 
 	old_proto_ops = felix->tag_proto_ops;
 
+	if (proto_ops == old_proto_ops)
+		return 0;
+
 	err = proto_ops->setup(ds);
 	if (err)
 		goto setup_failed;
-- 
2.34.1

