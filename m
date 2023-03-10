Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184636B4FF2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbjCJSUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCJSUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:20:11 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2075.outbound.protection.outlook.com [40.107.241.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B9510284F;
        Fri, 10 Mar 2023 10:20:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+mrvo22InCqcnjThS568Y9yeNfcsQQjuwMZoUtAiyhMYx4vuDlH2iuPamyS3mNGi4owvqBkzKPr14LXCm9rxBegGEI3/m3XkOfnYw6YS303b94s42qoTu0v5g1SM8wRuqYalhdywHSaCXeckXiABPUaDy068k9Q7aRReHqidk0D/7gOYe8svTia0SvmJH5U6cpdH8fdJ+yybtsQeyWaAgHxExtPzlRFTZYBAknsLKE7LDZbcTi5xq/UUjin0B9x+pqZXFLBQcueEhHInCko0IOyYKtbyHuzaVO3nRMEiPuH/HlkqUMpaGy8n/xPy2GjTRyyaUYnzwj30+oKNU/0Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y8vUV52mlQbn5GtqgDoRGrOJqgeNqnjP4c40QHQo9Wg=;
 b=LUFvf7rDGf2FSA4xH5sOUrP9ST1qYOzOkP1WOL2lA6qPFbYYrl0sx4U9CobSg57pwfLwJX4yo2MuD2SXI7uI9dxVNnIdaYprsPgO5xFTqiIY4OM41cuNPswnoSVr5k4ErPQeZADQ2tZn6MFWXOFYGBrSRj0ixPeezoGL3L8oycU4NII0TUR1TXL9iC0MDOa2mLhW8LvPG+sU6t5HvYRc3A50mVhGcJ25OJpLHvyYGUNPL7nYB1YiCPOd9L2wKEn8qTWrN09X4FW8Y0EXhnUG1OLTdOePWolaElaYjA/+fSZ+YGpOPM1X2SBmZF6yvWs213qIPpkRnyuSKLVkHG9u5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8vUV52mlQbn5GtqgDoRGrOJqgeNqnjP4c40QHQo9Wg=;
 b=ekTH32RI62JHi+fE/4XmNB8fhN+oDz+vrvgpFibrbFjzVdedmiODNZ/63Pz8VlVruQZbYFogG+vZ5kr2ko9gfDMMYqZDEspxip+gjHSdpOZqELaPBj4TlYZqDvakUlug8c470Eiv6G2oOHROrPe8JzDOT/oipkYgIvR28XPGOIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB9PR04MB9704.eurprd04.prod.outlook.com (2603:10a6:10:303::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Fri, 10 Mar
 2023 18:20:07 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 18:20:07 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v8 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Fri, 10 Mar 2023 23:49:19 +0530
Message-Id: <20230310181921.1437890-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB9PR04MB9704:EE_
X-MS-Office365-Filtering-Correlation-Id: 302b7648-666f-4580-e05e-08db21941389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3I6IzM5ASbdSjFoq/dvYlxJvzn1abCYmyatrw+/lw2u1iYHIcBdOpBSl8Nfn6vIUEJdzwPH/u7LJHvuxBlYRslkyTQNP/VU18fRMt4KHAPrfNJDTiCdVopi/LBvjyHx0SUzmgOp8w3N+MpXJpiOi/u+7c9mhQBtuOv/TNK4QCErtFAd6Bl6BGTW6DCb5p6TDg7Lq3y0tz/UlvU3W+uZ9bY0Rd3y+P0ZK8Q2DWJlakOAdT+t8NDAOMA5aMwfWX6/RQVI2M5EsqGaFA8fzDobyY+GZv6iGGQgrCiTGcAnmBNiyP/EouiLVSRHRo2mkDtAR5sBN5Ze3dWYDuhdZZwVsh1jGesMRx4aTmu+/356+HDKI6mRds6BEY0g1bJEs/BxoT2CoPB5eS4YWpd6sygC9kD0MtRiF4tK9H4PTnbhiN/VRuEn6l5U8FwCR3ddN/JT3ZQMerc1iTzhT3/KPHNNnex8dx2WBN05OHhBy6Sxv69TvcYSGIAwm3b6rZ5qtOgqiCYSnVn/whTkbp7xPiyqb/IYK34VRKOQSyNpoiji9og+uq10miByHR8GjGTYwE7/hLo3guob+uRqr1xnHjAQCK9AF13i4DimdEAM7AofxtB10BXQ6T+C9Z7MS008rzc6aoZyMY2EbOXpp9RBGKqyrzQVldrrmNMVCjFajTv1IpdrhheHmG155tJIoEFJLDUN1TmaqXXTJnlUeBWVzFKgXfhVdP6VWz9EOGGtK8YLK744=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199018)(66946007)(66476007)(66556008)(1076003)(6512007)(6506007)(316002)(38100700002)(26005)(8676002)(36756003)(7416002)(478600001)(6666004)(8936002)(2906002)(5660300002)(6486002)(921005)(52116002)(86362001)(83380400001)(4326008)(2616005)(38350700002)(41300700001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vTFeAV2uz3Qsp67YdsG8bPDHZpATSEGt93YheGDThYLCgpsyZ4PWI1Rp2iSB?=
 =?us-ascii?Q?1vArrgGo1J0BqJTtJAV/d4qO0YhZnJOeKFIWfGbUipGRQgTpgzFjO5q+EhCK?=
 =?us-ascii?Q?8915CZyBOn+JP5+w6gBvRh8EwdhBxwbZqHR0H57s8gNiwwFfGmKJPKcIClEN?=
 =?us-ascii?Q?CxpgC5Em7oFWqWT4lr+/UqkRr0sfW9cIGis0OFU1xO+RoI734MFc6mM8LYWy?=
 =?us-ascii?Q?9ar3AkV03elltHri7eBqaq/5yGs+LM3rdKZzJvV2zi0guWqdT5FnggS2r9Te?=
 =?us-ascii?Q?uStzk1zAeYCtko8uUWhDmeJqIsfphUuFVNDWy0na59zYjCrSC4DETIXLGdQJ?=
 =?us-ascii?Q?YBcSWkletrKgkeww6qwWXcbqd89U0hbfl2hKVMf+Flrvz/oYKW9TMUe9yUyn?=
 =?us-ascii?Q?P+H6wrNQYqCOZFsBnlIvGrqefO2i94oKgG9pQ1FIUqhf4MEqiJbVTTwEyXh+?=
 =?us-ascii?Q?gXKOXuUQXeKEhD8csyRyWIeg16T2U86jn/0wBzjiFzfSoQ/y3zcQTkeR9PKH?=
 =?us-ascii?Q?oPmk3GkFeGp5u14Xh6NfTXiIEnMJZ9vmV5XJqV8HJipLBSLKAYlX7I3hz9FX?=
 =?us-ascii?Q?aCb6TArbZ8A2eqASRuPpZOzgCjFFHhJAWxpjecB9tj1Tj1NvUfROue9ZUTH0?=
 =?us-ascii?Q?+dmOhP3sjWt/hZg4SwNE1LIcHgKuL1uDlo234LtoxzWAMpgGp6xOhFbVeYjl?=
 =?us-ascii?Q?+Gsz7VDTpeXlFPQAAtPU9dRLuFcbawxbu2BSdVAlI2uAeYqb0Fr+haWAkx9W?=
 =?us-ascii?Q?0VgRNXrsMp6ifP2a3SbEsrlb77MH0EJ0dSpEqmzSfjWtBTohOtXa3rqxvxGY?=
 =?us-ascii?Q?LhLnWUCuiRog8QYzTg9htIbbUWbpu8h8Ivv1ztRiTg8shyc72bXkJ9kJ2Yxh?=
 =?us-ascii?Q?WaOMLw86uEiYkyN/vac2pQTkUAjEu75JGhSiM4LMYHtbUHl55bXDtZirQN2s?=
 =?us-ascii?Q?XH1z3UpoEP1Na3OOJDmkb/w59GYJ4XbiikXDSACgV/aGAHq9+YfkyF8yE4Il?=
 =?us-ascii?Q?WJVBC0jFCFVIhY4nl+OiDimrrt82wC4Ocihv0m0SZiQwP8MAkKuHm7zfUj4B?=
 =?us-ascii?Q?9TiWMx9/KxkTMo5tu+2tikfgPxK0PYALJ7xrRVAXru4EhdUNihZLEDe+XRPT?=
 =?us-ascii?Q?zPpNuX2cgm9UZMoWN3K1/uqYJ9GTqPpoXqofLfaVCtaxibF/p7ZiQB3GpZnl?=
 =?us-ascii?Q?vAQFU1FMTz2IMWz8bkQQO6A7uhn4g+vlQC/OgObSrqaexPebCYWvcEWYuL0C?=
 =?us-ascii?Q?2RlSAmDz9DX7cf2H2wmFhPPtSR7K186WNFLEqLprAhbHMmJqPVXkXgu331Q9?=
 =?us-ascii?Q?o909bn4h1iE9oiwVOxMaaNzf+F2JZtg/bx0ACke5o3mzNIWARodHHtV+SAYz?=
 =?us-ascii?Q?7e2tmaP3RpxwGrAeZbGjvThjv/cVIL17kD/WJUZeC7Rgi9nppEu++9pI2tfz?=
 =?us-ascii?Q?2g4r3+UwC7hpPjICpZc4f9f/rm4nKkCTGlA1+amRDmMSaXltOamKzPE9VdTP?=
 =?us-ascii?Q?KXzpQDO77VRKRPIhvlNOEg55Dxe/M17/2xdjO1+MLumL1b81NZWMNXAUghrF?=
 =?us-ascii?Q?WBZ2y83HaJbWS3XYmKUHJ6qiBjfNP+HZcd3Q5no+V1ItkCxHVaggfRkUpofb?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 302b7648-666f-4580-e05e-08db21941389
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 18:20:07.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Igxur1sDovRVuozIQN6cirOtOOQsLfSXNOxlZSyDFRLAOeOD2edqHnkjsJtmNWw6D9pUMWPgmFRFiTi0af6U4A0AoQ5iYgmGZcO/6K4FAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9704
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds serdev_device_break_ctl() and an implementation for ttyport.
This function simply calls the break_ctl in tty layer, which can
assert a break signal over UART-TX line, if the tty and the
underlying platform and UART peripheral supports this operation.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v3: Add details to the commit message. (Greg KH)
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..f2fdd6264e5d 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -405,6 +405,17 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 }
 EXPORT_SYMBOL_GPL(serdev_device_set_tiocm);
 
+int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	struct serdev_controller *ctrl = serdev->ctrl;
+
+	if (!ctrl || !ctrl->ops->break_ctl)
+		return -EOPNOTSUPP;
+
+	return ctrl->ops->break_ctl(ctrl, break_state);
+}
+EXPORT_SYMBOL_GPL(serdev_device_break_ctl);
+
 static int serdev_drv_probe(struct device *dev)
 {
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d367803e2044..9888673744af 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -247,6 +247,17 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	return tty->ops->tiocmset(tty, set, clear);
 }
 
