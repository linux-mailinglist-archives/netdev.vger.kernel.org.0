Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B998E2B5112
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 20:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgKPT16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 14:27:58 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:35810 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgKPT15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 14:27:57 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AGJNLIG010641;
        Mon, 16 Nov 2020 14:27:54 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 34ta9m0y5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 14:27:54 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Mon, 16 Nov 2020 14:27:52 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 16 Nov 2020 14:27:52 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next 5/5] ptp: clockmatrix: deprecate firmware older than 4.8.7
Date:   Mon, 16 Nov 2020 14:27:30 -0500
Message-ID: <1605554850-14437-5-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605554850-14437-1-git-send-email-min.li.xe@renesas.com>
References: <1605554850-14437-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=4 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160114
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Add deprecated flag to indicate < v4.8.7.
Fix idtcm_enable_tod() call correct settime().

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 69 ++++++++++++++++++++++++-------------------
 drivers/ptp/ptp_clockmatrix.h | 11 +++----
 2 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 9b3ba92..c71a570 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -939,8 +939,8 @@ static void restore_output_phase_adj(struct idtcm_channel *channel)
 	}
 }
 
-static int _idtcm_settime(struct idtcm_channel *channel,
-			  struct timespec64 const *ts)
+static int _idtcm_settime_deprecated(struct idtcm_channel *channel,
+				     struct timespec64 const *ts)
 {
 	struct idtcm *idtcm = channel->idtcm;
 	int retval;
@@ -965,9 +965,9 @@ static int _idtcm_settime(struct idtcm_channel *channel,
 	return retval;
 }
 
-static int _idtcm_settime_v487(struct idtcm_channel *channel,
-			       struct timespec64 const *ts,
-			       enum scsr_tod_write_type_sel wr_type)
+static int _idtcm_settime(struct idtcm_channel *channel,
+			  struct timespec64 const *ts,
+			  enum scsr_tod_write_type_sel wr_type)
 {
 	return _idtcm_set_dpll_scsr_tod(channel, ts,
 					SCSR_TOD_WR_TRIG_SEL_IMMEDIATE,
@@ -1109,14 +1109,14 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 	return err;
 }
 
-static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
+static int _idtcm_adjtime_deprecated(struct idtcm_channel *channel, s64 delta)
 {
 	int err;
 	struct idtcm *idtcm = channel->idtcm;
 	struct timespec64 ts;
 	s64 now;
 
-	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS) {
+	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS_DEPRECATED) {
 		err = idtcm_do_phase_pull_in(channel, delta, 0);
 	} else {
 		idtcm->calculate_overhead_flag = 1;
@@ -1136,7 +1136,7 @@ static int _idtcm_adjtime(struct idtcm_channel *channel, s64 delta)
 
 		ts = ns_to_timespec64(now);
 
-		err = _idtcm_settime(channel, &ts);
+		err = _idtcm_settime_deprecated(channel, &ts);
 	}
 
 	return err;
@@ -1640,8 +1640,8 @@ static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	return err;
 }
 
-static int idtcm_settime(struct ptp_clock_info *ptp,
-			 const struct timespec64 *ts)
+static int idtcm_settime_deprecated(struct ptp_clock_info *ptp,
+				    const struct timespec64 *ts)
 {
 	struct idtcm_channel *channel =
 		container_of(ptp, struct idtcm_channel, caps);
@@ -1650,7 +1650,7 @@ static int idtcm_settime(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idtcm->reg_lock);
 
-	err = _idtcm_settime(channel, ts);
+	err = _idtcm_settime_deprecated(channel, ts);
 
 	if (err)
 		dev_err(&idtcm->client->dev,
@@ -1663,7 +1663,7 @@ static int idtcm_settime(struct ptp_clock_info *ptp,
 	return err;
 }
 
-static int idtcm_settime_v487(struct ptp_clock_info *ptp,
+static int idtcm_settime(struct ptp_clock_info *ptp,
 			 const struct timespec64 *ts)
 {
 	struct idtcm_channel *channel =
@@ -1673,7 +1673,7 @@ static int idtcm_settime_v487(struct ptp_clock_info *ptp,
 
 	mutex_lock(&idtcm->reg_lock);
 
-	err = _idtcm_settime_v487(channel, ts, SCSR_TOD_WR_TYPE_SEL_ABSOLUTE);
+	err = _idtcm_settime(channel, ts, SCSR_TOD_WR_TYPE_SEL_ABSOLUTE);
 
 	if (err)
 		dev_err(&idtcm->client->dev,
@@ -1686,7 +1686,7 @@ static int idtcm_settime_v487(struct ptp_clock_info *ptp,
 	return err;
 }
 
-static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
+static int idtcm_adjtime_deprecated(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct idtcm_channel *channel =
 		container_of(ptp, struct idtcm_channel, caps);
@@ -1695,7 +1695,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 	mutex_lock(&idtcm->reg_lock);
 
-	err = _idtcm_adjtime(channel, delta);
+	err = _idtcm_adjtime_deprecated(channel, delta);
 
 	if (err)
 		dev_err(&idtcm->client->dev,
@@ -1708,7 +1708,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	return err;
 }
 
-static int idtcm_adjtime_v487(struct ptp_clock_info *ptp, s64 delta)
+static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct idtcm_channel *channel =
 		container_of(ptp, struct idtcm_channel, caps);
@@ -1717,7 +1717,7 @@ static int idtcm_adjtime_v487(struct ptp_clock_info *ptp, s64 delta)
 	enum scsr_tod_write_type_sel type;
 	int err;
 
-	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS_V487) {
+	if (abs(delta) < PHASE_PULL_IN_THRESHOLD_NS) {
 		err = idtcm_do_phase_pull_in(channel, delta, 0);
 		if (err)
 			dev_err(&idtcm->client->dev,
@@ -1737,7 +1737,7 @@ static int idtcm_adjtime_v487(struct ptp_clock_info *ptp, s64 delta)
 
 	mutex_lock(&idtcm->reg_lock);
 
-	err = _idtcm_settime_v487(channel, &ts, type);
+	err = _idtcm_settime(channel, &ts, type);
 
 	if (err)
 		dev_err(&idtcm->client->dev,
@@ -2081,10 +2081,14 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
 	if (err)
 		return err;
 
-	return _idtcm_settime(channel, &ts);
+	if (idtcm->deprecated)
+		return _idtcm_settime_deprecated(channel, &ts);
+	else
+		return _idtcm_settime(channel, &ts,
+				      SCSR_TOD_WR_TYPE_SEL_ABSOLUTE);
 }
 
-static void idtcm_display_version_info(struct idtcm *idtcm)
+static void idtcm_set_version_info(struct idtcm *idtcm)
 {
 	u8 major;
 	u8 minor;
@@ -2106,31 +2110,36 @@ static void idtcm_display_version_info(struct idtcm *idtcm)
 	snprintf(idtcm->version, sizeof(idtcm->version), "%u.%u.%u",
 		 major, minor, hotfix);
 
+	if (idtcm_strverscmp(idtcm->version, "4.8.7") >= 0)
+		idtcm->deprecated = 0;
+	else
+		idtcm->deprecated = 1;
+
 	dev_info(&idtcm->client->dev, fmt, major, minor, hotfix,
 		 product_id, hw_rev_id, config_select);
 }
 
-static const struct ptp_clock_info idtcm_caps_v487 = {
+static const struct ptp_clock_info idtcm_caps = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
 	.n_per_out	= 12,
 	.adjphase	= &idtcm_adjphase,
 	.adjfine	= &idtcm_adjfine,
-	.adjtime	= &idtcm_adjtime_v487,
+	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
-	.settime64	= &idtcm_settime_v487,
+	.settime64	= &idtcm_settime,
 	.enable		= &idtcm_enable,
 };
 
-static const struct ptp_clock_info idtcm_caps = {
+static const struct ptp_clock_info idtcm_caps_deprecated = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
 	.n_per_out	= 12,
 	.adjphase	= &idtcm_adjphase,
 	.adjfine	= &idtcm_adjfine,
-	.adjtime	= &idtcm_adjtime,
+	.adjtime	= &idtcm_adjtime_deprecated,
 	.gettime64	= &idtcm_gettime,
-	.settime64	= &idtcm_settime,
+	.settime64	= &idtcm_settime_deprecated,
 	.enable		= &idtcm_enable,
 };
 
@@ -2253,15 +2262,15 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 
 	channel->idtcm = idtcm;
 
-	if (idtcm_strverscmp(idtcm->version, "4.8.7") >= 0)
-		channel->caps = idtcm_caps_v487;
+	if (idtcm->deprecated)
+		channel->caps = idtcm_caps_deprecated;
 	else
 		channel->caps = idtcm_caps;
 
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT CM TOD%u", index);
 
-	if (idtcm_strverscmp(idtcm->version, "4.8.7") >= 0) {
+	if (!idtcm->deprecated) {
 		err = idtcm_enable_tod_sync(channel);
 		if (err) {
 			dev_err(&idtcm->client->dev,
@@ -2360,7 +2369,7 @@ static int idtcm_probe(struct i2c_client *client,
 	mutex_init(&idtcm->reg_lock);
 	mutex_lock(&idtcm->reg_lock);
 
-	idtcm_display_version_info(idtcm);
+	idtcm_set_version_info(idtcm);
 
 	err = idtcm_load_firmware(idtcm, &client->dev);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 3790dfa..645de2c 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -45,11 +45,11 @@
 #define DEFAULT_TOD2_PTP_PLL		(2)
 #define DEFAULT_TOD3_PTP_PLL		(3)
 
-#define POST_SM_RESET_DELAY_MS		(3000)
-#define PHASE_PULL_IN_THRESHOLD_NS	(150000)
-#define PHASE_PULL_IN_THRESHOLD_NS_V487	(15000)
-#define TOD_WRITE_OVERHEAD_COUNT_MAX	(2)
-#define TOD_BYTE_COUNT			(11)
+#define POST_SM_RESET_DELAY_MS			(3000)
+#define PHASE_PULL_IN_THRESHOLD_NS_DEPRECATED	(150000)
+#define PHASE_PULL_IN_THRESHOLD_NS		(15000)
+#define TOD_WRITE_OVERHEAD_COUNT_MAX		(2)
+#define TOD_BYTE_COUNT				(11)
 
 #define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
 
@@ -132,6 +132,7 @@ struct idtcm {
 	u8			page_offset;
 	u8			tod_mask;
 	char			version[16];
+	u8			deprecated;
 
 	/* Overhead calculation for adjtime */
 	u8			calculate_overhead_flag;
-- 
2.7.4

