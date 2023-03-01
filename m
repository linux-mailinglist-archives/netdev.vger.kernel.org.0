Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C846A701B
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCAPqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjCAPqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:46:01 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2053.outbound.protection.outlook.com [40.107.247.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C48144AC;
        Wed,  1 Mar 2023 07:45:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dApxgJjHV7Ol/jq7XAAmaxAE+1ziEyhbjCr7yKgylBYCxILBVePIfnNtRk0Uit4az5AzzCJICuZ0o/M/I3KOsY9UDfsbSKh7u9p5igraZiyD71NpFGFsKXd4NVfT1rwqn72eCQbVELc0wix02XPMJDavETBGUVVP4TiC3T0ohfHXwJzMLUvxd1HSRS1XTh4zfFoDFJGMRPlAIhLI9mKrXbhEhByqd6iCSrBtBdTZvw3BtRHyqH4STBMYJJ6PIIFe1+qt9RBlStuwZALcno2VK/ZfJucYzT9XzD0VpczCVVgxXauJUBj6Kmj014yGQnchMs71zpTjFBvJ1nkyqiDz4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncbsG0Fbp27+jn8TcGuTD9b8u/nUZv4be5v46l52UwY=;
 b=kscRZ3kIEWO7kjgyXI3lZy+kLxhEwniy57bYXfDVtf2G5x5uToOGk0CPS9y6m2h4yAR5B7o6s2MUH7gDJkAJ47REw0vuCKEDUBxSZQBrV2V1IjV5cMLs0J1h0YVWKiqUJ0xy5FCVyCG+tqz8EV6I1tWKSU2Z+0vTZXWtBUnXSU0nsO7YUB4xuQi/oqgH5i1bov4it6QNvFddVGxS1+8qVed17oDzFNQeUjL7heuv3tEKSIYDZoao3ALfX5wh1mCcOnb7dHbnnrkke9L4T5OYK22VY6cWDHhLsd/hnwlaKVp9en4gxt09ZWD16aotUpb6rnwHJftZxqZBm5Od1w9NjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncbsG0Fbp27+jn8TcGuTD9b8u/nUZv4be5v46l52UwY=;
 b=Uk17lXsFTzZBoOrat6ZJvgFbycI9KHGw/7r245NB3gkIZnLVmuWGwd6gahsJAJw/s5SpAq/qnWXbAv4KOcCfX2KBQ3CYR8wA9dmYuOBIf8Lmng+42AyoYd7AfVw5zQCNb74RSdRWibFZIfLwcXgYbfAolJDRJ0c8VzKlurXJ4U8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB9129.eurprd04.prod.outlook.com (2603:10a6:10:2f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 15:45:55 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%4]) with mapi id 15.20.6156.017; Wed, 1 Mar 2023
 15:45:55 +0000
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
Subject: [PATCH v6 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Wed,  1 Mar 2023 21:15:12 +0530
Message-Id: <20230301154514.3292154-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB9129:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c04a031-2ec0-43b9-b619-08db1a6c0af8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1a8b2wBQRAYldPdsbmJ1bHAXpgoaGQFtvhPdaTAWPWNjJgvZlSLV3wAk9IvKr1ntrXLLEJYVGrHPGgswIPCHr1bRvpQCLo6nDzylaIwn/BFpZ7asQ6BwZBrGX+5JGaXiGI1dkoi18X4AwR0XreFZJPwBUXiwSyFDfHNwRqACULyoTXfu45Bp28NeepqWTkLJhV2xd6ZxbBsCDav0hasuFpkZ+OcIIqWUvE4aD5b7JvjRwILYMljD1xzEzG2dYyXuKegvjVjeYsv5H/G0wsRT+XW7OtX2pv8EqztMM4lwuTAARNOaJNauBFdPiCgMW57gUp2RYhccPOv230MFLBDlXTjgpRYORdFJWTzUWe4P0FBL+sEY1ZaiTy5AFDSbHB1gLEXa+WmPLyWDvvXtPdBEl8FDBXF5nXJAS/41pJML6gqHcq/oyvKCmBcx8oa88kWrXqZ/36VPlOOGucbt3YlCqau+zBuhNBLX9q7vS4q7JtbnS2hhCW5/54MCp0bqhfhjzK0+9nNw9EfzXOoOalRA2+FPSYWiYoC9XkX5q1zpAGbr8mbXFdEhCzr5VykQek4m6JtmCjYvlkVohkga8Esx3tK8eteWdh6crpKcT2uoRqwANNaGO2wAYi8qSACRxlW7KB+s1PJ+xqs2TW6U3+oK1RoXVOtZ8GTC+7+SNsFd56DvuxomGZTqdRPQH7iKLPhvy/f5ocMynvbyqlRShiQLk506r+cfEH7uWyF28/S4hv8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199018)(38350700002)(38100700002)(921005)(41300700001)(86362001)(4326008)(8676002)(36756003)(2906002)(5660300002)(66476007)(8936002)(66946007)(66556008)(7416002)(52116002)(186003)(6506007)(1076003)(6512007)(83380400001)(2616005)(26005)(316002)(478600001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?34yCFVTl19yB/fGeTAtO2iqr2wFnyBdBW4Wo2sZL3aFwshnDGMmsO3OpE6AW?=
 =?us-ascii?Q?lMS5w+RYkV2UXbdXl7SdLAtUB25yikgv3vhkOKEejHQJeCWd6R31Vhj6bya4?=
 =?us-ascii?Q?57X7DLSYGoNlxyA4015SvTgXj+rMiclt2nQxC8Bfw5gpMgBp4wBAjzgW4e64?=
 =?us-ascii?Q?eEAmUpH5l/ZxHcdhUe594wT/Y+nH8uXevlfZR2ddXPAMsVlAgGJozVgXVxk4?=
 =?us-ascii?Q?UeiKF7/u6i6oa4xtIlDUKzwCWhzXQIDl6gWCB+VkGTGdxWGj4nIUS8+VQYVE?=
 =?us-ascii?Q?ltV25szigWh5GVC/wpCqUNeEkJJzhs+Qz2BeRM3SS8AMiQp9eMwlKPwkdVU4?=
 =?us-ascii?Q?O/0X6DapOhkPwptzseOYeffzbqeRDK5ZIP/0y37oBtH9DdjG+R1ehpWWaOIJ?=
 =?us-ascii?Q?SGQNgSW4Zy+0pWf2UcTL947cU5md4k1Yxzem2JOUK4GwB7Uc4AmDM7/OFoBi?=
 =?us-ascii?Q?DyWgy7Hf3A/YhYw0fwci5IVVZYi2DCO2vp35HOK6mhS3CGa0TnThImoNpGcd?=
 =?us-ascii?Q?S1/6BmlHmzrk8CpHVoMEARkyJqaFnJ7e6QAXsnUM6UScyEgnF3V6RlbHQ+VM?=
 =?us-ascii?Q?C6wXYTxBHm6NKYE1QJ4AIY9ZW2+ApOUTa0lk5ESrJMwgeDv0lep8AFdT5nfe?=
 =?us-ascii?Q?p1B3VxK1/N6qR3VDhl+Gcs1HUYmJULvyARpA5dS1olHIMQOx81uhoS87fRbM?=
 =?us-ascii?Q?TBJsYJT/XrQ2I+oSro23qzUKYkivlL7UUB1q4tXbu17+8Dj4DW7a0mTHkzAt?=
 =?us-ascii?Q?4FyChM3EgSrNCwBnh3pKVbbGqgxHdyShpfpkSdk/o89TFxVCk5RIy5TmhnqX?=
 =?us-ascii?Q?dHD9xePGiLCYZS1A7k8lKZnaZ46wHQ+i6wJpJ98jS4lKEA3XM7q8VPvIlDji?=
 =?us-ascii?Q?5sBEufjShu2nP7Mm93C+uf9pMcmbvBCnG88ds1UbS4sahLgV/mHQnS32udQe?=
 =?us-ascii?Q?KtDlE0jwjCMWcKJS2ipEfxuPNRJjtE5Xem2KEKWYnfzo1NAKqXF/jQ8F1LZH?=
 =?us-ascii?Q?W8EBEUyE4B+goplGTW8tvcj0tFlibyhpjowYrDcCQ+cbmzxKyPtq5Tja/dxv?=
 =?us-ascii?Q?xcxTVteI4dLMxn5HtKs7R0rk4UnvQrSVIkZ6ti4KykNM5OobqA2ZMwbwA7Gv?=
 =?us-ascii?Q?KW5FPkvQkUsQRfIc8ladUHqwupwdAkWM1tJfGrNEoRiT6GiRG3nSNPpr2TOI?=
 =?us-ascii?Q?VT0cKtPOfCqXbgFi4QndukK8zyXQuSFx4mShQ5qAE+tr+QJzqJp6Kh/6Y1cI?=
 =?us-ascii?Q?O2h0jUUtji9cW/6ETc45UZNcweop6jrUXRsQS+NBnm7ECdRpiSIbP2TSpioY?=
 =?us-ascii?Q?9V/p6oqTq0nhk4772nBxYPvtwLJ79NxS5rlA+BVNAKW+fBVDaE/jynpVZ4SH?=
 =?us-ascii?Q?WO46+KlqK93vvLPoisr8kJlH+Bnb2/w/0lLCfuqDBKkX52wIz+Q0I52eTrjb?=
 =?us-ascii?Q?ssWd7f0fbObZ0+ybymC4FablWTgs1KNfS10ZwiPjWGiz6snUbt/yuzbmtBNL?=
 =?us-ascii?Q?y0djcxxFhj7AWUMwWy0Vm9d0yHQ6d/elTuOr0AC6ckRT5+6ybJiQdqRq6wYA?=
 =?us-ascii?Q?TGqvh97QpcJvSuA+z6gVqXwDREJeIwRiMIzFKmGKz/+KpPGTHyOb/PxUH6QB?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c04a031-2ec0-43b9-b619-08db1a6c0af8
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 15:45:54.9199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rVlWVqqCeEXtAu+LZ+IW+MuVVoxI3cxktjjpxtutVXe9Q4tMO+4H9pjIJphSNRhQ9rOAnwx6ZjigfUKdeSP+ixEnHfTbB3mBSUWfQXjCIVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9129
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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
v4: Add a check for SERPORT_ACTIVE flag before asserting break over UART-TX.
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

