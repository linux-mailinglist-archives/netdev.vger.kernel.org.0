Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8797E2ED581
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbhAGRZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:25:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbhAGRZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:25:35 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107H8QYl070236;
        Thu, 7 Jan 2021 12:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=LvuoETH3gMSE0cQfUwQj3zbpBWwtOo8g7TICjxm7DsM=;
 b=GokkWDASicCBb6cAad9HaRpWo1Me4deAACWhm9AB17Bls95YsmddIhDAalcRChnuGewj
 BoSuaCI2su/0wS+hU1zMImxE3WcYCgX0ESUwowxfm5o1j+OWIb7qYtH3RoNMCisnZzWC
 oOEXd1hclOy6hG+kE0xvrSYQD/2kTjerY0DbWpOmqRJPwq4TYMw6GEpIkEe9HouakudY
 ROxFlFGWV+NYhqu+iaySgIfWI50H+GyXiK9PF/t0QZJgtHeMmMf4Mx1NJ6FT5hqD0SZn
 ZaPNJj5mcC2WmJKoqsjjqJX2nHTx82DAReMpH6W/qymEcx2jg+RwGyYWr44LCOXTF8y3 rg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x5juhxgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 12:24:53 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107HChx5006006;
        Thu, 7 Jan 2021 17:24:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 35tgf8d2hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 17:24:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107HOmmQ41288090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 17:24:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8AED42042;
        Thu,  7 Jan 2021 17:24:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78E9742045;
        Thu,  7 Jan 2021 17:24:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 17:24:48 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/3] s390/qeth: fix L2 header access in qeth_l3_osa_features_check()
Date:   Thu,  7 Jan 2021 18:24:42 +0100
Message-Id: <20210107172442.1737-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210107172442.1737-1-jwi@linux.ibm.com>
References: <20210107172442.1737-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_finish_output_gso() may call .ndo_features_check() even before the
skb has a L2 header. This conflicts with qeth_get_ip_version()'s attempt
to inspect the L2 header via vlan_eth_hdr().

Switch to vlan_get_protocol(), as already used further down in the
common qeth_features_check() path.

Fixes: f13ade199391 ("s390/qeth: run non-offload L3 traffic over common xmit path")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l3_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 6970597bc885..4c2cae7ae9a7 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1813,7 +1813,7 @@ static netdev_features_t qeth_l3_osa_features_check(struct sk_buff *skb,
 						    struct net_device *dev,
 						    netdev_features_t features)
 {
-	if (qeth_get_ip_version(skb) != 4)
+	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 	return qeth_features_check(skb, dev, features);
 }
-- 
2.17.1

