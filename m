Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501F6292341
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgJSH6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:58:25 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:61410
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728423AbgJSH6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:58:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hp/Crg4djTaPAgcSmFphLTYaaF2eZHoHOgghkgG0S586ekVfb1YCjBFIZ/2KN1U54XlUXkY6o6/bmKFuCoFXo/aArd2SspIKUVMJycNURjNDi/jGaWVq+UXXYtiX8mTlqQNtNdF3QS9X6ED55quRqVGKBG0iMMorbo+7GLyEWFdpT1pdl2xy1fw/dYCmgdIt+sirVjL1uv9JhXkToQq6L6nJrpucsjWtpaA6+vx77hA52muEI9W5yxySF1+VCSSsxRBnHYLMQpW+Vfx4qSGulfbIWBAw+ak7QbfqARgOhJOReYDxSGzx1277DrkN/4Mjjpd0ROaxQXrIHxKn92wZhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5xuKQAQda6WMgDOX2SvDxTU5/aWbfXr5OA6dTBscEI=;
 b=XV0yJ4GDbFqRSy4CXn+4WjNeU9vv65jXB9dH5h+3RBrEALbBYNc0FBEa3F9pZ6nZKhGyCuVCJinTnSvknYCeLAwzpbxuAF3IES2PeOjNGReqduvlI8cMoMmiHV1B7QiNz+d+NwG+B3gsdat7zzo4DSBSbk0+wzx5euQCz/6agh1/bCuollcFlByVmWPrBfKUBF9rpNaRug1+R2fjcfRCm19mFIxbuh1g7l1E4/HWPqEveo5vRMUFSJ10w/CnxlPFp7uLR5In4KcO55poBzhwsVzXTS9lqHfTV1AQXw31yGsA3vHxWYIRThlW0jOf5A/W7C8NoM8YTkWPRjW+3B/Jvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5xuKQAQda6WMgDOX2SvDxTU5/aWbfXr5OA6dTBscEI=;
 b=KRno9dzEJJYnr+TPk4p4XDIQP4At6AQEprBzANTRfnjcp7zfsuwv3WPFs0cdIEtTt5DF+uiONzF1yJywxq3NW/t1gUBxv1QTW/VaEIFEmkSifZ/fGCBkz8TTkklYWuxHtA/m0p8aeCio7+UZ6P5+siLsn93Eaz4awhAev3mmmkw=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5852.eurprd04.prod.outlook.com (2603:10a6:10:b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Mon, 19 Oct
 2020 07:57:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:57:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 5/8] can: flexcan: add ECC initialization for VF610
Date:   Mon, 19 Oct 2020 23:57:34 +0800
Message-Id: <20201019155737.26577-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bdb59c9d-11de-4d07-b094-08d87404b196
X-MS-TrafficTypeDiagnostic: DB8PR04MB5852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5852B7DA4C575E17A8F05716E61E0@DB8PR04MB5852.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vW1cbHYfsLrF6axrkk8GUXPIBieie8aOF42B6LzoWBX4ddHd91fj84F7AgmXWrDoOKSxKQBhxNvpvTB0JdOOeYa0F5NmyVuz+1aAE7C0B2DJr4jDmN2DZjbSzFTOlEFYS0mdT6G9de7C8uT3GcSzl3ZdDL3s8K0HC/jaW4fq3jFxQofPuU6VDvI0UDtCE6xJDrV5zWG45yMvfcDPdoVMd1IJUUCHeLJhAeRHdo4mOA2D/33ujIMyhb2BtI8p3T616+KOcl6K2UkkGX0/TrtRuTaGdUVtzhJwiGCCdt9GsE+c278NrPbOgp6MfJ5wc0lcnYzz+MJY7lzSwNiVa2pT4ks7tVoEjib6MHGDdDR1kXlIDnkjOMMOqnjKk8s+WN+A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(5660300002)(8936002)(8676002)(66556008)(66946007)(52116002)(36756003)(66476007)(6666004)(6506007)(6512007)(956004)(2616005)(83380400001)(316002)(4326008)(26005)(478600001)(6486002)(2906002)(186003)(16526019)(1076003)(69590400008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F1D+L2jpTasPCuVYH9u10oaOw9HDhMo+Lmkn6NyYG3ClSHTt/Cl0PMLBSNAHqorUPgdet4Dkv6UlLKojY5TUTTttAGLdIhbmX0zzWAUn6KpDaPSVEr5iMzLMscJzukhzI0yaN4ZKZkb51/65NcP/hvSbQD3njQgBF2PZ9RDtyXxFtoviPVhKMqDXIfRjH/88RxoDSar3bXraihXVCcapZDCnzQXbsnOZyH+GO57lNI814xjBl0t2gc0134oT2LHIGbfZAxTMxmffV1cNe1y2IglCbdKLIiXbhDdhngdoGQlpBFMDy3bEJk/sKMUwwW5+VnGuFH7ZGXtkySmC/kn0RZ8FgD7Rtv40P3kUuHEIfBXtQRARXSeEn4TfP9gyIhxsKJCm7NpwRpSVay6AdDJTLSzHbpTUEahLsBFys0qjpsbIttu5INu2fRD088MLkURwrmUgIIrXdO7gor8R0vF9WsceLdJojb691y3jDY0D7tR5l29/DiQ/RJnN1dP5erpNg4eH58YGDrebJmg6/hZF6uNOhFgMOT1mO2/9dQeelojHzsno2eu+1KaYKnUzpn7spcHN1cdZx9jMor1RgwOezueyYfCLX6KuESpjpgCuDWEfz8zPL3ZBUGlRWRc54KxUFcXe30QJPNLDH3ntaDZFbA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb59c9d-11de-4d07-b094-08d87404b196
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:57:58.4752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNiwL/bUi8EJAkgE1EmSLujis+FSq2kIrbNEG2+2oCjgr4PSZbsaWNyU+hrMfHukGReLt4KpBdiOjuCJm8wIIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5852
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SoCs with ECC supported, even use FLEXCAN_QUIRK_DISABLE_MECR quirk to
disable non-correctable errors interrupt and freeze mode, had better use
FLEXCAN_QUIRK_SUPPORT_ECC quirk to initialize all memory.

Fixes: cdce844865bea ("can: flexcan: add vf610 support for FlexCAN")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c2330eab3595..06f94b6f0ebe 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -400,7 +400,7 @@ static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
-- 
2.17.1

