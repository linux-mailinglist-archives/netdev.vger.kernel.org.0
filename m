Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F382D4A9AC8
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 15:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359229AbiBDOQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 09:16:13 -0500
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:29280
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240322AbiBDOQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 09:16:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEvVfJQ2GuHmcK9MPPuO6ScaDdspaCiXOcPkPYS/o7xEEzsTnPL08MVkHfO3YBPssilaT8gnL2qDgOsJP69cv7iG6I/mB9+EpBHnoH7i2vuaxELZC9+HraahS/kqHUDG5TCCBZh5IBx43m1xMtj+KbfGXVNcVbhYcX9EZk72ESXoa9ySCYj+reR2jiOZmUGIun/qZf8/84Mu0Hl9H06ss4YtVy21qznJA1XRaGs0iBkvV3utrmDnwPpwXpVJLGwVeQQtlvoZ7pDCR6YTspP/nc73Vafg9BtzNcx9BMdQTMHzwzzFTm4AlOra+ro85+eVvqiZiYokvZmkvf/yFxhDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Nust8N8Vy+FPsFmGIOO+htPZStHTRwXzCdNJdSzZik=;
 b=iWJhz6+pZojjoFNW0vqpTiAuW8NApMFBYxLLTSXiwibEKhLFIpChkXil595LGv+Lv77gSSaY8U94RhvNxOT1gHKgNvUyIzSPf2VEIqyuTFIA5u7OxK1+JEjvGqgC9NJ4pgCq4ZKZ7X9MEs6KR3Y1AYIbaosr3M/02eVYOPaeTZQuC4TqjgV2YtCLdSlFi2iM4ISh25vsBh1pvN86u2cHNt9vYpuPlUdrOjmp9Gl5Ti91Oab50H36uxnDV1kQ2IsVFYrfLHyBlYv/S7r6lD/bX3dvNkzxqDeauF/CRppa8ZEEGYc/XRFkiZlOrLCWld7qm7Ow7JzEtEKxeP2GXCxqmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Nust8N8Vy+FPsFmGIOO+htPZStHTRwXzCdNJdSzZik=;
 b=SFQ9zZj2zAhdWRHIjgjM+FsPfUPZ4hJVXsZn0Tt2eBPOKqAGKtY9P/HDSg4o3+XBUAirQhuw+G500AN8goKDU5T8DGghWg62LdgBeUdo0aggkRGKiIc5pgG4l5ogsEfkNBf4NFmkx+pgOLPKY6YkJ3XHK1ozmtXka4dTVKCE2WQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by HE1PR0402MB2843.eurprd04.prod.outlook.com (2603:10a6:3:dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Fri, 4 Feb
 2022 14:16:08 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4951.012; Fri, 4 Feb 2022
 14:16:08 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net-next] net: stmmac: optimize locking around PTP clock reads
