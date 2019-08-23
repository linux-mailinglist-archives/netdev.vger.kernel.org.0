Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E980E9AB57
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbfHWJ3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:29:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732010AbfHWJ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:29:35 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9Ri39029234
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:29:34 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ujd4ph1qu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:29:34 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:29:32 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:29:29 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9TRRD40632420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:29:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 585434C04A;
        Fri, 23 Aug 2019 09:29:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 112CA4C040;
        Fri, 23 Aug 2019 09:29:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 09:29:26 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] s390/qeth: reject oversized SNMP requests
Date:   Fri, 23 Aug 2019 11:29:23 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19082309-0016-0000-0000-000002A21518
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-0017-0000-0000-00003302525E
Message-Id: <20190823092923.8507-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d4c08afafa04 ("s390/qeth: streamline SNMP cmd code") removed
the bounds checking for req_len, under the assumption that the check in
qeth_alloc_cmd() would suffice.

But that code path isn't sufficiently robust to handle a user-provided
data_length, which could overflow (when adding the cmd header overhead)
before being checked against QETH_BUFSIZE. We end up allocating just a
tiny iob, and the subsequent copy_from_user() writes past the end of
that iob.

Special-case this path and add a coarse bounds check, to protect against
maliciuous requests. This let's the subsequent code flow do its normal
job and precise checking, without risk of overflow.

Fixes: d4c08afafa04 ("s390/qeth: streamline SNMP cmd code")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9c3310c4d61d..6502b148541e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4374,6 +4374,10 @@ static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	    get_user(req_len, &ureq->hdr.req_len))
 		return -EFAULT;
 
+	/* Sanitize user input, to avoid overflows in iob size calculation: */
+	if (req_len > QETH_BUFSIZE)
+		return -EINVAL;
+
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_SNMP_CONTROL, req_len);
 	if (!iob)
 		return -ENOMEM;
-- 
2.17.1

