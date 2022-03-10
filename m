Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437624D4C97
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbiCJPBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344521AbiCJPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:00:23 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CF718CC42;
        Thu, 10 Mar 2022 06:53:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9ohQmyvdGKpxP2VpTTIw2uyVVS5i3jund3gMAaz4I207GtVp4D4SXGnQhcPVs29aQ2pV8X83m1IozL0+Y3u/Vm8Kr8gkTITZBsYnoV6dr/JHY+AoUJzjhN41mgr0GNKB9YsGpEIPTyFI1Xgl5ik4dkrvu3fQarHgfOb4jDlS0/2JyhL63HiodbR6XEC5dMosctCZkjo6sGL0/Nmf0qd5Zj8H7oZ0eHQxgsGvgFHPUlRbrBmH6fVgExHmqz56eFj4gp3tCvfe+/hN97D9yycmVM4is3PHbgWv2RaFzGg+/CecOLV5353LJzNgnUHgdnQiRJDgAuYwhRfXLMRHL2DVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGY7Ol/aUUeOiUHJoTneOAN8f3TZuA5CSk8d6GWhUV4=;
 b=MweQpvX9StZGgu0/KJF0VEwPLIsdECivi3vP5OeDSIfvOGIPPkXUkrf5QRYOzTPTucX+Z84t7n8U5by+603Gg4EOoGxPerp1SfUAMnlxHlXxsXJ7/Ys2qKJTyuTiQ/1PfsqLjM7/2keEPItjZjX+EeFztmSPW/ahD7Qt46vqmIeN8pGikey1zb6GgHIi5thWAh1yZydvbuKxwT1bPtCiB+ZbKYq0SYlAtc6fZR/+AT/3dbMVqT/rT1mximTRFLUrmjGHDDuoHpWoYtscZ5aGCGxaiCZi6z4bjWhw38hBMKJrC3lnTJTk/mOuNVLEFmkGnruauEcI9AzuEckgks0YMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGY7Ol/aUUeOiUHJoTneOAN8f3TZuA5CSk8d6GWhUV4=;
 b=MwWd2runvpQPKFZljH9Xu6kGXZznoAjnjBgK6jxJ6LsaeuqIZYflIo7gHn7JAIs7PqSinTpbvvU7jBvECkNP536TPpFo/uC+CxpUVrW/BcA+j5Dd52lsay06wXA87XLMFVxRSLVBYp/qCoIq2G1jKP8r1joWBPnyfRKrR0og6m0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:31 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 8/8] arch: arm64: dts: lx2160a: describe the SerDes block #1
