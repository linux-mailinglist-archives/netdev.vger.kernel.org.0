Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F35265BA40
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjACFPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbjACFO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:14:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FCEB7EB;
        Mon,  2 Jan 2023 21:14:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlLzvwfxA8J2Pzw/YKT58YlNmxDffpje/ozOja3nJbkHP7TFtV11ISDk7JzvaZUc6sFNnxo3ikBSZs3Drl3UEIm0UAJBocYVjtt6g1FPdgD5fzLlBJm1tcKjzTZ294JEr6baGPgVZJc6wlWJWV+9+75tSmqoPdF6elI05jmJrWWxqhq8s4H+PJjvNdQqJP7cbhjRiTwYAVj32hW6cIaS1nZVJmcCmxpAueHdUEFBz2qjwxadxYiLtuzVk1s+1ssbUN3kbz3TvYlURyZgt6U4UOlVDso5FfyYT/8nuq6ewt1YMHtbvtiP8AIttTu373pIhkilZcaEfUsArYLNcD5c/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yF8csKmIc0W2rFl4qEIsaEF3qooN6xzYM4I6paoblmU=;
 b=E6e2eKDR0apMUa/3I+We2rK4GafYhSbxZYm2G1qxuAruoU8N7/1jEgCjEs1MY2kfbKUU0QVNr/CTVXp2O6MKc5KOULt9rzfDYTaWF/9sujewnY1ki/4sMh5FmbLM+3YREUJDZbLhJPH2i8k+nBj8zMqgeQiDcaYcWVTxyOUu/K1AnKRmSs91NePDLwrWBCZHPytXKxMRSBvct8NRO9g34URBkzWNcEfRC9bgutCi8lhSaMT13m5ySog+OyjXdaklzT43raZIl9uvRXe3gISoKDgcN3ZOdsEnVSJPYRpPy8e4PkFDaSrM2MPn6vfkEgmiuYD5hmQuEle8EWeUfiuaSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yF8csKmIc0W2rFl4qEIsaEF3qooN6xzYM4I6paoblmU=;
 b=Kg7i6u9BDSyQklVqTqSDPYvq95jrdW1ohm1UNf5G0jtXHdSdYpDHaHPvUSP/7fdXpUhXQgvYMQK9Esr5efhF+qaXlMvycxh/8tS6HWvUgdLPdSEYh8itn/rwPf1bIpeQwQcC4TxOxN+5cR9MBe/IWrcb7QEirdMMfEiH9YOKs6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5823.namprd10.prod.outlook.com
 (2603:10b6:806:235::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:25 +0000
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
Subject: [PATCH v6 net-next 05/10] dt-bindings: net: dsa: allow additional ethernet-port properties
Date:   Mon,  2 Jan 2023 21:13:56 -0800
Message-Id: <20230103051401.2265961-6-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9b32a0cc-206e-4c44-861a-08daed496170
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ur1QeMiuYnUYZ09DxJVJ66WFBaPoLGlNx9uwyDWpDLhHL6iThsmM4RB8q0EYfo+P8ewZzxE51QRxOC1IQrrvI+dHBJFZVCrT8Kp9cxkUsgSrNTu8zBvc83MokigiogzhOY6KdFUQH/JKhq01I34RXGK2n9qUMf7eG57C4h+gB00v7Zk5SbXBFmzfsNXzPzdw2VXVAiHdnsqoWSPC1cltN8dWbJFPFDBJzEvs/DpKaB1HL/8f20qs/of2akxMkuo/YlUHGx3DZTf5VQPG6NyvgiJpxzHLKFIO85rCXijXEPznMpdkVRw7MLCJh5glDxDZi2lNhv9kd6Qa4Sq/Bd1a01IctXwESJEgItpVyzXUgErAM9QMrhZDrQhoCVuFIXnN+ZJccDO5hr47LHBKIt+CvoHgbvvLaT+iNER2mrsnjmu4N2By5qpUbL0yviXC1YbvBmghQZtPghN0W9rkd57JKwk+qCrTtDogFIdPVmplBWl0nBInVEXklHDr9zqtuRhm5KT+7V4GYOIG7n2WwKOpM5owft9l+4HRq5AC4xc7lLe3mC/N9CkJ0iNiiV4gIhNzudOrnvslYLCyo/4rjyptlgRRQodiRJ/lCeBIFNrqrxlpM3OyQV5xaXbK4QXBkRxVZF1OSZ00/DgtqTZI7+ACgMZ+/QjkCgp4NgCMI7Y3rWdicSs7UIfINr2pP8D8Y+nhOh+QVsn/P0Kb0KaiVupHMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39840400004)(346002)(451199015)(54906003)(26005)(186003)(52116002)(6666004)(2616005)(66556008)(66476007)(6486002)(1076003)(316002)(66946007)(478600001)(6512007)(4326008)(8936002)(8676002)(7416002)(83380400001)(5660300002)(41300700001)(7406005)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xUbGnUtb4MuxeKvZfBAWjY9wSGwtA7L4nv6CVXd9KErBYbNOIfUBti0B2cKr?=
 =?us-ascii?Q?bjJ8HQMMa4FUX8FW+QRy5O2y8c8Jlw03EjgiKwc61NHzu1i1XaiO+2ns+FFc?=
 =?us-ascii?Q?hwYD73gQM2YE83OeT/8/AZpebkoHMYAxiO6RCaslugez4TLl5YIw5jpSwn3Y?=
 =?us-ascii?Q?FdkkaDPPRrN+PHtJb61NGRpPmvk5J5qgKm1U4n/0zqRtcyIvh/WSmMUYYLL+?=
 =?us-ascii?Q?5tP9LihKIRyQYIGa/FxujLzLQLUSk4VyR5mLx0nknK5zykzJ3DcchC+Jn/RJ?=
 =?us-ascii?Q?ejZgAi9vo7u7pZy9hQSTFERIBmzL/X0aTMJRFa5OUIH4a5rSjCeKl1idgJ43?=
 =?us-ascii?Q?g73RikrwYK0WX7yOwOjOIQ+LOo6QqlUnDWW/QWsZITvKmYwXRCkbbrThC8gY?=
 =?us-ascii?Q?rqxfDllR9MZYuSi3ZGz/9UHtVjXIb1sE9SAShj/3utL6B2ORUu8nJhRxPxe2?=
 =?us-ascii?Q?DT6RH/NB0bSj0VfcNXM74icD394c/UnRF4McJyqTSK23+tWR/L+gxFMdo6eA?=
 =?us-ascii?Q?EMQLsrDizKfBmvGjVVaLjH6XV093rxPYtK+bVd24vgN0c0pjgVeJSGeBwhHl?=
 =?us-ascii?Q?4fLB5t35kL/RTcC/LE/h6A7Wvarx449f3UD3JmvbvLu2EaFe533S3MaSiqrH?=
 =?us-ascii?Q?VhxgavG1uT0TgVU6/P/NMnSPXnlXAW7aFbewS4GZ8cZfk+CaIsYSo07OMAl3?=
 =?us-ascii?Q?ceM1A/b8NqwtTZCLwcWYljoYf4VUbUIOJYZuBcvtF3yqASyJX9XlWbS2kJuX?=
 =?us-ascii?Q?juOZW/nqISbtommkZznsVO7N8E4TR+z//TLOpSOtrP0PnnWGJuHNgkyYCRQg?=
 =?us-ascii?Q?+D3IQb3hVO4TGh0MdbmcS4wybswfQ5mr5ikXLuwWD3j0qqfedqB/pWOX2Tro?=
 =?us-ascii?Q?WrpdiQpvMRFDA1K0HqAcFR5OkvEB8ZjEUwrGZWOnd4lxJS1eo3dcm/gEx7Wh?=
 =?us-ascii?Q?JNoo6RUCinENNhoVjAhMc8Cvs1Lb2T7Z2QmV+bJYMBDQQTzhevlJwuh0+QRr?=
 =?us-ascii?Q?Aw91g6Ce14TwtWg+JWKM2/9SEzLqmClfBSnuFF5FPKU9c1O0ZNufcTD7SvnL?=
 =?us-ascii?Q?/CGt94ThW6JaeLn81VTQnuuedDBOSkZ9vWM65RbQX+fKBAhHm+t29bsfXvcS?=
 =?us-ascii?Q?3Ey4lCYgQHuaC+cWNcSx7oI6ZjKINcEaCe/KrmK+gFbaeg/jGAsyGn4aWRVD?=
 =?us-ascii?Q?NBYviiZaJY5RiRTQJkGGybjBX63Cf9K2QQtfTfh1um1eC0BiRguuP8hJs7ak?=
 =?us-ascii?Q?zv7B5YZ03ejb05v2qIT4xsTiThNcY8h4O8QKBv/jkViHHY+UwYMNPrSFroPu?=
 =?us-ascii?Q?auD5dZBE/MO+y6qBRtTR45X79S6MGWQ1p5aa7GRoFE2rgEkEdlTSw/kYmw0u?=
 =?us-ascii?Q?la6yFWup8N86U1bMPR5RKMCQz0izaqOk9oBiDE5/WZdzdnN65vbq21Kr3qIq?=
 =?us-ascii?Q?5r0GVsSdtu5rBH99j4KXxBTgilhGPy29joVoK2z/E6wPdMt6gmONpN8smPlT?=
 =?us-ascii?Q?1yMxGnVxiAW7DmUf9WIv18AeOM7I4sjm5WY3HoZdf7lKcXvBIcHRuZeSijnD?=
 =?us-ascii?Q?GBhO12j16ZR3I/9/u4vcgIokopZWmLp4YuQJNbu8Vxx7zUIJdjwv0x4/pDhT?=
 =?us-ascii?Q?1oTfJJe3uVLMJArJSSdWhmI=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b32a0cc-206e-4c44-861a-08daed496170
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:25.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtWgVZSApoajcwtiWHQJ8jqkuiw98m8qID+ulbCN3CHXRSAgu3UEiOdjcaCforTg0JCoOt7MjmnTdMIRL7nU4OpkpoCasK4xPi5IfGavtcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5823
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly allow additional properties for both the ethernet-port and
ethernet-ports properties. This specifically will allow the qca8k.yaml
binding to use shared properties.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v6
  * No change

v4 -> v5
  * Add Rob Reviewed

v3 -> v4
  * Change ethernet-ports node to have "unevaluatedProperties: false"
    instead of "additionalProperties: true"
  * Change ethernet-port node to have "additionalProperties: true" instead
    of "unevaluatedProperties: true"
  * Add Reviewed tag

v2 -> v3
  * No change

v1 -> v2
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index efaa94cb89ae..7487ac0d6bb9 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -41,6 +41,8 @@ patternProperties:
       '#size-cells':
         const: 0
 
+    unevaluatedProperties: false
+
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
@@ -48,7 +50,7 @@ patternProperties:
 
         $ref: dsa-port.yaml#
 
-        unevaluatedProperties: false
+        additionalProperties: true
 
 oneOf:
   - required:
-- 
2.25.1

