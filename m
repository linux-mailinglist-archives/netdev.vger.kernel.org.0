Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33861166026
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgBTOzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:55:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728264AbgBTOzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 09:55:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KEnTx5030781
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 09:55:09 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8ubyn8ht-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 09:55:09 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 20 Feb 2020 14:55:07 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 14:55:04 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KEt3lZ14745830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 14:55:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D708AE045;
        Thu, 20 Feb 2020 14:55:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC2CAAE04D;
        Thu, 20 Feb 2020 14:55:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 14:55:02 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/3] s390/qeth: fix off-by-one in RX copybreak check
Date:   Thu, 20 Feb 2020 15:54:56 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200220145456.11571-1-jwi@linux.ibm.com>
References: <20200220145456.11571-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20022014-0012-0000-0000-00000388A68A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022014-0013-0000-0000-000021C53DBE
Message-Id: <20200220145456.11571-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_04:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=907
 spamscore=0 suspectscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX copybreak is intended as the _max_ value where the frame's data
should be copied. So for frame_len == copybreak, don't build an SG skb.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 2264c6619def..5efcaa43615b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5344,7 +5344,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 	}
 
 	use_rx_sg = (card->options.cq == QETH_CQ_ENABLED) ||
-		    ((skb_len >= card->options.rx_sg_cb) &&
+		    (skb_len > card->options.rx_sg_cb &&
 		     !atomic_read(&card->force_alloc_skb) &&
 		     !IS_OSN(card));
 
-- 
2.17.1

