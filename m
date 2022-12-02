Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0360640F50
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbiLBUqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiLBUqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:23 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF8F3C0B;
        Fri,  2 Dec 2022 12:46:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yq7MPRoleqCoh+GT7Tdeg++XJPO77E43nt0NZLSMZyahWBiNmHUq65ErCIvtjQWoPYBOILR55ZZxApjtAMex9DuM+QlNohPpWAM5t+7+oMwfqbjbJHhJEkBQMA6BwGTgolqXIcMdz/l0SSVht41QwMTZFft2C3QtrzuYke234AL1H2qUd0TuS+lB0dnrBPpHUipwKuSU7WcDmyb9py1ZDWHqDWjSx/r3fGZAbXkPQ0q2LCjkFcrFUW3wnO7rynvJEr3WELYtgwn7BUwgmMbhcyd9pfSeC16SVqJgcjZ/qbxBqNUvRvsfn7JJ1wYUclD2DVViZNFUi8yJIXH+KQvGuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYbz0ScqR0u+Wgwm+mP3P9fH0olF7XMLqKQkE7hunes=;
 b=RJhnL0qvIe6b0s+Ng8Gi82Khte9BWgGRXPexeC9qt5hkOnrIAy2PPp9MhoxoCkS3pXYFdbEoCj5ERRDs1gqhYggEIJC9McoLJ8+NixL5rCJAvQB60EnogzhL2vHWCrHaTmBgxsuxs5b9SEJr2EEUTZF4KfQg763TgsQbNRhvHqu52NdfCYrb+zZLd4dmz5/y/i1EiXaWglWzwuwwvFJz2H2d7QRfZNznooDQAw85zI7cgVJ3YwQfTI1bgX4qZC1vUAZlt/nzMf/u/nUWUQNTjZTzAvMImUCFmYl2zPuEUO9r0XacgBAB1UPDyPJdvQ1gjj7eRc/TKS1PF2XDOHy7nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYbz0ScqR0u+Wgwm+mP3P9fH0olF7XMLqKQkE7hunes=;
 b=EEJMZsfeBYMKQBD9kWaI8pwa2aiG1+8bOFZiXCCEnL1qal2KukljcsM2phcUat8LqKV8HLr6K6kZ7eDDn1+gWzFWsZJkbyCKZzHCTamT1Y2OYz4h/i1g0/GSvhz87tCWlCJtG4xzKa6tj64qj0yRvfz7qCp1GXsFuePSj2iakrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5547.namprd10.prod.outlook.com
 (2603:10b6:510:da::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base definitions for standard dsa switches
Date:   Fri,  2 Dec 2022 12:45:53 -0800
Message-Id: <20221202204559.162619-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB5547:EE_
X-MS-Office365-Filtering-Correlation-Id: 63e64de8-d2dd-4232-df2a-08dad4a64126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXTAC4t4BVpkBJLSscTmkbVey5sv6gnoaSOdV4EVHIaTJl561GblievAgsHbbYOER55Q4rj0fpsXziA0UP2mct4R9au59UBLbiNEU6dv0Vg925JbBJuTT+8XEK77i+PBaCKRAjEPZ/8BW59nxJA0e5awYbg2ua6lHwIpW4BqqN8Cw7otWX6K2KwYUculIcAjXUFS6myTbgiT09+mOPJGXAIN1EDC+15Mj8ZPK+wtqms1WNVLTC6XqMTsObv2yP3DtGfG9KZNF843/17iepcG/bmwVbSmL/OSFPYc1bZeqf6RduSR5ZA7tQojKJMyqR2lXe0nQxhXh6YVSQhGiAzGgT/iIcOsra6zCWeG5sZAeVWHd9iYNzgXYKRJsSpMzNuF31yx2pxViiK8pnN0Gn4qFPRbV65NCF2mOI5S/00+ii1kuXGuW+7kBS4pbs5gaCAcgYpQdIEoWC7bdRqubPgS6PJthy9inJ5pB0rNjr6wvu33mkMsBAp2T2cZAXwXwOHqc5YPlAlEIEb4/F5X3TnQznnUuOBECae3N3BIPU/ETskWyjBkyVTU7wqgMWe+oocxHzkexI4bmwWuk1W2bGC7XHXszJAoAIp70O0ZstSNJ1yrtcr+yB+TPu838f41AK1vXoinGSYxCeOEnXs5oj5WRuY7hJz8Oc8xYj/YmB/GI8TWdMj38t2w1LbMKI5mLDxlg1di1zx3J4QZHOmuDyXLajlukt0WazYW13nxo6Lsq08=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(39830400003)(346002)(451199015)(54906003)(316002)(66556008)(8936002)(44832011)(7416002)(2906002)(7406005)(38350700002)(41300700001)(5660300002)(4326008)(8676002)(66476007)(186003)(66946007)(38100700002)(2616005)(1076003)(83380400001)(966005)(52116002)(478600001)(6486002)(86362001)(26005)(6512007)(6506007)(6666004)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WitONjR3RGdOcDZPRVd3S3dSSWRlcnlxZEE4RzJIalpDeFJ2WTV0YUtvYzlJ?=
 =?utf-8?B?bGQ2NnV0YWhzdVBkZWNaenhrS2lxRmI0azArUVJmMGdIVmpJakdxM0Yrazlx?=
 =?utf-8?B?MjBZdG5TN2lKc24yZFZoL2I3NUhtM2tsVWZKZG1WSkVzeEVuRUpxQ05Gc3Bo?=
 =?utf-8?B?Yi91dzRWRUZJZ0dIams0YWtTcnlObWlKOGxram90MkZzdEVhVnUyYmlDazJL?=
 =?utf-8?B?NjgxSExUM1I3bjk0R1BmMmVKZDhSU1QwWWIwWDBaQmF6dFY3bGhZWWUyUkIy?=
 =?utf-8?B?TGJTcVV4TDFLQW9qOXJhYm1ObmtjS1ZXOFZQZkpqZkFzaHNPY3pkUVBzcGN4?=
 =?utf-8?B?MzhtRlFrcEpMSlBTRzJSd05IUlRlU0Y1T2Q5d3RDTnVIQ2JES09NSTBXSzVq?=
 =?utf-8?B?Qkk3U2YwOWVaSk9ja0xVYWVpZmYzc254QnR0U3VHaitlK1BzRVlYUHByZTR6?=
 =?utf-8?B?c2NFSForbTRNVGcxZHFldGNQc0RPUUtGZFN6VjE5TmxHMlZveGkrWDBvbG5x?=
 =?utf-8?B?K0orUmFkMGR3ZU5QV3R0S25jdGVyNitQYXJDS3NqbjUwTjZjVkpOdE1OUVFS?=
 =?utf-8?B?YUZ2dW9pZzBTYmV4WjFUbWU0SXRtOFdQbDJsWkdIY28rUDZRZFdUc3J2V3dy?=
 =?utf-8?B?M0VYeHFPaWJTUnM1OEsydzRuUENkYTkyYXREcHFrbDZMeE1EMWJpcy92MWRL?=
 =?utf-8?B?Y3c1RnVCRFJoMUJYSmU3Um1WUUM0VVIvNkhJTjF1Ymk1SkZCZGFQVGl3MVpQ?=
 =?utf-8?B?cHU3dTB6eDBDN0h4TTRGYWlNcWwyS3BCWWpCWUN3SWZlaTAvSVBKMUZLeUpz?=
 =?utf-8?B?RHdCZkRGMG1wdDhuUlRkVDFDRGVUalNuSFFEUWxpNm54VGpYZEI1VE00YUQz?=
 =?utf-8?B?c05PNnN1R3NlNk02L3NLY0NqV2dabnc3SHBIYVFTeDRkZGJ3YW0zNU5xTmNk?=
 =?utf-8?B?VkZtQSszQ1ZwNlVyOGxqT2N2VHBPZE9lazRwcy9MVlp1SVZYNVBQZ1crL2hY?=
 =?utf-8?B?NFFXbHIxaEN1RlpkQTFZTnMzOXQ4dy8xOFZxY0l4VUpZU1NYeHJYbmRkUElk?=
 =?utf-8?B?WXNLS0FEYzBnMzUvY2pjRm1memtCVUQwRzZpNkdncWtQaTRaTUFtWnRkZUJR?=
 =?utf-8?B?S3Jia2FxN0xzSEdNdkY0ejBBZzF5ZENrZ2FVUDdhOU4zUCtUdTRQZlB0M0F4?=
 =?utf-8?B?aUdFMVZPTHhZZ1I4N2JRTTl3TW9CTXJlQlpNUmMrYWpBQ2ZXbGhvM3F0b1ZZ?=
 =?utf-8?B?VE53U1hDMTJnd0dVY25ZV0Q0Mk5SdGs0YUM5S2NZTkFuN29YYnBtOHNSeHZv?=
 =?utf-8?B?TU9qRkhYWjA3RXdESUdZcTQ4VXh1WEpjOGx0MTV3MUMrZ0dudDhkYUMwWVE3?=
 =?utf-8?B?Qzg1NUdwN2ZOR25Tc09XcGNTblR0a2ZrcU05SVF3dmU5RUZ4L2pyWUlPbFBq?=
 =?utf-8?B?b0VFYmpvUTd5TU4wMldWYjNQUW5ZKzJDMndWa1lvWTJWNFhZU1c1bXoyQ1dY?=
 =?utf-8?B?VG9nOEtnRVFqdGd4TUVlUUxKdmNQZDVWSE1JOCtsMnFRZGZsNXVxVXRjTHNl?=
 =?utf-8?B?S3FoT2VrSEhSUEhUWDlNcWFiaEVXNVRDQWI4S1l0TEtXYVBwVUJCVGlaRGZX?=
 =?utf-8?B?VHAxcDRuZXRHSHQ3UlFvdGNyQVorSTNGdXUvK0VkazFQRkJSYStLaHlaZE5S?=
 =?utf-8?B?NjdUTHJjYjFUTURMd3BRMXlMWkplUTRoemZiYXp5RlY5YWRGZG9kVXRVMHdv?=
 =?utf-8?B?VTUzckN0SDlsT1JqSFYvRVl4V21uNkZUd2JaNmJqWWdPWnVocWtJRUdhNHp3?=
 =?utf-8?B?SFpxdlFLNkRva3RmZzU4cHdENkJpeUI0bmx0WEdoUzlUdXU0S3ZqR0FDNjVR?=
 =?utf-8?B?Mlo5ZVpnZjV0SXdWN2t2cDhyQ05LOWhmTUx6Y3djeVFPaU9iSDE3RmpvbWlw?=
 =?utf-8?B?NUx0aWQxVW5Tdkh4bi9SUnBnMkttNXhkYTI1a0VJQVk5N1Q1UGRVZ2lFeUFp?=
 =?utf-8?B?dEFLSjJjV1lsNXZpN1hvdHhFV0l6NmxCVjlsR0dLeWFmZGJZcnkzZW5JSEJT?=
 =?utf-8?B?NUk5Q3dMMlE4c2lTTDU5Vml2WkErUXVvWldsY2pCZUJSUnhoSHk3aS94ZUJZ?=
 =?utf-8?B?QVpCeEVCUmxGQ0tCLzI3cEtYd0pWeG83ajE1Zi83enhNWG5ISXlWVlNWUXB3?=
 =?utf-8?B?NUE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e64de8-d2dd-4232-df2a-08dad4a64126
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:15.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHUNTYqiTwvQI6RpWJ8tg12STAdmEZmAhOOh4cy7s/CJjlow+Nb9r6Orx89dZaM0vX6F76GnZlpUX82sf6+EfH5WzPenaNa5Lf0Cde4Ml6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA switches can fall into one of two categories: switches where all ports
follow standard '(ethernet-)?port' properties, and switches that have
additional properties for the ports.

The scenario where DSA ports are all standardized can be handled by
swtiches with a reference to the new 'dsa.yaml#/$defs/ethernet-ports'.

The scenario where DSA ports require additional properties can reference
'$dsa.yaml#' directly. This will allow switches to reference these standard
defitions of the DSA switch, but add additional properties under the port
nodes.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
---

v3 -> v4
  * Rename "$defs/base" to "$defs/ethernet-ports" to avoid implication of a
    "base class" and fix commit message accordingly
  * Add the following to the common etherent-ports node:
      "additionalProperties: false"
      "#address-cells" property
      "#size-cells" property
  * Fix "etherenet-ports@[0-9]+" to correctly be "ethernet-port@[0-9]+"
  * Remove unnecessary newline
  * Apply changes to mediatek,mt7530.yaml that were previously in a separate patch
  * Add Reviewed and Acked tags

v3
  * New patch

---
 .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
 .../devicetree/bindings/net/dsa/dsa.yaml      | 25 ++++++++++++++++---
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 16 +++---------
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 11 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index 259a0c6547f3..5888e3a0169a 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - George McCollister <george.mccollister@gmail.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 1219b830b1a4..5bef4128d175 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -66,7 +66,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..b9e366e46aed 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -19,9 +19,6 @@ description:
 select: false
 
 properties:
-  $nodename:
-    pattern: "^(ethernet-)?switch(@.*)?$"
-
   dsa,member:
     minItems: 2
     maxItems: 2
@@ -58,4 +55,26 @@ oneOf:
 
 additionalProperties: true
 
+$defs:
+  ethernet-ports:
+    description: A DSA switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?ports$":
+        type: object
+        additionalProperties: false
+
+        properties:
+          '#address-cells':
+            const: 1
+          '#size-cells':
+            const: 0
+
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            description: Ethernet switch ports
+            $ref: dsa-port.yaml#
+            unevaluatedProperties: false
+
 ...
diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 73b774eadd0b..748ef9983ce2 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index f2e9ff3f580b..b815272531fa 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -156,17 +156,6 @@ patternProperties:
 
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        unevaluatedProperties: false
-
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0 to 5
-              for user ports.
-
         allOf:
           - $ref: dsa-port.yaml#
           - if:
@@ -174,6 +163,9 @@ patternProperties:
             then:
               properties:
                 reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from
+                    0 to 5 for user ports
                   enum:
                     - 5
                     - 6
@@ -238,7 +230,7 @@ $defs:
                       - sgmii
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       required:
         - mediatek,mcm
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 4da75b1f9533..a4b53434c85c 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Woojung Huh <Woojung.Huh@microchip.com>
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
index 630bf0f8294b..4aee3bf4c2f4 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -10,7 +10,7 @@ maintainers:
   - UNGLinuxDriver@microchip.com
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..85014a590a35 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -78,7 +78,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..826e2db98974 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -13,7 +13,7 @@ description:
   depends on the SPI bus master driver.
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#/$defs/ethernet-ports
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 1a7d45a8ad66..cfd69c2604ea 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Realtek switches for unmanaged switches
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 0a0d62b6c00e..833d2f68daa1 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -14,7 +14,7 @@ description: |
   handles 4 ports + 1 CPU management port.
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/ethernet-ports
 
 properties:
   compatible:
-- 
2.25.1

