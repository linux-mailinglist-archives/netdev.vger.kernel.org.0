Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489CC2D0870
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgLGABf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:35 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:53705
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728748AbgLGABe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSNlR61aZhsuMg3A0NHaxWPYDK/nYRsskUibONsWQUJ6SKhKvdDF+C3f9KaT/IBAfrvT0JlqRjICx351WrLsl+0aB+9o6YrDaug8e+opTAnx7EGjx8tlpawpUHc01WeDJhS0vRKBgYgUJhCDplIjfbiM4BTKNhKUadVpRHR/OIrK18U3QuPMUpg4nFWGW3NbEGO3IJ4BBZ7aYdbLFlSj7Zh4m6H2ylwjNd7HO/yc+CmdYWk/VnI1/tYtAWQy/phU93ktzGsS6fAGnD009LVAp6PgtwhRDyOeLf8VvGtTDtiYmAP26paey/sr4N2CcAjphCTEDA4S7EK/Q4myZSTFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9lyqS3+YQoBjIZOTagj8aId1ZLbutQqlTf+rCJJTuc=;
 b=oQW0Tc6F3/TRPYSmPg4ftnIZ7RUFBqoWRu2j9GvEn1pneu/3GdUlAZQZYRhgXQu82ud7MpGxJKO/67FHpTSieDXIXZRkHzTgRIvfcgX9ZMgysSkW0M7q/atQWNRjv+EYpBEBx6ATJVWVNjgohTtkvRDDD0bYqB/F3ROtTpYEBWE0+34Ne+r5nWlpHOq19WDf91dJYLLr4/iUfxaJymziCA42xTGbP3SIfRMqbrh3BeYCtCeyOrZGJSqRZvtiZE1VcAz+sX8qawH0kJDI/yzrDGithXmuxYWFRiWkc+18KWJ9yh4JUNyYpNyab9aD6ylJb1ByJgOjnEZ+vIMxAutXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9lyqS3+YQoBjIZOTagj8aId1ZLbutQqlTf+rCJJTuc=;
 b=WDVLVQnp4IGWSGMiwIcXeJvlYmnYrJQiy+7p8nB/uxjvwF4KxsEUtYZqhzjs+3boZ2QRXAgYl8TDdbuF/LOP+EgVIuzFVUFNnuCArdinK4AsuGSqvMOtXQcvGcurWWZV9ZY8Kc2+Qel1wqpof5NAp6zoj9fQU6kjjeN4M3iKtJI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:05 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [RFC PATCH net-next 07/13] parisc/led: remove trailing whitespaces
