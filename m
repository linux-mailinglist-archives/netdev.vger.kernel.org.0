Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AE4667DE5
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbjALSWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbjALSVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FDCF5A6;
        Thu, 12 Jan 2023 09:56:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLJpGkPV6U8krEUftqVOb5GWAAzAfwuup906qfJo2s/TrYntdonXOhfsz37pHNXfTxY73eYKRgezkjX+vQVge32Kk2Ncwwc5FySJ6BlHiW+7hTFn5nuqJW4JLnwB94rVILBlnghTGZm3MRZlFko41WFHVy6GRQMfq9w7saVaTiYBXpxxjO4eUo7c+3Vh7eMb17jrVhlML8eVBpUFLlbBILNvVigu4HfANqrNmaZmYC1gBxa00cH/02k5uMogTzoGCYl8cc7wR+yXsyy61lHoU2p23K+FczWdA4BSp9ZUMj6Grd6qe8aaTejp5ROs+itBsCjLN+9WoSYJFr6N20fkOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqvuJlWi82/9wzUwPpCeKdBR/5CC7D4vHwyTUk/tjU0=;
 b=Pg0JTHadsH3UZjBwSJG9LM2DiY/giXBwO4ipTI2daiTXZ5AeN0CCzbsH8fOBGfnY7zaX5YoRq3JyDxmohQjSfcdSBQPkdos9Y5ntfhu+0VRpXwHdMAsQs7n4BGvLVm5T9s1e3OhxEQE9DsAWlMteWqkTbgrPia4PMQnjCu9MZP662XowQEUU/Cn6myA4ujZIPzAiJxxalGJ8T2bp/Mxwk2V4bboYRPfVUMqyT0eHg3qwLfbI8VdAoWXGMAN3wWmRemUv64wPAxeOl496NZUVnhHJC0TA7tf11dNUp0JDcv8Yiyh+wt8DWqRKrfIIukT5lTuEZZtQq6gTJE2ZD3gSFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqvuJlWi82/9wzUwPpCeKdBR/5CC7D4vHwyTUk/tjU0=;
 b=P1l0danu4MvKu2GoGXu4cMEBZTssB4B3vGErFL4wvTCtL4iAjL8A0RN4PsQG0dHRDIaY3Nvzrto2HUCZx4EXefnboJwDUq5SSjjmyx8CvOKjhe307ZyyBNrAvsGm0fyEhF9xUa2kP0/7sJZebRtSIg7qWDPkldkC92G2uNFpa64=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6548.namprd10.prod.outlook.com
 (2603:10b6:806:2ab::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:32 +0000
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
Subject: [PATCH v7 net-next 01/10] dt-bindings: dsa: sync with maintainers
Date:   Thu, 12 Jan 2023 07:56:04 -1000
Message-Id: <20230112175613.18211-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 674df376-2ef8-4a39-1405-08daf4c656b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxFWLALHmZ6cB5xHaTyiECtZQ8CXpN00itr/YQuWDK1+zkOAHSnF013fz+0DeAolgiDCbQRtIktUJCrDTIj9H/240+7ZzkpoX5mclw7iZ3Jt02U7DcXMfBNcWFBdGSP/EcoDu4xRAtb2/k9i9yfz2O6rwx9iRVr7mX74Z2+CxMn4pnH6qTzFuwgJoZGJASi4lzpFD4oUvgwDsfn5mDABJe77pqW4jRX2WwvZvILd78IJl9J2nik8iils32G9gycH3luYWPdsBKhLJx+Si26dEfnoLKnhTwhJxxjhthLEuYwYeKCNT401BB7J0OtdFCOv+563Njp1OJbpq9xI09FesBzbEe9fnFfhTv1K3OYJiJ6/6Kiyi/egJ2M0+40Cbx43rINFmAG4pYqvqy2sFdDmnt0wCNiHr7IWxLn/G7EM/LrggCOtCYTwRgA5tzIh/akcjcrydJqmv07pL/Inx07oCGTiL97zIV01eZo2fwXZ2V1pbAggrC7vP3XCc4qcgsswSsZBCGBq1guAAeGbzkvM2qITuvWNUDKJtcOOmFAzOhtNJImrU8tHO6s120sT1+YXnaH/KNmYQDa6tGw10ZnS95ZMczSR/1VLKKJY4qIcZrgucfLzhIZLKpmMHjK6aCgzYJfz8SLxxHveoKnj85Qnzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39830400003)(346002)(451199015)(66476007)(41300700001)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(316002)(44832011)(54906003)(4326008)(8936002)(2906002)(86362001)(38100700002)(478600001)(36756003)(6486002)(52116002)(6666004)(186003)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ro8Iw5InTPWnCP8G7WobThq/4f2ZWnboHi9xlVe+BxeY9CUzyNV8Xk/0KuPK?=
 =?us-ascii?Q?JV8/i8nkqVEXPg93wLfnAqkamVjl3ABF9KGIUuQRhQgiZ+f/LI4HjdshWk9b?=
 =?us-ascii?Q?PPYKwwVjxjrPcz7YLq4kMXyNpbzX+SFWEDE7sT9YHe0iOaYlzu0CdLmIpgmp?=
 =?us-ascii?Q?vjDFH4ppwYuDAlvBE7yGunHhQ3kixSwWgacOq6LOhBJCfq2jrXRVbSXnEitU?=
 =?us-ascii?Q?sLYFLkCHJXR3ATd9G0N9VAiE0IoVgcwQt7EJ0LkO4pVTSYwM1Q/oP6aG9iBN?=
 =?us-ascii?Q?3NC/nUbrPvJNLZ5CS3CYzTchF6eQYhYqirCTwKJllc1TaGwEzkTk/zEjSVlE?=
 =?us-ascii?Q?AFe/99adDRYZ3v0iZNV5bpoQWrzWEW7V3MYiZlmNmYqHQDnW/FGaAgAxm0Vg?=
 =?us-ascii?Q?/hpaqeJ8sQdYTTH9WIiHqF2eA/JpzXw9kMvvVCZjHuI9kphywkKR8MhQQSZx?=
 =?us-ascii?Q?hvuzA/jP+iaL+wP0DU5ct8OZdXd2HlNiUrkA+2BAHtg6OxOwL2+tkUI+cNMM?=
 =?us-ascii?Q?OX/db/uwp1v9IVmXb6Di4zXylRr6tYJd0uuTzL3WWTScJ2AedFn+I7E9j4wK?=
 =?us-ascii?Q?sUQdhMoTMznR+IBhA21wdManSi2ZFrY/ISWyKBCVXCxanXO+mDCOxo/szfy+?=
 =?us-ascii?Q?qQXptR59Udfy1xgydgF4N79F2qYHSg4/bnHL517E/QjbuxrJAWIx8dTaHcK0?=
 =?us-ascii?Q?KmQIwkqFhqztDVu+Dvgs0unJy3XpGPTePrkff19IOd39xlcMY1+NCKa0jdmK?=
 =?us-ascii?Q?r+bAJbDa3ibBA1SC+vSmXKdsRizAOM4l3gIM6hUHIy/eSOeO2xkpxZqYcerM?=
 =?us-ascii?Q?Bvb7P5HCXjnJaatIEe7EhqM3xL2PHc+X8BZOkJtNvZEtgc4p7N/f1blsqD2A?=
 =?us-ascii?Q?UjMzcNEg4CzvOrtsl/iqgsuFTmKwmuGyZfYtv5fuM4/Pp2rHBpiaDy2BV0/C?=
 =?us-ascii?Q?fme1r60ff4exg1ehR5F7auXhCMeb3HcKTMWNFyT8ZpcK3bl4h/ScItFDbvAW?=
 =?us-ascii?Q?HFKoneQxdciVtMYTp+cFCa3akhJwm9u4LCxbHMx/xPsdo6jKTcTDUL8r69/v?=
 =?us-ascii?Q?xsIeuz2Ribum2UGbZs0YQmWcOjXZp4Cjwy5kva5LoyTPglkO4WtpfywibIpj?=
 =?us-ascii?Q?rMTEsnEC6ose6k7vHu/KAnOnVjiTv8XYIe7hf7P3kLHwjzaPHipH4AmySrGP?=
 =?us-ascii?Q?24UxGrdaIkR4NaZtjpXfLNREm672dqwO8FqdK4J85PjSqJbD43Ja7rDmwr3h?=
 =?us-ascii?Q?HZh+e0+YCfepyQLn+bLXrhLOuXJ+aonYSZurNk/8GQcgJPhLfzuSn1Jhzjsa?=
 =?us-ascii?Q?aM+E2nmCYBAnhPr0ib6KU/sWv1okCLhrOGNQ4N0Qrr1jcSI70fyg/4qr7UbT?=
 =?us-ascii?Q?iokD892Bezgv8mDVm3mFO+BdyL+vRQTlTo0HgLqVL1rADCac3l9FSYEWCEaT?=
 =?us-ascii?Q?2juDXQXqo9P5p6JjBHjKJ6iwLn115y75mGnPmChaw2ApY72Ze1+Nw4+MSSbh?=
 =?us-ascii?Q?VqUwfhSg4n3WvIX20/JRsFBvTdYZB4VjjB86cnGC7U8QOCMQyehMxUvTZCcJ?=
 =?us-ascii?Q?sesY2vsqfbxPWaCB9Jfrce8KAsXoZ8RoKCnnjm8ml6Qb6KOANlX3kuYXmPuz?=
 =?us-ascii?Q?pdKY03/E7RcTsx7fvz57+KL0U7sBlCW6fsz5VcN6ALdPYd1JQ77bv96UTNqF?=
 =?us-ascii?Q?BB59HxbF9arvmj49mEEdEue+Yy8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 674df376-2ef8-4a39-1405-08daf4c656b0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:32.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnm5nASBdukHF2F0q3Tr2vER7wKb69Wa3Wl9SBHgonnOzyFlpG/AK3tLtXracqxFem6fsGfo9VJ8+/JEZMXRzVXJhe75NmCVDp6qZQxek3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v6 -> v7
  * Add Reviewed and Acked

v5 -> v6
  * No change

v5
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index b173fceb8998..fb338486ce85 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -9,7 +9,7 @@ title: Ethernet Switch port
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
 
 description:
   Ethernet switch port Description
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 5469ae8a4389..e189fcc83fc4 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -9,7 +9,7 @@ title: Ethernet Switch
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
   - Florian Fainelli <f.fainelli@gmail.com>
-  - Vivien Didelot <vivien.didelot@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
 
 description:
   This binding represents Ethernet Switches which have a dedicated CPU
-- 
2.25.1

