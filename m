Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1D33FE1B3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345463AbhIASGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:06:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60426 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235904AbhIASGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:06:54 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181I2eFk031076
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 14:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gNwRShj1fCPOjbvcZzcbmqfKAtdoDisxZvVIpOU9ySc=;
 b=htDFt8TfRxY/e4d20J60uPEgZtdVBNxxUELzslQadvGIlPrhpmRQ5ZhQuNC79tljxQnR
 mTaa2QIugWtAVHuU0BSnt3drQVE6tmWNvQT2FFAlfyd/hay4Csz42FoTHWygpmQT0Iy9
 5TxBvgsFTKPbrnQGOQ+M+whdBvs/PX7c70peGm1dL51BTDUDxZZDk/nM1P6gdtsPy+U0
 LXsOTS04db6cHyfN8hYrFt6VHMrPGfjG1RQxbV36F1sS66d8reLmUohWP5MNSUb9JZQS
 mbc/bU9SP5RkpHWuYnqGBMNU2YZIjtMBVj8O1cqQExwZhcy/3pDkiqYyDYVTtEo4wpGv Dw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ate1arss6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:05:56 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 181I43LI023180
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 18:05:56 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3atdxbgwwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 18:05:56 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 181I5sNF38928746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 18:05:54 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71CA312405B;
        Wed,  1 Sep 2021 18:05:54 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C48212405A;
        Wed,  1 Sep 2021 18:05:53 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.160.152.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 18:05:53 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.vnet.ibm.com>
Subject: [PATCH net-next v2 1/9] ibmvnic: Consolidate code in replenish_rx_pool()
Date:   Wed,  1 Sep 2021 11:05:43 -0700
Message-Id: <20210901180551.150126-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901180551.150126-1-sukadev@linux.ibm.com>
References: <20210901180551.150126-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BCPkvWMpjVyN71YmsmEKXYCiZuBu_pHn
X-Proofpoint-GUID: BCPkvWMpjVyN71YmsmEKXYCiZuBu_pHn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010104
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

