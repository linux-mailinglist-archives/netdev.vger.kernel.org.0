Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772BD5B5F92
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiILRvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiILRvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:51:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DF820180;
        Mon, 12 Sep 2022 10:51:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcX/orYidFZflCHOe3PmieB98jcwx6aY4JyVgbTxkLCPaTLSoAsCXPUifA44NfZgPEw6s3V4gwfIKryKNTNZgRNfviBEAniQcK81XpXV/Bk7myD0OHji9cuL2METzH0PqawHc8Wuol3IuA71P2Pb3Dj49lBWZijwqYofUkF5152YirRl5vt5BwD3p5CAvnl8WICWNOcs5C8pJyt5ir6Gulv72UTjoNnoUcoQDJfYYdRcsMTzlKH4cCAtu75YzhL9Fe1uBQAx4srMC6ppx9LQKU9TIpuwyA4rmkr+QU4wTi4vIzwNwvYALYyONmVyNim21RiLoQdm3wRYVKJsBoHQjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jx1A4D1Y6o0fbbZD2fhcJsEYfNEfqRf/MHgzsUO3KkI=;
 b=GQSrnjkBLJQ/E9ba6b2smzlr2USXKx7mgUsVL517+qOAP/8ZSiFy5/QbiiohdMLyQ9YDHLWTgk0ffHowytrqwvyqN+MNukSoIVEgrs9symuvlQu1a7fggS5KMxVWfSdmJwqyN0DIApkZ4IXPFsK40r61Z18PV/IyOMBzBItAJ2l6FTcj7Y5PfdvuDM9RmVUjsGhHLZSCgSHCOgomAAOCFUs7Uf5+YBAq4yuy+/DaqhDsilEc6nLiq1ecuzooSBjkmLRIFzSOgf7ZL75uBDHNuUNOiLfcRygdkd3OiBBiYy72ioUMvE6yywYHwVIr1NoqeLjm6aTRNKIXnnfYKv3I5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jx1A4D1Y6o0fbbZD2fhcJsEYfNEfqRf/MHgzsUO3KkI=;
 b=LWptx3EnQUphdt8jMz4VZE8h2Oe0qaaEoVtZbA+srssuR6pDombFKslaaP18W0RFpIiVNIzPBMZmy6COi5yLJQd59e4F38/U6FBVi2AM6pOiznCZqKDiiGvYO/Pf4FRwJ4+CCiVFb8ic/726lAiSHSHywM4AgF1VMBNa4Rm4/E4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8687.eurprd04.prod.outlook.com (2603:10a6:102:21e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:51:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:51:15 +0000
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
Subject: [PATCH net-next 2/3] dt-bindings: net: dsa: mt7530: stop requiring phy-mode on CPU ports
Date:   Mon, 12 Sep 2022 20:50:57 +0300
Message-Id: <20220912175058.280386-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1029b7f3-176a-4cba-97a9-08da94e76339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P3hj7MjBdY/+MOeTBpp9qCMmmUm8aqiBOcXk5dvltlDfN6uPUuuFZOaQbexnNG5KElnvZlUQocQOVBQ6SiUuAifac0ck8Ca3sBBNIBMeUB/BPO7qWAYSVjbfzZ96w3fMgvXAeAwq9/kfFPS9XyieAyaMLD83wALTy6DjogLrcqnAM4cpiaA1/R6WVoNDhsc0YifJaxZ6AG0Mo8hWb8SA4LaanasSAkdeLWwaiS/mEWi3spO/w33f3eI34uSGp27yMNlLPRXdD14Oxu3T7fpB/1q9cwrz4yaoKi1bfNhQMkzh6MjdJGdsCxSjqrnloDXZ1lf+8ZfSQu7HZlQE1frZzTZco5DQ6NgQ7nhH64DnGG+EHeKHVBNJ6/1WamAqV6rp+x0gDPBNAZ8aL1B1ve14gicHenNJZXLkjH1bPZwADYAFK5AQTJRwNbbohLIQjZjl8HBUryKUqy8291b5fS0U8KAuduBcYmPFPgEDDe56FW8vx9IxMe12+Gqdapy4YAmQeDTyB6sOTBPcV2tSPEwxV+jK0IvblMznPvCWadfW6iLllUQeKkrtMkyPmFdrBhSzslPJSPd64dspzkLck91PsVYEOiGvnG/rv+YEgjAZvtcyLM1qVH48To8ZBV1H9lwwcBYbq50GoQUOEbQ7XFGZqFoTp+AHbb5KuRf5E3U4kro4AwyFW7hCFcM5+F3AFDsACOEEwYfTGx4NdcjH11fkA1kVbikFYDde8tQupyLqG2sxUPuzueYZ5eTNhw8pbhJlD03Ms0PLcCh2L74UYnkOAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(6512007)(83380400001)(186003)(1076003)(6486002)(26005)(5660300002)(8936002)(6506007)(7406005)(52116002)(86362001)(41300700001)(478600001)(6666004)(2906002)(8676002)(38100700002)(2616005)(44832011)(4744005)(54906003)(66946007)(38350700002)(66556008)(36756003)(7416002)(316002)(4326008)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MK/p/DH4c7Mj9dtnpANwfQ1wEsvJ90iDFc5TxeH0DI+fDQ0zk43wOY7zDG37?=
 =?us-ascii?Q?hj2ZdwW7CiTgwXknCEdfAoKkQepPnGCZCgLLRG/wnw2vpfBYxI8p3P3Ao45x?=
 =?us-ascii?Q?MvPKqCgbpeIDjc3BO889r0q4jgxb9EXt5lIoiwySq2s7N4daKDAkw+FhFJ+9?=
 =?us-ascii?Q?/CNvsLreg8tYkv1+Ha3WP0aQoihUiPibXs0J3yx5XkcDCdbOzbhJ6DZBgxCi?=
 =?us-ascii?Q?Nync4Q2wo0lk9iAcUE4+LCY2F7wIRch2vp0udQ+nrjgMa1zyH1Neali4BYUm?=
 =?us-ascii?Q?btnCuk1tKcWobS2F03DUEWGJaG1sXGYhM6h1T3s4BuNW2ovq2RK19SJCR19s?=
 =?us-ascii?Q?e+PTrB/YNVSwtXJf9u0yUhBfVjRytP6i5S9Oeb5vBDTV0itYZMBR1kMu9CiQ?=
 =?us-ascii?Q?1rbq0j+q9W7JD248l6EhrOOX19LcyJB2YygwhV0Z7rFPsCehEpFQIfqyYOH6?=
 =?us-ascii?Q?EDLrZ8kNDOziRI16NBWwlBg7YGjn1TwiIzQedM5oJc+CeGf1ODa18VYNiwQ4?=
 =?us-ascii?Q?eKrJMJWa1xIrfv0bByyivc9lEiWZT5PkRnkTqMrXarNT/ys4l+MbgjyQTScS?=
 =?us-ascii?Q?kNnUKqM9sMlKumILWsiSMI90luNIJsb8x/QOOWJ5ICFV3PjWq8BBHen4D5VE?=
 =?us-ascii?Q?sCQTECPL+hFDOznQyrtBZuwjtLe3wc359Q6SHQLpDPYXoQrv7K6pAQQPQZF3?=
 =?us-ascii?Q?TG+5W7YrI7yEptazUgSL2RYRWjIjNCDxl6PnehmTbURy/8jdsYhRo6IIIvJl?=
 =?us-ascii?Q?QFBbEs8+CePwEe90b7OnuXRGCjdGz7Fgfny0pW8ekxkeaZ+OBhWKjkomsdGN?=
 =?us-ascii?Q?t8Xn7UKMyaTaJ8goybA6hnhGoeQN4XAzWvS/9LweJrmFojXh8i6M7MMdt+e6?=
 =?us-ascii?Q?mApDJDvwgsoWqp+lnGG8FfNz1sPhXXPWwfoaCKOYXHHKw5uHVrpcwg/JaEFc?=
 =?us-ascii?Q?U8xWkG5kNogYZiVH7UO2+QbjDsiU+8d+gQe+P4WMbQ9ExyUSlL0oHOqFdU9n?=
 =?us-ascii?Q?4yMzd/BClIT5zr1A0iIGENPfmAAUD2NqYloexlBnxazpzU+lMj96OtGVBQHl?=
 =?us-ascii?Q?dfgG8hHvtMIj21JF8fhYFhEpfXbdURlg+llPNqJMTNe5wJpTt0GtoSF9iy4g?=
 =?us-ascii?Q?EVdwyoKmaOKEgsSJ9p0vz4NQuZT3VUDni4nRigWLf1S2UyTIf6kHzD3NudsD?=
 =?us-ascii?Q?sGUgrDrRLM43ii4a+rxxYk3Az6kOzJ5P0bPGGmURwX3AxyXs0a4FfMOBgxkZ?=
 =?us-ascii?Q?H48t9FsaHBp20HSsb8zxeOdmfFAE0wyR5CWyvmcFRIB3bh9D+KYZQ/V05DkS?=
 =?us-ascii?Q?idHA+6rbqUtlUjCMQ5UdwHLs8s+GQDrLTc9SCtfFZGbyAJCz+6iQufSkuxOX?=
 =?us-ascii?Q?8K6zJyXKS4ryBlG0MFlRThgc/gE5aa5Iur0YAYD6DX6WGcsBuO8igdpwRUer?=
 =?us-ascii?Q?+QRSXY/souqAVLL8HZcRwgowdY/ImqTVzCGFxecomFpfaCD2CtYnPTpCoKQa?=
 =?us-ascii?Q?cqTnMiW6mKYMqV1O9lBamVibXthASl026XQj0J+a97QEiXHUbGiNb9nR0bXG?=
 =?us-ascii?Q?gcEifbusGvVVDjfJInFi/CZFTqLU/RrQQx9HJ4CXo2E1f85wP9vht+YBX8Ae?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1029b7f3-176a-4cba-97a9-08da94e76339
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:51:15.1140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uBuaLRnRM3A+0YvRZNzbwauM6Qhhb1QsvFF4SEL2QAs816EhUujyd7I7f6IvsN+Zb6eYtteyNZgFPXyKsZTPw==
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

The common dsa-port.yaml does this (and more) since commit 2ec2fb8331af
("dt-bindings: net: dsa: make phylink bindings required for CPU/DSA
ports").

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index fa271ee16b5e..84bb36cab518 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -165,9 +165,6 @@ patternProperties:
           - if:
               required: [ ethernet ]
             then:
-              required:
-                - phy-mode
-
               properties:
                 reg:
                   enum:
-- 
2.34.1

