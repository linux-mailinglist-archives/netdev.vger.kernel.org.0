Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF03340BE9C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbhIODyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:54:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236243AbhIODyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:54:23 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18F1xoHu021384
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gNwRShj1fCPOjbvcZzcbmqfKAtdoDisxZvVIpOU9ySc=;
 b=YwkIP9lyzSPCM+OP6GVQEDODeuZ/3DttAuFQb1TkxqsfmP03p1ChpsxpCJSHfMfL3FZF
 b7/7Mt5lrBEI8I9OeQJfSKQ0LZimHQY5Y7DcyvfhiOlBh0s6vwlsMgMwjbBlo2LQt1Kt
 Zb78d9GkVy0N8aeCtFQhmmba86KneR4HAkRaZbNQoD5tpMzTb/JsBxZqpE4PrxMuV3J5
 +tw31Qd/26+UUxjiU6ZbOMuJfHgJH1TpcrPKVh1bshiNpMypIJIFicJB951CqggIodEG
 cwO2iv9BAoIXDVlgMU+bned6KC6oe5cnof9PxEofyZ5/2a4b/eKSTAHhc5VKxG+sZwbO vg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b37nn1kg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 23:53:04 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18F3lMj6023145
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:04 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3b0m3bg560-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 03:53:04 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18F3r3g214287226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:53:03 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 537D7112063;
        Wed, 15 Sep 2021 03:53:03 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4473112061;
        Wed, 15 Sep 2021 03:53:01 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.77.142.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 03:53:01 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next RESEND v2 1/9] ibmvnic: Consolidate code in replenish_rx_pool()
Date:   Tue, 14 Sep 2021 20:52:51 -0700
Message-Id: <20210915035259.355092-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915035259.355092-1-sukadev@linux.ibm.com>
References: <20210915035259.355092-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rm7TCnnyoNP_txH4Wc7wcusE9ALEHnCe
X-Proofpoint-GUID: rm7TCnnyoNP_txH4Wc7wcusE9ALEHnCe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better readability, consolidate related code in replenish_rx_pool()
and add some comments.

Reviewed-by: Rick Lindsley <ricklind@linux.vnet.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a775c69e4fd7..e8b1231be485 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -371,6 +371,8 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		}
 
 		index = pool->free_map[pool->next_free];
+		pool->free_map[pool->next_free] = IBMVNIC_INVALID_MAP;
+		pool->next_free = (pool->next_free + 1) % pool->size;
 
 		if (pool->rx_buff[index].skb)
 			dev_err(dev, "Inconsistent free_map!\n");
@@ -380,14 +382,15 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		dst = pool->long_term_buff.buff + offset;
 		memset(dst, 0, pool->buff_size);
 		dma_addr = pool->long_term_buff.addr + offset;
-		pool->rx_buff[index].data = dst;
 
-		pool->free_map[pool->next_free] = IBMVNIC_INVALID_MAP;
+		/* add the skb to an rx_buff in the pool */
+		pool->rx_buff[index].data = dst;
 		pool->rx_buff[index].dma = dma_addr;
 		pool->rx_buff[index].skb = skb;
 		pool->rx_buff[index].pool_index = pool->index;
 		pool->rx_buff[index].size = pool->buff_size;
 
+		/* queue the rx_buff for the next send_subcrq_indirect */
 		sub_crq = &ind_bufp->indir_arr[ind_bufp->index++];
 		memset(sub_crq, 0, sizeof(*sub_crq));
 		sub_crq->rx_add.first = IBMVNIC_CRQ_CMD;
@@ -405,7 +408,8 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 		shift = 8;
 #endif
 		sub_crq->rx_add.len = cpu_to_be32(pool->buff_size << shift);
-		pool->next_free = (pool->next_free + 1) % pool->size;
+
+		/* if send_subcrq_indirect queue is full, flush to VIOS */
 		if (ind_bufp->index == IBMVNIC_MAX_IND_DESCS ||
 		    i == count - 1) {
 			lpar_rc =
-- 
2.26.2

