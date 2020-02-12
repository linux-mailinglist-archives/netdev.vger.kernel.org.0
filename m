Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA38015A838
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 12:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgBLLtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 06:49:14 -0500
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:24135
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgBLLtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 06:49:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNYuaIObkEvpDBpXVrLAfzKYfbZfyU9tAkm2XepaOEQxfagf3MahkoHBa1D4sMmly+T6Qqr4UUYHCHxvtKibMlXUczjZjba+nadylKuwxCQlYU+IdP6Of2dThGpLo4Dc2MbPXU8E5CnaVRI5LWvGrnfqV75mF3OkGzCGodMetuzcKW/LYyRNvMvVNct/nqlOk3dMi0fU6rUBggvOFghu1InQO/dQDTjo1ccDzvjFPZvamwhe1o7yV9xpN6Luf1xYsIQ1jcU9wTizhvKhLcx+RDJs+Ys4KDijJr2ifAJmJYH0NnpspZcIgr5ZvRGYoleo/xLB9JIrQOQWDKY0KZIPcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpivK3RpgvofkwZyVenihhJsrmt5f48FTn0HQpqg0lw=;
 b=ausmD+TsyN9a7R6vcGeOwgBMsU1ZK6KRoY9XT7PdNzyHOdR+fajsRoggZ2CDi0ERrGziDmJxu7ct1ecsV7SZha5Z4knt9V+UFImQBfVqHHWwkLxCKY4snB2onUGww6XT7AR7unpziyFwouB1MV/f07UllyMfAqelEHSmBRRnlnYNFZRyEwsnxSAih5hK2oc7SH8e8RLqrpUg5Z+reBQSOdyj/eqK8Xm2iGFFqiCMIA6WohyWm0wADBaWUvse6zzghmAiuxWk3sAfSHCDGFtABBp8LB6lugxoqQSH6QvI4atNlgxv6nMBtj+HjRZ4IxmX2dHp3AdkNTeghEy+QJ51WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpivK3RpgvofkwZyVenihhJsrmt5f48FTn0HQpqg0lw=;
 b=Hw19kpJ0O56k9oAGcdcNS61McbtbN0Ja9MKxHvgzQ59GR9pLTXDIvuP47ZqrHPMZRgthujJRlS7F7TyeErDXHmgSVTW+zgN4F/hkOgdSrBMzEENSNK9cpAQzmkZEGuYa0kHD7YPCpHcIbXQuBoimsDYPiU3JCc5b874ah8fGrNY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4826.eurprd04.prod.outlook.com (20.176.232.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.28; Wed, 12 Feb 2020 11:49:07 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::5cb4:81c8:1618:5ca%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 11:49:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next] can: flexcan: add correctable errors correction when HW supports ECC
