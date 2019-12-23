Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A3F1296C8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLWODv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:03:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbfLWODv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:03:51 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNE3fgS057843
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:03:50 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x21rmdb7n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 09:03:49 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 23 Dec 2019 14:03:34 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Dec 2019 14:03:32 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBNE3VPD46923854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Dec 2019 14:03:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 618A5A4054;
        Mon, 23 Dec 2019 14:03:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F50FA4060;
        Mon, 23 Dec 2019 14:03:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Dec 2019 14:03:31 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/6] s390/qeth: fix false reporting of VNIC CHAR config failure
Date:   Mon, 23 Dec 2019 15:03:23 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191223140326.16488-1-jwi@linux.ibm.com>
References: <20191223140326.16488-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19122314-0012-0000-0000-000003779842
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19122314-0013-0000-0000-000021B39572
Message-Id: <20191223140326.16488-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_06:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Symptom: Error message "Configuring the VNIC characteristics failed"
in dmesg whenever an OSA interface on z15 is set online.

The VNIC characteristics get re-programmed when setting a L2 device
online. This follows the selected 'wanted' characteristics - with the
exception that the INVISIBLE characteristic unconditionally gets
switched off.

For devices that don't support INVISIBLE (ie. OSA), the resulting
IO failure raises a noisy error message
("Configuring the VNIC characteristics failed").
For IQD, INVISIBLE is off by default anyways.

So don't unnecessarily special-case the INVISIBLE characteristic, and
thereby suppress the misleading error message on OSA devices.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 15e2fd65d434..fc5d8ed3a737 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2041,7 +2041,6 @@ static void qeth_l2_vnicc_init(struct qeth_card *card)
 	error |= qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
 					       timeout);
 	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
-	chars_tmp |= QETH_VNICC_BRIDGE_INVISIBLE;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);
-- 
2.17.1

