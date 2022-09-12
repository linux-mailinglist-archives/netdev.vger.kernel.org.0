Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D665B5F94
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiILRv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiILRvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:51:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B1627CED;
        Mon, 12 Sep 2022 10:51:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heTzOwk/z6nqPFqqcORukiYQ+JPk74bmL2CMDf385Ig8jstQzSxGboruY+bRcglAmfIdAAWdzsE+1cVN+PBQf1BIiSGEXQeybfhJqdoDa5JH5RvMI+B1Rxvf74UMy36vTKZNhdY0tQdyfjul1XBYz1PZalP2dhrYPlK9hs7p9+BpvGIXkR39oVjTpdbkZXVNHIpVIUGIH4IGnvYdBMhVkwMkVR6TJ7ZAfP4kc2yWXkbHCARMNWIujgrPB58L5sou+SQiBDlsfWYnJAEHstrhS6GIcgXZoIiH9IqyhnLCwIiLgHEzgZ167MIE5zcFaNz/znzouvO1IXVXjrsnd0F/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/xYCfZWOEP+aWJlbwhyzxJk9Ora2yWg2MB9L9L+3WE=;
 b=NVpv1+Lcz9HfxGS+76dVuliKKjofButz2rdlB+6Nf7lRCAPPf3XfrsO6M6Hmc4HOYMcERmZKDUTL7V8JpD0gwjNtJmtjVj2X7sYfY6fVyxHw8KcOpfPCJiEOxRjAq8C7EcCaINpXybi8exJQBByFD4Fl817m0aUgVTk+v6DKyu7achJzTTBUfHu48+6FDl69EeZB5vATMoUeV//0Js0GIq1HUEa98JrKeJ8HyHNvNmdt/5lzMVcPqk3ozrvJRPP+EjE/Xl3JgWuxHQhImXpLqFbTakZ2GWpvrJJvw+yVLuoSn7qel8b0zY2t2H7SYoJmLc06jHpPyPLY2zyf+bV+xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/xYCfZWOEP+aWJlbwhyzxJk9Ora2yWg2MB9L9L+3WE=;
 b=AJYo9h1fpgil51DcG/ZYSZ2zGqtP6tKraE/L3OnWbOvRYYbVJQqw3gdETl2/OBMuLVDJr4nGt0v9+ty8Fl0JzD6LMAe5C9oDy2Y2FtvUzxoyuiqYK4ZU9q+zgdRVo6lyU3uDLvMeV/zTj2vHT1tZxOlTwd3qMRnY54l2lksZ5Io=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8687.eurprd04.prod.outlook.com (2603:10a6:102:21e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:51:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:51:17 +0000
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
Subject: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu" from examples
Date:   Mon, 12 Sep 2022 20:50:58 +0300
Message-Id: <20220912175058.280386-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a17d7dba-0e6b-47e1-35f7-08da94e76461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KU2u64JXAD5UfaLUnuL225XF0LQykNEmOszaj57IVt6govtPhjslH+jNuE8yyaApB7g+GdLdZL4Rzk98g7x/BDKd4O2QrOI+aDM4K3nrUQntae8Bg507fclhukdC1KQO0Tku/kbRde8jLbU8JTDtJ6i4audqtLgXA+a/21rr0t9oQjB/SPcqMAuy+seNoQeGF7mBhvys6Kf3V7FhsZRzMYgOvpDbTEu7XI2Lu4p5CLB6VjZ/avm1g7UxMjM6v2uGKsDbkoKc3dX85lzOktAziwSFlrZhzu7oQ1la2/bCWRB9szvmDlK1yBQUyX5F5en/9SpUZ7Zl13FHURYxa81utrt9mCtvtT6Uc0Ck6rES4ZqgGHOdDxuy0NpEm5M1MkWQBPfUsBRCaJGgOjErdxkzt8bcNv1ZtTTjINQiSLmeAmMDAHC0AbBi09j5qTeOwXHm5yDgqG3OgLNEoIBB9x9WSlhrjh8DJUZsOTKuZRZCi09k9jzRfizE3CVHGNZsfprV2D4T9+n55OpMfimDz5k6JrMxlCHx4Gofa5ZiTgvzqNRVBh3AjrOEzhW8Tjy3m9rIRohSKEY+ZZ9pFdG6yW430a6jfm1H0pGAMhH4GS/o+PbuspvbHL8RcHoh3HH4XV9DZL8ziWuBVr+GKRmX8rjO6hrgOdk7/QUD1Wo7BmhxJ9wD7DhUaEGh6ai6wyDY6SOXfUQxOdprzWE3WLV0qlmC+2GTgy+g+AB/Sem5dNwApVlOM2C9CthIGU7G1gikxRZXWIcnscNgO5j5DkmozjFNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(6512007)(83380400001)(186003)(1076003)(6486002)(26005)(5660300002)(8936002)(6506007)(7406005)(52116002)(86362001)(41300700001)(478600001)(6666004)(2906002)(8676002)(38100700002)(2616005)(44832011)(54906003)(66946007)(38350700002)(66556008)(36756003)(7416002)(316002)(4326008)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fg9moK5AkRhRfSeMeftwCBaZCubr4Y/rz1wqwrO8MKUw2T7N8zgQ5jtw6fm8?=
 =?us-ascii?Q?nUPnxY6hCIW4vtXXwxi2zUYeLemh3nQkneg5YchIr4XgogxTUKyv9FHmbtNz?=
 =?us-ascii?Q?3ctek6RF5IaJeME/HDVIsOKzgWbMJz58uRc6hl1vIaEo1AV9Mfvk+Ppymk+S?=
 =?us-ascii?Q?YohDv9Il2phMcsoSsxKNE6SIfttYDkJ8iFr4tZCOZuPPYtPAJl2jcGof4pJX?=
 =?us-ascii?Q?GHMmrgDH7lDUIKTMG1h5RRFxtH9h/2ON3BR5xDhNz8/4jtVZ4/+diPtaPu7+?=
 =?us-ascii?Q?5Aec/fm/CzJe3Xl+iwNr0DXw1VSX57zbDpfCww34hSdFQsRDbBuHcdVMlaTI?=
 =?us-ascii?Q?/OP6NdrVS7yEj26S3omXKR4mhOaClQZHzBe8GrkYz39M/0GPTTjG17TYKIkc?=
 =?us-ascii?Q?SGQtG3UMv1VjyScEQN+BSJ78KiKg3ZcyNddX3FpWQPLCBuYRdhfHC4ElMhlz?=
 =?us-ascii?Q?sztWazoFJpS63ZKPdumbyvc9yYak3o688lzkzd5U5q1MG/8zLHetzDIhXBWD?=
 =?us-ascii?Q?gp52AKG6R6iqaXratVqoyD3y1IqnNCi2k7y/RUUbqK+3Ib1TUmV6jmrEtSFO?=
 =?us-ascii?Q?cpBjAYQH4Mj7+0oLbBPLlncjd68KtucVQ+Ow34o9vNuist17vISJk00gmjx3?=
 =?us-ascii?Q?i9zQsnT0CXAKUtvC9mNxn7Fsn5+Th52zD+1/3cleINNWIXF1G+k01/ZjFpwv?=
 =?us-ascii?Q?/5qLagxNlaTK5Gxu2VQRGDDQxgM1ZIxA4eCbMoo7xWwDknHDbo4xm+/VyTfp?=
 =?us-ascii?Q?W3sfdVwLy6DbDuynUjToH4n2STIK0EEVaJdtVPBBr3ONfFCwNyow2XYoKnYm?=
 =?us-ascii?Q?iouEUbbcESZYm6rWuOlUNNvoEBJkeu0p+YLLElq177gsutnz8NAYJPXwmypj?=
 =?us-ascii?Q?CvKXOSAFF7pLQhZXeyGrrIeX4JTiOuosWB8bBPfP92V4xEAeIP70Sc1hAlcv?=
 =?us-ascii?Q?bAnsZw41YZ40VBkwtLoPWJb4le2kpqqvAx76X2J7cLlInKj9Ty1bmX3kRRFz?=
 =?us-ascii?Q?FE5ZszXA8ptfmLsl6zACMJOihS3fpB4bHwImZ24pFKGxKXz6IrnDBpDXR54m?=
 =?us-ascii?Q?7Ri9GGaPlLx5uZXCnZYQsh4AoeNKgwJQoC/9GK5VIEpc8SljcsrJ0q+ZzQpD?=
 =?us-ascii?Q?XtA2QlCzKcroVHPFqhDJEgvhIIKW+ZV+JPyh3413pTA2u6JwYWFh9RG3VwX3?=
 =?us-ascii?Q?sJvzQUHrB5rYS6V9bL8shzdwXMhcu9XUe0Fc4hJm51JrQ6+Igz3lj/c00P2n?=
 =?us-ascii?Q?pXhxRb7GADKn5oVEFJGjx+TPiqIKwtTLZdAyPwiHyvFmt3S+tqYflmJjiaRq?=
 =?us-ascii?Q?Ct6GX8TQ/6iM7S+Ksm3Pz0acr06vzs7IhWZMZA3B65YGBCVbM/nWbtycyHOm?=
 =?us-ascii?Q?o5yDkqeu/7KtGAJQNuUJL2Fu3De/B7u66Z4yRtMeh5x8MZlJLPpxVdO14N3V?=
 =?us-ascii?Q?hska9KuMgEa3Za4AMorHWyVOexgEevgZcw77U6tCHd3LphlQ7stul85Nd/eZ?=
 =?us-ascii?Q?oW5s/RkTNQZfVyU4+ZojRnaQ/8LI7OOFA9w8T/qFy1gilF7KoMURX1cF67iC?=
 =?us-ascii?Q?RUROA3uV91KqY7gOmdbir6Y1SbCuwB00qgk0jyrZKOCGsTY619+1Qx0LfoGH?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17d7dba-0e6b-47e1-35f7-08da94e76461
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:51:17.0669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7IXa+7oeRQFogY8ucV1E06sSO0kxoAF5tz3R8oF8Bmn9c0W7HAqTWBSY+4dB4OMg437li4jCKFdVMw7qzXtSw==
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

This is not used by the DSA dt-binding, so remove it from all examples.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/ar9331.txt       | 1 -
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml         | 1 -
 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml    | 2 --
 .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml  | 1 -
 Documentation/devicetree/bindings/net/dsa/lan9303.txt      | 2 --
 Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt | 1 -
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml       | 7 -------
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 2 --
 Documentation/devicetree/bindings/net/dsa/qca8k.yaml       | 3 ---
 Documentation/devicetree/bindings/net/dsa/realtek.yaml     | 2 --
 .../devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml    | 1 -
 .../devicetree/bindings/net/dsa/vitesse,vsc73xx.txt        | 2 --
 12 files changed, 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/ar9331.txt b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
index 320607cbbb17..f824fdae0da2 100644
--- a/Documentation/devicetree/bindings/net/dsa/ar9331.txt
+++ b/Documentation/devicetree/bindings/net/dsa/ar9331.txt
@@ -76,7 +76,6 @@ eth1: ethernet@1a000000 {
 
 				switch_port0: port@0 {
 					reg = <0x0>;
-					label = "cpu";
 					ethernet = <&eth1>;
 
 					phy-mode = "gmii";
diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index eb01a8f37ce4..259a0c6547f3 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -61,7 +61,6 @@ examples:
                 };
                 ethernet-port@3 {
                     reg = <3>;
-                    label = "cpu";
                     ethernet = <&fec1>;
                     phy-mode = "rgmii-id";
 
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 2e01371b8288..1219b830b1a4 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -169,7 +169,6 @@ examples:
 
                 port@8 {
                     reg = <8>;
-                    label = "cpu";
                     phy-mode = "rgmii-txid";
                     ethernet = <&eth0>;
                     fixed-link {
@@ -252,7 +251,6 @@ examples:
 
                 port@8 {
                     ethernet = <&amac2>;
-                    label = "cpu";
                     reg = <8>;
                     phy-mode = "internal";
 
diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 1ff44dd68a61..73b774eadd0b 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -91,7 +91,6 @@ examples:
 
                 port@0 {
                     reg = <0>;
-                    label = "cpu";
                     ethernet = <&gmac0>;
                     phy-mode = "mii";
 
diff --git a/Documentation/devicetree/bindings/net/dsa/lan9303.txt b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
index 464d6bf87605..46a732087f5c 100644
--- a/Documentation/devicetree/bindings/net/dsa/lan9303.txt
+++ b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
@@ -46,7 +46,6 @@ I2C managed mode:
 
 			port@0 { /* RMII fixed link to master */
 				reg = <0>;
-				label = "cpu";
 				ethernet = <&master>;
 			};
 
@@ -83,7 +82,6 @@ MDIO managed mode:
 
 					port@0 {
 						reg = <0>;
-						label = "cpu";
 						ethernet = <&master>;
 					};
 
diff --git a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
index e3829d3e480e..8bb1eff21cb1 100644
--- a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
+++ b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
@@ -96,7 +96,6 @@ switch@e108000 {
 
 		port@6 {
 			reg = <0x6>;
-			label = "cpu";
 			ethernet = <&eth0>;
 		};
 	};
diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 84bb36cab518..bc6446e1f55a 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -325,7 +325,6 @@ examples:
 
                 port@6 {
                     reg = <6>;
-                    label = "cpu";
                     ethernet = <&gmac0>;
                     phy-mode = "rgmii";
 
@@ -389,7 +388,6 @@ examples:
 
                 port@6 {
                     reg = <6>;
-                    label = "cpu";
                     ethernet = <&gmac0>;
                     phy-mode = "trgmii";
 
@@ -454,7 +452,6 @@ examples:
 
                 port@6 {
                     reg = <6>;
-                    label = "cpu";
                     ethernet = <&gmac0>;
                     phy-mode = "2500base-x";
 
@@ -521,7 +518,6 @@ examples:
 
                 port@6 {
                     reg = <6>;
-                    label = "cpu";
                     ethernet = <&gmac0>;
                     phy-mode = "trgmii";
 
@@ -610,7 +606,6 @@ examples:
 
                     port@6 {
                         reg = <6>;
-                        label = "cpu";
                         ethernet = <&gmac0>;
                         phy-mode = "trgmii";
 
@@ -699,7 +694,6 @@ examples:
 
                     port@6 {
                         reg = <6>;
-                        label = "cpu";
                         ethernet = <&gmac0>;
                         phy-mode = "trgmii";
 
@@ -787,7 +781,6 @@ examples:
 
                     port@6 {
                         reg = <6>;
-                        label = "cpu";
                         ethernet = <&gmac0>;
                         phy-mode = "trgmii";
 
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 456802affc9d..4da75b1f9533 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -107,7 +107,6 @@ examples:
                 };
                 port@5 {
                     reg = <5>;
-                    label = "cpu";
                     ethernet = <&eth0>;
                     phy-mode = "rgmii";
 
@@ -146,7 +145,6 @@ examples:
                 };
                 port@6 {
                     reg = <6>;
-                    label = "cpu";
                     ethernet = <&eth0>;
                     phy-mode = "rgmii";
 
diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index f3c88371d76c..978162df51f7 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -159,7 +159,6 @@ examples:
 
                 port@0 {
                     reg = <0>;
-                    label = "cpu";
                     ethernet = <&gmac1>;
                     phy-mode = "rgmii";
 
@@ -221,7 +220,6 @@ examples:
 
                 port@0 {
                     reg = <0>;
-                    label = "cpu";
                     ethernet = <&gmac1>;
                     phy-mode = "rgmii";
 
@@ -268,7 +266,6 @@ examples:
 
                 port@6 {
                     reg = <0>;
-                    label = "cpu";
                     ethernet = <&gmac1>;
                     phy-mode = "sgmii";
 
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 4f99aff029dc..1a7d45a8ad66 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -189,7 +189,6 @@ examples:
                             };
                             port@5 {
                                     reg = <5>;
-                                    label = "cpu";
                                     ethernet = <&gmac0>;
                                     phy-mode = "rgmii";
                                     fixed-link {
@@ -277,7 +276,6 @@ examples:
                             };
                             port@6 {
                                     reg = <6>;
-                                    label = "cpu";
                                     ethernet = <&fec1>;
                                     phy-mode = "rgmii";
                                     tx-internal-delay-ps = <2000>;
diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 14a1f0b4c32b..7ca9c19a157c 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -130,7 +130,6 @@ examples:
             port@4 {
                 reg = <4>;
                 ethernet = <&gmac2>;
-                label = "cpu";
                 phy-mode = "internal";
 
                 fixed-link {
diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
index bbf4a13f6d75..258bef483673 100644
--- a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
+++ b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
@@ -75,7 +75,6 @@ switch@0 {
 		};
 		vsc: port@6 {
 			reg = <6>;
-			label = "cpu";
 			ethernet = <&gmac1>;
 			phy-mode = "rgmii";
 			fixed-link {
@@ -117,7 +116,6 @@ switch@2,0 {
 		};
 		vsc: port@6 {
 			reg = <6>;
-			label = "cpu";
 			ethernet = <&enet0>;
 			phy-mode = "rgmii";
 			fixed-link {
-- 
2.34.1

