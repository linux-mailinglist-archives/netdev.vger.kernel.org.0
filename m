Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B3927AB76
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgI1KDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:03:11 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:20046
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbgI1KDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:03:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCmHXGQTRRrsmISzZtAwrlsyWpdAc0w2INcr3+kosZyg4s8n0FqhSXjp5yX63ROypy0hNYuEeQlh+uToEk8QoyEzSWBQa5iAR/S7Z2hv0k1ql1XXvmIP8k28p5p+WGEjXkBrh3CtzvHizkEhJIBxobJbgVYbkp9G1kHBoL+1rzavb8s1VmscdAsKLqdIrSVrZNlKJOCFTHprMa2Kj9ydIs0nsFek2W1AY3VnKA6NW1KuARG71+mpZl7OpVxJpUVA+iP0zErGDGKJWPosq6LAwRO67yxx/WgiKKO+wKj4ur9dxq6ScMMqjutOddCMMtQRvJcW+9meadlYM20hsd/Emw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voz73Kao5sfdCWENEH/Zme/ZX//wNmXgmMelYmmqA50=;
 b=CCYPk1S4HaspX2attr1yGXPhqQ4OHzeA1V4z9Kfw7xCsoUmXdEvuUdBSK5o3b4rgxQXwLTpg9dF9IOnCOBdEAf6orWRi0Zyt+eo9Z8Lzmfh7/lSVBH8kh8iP1cMtt81ajBjVT8o62wXOcDVEyF2+AXMKZmat2rYhyRBz+T0d30fmcsqyVm9aSlFlKPWfGCbzLV6Yk+uwUIpMjAf27jKhoqXnGqib+r8YlqEMcFVuLi+nPKg1ifh2GhYAPPJqgjfUjsHd/0WnGwZuzKjf0UxVRHbCFsCvAfqomZhgCp6Z8adfTKJGDyvHVlcge6tt2LJh/JLt1s+qNkn1OkLES5XSVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voz73Kao5sfdCWENEH/Zme/ZX//wNmXgmMelYmmqA50=;
 b=XbcyGoVbnx4/+z28MPmFPoG3mWzaKit8cepbml5ohgnwh+MY1g7qH4Fu6deuyh7S4d4vA7aAFq2D7hydrVerc+unDdeLib7lumwF7RvdoduPBYb89FZ9JBrsFtuMOQNmEjHdzmkaGEtoWVyT0n9a242jnPUl6mMQWQmI8fmsYWk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3769.eurprd04.prod.outlook.com (2603:10a6:8:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 10:03:03 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 10:03:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 3/3] can: flexcan: disable runtime PM if register flexcandev failed
Date:   Tue, 29 Sep 2020 02:02:53 +0800
Message-Id: <20200928180253.1454-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Mon, 28 Sep 2020 10:03:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5a3f4a8-a252-4f99-a463-08d86395afe1
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3769ED6BB690772FE4814852E6350@DB3PR0402MB3769.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FwLIupxNn9JaOrznTqMt7hCRM91RA8mhrjGUqHtvE5EmxSNt/o1rk5/CRY7RlmXGMTNbiBpVLXOFT0rzlUbtb0Urg5xJVO4ew8yI29HcbDaD6+y0lpulVScTTCCVNzgHd6le4HXrKUE5C+b+GaqEHRqtKprrTZFExx99Ph//3ejwuybo4PWVYyJEb4zrmbmM64vkK5GC5ijvUnc620UeJGIxyiyV6y2AusxxsYyKSnHXtmdt6GoXbeXG7eP3J+VzHKsIC5ERlDy2SyXgVNiJfyOLJFtwkfybMUoOqwKr1vDZDKRX12TD8aFnPp8xJExZtEYa6qNldeFC8x6cRvBmf8ZINQg8ETLybOcY3eNowUN06A7RYq+ONd9CJo7hQYGY/apLdAK0EYTcahdy7F3/lMsVFFN1Vfgl3N4h+l+dd0zltRBU1dGo3x4MaJSGICen
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(6506007)(52116002)(2906002)(478600001)(4744005)(956004)(2616005)(186003)(16526019)(5660300002)(66556008)(6512007)(66476007)(4326008)(316002)(8676002)(8936002)(66946007)(86362001)(36756003)(26005)(69590400008)(6666004)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E0xsNGAn/xRTK4EAvMjMD0G3UqBBl2ZjhQk4tiEjt4y2HZXpEl7irExEUVVdfg30oftPfyDR/VWSagEj8INerX22l4ND0GKt7V4XWsZSkvBiB+8BP24CcbK+1FFzc24lanOUNqKQGZurbjurt/N3nB+LedxVP0OmG1CdLbnwUt5G4q5LjA1q0kXssTZ4FXbemSS6XccMQgUqaRl4jZWbK4mdHtZ+j2H2kEeqzAbghQx2l80HD/C0FpOOIojJEFAWsq4ML61EEiFpnx6qy2yjKyL4S4ES0LVC10PX2w1PCRaGotVb/zg5iqeWuqwhH9a6xs4Rs/FPIf8ZmDLKObmXgVmAwwK/okuCsXnb5WiFDqBpeoGBkxNKlI0x1YDhYzBmOwG7eAsbmENdp/EmpxP5Kj0z+0uHDA3mxpMTPvYmEnHCKBJ3idKCcIdy8AExRWzCV/t3A8MNLWSbXK22XgPPFmSlygA3Ud3CnLZdFu1xey5LkxcwZG9Y/MPdiABaNoOtYBIxz94ZberD3Nd5rVpoMBlCPhRhOO00whEjXQnFXwWCh2wEQq60SCNAEXEX3EF6GunKPlF4tcQKzN1z1lcSZIInO9x6NHfVCBSlCB00HOVqPx+W4FCqoPwya9xwpMtf8++t5jtEqeYsw6xak7/7xQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a3f4a8-a252-4f99-a463-08d86395afe1
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 10:03:02.8457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhAwByDyHTZLeLZYdzQINah5W1Ain8yepCB97yzLSEXRfLHsm3phbUMUD4zEjehEtxDsDycfr2ZIcLQuK/L4TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3769
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable runtime PM if register flexcandev failed, and balance reference
of usage_count.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V3:
	* no changes.
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 925efc986b6b..fbbc90454df1 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2058,6 +2058,8 @@ static int flexcan_probe(struct platform_device *pdev)
 	return 0;
 
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
-- 
2.17.1

