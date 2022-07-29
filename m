Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1D5850C8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbiG2NVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiG2NVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:21:45 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492AA61D69
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:21:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTtFSIhzBYSUwPX1Gpq04waXWFFVbPYahgfna8mgkDwQ69S3WUPhk2UUtOzKt1cu/lo+C9z5VzHaJ/3yaSGJG6JCnH7JtUvdb2QOu+DxmaC4pVAYAYEfwhnZM2EtnkNR2ZtKQYt+IIbQ3WdppWAsFtlYrGd81iCuFEC4fzrtWreuij1nLyk1JU1PigniBzuMelgfmTfeKdKno1Ke0FUz29VxEmWIgx96bOv8i8GpORniQkvSC6Xx7z7eMMmPRijCBiNi8Oo9TrUeoRG5ARWcjdbGfDCwH2pTmvIHI7FVykpaIyeFybAO4vmBji7kKTFtF+8W/pvKYPOgL41teFjAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgJUnIQVTH1QrxQmmN6IVoh7fDfi1RkHR1+XcBRoAtY=;
 b=M9S1tCjlSMKOLgJljWwezoMXZZIsdVD/58MshJfTzn9JQtm6mQxIB5faBYqDruqw4F2njFht/FNE+9fBduQp3Ikc7wmeIltJi1tbygHiK07IbL2SIsCLDOqnDFFC83pEWntDfZJktMZNieMqcfmzCyC1DPtn6fcN4YfTcqaAEzG7zRm73fy+vHi4n3F2YjzvF4ombnIDCIasOgQryzQJnt9DufLirmwfVflf6c+lOG46YEyemjuhsT5E61eW8nZdxxIqQ03x0Y57pI3Md/4jOeTCp+VN3DAUQINBZd85gChJpNRJMDOYMHDwz7bDTla8hB8aFWV5Wqfb+u++WaWr9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgJUnIQVTH1QrxQmmN6IVoh7fDfi1RkHR1+XcBRoAtY=;
 b=EaaMigYscM4VRAzlD/Hqt8iD80MgTk7CfeJg3YWQK5bnAGC3dhrXio5k0BItsLW9YdNN99QWstkhlXbdRM1PBw1nIApvs7HAZTD7CLr0IYQzFG9v3PEaugn2UaDh5k88o8AuBcVwyOa42Hwlrql0s7DB+fQrMTTkYW9qFfdbvUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7497.eurprd04.prod.outlook.com (2603:10a6:10:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 13:21:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 13:21:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>
Subject: [PATCH v2 net-next 2/4] net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform data
Date:   Fri, 29 Jul 2022 16:21:17 +0300
Message-Id: <20220729132119.1191227-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e1ae26-c23f-4898-c128-08da716545f3
X-MS-TrafficTypeDiagnostic: DBBPR04MB7497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liWvbjUVxxRhvBv0UrjPCCsCspqG59Wrbghj605HUsUPPU9fQE4GUFw4QDf5rjehn+Y0BR3BZy8ly0HrIuare4ubVsKptwGVEvu8GtX3aGuh9Cmqyd8Wxarcn1yQ5EYnuZrCnbHOxxD6zrsUt2p10DG0cq5mY3lva8k4OOfVve6obHFUWAg3Acjes57PflqRh62M1q+Jbmf3PfpbXyLB63NQPiQQ/4LbrVwvveiZVf7c2nhTXcRg4seg0dlc63IZUOMRkK8/RpELoT2HFgN/3zNZRfrWrQOAJagAMVsCKmOHb3H/2ys/aGPe/r/Yi+Ir3ITAT7sT9jenAdB61Hhcyyz6HRAzJYGDxk5JI9GguG0INeHi0IuvZ0rdI+i6D9QFx02vdqemStnBt11eDLkgkgbH36b/Uq+pwBrl9ZQu9fxVVzByMkJn+PY6kGVhhs8dXCmP0Bbo5l3nxQXkdftWKBSnLGHea42xoKrqKNkYT17DqCeIupScWX32LLnQY9LYryiNlBknF2o6MNcVXA6EgrTzzWZPXVK23J5ipM+8eb65kO293g0z/5pNbtWsbwP6hlmc8t2wmKxWszD6oH17kznQVk4gKKbVT7LJR9uKPCbXTaS33GrpE5S7Ev1N40YEKPefoYZGBTeeQErx2gIzXQJ+rWjq1ld+GcHqghfP/I6ztJBXZb+oDRH5/mMmcqXn0mm8iei5kyDqawX1Kr2YJ3OFIT7gYbZ3ONJvKbwEdNrKZWvUP8zsWPWOTO1zf82HI9R8uqairG0I8FZKDDqF/T8isovYSuIWCIETVhWs13XhPSNYGWaP4FCnjzOv2kaZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(1076003)(6486002)(2616005)(478600001)(52116002)(6512007)(6506007)(26005)(38350700002)(186003)(38100700002)(41300700001)(83380400001)(7406005)(66476007)(5660300002)(4326008)(66556008)(8936002)(66946007)(7416002)(36756003)(44832011)(6666004)(8676002)(54906003)(6916009)(316002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?073BZBGXhezd+jJ3QUkXYHypToGP25KWG/Kjb4761GEOaY2uCLRYryoLq1BA?=
 =?us-ascii?Q?/npiCn3NulX9qetm3mFdqfH1RuPlx0uAGMO0Fk2EOCav2ZVvtcxPhKPo0Rtz?=
 =?us-ascii?Q?vPeGztLBPw3i/baR7WD9ltpFNXyZnLa5qFUrc4E2T9Xif0AszcJrwW/2eA6i?=
 =?us-ascii?Q?kCy/CL3RPjjP6V/f0y/iOYe86MDVLcvlWBXHQisdJ+BayqLoX3NlFWf6bDIn?=
 =?us-ascii?Q?UXlZATHbNm268HNy2fINefCOFU2YvaXsHyfBPBSLwv2z8CfiMsyYhI3asIW5?=
 =?us-ascii?Q?kofrFwCmExfNQwFgYQu4ILtySbXdyc5bZwbuR9G4lr/rhiB3vSikuwb57uw/?=
 =?us-ascii?Q?/JaeOna96XGoPSipuDHrzEcSbqyJGz73xc4g5SPCyWDTExsym4Igse657u7z?=
 =?us-ascii?Q?WFjdu5iJ/9bO8vLJmh/4p0/ETNBevNZCRqInMP08xu6XFpJOPAXYBgpoDKC8?=
 =?us-ascii?Q?2XL6AzChIEeYyEzGVikfQNmaQoNTZzsNJUsyhoantV9TTVbQvfzHsAO/e+xa?=
 =?us-ascii?Q?+jCnWt1IZSTEGsqn822t5CZsFhANin/cqU2BMG54GAuSEMVpcFNgBD++oGrP?=
 =?us-ascii?Q?6O+Yy0OSkwicqt2dnJxeQB6dQr1fGX8YPv0frSYQZhdnzuR81yXOLSlpYLjl?=
 =?us-ascii?Q?5wFzpqS4F0ULgVHokvecOcx3kpram3F886VOmolOekPuEttvUy1zWERTVyoF?=
 =?us-ascii?Q?zXhUEy21ILWkgNw5Xp6RlozPfL/ofBZYgwan1iqe7x4uccda1HJJuZcFzfSy?=
 =?us-ascii?Q?d8D0NsZXcwxo6w/Q58HV9Y/+8ANamqDFmnXeHt6IUCs3GUvUGWSedQzWNefa?=
 =?us-ascii?Q?uFT1RmFwsQKusVpsMrmMFeKg3qfZm4BMcQWNXQPyDBA5F44Gly7i07dcm9nG?=
 =?us-ascii?Q?85Q63CdYNAp4jIqdmzVMCrbq6E4QkFWHRwVYJ1isZyG9+19wAOeh0C4b5i5L?=
 =?us-ascii?Q?W8WKEKiXqqXbjZzppmfBwEtDI0QWqSyA5LSmzml3J/nU3D33/cU95hjbTR7D?=
 =?us-ascii?Q?3zoFjdDVO+ILs7lb0ToOv8dyDKQ5KajOud2LB41lLX2I/58Qm0BxkwX9XWAI?=
 =?us-ascii?Q?GOmdrGh66IDoig50PnCo9SJyBQVNOxqezxt7mjApYxHKQxtlPVuXTLCA6Jhm?=
 =?us-ascii?Q?F0meoK/RrM+wjAYTSlEn4pMGi3PHAQlnEpyF48BeGxSfPgZulSxQy8YQmzr3?=
 =?us-ascii?Q?RGx8Dkrz06CFwC5ZT9b++XrmeqmuQMBoir2o4txVjhAajx4WveRAFEDNAVqe?=
 =?us-ascii?Q?cu/L7BlVx5YRS+Fh1p5tUEQW/oeBwTbETgaNAkd882xufVIINWCJ8pGjHkiy?=
 =?us-ascii?Q?tTF8HaV3tWmyzERgYiZKjEB9bQ8oQkT4x4g+DfAgqOBf4lnLNxpvO9I9/Jaf?=
 =?us-ascii?Q?3qjJv5N37r31m67vW3Utyh+hl83or9BfUiN52Xz20uZts4fJxr0IZ478JgLN?=
 =?us-ascii?Q?vDr7j5eESouVgCkToYkMdxLOQovx7QjFxMn6xRDxtbZ2Ctawl76LZ+IG07bQ?=
 =?us-ascii?Q?WGw2wux//hNOHFHVfPp/rWouMx/+LM9KTZH0fGqwWfxD+3igjfnWmKXYkwzC?=
 =?us-ascii?Q?Mfc+16A6loQhnV4M4i9eWpDWsDyTJE85k3IHreME8EfzG+nZn0DEF/YMuM8g?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e1ae26-c23f-4898-c128-08da716545f3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 13:21:40.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sw8AN+lN/xFH40XF+F4+2tspHW2axFnbJ74Tm5yqsRWaRsXFxdtmYDSLwoW2l+48AEoIoPr1c/yR1XH1rECNIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa_port_link_register_of() and dsa_port_link_unregister_of() are not
written with the fact in mind that they can be called with a dp->dn that
is NULL (as evidenced even by the _of suffix in their name), but this is
exactly what happens.

How this behaves will differ depending on whether the backing driver
implements ->adjust_link() or not.

If it doesn't, the "if (of_phy_is_fixed_link(dp->dn) || phy_np)"
condition will return false, and dsa_port_link_register_of() will do
nothing and return 0.

If the driver does implement ->adjust_link(), the
"if (of_phy_is_fixed_link(dp->dn))" condition will return false
(dp->dn is NULL) and we will call dsa_port_setup_phy_of(). This will
call dsa_port_get_phy_device(), which will also return NULL, and we will
also do nothing and return 0.

It is hard to maintain this code and make future changes to it in this
state, so just suppress calls to these 2 functions if dp->dn is NULL.
The only functional effect is that if the driver does implement
->adjust_link(), we'll stop printing this to the console:

Using legacy PHYLIB callbacks. Please migrate to PHYLINK!

but instead we'll always print:

[    8.539848] dsa-loop fixed-0:1f: skipping link registration for CPU port 5

This is for the better anyway, since "using legacy phylib callbacks"
was misleading information - we weren't issuing _any_ callbacks due to
dsa_port_get_phy_device() returning NULL.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/dsa2.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..12479707bf96 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -469,10 +469,16 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
-		err = dsa_port_link_register_of(dp);
-		if (err)
-			break;
-		dsa_port_link_registered = true;
+		if (dp->dn) {
+			err = dsa_port_link_register_of(dp);
+			if (err)
+				break;
+			dsa_port_link_registered = true;
+		} else {
+			dev_warn(ds->dev,
+				 "skipping link registration for CPU port %d\n",
+				 dp->index);
+		}
 
 		err = dsa_port_enable(dp, NULL);
 		if (err)
@@ -481,10 +487,16 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_DSA:
-		err = dsa_port_link_register_of(dp);
-		if (err)
-			break;
-		dsa_port_link_registered = true;
+		if (dp->dn) {
+			err = dsa_port_link_register_of(dp);
+			if (err)
+				break;
+			dsa_port_link_registered = true;
+		} else {
+			dev_warn(ds->dev,
+				 "skipping link registration for DSA port %d\n",
+				 dp->index);
+		}
 
 		err = dsa_port_enable(dp, NULL);
 		if (err)
@@ -577,11 +589,13 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
-		dsa_port_link_unregister_of(dp);
+		if (dp->dn)
+			dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
-		dsa_port_link_unregister_of(dp);
+		if (dp->dn)
+			dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
-- 
2.34.1

