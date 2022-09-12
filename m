Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223FF5B5F8E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiILRvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiILRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:51:17 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D43248C7;
        Mon, 12 Sep 2022 10:51:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi32SPiK0hfq0cddzoTIIJrgKJjIRYOh7L9tKZRoKzIyaaX8rV6Ozn3qpQ3nTLF1DWHHEsZUqrFevKoqqqcegG2P6dZys9nSRjtWjZ1Zgl0zrWH/jFIvBibYgEe+Gluz+P05scVCbRaWpCKqLsTljRI5q0vIJ2Wnaxrm8zsm45kwuf2dtfWL7waiet2pJXr4DkyCL3gNtvzo2mOjL42u1HMKhHydf5qH2t0OaySGHuKorj0EPgzShCcrY5pnd9MuRR+NW3GEE3xSlbF2COx9Yc1MSHg0u+KSYJukl8NsXGPEI8AcK8I9+jn1+APmG0+vSLcxAaBaqHX4EpwodNsyqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0x1V+/SfQo+wv8jI6QbUpDLoiVDSHRvCcYTnktmLGbQ=;
 b=FykxYeQ0EzprHuscA3Ypgvu7aeAdzjCxJBG+HVf91BlS6sWFYaZUAXyLUTqs3N7WYKmG5y2rkWLhJdo9qEBQDpk/voshg8FGKNwk5W0/8jNuwwBn0yqkQNiFjQ17WIHPCrpalfwUVinmBcE4h7p/zD3br+x+5JDj0NQUntTVe99f00ZPEWySW67cUGesEam++9brAK+KgE6sqc4+VJfx4PFxU8JUOS4xJcsLW7iRAvDleNiq069/ACaZ/FuGaxX7aO22i8l4r/yvdyuj5yIqAdOQeyX8eq9rf11R4psSWsLmRLYPq1XZ0zvhfUUosGkJuYmMjWQSGitQuaHmXTvSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0x1V+/SfQo+wv8jI6QbUpDLoiVDSHRvCcYTnktmLGbQ=;
 b=e48aplTuZ1mUZvE9vf702uYqYggMHBoUNNB4Ej6Z//fOq7pygbGHqJ8H7rg+6ae8OCgVvTf4I6EsDvmDul8q1A885gVLVmMCo0DD4ONGxsQkqo7AhV3qLj6V+x8omiHUF2h3MdzAW04QBOdAGovWELM6QYihBRb21EJzCRnonJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8687.eurprd04.prod.outlook.com (2603:10a6:102:21e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:51:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:51:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH net-next 1/3] dt-bindings: net: dsa: mt7530: replace label = "cpu" with proper checks
