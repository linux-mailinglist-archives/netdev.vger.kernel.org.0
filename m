Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9424C4150
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbiBYJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239004AbiBYJXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:41 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E711E1A8C95
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4JxjOrCIbsS9rrDaWvhOB5R3lihSFUbBVIiVBF6iF2ZUoJ9FbWMkM6/YrW5p2WxejOmReLSKMzvHCNVJJ3YxyggmOV5QrX8tZg8DJnCdmydqo9abNfqs+AnK8JuahZESkHFKfq/gmICgvYKmAByqVTJs6LlLpdW9H5WDCigTQQ7lVitDreukt9M+qcHbtJDWk7CYG8TwGAVWa/Vb7k2+0AJyWQ86OuQfItWeQAgoABQ/axW4S+kTMjcO6JvSZb/JWdhbadIobzVN3A14mV6p/XvnWhf3i7C+pTU4UIY4ifP0EsF1fJYV2LaViv8xCTpFcvPPai11d8hMqDqK16ASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJuL5fE9ijbCT8XWpvMOIjWBI6p8pseAE2dyCUqyjn0=;
 b=IRb4xYpuqONNYS3/E/2+YmZoGDyH6HE6FnDLApW/9H04YhYq9UAzfONRvQdrzL7cFc2ZsOk6EP313HAX8pWtcDlwog6Ckwfr0C8rv82vWgj9smfTOxq8W8P3Rm42PqODBM7LUgJfV3SrGlCo2j9tuhF65HTXUahkVp3+JXcoC7jwYiRj1zbqXKA2+WzuRaxj/2+xPCsojauMGZxcXs1zViuA5Xu81KIHuN+HNb7x15820zjd2iaFoUieH5BbR0rjuUaxt/NVmrjw1z5kOJmv18xCgu4j7Z3fNNtOp3+sYn5vbUj8Y2D3f1amGfnoILD86Km0iOB7z8ExYrQ4hzZ9Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJuL5fE9ijbCT8XWpvMOIjWBI6p8pseAE2dyCUqyjn0=;
 b=sXeYRZoXbesJl0axj2lGNGH9OwsCskDaAFvTKhNZP7J/ZWRYxBX43jiE1spcnF1WNR/m3ofeKDUY5HU48OgGW5SKPLvicX7mAOUGIqqq9AOKKbB/ArXvjjhXc4dmlV+41fLwPj1RNq05LfPaXWyRZSHaXyndj/FL7GjUlZW6PxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 04/10] net: dsa: felix: delete workarounds present due to SVL tag_8021q bridging