Date:   Thu, 10 Mar 2022 16:52:00 +0200
Message-Id: <20220310145200.3645763-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 688160e5-7743-4bef-e6e2-08da02a59ac1
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7281D6C5F25A24B6CE772BC4E00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: srjT4un0okAh00YC1rhCfNpLt8UMVVeKrITnHpsPID8gg/4mAPztdrH/COsj845OfSSCwpvjA6xC8sN51JRqkZq3FB1HXLa8zxDQ23WFu3UPYgNP1w3F22NNAVDQNBU3r0pw5qH0FRFoUSplNKVb6DbCtm1rYiQHYSc7zm5dvLNhgG4btPSMtmNXj+JFYnghzo/jTyJRS9xzb8b6NijdjAfcjElu5jIy4nwSJ0YYFQRQRMOOVj905wZjktK5msDxlKT7Kcnh3Dk5e0fh5Yh6Sjl2mNb9zmEa6ykYp1CihBJVHjHQw9YWRGTPX14KAJaCAkLMMb+uOS1CosOkFJgJnxqYFRUDOC0k2XSaXHiN5T3E3PnhTiG/cCiumn3GlgRBEXuMt/cAVPNg8VAUL4ceP9o8brHkq07rA7VS1rRlO/1sLpLGe6Gfj9aJeVOizuZVLx523lSLYr+PUwIIe80evDYMoMASylGoklBHG3O7V+zXMLpPzA+cqrtdcZ43i8XPXfvtp3rAPD/dBoo4D0RjdWVBGsLbwNCWSMqdLxiTNYpxL/rbCUL9epFOFrKkoT/9WLjBFCnliJnPHH9BUnyXO6QE2ROlojl7EoVHjnADLlpMI+fOknlgQBgIU6WsKpyhNqRzvFeocIPNz4T3YcjaAP8erJwoSkI845yo4l3nEHsO31Y8A4GQWBDw/eLIEsFhOJIgw6ZM++WQfTSgKjQD8zgCuOipnmi2CDqg/xTdCeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kYJXuWjrPZhNmCrjawlcET29w/LFFgfjZkeDvD74ZSSADcO7Skzd8ApHVPcx?=
 =?us-ascii?Q?AuI7uR8NiikIFydzB/r0rb7MKrfoulfeDslhPSMjQnhWfVny7nQFmm0CWbuW?=
 =?us-ascii?Q?Yf6EHULjfdUuFQgGCbX5KpEbLDXwW9b7lKJHSmDplDyOkD2j+RtDXz0kDzz8?=
 =?us-ascii?Q?jP7aVlOmMhbp081Zl3xscFlRcmtDtGMWdMKqWUT62bd/jPYrwyN2Kxfy2ITk?=
 =?us-ascii?Q?BEW7NgFzMvQvfyr6LeOsrWQ6JsAgVR9XGhnOO8SgQ1YF2YiJrycipOuThwuC?=
 =?us-ascii?Q?Dy1WFVtl6xQNCxGqM/nm6rnJrwhwqn2t3bIEqoa+63CSYb8ZZk5pZhVpE8d5?=
 =?us-ascii?Q?wUH6uF/zP4VwJRnNEqWxQilIkdCo5zcSHYOrI0Xmg25zd20xVcU5fWBXON89?=
 =?us-ascii?Q?E316rmf6SAOt+XKMFVpcts2A/BuH/jH3R1bNG8wuvkTtIP6yo9fRXsQbTyuE?=
 =?us-ascii?Q?sW91L2pOrlrUxMRXSAwNjlVK+Xu+/YC67R5/+qg48akWbrZSAwMyqcpJ2sMn?=
 =?us-ascii?Q?vAIizm7d8qtxlw6pV6ZJmUUQoIJBxkPx0Qs5vfKl32oVWFImBZ40PGT47rWp?=
 =?us-ascii?Q?zEXVPAMkHkVzZPKrK+7byURqynm9ezAqSFqExJspvMHKm5tI8FLXBV4+/Tea?=
 =?us-ascii?Q?RM92cby43d1BgEe02fLNtN7pXY2+jDrzTDN0xFJ9EDO1nbTKZPClxD+1dMfM?=
 =?us-ascii?Q?V9dAgaVuXuFs2/ssVIZ7u1pN5oQn53JgQh0k9ic+DTu32xUpgmkrAjPgyPSq?=
 =?us-ascii?Q?2BTTOixdHGwV/WIlm0Dc3MlT/RaAAIq028pUgNUTLvykRt/15sXnuQjkmXOE?=
 =?us-ascii?Q?qo/+L8XHPbLiY6LPZCq2A3btf/8fCO6QnQ1K3VE70jHxFJ6MP51yUeXHBAZV?=
 =?us-ascii?Q?I/FijUSDaoNfj1aOwzTIBTB2cL90RJFhQdnJs/etIHv5RVov82Qg05WBkyMs?=
 =?us-ascii?Q?eugR8fjXNQ4+2hpAkhSWJpIJ/zCLwz26ABBkINRd5NzmHq2+CaDbeDbFV0cM?=
 =?us-ascii?Q?DWtKQ5tnHtBmlvAO1BsVvOD9ou4Es4Oz1w7aFCyTA7+O40VR+lpqzX88A8Qu?=
 =?us-ascii?Q?xwl6OXyPVy+XbkYcHlwv+6M33gLV7JibrbH2v3AIEuOKd/xc/gXQokFHkWEk?=
 =?us-ascii?Q?DRkW8XyoG/SbRTMO4X/TnULKfFE4D2FtRyUCBS9AJPVsL8wrAHX/7/rQq5kg?=
 =?us-ascii?Q?ZmIdOcetqKEnzuzHEo+/tTGY9ZQ8d4iJopH0WvMF46KbwABMNX3BSvrwJj09?=
 =?us-ascii?Q?GQO4W5f88nh86rhk4xQm3qmls3Et7btfQ5ylCq/qwjWsDVeooyvBoRgqq1Gn?=
 =?us-ascii?Q?W24pWooSzM1UPs5iDHkKdElQgmFvMPuhuvg+Bsemr/F7pMo9wfDdsNPUVIY0?=
 =?us-ascii?Q?P9a4gGGDGu7NnKE+oZoNsS0DJvXMQ3jhjiQX7Le6lwFi5kJkL2EhzUHCoQzV?=
 =?us-ascii?Q?WvPbeO6DEWf17dAU+gW75H9I02NQ4zhZ4rlvMzR3SFB5cqsLfpEBbk/yGLkH?=
 =?us-ascii?Q?xQK84J8cPYSwXsGAzTqPXe8fSNaIgxXjxHEZ9XVSnVWqRFD9pXKttBZdo4cd?=
 =?us-ascii?Q?yqEK1Xb/ZWn+OdL+wp5SIF5j1Mb3IL0nWcznPoIDVqX/h5N90AbA28wMJBy0?=
 =?us-ascii?Q?VkwZInId2PDf3JsmB81bA7s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688160e5-7743-4bef-e6e2-08da02a59ac1
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:31.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LfTyn0dP/wc8c0xBQHoANTBGKXRcYEb2EOM5KkqgGXXRp7yY5YJ/ZCE0thM2GqxKxZLV7paYuJKjDtw/XPsTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the SerDes block #1 using the generic phys infrastructure. This
way, the ethernet nodes can each reference their serdes lanes
individually using the 'phys' dts property.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none

 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |  4 ++
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 41 +++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 17f8e733972a..14a6334adff2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -63,21 +63,25 @@ sfp3: sfp-3 {
 &dpmac7 {
 	sfp = <&sfp0>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_d>;
 };
 
 &dpmac8 {
 	sfp = <&sfp1>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_c>;
 };
 
 &dpmac9 {
 	sfp = <&sfp2>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_b>;
 };
 
 &dpmac10 {
 	sfp = <&sfp3>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_a>;
 };
 
 &emdio2 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 7032505f5ef3..afdbc0dbd47b 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -612,6 +612,47 @@ soc {
 		ranges;
 		dma-ranges = <0x0 0x0 0x0 0x0 0x10000 0x00000000>;
 
+		serdes_1: serdes_phy@1ea0000 {
+			compatible = "fsl,lynx-28g";
+			reg = <0x0 0x1ea0000 0x0 0x1e30>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#phy-cells = <1>;
+
+			serdes1_lane_a: phy@0 {
+				reg = <0>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_b: phy@1 {
+				reg = <1>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_c: phy@2 {
+				reg = <2>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_d: phy@3 {
+				reg = <3>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_e: phy@4 {
+				reg = <4>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_f: phy@5 {
+				reg = <5>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_g: phy@6 {
+				reg = <6>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_h: phy@7 {
+				reg = <7>;
+				#phy-cells = <0>;
+			};
+		};
+
 		crypto: crypto@8000000 {
 			compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
 			fsl,sec-era = <10>;
-- 
2.33.1

