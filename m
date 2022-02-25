Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190F04C4141
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbiBYJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbiBYJXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:39 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841E31A7D9C
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=himisrzc7bsDIgQBTK6G1sqFCD2a1BxiFboeFpXUzSo3C70KZ5AZgh1YQ6HgmhXimJfkUhu1qZ+3Wz7gepzoWptt95nEhvc4PcwZAM9fJFhI5i5LtjLVc0coJQvgFS76wxlt5yaHSXHAdBXKqH8EXMH4QIZvuKt5ZTp0j78b8Mr+N1JlaaAeUUWGgZb6/uWzkCIcQOIhpsSZBWxJxdsmBC2Hzs8UuXbQL9PWsl2JskBGvCGymc/ECYYao6uMGsP8minbgiKYslJmnRALHU3jucOwzhZItWDAWdKJfqvRLMjghYqpAo1AnJi5Lo7GHOv5qYoLqsgOeWD1PH2axkfvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+sSeC3GVxo1lCIdXIei1D7d4/wQe9GMvF9alIHL0SI=;
 b=G5nX0uH0rv+Yfn7/bQtjYauijgK0fqHsKgNbiGzLH4UmiZCv3l6FaOVrRJyK7JvDVOK+JfXJ7unTdwAp95D2V3V+3o/95TGfsma+uw3VwbOyJy3htkQ99B2ydv0eg/dhG7/fImtbiaQ4sM9HhyGOMo2xHRwvIEm013HxOmbChHbsDwyvlCj61jE1swjBLwYBXN5aDJb2yxStm4Ajv/BgE2mLpoZH/Y2ZoE3sgVVcp00NNknMNehOIYKub70isvKiSE6ppgzrw/pBODC+TbWbupYCdjdnuQawBReFepQLpsY0FpCFPBJz5vtgzouh3r6LSEL+VAdq3gykNGatOKnS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+sSeC3GVxo1lCIdXIei1D7d4/wQe9GMvF9alIHL0SI=;
 b=XQnqH9PDOQAJH+3djaK473fD0I8rFu3g8SdNkyfolNcPBkxhTyCSjepn4AWZ6J4ysp8fZk/BT4BwamCrKRkv9vTUBsrLAa5ruW6bZalzVODTQdvtJT/vFFg56I3Bka6zURC0vP2/dmt+0y4BE9VENE8QkcWjqWAwfQGQciYJ5oo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:03 +0000
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
Subject: [PATCH v2 net-next 03/10] docs: net: dsa: sja1105: document limitations of tc-flower rule VLAN awareness
Date:   Fri, 25 Feb 2022 11:22:18 +0200
Message-Id: <20220225092225.594851-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a1d3ea30-f42f-4b05-e6e8-08d9f8406cc3
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB7658DDF15F6152C3B81AE38EE03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMPT461jQsmI7eMwpKizKI3ATnreuLytF0nwmai5D+9Gw7RbMMEA1UQS/8hNmLPstDTQJw/F3vdhn3BN8Fzs7FXB28Q+IXSTkKwP0O7l/Q+NIbmmp7NyUVteE9VDE5LQ0MfJEn5lisPt0zzTWgs/+0dwbqfQVGi5Z5OxYGC+2hK+Ra0STMlt1dw150XVD+DH76mf/RieXhD8PxvQYO05MzlTEsWzlzjqrngkfRjp3BWJCD9XUpNH8VMSQVbN+ZJzvXYHzgRCKPHXNSBvZCEIDFofl7DATvpwzrjD5I1x0IDMWqfZnjQoogby059BbSzfYGKtXiBGzSAMxDN6pAiowtUjBBjgl6/TCHISGF1Dsy2heylHwylD66UQSDpUIj3jcSQ8OnY1JmfjXmR7WEb2W+2WMI7oYbgPc7IYLFKVJDK1qgUvOxvNyRtmfwOFLEetgH1bFVIlcLXAOkysAhOdGJeBrGNivyNqbS+ZLWINzw6bobCHuUzhZL2joIZWGX3JCiKwOw0L7KDmkZtKDYudZhNbYBubBvZz/QUqaScb84QZC/VSRouc8Nz98buuY+YHMCRuFX6nd+3KCgmdr/Yxx0hS7z2xJE3BaxqEyFsHUwuOvVtrd8vVvZtxI+e4IX9zyoUZ+HHQN6s2aAcpXsVYCBrNUtmk5TkhvKRfahkG2AFJGhueAXOoTPi5Nn5hgASG5l4DpcstzFRKxygWA1heiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h8KGKt5LqgpJsAM/q819EJpVdyp8OC0GJyaVuYLVVTSnN5qF1vf9SIhqMOjj?=
 =?us-ascii?Q?ED90DAhkJafvZLtj/fWeqC0QAb24iov5eDCz1oGkJzacXLhfdhIbRTv2ND+R?=
 =?us-ascii?Q?FddJE41Yxk/KkMOdKcn8YT5GVdQdtrxymq0IinNOeV1gS9IKuzz/Ajky0zdW?=
 =?us-ascii?Q?f9XIOoLNW7MVXViGQTuPNObQp0D0PtBxF77nvhn6idKcMBQOL3p8/lPjoleB?=
 =?us-ascii?Q?oqqz7OfyurXu097vQd4VfNc9tcg500FZZPFRevJIXto0eZlZ3fIUw0jMnCs0?=
 =?us-ascii?Q?AksRR7SqdTkaZycGdu2SbDcYM//F9h0H3gh+Q2l7y3VyGoYXnFBWYrPTKGVH?=
 =?us-ascii?Q?nDVVhwnNfucKCXkcyaK5l3pfS+PhbQKidYgTrdc92gM1mbZJPkWU9cURe78+?=
 =?us-ascii?Q?U4RDcfHuzvSqIGYTldIL5EfXUo3HPitb9k/mGbrgeVJlUq36iaO+UolWnW8W?=
 =?us-ascii?Q?MyxMBxYPSYnpIt7CMINeF7WhGkFbggAQvHgQ3l256IgPc+Tx2VuGzxpB5dtb?=
 =?us-ascii?Q?6JKhmIhinulqKojn7M+4IWtN/RjBdkMUnkF4fqR6TU1H1OcnaYg3OrN6aGrS?=
 =?us-ascii?Q?OWB7Q7eXCVymcHTEZEgfbd0OT6K1tOCYQuTbXJcMoYIxXcQmRlG1ToxfBTKw?=
 =?us-ascii?Q?HJUK6TdZnqgeoUJgkao/Jnc9QgZR9JqtdXt3MmWOkZW02aOR+3bz7H2tf5CI?=
 =?us-ascii?Q?LemfaAKXIDLrJYmGrIgyY2uD1cNGS5jLoJiQ+3g/3RVlSnXX1jE/RPJIx/C0?=
 =?us-ascii?Q?qS4FqWNRkRmAjrUUwZ13TjSgPHYFzHKkFh6nCxNFyy+O0QDo8Gd6c1fgsOCE?=
 =?us-ascii?Q?IWEtRJO2XVAv3/Sk3WB/mPVIzRqNPKPDz9J7PGVcjy4QzYOUqNuUFtCJ8+FX?=
 =?us-ascii?Q?Mt4/cLTlJKCZmrauJXY01SldwigZBfkWcDlzRsZ6j2WYxcpV6G/YHQJLuoRa?=
 =?us-ascii?Q?f9TAbGBORATvfOdh2GRG+z6lfwW4rzEOiI/h+kBScuV2AlD2a56PudYHr9Im?=
 =?us-ascii?Q?znFMnoSQxfdqoryPT6p2oglB5a0xElqxS7IxEX7FneY1VdQm9ezT+ds+6WfJ?=
 =?us-ascii?Q?QDXk7L6/NMpyvipoDoLvJqMHYiSC1sRu0lTp20Uj6yKOvFcwcfiRPH9QyjU4?=
 =?us-ascii?Q?CxlualgwaVyeFimU1fdOxM+tdwSvUJWYCxcGp+3XtogYlX+SLLT/dpMb2lP6?=
 =?us-ascii?Q?xxeq9MAs7wRHgnFVfhewseqtfcEBaLXRJPoMyZesNVRBGsYbV5uIzZt3MFmE?=
 =?us-ascii?Q?YeXpomWbdeOZzwHitHl9nXTpyWgTj3dmF3XIZAr84yzXzWSmYc36bCJwbO8M?=
 =?us-ascii?Q?Rl/TE1O/GYyJjVpWXxAUoYW0iDBKMfqzVQ650ffPo2DIx2DCu3ZFPyPe7d53?=
 =?us-ascii?Q?YC1pb0mTsp81WxnuAsKVl1x0ieXldewlvEyrx05BwAQiZQiyG6e0DsPKBLxA?=
 =?us-ascii?Q?K5s+7f8w7q0eXbb6a9cn4CdfUrhXe/3SJTR9+HIL/c6LaNewcQLl8D2QY9Bh?=
 =?us-ascii?Q?w/xE9MIiMKoE73ul/E3eksCcM2ASEOq9GnbJWgx9d1EyNYfDfGh4zTB9GyZM?=
 =?us-ascii?Q?CtFVZr84YBIj8EoNJfOpyNelkJBcQjVH28t+bQ0s1ORvLe/esTr+7yufTP61?=
 =?us-ascii?Q?MqUWCaOXGZu37Ch3HSPOlpU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d3ea30-f42f-4b05-e6e8-08d9f8406cc3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:03.7884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfzzLVCSgi2Z1P14rvAe8gRPLhIr7rhDX1IUFQEtGFFGl3lggbQsyy/UasMMmhNY1WgfN3D0Y+qRTjetWoXGVw==
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