+static int ttyport_break_ctl(struct serdev_controller *ctrl, unsigned int break_state)
+{
+	struct serport *serport = serdev_controller_get_drvdata(ctrl);
+	struct tty_struct *tty = serport->tty;
+
+	if (!tty->ops->break_ctl)
+		return -EOPNOTSUPP;
+
+	return tty->ops->break_ctl(tty, break_state);
+}
+
 static const struct serdev_controller_ops ctrl_ops = {
 	.write_buf = ttyport_write_buf,
 	.write_flush = ttyport_write_flush,
@@ -259,6 +270,7 @@ static const struct serdev_controller_ops ctrl_ops = {
 	.wait_until_sent = ttyport_wait_until_sent,
 	.get_tiocm = ttyport_get_tiocm,
 	.set_tiocm = ttyport_set_tiocm,
+	.break_ctl = ttyport_break_ctl,
 };
 
 struct device *serdev_tty_port_register(struct tty_port *port,
diff --git a/include/linux/serdev.h b/include/linux/serdev.h
index 66f624fc618c..c065ef1c82f1 100644
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -92,6 +92,7 @@ struct serdev_controller_ops {
 	void (*wait_until_sent)(struct serdev_controller *, long);
 	int (*get_tiocm)(struct serdev_controller *);
 	int (*set_tiocm)(struct serdev_controller *, unsigned int, unsigned int);
+	int (*break_ctl)(struct serdev_controller *ctrl, unsigned int break_state);
 };
 
 /**
@@ -202,6 +203,7 @@ int serdev_device_write_buf(struct serdev_device *, const unsigned char *, size_
 void serdev_device_wait_until_sent(struct serdev_device *, long);
 int serdev_device_get_tiocm(struct serdev_device *);
 int serdev_device_set_tiocm(struct serdev_device *, int, int);
+int serdev_device_break_ctl(struct serdev_device *serdev, int break_state);
 void serdev_device_write_wakeup(struct serdev_device *);
 int serdev_device_write(struct serdev_device *, const unsigned char *, size_t, long);
 void serdev_device_write_flush(struct serdev_device *);
@@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
 {
 	return -ENOTSUPP;
 }
+static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	return -EOPNOTSUPP;
+}
 static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
 				      size_t count, unsigned long timeout)
 {
-- 
2.34.1