Date:   Wed, 12 Feb 2020 19:46:20 +0800
Message-Id: <20200212114620.15416-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
MIME-Version: 1.0
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0014.apcprd02.prod.outlook.com (2603:1096:3:17::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 12 Feb 2020 11:49:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9ec7dea-fd4a-47f4-542b-08d7afb190ee
X-MS-TrafficTypeDiagnostic: DB7PR04MB4826:|DB7PR04MB4826:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4826BEA39B230B1E1EC66B04E61B0@DB7PR04MB4826.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(189003)(199004)(52116002)(2616005)(2906002)(478600001)(66556008)(956004)(66476007)(6512007)(6666004)(6506007)(186003)(86362001)(66946007)(69590400006)(4326008)(16526019)(8936002)(6486002)(316002)(81156014)(1076003)(26005)(8676002)(5660300002)(36756003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4826;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1bply29XB8zKXIMl2cP3LjoPuZ9gyCLUWnf88NrRIqXzfsNmlUdKYmpFy6CqXHVf9ehL5xEP4uxK40WveyAhjy5n4HcLk1EL54RfFa1elQ7FpHOWXFcEyd0uOawpAMwXYk700yve6LEpW8shDQ+i+/Msh9Wlbqq3WYEIMh7auBOt5ivDGWc4BWsk/fSBjAAVwpV9Ma3mS75gANiJ3CWaFDNE6ADQoL/YNtWPDMJdmHAtJgLIugDZT3rDNkgLWhWNFW/VxajxdS9HZHHyld97kBRiBaloesaFR5x8uE/SJCg7ty6bya9K277BM+kiDQPFK7em+LKQaAucuNDx8ApXu6msDaN8obtSKbZrbQbeIJBXVVlyMh3CjwVd7n3torRnH/67oq3BjWJhF2ewu4uYtbZI//EHQJb0rUy6KmADrt1B+zuAiRC55XVewDso6C4IzEdjl9er1eJR94eVY8bYDP/geMWI/uWDQhMYXtJUwHnwp3PdJ9iGoDM16M4Uw4XvQTmDstUKBdxSCfAUClSmsv7V0UwyOB1/nlhKg4qqPAg=
X-MS-Exchange-AntiSpam-MessageData: PvZr8tmepptsbhyK/L3cMBjiV0EHOqVC/Y44nlQN9f9l3kxVZAgll6tSpSlTZnXZZIacpnSi2kxb4Dpr96GC9BgQpLXw8QPJNbIxLDWSYQIE/EWzHmU2FZ6e0ZXDOsId40z3I75Tm3/l7cBRw9q5oA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ec7dea-fd4a-47f4-542b-08d7afb190ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 11:49:07.4923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wy9bRUdzvuKKzXYDuTAS1lMjFhiEB1CqBrk+I8pQlWMbEoiNJmX9xUmgXXJLsMgPg38HbmnzUN8JfDS+7ew/Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4826
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
From above commit by Stefan Agner, the patch just disables
non-correctable errors interrupt and freeze mode. It still can correct
the correctable errors since ECC enabled by default after reset (MECR[ECCDIS]=0,
enable memory error correct) if HW supports ECC.

commit 5e269324db5a ("can: flexcan: disable completely the ECC mechanism")
From above commit by Joakim Zhang, the patch disables ECC completely (assert
MECR[ECCDIS]) according to the explanation of FLEXCAN_QUIRK_DISABLE_MECR that
disable memory error detection. This cause correctable errors cannot be
corrected even HW supports ECC.

The error correction mechanism ensures that in this 13-bit word, errors
in one bit can be corrected (correctable errors) and errors in two bits can
be detected but not corrected (non-correctable errors). Errors in more than
two bits may not be detected.

If HW supports ECC, we can use this to correct the correctable errors detected
from FlexCAN memory. Then disable non-correctable errors interrupt and freeze
mode to avoid that put FlexCAN in freeze mode.

This patch adds correctable errors correction when HW supports ECC, and
modify explanation for FLEXCAN_QUIRK_DISABLE_MECR.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 3a754355ebe6..aa871953003a 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -187,7 +187,7 @@
 #define FLEXCAN_QUIRK_BROKEN_WERR_STATE	BIT(1) /* [TR]WRN_INT not connected */
 #define FLEXCAN_QUIRK_DISABLE_RXFG	BIT(2) /* Disable RX FIFO Global mask */
 #define FLEXCAN_QUIRK_ENABLE_EACEN_RRS	BIT(3) /* Enable EACEN and RRS bit in ctrl2 */
-#define FLEXCAN_QUIRK_DISABLE_MECR	BIT(4) /* Disable Memory error detection */
+#define FLEXCAN_QUIRK_DISABLE_MECR	BIT(4) /* Disable non-correctable errors interrupt and freeze mode */
 #define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP	BIT(5) /* Use timestamp based offloading */
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE	BIT(6) /* No interrupt for error passive */
 #define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN	BIT(7) /* default to BE register access */
@@ -1203,8 +1203,8 @@ static int flexcan_chip_start(struct net_device *dev)
 	for (i = 0; i < priv->mb_count; i++)
 		priv->write(0, &regs->rximr[i]);
 
-	/* On Vybrid, disable memory error detection interrupts
-	 * and freeze mode.
+	/* On Vybrid, disable non-correctable errors interrupt and freeze
+	 * mode. It still can correct the correctable errors when HW supports ECC.
 	 * This also works around errata e5295 which generates
 	 * false positive memory errors and put the device in
 	 * freeze mode.
@@ -1212,19 +1212,32 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR) {
 		/* Follow the protocol as described in "Detection
 		 * and Correction of Memory Errors" to write to
-		 * MECR register
+		 * MECR register (step 1 - 5)
+		 * 1. By default, CTRL2[ECRWRE] = 0, MECR[ECRWRDIS] = 1
+		 * 2. set CTRL2[ECRWRE]
 		 */
 		reg_ctrl2 = priv->read(&regs->ctrl2);
 		reg_ctrl2 |= FLEXCAN_CTRL2_ECRWRE;
 		priv->write(reg_ctrl2, &regs->ctrl2);
 
+		/* 3. clear MECR[ECRWRDIS] */
 		reg_mecr = priv->read(&regs->mecr);
 		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
 		priv->write(reg_mecr, &regs->mecr);
-		reg_mecr |= FLEXCAN_MECR_ECCDIS;
+
+		/* 4. all writes to MECR must keep MECR[ECRWRDIS] cleared */
 		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		priv->write(reg_mecr, &regs->mecr);
+
+		/* 5. after configuration done, lock MECR by either setting
+		 * MECR[ECRWRDIS] or clearing CTRL2[ECRWRE]
+		 */
+		reg_mecr |= FLEXCAN_MECR_ECRWRDIS;
+		priv->write(reg_mecr, &regs->mecr);
+		reg_ctrl2 &= ~FLEXCAN_CTRL2_ECRWRE;
+		priv->write(reg_ctrl2, &regs->ctrl2);
+
 	}
 
 	err = flexcan_transceiver_enable(priv);
-- 
2.17.1

