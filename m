Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C592B69AA
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgKQQPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13978 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727200AbgKQQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:38 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG1nbP029980;
        Tue, 17 Nov 2020 11:15:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=p7kvfNPtIKFvS+9MN3ts/5Woo8xHnPl9XHbsVlbikrk=;
 b=s9lW/bIwx+8tTaSQUXuQ0xkHjDttvSuvaYGs13fWunfy50oX34+X3bX3vRUaFsawvu03
 uoR1WIW81i8v0CJoMXnJsFkYLVt2tBeIjpv5YYKkwqYFKt+gx8PHryH4X8PASRCOvtG0
 UrIGRNiFKiHmimIl9t2gptM1q/IBEXfO7uR+p2f22L/irK8j9/98Vl1RnPbBqC3r4w15
 FcW1Nt0rxnK3z+v9LdLDe7sofsN6bzbCCQ5OqC7wdHB2b4qfRKqRpbRZhtsPFvKtDJ4Z
 WtLwS8XdlNC/ZRixowAG362zR2vvkA6uSKnUoKz2j3+Pi+HafKZ7todDTAehO86xyOll qw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vbvqvxqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:32 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8P3O001798;
        Tue, 17 Nov 2020 16:15:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh3a4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFRHo9437800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3656FA405F;
        Tue, 17 Nov 2020 16:15:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF7F6A4067;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/9] s390/qeth: tolerate error when querying card info
Date:   Tue, 17 Nov 2020 17:15:15 +0100
Message-Id: <20201117161520.1089-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By the time that our .get_link_ksettings() code issues a QUERY CARD INFO
cmd to get link-related information, we already set up a good amount of
static link data.

Return this data when the cmd fails, same as when the cmd is not
supported.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_ethtool.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index b5caa723326e..b843df2c14b1 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -413,7 +413,6 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 	struct qeth_card *card = netdev->ml_priv;
 	enum qeth_link_types link_type;
 	struct carrier_info carrier_info;
-	int rc;
 
 	if (IS_IQD(card) || IS_VM_NIC(card))
 		link_type = QETH_LINK_TYPE_10GBIT_ETH;
@@ -455,12 +454,8 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 	/* Check if we can obtain more accurate information.	 */
 	/* If QUERY_CARD_INFO command is not supported or fails, */
 	/* just return the heuristics that was filled above.	 */
-	rc = qeth_query_card_info(card, &carrier_info);
-	if (rc == -EOPNOTSUPP) /* for old hardware, return heuristic */
+	if (qeth_query_card_info(card, &carrier_info))
 		return 0;
-	if (rc) /* report error from the hardware operation */
-		return rc;
-	/* on success, fill in the information got from the hardware */
 
 	netdev_dbg(netdev,
 	"card info: card_type=0x%02x, port_mode=0x%04x, port_speed=0x%08x\n",
-- 
2.17.1