After change "net: dsa: tag_8021q: replace the SVL bridging with
VLAN-unaware IVL bridging", tag_8021q enforces two different pvids on a
port, depending on whether it is standalone or in a VLAN-unaware bridge.

Up until now, there was a single pvid, represented by
dsa_tag_8021q_rx_vid(), and that was used as the VLAN for VLAN-unaware
virtual link rules, regardless of whether the port was bridged or
standalone.

To keep VLAN-unaware virtual links working, we need to follow whether
the port is in a bridge or not, and update the VLAN ID from those rules.

In fact we can't fully do that. Depending on whether the switch is
VLAN-aware or not, we can accept Virtual Link rules with just the MAC
DA, or with a MAC DA and a VID. So we already deny changes to the VLAN
awareness of the switch. But the VLAN awareness may also change as a
result of joining or leaving a bridge.

One might say we could just allow the following: a port may leave a
VLAN-unaware bridge while it has VLAN-unaware VL (tc-flower) rules, and
the driver will update those with the new tag_8021q pvid for standalone
mode, but the driver won't accept joining a bridge at all while VL rules
were installed in standalone mode. This is sort of a compromise made
because leaving a bridge is an operation that cannot be vetoed.
But this sort of setup change is not fully supported, either: as
mentioned, VLAN filtering changes can also be triggered by leaving a
bridge, therefore, the existing veto we have in place for turning VLAN
filtering off with VLAN-aware VL rules active still isn't fully
effective.

