Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D181E3FD01B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242429AbhIAAKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:10:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243347AbhIAAJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:09:15 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18103Hu0112134
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+mOJKw62qtzdHY6xYokt+enZZkNUKw9d3pnZYRY5hGY=;
 b=HIWIpojFhRMqnACyykFU8TEakCudB6qhnovkg5p/RNnkp8+Wv44J/VG9TLehMwZcY1mp
 fqZkdZJi6ad9XhOKRBhp0GMeP48vdtwGWqAbl/JyjiDJEbMZrqxngxTbZBbQZsidjFjp
 ZdeWDCDCvVSOjRJk9sAdPR7YTz8O/oSwrIyS7AwJqdnZcg3XOfwthfS2h2MgA9l8XCIa
 Zl+XeYNM2X9CMMTvtWZrHgnkDrMFRZvBOQSrYpEY7xV6waEpVz7F7E3B014lHsxpzORn
 hAaajkvhHrO0lcBYrep5S70zt19EI4xwWOZCGPyMRLoHE/9MVoKogoh3gAgLaS6q4Tlc jw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asx598nk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:08:19 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VNudeh014296
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 00:08:18 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 3aqcsd208g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 00:08:18 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18108GiM42729906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 00:08:17 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD64B7806B;
        Wed,  1 Sep 2021 00:08:16 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4DB67805C;
        Wed,  1 Sep 2021 00:08:15 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.237.107])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 00:08:15 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 1/9] ibmvnic: Consolidate code in replenish_rx_pool()
Date:   Tue, 31 Aug 2021 17:08:04 -0700
Message-Id: <20210901000812.120968-2-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901000812.120968-1-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oQ42lvPVj5kgHGlGPQwUrFrPTA458x3R
X-Proofpoint-ORIG-GUID: oQ42lvPVj5kgHGlGPQwUrFrPTA458x3R
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better readability, consolidate related code in replenish_rx_pool()
and add some comments.

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
2.31.1

