Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2033D273
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405620AbfFKQiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405611AbfFKQiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:15 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGWPp2008520
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:14 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2ecpwkkm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:14 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:12 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:10 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc9LH26345586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC69F4C052;
        Tue, 11 Jun 2019 16:38:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EBC54C044;
        Tue, 11 Jun 2019 16:38:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 11/13] s390/qeth: convert RCD code to common IO infrastructure
Date:   Tue, 11 Jun 2019 18:37:58 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0008-0000-0000-000002F2611C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0009-0000-0000-0000225F5DB8
Message-Id: <20190611163800.64730-12-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RCD code is the last remaining IO path that doesn't use the
qeth_send_control_data() infrastructure. Doing so allows us to remove
all sorts of custom state machinery and logic in the IRQ handler.

Instead of introducing statically allocated cmd buffers for this single
IO on the data channel, use the new qeth_alloc_cmd() helper.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |   2 -
 drivers/s390/net/qeth_core_main.c | 132 +++++++++++-------------------
 drivers/s390/net/qeth_core_mpc.h  |   2 -
 3 files changed, 46 insertions(+), 90 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 2fee41f773a1..962945a63235 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -537,8 +537,6 @@ enum qeth_channel_states {
 	CH_STATE_DOWN,
 	CH_STATE_HALTED,
 	CH_STATE_STOPPED,
-	CH_STATE_RCD,
-	CH_STATE_RCD_DONE,
 };
 /**
  * card state machine
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e95cfc654ff8..671754a0e591 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1004,7 +1004,7 @@ static int qeth_get_problem(struct qeth_card *card, struct ccw_device *cdev,
 }
 
 static int qeth_check_irb_error(struct qeth_card *card, struct ccw_device *cdev,
-				unsigned long intparm, struct irb *irb)
+				struct irb *irb)
 {
 	if (!IS_ERR(irb))
 		return 0;
@@ -1021,12 +1021,6 @@ static int qeth_check_irb_error(struct qeth_card *card, struct ccw_device *cdev,
 			" on the device\n");
 		QETH_CARD_TEXT(card, 2, "ckirberr");
 		QETH_CARD_TEXT_(card, 2, "  rc%d", -ETIMEDOUT);
-		if (intparm == QETH_RCD_PARM) {
-			if (card->data.ccwdev == cdev) {
-				card->data.state = CH_STATE_DOWN;
-				wake_up(&card->wait_q);
-			}
-		}
 		return -ETIMEDOUT;
 	default:
 		QETH_DBF_MESSAGE(2, "unknown error %ld on channel %x\n",
@@ -1069,7 +1063,7 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 	if (qeth_intparm_is_iob(intparm))
 		iob = (struct qeth_cmd_buffer *) __va((addr_t)intparm);
 
-	rc = qeth_check_irb_error(card, cdev, intparm, irb);
+	rc = qeth_check_irb_error(card, cdev, irb);
 	if (rc) {
 		/* IO was terminated, free its resources. */
 		if (iob)
@@ -1087,11 +1081,6 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 	if (irb->scsw.cmd.fctl & (SCSW_FCTL_HALT_FUNC))
 		channel->state = CH_STATE_HALTED;
 
-	/*let's wake up immediately on data channel*/
-	if ((channel == &card->data) && (intparm != 0) &&
-	    (intparm != QETH_RCD_PARM))
-		goto out;
-
 	if (intparm == QETH_CLEAR_CHANNEL_PARM) {
 		QETH_CARD_TEXT(card, 6, "clrchpar");
 		/* we don't have to handle this further */
@@ -1121,10 +1110,7 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 			print_hex_dump(KERN_WARNING, "qeth: sense data ",
 				DUMP_PREFIX_OFFSET, 16, 1, irb->ecw, 32, 1);
 		}
-		if (intparm == QETH_RCD_PARM) {
-			channel->state = CH_STATE_DOWN;
-			goto out;
-		}
+
 		rc = qeth_get_problem(card, cdev, irb);
 		if (rc) {
 			card->read_or_write_problem = 1;
@@ -1136,13 +1122,6 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		}
 	}
 
-	if (intparm == QETH_RCD_PARM) {
-		channel->state = CH_STATE_RCD_DONE;
-		goto out;
-	}
-	if (channel == &card->data)
-		return;
-
 	if (iob && iob->callback)
 		iob->callback(card, iob);
 
@@ -1606,62 +1585,6 @@ int qeth_qdio_clear_card(struct qeth_card *card, int use_halt)
 }
 EXPORT_SYMBOL_GPL(qeth_qdio_clear_card);
 
