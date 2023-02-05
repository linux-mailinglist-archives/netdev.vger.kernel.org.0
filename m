Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA7468B158
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 20:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBETYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 14:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBETYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 14:24:30 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44AF18AB0;
        Sun,  5 Feb 2023 11:24:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVs6OaMKsa7y2VfY6jC60VqI0E+hHVAgo8tDYLfcKrc1OhvYKOLKpKZIr1lBJzMVQg3efzxegrOtK5nIjgXPjYcxDebH/K3+RprZy74wQZR3PvCcatvsuITzsytzp2G9mtEE1XEaz+yRWQ9QiRdYBSGsQjS5XZ3oAcWGZ0zM1/OfhiozCuGbZyLNlWu0NVWJT6ieQeEy61ScT7tIv18mlDJnDMiVI0Z1NRFgkkCovJqzUwR2O+90SAgFrABKzQ+Z+ROlf8bh0QaQckWjXpzucGsnTA076LmQEfiMrTQIgKbPED9SzaIoGlhB2AHzRtNNkGlEeCr+OGzR1U9M1+czMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmU/tu2P/MSmeO81GfJCsa62WvOvEubPnCXpbuVQ1zE=;
 b=IWNy8ZfbY3N4ar7q6yh/j3x+YzzlxjTn//dKDKLEoMYDS+wDwixdwJuokrDhkLYmRrW6iYDVsTvC0nwMgMMYGRj+nhsdml4Baj5u3ifElFePqlMjLdCaRNZLR4tY2iOjfwGXOIEFpSmAyMrLhFHUuZZOUJTo3q3612R0a/GN+yTJSi7LfYU9E0tOnOyalcT0Mp4FkK+/tBC2AaGh0jSsVH3J1NkA8w3sZxj4plZ3OoS70OATOMzQBZO05W8n2QsVZroaIbdGVD9cncOT0rvT1cCHktasVKa1kA9dORpKh4IemZRmKO9X06AaJ6PhmguZma2/4u26NuErcnWrTUW8Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmU/tu2P/MSmeO81GfJCsa62WvOvEubPnCXpbuVQ1zE=;
 b=fm9q1ap/ZW7qkXffaSyflP3bboP9dbtFEIOxMFOeI3U8AHTCdQtslPDDsBNrY7iBf5Ld4xvRtz0CJy9yHHRWmHOGh9nYF5dtnOlvtGgPS3QX7FBOxUYU/r9N51CZNFWUcQ2sHFnVj/exB/bymYC1EGUk25mGXHpiBnXJ66OJUU8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8391.eurprd04.prod.outlook.com (2603:10a6:102:1c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 19:24:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 19:24:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net 1/2] net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"
