Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A7A636A32
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiKWTy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbiKWTyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:54:02 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2131.outbound.protection.outlook.com [40.107.114.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9F25C8;
        Wed, 23 Nov 2022 11:52:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmwvxU4J85LmUBtS8mL/t+YBHJquIySiBYfFytpzLhnARPo4cpJ+ipup+UP3jF8XOnHel4TaDmLZsdFdPVs7TE4pvDmGjEDvNOix6fLA1Fmg5Pp1KTsvQ8pYsbCAJyBCpHRU/j8WuO1pNVtgsbskENJZ1OZBi3DcGngFaYcEQAc1N+yL6vV0KTQmPGfblTwWuGDBUKj0f7g88AwGVUxdSSqRqSl4LkrOpiaFLZDM8rSOi0mkHDs2p1zlvj+iebqF92yWwAvbvsyvUXpY1mASQmIUgFWQXxTt7XPeY0qc60iYPlfC1Q4pStUbGmuEznJlo6aWUGlyujAXN2sHtTS7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7Ot6XyyDv4d9O8Mou7EGWvT2zs3tvB0Wc28CBRgtvE=;
 b=ZToJlBq+3UbuwAjevMIhtEgZwqTvoTGBYQzYS557MTFykItctwnX8iFFsHU6wb80R+ZNEi/NgJoslEFoJ2n/W1hJmqhllQTjOEAmCN60OoNZBI+hb5WBXSaaoqwNj+lnXlhNFJ9pIeHxw+aEDMfpau+LV/gRaYkDF2U2tGXeQJ0GKrqyUMsq+ICduQDHcSEdQqAID03CWsAeZKEBC7UEJzJvacTNBPcD49op4rL4xH8DoBBCYcJCchCG79JVf4G8weUAFEkrT2RYfjYcVxpDOiBvqfUiSngfR/vEBHQle8hM4oO3JQW0esJDSv74lCFv8ZMTb6L2VskNGaHdJGc0Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7Ot6XyyDv4d9O8Mou7EGWvT2zs3tvB0Wc28CBRgtvE=;
 b=LAO122U1aspsajzCizLzmANkO/Pz4r/5QuSQRcAg96I1zco3Dq77oXahT/Nkfy1F3p7hyr8PBzVYSIKTb3njum26XTmsUz5HoSvAdw3feCMrd2it+YV0krlPsfVqa1LMjsKDYp7L6P1iIeJYCzFfjRXA978TB14tMM8LrHkqadM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB8700.jpnprd01.prod.outlook.com (2603:1096:604:155::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:52:26 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::e53e:6fe6:a2de:d7f3]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::e53e:6fe6:a2de:d7f3%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:52:26 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
Date:   Wed, 23 Nov 2022 14:52:06 -0500
Message-Id: <20221123195207.10260-1-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:408:94::43) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB6593:EE_|OS3PR01MB8700:EE_
X-MS-Office365-Filtering-Correlation-Id: 6530833e-d1cf-4104-1a48-08dacd8c3ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v09pP/uLHBb5wjhZXmRDX9wlrdrtdbOIZyWugMhrTketIHVXNf2r/iXZJOX9ei2vtSjVc7AmbHQesLDVp7oSCGOEMpMUMsgrmE/kAWwP0WoUbyi+HgZY2QtEJ4GRwZRlQz1VBUhOyzUuP6g4/QkgQBxq+zZykYkvv3G66RxUlXZdbHdE+CNHYyqI2XLCUAHWReZXbhIMpbjmYIzhWmiyoE+I0ZK8k6exOWpBWWqB8BnkQ5U+zMdtCO2f/VnfpPTYGHupiEUo5Mf50E2C/zgk18UPvT4nQTRbgwiS7qyDa8BkZXEh7zuxNNfqqVOCpaSnnDh1AWyMegvsRNEdZAdm6umA0Xja43DHjC7BVYojQHZNIuV1+6yI7J9hv54fKmVuuOfze64v42PL7nY92HxOUbMgArMOzursnz8sGg84BX2Loe/Wv9qwJSQfO/vlZmDVZg8xsr4QSVRezKuj2po6jsM7XDPXkoAGvIXkPLlfOopmH/dvHp5uWQHl5LxuOdsC/L3/EIB/UkrMBX1kFlIxbr3xbigP7QXpx8Jdyy9u2jCck07KVdXLeS1+AUmMwmF6YX1f8OLPBLnqQyr4Kasiw/HFpJhecbyJctRnbuW+7uLnsVaDGV6YzK3J+anVhv0ZoE69S6946GVEl9DRGyABRbJ5q5FyT9k8AibwXfCjDGno2GikZ1pQdWTS4Ilc4E6n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(41300700001)(66946007)(66476007)(66556008)(4326008)(8676002)(26005)(316002)(6916009)(83380400001)(2906002)(6512007)(38100700002)(36756003)(103116003)(1076003)(8936002)(2616005)(186003)(5660300002)(86362001)(30864003)(478600001)(6506007)(6486002)(38350700002)(52116002)(107886003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9xY0WZ1pEScXoImBowV0mzCmxPwKPKct0fl/vSi3hwUQXhIP2O6dynlKTHxq?=
 =?us-ascii?Q?11K9Ktr4Xud/TBV4ukiFHFUd5sdYbtrGTbAvYEhiX1indtwieGvXkgPczxjx?=
 =?us-ascii?Q?xwCpV1Ub70/xQdc/HcHpsul8X+WvYoKEI6neltpMLwAgkzLQnjy3PNcsMPLN?=
 =?us-ascii?Q?F7KMZ9LvRYO9PQPfzvLruNvB1wY84QW9tMkNBaRWLeODB561ZhXl4jod9HzG?=
 =?us-ascii?Q?hLnM5PIsHUKr4NQlnOXoMR8DuRMEA3qlrstm1B6NbLSoCdEPsZl0tb4Su7AY?=
 =?us-ascii?Q?0QeNW2eQrKzwBXOIHOi7FUhGbd8UbHIG4ngPGXAsjLwb22HYYNju8qOPv55D?=
 =?us-ascii?Q?E+pWoLUsVruxN2p908XLY9F5039lttsxN1l04aaW695nRPeDVsw2W+mlGlu+?=
 =?us-ascii?Q?LZRX9PqdXJLrJB7HM4nXCbaJhmyE8rKwW8dJbkwzySJ6RC+pxxo7B0SBcek7?=
 =?us-ascii?Q?60t3pS5SwTtFBht2bUjIrHsAs8eryEy6CH30wOQDE8t9G7fDtsyA4JuooY3h?=
 =?us-ascii?Q?5KDRMFu1nQ3qiPSIhO8Q/6BGXCLjciNmrAmlZOQ+07SP4szSV0paKryJiSE+?=
 =?us-ascii?Q?HTyR6+oWq3QZB2/WBJfAlUvwyhjN6mWUuto/kauDjAcurgUeSnuEB/ijujat?=
 =?us-ascii?Q?SKZLTu1/KzQBAd099wGkY6kK+2DLxIwkRWHxl3TXBRiKenxyQ+IUz7rsRP48?=
 =?us-ascii?Q?fnwEstp4yq/U95UnKwj5X017boJis483y1mjB9wstCPyZWoHc+V4hfg6rZ+j?=
 =?us-ascii?Q?unCPAYqWBE+uXctK2zG7ZRcIcj/a/CO5BJH2DrFW/4zE0qh8FoQ/DpIbN/4I?=
 =?us-ascii?Q?kEe5b/35o6hIJWeLQh/rKxtR8x3w0R3ltHj+bDDZ7xHWuFTvZ1Y5AU+tSx+D?=
 =?us-ascii?Q?Q25SOrY+0G5N+5cduzgD/OiJmjpWEclCm3JmUm0DKylcvlorevzf+Hi9sNKD?=
 =?us-ascii?Q?C1XPMYx1g7ugtCcY0332wzmtksditzOEo8arKFs0GTyqioUPaBJaA0r9uqwe?=
 =?us-ascii?Q?T2vdCGts6Ja6S4Tdknv7UFrmOTHAVU/F8p0yO2jgSLNI2IaH1DIq4fFcHy/K?=
 =?us-ascii?Q?2PmStmMpUEHMVOEv+LSLlG9ZdKwKDf0H2kqMG7DZLgiMXOcCtiMAO1N0Kadt?=
 =?us-ascii?Q?/77WhfC3ovCqFNJRCAPXmbbs5UB3t9OA0nzvpVaiWfNZ0hPbOWMKriBtRCDB?=
 =?us-ascii?Q?uVAHy3K1ulWilY7xSOA73J/jM9qswTGj6FtzvC5ITW813NQrO7ez+y397IlB?=
 =?us-ascii?Q?XuyJ/l89K14Ty+twQcLa7Tw1T9vTBaCIniEJEhrsY72BkoZ2vWaCqlsWVs4y?=
 =?us-ascii?Q?9gnLcoHm5hWFNwIPgNLzizAA0fLrbkEBssKJErEGu9S6//UqgfwmzkwbgLWh?=
 =?us-ascii?Q?7zCaZCyZm/20Xmv7jm4SrBhMBqbBRYwwEomGI8H9p0n5XtfyMh0sWsREBter?=
 =?us-ascii?Q?+qFPDXIUEnpq3epyHnPIHVhxB87oYhfe94IUCmva/AMiULdvE1H40IMMXUYT?=
 =?us-ascii?Q?3PEt5EyS/vlP5dKEmCfoEJ3npHYnap0hgGGIopJHhkkzN4G165Lhf0KguAG2?=
 =?us-ascii?Q?Hm83N+AlL9mNPh7S7vQNoqGl93ZKOX0hMb8guh0K?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6530833e-d1cf-4104-1a48-08dacd8c3ded
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:52:26.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Y+3BCvhWLYCt9AfwSgTYoEAYd5ebVxeVmbTDJSRjXpfqEuyoeLCoCL3HlkAnm+uWaI8piZUYu/WUHK0uKH6eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8700
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

82P33 family of chips can trigger TOD read/write by external
signal from one of the IN12/13/14 pins, which are set user
space programs by calling PTP_PIN_SETFUNC through ptp_ioctl

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 683 +++++++++++++++++++++++++++++++++----
 drivers/ptp/ptp_idt82p33.h |  20 +-
 2 files changed, 640 insertions(+), 63 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 97c1be44e323..aece499c26d4 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -27,6 +27,8 @@ MODULE_VERSION("1.0");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(FW_FILENAME);
 
+#define EXTTS_PERIOD_MS (95)
+
 /* Module Parameters */
 static u32 phase_snap_threshold = SNAP_THRESHOLD_NS;
 module_param(phase_snap_threshold, uint, 0);
@@ -36,6 +38,8 @@ MODULE_PARM_DESC(phase_snap_threshold,
 static char *firmware;
 module_param(firmware, charp, 0);
 
+static struct ptp_pin_desc pin_config[MAX_PHC_PLL][MAX_TRIG_CLK];
+
 static inline int idt82p33_read(struct idt82p33 *idt82p33, u16 regaddr,
 				u8 *buf, u16 count)
 {
@@ -121,24 +125,270 @@ static int idt82p33_dpll_set_mode(struct idt82p33_channel *channel,
 	return 0;
 }
 
-static int _idt82p33_gettime(struct idt82p33_channel *channel,
-			     struct timespec64 *ts)
+static int idt82p33_set_tod_trigger(struct idt82p33_channel *channel,
+				    u8 trigger, bool write)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	int err;
+	u8 cfg;
+
+	if (trigger > WR_TRIG_SEL_MAX)
+		return -EINVAL;
+
+	err = idt82p33_read(idt82p33, channel->dpll_tod_trigger,
+			    &cfg, sizeof(cfg));
+
+	if (err)
+		return err;
+
+	if (write == true)
+		trigger = (trigger << WRITE_TRIGGER_SHIFT) |
+			  (cfg & READ_TRIGGER_MASK);
+	else
+		trigger = (trigger << READ_TRIGGER_SHIFT) |
+			  (cfg & WRITE_TRIGGER_MASK);
+
+	return idt82p33_write(idt82p33, channel->dpll_tod_trigger,
+			      &trigger, sizeof(trigger));
+}
+
+static int idt82p33_get_extts(struct idt82p33_channel *channel,
+			      struct timespec64 *ts)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	u8 buf[TOD_BYTE_COUNT];
+	int err;
+
+	err = idt82p33_read(idt82p33, channel->dpll_tod_sts, buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	/* Since trigger is not self clearing itself, we have to poll tod_sts */
+	if (memcmp(buf, channel->extts_tod_sts, TOD_BYTE_COUNT) == 0)
+		return -EAGAIN;
+
+	memcpy(channel->extts_tod_sts, buf, TOD_BYTE_COUNT);
+
+	idt82p33_byte_array_to_timespec(ts, buf);
+
+	if (channel->discard_next_extts) {
+		channel->discard_next_extts = false;
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static int map_ref_to_tod_trig_sel(int ref, u8 *trigger)
+{
+	int err = 0;
+
+	switch (ref) {
+	case 0:
+		*trigger = HW_TOD_TRIG_SEL_IN12;
+		break;
+	case 1:
+		*trigger = HW_TOD_TRIG_SEL_IN13;
+		break;
+	case 2:
+		*trigger = HW_TOD_TRIG_SEL_IN14;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static bool is_one_shot(u8 mask)
+{
+	/* Treat single bit PLL masks as continuous trigger */
+	if ((mask == 1) || (mask == 2))
+		return false;
+	else
+		return true;
+}
+
+static int arm_tod_read_with_trigger(struct idt82p33_channel *channel, u8 trigger)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	u8 buf[TOD_BYTE_COUNT];
+	int err;
+
+	/* Remember the current tod_sts before setting the trigger */
+	err = idt82p33_read(idt82p33, channel->dpll_tod_sts, buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	memcpy(channel->extts_tod_sts, buf, TOD_BYTE_COUNT);
+
+	err = idt82p33_set_tod_trigger(channel, trigger, false);
+
+	if (err)
+		dev_err(idt82p33->dev, "%s: err = %d", __func__, err);
+
+	return err;
+}
+
+static int idt82p33_extts_enable(struct idt82p33_channel *channel,
+				 struct ptp_clock_request *rq, int on)
+{
+	u8 index = rq->extts.index;
+	struct idt82p33 *idt82p33;
+	u8 mask = 1 << index;
+	int err = 0;
+	u8 old_mask;
 	u8 trigger;
+	int ref;
+
+	idt82p33  = channel->idt82p33;
+	old_mask = idt82p33->extts_mask;
+
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE |
+				PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Reject requests to enable time stamping on falling edge */
+	if ((rq->extts.flags & PTP_ENABLE_FEATURE) &&
+	    (rq->extts.flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	if (index >= MAX_PHC_PLL)
+		return -EINVAL;
+
+	if (on) {
+		/* Return if it was already enabled */
+		if (idt82p33->extts_mask & mask)
+			return 0;
+
+		/* Use the pin configured for the channel */
+		ref = ptp_find_pin(channel->ptp_clock, PTP_PF_EXTTS, channel->plln);
+
+		if (ref < 0) {
+			dev_err(idt82p33->dev, "%s: No valid pin found for Pll%d!\n",
+				__func__, channel->plln);
+			return -EBUSY;
+		}
+
+		err = map_ref_to_tod_trig_sel(ref, &trigger);
+
+		if (err) {
+			dev_err(idt82p33->dev,
+				"%s: Unsupported ref %d!\n", __func__, ref);
+			return err;
+		}
+
+		err = arm_tod_read_with_trigger(&idt82p33->channel[index], trigger);
+
+		if (err == 0) {
+			idt82p33->extts_mask |= mask;
+			idt82p33->channel[index].tod_trigger = trigger;
+			idt82p33->event_channel[index] = channel;
+			idt82p33->extts_single_shot = is_one_shot(idt82p33->extts_mask);
+
+			if (old_mask)
+				return 0;
+
+			schedule_delayed_work(&idt82p33->extts_work,
+					      msecs_to_jiffies(EXTTS_PERIOD_MS));
+		}
+	} else {
+		idt82p33->extts_mask &= ~mask;
+		idt82p33->extts_single_shot = is_one_shot(idt82p33->extts_mask);
+
+		if (idt82p33->extts_mask == 0)
+			cancel_delayed_work(&idt82p33->extts_work);
+	}
+
+	return err;
+}
+
+static int idt82p33_extts_check_channel(struct idt82p33 *idt82p33, u8 todn)
+{
+	struct idt82p33_channel *event_channel;
+	struct ptp_clock_event event;
+	struct timespec64 ts;
+	int err;
+
+	err = idt82p33_get_extts(&idt82p33->channel[todn], &ts);
+	if (err == 0) {
+		event_channel = idt82p33->event_channel[todn];
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = todn;
+		event.timestamp = timespec64_to_ns(&ts);
+		ptp_clock_event(event_channel->ptp_clock,
+				&event);
+	}
+	return err;
+}
+
+static u8 idt82p33_extts_enable_mask(struct idt82p33_channel *channel,
+				     u8 extts_mask, bool enable)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	u8 trigger = channel->tod_trigger;
+	u8 mask;
 	int err;
+	int i;
+
+	if (extts_mask == 0)
+		return 0;
+
+	if (enable == false)
+		cancel_delayed_work_sync(&idt82p33->extts_work);
+
+	for (i = 0; i < MAX_PHC_PLL; i++) {
+		mask = 1 << i;
+
+		if ((extts_mask & mask) == 0)
+			continue;
+
+		if (enable) {
+			err = arm_tod_read_with_trigger(&idt82p33->channel[i], trigger);
+			if (err)
+				dev_err(idt82p33->dev,
+					"%s: Arm ToD read trigger failed, err = %d",
+					__func__, err);
+		} else {
+			err = idt82p33_extts_check_channel(idt82p33, i);
+			if (err == 0 && idt82p33->extts_single_shot)
+				/* trigger happened so we won't re-enable it */
+				extts_mask &= ~mask;
+		}
+	}
 
-	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
+	if (enable)
+		schedule_delayed_work(&idt82p33->extts_work,
+				      msecs_to_jiffies(EXTTS_PERIOD_MS));
 
+	return extts_mask;
+}
+
+static int _idt82p33_gettime(struct idt82p33_channel *channel,
+			     struct timespec64 *ts)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	u8 old_mask = idt82p33->extts_mask;
+	u8 buf[TOD_BYTE_COUNT];
+	u8 new_mask = 0;
+	int err;
 
-	err = idt82p33_write(idt82p33, channel->dpll_tod_trigger,
-			     &trigger, sizeof(trigger));
+	/* Disable extts */
+	if (old_mask)
+		new_mask = idt82p33_extts_enable_mask(channel, old_mask, false);
 
+	err = idt82p33_set_tod_trigger(channel, HW_TOD_RD_TRIG_SEL_LSB_TOD_STS,
+				       false);
 	if (err)
 		return err;
 
+	channel->discard_next_extts = true;
+
 	if (idt82p33->calculate_overhead_flag)
 		idt82p33->start_time = ktime_get_raw();
 
@@ -147,6 +397,10 @@ static int _idt82p33_gettime(struct idt82p33_channel *channel,
 	if (err)
 		return err;
 
+	/* Re-enable extts */
+	if (new_mask)
+		idt82p33_extts_enable_mask(channel, new_mask, true);
+
 	idt82p33_byte_array_to_timespec(ts, buf);
 
 	return 0;
@@ -165,19 +419,16 @@ static int _idt82p33_settime(struct idt82p33_channel *channel,
 	struct timespec64 local_ts = *ts;
 	char buf[TOD_BYTE_COUNT];
 	s64 dynamic_overhead_ns;
-	unsigned char trigger;
 	int err;
 	u8 i;
 
-	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
-
-	err = idt82p33_write(idt82p33, channel->dpll_tod_trigger,
-			&trigger, sizeof(trigger));
-
+	err = idt82p33_set_tod_trigger(channel, HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
+				       true);
 	if (err)
 		return err;
 
+	channel->discard_next_extts = true;
+
 	if (idt82p33->calculate_overhead_flag) {
 		dynamic_overhead_ns = ktime_to_ns(ktime_get_raw())
 					- ktime_to_ns(idt82p33->start_time);
@@ -202,7 +453,8 @@ static int _idt82p33_settime(struct idt82p33_channel *channel,
 	return err;
 }
 
-static int _idt82p33_adjtime(struct idt82p33_channel *channel, s64 delta_ns)
+static int _idt82p33_adjtime_immediate(struct idt82p33_channel *channel,
+				       s64 delta_ns)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	struct timespec64 ts;
@@ -226,6 +478,60 @@ static int _idt82p33_adjtime(struct idt82p33_channel *channel, s64 delta_ns)
 	return err;
 }
 
+static int _idt82p33_adjtime_internal_triggered(struct idt82p33_channel *channel,
+						s64 delta_ns)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	char buf[TOD_BYTE_COUNT];
+	struct timespec64 ts;
+	const u8 delay_ns = 32;
+	s32 remainder;
+	s64 ns;
+	int err;
+
+	err = _idt82p33_gettime(channel, &ts);
+
+	if (err)
+		return err;
+
+	if (ts.tv_nsec > (NSEC_PER_SEC - 5 * NSEC_PER_MSEC)) {
+		/*  Too close to miss next trigger, so skip it */
+		mdelay(6);
+		ns = (ts.tv_sec + 2) * NSEC_PER_SEC + delta_ns + delay_ns;
+	} else
+		ns = (ts.tv_sec + 1) * NSEC_PER_SEC + delta_ns + delay_ns;
+
+	ts = ns_to_timespec64(ns);
+	idt82p33_timespec_to_byte_array(&ts, buf);
+
+	/*
+	 * Store the new time value.
+	 */
+	err = idt82p33_write(idt82p33, channel->dpll_tod_cnfg, buf, sizeof(buf));
+	if (err)
+		return err;
+
+	/* Schedule to implement the workaround in one second */
+	(void)div_s64_rem(delta_ns, NSEC_PER_SEC, &remainder);
+	if (remainder != 0)
+		schedule_delayed_work(&channel->adjtime_work, HZ);
+
+	return idt82p33_set_tod_trigger(channel, HW_TOD_TRIG_SEL_TOD_PPS, true);
+}
+
+static void idt82p33_adjtime_workaround(struct work_struct *work)
+{
+	struct idt82p33_channel *channel = container_of(work,
+							struct idt82p33_channel,
+							adjtime_work.work);
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+
+	mutex_lock(idt82p33->lock);
+	/* Workaround for TOD-to-output alignment issue */
+	_idt82p33_adjtime_internal_triggered(channel, 0);
+	mutex_unlock(idt82p33->lock);
+}
+
 static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
@@ -233,25 +539,22 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 	int err, i;
 	s64 fcw;
 
-	if (scaled_ppm == channel->current_freq_ppb)
-		return 0;
-
 	/*
-	 * Frequency Control Word unit is: 1.68 * 10^-10 ppm
+	 * Frequency Control Word unit is: 1.6861512 * 10^-10 ppm
 	 *
 	 * adjfreq:
-	 *       ppb * 10^9
-	 * FCW = ----------
-	 *          168
+	 *       ppb * 10^14
+	 * FCW = -----------
+	 *         16861512
 	 *
 	 * adjfine:
-	 *       scaled_ppm * 5^12
-	 * FCW = -------------
-	 *         168 * 2^4
+	 *       scaled_ppm * 5^12 * 10^5
+	 * FCW = ------------------------
+	 *            16861512 * 2^4
 	 */
 
-	fcw = scaled_ppm * 244140625ULL;
-	fcw = div_s64(fcw, 2688);
+	fcw = scaled_ppm * 762939453125ULL;
+	fcw = div_s64(fcw, 8430756LL);
 
 	for (i = 0; i < 5; i++) {
 		buf[i] = fcw & 0xff;
@@ -266,26 +569,84 @@ static int _idt82p33_adjfine(struct idt82p33_channel *channel, long scaled_ppm)
 	err = idt82p33_write(idt82p33, channel->dpll_freq_cnfg,
 			     buf, sizeof(buf));
 
-	if (err == 0)
-		channel->current_freq_ppb = scaled_ppm;
-
 	return err;
 }
 
+/* ppb = scaled_ppm * 125 / 2^13 */
+static s32 idt82p33_ddco_scaled_ppm(long current_ppm, s32 ddco_ppb)
+{
+	s64 scaled_ppm = div_s64(((s64)ddco_ppb << 13), 125);
+	s64 max_scaled_ppm = div_s64(((s64)DCO_MAX_PPB << 13), 125);
+
+	current_ppm += scaled_ppm;
+
+	if (current_ppm > max_scaled_ppm)
+		current_ppm = max_scaled_ppm;
+	else if (current_ppm < -max_scaled_ppm)
+		current_ppm = -max_scaled_ppm;
+
+	return (s32)current_ppm;
+}
+
+static int idt82p33_stop_ddco(struct idt82p33_channel *channel)
+{
+	int err;
+
+	err = _idt82p33_adjfine(channel, channel->current_freq);
+	if (err)
+		return err;
+
+	channel->ddco = false;
+
+	return 0;
+}
+
+static int idt82p33_start_ddco(struct idt82p33_channel *channel, s32 delta_ns)
+{
+	s32 current_ppm = channel->current_freq;
+	u32 duration_ms = MSEC_PER_SEC;
+	s32 ppb;
+	int err;
+
+	/* If the ToD correction is less than 5 nanoseconds, then skip it.
+	 * The error introduced by the ToD adjustment procedure would be bigger
+	 * than the required ToD correction
+	 */
+	if (abs(delta_ns) < DDCO_THRESHOLD_NS)
+		return 0;
+
+	/* For most cases, keep ddco duration 1 second */
+	ppb = delta_ns;
+	while (abs(ppb) > DCO_MAX_PPB) {
+		duration_ms *= 2;
+		ppb /= 2;
+	}
+
+	err = _idt82p33_adjfine(channel,
+				idt82p33_ddco_scaled_ppm(current_ppm, ppb));
+	if (err)
+		return err;
+
+	/* schedule the worker to cancel ddco */
+	ptp_schedule_worker(channel->ptp_clock,
+			    msecs_to_jiffies(duration_ms) - 1);
+	channel->ddco = true;
+
+	return 0;
+}
+
 static int idt82p33_measure_one_byte_write_overhead(
 		struct idt82p33_channel *channel, s64 *overhead_ns)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	ktime_t start, stop;
+	u8 trigger = 0;
 	s64 total_ns;
-	u8 trigger;
 	int err;
 	u8 i;
 
 	total_ns = 0;
 	*overhead_ns = 0;
-	trigger = TOD_TRIGGER(HW_TOD_WR_TRIG_SEL_MSB_TOD_CNFG,
-			      HW_TOD_RD_TRIG_SEL_LSB_TOD_STS);
 
 	for (i = 0; i < MAX_MEASURMENT_COUNT; i++) {
 
@@ -307,8 +668,41 @@ static int idt82p33_measure_one_byte_write_overhead(
 	return err;
 }
 
+static int idt82p33_measure_one_byte_read_overhead(
+		struct idt82p33_channel *channel, s64 *overhead_ns)
+{
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+	ktime_t start, stop;
+	u8 trigger = 0;
+	s64 total_ns;
+	int err;
+	u8 i;
+
+	total_ns = 0;
+	*overhead_ns = 0;
+
+	for (i = 0; i < MAX_MEASURMENT_COUNT; i++) {
+
+		start = ktime_get_raw();
+
+		err = idt82p33_read(idt82p33, channel->dpll_tod_trigger,
+				    &trigger, sizeof(trigger));
+
+		stop = ktime_get_raw();
+
+		if (err)
+			return err;
+
+		total_ns += ktime_to_ns(stop) - ktime_to_ns(start);
+	}
+
+	*overhead_ns = div_s64(total_ns, MAX_MEASURMENT_COUNT);
+
+	return err;
+}
+
 static int idt82p33_measure_tod_write_9_byte_overhead(
-			struct idt82p33_channel *channel)
+		struct idt82p33_channel *channel)
 {
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	u8 buf[TOD_BYTE_COUNT];
@@ -368,7 +762,7 @@ static int idt82p33_measure_settime_gettime_gap_overhead(
 
 static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 {
-	s64 trailing_overhead_ns, one_byte_write_ns, gap_ns;
+	s64 trailing_overhead_ns, one_byte_write_ns, gap_ns, one_byte_read_ns;
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
@@ -388,12 +782,19 @@ static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 	if (err)
 		return err;
 
+	err = idt82p33_measure_one_byte_read_overhead(channel,
+						      &one_byte_read_ns);
+
+	if (err)
+		return err;
+
 	err = idt82p33_measure_tod_write_9_byte_overhead(channel);
 
 	if (err)
 		return err;
 
-	trailing_overhead_ns = gap_ns - (2 * one_byte_write_ns);
+	trailing_overhead_ns = gap_ns - 2 * one_byte_write_ns
+			       - one_byte_read_ns;
 
 	idt82p33->tod_write_overhead_ns -= trailing_overhead_ns;
 
@@ -462,6 +863,20 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 			      &sync_cnfg, sizeof(sync_cnfg));
 }
 
+static long idt82p33_work_handler(struct ptp_clock_info *ptp)
+{
+	struct idt82p33_channel *channel =
+			container_of(ptp, struct idt82p33_channel, caps);
+	struct idt82p33 *idt82p33 = channel->idt82p33;
+
+	mutex_lock(idt82p33->lock);
+	(void)idt82p33_stop_ddco(channel);
+	mutex_unlock(idt82p33->lock);
+
+	/* Return a negative value here to not reschedule */
+	return -1;
+}
+
 static int idt82p33_output_enable(struct idt82p33_channel *channel,
 				  bool enable, unsigned int outn)
 {
@@ -524,6 +939,10 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	struct timespec64 ts = {0, 0};
 	int err;
 
+	/* STEELAI-366 - Temporary workaround for ts2phc compatibility */
+	if (0)
+		err = idt82p33_output_mask_enable(channel, false);
+
 	err = idt82p33_measure_tod_write_overhead(channel);
 
 	if (err) {
@@ -546,14 +965,15 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 	u8 i;
 
 	for (i = 0; i < MAX_PHC_PLL; i++) {
-
 		channel = &idt82p33->channel[i];
-
+		cancel_delayed_work_sync(&channel->adjtime_work);
 		if (channel->ptp_clock)
 			ptp_clock_unregister(channel->ptp_clock);
 	}
 }
 
+
+
 static int idt82p33_enable(struct ptp_clock_info *ptp,
 			   struct ptp_clock_request *rq, int on)
 {
@@ -564,7 +984,8 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 
 	mutex_lock(idt82p33->lock);
 
-	if (rq->type == PTP_CLK_REQ_PEROUT) {
+	switch (rq->type) {
+	case PTP_CLK_REQ_PEROUT:
 		if (!on)
 			err = idt82p33_perout_enable(channel, false,
 						     &rq->perout);
@@ -575,6 +996,12 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 		else
 			err = idt82p33_perout_enable(channel, true,
 						     &rq->perout);
+		break;
+	case PTP_CLK_REQ_EXTTS:
+		err = idt82p33_extts_enable(channel, rq, on);
+		break;
+	default:
+		break;
 	}
 
 	mutex_unlock(idt82p33->lock);
@@ -634,13 +1061,22 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
+	if (channel->ddco == true)
+		return 0;
+
+	if (scaled_ppm == channel->current_freq)
+		return 0;
+
 	mutex_lock(idt82p33->lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+
+	if (err == 0)
+		channel->current_freq = scaled_ppm;
 	mutex_unlock(idt82p33->lock);
+
 	if (err)
 		dev_err(idt82p33->dev,
 			"Failed in %s with err %d!\n", __func__, err);
-
 	return err;
 }
 
@@ -651,14 +1087,21 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 	struct idt82p33 *idt82p33 = channel->idt82p33;
 	int err;
 
+	if (channel->ddco == true)
+		return -EBUSY;
+
 	mutex_lock(idt82p33->lock);
 
 	if (abs(delta_ns) < phase_snap_threshold) {
+		err = idt82p33_start_ddco(channel, delta_ns);
 		mutex_unlock(idt82p33->lock);
-		return 0;
+		return err;
 	}
 
-	err = _idt82p33_adjtime(channel, delta_ns);
+	/* Use more accurate internal 1pps triggered write first */
+	err = _idt82p33_adjtime_internal_triggered(channel, delta_ns);
+	if (err && delta_ns > IMMEDIATE_SNAP_THRESHOLD_NS)
+		err = _idt82p33_adjtime_immediate(channel, delta_ns);
 
 	mutex_unlock(idt82p33->lock);
 
@@ -703,8 +1146,10 @@ static int idt82p33_settime(struct ptp_clock_info *ptp,
 	return err;
 }
 
-static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
+static int idt82p33_channel_init(struct idt82p33 *idt82p33, u32 index)
 {
+	struct idt82p33_channel *channel = &idt82p33->channel[index];
+
 	switch (index) {
 	case 0:
 		channel->dpll_tod_cnfg = DPLL1_TOD_CNFG;
@@ -730,22 +1175,60 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 		return -EINVAL;
 	}
 
-	channel->current_freq_ppb = 0;
+	channel->plln = index;
+	channel->current_freq = 0;
+	channel->idt82p33 = idt82p33;
+	INIT_DELAYED_WORK(&channel->adjtime_work, idt82p33_adjtime_workaround);
+
+	return 0;
+}
 
+static int idt82p33_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+			       enum ptp_pin_function func, unsigned int chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_EXTTS:
+		break;
+	case PTP_PF_PEROUT:
+	case PTP_PF_PHYSYNC:
+		return -1;
+	}
 	return 0;
 }
 
-static void idt82p33_caps_init(struct ptp_clock_info *caps)
+static void idt82p33_caps_init(u32 index, struct ptp_clock_info *caps,
+			       struct ptp_pin_desc *pin_cfg, u8 max_pins)
 {
+	struct ptp_pin_desc *ppd;
+	int i;
+
 	caps->owner = THIS_MODULE;
 	caps->max_adj = DCO_MAX_PPB;
-	caps->n_per_out = 11;
-	caps->adjphase = idt82p33_adjwritephase;
+	caps->n_per_out = MAX_PER_OUT;
+	caps->n_ext_ts = MAX_PHC_PLL,
+	caps->n_pins = max_pins,
+	caps->adjphase = idt82p33_adjwritephase,
 	caps->adjfine = idt82p33_adjfine;
 	caps->adjtime = idt82p33_adjtime;
 	caps->gettime64 = idt82p33_gettime;
 	caps->settime64 = idt82p33_settime;
 	caps->enable = idt82p33_enable;
+	caps->verify = idt82p33_verify_pin;
+	caps->do_aux_work = idt82p33_work_handler;
+
+	snprintf(caps->name, sizeof(caps->name), "IDT 82P33 PLL%u", index);
+
+	caps->pin_config = pin_cfg;
+
+	for (i = 0; i < max_pins; ++i) {
+		ppd = &pin_cfg[i];
+
+		ppd->index = i;
+		ppd->func = PTP_PF_NONE;
+		ppd->chan = index;
+		snprintf(ppd->name, sizeof(ppd->name), "in%d", 12 + i);
+	}
 }
 
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
@@ -758,7 +1241,7 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 
 	channel = &idt82p33->channel[index];
 
-	err = idt82p33_channel_init(channel, index);
+	err = idt82p33_channel_init(idt82p33, index);
 	if (err) {
 		dev_err(idt82p33->dev,
 			"Channel_init failed in %s with err %d!\n",
@@ -766,11 +1249,8 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 		return err;
 	}
 
-	channel->idt82p33 = idt82p33;
-
-	idt82p33_caps_init(&channel->caps);
-	snprintf(channel->caps.name, sizeof(channel->caps.name),
-		 "IDT 82P33 PLL%u", index);
+	idt82p33_caps_init(index, &channel->caps,
+			   pin_config[index], MAX_TRIG_CLK);
 
 	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
 
@@ -805,17 +1285,46 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 	return 0;
 }
 
+static int idt82p33_reset(struct idt82p33 *idt82p33, bool cold)
+{
+	int err;
+	u8 cfg = SOFT_RESET_EN;
+
+	if (cold == true)
+		goto cold_reset;
+
+	err = idt82p33_read(idt82p33, REG_SOFT_RESET, &cfg, sizeof(cfg));
+	if (err) {
+		dev_err(idt82p33->dev,
+			"Soft reset failed with err %d!\n", err);
+		return err;
+	}
+
+	cfg |= SOFT_RESET_EN;
+
+cold_reset:
+	err = idt82p33_write(idt82p33, REG_SOFT_RESET, &cfg, sizeof(cfg));
+	if (err)
+		dev_err(idt82p33->dev,
+			"Cold reset failed with err %d!\n", err);
+	return err;
+}
+
 static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 {
+	char fname[128] = FW_FILENAME;
 	const struct firmware *fw;
 	struct idt82p33_fwrc *rec;
 	u8 loaddr, page, val;
 	int err;
 	s32 len;
 
-	dev_dbg(idt82p33->dev, "requesting firmware '%s'\n", FW_FILENAME);
+	if (firmware) /* module parameter */
+		snprintf(fname, sizeof(fname), "%s", firmware);
+
+	dev_info(idt82p33->dev, "requesting firmware '%s'\n", fname);
 
-	err = request_firmware(&fw, FW_FILENAME, idt82p33->dev);
+	err = request_firmware(&fw, fname, idt82p33->dev);
 
 	if (err) {
 		dev_err(idt82p33->dev,
@@ -863,6 +1372,46 @@ static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 	return err;
 }
 
+static void idt82p33_extts_check(struct work_struct *work)
+{
+	struct idt82p33 *idt82p33 = container_of(work, struct idt82p33,
+						 extts_work.work);
+	struct idt82p33_channel *channel;
+	int err;
+	u8 mask;
+	int i;
+
+	if (idt82p33->extts_mask == 0)
+		return;
+
+	mutex_lock(idt82p33->lock);
+
+	for (i = 0; i < MAX_PHC_PLL; i++) {
+		mask = 1 << i;
+
+		if ((idt82p33->extts_mask & mask) == 0)
+			continue;
+
+		err = idt82p33_extts_check_channel(idt82p33, i);
+
+		if (err == 0) {
+			/* trigger clears itself, so clear the mask */
+			if (idt82p33->extts_single_shot) {
+				idt82p33->extts_mask &= ~mask;
+			} else {
+				/* Re-arm */
+				channel = &idt82p33->channel[i];
+				arm_tod_read_with_trigger(channel, channel->tod_trigger);
+			}
+		}
+	}
+
+	if (idt82p33->extts_mask)
+		schedule_delayed_work(&idt82p33->extts_work,
+				      msecs_to_jiffies(EXTTS_PERIOD_MS));
+
+	mutex_unlock(idt82p33->lock);
+}
 
 static int idt82p33_probe(struct platform_device *pdev)
 {
@@ -885,25 +1434,33 @@ static int idt82p33_probe(struct platform_device *pdev)
 	idt82p33->pll_mask = DEFAULT_PLL_MASK;
 	idt82p33->channel[0].output_mask = DEFAULT_OUTPUT_MASK_PLL0;
 	idt82p33->channel[1].output_mask = DEFAULT_OUTPUT_MASK_PLL1;
+	idt82p33->extts_mask = 0;
+	INIT_DELAYED_WORK(&idt82p33->extts_work, idt82p33_extts_check);
 
 	mutex_lock(idt82p33->lock);
 
-	err = idt82p33_load_firmware(idt82p33);
+	/* cold reset before loading firmware */
+	idt82p33_reset(idt82p33, true);
 
+	err = idt82p33_load_firmware(idt82p33);
 	if (err)
 		dev_warn(idt82p33->dev,
 			 "loading firmware failed with %d\n", err);
 
+	/* soft reset after loading firmware */
+	idt82p33_reset(idt82p33, false);
+
 	if (idt82p33->pll_mask) {
 		for (i = 0; i < MAX_PHC_PLL; i++) {
-			if (idt82p33->pll_mask & (1 << i)) {
+			if (idt82p33->pll_mask & (1 << i))
 				err = idt82p33_enable_channel(idt82p33, i);
-				if (err) {
-					dev_err(idt82p33->dev,
-						"Failed in %s with err %d!\n",
-						__func__, err);
-					break;
-				}
+			else
+				err = idt82p33_channel_init(idt82p33, i);
+			if (err) {
+				dev_err(idt82p33->dev,
+					"Failed in %s with err %d!\n",
+					__func__, err);
+				break;
 			}
 		}
 	} else {
@@ -928,6 +1485,8 @@ static int idt82p33_remove(struct platform_device *pdev)
 {
 	struct idt82p33 *idt82p33 = platform_get_drvdata(pdev);
 
+	cancel_delayed_work_sync(&idt82p33->extts_work);
+
 	idt82p33_ptp_clock_unregister_all(idt82p33);
 
 	return 0;
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 0ea1c35c0f9f..cddebf05a5b9 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -13,6 +13,8 @@
 
 #define FW_FILENAME	"idt82p33xxx.bin"
 #define MAX_PHC_PLL	(2)
+#define MAX_TRIG_CLK	(3)
+#define MAX_PER_OUT	(11)
 #define TOD_BYTE_COUNT	(10)
 #define DCO_MAX_PPB     (92000)
 #define MAX_MEASURMENT_COUNT	(5)
@@ -60,8 +62,18 @@ struct idt82p33_channel {
 	struct ptp_clock	*ptp_clock;
 	struct idt82p33		*idt82p33;
 	enum pll_mode		pll_mode;
-	s32			current_freq_ppb;
+	/* Workaround for TOD-to-output alignment issue */
+	struct delayed_work	adjtime_work;
+	s32			current_freq;
+	/* double dco mode */
+	bool			ddco;
 	u8			output_mask;
+	/* last input trigger for extts */
+	u8			tod_trigger;
+	bool			discard_next_extts;
+	u8			plln;
+	/* remember last tod_sts for extts */
+	u8			extts_tod_sts[TOD_BYTE_COUNT];
 	u16			dpll_tod_cnfg;
 	u16			dpll_tod_trigger;
 	u16			dpll_tod_sts;
@@ -76,6 +88,12 @@ struct idt82p33 {
 	struct idt82p33_channel	channel[MAX_PHC_PLL];
 	struct device		*dev;
 	u8			pll_mask;
+	/* Polls for external time stamps */
+	u8			extts_mask;
+	bool			extts_single_shot;
+	struct delayed_work	extts_work;
+	/* Remember the ptp channel to report extts */
+	struct idt82p33_channel	*event_channel[MAX_PHC_PLL];
 	/* Mutex to protect operations from being interrupted */
 	struct mutex		*lock;
 	struct regmap		*regmap;
-- 
2.37.3

