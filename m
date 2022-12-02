Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D643A640F5B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiLBUrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiLBUq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982EBF3C1B;
        Fri,  2 Dec 2022 12:46:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6E3DCtRaUcXY+S6lZQSyXa9bQdEnvrcVfsYX2RF9UoPDaFxfEgkU5s+A4o5CuE8Lbv/9Q+fTnlluAJR4fbD1EHrLQcFDB7nhNVCRxXXwbnp2FG9i/fWbMJHW8JdALKn69KzpMDXoUYOfS95y+y4vnvqgL3Vp/rTJSP68nYpT0GEqf/4hJBgwFd4QZeRh/9g3tJwSJoeYtdPk2X2dRUtCyljVn2tf/VLMqTdiHLJyr5TQILDU4TLZ00GNf4W1CGwDgrB+O/eiGvfoGKUHY96iMYVNw2TvhnBOzg7iN6hh0QxrLWQUHnuZac2YxgH2T5DcAR/b5uUsO2gKJvjsnfNIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIsrSGxiZGQmx9it4ot+6H6XNrQtq/D+2osbZnhCIg4=;
 b=XwGDfr5nNEkhXrT7ryoQd0TTH8VSmakHPOkdRt6hdjF6Cn+Q32fodkM8Oi2+slVvMQTB2eHOhcu4SGn9+WF2KtEqJLM3zeLsd/Cyf82YNZsKWpdY3QqynDygk9xFLJ5ix/nCtMFMaGWy2cim9d3QcxwxjXpR7HVvsBZdzOwPoAmpqKhGNAjruDRzut2vUiQLI+DF8qah9XDRt160hfT4snNsaVxu0kT4MFwosxoQ4UA5DzFFJbHllmWjE72DZUuOtwfKKkRRixq/bj2Pf47cXqPEOzy/6UD+5Pyy7/0PYbEtfHleAQlFCeaST/m7k8ekQcuZAboxDY1kJYKxD9LCag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIsrSGxiZGQmx9it4ot+6H6XNrQtq/D+2osbZnhCIg4=;
 b=YxRiLSbOjAqpQ/foybSrwVRthYq+OHwApRjFaOAS3BAJznOOsz1YYBEAOeXTf3cCQ0fjoPbm6+fBZDrjhaqKmINR+v0fWRY8mv7y/KNS3NNlYTz/PsAQf68XGTzKIwplY0mcA+6YH/KHZa/eToNVT5QPmWOCxpjqDgDQjZFpod4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4944.namprd10.prod.outlook.com
 (2603:10b6:5:38d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:19 +0000
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
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v4 net-next 5/9] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Fri,  2 Dec 2022 12:45:55 -0800
Message-Id: <20221202204559.162619-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: 05a51410-0457-4303-1d45-08dad4a6422d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QPZ6R/ea8zIDiIqwg3I41iGTZMfeRdr/q9LoljWMqOVPmx5ogWs+O2UPkRVqjSjCqFb71NZR/WLYVrKBISNUTxBkO4WzE7hbZetYolP1bxbaVDD5YAHgtGl6MVAYNBd+yIt7qdO/bCmCHx7OK1eFeNqIn+HZn1/22YTbBOEEcBpC4pQfiNBHG1IecxoSPDWC4M3TTHhdZ+dHERbVncYeegtqtMsOoWHUnYa+SEpiD1IBEl1vJgHh2I0lm5MqoPOq5gmpVwVXxxMGuz8NRQ42jc10v6gQgVM29Fv8Vz/YPcdKDwh7zEf1nAOiu+NTGDoJDJbuNV4ywJCg6jjFtjoe+aRbbNQ662tgzEu5VhP9rwvNbi9A+uwYQ3BTpJy2isFPGCDiu/QJS1kgaFK4g/8GKUNYpad3IlN/DgFFmh6ZVx2N6jmWzC4bVCb6WMGgJ4FBmhyC0QqjtU4vdsn7K9HbqPoAHsgwJco9hzB6OEr/5sQ7H7OT4HG78mQz/EMJkxaIYb5gytd6+u4E3QSuh4IzHqaYFm/aFQGUNJKq2hPzOvDTkny/icX1H0StIS7hWJgKb7gAEzk5tNdmM8uVFurmSnGgZI62AcH74R8rB5bT3AZL2jjkWnncLhyb1PtbA/flADognGpF9dKdkj+6D/wSHd0yvFwSOZtJcXLDKgDH1j+JqwviXYP4s8a/u13qYMrb3nULtCwsk59Qb7WlAF/oaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(376002)(346002)(136003)(366004)(451199015)(38100700002)(38350700002)(8676002)(66476007)(66556008)(66946007)(186003)(26005)(6512007)(316002)(4326008)(54906003)(44832011)(5660300002)(7416002)(7406005)(83380400001)(2906002)(41300700001)(36756003)(2616005)(1076003)(8936002)(478600001)(6506007)(6666004)(6486002)(86362001)(52116002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CAhmlYiauK/JmuM/05ES9jN5YSWbwOCQb+tix4q0bhQOR+W04obIlRv4hnky?=
 =?us-ascii?Q?YtOfTyDA9R0EHP7KZE+oq53QQLmBiZ8IeKOWqL87loLxDBmR+a+COZkkssBf?=
 =?us-ascii?Q?3VbPUvQCAhVepN05IgGMw2b39o66I/5rH6iclyToKQX/olWM6Vj2j+LBT+zG?=
 =?us-ascii?Q?fDbQqRTy6/fmfMAQ7iUhtu5nUASfH22R/jrv04ccqR7W06qvHsZ2KDQ9r3p6?=
 =?us-ascii?Q?uB/SGPWNPforcYz+dU0DFuCVOCtkKTd9wTwMIJXr9UFQhhbVmPGppoMZMYdK?=
 =?us-ascii?Q?0x0VATW50H7/mElaR8xo1MjGGYb/4YNBgJO+TNcabcO7A59rojW44zzEYxUG?=
 =?us-ascii?Q?rFkKWoHjj/0TVYYf47hAsb4A8PSUqrPOjvjHFzc5DFJ8zXBBWkbUUl4In4ZB?=
 =?us-ascii?Q?SChycHLjjMIfPPv1NHUBkHNWB1iGmyTcWSAyiuuB2kSP/xDrSEEmlpzGff5S?=
 =?us-ascii?Q?jQUNGrnNF5nPcTLnYxybLwDNJQDcSGJ6QgwqhTnKbOryk7y6Kq+w4v7HSrne?=
 =?us-ascii?Q?6PObBSIG3rat8YYW/qO7CBRquoXpciaaU1/aYRQMnwGB01j469zeQoL9Ra8j?=
 =?us-ascii?Q?f5Ok3MzqhbCek1U/yzV3E/Px7wlF6PKYPWMYyyfqMNCiBnfItGGIdb0F7Hlp?=
 =?us-ascii?Q?M9aUpeRJnvAIy4Yd8MpwRSvsn0h8sHjAfB8SPD847X9QiB10Gw8xxbcQlDfb?=
 =?us-ascii?Q?NMDiH7FAqiaaau9q/wgICPIzVzLar4KnGfcgnPmrde+LY3ETbWchzl/O96SJ?=
 =?us-ascii?Q?V1LndKHdk5V3j+PjYWLYkWPCWZrjOdKL1IkZx08IC+iug7s6rpSE8cnmy7LM?=
 =?us-ascii?Q?xoIfjzUsKVs+I1xx7xKhpp1TcXQJq8xbDYOKIeb57VkGYPbmW36K13zFRn3R?=
 =?us-ascii?Q?iTgAI62NEJX2vpfyW2x912P2NWSwhzYDR1XUOx7hPmasdDXlSn0LF5ACxCCg?=
 =?us-ascii?Q?wu32hLL7hFE2+dkOKCof2SsT1kTHTo9j8bLG8Y+PooA6F+Hl1+lCbCZewq2l?=
 =?us-ascii?Q?OA/VIPLNX5xDXumScx1PQuOoPKYjtkDZeqYNcjd7CVtkvdwmvH1uA2trhkan?=
 =?us-ascii?Q?8rVnhhOX5SsCJhLcId6om84FZ/SVt7QSdCOXDP59BcqHZGS/tYT/Jn0kvD84?=
 =?us-ascii?Q?GCtGaphQexL6aEy2+pzT5c9nqyC8k80NeZpAtEQBsch4XnMUYbSbQB0qw7Kl?=
 =?us-ascii?Q?jJcsQRA0iF6EzIaCFfkWcrRnVbQqqey7PliKuDJXRmW9JGeqgfpUchHwwcoy?=
 =?us-ascii?Q?8T/+ISxHgdSoGyL/MQx3npVtbm86SDW3NDA/RO3b5EDenFxoi77rCC6w4Rn2?=
 =?us-ascii?Q?WJbgWEECMCiXEdjOYOa8Z5K7hk4+Xt2ntIUU2s2mCx37UdGm0o7UNTs3w0CE?=
 =?us-ascii?Q?XCLvnRBQHThZLHVUOrCHoTP/6U2AI0SRlOu5aNsDkmGmQVibzNctyqo1ED7H?=
 =?us-ascii?Q?dylXTPMsqC0P/pL+j9J7fFDp03NFZgQvEDpV2JczuXRCgLVTMpmrXlVVNH2m?=
 =?us-ascii?Q?WlCDwB4iVQtLZ9tafaRldYgE53NY7BcYpz3lm/FFKyLKuhD6EVC7vDAVmYwM?=
 =?us-ascii?Q?kpLKMpyDqIcEiUnI1hE7+1MrJZqE73Nz+Uq4QiWOXj+jkRyvavdbTwnfJEBw?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a51410-0457-4303-1d45-08dad4a6422d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:16.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJ2W7mIuBKUDvp6w8LV+uX9/aGZY51wXMgBo1IuZG4KGS51mpiAouGI0sMgJvGp82P8tQp9CBFQSA2pk2A28UWzUmLwfHOGlwQmykvhQjhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
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
---

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