I really don't know how to deal with this in a way that produces
predictable behavior for user space. Since at the moment, keeping this
feature fully functional on constellation changes (not changing the
tag_8021q port pvid when joining a bridge) is blocking progress for the
DSA FDB isolation, I'd rather document it as a (potentially temporary)
limitation and go on without it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/sja1105.rst | 27 ++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 29b1bae0cf00..e0219c1452ab 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -293,6 +293,33 @@ of dropped frames, which is a sum of frames dropped due to timing violations,
 lack of destination ports and MTU enforcement checks). Byte-level counters are
 not available.
 
+Limitations
+===========
+
+The SJA1105 switch family always performs VLAN processing. When configured as
+VLAN-unaware, frames carry a different VLAN tag internally, depending on
+whether the port is standalone or under a VLAN-unaware bridge.
+
+The virtual link keys are always fixed at {MAC DA, VLAN ID, VLAN PCP}, but the
+driver asks for the VLAN ID and VLAN PCP when the port is under a VLAN-aware
+bridge. Otherwise, it fills in the VLAN ID and PCP automatically, based on
+whether the port is standalone or in a VLAN-unaware bridge, and accepts only
+"VLAN-unaware" tc-flower keys (MAC DA).
+
+The existing tc-flower keys that are offloaded using virtual links are no
+longer operational after one of the following happens:
+
+- port was standalone and joins a bridge (VLAN-aware or VLAN-unaware)
+- port is part of a bridge whose VLAN awareness state changes
+- port was part of a bridge and becomes standalone
+- port was standalone, but another port joins a VLAN-aware bridge and this
+  changes the global VLAN awareness state of the bridge
+
+The driver cannot veto all these operations, and it cannot update/remove the
+existing tc-flower filters either. So for proper operation, the tc-flower
+filters should be installed only after the forwarding configuration of the port
+has been made, and removed by user space before making any changes to it.
+
 Device Tree bindings and board design
 =====================================
 
-- 
2.25.1