Date:   Sun,  5 Feb 2023 21:24:08 +0200
Message-Id: <20230205192409.1796428-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8391:EE_
X-MS-Office365-Filtering-Correlation-Id: 3730887b-ff29-4700-3fcc-08db07ae961f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGhnbL8PVvWjdMDfBb4o0ObxxJTjCPJQ8VPHIqtBejK7g00b33niCm3IyClNH4RdU9J1bvRgvTbdjTB1vzexB60HcppPMzQ4rFNGGXPNpUC1BFaOd4RPwc5OhMGmg2lZ45+zNPgOL/p7dEj2bMwJu3kwqebID6rr2F9V+qBZut3OFsiIxJM0YrNDpYZspbT1pCkw8199ne39RQHVKBLME2YNXeqEGfPv3jT1NvI4SvjXM0F3WmZc+KLFLL8u8OuPzGxagxOOOQq1FtgELYi+Mdzbih9QJHV/xZOttSFQhSczC2dYjnbwzyHlgdQTT/b3qXNBg6wBTEnT5M/tkCN0a5KN8Cdfq1vXdj7ld1QDKRCPVB4foMeNKqRNsxG1XOK+om/yimbUdrplGKrgawFlqCrIT91FrHXuLgmY/8DJOhrwClFrcR/veFZ0PVBnPaHP9gCPvaCKT9q5ZFJhnM+vyKnrRWvqyqbur9NQJx1c/Lsm6utUdWoZ8frtEdnHVm+OSsm5JFG53u1tL2UBvWVKnZ1x7eBmF9L2LWu7WX5LDd/NgenJzPQiFMyMqhAqOpWpc1MiZAqMVtyeZxN+r5/Erkguhby8Bdrsvr752xtF4WUziWvYp6ijDIMNLNSs40y+WF383h4o+LccPeFn+Z1hG0QUJTx3fd2gV8+MYNZi0Poh4vx5pHxYvx/bw7uNMoqx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(52116002)(54906003)(66556008)(66946007)(316002)(4326008)(6916009)(38350700002)(86362001)(36756003)(38100700002)(2616005)(186003)(26005)(6512007)(44832011)(41300700001)(83380400001)(7416002)(2906002)(66476007)(8676002)(8936002)(6666004)(6486002)(5660300002)(478600001)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dh5qobV0J9Gumnfz41uEi4HZNa38ipKWiJ8tEavnyVz7cyLufwTcR60iatbs?=
 =?us-ascii?Q?2XsNgWembine/yuPK5dtiWCloX7bWOCHN42ZtuyIeHtMdCqDfNOuT3Idpny+?=
 =?us-ascii?Q?Q91i1Zr95qiwGHwN+t1LOow+GhSTuHOXGB+L4FcmURkooTsMYxVoKJrE6ajD?=
 =?us-ascii?Q?Xdzu7UZoKEPUkMVkBvX7yGTtVpM0LLHNwsqbckuf0sS1pznycGhNtMcgfLKS?=
 =?us-ascii?Q?ySlxB2js6oawgZysp6p0E0h8/O4JjNcT2PS08c54hS1Pju2ucyfHLiba0+tP?=
 =?us-ascii?Q?qwPthFPe2cLO7+JjtuIuLr/O3d5cLRmUojrN9u749nhGomUx6yMfNibMtrJC?=
 =?us-ascii?Q?HJMhfWooEehGrbLomrixSZVegk3u9JHFOQOh+pyaNjPnQDUx13Dw8z6S6kCC?=
 =?us-ascii?Q?rhH5+6vOFXRZl8cE3Tiqap46G5nrrexxUJOe7YuVLa0/dp2GklaGWvsZtojQ?=
 =?us-ascii?Q?DsXWvh67KCThOr6aIxC64X4zXjFjQOJZBiCvTx35PwWyKMztVpaxlcJkAqGR?=
 =?us-ascii?Q?kTh9P3v138ggzXc2GHp57w9PJzYwdpY4rzqEDyCKWFu7o5PVL6Go6xDgRCrm?=
 =?us-ascii?Q?PfjcMYTC9EPhruGuOpjNkRtohxfVbOgD8ZK2892IyLMGOZ3uQzE1dD7Ti/Ab?=
 =?us-ascii?Q?MsyVjBsNkXd5UtqlnMQTqrP/pKA9UTDSPw27ctasLStVQsfb2aSxBtjflmok?=
 =?us-ascii?Q?/8hnZrv7yHGBw2BDTkyLKyqPylBOKjvoKq1wDzcd9s3OWEswpI/ZpkSMzijC?=
 =?us-ascii?Q?xbZtKzwnH7viuxEx2PzbeboVsC8+ELnOG7TVAVnd8EyWHwOUQ6DWbx8lW+Dn?=
 =?us-ascii?Q?ecNz7NeM73GciHtGD3Wo4C8Ms7HmlpoupIQuDLsiHHNI9MBFvWKDQBZMBM9W?=
 =?us-ascii?Q?dvvfu9rzz1eei5BrK33I4S89lUQoiM+m0uOj5q0P6Kw96Yimj5j7CJbXgnet?=
 =?us-ascii?Q?+iAIZn5+UY6ZAS5cY2o6xbL4s1YVNZiSlSoMygJTkLytrmkrG/ya9MGcFuhw?=
 =?us-ascii?Q?zdx3oTU6zoXXbC61vUzex8s+xn9CdbyKyJKjpO6ezMoLSTmYDSkPxI7ffa9a?=
 =?us-ascii?Q?guUVS/i9LC0Wr2oVDkosdHX9IL3qcPIcYhgArH10durBPzSglJychBHDoLjM?=
 =?us-ascii?Q?7IX+hHeBqv9IhhAL3OsIQ01arZRsMw1waTVv2SDk4hfVwPEE73HnwM380/m1?=
 =?us-ascii?Q?LDwcnhjdQYY9ApYY1xE/Hoy5k4G/vIQ518XioW6dw+x65O2hKMtDiqBnhO1/?=
 =?us-ascii?Q?g1yskzTtpBEOoXNwbMJ1aRDnDsu2Yfgwu/FXoYIoSLhjqM457OmXErqv6dNn?=
 =?us-ascii?Q?gNWiuaqWILihniXEBTfE1e+2s3o+1kxSEjdRTWOtS6QkVdq0Inu94OWBSiI2?=
 =?us-ascii?Q?t4cRoGDncEU/hAMQuZ/rQDkwsHJCVQmooPuxfGgvtHUIOWnHxoW7cIhssO2g?=
 =?us-ascii?Q?4bCPswPqK89DvBQOeR6NIT5+g2wSExPq9iW0wJKp5+3KfqVUVC0FaTG/4bLi?=
 =?us-ascii?Q?+2r4aE4Ir0ipJPDM2MjqO7vv8ng8IpomlqkYpJWNuDF8H9a8jJbE6K842N9r?=
 =?us-ascii?Q?L440OaPzVQj0nwXZ01uvKpyVuuOCl6ctvn14n4iZBnM6ULTAmNWyqFhwckSt?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3730887b-ff29-4700-3fcc-08db07ae961f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 19:24:23.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNwwirSMrO2Vo5jsxTAvXWMjzkPyhG/jp+Lgi2qqfU3eikUOPE1fy8k74VWZSJ3AmZumcxLdtcZLZFF81CBGdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8391
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alternative short title: don't instruct the hardware to match on
EtherType with "protocol 802.1Q" flower filters. It doesn't work for the
reasons detailed below.

