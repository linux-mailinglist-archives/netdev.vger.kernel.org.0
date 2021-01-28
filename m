Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3795D3074C2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhA1L1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:27:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231398AbhA1L0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:26:44 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SB2xt6030137;
        Thu, 28 Jan 2021 06:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=HtfjBSdKgUAQnx8CdWt6IqKhsxHbr3A8jfNf9eobdao=;
 b=fCnmi+6fBJVEm0MLQdB9wAmeO52z/tAvAwvhvT77axZouqUV8MafRRWFXxx+MHuYltym
 BJjSgAswHB/AVgJInrREBRx6oJl0osb5AlRP/TMIiRQC/QJ2uNfXnCh2VuYzQGXAO9i9
 tBM5qsJyX3tNzGL3dpX7fzKEdDQ9fx/7dyKYMGnDV/lfk8aa98Q+5y9Xf+bRHMNQLJBW
 3VV0Mt1M/KxITiCfJJUL+/ZX5G89ZvVx2H9gibjgQekqqxDaEYOeA1Y/aDdQrerhWUg1
 IytFdtRgqjVDSiUBZ1xHL63Qw3p42Dl+5kzwO7EtrBbLA7hmstc1lFeRelzveTub+gFJ pw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bs2ax373-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:26:02 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBN9iJ001667;
        Thu, 28 Jan 2021 11:25:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 369jjshsp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:25:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBPu2A40370556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:25:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCB2E42041;
        Thu, 28 Jan 2021 11:25:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C8C142049;
        Thu, 28 Jan 2021 11:25:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:25:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/5] s390/qeth: pass proto to qeth_l3_get_cast_type()
Date:   Thu, 28 Jan 2021 12:25:49 +0100
Message-Id: <20210128112551.18780-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128112551.18780-1-jwi@linux.ibm.com>
References: <20210128112551.18780-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_l3_hard_start_xmit() already determined the skb's proto. Avoid
doing so a second time when it calls qeth_l3_get_cast_type().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 7a7465376e29..4921afb51a1c 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1610,9 +1610,8 @@ static int qeth_l3_get_cast_type_rcu(struct sk_buff *skb, struct dst_entry *dst,
 	}
 }
 
-static int qeth_l3_get_cast_type(struct sk_buff *skb)
+static int qeth_l3_get_cast_type(struct sk_buff *skb, __be16 proto)
 {
-	__be16 proto = vlan_get_protocol(skb);
 	struct dst_entry *dst;
 	int cast_type;
 
@@ -1771,7 +1770,7 @@ static netdev_tx_t qeth_l3_hard_start_xmit(struct sk_buff *skb,
 	}
 
 	if (!(dev->flags & IFF_BROADCAST) &&
-	    qeth_l3_get_cast_type(skb) == RTN_BROADCAST)
+	    qeth_l3_get_cast_type(skb, proto) == RTN_BROADCAST)
 		goto tx_drop;
 
 	if (proto == htons(ETH_P_IP) || IS_IQD(card))
@@ -1831,8 +1830,10 @@ static netdev_features_t qeth_l3_osa_features_check(struct sk_buff *skb,
 static u16 qeth_l3_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
 				    struct net_device *sb_dev)
 {
-	return qeth_iqd_select_queue(dev, skb, qeth_l3_get_cast_type(skb),
-				     sb_dev);
+	__be16 proto = vlan_get_protocol(skb);
+
+	return qeth_iqd_select_queue(dev, skb,
+				     qeth_l3_get_cast_type(skb, proto), sb_dev);
 }
 
 static u16 qeth_l3_osa_select_queue(struct net_device *dev, struct sk_buff *skb,
-- 
2.17.1

