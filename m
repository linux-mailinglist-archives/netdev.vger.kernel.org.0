Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52EE2B6A70
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgKQQjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:39:39 -0500
Received: from pbmsgap01.intersil.com ([192.157.179.201]:44142 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgKQQjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:39:39 -0500
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFrdgJ028277;
        Tue, 17 Nov 2020 11:06:33 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 34tbn59bc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:06:33 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 17 Nov 2020 11:06:31 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 17 Nov 2020 11:06:31 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net-next 3/5] ptp: clockmatrix: remove 5 second delay before entering write phase mode
Date:   Tue, 17 Nov 2020 11:06:00 -0500
Message-ID: <1605629162-31876-4-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
References: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=4 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170115
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Remove write phase mode 5 second setup delay, not needed.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 22 ----------------------
 drivers/ptp/ptp_clockmatrix.h |  1 -
 2 files changed, 23 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 6a3d02b..c06df61 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -72,16 +72,6 @@ static int contains_full_configuration(const struct firmware *fw)
 	return (count >= full_count);
 }
 
-static long set_write_phase_ready(struct ptp_clock_info *ptp)
-{
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
-
-	channel->write_phase_ready = 1;
-
-	return 0;
-}
-
 static int char_array_to_timespec(u8 *buf,
 				  u8 count,
 				  struct timespec64 *ts)
@@ -1382,16 +1372,8 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 
 		if (err)
 			return err;
-
-		channel->write_phase_ready = 0;
-
-		ptp_schedule_worker(channel->ptp_clock,
-				    msecs_to_jiffies(WR_PHASE_SETUP_MS));
 	}
 
-	if (!channel->write_phase_ready)
-		delta_ns = 0;
-
 	offset_ps = (s64)delta_ns * 1000;
 
 	/*
@@ -1971,7 +1953,6 @@ static const struct ptp_clock_info idtcm_caps_v487 = {
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime_v487,
 	.enable		= &idtcm_enable,
-	.do_aux_work	= &set_write_phase_ready,
 };
 
 static const struct ptp_clock_info idtcm_caps = {
@@ -1984,7 +1965,6 @@ static const struct ptp_clock_info idtcm_caps = {
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime,
 	.enable		= &idtcm_enable,
-	.do_aux_work	= &set_write_phase_ready,
 };
 
 static int configure_channel_pll(struct idtcm_channel *channel)
@@ -2154,8 +2134,6 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	if (!channel->ptp_clock)
 		return -ENOTSUPP;
 
-	channel->write_phase_ready = 0;
-
 	dev_info(&idtcm->client->dev, "PLL%d registered as ptp%d\n",
 		 index, channel->ptp_clock->index);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 713e41a..dd3436e 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -125,7 +125,6 @@ struct idtcm_channel {
 	enum pll_mode		pll_mode;
 	u8			pll;
 	u16			output_mask;
-	int			write_phase_ready;
 };
 
 struct idtcm {
-- 
2.7.4

