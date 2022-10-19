Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEB4603915
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 07:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJSFKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 01:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJSFKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 01:10:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60059.outbound.protection.outlook.com [40.107.6.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0A561DBC;
        Tue, 18 Oct 2022 22:10:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAqBBA1ST0qXgXT2Lj6NYgNtN5iQN9ZVpVDJj+hGhhGaye6VaJNEemngQl1pvKt/Up+1XJicaZSmqTbrPI2YNPYSKbjzza3CGfvAuKRJpqa30yVpWC4XP9rx3+UP+2hlve+0fmyPlzQmRDnhx0UnOmNqSBvvLUPP1SbXGtzvVsseNpGlRpnL76sHTxfTX89270QMjJj6FyVri5hGP+JHmJaBN6kQ/bp3brSN03UeagjcUSpwtJTfFMHKEcMu0i+ah/0AlQgwi0ma7bgPUoF0Bw8sAYz/LA+jTlaREwVOUcQtHG5kHr7CWx7s+S4MnjeIPElVgZJEoKbvUZMUhZqpog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VA7/XL3UyHgWxrmbtqb6ZadJtrnlLngrMAkTfHQ+o68=;
 b=iHfawi7qhfgZkUmZYGxvsomU9DtxfhbCj6kxIVObfkHyddFrPZ0CNskatpaTqS4ZZYzuSbX92auOL5Zbsd1NBaY4k/6xnW9Ap9Cu1uZWZowMnnzt+4CZf9odjOXI/J/NTQEpTo8qfXPSTmlKyhO2z6+5yA+67KTMJ96mIJ6TU10HoL64Xar5Wass6VUdHsFjkEj+BxbnsYDQqMA//b8T4pamNlPKYt/8bIh/mx9HKY0rFsWpMhur7JLe8X6eMkkmbRn/zlakNu1r+c89HI3NggKTmo3iofQA3IjxIHJfudqmBslh4TprU1xv6PzHaYEqyi38LDG8x1+kwMfiOP4bVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VA7/XL3UyHgWxrmbtqb6ZadJtrnlLngrMAkTfHQ+o68=;
 b=RH4SxnsDnD4ocnIix3fB7l/vru6mLR9W7XCZtEOppjVCyxEXg9/fKGcTZmYKnojNw4RX4IlHqJel+9TdZ4slmaXQjiFh6dSTbR8ibPyG2nex+emBeWQSZQUxl5vk4O9OBIrbLu6xg4JnWiVc2P7vH2nD/I4o/z4DCpsq+8o8PHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB7135.eurprd04.prod.outlook.com (2603:10a6:800:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 05:10:11 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::904:970c:dd08:fd47]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::904:970c:dd08:fd47%6]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 05:10:11 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frank.li@nxp.com