-static int qeth_read_conf_data(struct qeth_card *card, void **buffer,
-			       int *length)
-{
-	struct ciw *ciw;
-	char *rcd_buf;
-	int ret;
-	struct qeth_channel *channel = &card->data;
-
-	/*
-	 * scan for RCD command in extended SenseID data
-	 */
-	ciw = ccw_device_get_ciw(channel->ccwdev, CIW_TYPE_RCD);
-	if (!ciw || ciw->cmd == 0)
-		return -EOPNOTSUPP;
-	rcd_buf = kzalloc(ciw->count, GFP_KERNEL | GFP_DMA);
-	if (!rcd_buf)
-		return -ENOMEM;
-
-	qeth_setup_ccw(channel->ccw, ciw->cmd, 0, ciw->count, rcd_buf);
-	channel->state = CH_STATE_RCD;
-	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
-	ret = ccw_device_start_timeout(channel->ccwdev, channel->ccw,
-				       QETH_RCD_PARM, LPM_ANYPATH, 0,
-				       QETH_RCD_TIMEOUT);
-	spin_unlock_irq(get_ccwdev_lock(channel->ccwdev));
-	if (!ret)
-		wait_event(card->wait_q,
-			   (channel->state == CH_STATE_RCD_DONE ||
-			    channel->state == CH_STATE_DOWN));
-	if (channel->state == CH_STATE_DOWN)
-		ret = -EIO;
-	else
-		channel->state = CH_STATE_DOWN;
-	if (ret) {
-		kfree(rcd_buf);
-		*buffer = NULL;
-		*length = 0;
-	} else {
-		*length = ciw->count;
-		*buffer = rcd_buf;
-	}
-	return ret;
-}
-
-static void qeth_configure_unitaddr(struct qeth_card *card, char *prcd)
-{
-	QETH_CARD_TEXT(card, 2, "cfgunit");
-	card->info.chpid = prcd[30];
-	card->info.unit_addr2 = prcd[31];
-	card->info.cula = prcd[63];
-	card->info.is_vm_nic = ((prcd[0x10] == _ascebc['V']) &&
-				(prcd[0x11] == _ascebc['M']));
-	card->info.use_v1_blkt = prcd[74] == 0xF0 && prcd[75] == 0xF0 &&
-				 prcd[76] >= 0xF1 && prcd[76] <= 0xF4;
-}
-
 static enum qeth_discipline_id qeth_vm_detect_layer(struct qeth_card *card)
 {
 	enum qeth_discipline_id disc = QETH_DISCIPLINE_UNDETERMINED;
@@ -1888,7 +1811,8 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 		return (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 	}
 
-	iob->finalize(card, iob, len);
+	if (iob->finalize)
+		iob->finalize(card, iob, len);
 	QETH_DBF_HEX(CTRL, 2, iob->data, min(len, QETH_DBF_CTRL_LEN));
 
 	qeth_enqueue_reply(card, reply);
@@ -1922,6 +1846,46 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 	return rc;
 }
 
+static void qeth_read_conf_data_cb(struct qeth_card *card,
+				   struct qeth_cmd_buffer *iob)
+{
+	unsigned char *prcd = iob->data;
+
+	QETH_CARD_TEXT(card, 2, "cfgunit");
+	card->info.chpid = prcd[30];
+	card->info.unit_addr2 = prcd[31];
+	card->info.cula = prcd[63];
+	card->info.is_vm_nic = ((prcd[0x10] == _ascebc['V']) &&
+				(prcd[0x11] == _ascebc['M']));
+	card->info.use_v1_blkt = prcd[74] == 0xF0 && prcd[75] == 0xF0 &&
+				 prcd[76] >= 0xF1 && prcd[76] <= 0xF4;
+
+	qeth_notify_reply(iob->reply, 0);
+	qeth_release_buffer(iob);
+}
+
+static int qeth_read_conf_data(struct qeth_card *card)
+{
+	struct qeth_channel *channel = &card->data;
+	struct qeth_cmd_buffer *iob;
+	struct ciw *ciw;
+
+	/* scan for RCD command in extended SenseID data */
+	ciw = ccw_device_get_ciw(channel->ccwdev, CIW_TYPE_RCD);
+	if (!ciw || ciw->cmd == 0)
+		return -EOPNOTSUPP;
+
+	iob = qeth_alloc_cmd(channel, ciw->count, 1, QETH_RCD_TIMEOUT);
+	if (!iob)
+		return -ENOMEM;
+
+	iob->callback = qeth_read_conf_data_cb;
+	qeth_setup_ccw(__ccw_from_cmd(iob), ciw->cmd, 0, iob->length,
+		       iob->data);
+
+	return qeth_send_control_data(card, iob->length, iob, NULL, NULL);
+}
+
 static int qeth_idx_check_activate_response(struct qeth_card *card,
 					    struct qeth_channel *channel,
 					    struct qeth_cmd_buffer *iob)
@@ -4772,8 +4736,6 @@ EXPORT_SYMBOL_GPL(qeth_vm_request_mac);
 static void qeth_determine_capabilities(struct qeth_card *card)
 {
 	int rc;
-	int length;
-	char *prcd;
 	struct ccw_device *ddev;
 	int ddev_offline = 0;
 
@@ -4788,15 +4750,13 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 		}
 	}
 
-	rc = qeth_read_conf_data(card, (void **) &prcd, &length);
+	rc = qeth_read_conf_data(card);
 	if (rc) {
 		QETH_DBF_MESSAGE(2, "qeth_read_conf_data on device %x returned %i\n",
 				 CARD_DEVID(card), rc);
 		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
 		goto out_offline;
 	}
-	qeth_configure_unitaddr(card, prcd);
-	kfree(prcd);
 
 	rc = qdio_get_ssqd_desc(ddev, &card->ssqd);
 	if (rc)
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index f5237b7c14c4..fadafdc0e8e4 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -31,14 +31,12 @@ extern unsigned char IPA_PDU_HEADER[];
 
 #define QETH_CLEAR_CHANNEL_PARM	-10
 #define QETH_HALT_CHANNEL_PARM	-11
-#define QETH_RCD_PARM -12
 
 static inline bool qeth_intparm_is_iob(unsigned long intparm)
 {
 	switch (intparm) {
 	case QETH_CLEAR_CHANNEL_PARM:
 	case QETH_HALT_CHANNEL_PARM:
-	case QETH_RCD_PARM:
 	case 0:
 		return false;
 	}
-- 
2.17.1