Date:   Mon,  7 Dec 2020 01:59:13 +0200
Message-Id: <20201206235919.393158-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47936ec3-cf38-4dfb-3807-08d89a430d3c
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637EEAB538EB03A2A4BCBBDE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKX7bhnQb3FATe2ZL+X+L4jUKRqIw9pR1dicT9NcGqpZc9oE1U+AHYJAPK4/sA3mJxbnX9H4VY0CKaNryIh/Dv2sR8OE1G/6zYCTEEsOE70r9vnZpuGW6648Q9TrpafIPGaht3VqynDQvy7bK5UmxduXS/Ko4Sh7h29dEivS15tSrXCPx4duetELZBgl9aRldEVFi4EM48+COgXWPR2lA6tRkcLfxFASb54a1J5VkYd1KpvUp3VgVhruMxxBquSb386I6ZTJ5MEZMIG4E5lWo1P8dRPPh+71HmsxeZy11/ggLs7id3wtRrWaY/uhCNTp6L+D5yzySkRQU8HFELbC4oKjgmOrPnViI0ZUbjDB14C0a+PJc9OS199/oAcnJn/b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(30864003)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MvRi+X3eIqb7HYHPkOQkVYL6VyFkfQvCAYl/IM8GpXpG7NW68QFdklROgexW?=
 =?us-ascii?Q?dnG+fGj+53ovM29g7uu3TlFQO/AESWHMbfj52rzbDtqnnRuCQ9n3ncsBBXmM?=
 =?us-ascii?Q?Zz9yKsHb3VOxkuYmnmlTVWnvPJU3wSG6NbgyfRs7tcPit5Q1xC0SsTsP81In?=
 =?us-ascii?Q?oxNdEX9eH3g2xo8HpTv719zjtATcRUlmGB1iIbGcQSbg4ZVJQeh6YWAKIIMi?=
 =?us-ascii?Q?lmAlzuc9wNFaLVm3M+XLf7NkVISaK0enZB2T4yFhOeiD4uJ5Lip7Xa15iAc/?=
 =?us-ascii?Q?hValReuoSZSR++nwWOBumG3lItFVidd8Pv94Aah/LQ4Gc7h8kusMLEliT0sC?=
 =?us-ascii?Q?bo8C4oU92j8ypeofAjWBfBe4SCDIh30qaG8WdlZ3CT8SB5WWPPCjHR5rh1KT?=
 =?us-ascii?Q?Du7PnD59LyXHMad5tDzY3jZMvZuDL3ukpmN/+sqJGE6nBFm68torBIcwZIu+?=
 =?us-ascii?Q?5pp+TUuXZ2OBbR2ydhNXNB+YB1/2LQm0gSBr6SBonewQJJ15E+cYxz6KIYiN?=
 =?us-ascii?Q?yMpsEn+kbLSNTZ/G0TIkRh5ki6tEQ/MXegIHvBpNpeM0Fdn+uF/5IUyOAuIB?=
 =?us-ascii?Q?KgQi97QKaLt2I/bi7V3v8MhiTO/okeC5Lj+JpTTYSyCi6FVCfxeL6uJz1htC?=
 =?us-ascii?Q?5WxvR7frTEpDeUTr2AqHDwdJGGO6K5/TazuLqN6xBIe4bqau4q+s6BlqhrTp?=
 =?us-ascii?Q?JR9To/hgMbNnTHvcNQ1gx9xpl63zDedoSdSft24CQRqiOVUnfOMMCaXKpnMw?=
 =?us-ascii?Q?ge5tdwf8frdX+lN6RZ77vURxHA79Kl+6nWg5D5KMP+YIywABB+wY6wuivz+k?=
 =?us-ascii?Q?7IRGvAcE4HUeVtPsSq6u1mQzBxFvNXPEkS/rJqeRty7SRWw0CyJkLCrVnmuu?=
 =?us-ascii?Q?XD8qf9oYlulgpkOHIFAYO/Wv/v/KXUr1wipp/DTt9xaWtPqMrd9m+Tikq8xa?=
 =?us-ascii?Q?Bhmnr0i8YgmBkLt2SLfuUcAM+Ng0L98A25axBnVUaI25ZmQ0lADHY5Ui23TH?=
 =?us-ascii?Q?dWBX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47936ec3-cf38-4dfb-3807-08d89a430d3c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:05.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrRhobfpaa/spVRqqSsCN4lximKKA1/r9DFfsxLsCFxTLJqHnJGRgASHb4Eo5/YMoCCUvAmV0Amzb1RPtHzzew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This file looks bad in text editors.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/parisc/led.c | 128 +++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 36c6613f7a36..676a12bb94c9 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -47,10 +47,10 @@
 #include <asm/pdc.h>
 #include <linux/uaccess.h>
 
-/* The control of the LEDs and LCDs on PARISC-machines have to be done 
+/* The control of the LEDs and LCDs on PARISC-machines have to be done
    completely in software. The necessary calculations are done in a work queue
-   task which is scheduled regularly, and since the calculations may consume a 
-   relatively large amount of CPU time, some of the calculations can be 
+   task which is scheduled regularly, and since the calculations may consume a
+   relatively large amount of CPU time, some of the calculations can be
    turned off with the following variables (controlled via procfs) */
 
 static int led_type __read_mostly = -1;
@@ -80,7 +80,7 @@ struct lcd_block {
 };
 
 /* Structure returned by PDC_RETURN_CHASSIS_INFO */
