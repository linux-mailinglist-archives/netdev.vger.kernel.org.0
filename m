Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE4B3A3D37
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhFKHfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:35:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhFKHfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Wt8K015560;
        Fri, 11 Jun 2021 03:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PxBEazD7AsBMILcXKKpFFo9PYbowUToUjnFo7TBRlr4=;
 b=QJjqhslhwZbVvpDKwv+z4dlCKTYZ0B8VUAJaagQeWira8iIc/DBqUp4hzKpmSSz6lvmX
 kH+xaGhq65TK//8rvSgDOCWYYhHDM8H+1kDOcRhofwG8KxI6ZnjeKC66LS6oiF1BB2PM
 hRnlXlSWltrR/Ujsmo0id5ZAi9jLc2YNVCWpN5L5wu4jGx+59vOr/PrMU+SwPtMJIuPX
 QtUDN9Cu9JGmNeeTm0u3Z+ebnoP66vmwH8zXqnQluJ0fXfv7EbZD6k+IjFt/d83/m+BW
 CAn5WXrZZZYA7oD7YJWtwewbnO/8YNQjMVgwLF247LjZLmX60V5blhVPpTduYMeMKQM4 0g== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39439wgc3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7WqcW007668;
        Fri, 11 Jun 2021 07:33:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 392e798v75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7WrIB35455448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:32:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BC95A4066;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B409A406B;
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
Subject: [PATCH net-next 1/9] s390/qeth: count TX completion interrupts
Date:   Fri, 11 Jun 2021 09:33:33 +0200
Message-Id: <20210611073341.1634501-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EVe-rNQqKkXUrJINvk8pu7Ri6WrFNdBJ
X-Proofpoint-ORIG-GUID: EVe-rNQqKkXUrJINvk8pu7Ri6WrFNdBJ
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

While the qdio layer already tracks the number of HW interrupts for a
device, there's value in understanding how many of them have been
raised due to our TX completion logic.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 1 +
 drivers/s390/net/qeth_core_main.c | 4 +++-
 drivers/s390/net/qeth_ethtool.c   | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index fd9b869d278e..3a49ef8dd906 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -483,6 +483,7 @@ struct qeth_out_q_stats {
 	u64 stopped;
 	u64 doorbell;
 	u64 coal_frames;
+	u64 completion_irq;
 	u64 completion_yield;
 	u64 completion_timer;
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index a1f08e9aa064..9085f22ca34c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1400,8 +1400,10 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	int i;
 
 	/* is PCI flag set on buffer? */
-	if (buf->buffer->element[0].sflags & SBAL_SFLAGS0_PCI_REQ)
+	if (buf->buffer->element[0].sflags & SBAL_SFLAGS0_PCI_REQ) {
 		atomic_dec(&queue->set_pci_flags_count);
+		QETH_TXQ_STAT_INC(queue, completion_irq);
+	}
 
 	qeth_tx_complete_buf(buf, error, budget);
 
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 3a51bbff0ffe..190dac2065df 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -41,6 +41,7 @@ static const struct qeth_stats txq_stats[] = {
 	QETH_TXQ_STAT("Queue stopped", stopped),
 	QETH_TXQ_STAT("Doorbell", doorbell),
 	QETH_TXQ_STAT("IRQ for frames", coal_frames),
+	QETH_TXQ_STAT("Completion IRQ", completion_irq),
 	QETH_TXQ_STAT("Completion yield", completion_yield),
 	QETH_TXQ_STAT("Completion timer", completion_timer),
 };
-- 
2.25.1