Date:   Fri, 25 Feb 2022 11:22:19 +0200
Message-Id: <20220225092225.594851-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d4763eb-dd67-4a54-b607-08d9f8406d57
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB76580A76266D24DB9218A559E03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rE2hHn91PCZcrAaYnt5DCwn6Ei6DBLFoEyfxif30JeqjJM/v17jRJKIen0Owu+47rNrAlmQ5bHIejd4WUxAJEfNuajQMWgtF8Ue+JlkBKHw+S4w/M0j51PHw4YyEPL/A5a2HqsBsAPrJ2rTK3JGFVCEIQbbtHl6kz/yHCpogfKHPcfO3fA2EK5gokdNvk8/WbMHVedYgk0fXcl0tQgSXQQvonL0sGSKOOFXpwtDMmiJNkN3rt1b7xBTIrRYSWOo+1Jd+Cdu7wqVhM46JCnn3UkAl2wRBuBqSq1n9UO5z5vpZs7VRMLy+wnodRqdh3Ieaq2vnxYgqG9OepS6EkqIqU3WAxwjNzrxgBhovKJvbouKXpsZdpJi501JejSEyQ01Ov5dnoBROfE7xkG+KUx7i6TOVjbZmF/C2EbHsVejrERtXkfZC57CvlkoxJTIA620Kq5VHEUir21/HBx+0foep6ASu1sq/2XKvnWIwMkbXaRckp+Irjq1tzAw9S8d6owXgp97wbOViI2uR1RsXYrkAEamfvSLVGbBDGkd9iSWLgqlDZx0BU2JxvlGSUML04w3wA0LEPHyngDWz0zM+mohvP1HrOh/F8JTr9W/gIHZbbHsEBnBWWg9lQXRuUn821kTbEVSfWg2sjxtdiYQi5x/o/jFDnYNg5AytJl+13V1qMl2m374qwloB4dUEi6tb2b/YdGw1dkZHQbYHt02omR7D7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AVy5+PQ5fiUz+cToC+425YBazWj3uOpouq9+ZyXqB2YFrGj7CkfCMLjAie/L?=
 =?us-ascii?Q?U78NdT82l5x502qy0WNqwzAYf9uX8jeYsug5weAUXyPwnxKHXl/RU9v+CW3a?=
 =?us-ascii?Q?Rphwub9Cc4qz5Smk/IaEmqxn2KO2wpLD/DOLkBbmiA/jlR2i3rzBYPDAfjPZ?=
 =?us-ascii?Q?mTk5o20MK4+9H80Lic7yEoa0Gab9xcgjpQk7ztHBM9dIdHxFE7y7IiOy+iZW?=
 =?us-ascii?Q?RZWqcCocO3wYEpq31C7hDmUo9SdzykAa3GvAaocJzJIw1T3jzbJn9wE8vVsO?=
 =?us-ascii?Q?JsAErvymGpZB6rHUwSG+IlpTG+zIGBlXyRCShFzxU3XiVGQnhnz/PHACZiOD?=
 =?us-ascii?Q?7xE0uFyeW+yyO+kHLDRUiMu/D6ZfHjPuKMUiXMvchMPAO13llLx5MKoLQhOM?=
 =?us-ascii?Q?c/FpQm3BleYYAO6HUeNhu+W58rCqbi5bRhNQk4WXNVgKVZ4qytB8+32tgIKw?=
 =?us-ascii?Q?wEX0OfMOpQX6PcJfRYur1mNyejudUx0nM8Cyihg5dPFHRbs4Qtfcek5GVV3Y?=
 =?us-ascii?Q?yZ9vI/tkyyjQbXXcj5t5tFt8oq7Jw7VPthcRM/G4ecwgC+eC/7nv09PKYtdc?=
 =?us-ascii?Q?5HEisv2Y9I47o9IKIErhKPWuDdZ3dueIdSvj3B/qHIa3UEiXSAxiCXnXIVuM?=
 =?us-ascii?Q?nZnL933BR1iwPZOYY4OWnOlQ+7K6D86aoIjSN0xjlmh4iCqmoKuyR7gV7/MK?=
 =?us-ascii?Q?H2GVArwEcWfKLqY2fqMY3dAsehztQX+7Jeb8eWOe71funPil1z6qplV7TOvd?=
 =?us-ascii?Q?keqM8PjXeFxohL8Zm8zSw27X1Y0k1hSAfxtViemx01q7aZYg23HK8hCDnKVv?=
 =?us-ascii?Q?+olOc2sQq1/JUIZqPmP5kuBWIniJh25nhWdJL/3LibKYx+ILdfvGb5w2wV9A?=
 =?us-ascii?Q?qv58meXnAmLQfFLWN40blIzU8kNLICB7Rykfbh2ebmIihHIc67/6wbDVEzLo?=
 =?us-ascii?Q?k2nsRAGH8WaAszYc1RfWGyJiz//H5lKMKxoJQ9hDzNuFg+sdvDISQTmqSbci?=
 =?us-ascii?Q?Kf/+FWyJ5BuJf5RCk1JPNizEGqzE3PCgoHUGi1UjT9Ft18ozUnJELhVV7ydg?=
 =?us-ascii?Q?D7AWC92+Vk8uyO/xGiLVmwS6HbrUsUL9YgGZ09/leomjOjJpBAkPC71B+5zM?=
 =?us-ascii?Q?apth+NpDP1unxAx0WWwnct/3DWPOObTHX/96cKpweHj7oYVA+SyJ5iXjevas?=
 =?us-ascii?Q?U1A77FPInlBNPQMfH+BMiEjmQ/9FEy0bXIIpPdx6yrmu0X+Hz4M2AFXDNtjt?=
 =?us-ascii?Q?jmsyC3nj3zIiDJP6pFGtcDQ7A4vaOjIbXZbA1d6eelQyGf88FYHsQPMQQUSh?=
 =?us-ascii?Q?9ktxOv+MxnxYuEUpnoKRplOorHlDqPQAf7PKPNmR8TCzBZQBe9rW4JxEQJye?=
 =?us-ascii?Q?aAuJBArMUn6s00EmGaQ9n9SjI5xa1mkwgeCLkt550XVJD6zLfr7P2ed9FWKf?=
 =?us-ascii?Q?krVCZ2tVjBSjJZJ8LhrmYnDNCGZWjSd9VZ9BZ9mAure7f1IZMzHuPxK5+W4H?=
 =?us-ascii?Q?T+VicfnFuErCgv6wcIp4JXhOkxkkFwULH2LgU3nSznZprzbGOmtaBFvXDNPd?=
 =?us-ascii?Q?OWcpkGeXoF2Z7nrgyVrIu3d2hWaiuEY/oB08QBrAiq9sXpAE2+edrw+rFAm7?=
 =?us-ascii?Q?3ylZM4a/L429y08aseZonO4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d4763eb-dd67-4a54-b607-08d9f8406d57
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:04.7258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikSFpszT56TfP3r2BoxVocETv2wl8hPc+dcMs/LG63EL/zOu+8nhnTpLvWb39sIzsQZ/E6DPW/AxBphqohrRAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix driver, which also has a tagging protocol implementation based
on tag_8021q, does not care about adding the RX VLAN that is pvid on one
port on the other ports that are in the same bridge with it. It simply
doesn't need that, because in its implementation, the RX VLAN that is
pvid of a port is only used to install a TCAM rule that pushes that VLAN
ID towards the CPU port.

