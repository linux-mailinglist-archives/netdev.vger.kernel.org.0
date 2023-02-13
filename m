Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCE2694912
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBMOzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjBMOzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:55:33 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2061.outbound.protection.outlook.com [40.107.6.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA8B1C7F4;
        Mon, 13 Feb 2023 06:55:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agIah7F/f3Y1Bce+pIp+XxTGSCVMV5gCyqvcARSnATeUUaqfn+Z8FWte+8yhmSu37R7GoJD4EFQBs107npvYqef07kVFx6SvDqHNwwDlSVsWS7pyGFzM8rMbXrmd/FAelJU4NivqcNicNTqSXW20GkvUFmjGEyMdA5vS6OhSWKcz1BPrYw7RVgPTzewAPcwFwzFzhiEIoghM8h4bvMcD89ClFL1Fp4mDH0ZSeRZaxX72cQlT/zLGyVlUVgfhd6Yd3DNDSvLth8GBVUvjI1xmepFC/P7jjb81yKrEFJz9LX6omffVckuWWIEX6Lv+vclY4reVm0pEkZaGT0HJFmGobg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ta+Ww9o9HktQNwZkbqs6z4pt+Ol2zIBUeLuWY1Huc24=;
 b=CCR75ae1BXwlJVgFNsmIM8I7qTJWKwzVOpykU60hViYmZFTqPbxMoSZ2ujqc0pL6IyRAVVWwOReUVrSD/63jMidN4m2SOlQke/ZBKJkqO8oiz5FAMO1pn2gcWWmn58B8qj/TzbTa/iF1y5iW+jqVVarbgoI6vmLCSgux+pQ4D53NZ+Y2NZlfPuetKWuIqfqMp15IJIhYXu0ctCD+4TlQHhcQLfJdoYtip9fCJQr3XOAYi9j5mFUES7qqDDFvPKjS8vTlohC0CN5ey1AeHoy364JrYeTTIteNfo29jTGPCxvsSH1tOQ6QJeypvTHr9DiYJC6lT2qesone1A6L6aF9pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ta+Ww9o9HktQNwZkbqs6z4pt+Ol2zIBUeLuWY1Huc24=;
 b=LqV+HBReV+9g3WUR0Ox2KGvyvaufEUuPg3YBQfYhOK/7nmHxmr4/wdY5P5db58uxKHOOzOwGjz34r70Lt0FfLZQRd4FFHw9w99rToSR3c7ggHAR5+cRU345PL4vx0Ac0ZggOpJVAGKm0qS/gXSiU6CHa2Nf25Cy1YYxxgnfUxFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB7523.eurprd04.prod.outlook.com (2603:10a6:20b:2d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 14:55:24 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 14:55:24 +0000
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
Subject: [PATCH v3 1/3] serdev: Add method to assert break signal over tty UART port
Date:   Mon, 13 Feb 2023 20:24:30 +0530
Message-Id: <20230213145432.1192911-2-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM9PR04MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c3e598-986e-4fe9-e625-08db0dd25610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PeEFY0qlhz9MpIHcdNYCdEgxSGC92GrvhHAsdqL8dPI2TDAC9cb0b+bc2wROJ1WGca0wHsISc+XQJ4V+ddr/FexBRKn3afN7kToxuoCcKvn5eK5YkWvAddnPrxb8nbsVVzI/6EnATXqZzzPGvr5qA/gSwgfizf9kwIDs4zi2x+tShNVqCBvEOKeUG8I6XX3scx/rpANFFhxJMOQWozB+RmVWIczSbnKNrGtYIRgquKszf0iLT85Ct4PtczYKqHzE07acQWWQTxz6Vxa17orV6OYG3PjxP8JSyckdf6AoA3LqWGE+uMjCTCGCTrBPBe383YFOMxUpC5vASafP0P0NAE0l1X9vPYm7dVEQMvtHl3pOrhrMmMcDHpecE6aaQBc2ceRZ8Laj9rBpmf2HDqbaxrjeoRL63QHQnS+2uqwCr8AEwSb6p4OmcAyPOd7AS6jQGC5LNbLtAZs4olKSy47Hgk+ZC46eSJyDOqEKpCVjhYXMgUDo+ySPsw0rFtdm8zPZ9uhK0XgxdzwFCG6uj0pIZdje6U1NxTJSEVC71sjV/pN7GVfULB017rH9LWwgvVzZJTMlPprjL9dcBTMMxh0GfBLKeRwOq0fWH4uld88/+WYiqLhu0VgZqWGoaDvLeD2F1pqbfE9lf0S5nkx5Apl62O7/bFnVziJWPW6Upup3v2DGRylO/WW69RF5qqaWDE2YFC4vaNAw9CWsDGCpjotUKieWubgbxJZCdTka394ptf8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199018)(478600001)(2616005)(6666004)(6486002)(52116002)(1076003)(6506007)(186003)(316002)(6512007)(26005)(66556008)(66946007)(83380400001)(66476007)(4326008)(8676002)(41300700001)(7416002)(5660300002)(921005)(8936002)(36756003)(2906002)(38350700002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SfjVkUIfkJ3o3jLGTrmf2fDyMQG0z9xHd80HNeZhCeTHbw1Vj/4L1y9MmG8y?=
 =?us-ascii?Q?EQhyLKtqPI/QHnryNw91jxnMsOyQbIVzieX7HbZpM425bUSAJj9z149+6bMn?=
 =?us-ascii?Q?LpZRSsdel8fx6pVv3lpXAJCMJrt/3E4p/sP7oF+L1bOEpDiNsHxnw5Pgc4c6?=
 =?us-ascii?Q?uTNh0sP+j+SkHVffveKXaqdVzhLU5MWTwO9dIZYbH50MznZp+vUPqHs/fPjI?=
 =?us-ascii?Q?kTHukqcWUTqQBLBg2tkcUK19+vHtSzZiSiR6X52p2+cq0Qb4ZHEB1k59KiY8?=
 =?us-ascii?Q?l886ZjGPqYD+LWiIS8m3/t4+7eaZ6aLuuwAbzFgX+KTH/qziC2NflKbylBJ5?=
 =?us-ascii?Q?utdcOrfAGAf9tB8BLikybK5PAkCKaxR4ppyKkWMRNvBGWHEoorfDFJapPHgq?=
 =?us-ascii?Q?VAL1NBbCj06zwry/VF5q/UWg4M+gQw5NzXWXt2Dd8Q8/GkuH9pnpi9WQL5E0?=
 =?us-ascii?Q?AZ68RVRECw6zFkli+EKLFh8hPSxMpkR9PiMUVg4RLyMSJBq3iXR5Jm2iFVen?=
 =?us-ascii?Q?e1syTO9mUbv0XaB1yE5pdb7qbLLx7GxkjxgSmtqgW+KCGNEfuAhVkQ8Dj90S?=
 =?us-ascii?Q?mw4P+jHORhRRM+mMMiGhTZsDGL/xh6QUAiy3h4gOIhddBr//Jb60cqjC1K92?=
 =?us-ascii?Q?s9DhQ0P19bQN5BjJrUtuZz7bE/z7RzAcXsq4Q/cEpPiOGqWHOGF87R3KYcCJ?=
 =?us-ascii?Q?smRJIVKy2x7On97Pvd7N0rEcHAgDNQ/vPGN7/7YpIPEoQSfN57QmVChf9ntQ?=
 =?us-ascii?Q?puFQ/VaYoeuOtE16YN7Rs0rwUloVBoZSXcW3VVn2PbYL0FWNfunvnGYu4a+E?=
 =?us-ascii?Q?brYb0CsNpnc1t+FbWlBIb+89RSLpr/2lpnhaHzIUwFggwKAUBQx0UBg5Xduv?=
 =?us-ascii?Q?NxqQguTwIhjw2pnSkD8kNg6V8rlXMdf7pUV1Fv4yKDip69KLE6LSq/UogBWx?=
 =?us-ascii?Q?Bdz4I5p76vO4eJ2el6J2yZ2VcqvzvXkHc0iCLKrENKL8LCWEDkmPhrDGqROX?=
 =?us-ascii?Q?DEp9ulwKF+EhhYFq57RiYNB6RCf454Fb1eTEziSKMi1I6zx8xzux4md3Yxtd?=
 =?us-ascii?Q?7M78CYbKfIGfH+98fcZw/pwjNmhU6OzfAJVXE/Zw77WifKeHQEqs6CruN7Ka?=
 =?us-ascii?Q?Tk4tLSmCiJPkG1Q8pKvycxk3zLjNKtWEkTTy4nq9IhP+rcjGMY5ZQTKn0/N8?=
 =?us-ascii?Q?jr5F/S9sIoAz6kCZSvGI77NjQh57HPlKR4E0bucD2md1a6wyDIJJ0P9IVmCR?=
 =?us-ascii?Q?X43a2CAa5PeaBw3MrY/Cyfo2pspmhpA4eAD19kTI0JubN4tQrIg3MUqF015k?=
 =?us-ascii?Q?J4iOz/k8rP4ywrur6ka8uAakV9hvJIVXHygd3STo6MaojADusvFhoCxzknLD?=
 =?us-ascii?Q?ZyaOQ6vEMpXF+eysIJFlNaJyVE8ER6DFYqwUlhvtd83PGwxqt2HEpgHmQHpI?=
 =?us-ascii?Q?RS5eXT1kJWKq0f8BeqIXq64eivlTqpdSNlyCvj3P6RY74B3BbnRwgGGZhNp5?=
 =?us-ascii?Q?0kqZPCqX3SGHvAYUtcVbuB54ir+WifWzyqDElZOVKY7n5/JGiSE3w9RNxfqq?=
 =?us-ascii?Q?0frJkdzEF1SZHPXWmR8fQMJCnLD1AIco53ms8EIapQaqEFnnlB5J7Ag+C1MT?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c3e598-986e-4fe9-e625-08db0dd25610
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 14:55:24.3654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tV6R+r95Alpj//Sqn04guwDQ3OMG/YS9urmkBe1n8aaZO7+TrURy9p7g/KQ2zwjdbNQi5qZtDVVpzZNpl/keOuJHLA1UMinKhVgzWc9cw+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7523
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
v3: Add details to the commit message (Greg KH)
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

