Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24603648CC8
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLJDbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLJDa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:30:56 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C781687411;
        Fri,  9 Dec 2022 19:30:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oP4LHDszlE+DjBqC1HeGY1yiQRqQmlSqV4eW9ky70VgMTzt08IrZs4gfZXk+7IhcwEAvUZmYchjKiJh8F1/S8uSlIPZDk5p7EAb0i5POEGVT15Hm6m1x3OE6dPhYh17csOrp8dLMbqP8afaBqfZzRXQUwuuYELlUbw9in9oYGwnDkA0Y+uOo2JHCOv/JMcZWJPio2CU81couu07C8Dy6lGsBGDkd1odB9QheRj2rqyFVRZaWPHipJK22KCjfaqd9ruF7YL44RHyzR9wYgueDWKXLunjCKi+dDbzcGE8WLu+rKrOzwPt4Vg13AEv2yZMkofjhoUj9APxX9knE73LU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4yn3kxIvlE+alNL1muV57r1ci1bk6sVONSDM89pQ/Y=;
 b=XPdXbnEYpEhwrGVTrIeVKsqpsNMJrcUebq1IwUgYzGSWyHSDGMMvGyK0dmMeiT4au0ifL3J3k1TMTZFpQn9yLs6RXJxKDUJGllp//rSRvKikptV3IXwijREK3wpL/npR0WOCxEZj+1RWj8gL+QsiBGSNhdqvWQnE8233fwt2N4cNy1dW7s5+IMB5z+QRXzeZZ0dfm7DXYPE+tLoI7uUsD/BJivfUG0GXkTCQ1t9oNyO9wSFyBEdzLqzB52uSuY51w1A6SdzG92EBofGOIg/dN4Gu+LrBcpupytvJc4K4LQyTEE1ZF1GO1f+KS/DZRnHXYnBLrDyE/hPTxbRGEixQBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4yn3kxIvlE+alNL1muV57r1ci1bk6sVONSDM89pQ/Y=;
 b=sbL9Pt05wFlrgxw9EBQDC8kSd+c0GTYMG6UxDN44FYnT0Cvhpq+iTmOusJys7LIqhejqtmKSVpqXxTXqXYI25hilyjWq6+BG2YlQQzFcHKC0ZRvzfgcFAr5IQ9ZAr5GUETcYIAp9qX+/I7jYcYs1N8FMggKDISiwwlWGt1EXuug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:30:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:30:49 +0000
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
Subject: [PATCH v5 net-next 01/10] dt-bindings: dsa: sync with maintainers
Date:   Fri,  9 Dec 2022 19:30:24 -0800
Message-Id: <20221210033033.662553-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2c10eb3c-8557-4563-f3c9-08dada5eeebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MUqZobOz4YJzT9c+YvtY6SkOZ5C3agn9qG68YNyvi7lAWdND6EzT0wxfAethYr6gBL5TydsDrP9nrBMaqTfd1wCJaDTdUogud+iKn9KxtneqNlRQX3yO99yp8/fbiCLe0c3/b5KUehlBMuGFN56d1cnRD+LAcEGhVndpiaHBaPmpvAgY7ffj9EKQU9XD8o5udAgDhCVM0C8d5eDA577zI0aDRRSbq3jj76gVb8NerizyAtKOtJtTPDIkVgX7j0ggjunrss0a7o3QeMrL1cWaWrtJbuw6SdUqyW01cNy1uTxA4wzpQPfsJARTf/L6Jw++MQRmUsKi3frU5dIU/8ix2NdmB4Fmq2r1eF9to+apShO4RqXTAYOft1hKy1Xm2CotIxR+FwiFkrls9RW3e8a1B1N7Ef77mYAAJ0m/retkyK2uEpp8KzUYULWlh8ELlj1Zcz6g2NTSpJnyk2GHzRUt14rRFB38hL51O8XM67GkK62oo72zwmjZHjcNdu1dCQC+8XC5kz/vvk2MFA6g7UTBh1LdhYJg21hRkkywLDPwVoPVlhAzyJ5oQ4VuhY5dTiGUwi4VsjBzL/UGHRRSDqtK6oSSUQWGUs1DzXvvFq012DorQ+h1g3gtq4hzVzwPlXVR+/cNOWn2rEpwzkEsODA884GVyNWZe+Syhyz/uprPhCnZAmwO9eVdsha1ICOKwEO5wwx1tMyHHJVR9c7lAERQAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(396003)(39830400003)(451199015)(6486002)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7eZ8FfbCj3Ac5ycPgVUle1e4oPliw2VpygoiQD1xWPDYNKwHksbiQy2oCqNO?=
 =?us-ascii?Q?ZpoHztfV1bIv13Ns6Lw6GEyW31u9C6Wql8GgNVlSo/XAkmUL5MCLt0cOcZam?=
 =?us-ascii?Q?msPRJ1NQgMiYYSczDYosdSQEv6LwITwArnbwAJJCs7j8x5ZLLkFY2u1F/Yk0?=
 =?us-ascii?Q?Ifj9PaTWs3c268UXlVmyA+I3pT5KcDw/5u/M5mDzVCUrNvBUPvhQJ9VK+ixt?=
 =?us-ascii?Q?SEHG2yG2zP3LHUlW3R/fpNbYeHDBLUNKgf5BqT8uB/Ufc93+wrnPXUjDXPmH?=
 =?us-ascii?Q?cuikkt2EqvZYYyHsEWFat6Q1Hl04bvFQbWnbO4FMqeFUeRI/aYyMSqkCLWMv?=
 =?us-ascii?Q?UNbQqmeh2FmbuaomJjDbj6cDHduQ/QGIA4wlUQdc4WIEGGyyewFY/FaP1OiA?=
 =?us-ascii?Q?oFawFVoQ3CFnK4z1zIr49TYfOuX+42DTQZOxDMd4o/6J7UE+pr3ZnSapQ6V0?=
 =?us-ascii?Q?eg8q6xCFnfR9Z5wJ/8RSfQP+VNau0ptVN0fG1aMRlpedlwcPvi7RXW8DNblr?=
 =?us-ascii?Q?4SB8ehooZTclDlWqWxF5kr1lgIT+mEBKY4infNwENjPJrRGOzk2T2cbeeGXo?=
 =?us-ascii?Q?ZQYM9CbIj9MHssy6BQYA3p8l5hhEVlto4jNEy81hWaizkdXwokBob31JPq2u?=
 =?us-ascii?Q?zYDrNUjo+pMVVA5jWNs9G+6RbU2Cj6p3Ozco6UJWY5Z8QyCssHTwHpluWhm8?=
 =?us-ascii?Q?c0+d7suTbzD2VztG7mu7mQaBkXFdR+ayiISDWFeUFWkkYxlkBLiz8LVfozJv?=
 =?us-ascii?Q?O1m/AP9GNWOhUHfFJnXTQtMpJMwokd3tGyeeRAT4JqxJVAb5tgAafrxLycD3?=
 =?us-ascii?Q?oz5xz6fw28k01WlNqpnpUndhIrq1UNvZtLslfIcdZapMqEI9Yy8i/Fkv+Vnj?=
 =?us-ascii?Q?dj34aUvv3meY5VZfvS5HbJPaaA5vbg4erdQfV/rebA1AHWtb34ZqUIoBZ5HW?=
 =?us-ascii?Q?XMk1xtr6QQvtkFGBURf5J/XDnXgOLiWHLs1pwLZzxZtyFRWaCdsUUvNjVPf4?=
 =?us-ascii?Q?v76a5KDNmSb5518q+3q/2SZyRem51CRKJQueOym6kdueVL2ml8axdrkxYoj9?=
 =?us-ascii?Q?/RaeboMLSK1dNlHq/UyoYb6/BhUr2B7XUTgbJ9nriseUoDJJjaY1cGE6Q1Bc?=
 =?us-ascii?Q?KiN2u3wvuO3MhXT4SvItDWmYD09mu1sV3nZYqCnzJYOF8GmtbKW+2vujJOlm?=
 =?us-ascii?Q?LFYGlDlBWW2B0fq0SgRe3Qmd+Ln99+Td1NCCAs7Y+iagI9xBxJQ4tM3lhFQ3?=
 =?us-ascii?Q?4oad0bqHCYgfM7ABgPubbqounThvRqdzgMnH554p7FR81m66Wc+I/zZ7cvFJ?=
 =?us-ascii?Q?3fxR4QbPpTJHhbNNcLD20YLmA+ucXk+cnVAgO39AMFnrDInFNWfnbsrhxJXe?=
 =?us-ascii?Q?8xkLHBiAh2rlwmOuRxgLE0veCblno6hIT55oUekPOUP6JtX0K0ncdqulSw0P?=
 =?us-ascii?Q?Vuabwj88vb6vdssbZG9TMbLlWf6bASfG/hyiuC4xpypFiUdzTjwsMvgzRJaW?=
 =?us-ascii?Q?j205q3sa2JUl1BPWXRgzfI7iWqmEBpKXkPqedAp8l5cu74ejhj7p4fXtqWZc?=
 =?us-ascii?Q?rEwUYuuJVwR6scjI1ZjGYeVO/ImHlgDjyASabAaMD8OIf4BzMwyzSuge1eFo?=
 =?us-ascii?Q?SAfPatyp6B5WCy3KhgCcKM4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c10eb3c-8557-4563-f3c9-08dada5eeebb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:30:49.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmbS2K0ezAQ88cuufmd4OLws6ZvwpHBgqY/Ij5qa3JEU5v2fh72eDo1F/FXyQPp4ioVKtm9Oh3W7Z6TB3j8Wi6LrFRKiGZHqyNWBoPMSQcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAINTAINERS file has Andrew Lunn, Florian Fainelli, and Vladimir Oltean
listed as the maintainers for generic dsa bindings. Update dsa.yaml and
dsa-port.yaml accordingly.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>

---

v5
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 9abb8eba5fad..2b8317911bef 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -9,7 +9,7 @@ title: Ethernet Switch port Device Tree Bindings
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
 
 description:
   Ethernet switch port Description
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..5efc0ee8edcb 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -9,7 +9,7 @@ title: Ethernet Switch Device Tree Bindings
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
 
 description:
   This binding represents Ethernet Switches which have a dedicated CPU
-- 
2.25.1

