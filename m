Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E768605663
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 06:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJTEiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 00:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJTEiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 00:38:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE4A16725D;
        Wed, 19 Oct 2022 21:38:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVYLCw9RqXa6I9K+NfMO9/VfobRM98qJemWxvl+g1IYqvC9hZsbZn9uYrN9H+IKrUqjNMitzd0ukC4UnUyDvmBbJUqo/FFnARoquB4IvImgfgFP2WjjAVjwlOMjuzhsuSsF0mnLdGaCmZUgN8dmXw4HcIOfMkygR2vBph3EoovT5IzOl77e8Be5SfYfsx6B0BdBI/WSGb9f5snfJbu4TKlTVp30BnQAdXD2troZ2epwE8G9nHKC5uBIe4fglTl8B552iaWXHWIng7lxzis5R7bM01zp1RkmR5J1gF+z1rwf3vzHHxBX6pcb/JEDafxxBjJupUeb0UAKEFiMZXS/egg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VA7/XL3UyHgWxrmbtqb6ZadJtrnlLngrMAkTfHQ+o68=;
 b=flQlVdQ1jpr/cJeyZRQudXdNeQ/l+ZeAelyyudl36bI1v34iPwlCD7lZLwE76OQbO8B4OWQk/j2zmYMzXtaaoBACCa01W4ILug4UQSM+1zjBd3YOIGwyY+T6p5v8ziMs2Y5595zGkHeSwEEbHXHXwVYc26crQTMluVQzfSB0ubPrDI8LPkhi9prKChq25ikTATJJtKob34tx4kE1vivOxhNbFjL20cofzvvpD3wYfafkb9cV0FvMZ+shWVVKjzTtST4lRpmYx7l0pgDJYG2ce2URbyKOMhqP52q76+wDRlJLOihWB9jDZCmbBTZSXrlIqihxnWfr8/RcdIh9StD2Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VA7/XL3UyHgWxrmbtqb6ZadJtrnlLngrMAkTfHQ+o68=;
 b=U4kNadBkV8jakmedB4g/Div4ZnTwgfP6iKPUcfV9O8odAsxamX7BwitB0f8FeP843PX45PqFSf5qLlxM6vMNJSFfgR5DvhABkgRYzCdoIKCE5GTB8SwDBstWcca20W0UEq45LxTdgJrMRZ9/FJyyYnWCq5lKdtsxCEjPmNvgoVE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS4PR04MB9363.eurprd04.prod.outlook.com (2603:10a6:20b:4e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 04:38:00 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::904:970c:dd08:fd47]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::904:970c:dd08:fd47%6]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 04:38:00 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frank.li@nxp.com, richardcochran@gmail.com
