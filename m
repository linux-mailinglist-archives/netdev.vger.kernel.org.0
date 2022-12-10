Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1841648CDB
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiLJDbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLJDbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:08 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21998D663;
        Fri,  9 Dec 2022 19:31:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obXOYpu+RZYljia5NrC9rqo/sEtaqQMeH7BBYUVEhDRNCxhmT7Wh++ZOBJn+qMr+9/HgackD+v0zrBLuu3Q4MJpOroqm4QARJydLdrd18opEiKPZPu3hdOQWPcgh0l9JVrb4NpFXVGQHz1wo0OANplUOzLMSZp4DmDctiQhn4c6C/YPYc+C+K0SzTNqbnV8otjknkMzxYTbb7gkF6MeS1Aow1rV4nd06vJ1NB+nmpNIJFiGTXs1IBipC+Fj2JCYxZXdE5LGvnbKHxPHTI5CylQAvgWmJLnIhg/6iTIBvqQ0+FKlqNDge2AlVXRkLZzlkPgp4hY2WZsqzV4wLHFVjoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nH96UgsY4RIuDfdT9n9G1RGOenUasVWM8KnDjZ9PM4o=;
 b=Tcf5O71/VRZLqAEccBqo+ueZPGOdtS/ApEqdAYTbZLbmoRWATXFt6aUnkIi2BwJeymrpRq9BQzEOk5BuN3u/pBPAeucM3f14uVCkORXR8XMUEstJSMmDxSsIjc+8c/QYup+Rhk215iK9zbE1SZ6udqdgx3gmdy6zfDANch97ZcyhG93id/hCyEhM93qInR5C4R63D6cxomfm15D2MGzIpB1GJRwHxB23vS0J4sJZTXTGIqsPY6blY8jS/pBWKFChTzx8yUFB00ElkuNq/DWBX7iya6He/zdDWwY3fYTv+QQcAUpqPAi5qOyvmwKLxY1bnoBtsBZ6Mi7NPsw0p9cWRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nH96UgsY4RIuDfdT9n9G1RGOenUasVWM8KnDjZ9PM4o=;
 b=lm59471Ccsm3NgijpjQ/lTghqIfjEVmJUUvHKB/b7VBZpP9xJVXH42O5DW6XqcfIngfc+7mYkwkS37e8k/AQ1HL3J/8XntAwLZSiPb3rH7hzwMxtU+CR7IeG4ovxja3y3twkP7kokb8Xquvr5c0bBP65G20dR5lccRZFZwpBGIY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:31:01 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:31:01 +0000
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
Subject: [PATCH v5 net-next 06/10] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Fri,  9 Dec 2022 19:30:29 -0800
Message-Id: <20221210033033.662553-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: 231743aa-6be1-4b7f-a151-08dada5ef606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5L5jOhSfDMWIM3PVlBpp6p5+CvaEGNtjLF8H33XJ81ACa1syaiTGvCoe7i6YzyLmdHNMP93HpNTYbBJ1M0dfuOiyg5sNx1iDnZ65ltKz5X6h++ij3DSZPV1WapL0jyDwN7W8KNigE2IHOwldsgEp5fjlNVx4n0E9l3oCIGOAgq76zk7zlVYEy7dIA3f1hPJUG7mzrp6+Di2+fXBpwSOL2jUunDFdCIYjl6FN9BqfRSKFm5G7pkEbzr+SjJ4j4JMk09tezl28tiNmX8wCimW2JePSU0CoG+wMTsiL1ANBQ2DY7r5MAPWB/esneoxpbLE2f9EXfQOkk1e5m7bmT6T2aDe/mlAgYTKBZKg6rZUNizHX6QN2x8AUWJbfAVSXfG3F5aWiOjmlJyfRQw2lKoHta0m6DYc6d0zHw/u/FjaappbGsTCKxuBizLTWeJ9VvVYDpYzYX4yp1Wn+1nyfDpXJDTV04J+9qncCfA6ImzieMbX39DY6AAexfBo9LXLUHELBp8EHfUUmMnXugYrTc7h9yETeF+OqICqR8osz5GnLaSZzeCRuqLQducDUqeNclSnXBY+rz4OrWfmoz9R5tqMS+7oMUO2pskcMnyrdZxI9Gp1wPgvKyrFMdU4cGux3+tXjv6vH5tAc9eC5t2sCkmpJtAOyAWnu6Wb3n6DT7k2pcUV69JYcDdbX6YLn7JpIGBE0wzv5P6caNWB0O1Vr8FsoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199015)(6486002)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lQOVY47Rs9N7/P7xNsxyEy/+X42CQol32njyow+Olrl+iqTeCQFegsYrFhdy?=
 =?us-ascii?Q?1sdcH2lPR3AMHK8BphIqBdOj1HuEaGLMmByueiP6Un1h9K9QBP60s71fOUaX?=
 =?us-ascii?Q?1dQnZYYnuQkur8WP0xYhd1AseAjH/hO/+5DSKxC8DfnqvjY3wb6SVWBmvRzQ?=
 =?us-ascii?Q?SIgFJ85Q6cCHc88+0KLHsXdLtac+c8aY2zf78cpUUWt/imD9QL9WzbGxckdf?=
 =?us-ascii?Q?t2BIbPsSTRwkim42Oymo8wwYCaBfqtl1VCumOysIIdzIWlWtMwP2yTp9m4QP?=
 =?us-ascii?Q?4mZaNWCzZ/mggBgOdNNl7v283MVmvNLi/uVorNu80oEISTpgqrElKH+j6gl4?=
 =?us-ascii?Q?s8jBgADL9lJEaLV+GpGdss2bLqyreeLiXmWl5KF8ye0err2dVUiUTu+/ytFE?=
 =?us-ascii?Q?9+LxxzS+Mtzwi0SCo+r4+v7vzFbimB/fimVQNUUTDuUNJZgCMK1GlzABduuI?=
 =?us-ascii?Q?nw9svNK78kbMbhaBX63RprAbpM4AfGPQZdZTwpzLDtztyBDwkv1eAiQC6O6H?=
 =?us-ascii?Q?BdTYFgRGdlhDWjRtU4Up+bYLXEUguOHp59Hy6x92Ws8CEbIyE1gBaysDZ43o?=
 =?us-ascii?Q?LV8YpuGSHP4mUl05mZaFIT90ar0U1FGerK5e+cHTWJdIMqy9ckcrlMnpnqH2?=
 =?us-ascii?Q?05+W5+33Faxdox4zQ0uBeiberuW3X3xY7eV/fzQX++IGymxq79g2jeYuA5Z8?=
 =?us-ascii?Q?S24pqPWR+k5x/3VG+p1Z8Ve4PsEKdOOvxTjssfyS3sJ4/7cJIfzth+c1W4FN?=
 =?us-ascii?Q?MNRY20JXVCCbHoSNDiUNJJGNaLUQO2BD5exxzA82WSz96aZ9dDT9YdtwA51E?=
 =?us-ascii?Q?24hQFD6fcNY6fDUj/fg92gx7tSYykTPT4ngrqlryGErXH6rmnu8dhRFg6ld/?=
 =?us-ascii?Q?UEHFvC9+jZpplV4LxJFiE4RK/78WFwM4DuP+TIlGLEmUpBRTVlPzNcM38VyA?=
 =?us-ascii?Q?1rwoXEtKYoZePPgMIoEsRC/etpNZvulaqYXl3xM3XhjTRDSCAgN1no5IIPUP?=
 =?us-ascii?Q?5S4B07Z3FQj+8/QQefvShvbcDeM9/FvwgKe9DV1QBJaJOU4qojODOALchMUw?=
 =?us-ascii?Q?G+xppLMfvDw4wwwdsXRmN9PQVKFugp34Xpd8m5WfJK6RO519+P68KZ4mDzc5?=
 =?us-ascii?Q?kByKlO1a4Y3jGa1sKQeuCbmOj3xDW05SrBF9zGbyLjWLX674HibXeCfzNE88?=
 =?us-ascii?Q?fHDqyEW1AXBpUJxaaQNoumYHxrjPdkQwE713fRYnB8IpRqTpMPUTi8RmuIUx?=
 =?us-ascii?Q?ERiS0z0h0F30r2EHhx2LbvMzl7IRH01MZef61QaCz5dneebUTuVBq2Mc6tML?=
 =?us-ascii?Q?uqf0JeTIrcq3sKfOS2Smh3hDEib2ceuLTwjMe1kSYOUQZdp1JKqb1LpICKai?=
 =?us-ascii?Q?nVOZeaN3C+tIonm0PC0x2WfePEGjciALWWVC4zxioGdsVozB9XAk9MTKNG++?=
 =?us-ascii?Q?lxZu/IWy7/PoWUGAlmZcjZ1vurzO4z/VXmPRJCZhWtaRB2U89BPh1R8z5PxK?=
 =?us-ascii?Q?QKSmdz9MMu1v0hfLvz46HvIjWUWiZzLdGweWC/wQyiBrfGxPJEqBVb+KY+Qa?=
 =?us-ascii?Q?T+MFxhg1JQX9XQBKF1MbPAxXxhuaJ1IdaNb1zjwxGom7q0jG8EkpCfRQRHoj?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231743aa-6be1-4b7f-a151-08dada5ef606
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:31:01.7475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHAQRFBk89kOfFDTL8lV7gGxfo1JF7zMcFn8pRw1cXXSz+T1aI9XfZxfHBXc7cmrTt2cVK+Dv9XmsjcTaEBbrCVLE38lH4Fz7ciLtLM6C28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa.yaml binding contains duplicated bindings for address and size
cells, as well as the reference to dsa-port.yaml. Instead of duplicating
this information, remove the reference to dsa-port.yaml and include the
full reference to dsa.yaml.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v4 -> v5
  * Add Rob Reviewed

v3 -> v4
  * Add Reviewed tag
  * Remove unnecessary blank line deletion

v2 -> v3
  * Remove #address-cells and #size-cells from v2. The examples were
    incorrect and fixed elsewhere.
  * Remove erroneous unevaluatedProperties: true under Ethernet Port.
  * Add back ref: dsa-port.yaml#.

v1 -> v2
  * Add #address-cells and #size-cells to the switch layer. They aren't
    part of dsa.yaml.
  * Add unevaluatedProperties: true to the ethernet-port layer so it can
    correctly read properties from dsa.yaml.

---
 Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 6fc9bc985726..389892592aac 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -66,15 +66,11 @@ properties:
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
 
+$ref: "dsa.yaml#"
+
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
     patternProperties:
       "^(ethernet-)?port@[0-6]$":
         type: object
@@ -116,7 +112,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: true
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.25.1