-/* NOTE: we use unsigned long:16 two times, since the following member 
+/* NOTE: we use unsigned long:16 two times, since the following member
    lcd_cmd_reg_addr needs to be 64bit aligned on 64bit PA2.0-machines */
 struct pdc_chassis_lcd_info_ret_block {
 	unsigned long model:16;		/* DISPLAY_MODEL_XXXX */
@@ -103,7 +103,7 @@ struct pdc_chassis_lcd_info_ret_block {
 #define KITTYHAWK_LCD_CMD  F_EXTEND(0xf0190000UL) /* 64bit-ready */
 #define KITTYHAWK_LCD_DATA (KITTYHAWK_LCD_CMD+1)
 
-/* lcd_info is pre-initialized to the values needed to program KittyHawk LCD's 
+/* lcd_info is pre-initialized to the values needed to program KittyHawk LCD's
  * HP seems to have used Sharp/Hitachi HD44780 LCDs most of the time. */
 static struct pdc_chassis_lcd_info_ret_block
 lcd_info __attribute__((aligned(8))) __read_mostly =
@@ -119,16 +119,16 @@ lcd_info __attribute__((aligned(8))) __read_mostly =
 
 
 /* direct access to some of the lcd_info variables */
-#define LCD_CMD_REG	lcd_info.lcd_cmd_reg_addr	 
-#define LCD_DATA_REG	lcd_info.lcd_data_reg_addr	 
+#define LCD_CMD_REG	lcd_info.lcd_cmd_reg_addr
+#define LCD_DATA_REG	lcd_info.lcd_data_reg_addr
 #define LED_DATA_REG	lcd_info.lcd_cmd_reg_addr	/* LASI & ASP only */
 
 #define LED_HASLCD 1
 #define LED_NOLCD  0
 
 /* The workqueue must be created at init-time */
-static int start_task(void) 
-{	
+static int start_task(void)
+{
 	/* Display the default text now */
 	if (led_type == LED_HASLCD) lcd_print( lcd_text_default );
 
@@ -136,7 +136,7 @@ static int start_task(void)
 	if (lcd_no_led_support) return 0;
 
 	/* Create the work queue and queue the LED task */
-	led_wq = create_singlethread_workqueue("led_wq");	
+	led_wq = create_singlethread_workqueue("led_wq");
 	queue_delayed_work(led_wq, &led_task, 0);
 
 	return 0;
@@ -214,14 +214,14 @@ static ssize_t led_proc_write(struct file *file, const char __user *buf,
 	case LED_HASLCD:
 		if (*cur && cur[strlen(cur)-1] == '\n')
 			cur[strlen(cur)-1] = 0;
-		if (*cur == 0) 
+		if (*cur == 0)
 			cur = lcd_text_default;
 		lcd_print(cur);
 		break;
 	default:
 		return 0;
 	}
-	
+
 	return count;
 
 parse_error:
@@ -267,9 +267,9 @@ static int __init led_create_procfs(void)
 #endif
 
 /*
-   ** 
+   **
    ** led_ASP_driver()
-   ** 
+   **
  */
 #define	LED_DATA	0x01	/* data to shift (0:on 1:off) */
 #define	LED_STROBE	0x02	/* strobe to clock data */
@@ -289,9 +289,9 @@ static void led_ASP_driver(unsigned char leds)
 
 
 /*
-   ** 
+   **
    ** led_LASI_driver()
-   ** 
+   **
  */
 static void led_LASI_driver(unsigned char leds)
 {
@@ -301,16 +301,16 @@ static void led_LASI_driver(unsigned char leds)
 
 
 /*
-   ** 
+   **
    ** led_LCD_driver()
-   **   
+   **
  */
 static void led_LCD_driver(unsigned char leds)
 {
 	static int i;
 	static unsigned char mask[4] = { LED_HEARTBEAT, LED_DISK_IO,
 		LED_LAN_RCV, LED_LAN_TX };
-	
+
 	static struct lcd_block * blockp[4] = {
 		&lcd_info.heartbeat,
 		&lcd_info.disk_io,
@@ -320,15 +320,15 @@ static void led_LCD_driver(unsigned char leds)
 
 	/* Convert min_cmd_delay to milliseconds */
 	unsigned int msec_cmd_delay = 1 + (lcd_info.min_cmd_delay / 1000);
-	
-	for (i=0; i<4; ++i) 
+
+	for (i=0; i<4; ++i)
 	{
-		if ((leds & mask[i]) != (lastleds & mask[i])) 
+		if ((leds & mask[i]) != (lastleds & mask[i]))
 		{
 			gsc_writeb( blockp[i]->command, LCD_CMD_REG );
 			msleep(msec_cmd_delay);
-			
-			gsc_writeb( leds & mask[i] ? blockp[i]->on : 
+
+			gsc_writeb( leds & mask[i] ? blockp[i]->on :
 					blockp[i]->off, LCD_DATA_REG );
 			msleep(msec_cmd_delay);
 		}
@@ -337,15 +337,15 @@ static void led_LCD_driver(unsigned char leds)
 
 
 /*
-   ** 
+   **
    ** led_get_net_activity()
-   ** 
+   **
    ** calculate if there was TX- or RX-throughput on the network interfaces
    ** (analog to dev_get_info() from net/core/dev.c)
-   **   
+   **
  */
 static __inline__ int led_get_net_activity(void)
-{ 
+{
 #ifndef CONFIG_NET
 	return 0;
 #else
@@ -355,7 +355,7 @@ static __inline__ int led_get_net_activity(void)
 	int retval;
 
 	rx_total = tx_total = 0;
-	
+
 	/* we are running as a workqueue task, so we can use an RCU lookup */
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
@@ -390,14 +390,14 @@ static __inline__ int led_get_net_activity(void)
 
 
 /*
-   ** 
+   **
    ** led_get_diskio_activity()
-   ** 
+   **
    ** calculate if there was disk-io in the system
-   **   
+   **
  */
 static __inline__ int led_get_diskio_activity(void)
-{	
+{
 	static unsigned long last_pgpgin, last_pgpgout;
 	unsigned long events[NR_VM_EVENT_ITEMS];
 	int changed;
@@ -418,7 +418,7 @@ static __inline__ int led_get_diskio_activity(void)
 
 /*
    ** led_work_func()
-   ** 
+   **
    ** manages when and which chassis LCD/LED gets updated
 
     TODO:
@@ -453,9 +453,9 @@ static void led_work_func (struct work_struct *unused)
 		/* flash heartbeat-LED like a real heart
 		 * (2 x short then a long delay)
 		 */
-		if (count_HZ < HEARTBEAT_LEN || 
+		if (count_HZ < HEARTBEAT_LEN ||
 				(count_HZ >= HEARTBEAT_2ND_RANGE_START &&
-				count_HZ < HEARTBEAT_2ND_RANGE_END)) 
+				count_HZ < HEARTBEAT_2ND_RANGE_END))
 			currentleds |= LED_HEARTBEAT;
 	}
 
@@ -488,10 +488,10 @@ static void led_work_func (struct work_struct *unused)
 
 /*
    ** led_halt()
-   ** 
+   **
    ** called by the reboot notifier chain at shutdown and stops all
    ** LED/LCD activities.
-   ** 
+   **
  */
 
 static int led_halt(struct notifier_block *, unsigned long, void *);
@@ -501,7 +501,7 @@ static struct notifier_block led_notifier = {
 };
 static int notifier_disabled = 0;
 
-static int led_halt(struct notifier_block *nb, unsigned long event, void *buf) 
+static int led_halt(struct notifier_block *nb, unsigned long event, void *buf)
 {
 	char *txt;
 
@@ -518,45 +518,45 @@ static int led_halt(struct notifier_block *nb, unsigned long event, void *buf)
 				break;
 	default:		return NOTIFY_DONE;
 	}
-	
+
 	/* Cancel the work item and delete the queue */
 	if (led_wq) {
 		cancel_delayed_work_sync(&led_task);
 		destroy_workqueue(led_wq);
 		led_wq = NULL;
 	}
- 
+
 	if (lcd_info.model == DISPLAY_MODEL_LCD)
 		lcd_print(txt);
 	else
 		if (led_func_ptr)
 			led_func_ptr(0xff); /* turn all LEDs ON */
-	
+
 	return NOTIFY_OK;
 }
 
 /*
    ** register_led_driver()
-   ** 
+   **
    ** registers an external LED or LCD for usage by this driver.
    ** currently only LCD-, LASI- and ASP-style LCD/LED's are supported.
-   ** 
+   **
  */
 
 int __init register_led_driver(int model, unsigned long cmd_reg, unsigned long data_reg)
 {
 	static int initialized;
-	
+
 	if (initialized || !data_reg)
 		return 1;
-	
+
 	lcd_info.model = model;		/* store the values */
 	LCD_CMD_REG = (cmd_reg == LED_CMD_REG_NONE) ? 0 : cmd_reg;
 
 	switch (lcd_info.model) {
 	case DISPLAY_MODEL_LCD:
 		LCD_DATA_REG = data_reg;
-		printk(KERN_INFO "LCD display at %lx,%lx registered\n", 
+		printk(KERN_INFO "LCD display at %lx,%lx registered\n",
 			LCD_CMD_REG , LCD_DATA_REG);
 		led_func_ptr = led_LCD_driver;
 		led_type = LED_HASLCD;
@@ -575,7 +575,7 @@ int __init register_led_driver(int model, unsigned long cmd_reg, unsigned long d
 	case DISPLAY_MODEL_OLD_ASP:
 		LED_DATA_REG = data_reg;
 		led_func_ptr = led_ASP_driver;
-		printk(KERN_INFO "LED (ASP-style) display at %lx registered\n", 
+		printk(KERN_INFO "LED (ASP-style) display at %lx registered\n",
 		    LED_DATA_REG);
 		led_type = LED_NOLCD;
 		break;
@@ -585,8 +585,8 @@ int __init register_led_driver(int model, unsigned long cmd_reg, unsigned long d
 		       __func__, lcd_info.model);
 		return 1;
 	}
-	
-	/* mark the LCD/LED driver now as initialized and 
+
+	/* mark the LCD/LED driver now as initialized and
 	 * register to the reboot notifier chain */
 	initialized++;
 	register_reboot_notifier(&led_notifier);
@@ -601,11 +601,11 @@ int __init register_led_driver(int model, unsigned long cmd_reg, unsigned long d
 
 /*
    ** register_led_regions()
-   ** 
+   **
    ** register_led_regions() registers the LCD/LED regions for /procfs.
-   ** At bootup - where the initialisation of the LCD/LED normally happens - 
+   ** At bootup - where the initialisation of the LCD/LED normally happens -
    ** not all internal structures of request_region() are properly set up,
-   ** so that we delay the led-registration until after busdevices_init() 
+   ** so that we delay the led-registration until after busdevices_init()
    ** has been executed.
    **
  */
@@ -626,9 +626,9 @@ void __init register_led_regions(void)
 
 
 /*
-   ** 
+   **
    ** lcd_print()
-   ** 
+   **
    ** Displays the given string on the LCD-Display of newer machines.
    ** lcd_print() disables/enables the timer-based led work queue to
    ** avoid a race condition while writing the CMD/DATA register pair.
@@ -640,7 +640,7 @@ int lcd_print( const char *str )
 
 	if (!led_func_ptr || lcd_info.model != DISPLAY_MODEL_LCD)
 	    return 0;
-	
+
 	/* temporarily disable the led work task */
 	if (led_wq)
 		cancel_delayed_work_sync(&led_task);
@@ -660,7 +660,7 @@ int lcd_print( const char *str )
 		gsc_writeb(' ', LCD_DATA_REG);
 	    udelay(lcd_info.min_cmd_delay);
 	}
-	
+
 	/* re-queue the work */
 	if (led_wq) {
 		queue_delayed_work(led_wq, &led_task, 0);
@@ -671,8 +671,8 @@ int lcd_print( const char *str )
 
 /*
    ** led_init()
-   ** 
-   ** led_init() is called very early in the bootup-process from setup.c 
+   **
+   ** led_init() is called very early in the bootup-process from setup.c
    ** and asks the PDC for an usable chassis LCD or LED.
    ** If the PDC doesn't return any info, then the LED
    ** is detected by lasi.c or asp.c and registered with the
@@ -715,20 +715,20 @@ int __init led_init(void)
 			 (lcd_info.model==DISPLAY_MODEL_LCD) ? "LCD" :
 			  (lcd_info.model==DISPLAY_MODEL_LASI) ? "LED" : "unknown",
 			 lcd_info.lcd_width, lcd_info.min_cmd_delay,
-			 __FILE__, sizeof(lcd_info), 
+			 __FILE__, sizeof(lcd_info),
 			 chassis_info.actcnt, chassis_info.maxcnt));
 		DPRINTK((KERN_INFO "%s: cmd=%p, data=%p, reset1=%x, reset2=%x, act_enable=%d\n",
-			__FILE__, lcd_info.lcd_cmd_reg_addr, 
-			lcd_info.lcd_data_reg_addr, lcd_info.reset_cmd1,  
+			__FILE__, lcd_info.lcd_cmd_reg_addr,
+			lcd_info.lcd_data_reg_addr, lcd_info.reset_cmd1,
 			lcd_info.reset_cmd2, lcd_info.act_enable ));
-	
+
 		/* check the results. Some machines have a buggy PDC */
 		if (chassis_info.actcnt <= 0 || chassis_info.actcnt != chassis_info.maxcnt)
 			goto not_found;
 
 		switch (lcd_info.model) {
 		case DISPLAY_MODEL_LCD:		/* LCD display */
-			if (chassis_info.actcnt < 
+			if (chassis_info.actcnt <
 				offsetof(struct pdc_chassis_lcd_info_ret_block, _pad)-1)
 				goto not_found;
 			if (!lcd_info.act_enable) {
-- 
2.25.1

