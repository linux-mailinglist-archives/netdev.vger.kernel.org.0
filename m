Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE96A065E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbjBWKhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbjBWKhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:37:08 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C724FAAE;
        Thu, 23 Feb 2023 02:37:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mifoDEMsSgl/vmFQVhktuU3XssBwHiD5h04Tz0dz7gOKEFslDl0k1rbYiNi+xkCslmjauy92Cgh80ynTaNDlHLkEaw476dwuYEER3hVegig6iN81G7Ca9xy1rrfcQ99l9t/czhLHqPkXFuqiJ8VHt5+0LgFn7mNYCussXyjbFcHBrRgEY5GNnIu6hJP7GBNxlE/nKYQHbbymwxGXbmwu+yXOZB3ARfA6T0EmXsoe4tI6ebyfEkZoceMppV1ow9IlSpysP99/uSJmUkyTjOfPiI9K8PASWoDIA3Im+QCb3zBZN8K2aaiOo4C4sn8eGS/r8ysVy6p/3KC5pibLabiueA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaRJ0wVAel+SMHzl+EisXjhqD1nlPWpe8jatGPGtPBo=;
 b=Ahxgc/tkbKNBK8VOKKrTO0YteOdlYgOQ7vlXMbjdg6US8V0MZOuVYdelbqtw7WDPOToSteHzxoF14H0giAxkoKcHgw7tZq37qSF+FyLaz2FoaNzHYNKBYRL5REUVkf0kElbkyJKkq8Ec8+6mV8gs/EnvNkyvZGPMZuuMb8+eYtGoJoicW0FsLqKESBuQCMOTT+JRKVZ2O00WDjPV45YhwZ752mo15QGMPqP5/h9SNdQWV2XkYH3szmdgne/YjofkqxKVtujwPwT0NMLRJwkkRdV8yzUTIdBq5T42Lv6cxHeHxMVXVwnwret4aXt9bPDVxUqyVwe/XMTS4iPOGXodqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaRJ0wVAel+SMHzl+EisXjhqD1nlPWpe8jatGPGtPBo=;
 b=cD44upllK116NkF2MrG3zBEnDDAYDJxuxssR3E0+H4R7yY9iq9d42WQ0cYr7ffphc+wKcZfiFnvQJ+LUK/6SZ/KAh57uxFKrkXTalVQrbl8SsYFnqE070pCatQIPgynwmkvJBGZEDgDKLWbeTJjcbSSvXGh1EaDD7DI7mWDJA/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB8195.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 10:37:01 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 10:37:01 +0000
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
Subject: [PATCH v5 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Thu, 23 Feb 2023 16:06:12 +0530
Message-Id: <20230223103614.4137309-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0137.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::42) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM9PR04MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: 37316ca0-07a3-4ca0-3197-08db1589e537
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilx2G9qXnPk4WEtNRnlzONpaecT3uYR6YGrqVVSqNI6Z5dWOyXHgU2A2Ry2HkXriv4KbDD/osV6r16tGgC9upBoSvGearf51Gl1H24ie++vehWNG1gdqh6Z65OZyvuBTZFn3ca0uKzX4bixWIq//InAur3r5Qa3ljY/fgDOm6jRIg9QOQ5ZXe7wL3+aUZIUmC05MFDMHTL2SHSNasd8TgJ7Tc92uLEpKkaeWt7GNKt0gvCK9LwITCNCcrfo6H5wkqptryd8dtfeJJfGrk1QmlB5bX14y+8FevxhTQhp+V07Tpb7IEYbTs4AxJV+Oh2Tq34Yhud1IZfJ835emcaKLM42qF3/D8abZA2WlAM4WISYfwEsEv68haOSdYpqhYC3suI8wQEmuSng59aUPBP8VCTO9dewsLsMq9Yt9CDK1ptoz1zuDJU+NB3QDZaSyHgG+DP464ZmcUOH0uW8D61hB+OUUZYyEYnS31UAwFD76Vt7xasrS/U1fahbLztUAtjAwfr74qhsWXzdohzC1MCXeHBlCnxAQrzeye2xVtdm3ZCRyMyT9CMYW4Ip44sEZWjdl1W6h03fpASTFR6S6iy3znaSA72oTSCBKbDrOk73CbFNpvsRG4SgQI+YkbMSdrFwGbkjfjQeoz/pn5mJLqz12reR2BoifaYu9rcJm5dJRIt228urZFFkaiE/v449tLBT4ZGk5aOauuE6UTD0hobeMHqBskFEe/8KzliI5WWc2u3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199018)(66946007)(66556008)(66476007)(83380400001)(8676002)(8936002)(316002)(5660300002)(4326008)(41300700001)(1076003)(6506007)(2616005)(186003)(6512007)(6666004)(26005)(478600001)(6486002)(52116002)(921005)(36756003)(86362001)(2906002)(7416002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ps8ZgAOB+7QxngjJwq1dNM13SL9WqpLRuolKboXN78eumUY7ONSimqgVVyyF?=
 =?us-ascii?Q?cTF5G3sz/NkwfTpukDVVsa5Y/0af7gvPU2VOKsWVGvLiiry/mY53z/AxwMg/?=
 =?us-ascii?Q?hFKMRemspJDribW8fcsy1f+2xltbfltL+0CZuR7ioV2PJ2DjLDKFLDymaxDQ?=
 =?us-ascii?Q?8Ghk3DFKYYqwxbmB2tSDHuDNwL5Om29kH+qdg+0YD3hPUh75P5c4DQevDlyA?=
 =?us-ascii?Q?/aszowv+6Y7fkmBcnPpciqarJg952kbXTVkYWjSW2JnlUnjcEMUPN5Rpnf0E?=
 =?us-ascii?Q?b2S+FEgvHAD5laE3WEk4xOdTGzHLHLBan1UWNjYivFPQEJktDbcrbnuKh+kj?=
 =?us-ascii?Q?CEnOVKMUV9nUvP22hYESigO+LX/hHK2Qhv8QBk2N97ey+TkLfTgH5fCK4pLd?=
 =?us-ascii?Q?L48hLwSkndsrgdsmVNlawTsFR/AwrWp8dELSERRa0O3q1nsmkbiv/0TCMfux?=
 =?us-ascii?Q?cKKS4PJNATGAmMvPB/CJX00pPPQ5jQGTQlcjZ1ISsGLXMeVQk1QEaFqjqW4j?=
 =?us-ascii?Q?BNY3jBmdQWgO5uJ9DL4s/ze21z4vg80V+AZHljXQUBK6s3nzASE04o54P9rl?=
 =?us-ascii?Q?VlUy8J7VJ9V5vrMheprra8eQCbonO09xaCx31xK1d7oL4vK78ugzH1HANWSJ?=
 =?us-ascii?Q?rby0fUSaVUZ40wg4ArWUNgrglVOGLjouRUNF1/tZ5QbDcG1zXcN89KXfW9WH?=
 =?us-ascii?Q?b0yV6BcHL3sQ81GdDRQKLmS4FEDQa7YmYW38xabh7fKHngBhF2QYXCqUrBB7?=
 =?us-ascii?Q?rJTXeb7kjOQp4qPsQ5SiZe9Di9fdZcaJHW5yYVJX1jI/8iSYHCrHlGeGNs+w?=
 =?us-ascii?Q?cjoTK/S1q4j2MWyTp9I1wfRivx4+32SzhnQe6AJc3Gw8o2OqkWsxrnIKo5Jy?=
 =?us-ascii?Q?nQ9/jy9se9xdoON+r+xlG6D+QoBpDkdQm2q3LjpdI+OfpRr1gbicZ/vv84vy?=
 =?us-ascii?Q?4c3XKhKEVKJmI63hrGcCDHXsyJogAT9HKF/iTISrFHdD6HAPvvlhHVqKjt8L?=
 =?us-ascii?Q?hHDqX30CSw4lCzurIhDy5CyaTsCOWEczICY6j9g6WrsKssXbFMhQbJwmJsKH?=
 =?us-ascii?Q?pxyNYgqdrh5lENFPRFbkxpvcalSMRhjdPzJZRDPLJWGiaG+BQ1bDKR1sG++e?=
 =?us-ascii?Q?fwI33kJtfnt+mWfgt3c2EWO+ElDmkuoXsn8utrsqobo3vDLYkCpufjdF0n/0?=
 =?us-ascii?Q?440vSd1hxrTVFv7mBCGTE8KZvLUcVblEYJuHaIDSf5JwChYvoNyyjzo1ww8D?=
 =?us-ascii?Q?x5GGzK2Ypp4q2kZnfWuk1P5SeLuK2ql8UTgzRV6uFioXTStmy78zpkaf0DCJ?=
 =?us-ascii?Q?lvfq8MupF3LZjzGG4p5jXXXuu3S1iK0mK/XNarM9CBcU3F60e/1lnT1OfO3m?=
 =?us-ascii?Q?Yg6AJtGCQkSD7XRjFbYpwHDjs9xaylz6ZoqaBJB/CeDaLcE7nGJp8InIo2nT?=
 =?us-ascii?Q?8XtDC9O+gqsagYNJf7nfAePLIN070UGg9ydXe4JuGn9A4hiIDvvEqR3UMPpy?=
 =?us-ascii?Q?gxhdF3sXTcnL0avbXGUvDC+EBP8r1xzrjU35cJ/MggdH+sfjdieTXNbWiFnk?=
 =?us-ascii?Q?/d/YoPz7LZj4Luub39x40L18fqL7dG0kx0ss7FotP2dCZs04rhylQjpSKKfB?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37316ca0-07a3-4ca0-3197-08db1589e537
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 10:37:00.9609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0u2knA3d3bMLyQqlCCfqyhRFOgGkFbz7UJL448UTh0MoFAmm/Av1hkleJjohi/qrbCzLIKuFMu342pZWLAjUzYItIknNYia+naFnu4QhHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8195
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
v3: Add details to the commit message. (Greg KH)
v4: Add a check for SERPORT_ACTIVE flag before asserting break over
UART-TX.
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 17 +++++++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 34 insertions(+)

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
index d367803e2044..be6044fc0e6d 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -247,6 +247,22 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
 	return tty->ops->tiocmset(tty, set, clear);
 }
 
+static int ttyport_break_ctl(struct serdev_controller *ctrl, unsigned int break_state)
+{
+	struct serport *serport = serdev_controller_get_drvdata(ctrl);
+	struct tty_struct *tty = serport->tty;
+
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+		return -EOPNOTSUPP;
+
+	tty = serport->tty;
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
@@ -259,6 +275,7 @@ static const struct serdev_controller_ops ctrl_ops = {
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

