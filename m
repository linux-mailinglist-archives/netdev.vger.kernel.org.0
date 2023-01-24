Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5D67A06B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbjAXRsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbjAXRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:48:15 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A586548582;
        Tue, 24 Jan 2023 09:48:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYlqo+WCbWJsoytteJNZhbUeqvWelP/Re5tzRij3p0lte3hYhRmAe2EsgP6YwnRDHXOrN1A9rAgGBacfwdZ31rH/zfBY8rXxugT1+Pd8aPvwwjYy3hyXUqFkP8J4str9sCUGgYHONyT15EYq+wd0keu+NIN7lbHAVqyYVfedTJN521xiZE8behxPb1fmFirxUNjUkjMS/VvlDBjiMlZpL/jcRrT9ev6aI2QYN6eV6vVpI5+gnOgZvdYM8a2mwkUe+V5MEO9AoZlZstmP4LXzLWYI82w0GFfazeM2NC+C3OvYk/Nxrhk4gFKUdnZN5P1eencqDDaCs/LlKitTHwdAdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5nbcOgcVSHPFCPJqOWAGZJRAJK2XDDhd63lyUiHUYo=;
 b=AI7XNKICOuLNg+2lMCePnJ/XWDz+RuVunCYOOQmhOG3y21ywRDbwIQpydlkBl77q8chwln0jKwwG3O/xae/6M9AHSfDsxHAHT3fLJWQoYpeKW1F9AEM+ghzl2fjpwOZMzhOPXy51jEM1tU8bVm/erN7iQ6xK5n1Nb+2V0BeeSsM3wXTZFf727aa6BQLMHU3GRrMtWlFTBoY3jnSkdMfGOBCYiKDmm9zf3vdFLhVXwnqawM2qWf/EV1O/2Ns94BTXmmC1dxKm+hkjMdTJ96VZ/saxJAxfj36yZG8lw2+QalZ3ORuO/lOdAtsgWg2vs9Neb5Ad0xuJq0BeT5A0+/j8xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5nbcOgcVSHPFCPJqOWAGZJRAJK2XDDhd63lyUiHUYo=;
 b=SOkYZahaMOJzyGA0sXh/TPaak0bt9840PkMMBhW8ORXnYw/I7tb2/ROURIGO56cBO+rssnSsQhEe595ADVTtt0MiL3kQb/ldXq16vpzdiALY/jPsJwhL8nQ6btPmewFc94klnhyMA6I7UMgzHCRNGDq5J99sC/quWUXR+8jlaMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM0PR04MB7026.eurprd04.prod.outlook.com (2603:10a6:208:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 17:48:07 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 17:48:07 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v1 1/3] serdev: Add method to assert break
