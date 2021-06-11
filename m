Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD52C3A3D3B
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhFKHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:35:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbhFKHfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:53 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Ws1A015492;
        Fri, 11 Jun 2021 03:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xwhMIQcO55FMq1EqcVhuiBWGR5GHFeaVJwkxgeLpuYo=;
 b=HM+1yQIKCcdcl9ZsfYhOGyFoH+3zNz4fWO41PNPsMe/zAmJr2QjRBUOCKz8JorEnLcOT
 9uPgCt/a0wq9KxTiVpuxDETE4+YZW4ulBzARmlvncnkzus1ysogOdDjwtSsCbMuhcfbZ
 LhWETCXL/eFBmRvtYWFWrm3xlwa8WTJuDmwComEg9FHq38TT5mEsnc6LzdXpuHHUxnkV
 jk6syKa85Clbo8dfhU/UGpf+GM4Z2uO4y8opYSpbq/Wy+CkxPw7Aa1iHY4CiTjveOUX5
 xUdLBcXqt9dEi7oY7IEYT+Kl30/RH3mkhusnWw9k745FfGyXtFEtZ/Tx2VqjZsKwxqKo 5Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39439wgc3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:54 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7XqbE017669;
        Fri, 11 Jun 2021 07:33:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3900hhhtgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7Wv0835651996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:32:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED2A0A4060;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4FFA4068;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/9] s390/qeth: unify the tracking of active cmds on ccw device
Date:   Fri, 11 Jun 2021 09:33:35 +0200
Message-Id: <20210611073341.1634501-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E7Okw0JlzUvXIxQheTY20McyBsjRVgim
X-Proofpoint-ORIG-GUID: E7Okw0JlzUvXIxQheTY20McyBsjRVgim
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have one field to track _whether_ a cmd is active on a ccw device
('irq_pending'), and one to track _which_ cmd it is ('active_cmd').

Get rid of the irq_pending field, by testing active_cmd for NULL.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 14 +++++++-------
 drivers/s390/net/qeth_core_main.c | 12 ++++--------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 4d29801bcf41..ad0e86aa99b2 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -614,7 +614,6 @@ struct qeth_channel {
 	struct ccw_device *ccwdev;
 	struct qeth_cmd_buffer *active_cmd;
 	enum qeth_channel_states state;
-	atomic_t irq_pending;
 };
 
 struct qeth_reply {
@@ -664,11 +663,6 @@ static inline struct ccw1 *__ccw_from_cmd(struct qeth_cmd_buffer *iob)
 	return (struct ccw1 *)(iob->data + ALIGN(iob->length, 8));
 }
 
-static inline bool qeth_trylock_channel(struct qeth_channel *channel)
-{
-	return atomic_cmpxchg(&channel->irq_pending, 0, 1) == 0;
-}
-
 /**
  *  OSA card related definitions
  */
@@ -896,10 +890,16 @@ static inline bool qeth_use_tx_irqs(struct qeth_card *card)
 static inline void qeth_unlock_channel(struct qeth_card *card,
 				       struct qeth_channel *channel)
 {
-	atomic_set(&channel->irq_pending, 0);
+	xchg(&channel->active_cmd, NULL);
 	wake_up(&card->wait_q);
 }
 
+static inline bool qeth_trylock_channel(struct qeth_channel *channel,
+					struct qeth_cmd_buffer *cmd)
+{
+	return cmpxchg(&channel->active_cmd, NULL, cmd) == NULL;
+}
+
 struct qeth_trap_id {
 	__u16 lparnr;
 	char vmname[8];
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f22f223a4a6c..83d540f8b527 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1268,7 +1268,6 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		iob = (struct qeth_cmd_buffer *) (addr_t)intparm;
 	}
 
-	channel->active_cmd = NULL;
 	qeth_unlock_channel(card, channel);
 
 	rc = qeth_check_irb_error(card, cdev, irb);
@@ -1715,11 +1714,10 @@ static int qeth_stop_channel(struct qeth_channel *channel)
 	rc = ccw_device_set_offline(cdev);
 
 	spin_lock_irq(get_ccwdev_lock(cdev));
-	if (channel->active_cmd) {
+	if (channel->active_cmd)
 		dev_err(&cdev->dev, "Stopped channel while cmd %px was still active\n",
 			channel->active_cmd);
-		channel->active_cmd = NULL;
-	}
+
 	cdev->handler = NULL;
 	spin_unlock_irq(get_ccwdev_lock(cdev));
 
@@ -1732,7 +1730,7 @@ static int qeth_start_channel(struct qeth_channel *channel)
 	int rc;
 
 	channel->state = CH_STATE_DOWN;
-	atomic_set(&channel->irq_pending, 0);
+	xchg(&channel->active_cmd, NULL);
 
 	spin_lock_irq(get_ccwdev_lock(cdev));
 	cdev->handler = qeth_irq;
@@ -2039,7 +2037,7 @@ static int qeth_send_control_data(struct qeth_card *card,
 	reply->param = reply_param;
 
 	timeout = wait_event_interruptible_timeout(card->wait_q,
-						   qeth_trylock_channel(channel),
+						   qeth_trylock_channel(channel, iob),
 						   timeout);
 	if (timeout <= 0) {
 		qeth_put_cmd(iob);
@@ -2059,8 +2057,6 @@ static int qeth_send_control_data(struct qeth_card *card,
 	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
 	rc = ccw_device_start_timeout(channel->ccwdev, __ccw_from_cmd(iob),
 				      (addr_t) iob, 0, 0, timeout);
-	if (!rc)
-		channel->active_cmd = iob;
 	spin_unlock_irq(get_ccwdev_lock(channel->ccwdev));
 	if (rc) {
 		QETH_DBF_MESSAGE(2, "qeth_send_control_data on device %x: ccw_device_start rc = %i\n",
-- 
2.25.1

