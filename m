Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558FE1C5D77
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgEEQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730681AbgEEQ0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:12 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045G767P097078;
        Tue, 5 May 2020 12:26:10 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v88as4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:09 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GK6RQ017360;
        Tue, 5 May 2020 16:26:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 30s0g5b09x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GQ4lf12124502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:26:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFE2942045;
        Tue,  5 May 2020 16:26:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9706242041;
        Tue,  5 May 2020 16:26:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:04 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 10/11] s390/qeth: allow reset via ethtool
Date:   Tue,  5 May 2020 18:25:58 +0200
Message-Id: <20200505162559.14138-11-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505162559.14138-1-jwi@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .reset callback. Only a full reset is supported.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_ethtool.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index ebdc03210608..0d12002d0615 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -193,6 +193,21 @@ static void qeth_get_drvinfo(struct net_device *dev,
 		 CARD_RDEV_ID(card), CARD_WDEV_ID(card), CARD_DDEV_ID(card));
 }
 
+static int qeth_reset(struct net_device *dev, u32 *flags)
+{
+	struct qeth_card *card = dev->ml_priv;
+	int rc;
+
+	if (*flags != ETH_RESET_ALL)
+		return -EINVAL;
+
+	rc = qeth_schedule_recovery(card);
+	if (!rc)
+		*flags = 0;
+
+	return rc;
+}
+
 static void qeth_get_channels(struct net_device *dev,
 			      struct ethtool_channels *channels)
 {
@@ -522,6 +537,7 @@ const struct ethtool_ops qeth_ethtool_ops = {
 	.get_ethtool_stats = qeth_get_ethtool_stats,
 	.get_sset_count = qeth_get_sset_count,
 	.get_drvinfo = qeth_get_drvinfo,
+	.reset = qeth_reset,
 	.get_channels = qeth_get_channels,
 	.set_channels = qeth_set_channels,
 	.get_ts_info = qeth_get_ts_info,
-- 
2.17.1