Subject: [PATCH net-next] net: fec: Add support for periodic output signal of PPS
Date:   Thu, 20 Oct 2022 12:35:56 +0800
Message-Id: <20221020043556.3859006-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0035.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::14) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AS4PR04MB9363:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d0c9bf-adc8-4e73-d849-08dab254de28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZF3ZqLweMtqz0jnXaDXqKfm0sQC5fHCgrZTPLFUAzD/7NX7ycPABUOPxflzygXNsz8jMBr7PSvsevmXTAPVT2jpP4bDuDt/ju5qeU7ixdTSrw6nPd5Vd54oWEbXuwT1jWqLaBNvETvtMauPoItZhvZ/4QKZLOkbY56G0+1DoJLYTAaxgfK+zg7ZmkucUY6v+8AHnt4C2LEYVA2trKaRdkQWkIey1vaajaVkxlcBEM5VsBK6QvVwBs84RkOHVrgwsp0fwYz6taTgQChL3mQpPZQYQCDBIaa81DeMEKXblUnUoDK538OvNR5rJS0KLue2sndLM5dl980rZPZAPDrz9pyc67ULOQFviIQ2IPQDzQXVQZTy4vKaXO/cokPsKZFH/UzblxvhDlpRiLr8/zs06Ww89DnSdhlKXsSgNDmrLrKeyZBA5WMBfne58mcsHjJkDDWTwuTozuymDrRw61k+QSFblAd67mBPqdicZwi1hTzvtaQje8NPIAmWqvWZzWV2NhoijdGTKmzYhMAZONHVNHS7MdgVraVOvZYxWCclG1dsJR3FOpWRClvqnYmSTQapH3zNwV2YkhzOsiKQvEwlNfE6RiUFCPDR6wPDx7tmXImAKXe8e9cOT/XAGTRZ8QVVzrf9D9WgzZaHGN7tY/gzbLtT0kyOS44DqR2idDOaIBSqC9DgofTrtaArK93XQAvxd8fLQ5pMNbTRElnPYXUR3hnqzqurL//u45aB4WJLvClVqBHud3WTtGTIfhv7YWbIdAcbEsQlOeWghkamPaOk3IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199015)(478600001)(316002)(6486002)(6666004)(38350700002)(5660300002)(38100700002)(4326008)(8676002)(66476007)(66556008)(66946007)(86362001)(83380400001)(26005)(6512007)(9686003)(41300700001)(2616005)(1076003)(186003)(8936002)(36756003)(2906002)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meVsmQ9vfZAzAlYs9cJ8QafKXeuHmQIun1cSGOmJr7vn3K5RefxwkBE8fi0k?=
 =?us-ascii?Q?r4WyydR6EyT8Ky79Z9VftdLoUyDGy5Ku4ZGn+81rnpF4+yNWVepKBij1pfsF?=
 =?us-ascii?Q?6dcJvxqMZmTZ5mIPie1dI05Vf45O6DC45Lg4livSmrOQNewoDcRejpmz+D0v?=
 =?us-ascii?Q?a5GGPWAflil7O3c5cBFWT4CgjkoEKRqCyyn7odo62MFLR/s9Hbyk88qzd1xQ?=
 =?us-ascii?Q?nXrBuBqY8OIcHFz1HVKJtw2S6ojSPcl6OAm11m7kkJmVN/KQinZXRZKOdnu+?=
 =?us-ascii?Q?toLCsuxU8cQ6Uc+IUNQBqak/voGHXuKnf7RhAd8jU2ndrEOhbeid6zkerqya?=
 =?us-ascii?Q?HLhaKyImx+eOLfon3n44nyY2HcakQ4++u/suJPOmBRK/f5wohAN0UqNEsT81?=
 =?us-ascii?Q?cNyl8/wonf1AV1QmWYWnUvV7jeWPU9XXV2Cu4MquMIyp1vm1yGo/tvom1p8A?=
 =?us-ascii?Q?s5T6r3IuEWUJg0uMUcrtSqPi4dea6viSj0M2PiwS5t4Nw+qRWyJjavWJkirS?=
 =?us-ascii?Q?Oq9WF6wPmPGCR3mF+oaZMWbWs9wqCRDOLkjVa+AVVcApWrxe0JEZOlIvYqwk?=
 =?us-ascii?Q?Zhe8mGcxbGE1f5y6uf/K7od6QS1+IKvH/fs+mX9nV1cq30oTnfxLaw9Lxxrn?=
 =?us-ascii?Q?6E0KfGdFuQ0RIUQgMUQ/kxFEZQaflRyHkYRvgL1OL2ToYHtqyPFtQiNvDWz1?=
 =?us-ascii?Q?frPaOWLkegxdHwk9DD+gMHBbfsWC8da7ew6DbdUpRI2xm16Hxq1hdkvG41gq?=
 =?us-ascii?Q?upakhnU+IRuh7f93skxQ3v226Elnw0LSZxShZLvyWnINvVQXpXz9hrVm1yPl?=
 =?us-ascii?Q?fh96D3suvSWkpIutnE6N17FlH9aDSfsTiBT+BHZwR7DsyYvzIufqSZEzFN7c?=
 =?us-ascii?Q?Uou7BycYsydWLLxU1hpFOTSn2baQserRuwRpjtXtqVQka60LxcCIANVjI+nW?=
 =?us-ascii?Q?wlIuHHwZH9mOJJ0HWBFzm708xceL5ZNgsrsVozqDvJHmQLuz2h/fRMNvzgvU?=
 =?us-ascii?Q?1XsP4qXUDk7d1HwTZl+bwFU4evb1sVFObnu3jR63d02EGjdWNpkr7nUIyCn1?=
 =?us-ascii?Q?mX9brKylT0AxGK7eBRC05ANa+OlGWwHM74FD65n3nHFKHn1WR9cSuVgvDUvM?=
 =?us-ascii?Q?7YEyKdkuE60oLXKexX1RhIyVI7Y2zpKZpPOLAARi3zp56mXZaRkW03CNGpsE?=
 =?us-ascii?Q?uk91nivAaHYzbEqmIg69BVWXw9yBUw/elX+REiPDXwuUCKvO547Ef4Jp5/Ny?=
 =?us-ascii?Q?RNzMV5c3IKrzqQ2iHADYb8sq/993Z5BzYfPy3iLcjSKZb9NcYQeJADt1rHGq?=
 =?us-ascii?Q?fk2iwIMpkWc5bRI83uvEG57RwbfB8oTpyGiMgdWC26aUxGDvwB7MNgsJ9e8C?=
 =?us-ascii?Q?/8G0M6jWScA7aOEABW5KHriPLL0HjAh+i+nm2yupVF4b6NyQZWJic0IvgeOS?=
 =?us-ascii?Q?ptfZxegEY6zkSQRgaubSl6KaOOOgGgw4xeh5SDkyDs4ZML7jIgwCRXi/3T/s?=
 =?us-ascii?Q?iZFty43OpH2DM/sBtTR7Noh/0MiKxI3Jp1I53DHYb6VOEMY9aj9LlJ592G0w?=
 =?us-ascii?Q?MqvFpUGkMrlCCs6CAZZ/75s1rX28ScLIHRn1Bvc8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d0c9bf-adc8-4e73-d849-08dab254de28
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 04:38:00.4172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VpirrFGTEjtD+sCwoulGUvK66QaoIeljwHtgCA6CM35LQDqRf11823ASTtRynlKj/IAynn8d1CiCmM+lfWeJmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9363
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

