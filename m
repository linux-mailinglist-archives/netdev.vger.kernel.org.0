Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437385851E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfF0PDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:03:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726443AbfF0PDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:03:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF3eJn064258
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:03:52 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcy0smbqq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:03:49 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:42 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:39 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1cbQ48955596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA931A405F;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1A75A4064;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 08/12] s390/qeth: streamline SNMP cmd code
Date:   Thu, 27 Jun 2019 17:01:29 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0020-0000-0000-0000034E1318
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0021-0000-0000-000021A18ECD
Message-Id: <20190627150133.58746-9-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apply some cleanups to qeth_snmp_command() and its callback:
1. when accessing the user data, use the proper struct instead of
   hard-coded offsets. Also copy the request data straight into the
   allocated cmd, skipping the extra memdup_user() to a tmp buffer.
2. capping the request length is no longer needed, the same check gets
   applied at a base level in qeth_alloc_cmd().
3. clean up some duplicated (and misindented) trace statements.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 49 ++++++++++++-------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3875f70118e4..efb9a27b916e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4320,18 +4320,13 @@ static int qeth_snmp_command_cb(struct qeth_card *card,
 		return -ENOSPC;
 	}
 	QETH_CARD_TEXT_(card, 4, "snore%i",
-		       cmd->data.setadapterparms.hdr.used_total);
+			cmd->data.setadapterparms.hdr.used_total);
 	QETH_CARD_TEXT_(card, 4, "sseqn%i",
-		cmd->data.setadapterparms.hdr.seq_no);
+			cmd->data.setadapterparms.hdr.seq_no);
 	/*copy entries to user buffer*/
 	memcpy(qinfo->udata + qinfo->udata_offset, snmp_data, data_len);
 	qinfo->udata_offset += data_len;
 
-	/* check if all replies received ... */
-		QETH_CARD_TEXT_(card, 4, "srtot%i",
-			       cmd->data.setadapterparms.hdr.used_total);
-		QETH_CARD_TEXT_(card, 4, "srseq%i",
-			       cmd->data.setadapterparms.hdr.seq_no);
 	if (cmd->data.setadapterparms.hdr.seq_no <
 	    cmd->data.setadapterparms.hdr.used_total)
 		return 1;
@@ -4340,9 +4335,8 @@ static int qeth_snmp_command_cb(struct qeth_card *card,
 
 static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 {
+	struct qeth_snmp_ureq __user *ureq;
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd *cmd;
-	struct qeth_snmp_ureq *ureq;
 	unsigned int req_len;
 	struct qeth_arp_query_info qinfo = {0, };
 	int rc = 0;
@@ -4356,34 +4350,28 @@ static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	    IS_LAYER3(card))
 		return -EOPNOTSUPP;
 
-	/* skip 4 bytes (data_len struct member) to get req_len */
-	if (copy_from_user(&req_len, udata + sizeof(int), sizeof(int)))
+	ureq = (struct qeth_snmp_ureq __user *) udata;
+	if (get_user(qinfo.udata_len, &ureq->hdr.data_len) ||
+	    get_user(req_len, &ureq->hdr.req_len))
+		return -EFAULT;
+
+	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_SNMP_CONTROL, req_len);
+	if (!iob)
+		return -ENOMEM;
+
+	if (copy_from_user(&__ipa_cmd(iob)->data.setadapterparms.data.snmp,
+			   &ureq->cmd, req_len)) {
+		qeth_put_cmd(iob);
 		return -EFAULT;
-	if (req_len + offsetof(struct qeth_ipacmd_setadpparms, data) +
-	    offsetof(struct qeth_ipa_cmd, data) + IPA_PDU_HEADER_SIZE >
-	    QETH_BUFSIZE)
-		return -EINVAL;
-	ureq = memdup_user(udata, req_len + sizeof(struct qeth_snmp_ureq_hdr));
-	if (IS_ERR(ureq)) {
-		QETH_CARD_TEXT(card, 2, "snmpnome");
-		return PTR_ERR(ureq);
 	}
-	qinfo.udata_len = ureq->hdr.data_len;
+
 	qinfo.udata = kzalloc(qinfo.udata_len, GFP_KERNEL);
 	if (!qinfo.udata) {
-		kfree(ureq);
+		qeth_put_cmd(iob);
 		return -ENOMEM;
 	}
 	qinfo.udata_offset = sizeof(struct qeth_snmp_ureq_hdr);
 
-	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_SNMP_CONTROL, req_len);
-	if (!iob) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	cmd = __ipa_cmd(iob);
-	memcpy(&cmd->data.setadapterparms.data.snmp, &ureq->cmd, req_len);
 	rc = qeth_send_ipa_cmd(card, iob, qeth_snmp_command_cb, &qinfo);
 	if (rc)
 		QETH_DBF_MESSAGE(2, "SNMP command failed on device %x: (%#x)\n",
@@ -4392,8 +4380,7 @@ static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 		if (copy_to_user(udata, qinfo.udata, qinfo.udata_len))
 			rc = -EFAULT;
 	}
-out:
-	kfree(ureq);
+
 	kfree(qinfo.udata);
 	return rc;
 }
-- 
2.17.1

