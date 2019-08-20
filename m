Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA0E962CD
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfHTOrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:47:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730341AbfHTOrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:47:01 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEXoku098335
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:47:00 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ugh7f60xa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:47:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:58 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:55 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEkrkm43188340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:53 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72BFC11C04C;
        Tue, 20 Aug 2019 14:46:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 351B011C058;
        Tue, 20 Aug 2019 14:46:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 14:46:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 9/9] s390/lcs: don't use intparm for channel IO
Date:   Tue, 20 Aug 2019 16:46:43 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820144643.64041-1-jwi@linux.ibm.com>
References: <20190820144643.64041-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082014-0012-0000-0000-00000340BBCE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0013-0000-0000-0000217AE052
Message-Id: <20190820144643.64041-10-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=906 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lcs passes an intparm when calling ccw_device_*(), even though lcs_irq()
later makes no use of this.

To reduce the confusion, consistently pass 0 as intparm instead.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
---
 drivers/s390/net/lcs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 2d9fe7e4ee40..8f08b0a2917c 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -504,7 +504,7 @@ lcs_clear_channel(struct lcs_channel *channel)
 	LCS_DBF_TEXT(4,trace,"clearch");
 	LCS_DBF_TEXT_(4, trace, "%s", dev_name(&channel->ccwdev->dev));
 	spin_lock_irqsave(get_ccwdev_lock(channel->ccwdev), flags);
-	rc = ccw_device_clear(channel->ccwdev, (addr_t) channel);
+	rc = ccw_device_clear(channel->ccwdev, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(channel->ccwdev), flags);
 	if (rc) {
 		LCS_DBF_TEXT_(4, trace, "ecsc%s",
@@ -532,7 +532,7 @@ lcs_stop_channel(struct lcs_channel *channel)
 	LCS_DBF_TEXT_(4, trace, "%s", dev_name(&channel->ccwdev->dev));
 	channel->state = LCS_CH_STATE_INIT;
 	spin_lock_irqsave(get_ccwdev_lock(channel->ccwdev), flags);
-	rc = ccw_device_halt(channel->ccwdev, (addr_t) channel);
+	rc = ccw_device_halt(channel->ccwdev, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(channel->ccwdev), flags);
 	if (rc) {
 		LCS_DBF_TEXT_(4, trace, "ehsc%s",
@@ -1427,7 +1427,7 @@ lcs_irq(struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 		channel->state = LCS_CH_STATE_SUSPENDED;
 	if (irb->scsw.cmd.fctl & SCSW_FCTL_HALT_FUNC) {
 		if (irb->scsw.cmd.cc != 0) {
-			ccw_device_halt(channel->ccwdev, (addr_t) channel);
+			ccw_device_halt(channel->ccwdev, 0);
 			return;
 		}
 		/* The channel has been stopped by halt_IO. */
-- 
2.17.1