Date:   Tue, 24 Jan 2023 23:17:12 +0530
Message-Id: <20230124174714.2775680-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM0PR04MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: 67135987-eed9-4b4a-b8fe-08dafe332677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dd/S7JlyHDAqUgsieiWIVUm/9sZd90EhQRFvpk9vJGXzhm+Y9AnuQXyA5t8QSA5RZgOJUAY9+GY5tZ0yCAlA3+WY8pf9+MRInm1xYxFF4IbUhZ6wbalXnyx4gu+xHuRxgYMzb5njsKLHN5Rr1RdQXYQfNtApLIFTXe5D/tfiBvVAUWSDceLDVOx18wRxAxVI2YiWHo+4URfKP0r4J6uQMP+bGGvXygM/OfDs12TrS3xFNEYi8xopAzSMta5e2Js1GFYIRSITRyP937jp0XyNa6iTcWqIdZNO2/SfO8Mb40NKAB2mPXE40gu/diKK6X4qk8c6b6OAz6usCXgIQPvq0o8SFTZEVNxozAaOz1zX7dzdEjfK1mRWRxq6ZzFmOuJHW79DEm5nOExdv7eZxhIozdN8HaDF6PWaQR3lc6jkx7KgJ8wdY3ySREs/j6xmW7Oiulx9GGp6vSeGciv7lLIAwOatbkZ0EUyDrLmsCuMNOLpTroYW9kp0vnGevRb+MlQTDK9N2TgWrcaMxpGGIDERA53QamWfAcZOkDbHIgSYso8c92+DVrxn4DFoleW5ttWncU61om1uKed22EMXH9h7GNNjcruvdb+A0osvQuxhZK07ClQCb8mnn74y1M0dDbWASrEya1UtGAnpoSEgVTrY74Rl1yRANLJV4BaafFJ4fO8bm407+Q2x6/recqYF8IJbdatvSUsjK912idJj530nAq/poo5Umx/Y4xNzKdV+LKc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(36756003)(86362001)(921005)(66556008)(66476007)(4326008)(66946007)(2906002)(8936002)(8676002)(5660300002)(7416002)(38350700002)(38100700002)(6666004)(52116002)(316002)(478600001)(6486002)(41300700001)(6506007)(26005)(2616005)(1076003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LKLVj8aIJ2XvVP4B2e3L4X3vwRP5JsuhAqFFa3uysYgAoiZ2IAe+361iYseK?=
 =?us-ascii?Q?uT0n7KpParsiVnzqHVOBzk5stXq4LlyBSOmqgcpoiu56YgMr3ySZWUyiEzDV?=
 =?us-ascii?Q?ruV44i/WrFt2H3SKiSqkMzFug0/InGF2pHsXncH77+lSnQE9WXfPp82PUvg6?=
 =?us-ascii?Q?9XNdn8b+zl7GWW44GG6gvUzd132j74vwS25aukR6KSRMxaElZHGbSuwzRgMM?=
 =?us-ascii?Q?hIMGgIZHQGhb75lANs3LxxexjeGFoMm3v7K/IvTTOT3EXL1GGmlyzBQoD0tW?=
 =?us-ascii?Q?iNYgNoDoq/LtDjEwhpfQ8EG9s51UcWxJReIon8fjBcHY35h3gbfW2Bj1cEje?=
 =?us-ascii?Q?B6or2lci411msfwXIq/XOe3YJwuXHx4E3DOSJyt8NfdJ95+HvQBaqB+V4E3Z?=
 =?us-ascii?Q?IHkm17lLlES+tBwnxYHIzbBFc/W4d3pTW8S+vujcHWS/YjS6WA1dmZWuYpet?=
 =?us-ascii?Q?4kGXQzjsgU4gUXqP2ac91vk5+1B2tbdvnApFJo3kwX419f23HdtXM5G4wQUZ?=
 =?us-ascii?Q?v9C1L9kPnRxRq/ZAOCrTXytJrAZ0aLy+JiTu2r94YwQ0fsaLeWcwS/wWpFgA?=
 =?us-ascii?Q?Ot+EzGQ+JN2h5+8/DUuhoZK8Gca4idYLC7hqd8H9XRVOwlYQxB8xVcJ+urDx?=
 =?us-ascii?Q?5jEgkAYqXF7poGZPKrbvUFMB2PlpOwuXdbUU24hZ/lTWFjymbhBElw4ZENii?=
 =?us-ascii?Q?yYwnqyLr5uGsJnr5CnyLTbEeU7WZj5FE7ictgzgM2odOH7JhYx9nFHSzH2QG?=
 =?us-ascii?Q?7CPwMYg/nKYgApHa5w+ICDdFhNN7OTClhKAy5E4JixXn05kMpwy1Rj8LirYT?=
 =?us-ascii?Q?e+5302QK23/FG9MtIMfgC/DKQvMPiSpLu3G6Bc/dbYDpEFyCpnBEFlYMliAH?=
 =?us-ascii?Q?0KZ4U6CVkJFo9plNMZweAEFnIm7cJrWRNWaH2N9+NnK2jfQxnW6+fBuLz38J?=
 =?us-ascii?Q?uzyCd3EaJtiLhwd+6J5d6ZKFMq2oOskQPZJtmOdOki+38dPilr2VHZCb/dIZ?=
 =?us-ascii?Q?/0vIovDVpQKQ6BmHLG+Q7shZrNl72af3uErz/NPTtcqnRgGQWjKN993D2qUi?=
 =?us-ascii?Q?ak+eWqtkEsmNZByWDZlQ7SBGKX58K0YPef4NviZHNSTWpdak8QPJqiX03rib?=
 =?us-ascii?Q?XQCQNjGF1GFUckdpcmqoETKtbrqVhI4ceAj/kDmL//VQZ31wM9HKx41QxQkm?=
 =?us-ascii?Q?vvwUbrh8YTA+c5ZDTMlE1kW/NE5OUjydNBqdXuFlWKJZnbkDb0/xg4+/eaEq?=
 =?us-ascii?Q?r+hXBv126clb/6vUdbFZdIPYuJe5LXKIj495BsDdpYPY5yVYCd8Pqfwv2Nby?=
 =?us-ascii?Q?qZOERLiOcZrkqQ1R7K1DOmgD5aUmw1a9NzHa1x6kVg9odxtADYlhXzhcLB/s?=
 =?us-ascii?Q?E8orPE+6dJMSeGCIOaQikv23nw4ZUkxuEdsJabYKm/K/WAiWUwKTN3vWU0zp?=
 =?us-ascii?Q?Ma/jEVemhcDrBcDh/MUboiZJoHeHLLSOtpbJO/OYUl6iZUYIhJ84yA13t0mw?=
 =?us-ascii?Q?6v+as/+qoYU77+OWZKBhVxENB3uonHLU5HaneQn87AEbcYizoelendvcGrMP?=
 =?us-ascii?Q?udN8mZnPVo0cwAwGCJG4hvdVWKTFZGZSRUSWIHDzGFc7Slf/yCHkwSmnAANg?=
 =?us-ascii?Q?OQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67135987-eed9-4b4a-b8fe-08dafe332677
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 17:48:07.0388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q35CaskcwrQcreAXfkMdQp2kCylGvIl25IvmeK0p5+5NLP/a0DGnn6jLoe/qtpojyHG109mAnDjLiCJVEpwypklpQ0smpb0nFINuzJ/pjic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7026
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

