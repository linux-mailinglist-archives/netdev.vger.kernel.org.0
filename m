Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F326BAFD8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjCOMEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjCOMEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:04:34 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2071.outbound.protection.outlook.com [40.107.241.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22A62BEE0;
        Wed, 15 Mar 2023 05:04:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3E08Viq4KESPXH+aBjdDDUwb/7uD72FPOOVoGkWFlIgXszPADaQYQoOUHYoCs4LS5oxu3AhUQYzWkzXoCH2sFZeETC71/rhvv8qegp3b3OupHtxFQ8nG5PiTFD0UoSTrc/3WZx5eU7D5bwDEBem2sDYOfbijrqc1iKnLDopl+Q6/bUDWu6Q8NWYtvxaKJHlD9I+oD0SqtVAE9rJLpaM1r3lcHg5zVHHdeLD1/J/XCUKnCQe21/bbqEIT3FKAQjejCGAVQvHZ75NEx+9iFmmA4LiBoHDpme+EY63vftdFUC+j3OYn8/RH905rjIwWlIz/xmM/PswenpkZo5PrSIEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nBPLnQZTmbjcXxRT01WcUGU4Offe4k8SEV+HxYAerM=;
 b=WmaDi9HHl1Fwg3VEAnrs6Er6pNiX0FU0qPghNNbsONiWr5WuF70qu6iuB7pwmWvfXAm3Xc91bWieh0FGVKuDl3pP338brBxg81bttAZTUDn+uZ0U5Ny1eTnDxUL79qiSZ0COhipYGjDxQFIXhV2m2b61sEnUn+FTIaXYeopeywaz/5uX6CPpy3/YowRwrpeL7Sp2bD7xIZUIE0vrBgaSBdxtYOMxhqv3kxfFsEYg7WSJ4Bl75kDmMk/5U6qNWP+b/vqO/pfMjzsma4Lxtb7TLxbDGumzTzZjdpPS10pnYEkiXB73UlSFutFn+vJy/QHHPKHeflnFRpMDjYLJUAwlDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nBPLnQZTmbjcXxRT01WcUGU4Offe4k8SEV+HxYAerM=;
 b=AVfic7gEmGfaXUlnT1ieGBSYUqyyDLEhTA12phZRbdpQyOll8K4tZ9tlyBJWglYfIDsjvgLRGqMzjSPnuk9IHSuAfkB+DjiIJFT6sufPYAdZ0DzThUHohkB5YO+A+8opLZzReGHCmqHefu12Lkut9M/DAZSc5QwYrr4V4rdq76E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB8629.eurprd04.prod.outlook.com (2603:10a6:10:2dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:04:10 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:04:10 +0000
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
Subject: [PATCH v12 2/4] serdev: Add method to assert break signal over tty UART port
Date:   Wed, 15 Mar 2023 17:33:24 +0530
Message-Id: <20230315120327.958413-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0096.apcprd02.prod.outlook.com
 (2603:1096:4:90::36) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB8629:EE_
X-MS-Office365-Filtering-Correlation-Id: f431bd0c-1935-4355-f2b2-08db254d62c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6XzxAjn7YmXYZLptZwHCiFUt4hjL3bSR52bBLG55YoO6eOCxvNUYHHrUmkkhVZ4j7pQzb2tRQ8TXnu/BrJJZxVNXJzlXO8viEihWnhsmpU0dj0LgDgn3WV3Q0T22/Ef/w3gGPDKcBI4hPc5PaogvVGNyBbT76CerPcfdKj6m2doU6jsHJmQ2SpKcWpboVztbBJANf8JkFYOdZB9PhXBr718rhDnI9UuJzQGMCfujF3XTnYnm7Ych8ZycINb0M3lv4K6ZZm4Ni+6IEWi10lOzbdnOTyPY9z3k7XiB0f18Tt+LKSs6H84DLJYzexON9CgyZOt2Pg5EvEoqC+kWSyjo0kPlDcSmkHZgz/B6O4+fs6FOdPlj+h1mbtBgLZH4r42DsCxbuGsqvuNrQ7FoeCZARdNMW1mYIiWeHsoCNDz4xITHkccVON4QexXUaDi0oQwGcZ1hJ3iF8HYOoTRjgnEgL9sdacAoIzUu1AO8q5JRKYDzbe7I0ffv1o/LkfAPu6qT/dwo5MEeFg0FbjzN/egYbqOVzIEjRBwny1/gOI3yw/QuDwIgWUSOeaiQMSDzfaLtgS+0Wp2qELctQQC3EOolEoEHYE9AFAt047PKt8PVWKtGEk9JeAtTfDWGRhU909YKQ5M1FuvwLiwuDRJhz5iAOIgutMSJflUYxUpJ4uF/bxwiAck5wrorpdBNYNHdKgX/LJsm9ez4yYCxe7zZbPIZt2XuXq6Olyz3BBIkCvy5Kg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199018)(66946007)(41300700001)(38100700002)(2906002)(316002)(38350700002)(66476007)(66556008)(8676002)(4326008)(8936002)(478600001)(5660300002)(7416002)(186003)(52116002)(6486002)(921005)(36756003)(6666004)(6506007)(1076003)(2616005)(26005)(83380400001)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mx6GWTq+71PFomIdccDE+xZ07URYDMQf9k9xpld0xgNm77NHM4cgUiiSy2cu?=
 =?us-ascii?Q?ibXPcn3VulA7Pkh3mM77jcuHYRa0B6bWXzjLlbrEqViAPl3iHML76Ampf+FV?=
 =?us-ascii?Q?3fIPaGqVsLvLEp7Xl53lKhtwgdpmh0rHxerKIy2qaoTyex/cSdxvwpP6nQob?=
 =?us-ascii?Q?BokZwLYF03uyu9jzUGuCU2SoJP06wpU8GW6dSyeLku4u83HN+3Hpp73YdFlC?=
 =?us-ascii?Q?l8uhAc6k3upBog9i+hEtbINnjlA8KPVRC6uJTVjSgSNfOYlU66C0EsiI6yol?=
 =?us-ascii?Q?3snyPw5q0pkwFB6I7IxPJ0adjjTPHgnzE20xK3K9T7PzVIU4aSHHtOQuaPsl?=
 =?us-ascii?Q?vD+QAzACJoyIEmZtVaiyvm88E/JNqyGZcqxqrbRRqodpgSp/TWg24qbO3UuO?=
 =?us-ascii?Q?QG2UN5c/y7un0aDqsRJ1rEiBzeH4RnzH7UVD7/J2WbkyvutioHuxfaPY0H/l?=
 =?us-ascii?Q?IWD/Egwwtr1Nad9FPa8DRXE127FKtubetN0F/v31YhqBFyNM0W5J+YIF76/y?=
 =?us-ascii?Q?G7bKt+86WO7lj068J9kHmVCo0PF1J11hR9tVOsyo8Yf8s/6VAv+9i4ps+WH5?=
 =?us-ascii?Q?U76a2bzt4Eh8UKCHywd8hzv9gw8bbPSB2WPNAknwRja0/vE3fWi0aGk/YpOm?=
 =?us-ascii?Q?VObcTJ+QhmVpuUWzVOkpxBWY306oQfGMvrhhgHYEY2q12p39B1HQLPHGdCyP?=
 =?us-ascii?Q?VoB4hVwg6Z0IkgfTeJwUonhtfYlw7kLpIxwUO/1+Ja0jIEwfOWZVEFF1d0vt?=
 =?us-ascii?Q?8x8pdOiHatIsJwMMoQ9eyPzMX5knWKTFT7npuHN25g1SnuNEvIT3KBYdhSPH?=
 =?us-ascii?Q?bKyomsK/ANTS3Jxvf+H11IZl9slBF4yQFh3WK/qjXwLKPWZmXHCi9PL7M9Tr?=
 =?us-ascii?Q?1Ukr8SkKf3+RAh9U6we19Z8Rv5cITJA2QByF5Y/1nmaVy4kTWM/sauCeAB79?=
 =?us-ascii?Q?JvZqEGtDx1O0/4Dk0RCFp42ro5oVrdbIHQDzo/vVC6NA09e7kHq4OkQgs+cU?=
 =?us-ascii?Q?M8wKOx4KthOI+zRRoSUuonc9kROeNYfwIF0UFaViLOTaIznPq2/uCJ+7PrrY?=
 =?us-ascii?Q?vD+0T7QcPYRvy0re1k0/GxRVb+lDHZgXXDv4GMURPETDtwfnXrC+0d4Y9f8t?=
 =?us-ascii?Q?YXsHJVTpaGORMy3TsCjQ2WLeUDydeE1S/SCJOlHBONJ3Qsd39ThiiF951fMw?=
 =?us-ascii?Q?gXfJKlgPguIBd4e/U9l8xas6+Vj7kGS/71ygglaY5wtC67IHAyDL0He26pH+?=
 =?us-ascii?Q?dOR+PYXKmUqYDiwUBb7XD0o7v1KV7DAULDWm03kteDI3W3ZAZnPwtAqxNg84?=
 =?us-ascii?Q?dl5P5Wu2/+vpjCVRqUtaOkyB5nPdx8WQfmpCyOKsI5EbcPrZFxeLB63gJJ9o?=
 =?us-ascii?Q?Ld+aXFC3qnUQjSgOjDGAMBjT1tdecwT+yQHRy7TrD/fcl45wJJO7LyP77fLz?=
 =?us-ascii?Q?TEi3I/IutfxZ6LE4pT8sAhdSSAtN2PJOrG64nLQ3qDdbxLka84rG8h2VpAJC?=
 =?us-ascii?Q?8YCG6qMXsBj5Mm3cJ5nDh9RICjcBXyPcJzAO8+J3/KxJqJMjBnT+W8tJ0DAI?=
 =?us-ascii?Q?AO1UuRQCHiHfy35mHmefahqP9zlfUfXjZBvDj6lK8wTUbgLsS43QocKyZPQH?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f431bd0c-1935-4355-f2b2-08db254d62c3
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:04:10.4962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiG1FLuaQYQ0VZ2nOALqnEyj2ajS0mYo7U/3T4fzsYeLxIHBKiyLOeVp4UD2glvP9Kiu8ZaXvjprA2F1LbNG8/9NU9CKC8ft1prtEYCyqhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8629
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
v3: Add details to the commit message. Replace ENOTSUPP with
EOPNOTSUPP. (Greg KH, Leon Romanovsky)
v9: Replace all instances of ENOTSUPP with EOPNOTSUPP.
(Simon Horman)
v11: Create a separate patch for replacing ENOTSUPP with
EOPNOTSUPP. (Simon Horman)
---
 drivers/tty/serdev/core.c           | 11 +++++++++++
 drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
 include/linux/serdev.h              |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
index d43aabd0cb76..dc540e74c64d 100644
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
index f26ff82723f1..8033ef19669c 100644
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
index 89b0a5af9be2..d123d7f43e85 100644
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
 	return -EOPNOTSUPP;
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

