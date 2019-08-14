Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903E88DE2A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfHNT5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:57:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726865AbfHNT5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:57:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7EJq99L132881
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 15:57:11 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ucqhak4dh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 15:57:10 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Wed, 14 Aug 2019 20:57:10 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 14 Aug 2019 20:57:08 +0100
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7EJv7an14484332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 19:57:07 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EB4D12405B;
        Wed, 14 Aug 2019 19:57:07 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1533312405E;
        Wed, 14 Aug 2019 19:57:07 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.41.178.211])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 14 Aug 2019 19:57:06 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: Unmap DMA address of TX descriptor buffers after use
Date:   Wed, 14 Aug 2019 14:57:05 -0500
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19081419-0064-0000-0000-00000408A385
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011590; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000287; SDB=6.01246834; UDB=6.00657998; IPR=6.01028341;
 MB=3.00028175; MTD=3.00000008; XFM=3.00000015; UTC=2019-08-14 19:57:09
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081419-0065-0000-0000-00003EAB70B7
Message-Id: <1565812625-24364-1-git-send-email-tlfalcon@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=657 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to wait until a completion is received to unmap
TX descriptor buffers that have been passed to the hypervisor.
Instead unmap it when the hypervisor call has completed. This patch
avoids the possibility that a buffer will not be unmapped because
a TX completion is lost or mishandled.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Devesh K. Singh <devesh_singh@in.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 81a05ea38237..07efa2b40003 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1568,6 +1568,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		lpar_rc = send_subcrq_indirect(adapter, handle_array[queue_num],
 					       (u64)tx_buff->indir_dma,
 					       (u64)num_entries);
+		dma_unmap_single(dev, tx_buff->indir_dma,
+				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
 	} else {
 		tx_buff->num_entries = num_entries;
 		lpar_rc = send_subcrq(adapter, handle_array[queue_num],
@@ -2788,7 +2790,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	union sub_crq *next;
 	int index;
 	int i, j;
-	u8 *first;
 
 restart_loop:
 	while (pending_scrq(adapter, scrq)) {
@@ -2818,14 +2819,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 
 				txbuff->data_dma[j] = 0;
 			}
-			/* if sub_crq was sent indirectly */
-			first = &txbuff->indir_arr[0].generic.first;
-			if (*first == IBMVNIC_CRQ_CMD) {
-				dma_unmap_single(dev, txbuff->indir_dma,
-						 sizeof(txbuff->indir_arr),
-						 DMA_TO_DEVICE);
-				*first = 0;
-			}
 
 			if (txbuff->last_frag) {
 				dev_kfree_skb_any(txbuff->skb);
-- 
2.16.4

