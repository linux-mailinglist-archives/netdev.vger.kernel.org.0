Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78615681845
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbjA3SGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjA3SGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:06:30 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2045.outbound.protection.outlook.com [40.107.7.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57273B67F;
        Mon, 30 Jan 2023 10:06:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NscesATc6vyIEvoUutmeWhWZz7IFxv1NvHUNVkXbZ7t4H+rsrIOrJerVORWeVo11yvsk7HNBjAmLA4h1LsbWFGT+PNaSgb3DCGvSTbDI5VrX7nJuoS8O039ZeUV0ab68LhHNyQO0T8AODRZe4JXYhrvl7v2Bq3a9kag0cM6GpvJoRhuZh+KllsjmqE6GvCGjpM6q1I331NcN0Zvv7X4mZ5KXHAc6/m5PYyOuDBk4C5Xy/fy+RghkmfBdItYwgS10CwcByt5H7OKWuKFKrWZthBToI34i09mLVg5hOaQyGeUkru29uPB8mNJUhjecBSe3XguoL887UXWI/BgE78avlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5nbcOgcVSHPFCPJqOWAGZJRAJK2XDDhd63lyUiHUYo=;
 b=hAps4KwLcfWfqTllEaLGYNNUVk9rah9NDQb83QKW+RLBVGDh+qqA+v1IR5li6apsL7I38MK7FrCD91W/x+ADYI7uad2z15ecXlzdajHDojLfzJq2kwydHjXcmWIPMtLuxplz17li4dhM1wlD4HEK56Gakf/YZFfAA863yLW6TGjU3Pmj3u2h440QkIPo0fEuf+PrWskpxmyrXyh2nH1j867keRfhtSQFBYMQjeSbzjpsJ8Ygc2CH8kfKrdiwtQonpG4zHDTSEqH3uEjn5+ajgSxISQePBjFaKTz8wzXgfchhpUyT4WJS8oIWOG5nPcyuJJQIYPECYNapmsHg+d92oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5nbcOgcVSHPFCPJqOWAGZJRAJK2XDDhd63lyUiHUYo=;
 b=RtXnHnBam2onWF9z4FZGw0cWVWqnULAVUfB+wjL7ct2hqDLAJQyUMO06m54EYU+Yw8Sxr/GWqketyTZoBn984gdmtxpfEl7/QV9S+ANWyX90B1VrBa60Zh3oUdav5Ik1Urk4NatQW5Q/Go/RZ+1oqFIRcXvvDux0vKYXDasfhC8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Mon, 30 Jan
 2023 18:06:26 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%6]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 18:06:26 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v2 1/3] serdev: Add method to assert break