Now that tag_8021q no longer performs Shared VLAN Learning based
forwarding, the RX VLANs are actually segregated into two types:
standalone VLANs and VLAN-unaware bridging VLANs. Since you actually
have to call dsa_tag_8021q_bridge_join() to get a bridging VLAN from
tag_8021q, and felix does not do that because it doesn't need it, it
means that it only gets standalone port VLANs from tag_8021q. Which is
perfect because this means it can drop its workarounds that avoid the
VLANs it does not need.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9959407fede8..39ff5d201262 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -33,13 +33,6 @@ static int felix_tag_8021q_rxvlan_add(struct felix *felix, int port, u16 vid,
 	struct dsa_switch *ds = felix->ds;
 	int key_length, upstream, err;
 
-	/* We don't need to install the rxvlan into the other ports' filtering
-	 * tables, because we're just pushing the rxvlan when sending towards
-	 * the CPU
-	 */
-	if (!pvid)
-		return 0;
-
 	key_length = ocelot->vcap[VCAP_ES0].keys[VCAP_ES0_IGR_PORT].length;
 	upstream = dsa_upstream_port(ds, port);
 
@@ -170,16 +163,8 @@ static int felix_tag_8021q_rxvlan_del(struct felix *felix, int port, u16 vid)
 
 	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
 								 port, false);
-	/* In rxvlan_add, we had the "if (!pvid) return 0" logic to avoid
-	 * installing outer tagging ES0 rules where they weren't needed.
-	 * But in rxvlan_del, the API doesn't give us the "flags" anymore,
-	 * so that forces us to be slightly sloppy here, and just assume that
-	 * if we didn't find an outer_tagging_rule it means that there was
-	 * none in the first place, i.e. rxvlan_del is called on a non-pvid
-	 * port. This is most probably true though.
-	 */
 	if (!outer_tagging_rule)
-		return 0;
+		return -ENOENT;
 
 	return ocelot_vcap_filter_del(ocelot, outer_tagging_rule);
 }
@@ -201,7 +186,7 @@ static int felix_tag_8021q_txvlan_del(struct felix *felix, int port, u16 vid)
 	untagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
 							     port, false);
 	if (!untagging_rule)
-		return 0;
+		return -ENOENT;
 
 	err = ocelot_vcap_filter_del(ocelot, untagging_rule);
 	if (err)
-- 
2.25.1

