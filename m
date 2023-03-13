Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955DC6B7A95
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjCMOlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjCMOlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:41:13 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2084.outbound.protection.outlook.com [40.107.6.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A8935253;
        Mon, 13 Mar 2023 07:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGmSn7SJTG5iy228laHfnY9JeW0oHzuF3xLIx56BrLKhJrA6CIOdPMucCE6GugCOxN+rgaLlafZZaXEftA6AVR8gl15AC0ragq+bfQ2HTE1Mk3GBVFlpJcZpafr4Ugqex/oWijFVy0exkB6nfQRcdo+IdKrRdEilCsPCb3zer/ESc4w0esuN6aAbNE16poixmlTjT3UNIvAkba3caAfy/GBLWRvEnP1dP9VD7tcnjScLiIivKwyjoMELe0PNEQZV1dv3to4rH+b9lwccnVZ+jB0DCAvhLqg3wLybjvO/8xJy3wt4hwcy/1qMZCsqNUmxKm2JX2OcWNxb5POrzLUs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lfnd9GeZPdlVaEKMuJLdvJcm8ylC5I9TGjLWQqtXRM0=;
 b=kvIU2Xh9wvt4OfF4xgvmsvZ3ENRvRdmDt9mYkHcodFy4LMl9/5AvNTKW+3R1/a4hUEYUY4lFzgS+bbtsQiXkrLLCo8Ugd0fvdaYcNIYcYWKuuvcncK/vxFdmKZ0h45TuSxrfeM6wrSrQEuUwdOOrliECgkoyvp5SBq+/VXbNRhEsrhyK5P1TgYy27PKomfLSbDEKx9h5iD8hTNBTvhyqcQThglgSU9Whzy7OcRq28kSxYagRQsBWnDknZE08x8w8YMJ023THq/QkBrsY0gy3QygCKo40v1nZ80hfAabH8AJxq08VH6ewM7q4OZGKugY3OHwn8lE7Cs4L/Mk2OFbQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lfnd9GeZPdlVaEKMuJLdvJcm8ylC5I9TGjLWQqtXRM0=;
 b=PUp+26yb/k39d7KxrMSgmX094LYYw8mi9P22KswBXBW6v1jI0D14V+xAVJiCTU8gJZ2Mp97bR8X2K4BlnXQuEB25bvkaAjsC7LUMh9NgaFB6kYW6lT+Y+90/hT3aH91amp7FfiopYkAFmusmI8wMmQNdeJLxjX3JMLfP/guxYQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PA4PR04MB7744.eurprd04.prod.outlook.com (2603:10a6:102:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:41:09 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:41:09 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v10 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Mon, 13 Mar 2023 20:10:26 +0530
Message-Id: <20230313144028.3156825-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|PA4PR04MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 36b358c5-ab51-4d50-34bc-08db23d0fbca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1EdzB5JvRk+KXzg/A/GVSbxE93ew64BgK9j6YpK4u63grzHjv/SpaVc/GS6Y4w1ZLHOngEQzKAf7BOs86Kq9TepwNoDX9YpU+EhNRb58nahFuVPfgCEplQFJi9ZBf1UHLbX/8fADLOLb45y8zCDVOGV1f5vsjGqVuHUwnksDusdMRRf5W/Zzxm1fdFL6yaC402sE1Safau96n0gT+1J7x5lXeef2GwFXV9o/rSI2kEXI3/QwNPJQATxKTr2rGFDaFdtrAI920dqBm1Pcp29D/aPAinlBTVVq9ExC68c/FEO7ibv1GJSEZdDGbxPktOhBvtWbWrhRDCMgHecJroake55JzcYvs46jhGVm55jaGwZqzyd/XT93ZwYfbrY1KIi569zYWM6OP+BLoT78XfXgYarTgzuQZ0Wo34KwyEwYwdPxogSgLyDO7BqwJ8KksfElROoUyKgE9LXQmsSthX9PsfpcCMisUICr+M9iaj/XLgskkTcbPyBn6vGYv/G8OnrgczpcBDdxc+jfr3Nc2Ap/R4FRUCE1yPXgk5gkA1wfQJbyC6jO2RkVNP/dlOQRRmvcZ0nhYVo6E3aK650ZsOXaXhnWDL1x/iQeI0Mz93cjqUvlV2EqxFi6C6JXAqYdOBXlT5PxvWH7gB5eP+MjkO8+H+psJ1QPwtDDs0cAWsaQXV9PyGb3t0gF2tPKaPOgLHpRaP4mTVV7ZhtJz2lsa7mBsj+MWj7YeyJ5jyDf6OEZnSs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199018)(36756003)(86362001)(186003)(41300700001)(26005)(6506007)(1076003)(6512007)(7416002)(5660300002)(4326008)(2616005)(8936002)(316002)(52116002)(478600001)(8676002)(66476007)(6666004)(66556008)(66946007)(6486002)(38350700002)(38100700002)(921005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3kdQs/whS67AO95y4k4P1eDCBN8046vd2IeMb9FsiOwlKf0NRk22TCSE3QJA?=
 =?us-ascii?Q?lY1vgdF/rC3CKKxz1qNc5asc5h1L34YKOAlYh8Z5zCJDW6l7Lzx999POpe46?=
 =?us-ascii?Q?E07HBPSIDQlxL720TljK5SlmXzgrfhqOBBa0BgurMM3zFSvm0BCwB0f9vcZk?=
 =?us-ascii?Q?6koOweYcBO757C42jJ82R8lNCT44UQ+03kKgLJAwT18uvcl33PHsvnz3UW0T?=
 =?us-ascii?Q?gmGZTPklFstI4ggiyvbjbeJ4PusCQuc1KJ2AzxK8RE8eT7Q8AXZCEiGRO8tq?=
 =?us-ascii?Q?lj1ffsety9ttAPlqmm/cjdC/T65Vah00OyEs1YuIpT4we61/C2i/sRM/49Ub?=
 =?us-ascii?Q?NVcGkUuDLA2HjSeTZoOmKz4YZ63vRk1tpEoBBgNO0u4NReUmMXksA1H8AGQn?=
 =?us-ascii?Q?z5taPf0CgX5xSZPPXHjBX/hi4Ghy8qFAXIAdsMUMCf00ZzeelI5IaYhzFs/8?=
 =?us-ascii?Q?mdQbUpvfl3QN6Yf1qTNp3jv7v5Y0S2XXdaIs1678u23MjfNECcEwEF3vphod?=
 =?us-ascii?Q?RrS7Uq8ACfgg8CbONM6MbS2sj+fdhcPz0+6DGxh282XbWHgUfjgu1O5pBu1M?=
 =?us-ascii?Q?23zXYNKExqiauIUAg5OU1kehWXBAfrcD2C4Q0X0yBNId6uYGHytDsIEOooEf?=
 =?us-ascii?Q?RhKsl79fdsa3yr0FHKKrPEK+xFjMeNgZN0qrtTW6O/WeREAdI636El215MtZ?=
 =?us-ascii?Q?iqtLn1K5AFmlSjQdwjlsCJlVimxHYLxgpUQgztqFdPOavaWA+dy0meSWwtOF?=
 =?us-ascii?Q?Y75nkhx0YB5EfqZDk3eMV8pDMeguwvTqX5TYY7adne9eh5OBfDbvnvU3uP2w?=
 =?us-ascii?Q?sm3Tdh+Z748Nh2Y6GW9sw0afSt/F2fEv2n5KEDRiHmIlSVwcaBbt/PuF7cws?=
 =?us-ascii?Q?DJpxg7T2uR6XOINxo1+7MdDM478362ss3Wyma8Gxb4F/JY8HAL12I3RNkOFi?=
 =?us-ascii?Q?e0fo8QoPM8arh9J90ZIsy6WtF9nlL1cE8jRoOluiAbwKr+M/S615StUPEyO/?=
 =?us-ascii?Q?81ZSf6kcFMUqD7HozWXGUMuA9RmtUFaoljtE8itRAG7p4qBoEVb/950HoHL4?=
 =?us-ascii?Q?UQCBEKmkOe0ne8im2y2oj9bFhIr0icpRkjLz0kaTgcWW68GABZpqAO9sKtRY?=
 =?us-ascii?Q?6JN5WMiB0aKRv3q7Le+b6A2HCDTEOHqI6+bUy7kHRuoLRgUskMYpbptl3XyS?=
 =?us-ascii?Q?YLAHtzav/aVqDKJf77QiSo23XQLN3Y+618GmwJrwiODJzALMMOMakP1RQ52T?=
 =?us-ascii?Q?cmCuxp2hZWcDB/QrHBvJY52ur+sYu2PQ30FfyqB+Yztbe5fbzDC1VriIKljk?=
 =?us-ascii?Q?2cET0RcFRljnvx3jq9dnn1xHPbn5UyWWFGO0OIoiEX7UT6j56r+76492ybAj?=
 =?us-ascii?Q?zML7FW7wq6cCvWXoh8HOJNwl/lSShkNHrfzmZ/CraElFwecv9zvIFhGQ/rep?=
 =?us-ascii?Q?S8Lca4jxtu0AXdJ50HftsAAY0Xkddccjbib+o+fbKjCbbuiB7QkZdCBs60qP?=
 =?us-ascii?Q?hzvdDcoHtqqIkBVMKsDX1J0NxU/2FhCl8wtfZyMuXh2W5NFeeWX0MkAVn5GE?=
 =?us-ascii?Q?cirMWIBxiJhs89wjKKkpJhV3F+5Y76v0uX5uzdep6SBfj4vmQuln6s9OBwf1?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b358c5-ab51-4d50-34bc-08db23d0fbca
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:41:09.0215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQbPwZjv8qm2fARwyq4DO3G3Csfc6x/h76dlOsaIQUJBeC83jiDtCI4HbHJggrHPhVTWiT5A79lovpMGkqsQR9UhKDiZXYl+252ZZ6kvIQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7744
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
This function simply calls the break_ctl in tty layer, which can
assert a break signal over UART-TX line, if the tty and the
underlying platform and UART peripheral supports this operation.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v3: Add details to the commit message. Replace ENOTSUPP with
EOPNOTSUPP. (Greg KH, Leon Romanovsky)
v9: Replace all instances of ENOTSUPP with EOPNOTSUPP.
(Simon Horman)
---
 drivers/tty/serdev/core.c           | 17 ++++++++++++++---
 drivers/tty/serdev/serdev-ttyport.c | 16 ++++++++++++++--
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index 0180e1e4e75d..dc540e74c64d 100644
--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -366,7 +366,7 @@ int serdev_device_set_parity(struct serdev_device *serdev,
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_parity)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_parity(ctrl, parity);
 }
@@ -388,7 +388,7 @@ int serdev_device_get_tiocm(struct serdev_device *serdev)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->get_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->get_tiocm(ctrl);
 }
@@ -399,12 +399,23 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
 	struct serdev_controller *ctrl = serdev->ctrl;
 
 	if (!ctrl || !ctrl->ops->set_tiocm)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return ctrl->ops->set_tiocm(ctrl, set, clear);
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
index d367803e2044..8033ef19669c 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -231,7 +231,7 @@ static int ttyport_get_tiocm(struct serdev_controller *ctrl)
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmget)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tty->ops->tiocmget(tty);
 }
@@ -242,11 +242,22 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	struct tty_struct *tty = serport->tty;
 
 	if (!tty->ops->tiocmset)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
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