This patch adds the support for configuring periodic output
signal of PPS. So the PPS can be output at a specified time
and period.
For developers or testers, they can use the command "echo
<channel> <start.sec> <start.nsec> <period.sec> <period.
nsec> > /sys/class/ptp/ptp0/period" to specify time and
period to output PPS signal.
Notice that, the channel can only be set to 0. In addtion,
the start time must larger than the current PTP clock time.
So users can use the command "phc_ctl /dev/ptp0 -- get" to
get the current PTP clock time before.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h     |   2 +
 drivers/net/ethernet/freescale/fec_ptp.c | 164 ++++++++++++++++++++++-
 2 files changed, 164 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 33f84a30e167..476e3863a310 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -658,6 +658,8 @@ struct fec_enet_private {
 	unsigned int reload_period;
 	int pps_enable;
 	unsigned int next_counter;
+	struct hrtimer perout_timer;
+	u64 perout_stime;
 
 	struct imx_sc_ipc *ipc_handle;
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index cffd9ad499dd..67aa694a62ec 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -88,6 +88,9 @@
 #define FEC_CHANNLE_0		0
 #define DEFAULT_PPS_CHANNEL	FEC_CHANNLE_0
 
+#define FEC_PTP_MAX_NSEC_PERIOD		4000000000ULL
+#define FEC_PTP_MAX_NSEC_COUNTER	0x80000000ULL
+
 /**
  * fec_ptp_enable_pps
  * @fep: the fec_enet_private structure handle
@@ -198,6 +201,78 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	return 0;
 }
 
+static int fec_ptp_pps_perout(struct fec_enet_private *fep)
+{
+	u32 compare_val, ptp_hc, temp_val;
+	u64 curr_time;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
+
+	/* Update time counter */
+	timecounter_read(&fep->tc);
+
+	/* Get the current ptp hardware time counter */
+	temp_val = readl(fep->hwp + FEC_ATIME_CTRL);
+	temp_val |= FEC_T_CTRL_CAPTURE;
+	writel(temp_val, fep->hwp + FEC_ATIME_CTRL);
+	if (fep->quirks & FEC_QUIRK_BUG_CAPTURE)
+		udelay(1);
+
+	ptp_hc = readl(fep->hwp + FEC_ATIME);
+
+	/* Convert the ptp local counter to 1588 timestamp */
+	curr_time = timecounter_cyc2time(&fep->tc, ptp_hc);
+
+	/* If the pps start time less than current time add 100ms, just return.
+	 * Because the software might not able to set the comparison time into
+	 * the FEC_TCCR register in time and missed the start time.
+	 */
+	if (fep->perout_stime < curr_time + 100 * NSEC_PER_MSEC) {
+		dev_err(&fep->pdev->dev, "Current time is too close to the start time!\n");
+		spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+		return -1;
+	}
+
+	compare_val = fep->perout_stime - curr_time + ptp_hc;
+	compare_val &= fep->cc.mask;
+
+	writel(compare_val, fep->hwp + FEC_TCCR(fep->pps_channel));
+	fep->next_counter = (compare_val + fep->reload_period) & fep->cc.mask;
+
+	/* Enable compare event when overflow */
+	temp_val = readl(fep->hwp + FEC_ATIME_CTRL);
+	temp_val |= FEC_T_CTRL_PINPER;
+	writel(temp_val, fep->hwp + FEC_ATIME_CTRL);
+
+	/* Compare channel setting. */
+	temp_val = readl(fep->hwp + FEC_TCSR(fep->pps_channel));
+	temp_val |= (1 << FEC_T_TF_OFFSET | 1 << FEC_T_TIE_OFFSET);
+	temp_val &= ~(1 << FEC_T_TDRE_OFFSET);
+	temp_val &= ~(FEC_T_TMODE_MASK);
+	temp_val |= (FEC_TMODE_TOGGLE << FEC_T_TMODE_OFFSET);
+	writel(temp_val, fep->hwp + FEC_TCSR(fep->pps_channel));
+
+	/* Write the second compare event timestamp and calculate
+	 * the third timestamp. Refer the TCCR register detail in the spec.
+	 */
+	writel(fep->next_counter, fep->hwp + FEC_TCCR(fep->pps_channel));
+	fep->next_counter = (fep->next_counter + fep->reload_period) & fep->cc.mask;
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+
+	return 0;
+}
+
+static enum hrtimer_restart fec_ptp_pps_perout_handler(struct hrtimer *timer)
+{
+	struct fec_enet_private *fep = container_of(timer,
+					struct fec_enet_private, perout_timer);
+
+	fec_ptp_pps_perout(fep);
+
+	return HRTIMER_NORESTART;
+}
+
 /**
  * fec_ptp_read - read raw cycle counter (to be used by time counter)
  * @cc: the cyclecounter structure
@@ -425,6 +500,17 @@ static int fec_ptp_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int fec_ptp_pps_disable(struct fec_enet_private *fep, uint channel)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
+	writel(0, fep->hwp + FEC_TCSR(channel));
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+
+	return 0;
+}
+
 /**
  * fec_ptp_enable
  * @ptp: the ptp clock structure
@@ -437,14 +523,84 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 {
 	struct fec_enet_private *fep =
 	    container_of(ptp, struct fec_enet_private, ptp_caps);
+	ktime_t timeout;
+	struct timespec64 start_time, period;
+	u64 curr_time, delta, period_ns;
+	unsigned long flags;
 	int ret = 0;
 
 	if (rq->type == PTP_CLK_REQ_PPS) {
 		ret = fec_ptp_enable_pps(fep, on);
 
 		return ret;
+	} else if (rq->type == PTP_CLK_REQ_PEROUT) {
+		/* Reject requests with unsupported flags */
+		if (rq->perout.flags)
+			return -EOPNOTSUPP;
+
+		if (rq->perout.index != DEFAULT_PPS_CHANNEL)
+			return -EOPNOTSUPP;
+
+		fep->pps_channel = DEFAULT_PPS_CHANNEL;
+		period.tv_sec = rq->perout.period.sec;
+		period.tv_nsec = rq->perout.period.nsec;
+		period_ns = timespec64_to_ns(&period);
+
+		/* FEC PTP timer only has 31 bits, so if the period exceed
+		 * 4s is not supported.
+		 */
+		if (period_ns > FEC_PTP_MAX_NSEC_PERIOD) {
+			dev_err(&fep->pdev->dev, "The period must equal to or less than 4s!\n");
+			return -EOPNOTSUPP;
+		}
+
+		fep->reload_period = div_u64(period_ns, 2);
+		if (on && fep->reload_period) {
+			/* Convert 1588 timestamp to ns*/
+			start_time.tv_sec = rq->perout.start.sec;
+			start_time.tv_nsec = rq->perout.start.nsec;
+			fep->perout_stime = timespec64_to_ns(&start_time);
+
+			mutex_lock(&fep->ptp_clk_mutex);
+			if (!fep->ptp_clk_on) {
+				dev_err(&fep->pdev->dev, "Error: PTP clock is closed!\n");
+				mutex_unlock(&fep->ptp_clk_mutex);
+				return -EOPNOTSUPP;
+			}
+			spin_lock_irqsave(&fep->tmreg_lock, flags);
+			/* Read current timestamp */
+			curr_time = timecounter_read(&fep->tc);
+			spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+			mutex_unlock(&fep->ptp_clk_mutex);
+
+			/* Calculate time difference */
+			delta = fep->perout_stime - curr_time;
+
+			if (fep->perout_stime <= curr_time) {
+				dev_err(&fep->pdev->dev, "Start time must larger than current time!\n");
+				return -EINVAL;
+			}
+
+			/* Because the timer counter of FEC only has 31-bits, correspondingly,
+			 * the time comparison register FEC_TCCR also only low 31 bits can be
+			 * set. If the start time of pps signal exceeds current time more than
+			 * 0x80000000 ns, a software timer is used and the timer expires about
+			 * 1 second before the start time to be able to set FEC_TCCR.
+			 */
+			if (delta > FEC_PTP_MAX_NSEC_COUNTER) {
+				timeout = ns_to_ktime(delta - NSEC_PER_SEC);
+				hrtimer_start(&fep->perout_timer, timeout, HRTIMER_MODE_REL);
+			} else {
+				return fec_ptp_pps_perout(fep);
+			}
+		} else {
+			fec_ptp_pps_disable(fep, fep->pps_channel);
+		}
+
+		return 0;
+	} else {
+		return -EOPNOTSUPP;
 	}
