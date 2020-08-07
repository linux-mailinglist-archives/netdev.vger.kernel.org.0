Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C797423F067
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgHGQDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:03:40 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:54030 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgHGQDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:03:40 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 077FvuCQ005868;
        Fri, 7 Aug 2020 11:57:56 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 32n2jctr6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 11:57:56 -0400
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Fri, 7 Aug 2020 11:57:54 -0400
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 7 Aug 2020 11:57:54 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 2/4] ptp: ptp_idt82p33: add more debug logs
Date:   Fri, 7 Aug 2020 11:57:48 -0400
Message-ID: <1596815868-11045-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_12:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2008070110
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 88 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index bd1fbcd..189bb81 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -86,6 +86,7 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 	struct i2c_client *client = idt82p33->client;
 	struct i2c_msg msg[2];
 	int cnt;
+	char *fmt = "i2c_transfer failed at %d in %s for %s, at addr: %04X!\n";
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -99,7 +100,12 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 
 	cnt = i2c_transfer(client->adapter, msg, 2);
 	if (cnt < 0) {
-		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
+		dev_err(&client->dev,
+			fmt,
+			__LINE__,
+			__func__,
+			write ? "write" : "read",
+			(u8) regaddr);
 		return cnt;
 	} else if (cnt != 2) {
 		dev_err(&client->dev,
@@ -448,8 +454,13 @@ static int idt82p33_measure_tod_write_overhead(struct idt82p33_channel *channel)
 
 	err = idt82p33_measure_settime_gettime_gap_overhead(channel, &gap_ns);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idt82p33_measure_one_byte_write_overhead(channel,
 						       &one_byte_write_ns);
@@ -613,13 +624,23 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 
 	err = idt82p33_pps_enable(channel, false);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idt82p33_measure_tod_write_overhead(channel);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = _idt82p33_settime(channel, &ts);
 
@@ -728,6 +749,11 @@ static int idt82p33_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_adjfine(channel, scaled_ppm);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -751,10 +777,19 @@ static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns)
 
 	if (err) {
 		mutex_unlock(&idt82p33->reg_lock);
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
 	}
 
 	err = idt82p33_sync_tod(channel, true);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 
 	mutex_unlock(&idt82p33->reg_lock);
 
@@ -770,6 +805,11 @@ static int idt82p33_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_gettime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -785,6 +825,11 @@ static int idt82p33_settime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idt82p33->reg_lock);
 	err = _idt82p33_settime(channel, ts);
+	if (err)
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 	mutex_unlock(&idt82p33->reg_lock);
 
 	return err;
@@ -849,8 +894,13 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 	channel = &idt82p33->channel[index];
 
 	err = idt82p33_channel_init(channel, index);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	channel->idt82p33 = idt82p33;
 
@@ -859,12 +909,22 @@ static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
 		 "IDT 82P33 PLL%u", index);
 
 	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	err = idt82p33_enable_tod(channel);
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
 
@@ -896,8 +956,13 @@ static int idt82p33_load_firmware(struct idt82p33 *idt82p33)
 
 	err = request_firmware(&fw, FW_FILENAME, &idt82p33->client->dev);
 
-	if (err)
+	if (err) {
+		dev_err(&idt82p33->client->dev,
+			"Failed at line %d in func %s!\n",
+			__LINE__,
+			__func__);
 		return err;
+	}
 
 	dev_dbg(&idt82p33->client->dev, "firmware size %zu bytes\n", fw->size);
 
@@ -981,8 +1046,13 @@ static int idt82p33_probe(struct i2c_client *client,
 		for (i = 0; i < MAX_PHC_PLL; i++) {
 			if (idt82p33->pll_mask & (1 << i)) {
 				err = idt82p33_enable_channel(idt82p33, i);
-				if (err)
+				if (err) {
+					dev_err(&idt82p33->client->dev,
+						"Failed at %d in func %s!\n",
+						__LINE__,
+						__func__);
 					break;
+				}
 			}
 		}
 	} else {
-- 
2.7.4