Date:   Fri,  4 Feb 2022 14:55:44 +0100
Message-Id: <20220204135545.2770625-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0114.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::31) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a701111-a02f-4e57-d442-08d9e7e8e368
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2843:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <HE1PR0402MB28433C13FCCCA4CF18697C53D2299@HE1PR0402MB2843.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8WfG4wH0ZdkhO+L0heYw7aJMU4ptEsp4+iTKvcXilTeVNaZcdbRzBg61Uu4xpRkCzmQEOp9Ag8iyMstj0f8E0xinYVXP/BGPDQydWMACwzqzB8tne/1PJKWRKP/sMnUG2Oh8zp5qYleal876YaNQW4w+U7SkY2IaPX+wuj4lnWnmyx0bnMO8tvuf31Qe7rtBpk5bzO4NDwcx01OBD6CxvKQx4FepAXe54Y08GavvymQ6CilUHQO052nJkAG6+KcdOmQidMs/xkQHIxsKXddrlfHaTWdlDvPVlNy2L4MGD49R4tXpaglXTnrms7rMZScX7yjs4QmbYv5ft0UkfaB6RumuUyS6Y4uZspjPV0vmZJrmjDhlxsrUF7LiqSENiC5yQ9rrBjwib3mHn2ywHHLUQEBnhA4z4ZmFkieIGkMUVHfR6LQjM/9Q8Kfqgx5+BLgLDZcNOHMpJaSRjw/cZ1i4zFaSQSgeMXXWJXBCHSGirniHgagsbDwnPofHgZf/cyYjNkKURO7U/bAUsvuCSqQdKNheE6E3N3aF6SDv04Iz/0o2MtEH6LwrhjsAy50FF/lOzLq7z7EE9VEQjYUwYh3M9qPnvD863iuZ62Ztty4ZiokQopIa2q/jqPopsZ0PvMotXMJTzkBl1Ta5WFvs9QMpNk0wI2ghvXY3eQLF3YaioRTpoSG8EMRofcJM1CYd9OhGi16FRQoerOt6xuKs5BRelzTgnbiMirNg52Hy+fXo9bs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6486002)(5660300002)(6512007)(44832011)(6666004)(52116002)(1076003)(186003)(26005)(2906002)(508600001)(2616005)(6506007)(38350700002)(921005)(86362001)(38100700002)(316002)(110136005)(66556008)(66946007)(66476007)(8936002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x4PRlYrZR1rCZM1CecVWIff6mQ2KtRRBUPtLUmi8SIA9naE7/8GYx0cQVxmZ?=
 =?us-ascii?Q?2VKkGfSyN/uzxvZYXTKFRDbEMS7JbMKGTWoD90F1pRfFCVk1rPisZjV9f8J2?=
 =?us-ascii?Q?MXPzc4Kss0WPDUMlGfD5/bm93uHNcwtcKk5aEdIlyLpzWtugH7qz4tRZ9kF2?=
 =?us-ascii?Q?ObnLVfQI+aCerLPEptECK9Q8xuFGnz+VBLwOKnW7f5z4jadIu/j4Ig3tGUee?=
 =?us-ascii?Q?w2NXEg7AIGG8Bc3NJK42WrI1TtKOf0zS96Db+PIBGD8nfmunT+zoHhhyAo8h?=
 =?us-ascii?Q?29cEn8upbxHbyn8nxYQv2CMufhtugHQqmlXQ35Tw+cCXeYzd6fktPI40OJaF?=
 =?us-ascii?Q?IYsLkGW6y9eViYCH/hbljaNDpUho8iSH17/WVpe36Y2lWVQQGONEV8CxQGHu?=
 =?us-ascii?Q?+cWKyk7QyEvyJm3cMo4SAvGd94V5KhqJs2B8xsvAx481hBhW8sjv7gqVoDbT?=
 =?us-ascii?Q?jyA7UyRK19slhFoJLzr/rPkTdF5azi7z2o1xfnj2j9wju2qjO43K8EVCS+4J?=
 =?us-ascii?Q?zcl2bKCZOdnLenaSY7hzVtmKIFfnnVkv4/Qh99JdDykcC+2TNf7VQzovdBCO?=
 =?us-ascii?Q?VOZQIgvSyPLPn5gl2ZsDWtfx9a4fnRTBxA71V6SmHHRklpCllOvD8lppa2QL?=
 =?us-ascii?Q?Hh9xR+GrennbdcAZF7ay+W2x3c9qBnXaBxty1VEJ5GgLVZJUFwavVa4Ose/u?=
 =?us-ascii?Q?wvWP7SCIu0g1psAO9N8quqqNINWwMoEDm5iRRMu8vXjE4sDxQiku2YE3hCeX?=
 =?us-ascii?Q?BFW16+wtQX7rJVTqmcnWAeFngvn3HQV32Rb1ltFMoeG6N7S5itiKqU6bWYvV?=
 =?us-ascii?Q?8HBlpdaitWe5dnZgJSONFPb7GkJrTltW4azjSoqPSZ4OVxCUagGv4Ue6cAE6?=
 =?us-ascii?Q?VEoDJiUprIdkgl+mGo/9KmJ6+aZHs7fPp7JUljgb/Weq1GUwmJBXgGLGXmhJ?=
 =?us-ascii?Q?g78hV+yOOZ0ldXrBaaRN59QpmaheZZxDyGpgAbe5FSUTKhS24H9GYZyMkqff?=
 =?us-ascii?Q?+rbNeQJcV0DLXxDVqIxFBtEt43kJi0GcRKmSkV4RLkYsf5teYqB+du3oG+nC?=
 =?us-ascii?Q?LGBt5BgMPERTtwF/vcM5C7MHJwIM05t5FRaBev7DopMNqvdMiI2ATQuWGsc+?=
 =?us-ascii?Q?fMqE0MFjW/cHMI222H5irP5SkzvXIhxAY6Bx7NWAgGqR0gUAiiLnZNy3F1fW?=
 =?us-ascii?Q?vvavjEiAnn9r7xaBFu1m54fDAQu+U24SiucZS23AHtswxrp4sAnyJ2OjJZ7x?=
 =?us-ascii?Q?5rs/FTk92uKj+zkGPdT6fV7H8K0zdbD4fa5SCVJl1u0tkfAKxzrHNkRUEt7x?=
 =?us-ascii?Q?6kgDwBazdc43IqE8kBEfqJDp7AMT233T9cAm7vtvFjUjuD0juuTpMk7I8iDo?=
 =?us-ascii?Q?5+QYqFBjGgGsdnuxjp7qmqZyU7spfpB782j9Oim8XBlfl1u2+hmebFYfyY+W?=
 =?us-ascii?Q?B7TR3g8BGGOeCg8YC+0l55WM/fWr3aEtmZRbqMjrCbZbsB6wgPQhQ3sM5tX8?=
 =?us-ascii?Q?U/UQwxMjTfAVA4HVDND9aG1maS3jdrU5Q3FArvijvr3WC7VDf1t1taZUHthr?=
 =?us-ascii?Q?taqVASvOT5JMEtPiF9bbdtei9KAsvAEOstNLT+nVPPvTW7KgJ6yx5QtjEt3X?=
 =?us-ascii?Q?Jvulc2RjYZVVe8u5Y2GXhTs=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a701111-a02f-4e57-d442-08d9e7e8e368
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 14:16:08.6955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ItuU3O/qbC32J4BYxeZ04nxEZK5F5DYUNu1xQGHmngzqSTWt+R0nl/Vspgu1A/+ArzjfESW+sYkS/KvufmDxNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2843
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Reading the PTP clock is a simple operation requiring only 3 register
reads. Under a PREEMPT_RT kernel, protecting those reads by a spin_lock is
counter-productive: if the 2nd task preempting the 1st has a higher prio
but needs to read time as well, it will require 2 context switches, which
will pretty much always be more costly than just disabling preemption for
the duration of the reads. Moreover, with the code logic recently added
to get_systime(), disabling preemption is not even required anymore:
reads and writes just need to be protected from each other, to prevent a
clock read while the clock is being updated.

Improve the above situation by replacing the PTP spinlock by a rwlock, and
using read_lock for PTP clock reads so simultaneous reads do not block
each other.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  4 ++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 +-
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c |  4 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 22 +++++++++----------
 .../stmicro/stmmac/stmmac_selftests.c         |  8 +++----
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 8e8778cfbbad..5943ff9f21c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -383,10 +383,10 @@ static int intel_crosststamp(ktime_t *device,
 
 	/* Repeat until the timestamps are from the FIFO last segment */
 	for (i = 0; i < num_snapshot; i++) {
-		spin_lock_irqsave(&priv->ptp_lock, flags);
+		read_lock_irqsave(&priv->ptp_lock, flags);
 		stmmac_get_ptptime(priv, ptpaddr, &ptp_time);
 		*device = ns_to_ktime(ptp_time);
-		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		read_unlock_irqrestore(&priv->ptp_lock, flags);
 		get_arttime(priv->mii, intel_priv->mdio_adhoc_addr, &art_time);
 		*system = convert_art_to_tsc(art_time);
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 5b195d5051d6..57970ae2178d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -263,7 +263,7 @@ struct stmmac_priv {
 	u32 adv_ts;
 	int use_riwt;
 	int irq_wake;
-	spinlock_t ptp_lock;
+	rwlock_t ptp_lock;
 	/* Protects auxiliary snapshot registers from concurrent access. */
 	struct mutex aux_ts_lock;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index a7ec9f4d46ce..22fea0f67245 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -196,9 +196,9 @@ static void timestamp_interrupt(struct stmmac_priv *priv)
 		       GMAC_TIMESTAMP_ATSNS_SHIFT;
 
 	for (i = 0; i < num_snapshot; i++) {
-		spin_lock_irqsave(&priv->ptp_lock, flags);
+		read_lock_irqsave(&priv->ptp_lock, flags);
 		get_ptptime(priv->ptpaddr, &ptp_time);
-		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		read_unlock_irqrestore(&priv->ptp_lock, flags);
 		event.type = PTP_CLOCK_EXTTS;
 		event.index = 0;
 		event.timestamp = ptp_time;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 1c9f02f9c317..e45fb191d8e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -39,9 +39,9 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
 	diff = div_u64(adj, 1000000000ULL);
 	addend = neg_adj ? (addend - diff) : (addend + diff);
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_config_addend(priv, priv->ptpaddr, addend);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	return 0;
 }
@@ -86,9 +86,9 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 		mutex_unlock(&priv->plat->est->lock);
 	}
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_adjust_systime(priv, priv->ptpaddr, sec, nsec, neg_adj, xmac);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	/* Caculate new basetime and re-configured EST after PTP time adjust. */
 	if (est_rst) {
@@ -137,9 +137,9 @@ static int stmmac_get_time(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	unsigned long flags;
 	u64 ns = 0;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	read_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &ns);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	read_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -162,9 +162,9 @@ static int stmmac_set_time(struct ptp_clock_info *ptp,
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_init_systime(priv, priv->ptpaddr, ts->tv_sec, ts->tv_nsec);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	return 0;
 }
@@ -194,12 +194,12 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 		cfg->period.tv_sec = rq->perout.period.sec;
 		cfg->period.tv_nsec = rq->perout.period.nsec;
 
-		spin_lock_irqsave(&priv->ptp_lock, flags);
+		write_lock_irqsave(&priv->ptp_lock, flags);
 		ret = stmmac_flex_pps_config(priv, priv->ioaddr,
 					     rq->perout.index, cfg, on,
 					     priv->sub_second_inc,
 					     priv->systime_flags);
-		spin_unlock_irqrestore(&priv->ptp_lock, flags);
+		write_unlock_irqrestore(&priv->ptp_lock, flags);
 		break;
 	case PTP_CLK_REQ_EXTTS:
 		priv->plat->ext_snapshot_en = on;
@@ -314,7 +314,7 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
-	spin_lock_init(&priv->ptp_lock);
+	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index be3cb63675a5..9f1759593b94 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1777,9 +1777,9 @@ static int stmmac_test_tbs(struct stmmac_priv *priv)
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	read_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &curr_time);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	read_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	if (!curr_time) {
 		ret = -EOPNOTSUPP;
@@ -1799,9 +1799,9 @@ static int stmmac_test_tbs(struct stmmac_priv *priv)
 		goto fail_disable;
 
 	/* Check if expected time has elapsed */
-	spin_lock_irqsave(&priv->ptp_lock, flags);
+	read_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_get_systime(priv, priv->ptpaddr, &curr_time);
-	spin_unlock_irqrestore(&priv->ptp_lock, flags);
+	read_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	if ((curr_time - start_time) < STMMAC_TBS_LT_OFFSET)
 		ret = -EINVAL;
-- 
2.25.1