With a command such as the following:

tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
	protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
	action vlan modify id 300 \
	action goto chain $(IS2 0 0)

the created filter is set by ocelot_flower_parse_key() to be of type
OCELOT_VCAP_KEY_ETYPE, and etype is set to {value=0x8100, mask=0xffff}.
This gets propagated all the way to is1_entry_set() which commits it to
hardware (the VCAP_IS1_HK_ETYPE field of the key). Compare this to the
case where src_mac isn't specified - the key type is OCELOT_VCAP_KEY_ANY,
and is1_entry_set() doesn't populate VCAP_IS1_HK_ETYPE.

The problem is that for VLAN-tagged frames, the hardware interprets the
ETYPE field as holding the encapsulated VLAN protocol. So the above
filter will only match those packets which have an encapsulated protocol
of 0x8100, rather than all packets with VLAN ID 200 and the given src_mac.

The reason why this is allowed to occur is because, although we have a
block of code in ocelot_flower_parse_key() which sets "match_protocol"
to false when VLAN keys are present, that code executes too late.
There is another block of code, which executes for Ethernet addresses,
and has a "goto finished_key_parsing" and skips the VLAN header parsing.
By skipping it, "match_protocol" remains with the value it was
initialized with, i.e. "true", and "proto" is set to f->common.protocol,
or 0x8100.

The concept of ignoring some keys rather than erroring out when they are
present but can't be offloaded is dubious in itself, but is present
since the initial commit fe3490e6107e ("net: mscc: ocelot: Hardware
ofload for tc flower filter"), and it's outside of the scope of this
patch to change that.

The problem was introduced when the driver started to interpret the
flower filter's protocol, and populate the VCAP filter's ETYPE field
based on it.

To fix this, it is sufficient to move the code that parses the VLAN keys
earlier than the "goto finished_key_parsing" instruction. This will
ensure that if we have a flower filter with both VLAN and Ethernet
address keys, it won't match on ETYPE 0x8100, because the VLAN key
parsing sets "match_protocol = false".

Fixes: 86b956de119c ("net: mscc: ocelot: support matching on EtherType")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7c0897e779dc..ee052404eb55 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -605,6 +605,18 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		flow_rule_match_control(rule, &match);
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		filter->key_type = OCELOT_VCAP_KEY_ANY;
+		filter->vlan.vid.value = match.key->vlan_id;
+		filter->vlan.vid.mask = match.mask->vlan_id;
+		filter->vlan.pcp.value[0] = match.key->vlan_priority;
+		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		match_protocol = false;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
@@ -737,18 +749,6 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		match_protocol = false;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_match_vlan match;
-
-		flow_rule_match_vlan(rule, &match);
-		filter->key_type = OCELOT_VCAP_KEY_ANY;
-		filter->vlan.vid.value = match.key->vlan_id;
-		filter->vlan.vid.mask = match.mask->vlan_id;
-		filter->vlan.pcp.value[0] = match.key->vlan_priority;
-		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
-		match_protocol = false;
-	}
-
 finished_key_parsing:
 	if (match_protocol && proto != ETH_P_ALL) {
 		if (filter->block_id == VCAP_ES0) {
-- 
2.34.1

