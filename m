Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A6665BA47
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbjACFPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbjACFPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:15:02 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2128.outbound.protection.outlook.com [40.107.100.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07E6BE3C;
        Mon,  2 Jan 2023 21:14:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8HwJNLJZfj4qfu3f6DycusgMdxR65G+vU3Au4aE9oGNhFeHextoie0DoCLKJ0ajPKvBX7kmGnAT+bksHDi2XJDiwxYyuEZlDnVw75cp9ptPF5cEFTJswlClh/W19wSIaRmGx8SM0C2enX4rJpX0nZAUuC5BnVyOhDanYrR/NQ2BLVsRI8oEuLfSsTkKEQSMButdBwqaY1DxZYgrtw5MBjQ/FTMySLlDaMCtMVjzZDLxQGwiaQubNW8MetvdWgyEN+gcE8bMH9GkUCKfNvsOGwlqlzs8YRu5oxXw8hb1Zn0yNqkzlyHC2UJBWdbZlytADJ5HcAmcR1Sgb9TpsjFdvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpQL4EhXiWlkoCQbrLZ25hhvq6SOX388xZKtchkqSVc=;
 b=m61Wih0GIHjQllM5V2KhKcUBMEXTuGGGp6edxm2221oMQCBkTgPVH3boYQaank59ubbXgBx36ZgjjLh46SeiloLuaQz58L948m13OyGPwy8atqlwb9E6WnaWIqy15YDiuwN0LAPZZaZBPMurSzUyXDYvypbxmiAGHI9i+vIYQGT0VEnKOk8cXOThmkcHGC1rlXYKwCrPLQ08H7mQddXBW2qsCzQKlszokOFbsUS3rRjeglg6k/cmrjnBRs1CR6/N2CbU+NmF9CNz1bKR1yHG7Cpfvhqma3T4MY2KuBCpABLw5i+BE6mFdy5CypmP5d68sTPsQg7ABzKRn0WX17r1Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpQL4EhXiWlkoCQbrLZ25hhvq6SOX388xZKtchkqSVc=;
 b=hTTyrRsqZiYEubd84LFJwsvnkR4V7+YgvQzAH9s0b8bowm8B1qwi5WeSyV+URugN1UlDXlc2jdgHN/bxxpvgU//I+oANjg9nXb+2wE3sTDVo0vPpf6uOmb7/dv46hRhskqo0YTj+sUW/gG6MX2e98lOroEEnAPT1GiF9F/dNQgA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:27 +0000
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
Subject: [PATCH v6 net-next 06/10] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Mon,  2 Jan 2023 21:13:57 -0800
Message-Id: <20230103051401.2265961-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: b141e635-bfba-4bdc-726a-08daed4962a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grUIXMtH8fkXp1WlAaT5xIOMqpGpYvR5/A3ZwBbaeVfeF2oPg4EQc+9K97hK4zioo/DWZo0z5nfNNqONC8Ftt43LVz18NNPZED9eP8A8pwj4nPNiI6seWLGe594A40LFX8cHk5FVUZh/y1o1vz4Y5cFO3xs0eAveWvYe8JKZUL9Ot3eSDyB2w2rew9kyC6qAyZXRxqKcn+cH5smQXvT+Sf3+j6M596+NwhfTmS/AKOlyqWMtWxe3JP4Ketrm3cLrFXqhtMvYdHDs1q18ZopYuo4gdjWbMmLwhnwQXl7UwL4p0J/dtEPj3dDo6OhQCsCD/0wJq5ASTN30EhKAlZVDt68ZkYF6g9IcHBwnHUpQ+64IYCLPZKMlG/0ybCVRPgucVdNca5ojDV+mZXcqUj34zP3sG4vxxXuOcO5aoBp2Syjo8gvGb6KXG5L7FDQ3HRToXToRCPPLpMJMpr4OVNaZ3+WappOueb9P5eTvmYfnl2XlV8np0hGixTdwIpaG3E0kruRaYu89Ez2bmmVErQsSagPL3Jom1pgzPcWDbGsM/3hxK5tYnVB/3rDJQRHMLs4a95VFZKHrKFRulp5U8pFH/aUpRr+OkEjAYlSIuq4kX6y941a4Cu1ov6Z3jmeiwSLpr5vxFD4lRJEyWIKSEH84E4duBzkvNQ4/cwfHysdZMhSpT/5r/wzQz19ofJnIPnZ/icplFKAkC7zg1ZP12FMgtmOGb+mNgfIO0DHTeRed6jaWMzZe5vjtHl0JcrNq44qX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39840400004)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(6512007)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ZqHoXo/jZd7qsHGlOD6528LjIkQ85m+ME+Fnt+pzsgY3JNC6I6eMRkQ+dZt?=
 =?us-ascii?Q?46z12vdi5jIInhIdZL1BxsfTwBvkTsum7eqG7c0Mkil9TdL/9Co3eo+o6CnC?=
 =?us-ascii?Q?fYKUb3rWQsTrsUf54HuGdcYwEZVYkNWCECbb/gYjRTy27IwTqSh+NeS4T1Yk?=
 =?us-ascii?Q?tjcGtd5G4E3qXPz2zB3045dpFLr22GUF7kqGgJJEUm4nKcHBThcf1Ch969BH?=
 =?us-ascii?Q?FeTnqz4vsRXS0rZHJnbhVZrw0flo1DGoWOuu+cAFOx8tbH4DT6qJNN+wFL48?=
 =?us-ascii?Q?ddLZcygtafahTcu3Wg4jwK82MfEe3qba8C82EHWO2vNMOkPXib7zr8x5UwzO?=
 =?us-ascii?Q?g5SjKWzj3gvF1DGlY0Lx+VI9kN85h7CTQFHGg8A3LVgLtH6yRohwfmEyYSuI?=
 =?us-ascii?Q?3M1K1kzS9zQ0iYVnAxW3D+iQ2pUd/JrWTx/wMhYSdfMgSs8WNHxdoUkPKm+M?=
 =?us-ascii?Q?/VQ7DlYN8z6xDHoPO6Hys4tNVOSHGHPTyEpTuxfGEPwO9Ka8C2AvbgbqCGoG?=
 =?us-ascii?Q?w8lvtux+2hNxeqWdD3HcfpiN+pMRN/UDMRQdRaQvpMVdCqKqV7j1hO5aFpnb?=
 =?us-ascii?Q?3bnernsgNPsvIfwEdTLTNGE4DF30SQr0lRPID0qUEee6RLFmL+yWqz6ptVr6?=
 =?us-ascii?Q?2XoYuvtV16I8lhQf6orSIEW5vxTSHM++xtvS7QBV8y2JbS5TlQLscXZ7nL+b?=
 =?us-ascii?Q?RMKEWJMiU1M1cSlhsotncWSkwaHpAQd/Jx7sK1bmNcviZhuLauAyf8z75NKA?=
 =?us-ascii?Q?bw312ZIc1nSRJTRug8Z3mb2Mb9UrPNb4J56jtGWULrcleEzzXoZ6BFSnicTS?=
 =?us-ascii?Q?C2K5sDAHdCBX+2EGKEejNIzz/qMkJWvU0oL5a6gmqNJI5UPiuh8BPJjzbNN8?=
 =?us-ascii?Q?4ZIDPMGWBwWazdFRGIdffNlDAZ8CCsyKiKYnErvYTwd3YytCsSczyR7VXxKz?=
 =?us-ascii?Q?r1AyUtWn5vGaC9oaKK6Bz7wQsNp04RCTHz0O3ncKQru3b5vmVHbx0jLVedUT?=
 =?us-ascii?Q?4Bk6loVW1mA72Ct80lTSz4R9hv4f35ZP01n3U+A/k1gglfLNB+6YY+VFK4U4?=
 =?us-ascii?Q?4E46j3mzLSv8MIKBMPKWo8pW/o/NfcYMOKBKwwyZm4hMNC/x0oER5qIegwzH?=
 =?us-ascii?Q?ZrHB5tY5jt+cuaFj4p62QwflK5mxQfy/i0U/hXxOBi4Cg+MinfCzyiqr0kJj?=
 =?us-ascii?Q?+OCWZjY53UvF8+vUuKqQsMLIysrmJzL6Ao6rxHnZDvKplVooKoiy2MKpAakY?=
 =?us-ascii?Q?mNCO+qsO1L8fKSJuFVtblZbYTA6MGCKZnQezCHwPnSRN6NiNZWiT9h/lcphD?=
 =?us-ascii?Q?sHqI1G7y3ooZnLJOMnIP9tUBnxyjg3mk+eHxfyuMVDCPgqfiQZXYBaSkvAZq?=
 =?us-ascii?Q?80tHhoXJG0h8FXdlLcmrwRvcunOxB99fjBvmxok2MiMuX28rnKkXqrj9f1Vz?=
 =?us-ascii?Q?4KghNRVtWM9gJNh6mm/OGwlIeKNMuLuOWFICkMqSLonjizHtSh69k5CTDC2W?=
 =?us-ascii?Q?mHrIkGDvPlvi2WXQWSr07BlYDrtOGQDwMTFMRMFPpzD83b6nosEmHZCEhuI3?=
 =?us-ascii?Q?uCUh+4FV190SoFynqhjKvtnOw+eNFfs5a+DU690U5x8KYdgc2VmcpyfltpFz?=
 =?us-ascii?Q?OVqIRkPKaUlg9Mv6T5RauvQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b141e635-bfba-4bdc-726a-08daed4962a6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:27.2004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCZoGbBXt+u/h+9zjgbhxh+5/SjWrFj3eUYeomPuWjdPshtcaXBNTNwZyKZBEaOXdUhl9D25u5yjENwo8kLj50FJlM8MlHh+kseFVT6OlS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
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

v5 -> v6
  * No change

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

