Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBD7275365
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgIWIhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWIhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:11 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8YijS066421;
        Wed, 23 Sep 2020 04:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=lKAg+vZLBn/XKDEv/N+WYOYj9B6nu7llT8wFkNd1pvg=;
 b=jYnhbeiFM2MzCAjTVJSnyen1RL6G0QoWbZ3vWoSHaolRaUzvUjxM5JM7y9g/jDQtseXD
 2HgTHL4r+aAE5kaccqL2TFw7EWqJEsdeeqpfxZZMjykL9hoWbdweaB42nTGXYjmBD8lO
 062VCv4dSyvfY8zPOVOFXQr812/guD1Qg2LyjkDSe+KTJv85VqadFVsfd04wou6hcujN
 CRz0LQKBQRBggtJuZ589w/AS51BxliQ6xMjS1APaEcG2RJCxMksGg4HEtj236Y4p1m4+
 gb4wPIxq2h1GE8GBbn///ATn84qLmMN8e/FQyclItze3BarELqAeu2f4PVbRXx8xf3KT Fw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r29x9chq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:09 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8W0fP016508;
        Wed, 23 Sep 2020 08:37:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 33n9m7t1w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b4cG30409094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 282AB11C04A;
        Wed, 23 Sep 2020 08:37:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5F1311C054;
        Wed, 23 Sep 2020 08:37:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:03 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/9] s390/qeth: clean up string ops in qeth_l3_parse_ipatoe()
Date:   Wed, 23 Sep 2020 10:36:54 +0200
Message-Id: <20200923083700.44624-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indicate the max number of to-be-parsed characters, and avoid copying
the address sub-string.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_sys.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index ca9c95b6bf35..05fa986e30fc 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -409,21 +409,22 @@ static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
 static int qeth_l3_parse_ipatoe(const char *buf, enum qeth_prot_versions proto,
 		  u8 *addr, int *mask_bits)
 {
-	const char *start, *end;
-	char *tmp;
-	char buffer[40] = {0, };
+	const char *start;
+	char *sep, *tmp;
+	int rc;
 
-	start = buf;
-	/* get address string */
-	end = strchr(start, '/');
-	if (!end || (end - start >= 40)) {
+	/* Expected input pattern: %addr/%mask */
+	sep = strnchr(buf, 40, '/');
+	if (!sep)
 		return -EINVAL;
-	}
-	strncpy(buffer, start, end - start);
-	if (qeth_l3_string_to_ipaddr(buffer, proto, addr)) {
-		return -EINVAL;
-	}
-	start = end + 1;
+
+	/* Terminate the %addr sub-string, and parse it: */
+	*sep = '\0';
+	rc = qeth_l3_string_to_ipaddr(buf, proto, addr);
+	if (rc)
+		return rc;
+
+	start = sep + 1;
 	*mask_bits = simple_strtoul(start, &tmp, 10);
 	if (!strlen(start) ||
 	    (tmp == start) ||
-- 
2.17.1