Date:   Mon, 12 Sep 2022 20:50:56 +0300
Message-Id: <20220912175058.280386-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220912175058.280386-1-vladimir.oltean@nxp.com>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8687:EE_
X-MS-Office365-Filtering-Correlation-Id: c878e44a-54aa-4826-5bc8-08da94e76214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9PpMj0DOZarK8Wf+fKp8MDjJ9U6CyXJyJ1MBHjHP1CBGOu08XZ3YlQD4VTSPK9G+v0DIQi/RGqNs2Xs5EYLN69ch/hzp119Gwxhn2JVDBanhle8x4lkc0neW0NAMqdo2OreApeGBlQCo26YQB2PdhIAX7eHgWlhGBPDmJHZghmWql4FEl33rHeGRGhqQBJHH1Q/YC0YaTvYb1+O0EucX7rnnSgnNmBO9Ckl71K3NqImsVlmqjzX3YFUONK5sadu8Xl1ZZEDOewMkPxJGlU9tmxjxGk9RSSY4ok4frvbG0UMVSHAXOp6JFo21bZQm3g+TKUPtyCzvv9AJLK1TABBkADd0CYsS6Mw3MhKFJRW7p3nUXvPp+dVkZ1ycn/lWiNBCkwG3/cK0yTjqxZteo3EbaYdqlYu+YQbim7nvdsdGohQ1Es52KORcL2IxhtlAf2reliZ33zI6HS+J1UjnYTH7ZCeysWeDnlgB0FBH5nS5bZtcxvvgOv7ZSL/PnPRu9noTU037vrZhygR+2TNa/wfz+m5aNvWxQ27cOSbe9248GNGXgK+GF/r0R+l8gwJz3Jmup9DunGW/9AazetIzKdUMZvg4q4ChPAq8gA+IzVYY2k6fWF3wYUmMVvmUhUlYjnwyJP9mrE3t9IdIkacmItIBZEvCNxWweIjO2pp3A0n6wN3NdQfkctLhBT19jN7zvUSTM+BcUXNEr3kIe42UGG8/l6Xf5yLRmQhLHRdJs1cRAi/zCxicPTQXe5ajex3jQDEoJsvMMTufRQMVdVLpU4qpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(6512007)(83380400001)(186003)(1076003)(6486002)(26005)(5660300002)(8936002)(6506007)(7406005)(52116002)(86362001)(41300700001)(478600001)(6666004)(2906002)(8676002)(38100700002)(2616005)(44832011)(54906003)(66946007)(38350700002)(66556008)(36756003)(7416002)(316002)(4326008)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zAqTpSxPMRo1yG3x0ck0zaPPv4/HT8X70f6UK6Wv2ZhOEQL0AXM5EC//2Lvs?=
 =?us-ascii?Q?7xYYst97iN2zUw5LsGP1y3jiTptXN6MZd7CPiGO1OBQm8OZN1lGMcPvuthuM?=
 =?us-ascii?Q?3qzB2qTGt63uPI5JruLkL712HHzEcyOOrSnUsf+Z5ESwqp4koeqpMwETdhwe?=
 =?us-ascii?Q?fy9dEMcvsBy6GrZot7Z5OB/cY44eOKjp23QBGA6B95Tw2YRgbOUej1LY5HXX?=
 =?us-ascii?Q?P3wVci+Az4b+qAVlIrwxFbePXixZ/rRfZly36P4OyDDlLwCKIJjkopPD/WTN?=
 =?us-ascii?Q?JBoUGbesRA/m6zj/umTDx6JQ+TrPYFxg4L3me4O0SK21MHpqyDsVsL6ylEw+?=
 =?us-ascii?Q?Xwu1VSJmQeshubE/G/pvqjvw2Lsx+Fce7AoE1otjekG2bI87sO3coffcVlRg?=
 =?us-ascii?Q?4mt4AmvjuhqWJ9MURFfn/euf4NUzYkLduhwOJbhkSfgHJrpv/nhiDlGGbeS1?=
 =?us-ascii?Q?2DW5aJiMBd8yjL8+zrviHovG9yilWQV1kcuap5ezKFH3NaRWXgNCgAabJ7q5?=
 =?us-ascii?Q?Pu8ObOwC1Hyk+OrtO2J0NSXG5zWl+uQYDsvy9a+FKg6OOyUwDjdm5tSrt/RA?=
 =?us-ascii?Q?EnBdtseX+GNohJ/rEQklW2WB38UojCQdFaRPPyjhwkSOTdbdupAnzfNS8aOP?=
 =?us-ascii?Q?dfbo8LBpiJYP1Md+XL4wQyWHXRx4bj/ctLnw9fbAUIJFrNxZi+px/I6I3eur?=
 =?us-ascii?Q?3Rs267dQQmjOqi0KqQRkLLmseu2Hf30lOICSs8xfEPSKrSbgOjtGL7OWvnar?=
 =?us-ascii?Q?yt/KtsipfpSVBBD2lU/zPyFK3lDrUI5bXx/0Pb/5XkWifX174mxf8dgzEg0R?=
 =?us-ascii?Q?PvHqnAtVDyXsXoheGvX+CR/dBC8977hNalYpZIB+7QtiEr9veBNg7iDxYAC4?=
 =?us-ascii?Q?rYDz/IcZcJ9rLFr85OhzYZX10aK/fTMlqoODfVW4BomIBfs6wd2QYYTkZEph?=
 =?us-ascii?Q?TyujS12QXaKJzHi84zfPfTynLejQqLJJCtvYtkoqF6EFqQBE83Mw+JiH74cD?=
 =?us-ascii?Q?oMHb+vTE74KjVhd+fCC/DgUB3INvhvpfy6KElWjJrsWdF/4/lgkgKwaOroH7?=
 =?us-ascii?Q?4IMWiYjZx+fjM2kVJLbsDRciMjpqUELA/IfoSgCoshqAw0hAllRN65uOw1R1?=
 =?us-ascii?Q?uRMAzC5eE5rtNd6jFRFIOwD1eKPNrH139hgUgj56EUyRO4fjxSQl5G06r2ZM?=
 =?us-ascii?Q?2yF/jIikjkUMrfcR/Xp3dplv4uYUM2i9eAyDJ+8fcPRZHqE9RA0pPsGrqkoZ?=
 =?us-ascii?Q?aM0RGjLa8eHQyMtiueNccpY0L0anAmutV3WG3RI90EHdlEFm6Fd5GqrhEWGM?=
 =?us-ascii?Q?wk6fcRtsD67JbaKOWIpStuxDboPKYpPr8OWbPg3EQiGuluUUS0PH9RXLbHiF?=
 =?us-ascii?Q?KYArM8cnycD9iPiNElzLCcaR0jImEkCDVdh5cUWO537+RA7JA8ybb7DCAS0h?=
 =?us-ascii?Q?vC1lzN/9WvjP9NiqyOSh7BXpvgPggQ92PIQsW7dDeMdCo5IBuZ2rjlXO87er?=
 =?us-ascii?Q?xxc/hAtta4ixamlMbml4mPBAecu6faB+Mwi4K2BN5bf8YbeD5/6rgim0nMD0?=
 =?us-ascii?Q?0xIBoB3NyQ58EGr+mcTl54qu3Pah4KcJmnAtNlouoNEdL85wO6n7zkaHb4Xz?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c878e44a-54aa-4826-5bc8-08da94e76214
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:51:13.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cz5MEJCU7YukC5kR7jfC1hMV3M431mvhFeMj8iGW0pa3IOPLlpWFjTW0uQyn2kIeHKPJA+yxxWAT8qqhWfdtVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8687
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fact that some DSA device trees use 'label = "cpu"' for the CPU port
is nothing but blind cargo cult copying. The 'label' property was never
part of the DSA DT bindings for anything except the user ports, where it
provided a hint as to what name the created netdevs should use.

DSA does use the "cpu" port label to identify a CPU port in dsa_port_parse(),
but this is only for non-OF code paths (platform data).

The proper way to identify a CPU port is to look at whether the
'ethernet' phandle is present.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f9e7b6e20b35..fa271ee16b5e 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -163,9 +163,7 @@ patternProperties:
         allOf:
           - $ref: dsa-port.yaml#
           - if:
-              properties:
-                label:
-                  const: cpu
+              required: [ ethernet ]
             then:
               required:
                 - phy-mode
@@ -187,9 +185,7 @@ $defs:
         patternProperties:
           "^(ethernet-)?port@[0-9]+$":
             if:
-              properties:
-                label:
-                  const: cpu
+              required: [ ethernet ]
             then:
               if:
                 properties:
@@ -215,9 +211,7 @@ $defs:
         patternProperties:
           "^(ethernet-)?port@[0-9]+$":
             if:
-              properties:
-                label:
-                  const: cpu
+              required: [ ethernet ]
             then:
               if:
                 properties:
-- 
2.34.1