-	return -EOPNOTSUPP;
 }
 
 /**
@@ -583,7 +739,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_caps.max_adj = 250000000;
 	fep->ptp_caps.n_alarm = 0;
 	fep->ptp_caps.n_ext_ts = 0;
-	fep->ptp_caps.n_per_out = 0;
+	fep->ptp_caps.n_per_out = 1;
 	fep->ptp_caps.n_pins = 0;
 	fep->ptp_caps.pps = 1;
 	fep->ptp_caps.adjfreq = fec_ptp_adjfreq;
@@ -605,6 +761,9 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
 
+	hrtimer_init(&fep->perout_timer, CLOCK_REALTIME, HRTIMER_MODE_REL);
+	fep->perout_timer.function = fec_ptp_pps_perout_handler;
+
 	irq = platform_get_irq_byname_optional(pdev, "pps");
 	if (irq < 0)
 		irq = platform_get_irq_optional(pdev, irq_idx);
@@ -634,6 +793,7 @@ void fec_ptp_stop(struct platform_device *pdev)
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
 	cancel_delayed_work_sync(&fep->time_keep);
+	hrtimer_cancel(&fep->perout_timer);
 	if (fep->ptp_clock)
 		ptp_clock_unregister(fep->ptp_clock);
 }
-- 
2.25.1

