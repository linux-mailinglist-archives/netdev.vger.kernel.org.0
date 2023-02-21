Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1224369E48A
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbjBUQ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbjBUQ0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:26:48 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2069.outbound.protection.outlook.com [40.107.241.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCFB2CFC9;
        Tue, 21 Feb 2023 08:26:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCuBP7u7pecWZnZ2HVNCkZqO//f02j0bPZC0EOU5C7FWXjglnoHY901hvEgfaHT0Fdz1Vn0V5irrIp6G5wDNASG2vLOW1eRpDNoH3+SOwcHYPoDt+Tai2dTir3/9nYBiEFPxIuX5mQ+X2VtE0voZGdYPVg+2HN9pd1U3IT55Ak/YINL7ddMZMa8Exvx+tUkPJEbGJq7XV0ZeOpbZO6SzoOLEVoujg79UAYH7XgAVKWyIALqiq67MFE1TpXBSEuXLLjM8AHnwYzSxgTqE+o0/33Bzp+gzjQhxf0w+/6oYED1ymT21QjaZDqGn02Lq5E1GJYlpXZCebDpbJvQwC0X/iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaRJ0wVAel+SMHzl+EisXjhqD1nlPWpe8jatGPGtPBo=;
 b=EZ3NVwzfyJY2Omv81s6qV8bW2i90ooC397RtH8+/oWJiDED0FgKhZpp+gUO+NzTeoMRYGxro7rQwg7D7QHV/wTmEgo9BA69TuJz/np19uohIgsDaCteWKQD7kduz+TvY5LH9m4yRR6tfufWL6CwQI3AuF4q3YMVccTuASMzVZeELgGrf0ZAtvdxmYIouHndV5ENFEa5ov0AzAaioe7Tfebamc1HRgc4Sn/OmCCm3HTObMLnnmr9jjoXeK5FnRt3j7rD+B+ubGdcaUa70918PukKie2IlYFi0Pq4qth+knaT7BrHHyFXHdxfExCNp2d+/+/UfKzKLaYKq8W44uz2t4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaRJ0wVAel+SMHzl+EisXjhqD1nlPWpe8jatGPGtPBo=;
 b=ht++nbwmOE4s1G0GsF9WlIhHidTU2uqR2IiL828wXtBua0mZketkhnKPkPvzEOHjSAIP0VWevjt8F9g59taFrk8N279Ncu7VlL1Ykwp/gUh0+ar6ahWarxNniUYwZj0eowH8bkAgZZLLmGDevYgsoGhlMjYswSgeNdOPjsMWIbc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com (2603:10a6:10:2db::12)
 by AS1PR04MB9405.eurprd04.prod.outlook.com (2603:10a6:20b:4db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 16:26:36 +0000
Received: from DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe]) by DU2PR04MB8600.eurprd04.prod.outlook.com
 ([fe80::6aa0:508c:be53:7efe%6]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 16:26:36 +0000
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
Subject: [PATCH v4 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Tue, 21 Feb 2023 21:55:39 +0530
Message-Id: <20230221162541.3039992-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DU2PR04MB8600.eurprd04.prod.outlook.com
 (2603:10a6:10:2db::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8600:EE_|AS1PR04MB9405:EE_
X-MS-Office365-Filtering-Correlation-Id: 147792db-b555-431e-acb3-08db1428669c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8oe8M9nsSJQH1JaGDVCSEEd1auvPQCunxnI3/A7xhAFTJUXAYJ8+wSIJEYirsToLtSzz6P1E9DRJDeBPb0GbboSx/w//KMABY+I7txcj4EGWr8Hs6Q9ZwCC9xTSkjoP3kasVC2Vwt1v4zC0FA3ZLDUCc8b010lT1KwAQhnpCpF2Q7wB3vNZ71NJ5MWpFvhtZI6mQXoeN+AYq8plmISKdPCjuLzMAoZV/BgWVvR100w8/un42XFDzgGX4sYJHQbRZLGMim/vsGgrDtI+LrFoWSKX8A6HhzSkINxMwzoCWkA4mRH4l668cigqQGPMrE/6n8nofEOZh07azTvnYWGflhTfxCZh/LTECq43C2AZU3kuZ3AVUq1iCYme07Tn46IatUDhWohQ+YgJYc9A2QFYyFEgc79axcPP8dDHZWyG3CvkReog2pEfyj3HNWzdE04gVIpo1bJ7M3kCLEHUwHlEZYPUrWPbUMJX+5++d1HwyPBSPf1b0HA33jXhFzlRjZkHhT2ugamzt096NCoHMXPnK0TEK4WHGXLRWFHP7QuRKY5fH+ZAQcc0DXMDCOMRl2H/MtHAvWSyKKHrtskmsZLCyu0KqyAupGNAz1j7l01Yyxf8vaWrjt0TkIqvbVGxeHCsorxOs7aOoQei+ngLJNkGFKq9/xM3yiBD4MqWFbjZgHSxw7V9R04z0tfzHy6vAj4GgfeVtPYRAK5VbZBMlYSZI+QCtlE0ZiwOz5ieBfKwvIVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199018)(38350700002)(83380400001)(921005)(86362001)(36756003)(38100700002)(2906002)(8936002)(41300700001)(5660300002)(7416002)(6512007)(186003)(26005)(6506007)(1076003)(2616005)(4326008)(316002)(8676002)(66556008)(6486002)(66476007)(52116002)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YBUxmVztdCSFxQZTXnTWav5nlwF4nmi9oDYtgJ7ZAJEysSd7ZFG5ZTkQwUqL?=
 =?us-ascii?Q?Ve96qq8+VFGYqNogGvJqeTqjP7H6lRDrj1cTpK4QWjrVamZn8+7kuxF517Mf?=
 =?us-ascii?Q?3338wu65uFmlJ0N2rx1T/ddtIK4SLhE6+vlWLQYiC/DaD71TPQVcYvKDDHTq?=
 =?us-ascii?Q?wSXEyYYVQBBviiZzNHcD3M2dCNzLJbxmRTCrDigeadNBOUFY36do7M70pnYr?=
 =?us-ascii?Q?I2PR45j7LIzY3avuQly8KP6aFbCKT6CnYCaCRnmdkKHUFCaDa1aoTJ9jhVdp?=
 =?us-ascii?Q?ruSjHH7LCxxnyvR1jPi6a2R4SQe5k7XTU7QVR4f0y+UMRcPM462ETlMT7MBh?=
 =?us-ascii?Q?0pPKy9mv84EFzWsCME7WkLDL1+oQkhWab3QC/S+liJo9q+mZi0Wdf6oTyXgE?=
 =?us-ascii?Q?SEFW5LEryZUzDFJMyKK1fux0pZL7AwmkytO8bWoh44TNKiL0MpRJmrpE6Xd3?=
 =?us-ascii?Q?h++1GcUyjQ08U/p8Wg0U/2Sx/hiC3aPE+3tobxUpqrsEkHX/N4h44hxHHMxz?=
 =?us-ascii?Q?fTAnHjuiJe2IHjMAhYtU52HIbsjGBRhc7Kmd/gIKC9SWV0C+rT4bmMM8R4C0?=
 =?us-ascii?Q?pOF9iZk3yLuXlq8t20ILlih40/V8Sutmy9f+bPHRoz0rk5+vs6FByJjCtAgA?=
 =?us-ascii?Q?tyMA+sRRaGKIsOoqN09RYApzAgLmnmy53EacPBDR9C8jP0Aqg3mKT897Trdh?=
 =?us-ascii?Q?YEN3lkvVmlr7pWcmTdsjQqiY20LmcL6e9vDTUFn+ZjAIeZuTEtWR6Z8l40x/?=
 =?us-ascii?Q?LUctmtWF79tR7lLYmVfgQPHILgRjN0le1t5Hj6o134W+ll17ssgUTEY+pTsx?=
 =?us-ascii?Q?K/CR21znpunI0TXAcjk99VXr+XQdXoKqp3CHgFeU5JwYP7XnyAT0uh63cAN3?=
 =?us-ascii?Q?w6MdciEIL4xoPmSEbpadgJ+yhvanhLoONX6F4mo1NGdbLlFCppp7mqy2mhAW?=
 =?us-ascii?Q?cjRw5vmp9FubuXAlBma6b7GparSdimAYe7t9LuNUzZMtHqkkcYu7oK+4iVz2?=
 =?us-ascii?Q?p1/aeJ8ihYmJTrr3+c10sbkaWWTKK0zoSaJmO2CkUIyR1Ic1PsAn5KE81epe?=
 =?us-ascii?Q?H1lCvcomFBlDfx5/JNaJdIwyztQ8T2H4bbcBggGcU6lmqaUAcfn0uAbm6Y/a?=
 =?us-ascii?Q?c/G+usfXrJigcQvMkIYKnGVlNHZ4XoHzJXBfn1TEyDVD0GgIt9OgBwt8hoxd?=
 =?us-ascii?Q?UhtR2XqYPSkogrWcUWVkWW03Zh+GNTsCY91JBHqx7ilvQDdwgpWJg66I9oNZ?=
 =?us-ascii?Q?NRlOLrigzqM+Sdb9U97B3NAcau1+OMIqtm214Huj/b451RxY8KSRlPDr9lZ4?=
 =?us-ascii?Q?qYfanX7gz+Ee/dE2vOQNeAenvlVBYNe4tz6FjfYtl1nxLqgS4Yq5p7j83T25?=
 =?us-ascii?Q?f4Cf/vQxPnna4f54mDIcXTj3o5j90LYudDApTGaI8bl3VgBaZ4TU/HNu/NSG?=
 =?us-ascii?Q?4GmWfPjOdDtIdRFAL615DdOmrDeuODysCatDqSQHVDWToP8kYRXL6zOO8J4V?=
 =?us-ascii?Q?Ruyoo06ypavkP/knRo4jE3AReBZ7yBQtbT09jF9Dh49aVa+IzT4A08A3Fw7i?=
 =?us-ascii?Q?eaRRbN4/0eHSnN9dzyKNMOPu2P/IF2iWH1p8dz8AWAr5s/z1iRxfZFX/YVhF?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147792db-b555-431e-acb3-08db1428669c
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 16:26:35.8972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4yGXsdXOVIEwpu8ui2vlVHJ6d062MUDXA0oeKMG/WZ9f7w1qEZuo/kJhSdim7fEN2J2zOzDJrcYMpbErwt2MlAbyf+jOTX9oiSVyPdr9uVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9405
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

