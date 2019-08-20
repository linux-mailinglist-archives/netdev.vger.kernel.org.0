Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8235C962CA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfHTOrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:47:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730334AbfHTOrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:47:01 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEXou7127239
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:47:00 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ugh4mx8g1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:47:00 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:56 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:54 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEkqBG42795018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8857711C05B;
        Tue, 20 Aug 2019 14:46:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B56F11C058;
        Tue, 20 Aug 2019 14:46:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 14:46:52 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/9] s390/qeth: get vnicc sub-cmd type from reply data
Date:   Tue, 20 Aug 2019 16:46:40 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820144643.64041-1-jwi@linux.ibm.com>
References: <20190820144643.64041-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082014-0016-0000-0000-000002A0BC84
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0017-0000-0000-00003300EC66
Message-Id: <20190820144643.64041-7-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing the reply for a vnicc cmd, there's no need to remember
which specific sub-cmd type we initially sent. The reply itself contains
all the needed information.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index ad7ee3bfd63c..1f534f489a79 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1704,7 +1704,6 @@ static int qeth_l2_vnicc_makerc(struct qeth_card *card, u16 ipa_rc)
 
 /* generic VNICC request call back control */
 struct _qeth_l2_vnicc_request_cbctl {
-	u32 sub_cmd;
 	struct {
 		union{
 			u32 *sup_cmds;
@@ -1722,6 +1721,7 @@ static int qeth_l2_vnicc_request_cb(struct qeth_card *card,
 		(struct _qeth_l2_vnicc_request_cbctl *) reply->param;
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
 	struct qeth_ipacmd_vnicc *rep = &cmd->data.vnicc;
+	u32 sub_cmd = cmd->data.vnicc.hdr.sub_command;
 
 	QETH_CARD_TEXT(card, 2, "vniccrcb");
 	if (cmd->hdr.return_code)
@@ -1730,10 +1730,9 @@ static int qeth_l2_vnicc_request_cb(struct qeth_card *card,
 	card->options.vnicc.sup_chars = rep->vnicc_cmds.supported;
 	card->options.vnicc.cur_chars = rep->vnicc_cmds.enabled;
 
-	if (cbctl->sub_cmd == IPA_VNICC_QUERY_CMDS)
+	if (sub_cmd == IPA_VNICC_QUERY_CMDS)
 		*cbctl->result.sup_cmds = rep->data.query_cmds.sup_cmds;
-
-	if (cbctl->sub_cmd == IPA_VNICC_GET_TIMEOUT)
+	else if (sub_cmd == IPA_VNICC_GET_TIMEOUT)
 		*cbctl->result.timeout = rep->data.getset_timeout.timeout;
 
 	return 0;
@@ -1761,7 +1760,6 @@ static struct qeth_cmd_buffer *qeth_l2_vnicc_build_cmd(struct qeth_card *card,
 /* VNICC query VNIC characteristics request */
 static int qeth_l2_vnicc_query_chars(struct qeth_card *card)
 {
-	struct _qeth_l2_vnicc_request_cbctl cbctl;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "vniccqch");
@@ -1769,10 +1767,7 @@ static int qeth_l2_vnicc_query_chars(struct qeth_card *card)
 	if (!iob)
 		return -ENOMEM;
 
-	/* prepare callback control */
-	cbctl.sub_cmd = IPA_VNICC_QUERY_CHARS;
-
-	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, &cbctl);
+	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, NULL);
 }
 
 /* VNICC query sub commands request */
@@ -1791,7 +1786,6 @@ static int qeth_l2_vnicc_query_cmds(struct qeth_card *card, u32 vnic_char,
 	__ipa_cmd(iob)->data.vnicc.data.query_cmds.vnic_char = vnic_char;
 
 	/* prepare callback control */
-	cbctl.sub_cmd = IPA_VNICC_QUERY_CMDS;
 	cbctl.result.sup_cmds = sup_cmds;
 
 	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, &cbctl);
@@ -1801,7 +1795,6 @@ static int qeth_l2_vnicc_query_cmds(struct qeth_card *card, u32 vnic_char,
 static int qeth_l2_vnicc_set_char(struct qeth_card *card, u32 vnic_char,
 				      u32 cmd)
 {
-	struct _qeth_l2_vnicc_request_cbctl cbctl;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "vniccedc");
@@ -1811,10 +1804,7 @@ static int qeth_l2_vnicc_set_char(struct qeth_card *card, u32 vnic_char,
 
 	__ipa_cmd(iob)->data.vnicc.data.set_char.vnic_char = vnic_char;
 
-	/* prepare callback control */
-	cbctl.sub_cmd = cmd;
-
-	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, &cbctl);
+	return qeth_send_ipa_cmd(card, iob, qeth_l2_vnicc_request_cb, NULL);
 }
 
 /* VNICC get/set timeout for characteristic request */
@@ -1838,7 +1828,6 @@ static int qeth_l2_vnicc_getset_timeout(struct qeth_card *card, u32 vnicc,
 		getset_timeout->timeout = *timeout;
 
 	/* prepare callback control */
-	cbctl.sub_cmd = cmd;
 	if (cmd == IPA_VNICC_GET_TIMEOUT)
 		cbctl.result.timeout = timeout;
 
-- 
2.17.1