Subject: [PATCH net-next] net: fec: Add support for periodic output signal of PPS
Date:   Wed, 19 Oct 2022 13:08:08 +0800
Message-Id: <20221019050808.3840206-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|VI1PR04MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 21def135-8f38-4936-e19b-08dab1903304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wo5Y8EP2mLK/Etd78uM1FL96MoW/RAGGsCOgheoAOOjE/ZmJVT0AGXuns2FOax5d9a+/7j1J5v+rH6b8H9IeO8iAfY1HrMyb17lJvJm9VtHM4j6DacnnwMiHLETVkuadk2TtlbvNsUtoMoLlEFNSqfmJeJ783zMvkYe6A7zCC/lHqbMxFbIkFGuNcUgfH0yXRxSTjftoGJkIpaqlZHENTfJERzCYnbGxEShi2KUjtqoDoT48wEYbV94Iltn2Js5aYgpWkhQGr7DBwM4lo/atzq8yFHpv8bxYa9yL3PXAbUzWgH4AdE8dr5k21WkNFKLyRDmj1JKkfv9gWF8WoKbpsJvyfcyqikQhci5Z6YVSoE8vkdM3lKDhdXZ+g86kRAqywlX+hWLwmu1bKIy+THWoffqQ8oGaPtp0+nHWIOBhdfpH8XYeJ0OM6d/Bbs9mHivzPKE7qK6enOzPbv8OA6g0IpzjA87d1MLSlDqJckg34mEhEVIl1gh5dskwb0R4htjVGz4zsRL9pOeEct83BdTEa/l0cKPCAdMO2ySIIOH7W3yLCFq0HAwEZX1SAmvxMIiucz8hCTOGcDW08bFNpvnTY/XtT7ZRHeTDYG2DX1hJnyTaKs5TPSTOECcJUQJnpyAz20aIs2Kb3z9NrTgEa+dEcPwH0CU1hd3JW6+Zt8spNX4Py8iqyeNor2GieBMLZdkDmP1e3t8h6T2sS9AP8yjto+/RTmV2o6JoU8A/d0T8xHPykmdHCpLVz1tdp5yCTa5TPdboA/pekxYK8kp7e0gX+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199015)(66556008)(8676002)(4326008)(66946007)(66476007)(86362001)(83380400001)(41300700001)(26005)(36756003)(9686003)(6512007)(6506007)(52116002)(5660300002)(316002)(8936002)(6666004)(38100700002)(6486002)(2616005)(2906002)(38350700002)(1076003)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zbP8kX4hh60Xo8+jvGPzatweXDF4kG7ggk9rH8psuOkBJVFSla50iLxdnzv5?=
 =?us-ascii?Q?XO/dFDHN5y6+ae68LzGW6Aqg7ifrk4c/2C0MgpADdU/+SOcDRxgV0OtuV9yN?=
 =?us-ascii?Q?bFv1M5P5Av+8QuOxe5C1a0WPN2tMI9B9TJH2gNhwAbLDMqa8p6tJnbDEtlte?=
 =?us-ascii?Q?jmLokcfClxHS9/cwj4hlLoO5ePYNIz6LT2Pk8e8Uz2Z0fkH+wFWJDL7G8tMz?=
 =?us-ascii?Q?jNy4FqBmKpj976QQ++7TuW5tHUM81/EOiN8vxhugPhtrOwFvyvB22LkjBkuk?=
 =?us-ascii?Q?1cf5iLAAYLY2cS7jYE6AoCGRe3SFjEv2rZTahewdtDMjedHj6YXpDEWlam7e?=
 =?us-ascii?Q?DfEmPaW7J3i8z8rBsjSVn8aouLzA/xDeDJUtm+23S9IHxAJ6NKd1NxL7k7Is?=
 =?us-ascii?Q?cLitqIicdszPH/lveVlcoIiea+3OD4xqKOhGeuPW734bfLdFPpgbwN996syo?=
 =?us-ascii?Q?wwMOC2wIu6Ufzf4+aWiiHfd2eAJqHhUGcGsphd3D63RKnnxC8OWwcM1mMCjk?=
 =?us-ascii?Q?Jq/SjWEQ6ddDEJbXN4kpeWH+gAbUV5mA+PXMXPweJ4DuW1zJ2qiF1Od+0/yR?=
 =?us-ascii?Q?Qo0CMRU3L9RUNrKA2zv97IjdgoZtXG/sf5MFfmH96SROpIubOz6tAng4Avpj?=
 =?us-ascii?Q?LahDsICFzLttbk+ZsEQHMuDr6tqQmLDmxt+8IUipaLE/fs5r3wRa+PHBK97B?=
 =?us-ascii?Q?X51Yq+Jq301joMp2E+3Taj49sW3a4tmHJFwupODBIw+UtixZqHM21YC1Hz06?=
 =?us-ascii?Q?zC7Farq1x3NrR4swmgwSlV1wNG+rmLyFKr4q943/irHbD6yezVWSL+EFdPfC?=
 =?us-ascii?Q?ifM5QtsVrK5tzhMlm3QPIcBw/nX33WKsvCZa9HfYVWXPcdojNyST2WLHWY5X?=
 =?us-ascii?Q?5g0U62a3pC/ZitKGNyijkIyhfta+r4mW2wc4lTc5RLniXfrv3LpBWAr0f1vV?=
 =?us-ascii?Q?xNvW5ki7uj1NILkeabXe9WNSd9A91/+jUGxDH1qQdOzOiDsNAJcZN9cw29Ni?=
 =?us-ascii?Q?E7kdpo9PEr1fCGkNPaWlCQLeTWNlJ/vZqtFCJdLCbxr9bFIzbivhJ5NYigZG?=
 =?us-ascii?Q?dsp1tyTb+5gkCaxY0Zvoz3XretiGiLn398BNkLqdaFLBveL9cV1GI4BOGHIo?=
 =?us-ascii?Q?a8CxrAByqwLNgd9Q6wAMXHsrTAc4QkvcMUqmZokqJbgT5QWTzKgOjf6TJsLF?=
 =?us-ascii?Q?xSFLzyfzUNRtz6RL+x2JHMjXqeboNLJ55lYNdnQIo0e5S9OlZ3FN2Q7ta29k?=
 =?us-ascii?Q?iQYJft4XIm0baEEqWIwX/lKXU6f7DJs/AqlHS5l3bjc2bCGtPpaBtAiqz98E?=
 =?us-ascii?Q?nZmF54whj+BYCD7rSxsjPhvm2DX4I+wgkrgDFe35sNcuvDqJ9l8Rdst+bByn?=
 =?us-ascii?Q?v3x+NrjfQ7SDx7IuKRpvnrXKp6CMhQmuk6oVPMZ0iIUs6+Fp1bBXpvdCYh/v?=
 =?us-ascii?Q?Cs1M+qJzW6qrAm44fb/3oQkd1Dw0+drH1tt6jH1IQWJg1jmxnNEJbIrVQDPG?=
 =?us-ascii?Q?dV4jYAbcScjechs4+XV6VIZU9tkrRwzy/s0FPvlkt0lx4HjXrMj9Cbh4gm6p?=
 =?us-ascii?Q?+zCVNmvLsxF14+7wbTJXmvCU3cPVyHhjiJDMBjuQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21def135-8f38-4936-e19b-08dab1903304
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 05:10:11.7274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mmzcz/b7PXmJJFoek6+YlpCWND9jyYExOFksEzQ0ZaSI0QSOcld+4FbPF6fsmFbQCoZU/4R4pbtq0XUAcWTYmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