Date:   Mon, 30 Jan 2023 23:35:02 +0530
Message-Id: <20230130180504.2029440-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: da1bf7a7-b97c-4347-a6bf-08db02ecb43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mpsDxg/vhwIi/mOIaGZhgP+HxVzcR0SqbvmaYLmgooic6J5ORO5VbdSJlQ7iBrBXfBjJhaMzDGP5g97wJAB/mRFUx3Hgq0m249qK48EEGV7IQdNqmYkRAekzDI8TGK2zqvPW6wYSUQWSUqmmFeqj3hyOBuTMamA+LE8e4LylLa+/9bngE5Vt2UmK+A75f0cH9Q9tcFYgJz49pJ1gnnHXanLMF5YTNQsyMkxOdR9X8WUKYzDOJk64oEoq4JGtIqmEuuEOubZc3Gs/gtkukuHTi7LCAKTwtf0l9AzVgdPX4tgjipi5bJvykAOQrQhTfada68pzb4jm9wMjNl4wVoajfaukeuYJpbPcIiddQZIJjJPSLNEnBv3O1EDYBnDYDg4I0UPf69UqhWtiOEzXwURFCQEHVkd1N7p5+3gwMxFi2SSu53SSja82r4aVWgF7mSY6fDG3xWZJwcojRHRLp5+s+IfAwDNgcUMGMV+ad3tanO6KjYox9D+6TDKSOabbZPAzINX+9+KzlbpLRw7OhTfgKlNxZ7igeMzz5iqHygMQbdfQTwsF/2RktDiX6VMAKtIm8itQyWRO3mIBiknUqiBpazdj73vM4tbqr0HyZbqWmifQrmRp07I69eyejUzi7v03ulTMKsyqyO9rOJ2czQReQnELw5liBiV/OYK47ybz+A+EmRCNKsKxHq+SvO1HWhgQSlVffaPk91cDWZNamoH2yFKTiNfO6B4sUSxCJ6E6lyQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199018)(186003)(6512007)(86362001)(26005)(6506007)(1076003)(921005)(38350700002)(38100700002)(2616005)(36756003)(316002)(6486002)(6666004)(8936002)(52116002)(41300700001)(478600001)(7416002)(5660300002)(2906002)(66556008)(8676002)(4326008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I4eQi2SspQg3XegoSDSko1T6errM+BxJ8aRAleLR8VfxUoHw7HXY8iWkFQ3K?=
 =?us-ascii?Q?LizAhcvJwT+MCUzuBr6uPMGON7FJ/koSKoeBOjU2l/XvehRookGcMStSTmry?=
 =?us-ascii?Q?vu2hKNymeVxO4y6g1obdZT+HW36eMKDo4SOZ/5NWRuJ0ic5PEikv+YoctdcT?=
 =?us-ascii?Q?P2/ogc8YtgRavUIIgVZUkXKX4m7bWrC4ntE5s6OZtB0cckuPiWT7bVMz9p95?=
 =?us-ascii?Q?bRzbcqeo3f6/Vy5MxhqqvSOJqyzG+KAgWU010cjPJnQBbMmxsJTKh/rcx46f?=
 =?us-ascii?Q?Cs6ud0SjHqVNlNy2X5REVViSVgWe9NVC21wJLshq6oyex47y2Jk02v/dbbsZ?=
 =?us-ascii?Q?1c0tf70EYlla5ICcxxavMzZTyV6jimUY0rP7pcFMNU9CWJUUw1WVwlNDdLno?=
 =?us-ascii?Q?Fib6qJfhSZ6fwe6LkhRID9IpND0C62cu4mToFddVWaGRPXW3a51qEU3LC2Gm?=
 =?us-ascii?Q?wAWncJp2MuVyQjVH9Df0uOtZId/UrP3hWsCEHuHsgWSDjEw6IXdMUNW8Pp3i?=
 =?us-ascii?Q?ZYdo0TZnN6fVDBZJ67fkInhDcAGPQomw934HR8k+ueFO52ANeBvE8rL/6Zu7?=
 =?us-ascii?Q?NrOt8x/OGMUJAQ/2ZuTisFwotpt12RHBFhZDXTxQ800qQlg0VXdyOIKyoC2g?=
 =?us-ascii?Q?beTUy8+HZAAog9CAzszsudUPL5/SBRIhHfXVOvU5nQOTIbCLrRx1u87xnKRU?=
 =?us-ascii?Q?q+2M8h4PLzD+90ghbFLaDhOBDHCImbeOlkk8A2srYS4qtzc2jLCyt/JPoBnw?=
 =?us-ascii?Q?4Xh3w2WkuHRYQoGUwIb30gsyFCv53ZoUCyNcW+HBTfXKTfzXtxbsmhbtOTzT?=
 =?us-ascii?Q?68sqo5ObPf22SoROWo7t6J19Pc0JkIvIR5rVyufk7+U3NA7liXJWX7xFP2zw?=
 =?us-ascii?Q?9aN1s+a7EIoTENe1+cYr+6UPS1ohtXWmycliRXS/OVLwPkSv60whpBMqplog?=
 =?us-ascii?Q?ZSmpiDvN2hqZYK/RU+7dtpfAC08VJ3X2bfQj7cu50JuXWEtUScsnYxwrdOdB?=
 =?us-ascii?Q?I8w0otWndXdyN0AdJhKnx71dSGH74AOom+dGnO1LgJR5bpDGz0dICDZzMxuf?=
 =?us-ascii?Q?wZ+UU0ZpRrrWxfGI9cHJmAjRuN2/cP+Som/YuQAjA9xZ60M9WGEmY4a0Bmc0?=
 =?us-ascii?Q?5Zxc5wKpxE41PBX3GVubLZjoUkgaaD2HzM5ONaWuGzzho5Jtfo17Cw/zqcDZ?=
 =?us-ascii?Q?O6fGjmnNNeFiGhBieqRSDd2FU0OUn13TUEJPOFyWh8kqNZAvtGL2riIB7aUo?=
 =?us-ascii?Q?aI5SzXkWTJmSVO1SKxrSO65DMSrTt3DV7y1t3eZmBuz8VcAUmjPUNCiGdktg?=
 =?us-ascii?Q?PIQi4qnWauvd3IXFjfdsVRmFfYh92uaoGSupvJMQ81xUXIPSbYRMKtBhssFM?=
 =?us-ascii?Q?uGfcFA4A73mSDKaoeLTjOEMTYhRqFl5TybrcvK+doX02+ejQUPA5l9ZqcGle?=
 =?us-ascii?Q?375vckI4lzWgl7s63xGm1u7gFGutM4Ub7IBk2qmCWkxXeU8BBn/1iTuLMqo5?=
 =?us-ascii?Q?NfxNLKm0mUrtl+7wkFPwE3kKs4QZRmvJ5jYrWNAiqxxaDz+sc3o1R81NNTzm?=
 =?us-ascii?Q?UHW9XzV/Q6wXLkFASAs6PNo1eQC6PZghPvQ9XXeTQ5gexN2ffmezmVjmqy6l?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da1bf7a7-b97c-4347-a6bf-08db02ecb43b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 18:06:26.4589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVGKqg6+ld5L1jJ/Z4oyXHGHDGPICztzU06Jp/LmJKMkUdn8QlggPong5ldnbxTU7EfWeaNNmZHd2ZnK5VP4PpWVO2DN76BEBRHEH2wSEIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds serdev_device_break_ctl() and an implementation for ttyport.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..26321ad7e71d 100644
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
+		return -ENOTSUPP;
+
+	return ctrl->ops->break_ctl(ctrl, break_state);
+}
+EXPORT_SYMBOL_GPL(serdev_device_break_ctl);
+
 static int serdev_drv_probe(struct device *dev)
 {
 	const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d367803e2044..847b1f71ab73 100644
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
+		return -ENOTSUPP;
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
index 66f624fc618c..01b5b8f308cb 100644
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -92,6 +92,7 @@ struct serdev_controller_ops {
 	void (*wait_until_sent)(struct serdev_controller *, long);
 	int (*get_tiocm)(struct serdev_controller *);
 	int (*set_tiocm)(struct serdev_controller *, unsigned int, unsigned int);
+	int (*break_ctl)(struct serdev_controller *, unsigned int);
 };
 
 /**
@@ -202,6 +203,7 @@ int serdev_device_write_buf(struct serdev_device *, const unsigned char *, size_
 void serdev_device_wait_until_sent(struct serdev_device *, long);
 int serdev_device_get_tiocm(struct serdev_device *);
 int serdev_device_set_tiocm(struct serdev_device *, int, int);
+int serdev_device_break_ctl(struct serdev_device *, int);
 void serdev_device_write_wakeup(struct serdev_device *);
 int serdev_device_write(struct serdev_device *, const unsigned char *, size_t, long);
 void serdev_device_write_flush(struct serdev_device *);
@@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
 {
 	return -ENOTSUPP;
 }
+static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
+{
+	return -ENOTSUPP;
+}
 static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
 				      size_t count, unsigned long timeout)
 {
-- 
2.34.1

