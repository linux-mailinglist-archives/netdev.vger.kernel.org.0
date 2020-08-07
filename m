Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05A023F05E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 18:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgHGQBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 12:01:41 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:53882 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgHGQBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 12:01:40 -0400
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Aug 2020 12:01:39 EDT
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 077FvuCS005868;
        Fri, 7 Aug 2020 11:58:28 -0400
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 32n2jctr77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 11:58:27 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Fri, 7 Aug 2020 11:58:26 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 7 Aug 2020 11:58:26 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 3/4] ptp: ptp_idt82p33: use do_aux_work for delay work
Date:   Fri, 7 Aug 2020 11:58:05 -0400
Message-ID: <1596815885-11094-1-git-send-email-min.li.xe@renesas.com>
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

Instead of declaring its own delay_work, use ptp_clock provided do_aux_work
to configure sync_tod.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 24 ++++++++++++------------
 drivers/ptp/ptp_idt82p33.h |  2 --
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index 189bb81..2d62aed 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -531,8 +531,8 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 
 	if (enable == channel->sync_tod_on) {
 		if (enable && sync_tod_timeout) {
-			mod_delayed_work(system_wq, &channel->sync_tod_work,
-					 sync_tod_timeout * HZ);
+			ptp_schedule_worker(channel->ptp_clock,
+					    sync_tod_timeout * HZ);
 		}
 		return 0;
 	}
@@ -555,24 +555,27 @@ static int idt82p33_sync_tod(struct idt82p33_channel *channel, bool enable)
 	channel->sync_tod_on = enable;
 
 	if (enable && sync_tod_timeout) {
-		mod_delayed_work(system_wq, &channel->sync_tod_work,
-				 sync_tod_timeout * HZ);
+		ptp_schedule_worker(channel->ptp_clock,
+				    sync_tod_timeout * HZ);
 	}
 
 	return 0;
 }
 
-static void idt82p33_sync_tod_work_handler(struct work_struct *work)
+static long idt82p33_sync_tod_work_handler(struct ptp_clock_info *ptp)
 {
 	struct idt82p33_channel *channel =
-		container_of(work, struct idt82p33_channel, sync_tod_work.work);
+			container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
+	int ret;
 
 	mutex_lock(&idt82p33->reg_lock);
 
-	(void)idt82p33_sync_tod(channel, false);
+	ret = idt82p33_sync_tod(channel, false);
 
 	mutex_unlock(&idt82p33->reg_lock);
+
+	return ret;
 }
 
 static int idt82p33_pps_enable(struct idt82p33_channel *channel, bool enable)
@@ -659,10 +662,8 @@ static void idt82p33_ptp_clock_unregister_all(struct idt82p33 *idt82p33)
 
 		channel = &idt82p33->channel[i];
 
-		if (channel->ptp_clock) {
+		if (channel->ptp_clock)
 			ptp_clock_unregister(channel->ptp_clock);
-			cancel_delayed_work_sync(&channel->sync_tod_work);
-		}
 	}
 }
 
@@ -862,8 +863,6 @@ static int idt82p33_channel_init(struct idt82p33_channel *channel, int index)
 		return -EINVAL;
 	}
 
-	INIT_DELAYED_WORK(&channel->sync_tod_work,
-			  idt82p33_sync_tod_work_handler);
 	channel->sync_tod_on = false;
 	channel->current_freq_ppb = 0;
 
@@ -881,6 +880,7 @@ static void idt82p33_caps_init(struct ptp_clock_info *caps)
 	caps->gettime64 = idt82p33_gettime;
 	caps->settime64 = idt82p33_settime;
 	caps->enable = idt82p33_enable;
+	caps->do_aux_work = idt82p33_sync_tod_work_handler;
 }
 
 static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 9d46966..1dcd2c0 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -119,8 +119,6 @@ struct idt82p33_channel {
 	struct ptp_clock	*ptp_clock;
 	struct idt82p33	*idt82p33;
 	enum pll_mode	pll_mode;
-	/* task to turn off SYNC_TOD bit after pps sync */
-	struct delayed_work	sync_tod_work;
 	bool			sync_tod_on;
 	s32			current_freq_ppb;
 	u8			output_mask;
-- 
2.7.4

