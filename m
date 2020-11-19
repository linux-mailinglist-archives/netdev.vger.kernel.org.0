Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147D12B8957
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgKSBMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:12:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727145AbgKSBMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 20:12:54 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ127Ro132543;
        Wed, 18 Nov 2020 20:12:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=AkEoy85Qcu6CJFrcG4vga58Delkp1TZw+VTVbeESjnw=;
 b=mwF2C+cC9p6VEvZRSojh5hZdmYKGxL3cZpuna29SHpDW4giJ8sNTyCa8VKIU88MORl0R
 hpHvBSEAGhyjBgwUBHmBtWdHS/GPSpyqdJGDRF/9KUgSrHN+s/wLiQFXMof+Xpq4Ht2K
 shRiEv6/lR/DxB8K6p9gZpuFHc3gocuRv1kyBh3qJYvzfoMpW0ucfEbyEhWTUHC/q407
 K6zF1Il2uionpSpQ9RmmMm9ggHlLRQN4C0a3atAG+wVCnLHfhA/HF3roWbHwa7xyVUgd
 /a8OyHaL7G9oaHuPitEkNPe8JsPjwzhxXZGPno8rVGfHoW9BnkZxuFaLsHbKAO9twWVW Eg== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4xbrujs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Nov 2020 20:12:49 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ1CUPM004918;
        Thu, 19 Nov 2020 01:12:48 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 34t6v9aed0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 01:12:48 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ1ClpK10486188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 01:12:47 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C90A6A04D;
        Thu, 19 Nov 2020 01:12:47 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A90C6A05A;
        Thu, 19 Nov 2020 01:12:45 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.199.179])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 01:12:45 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cforno12@linux.ibm.com, ljp@linux.vnet.ibm.com,
        ricklind@linux.ibm.com, dnbanerg@us.ibm.com,
        drt@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, tlfalcon@linux.ibm.com
Subject: [PATCH net-next v2 4/9] ibmvnic: Clean up TX code and TX buffer data structure
Date:   Wed, 18 Nov 2020 19:12:20 -0600
Message-Id: <1605748345-32062-5-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1605748345-32062-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_10:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 impostorscore=0 suspectscore=1
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused and superfluous code and members in
existing TX implementation and data structures.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 31 +++++++++++-------------------
 drivers/net/ethernet/ibm/ibmvnic.h |  8 --------
 2 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 650aaf100d65..2aace693559f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1496,17 +1496,18 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
  * L2/L3/L4 packet header descriptors to be sent by send_subcrq_indirect.
  */
 
-static void build_hdr_descs_arr(struct ibmvnic_tx_buff *txbuff,
+static void build_hdr_descs_arr(struct sk_buff *skb,
+				union sub_crq *indir_arr,
 				int *num_entries, u8 hdr_field)
 {
 	int hdr_len[3] = {0, 0, 0};
+	u8 hdr_data[140] = {0};
 	int tot_len;
-	u8 *hdr_data = txbuff->hdr_data;
 
-	tot_len = build_hdr_data(hdr_field, txbuff->skb, hdr_len,
-				 txbuff->hdr_data);
+	tot_len = build_hdr_data(hdr_field, skb, hdr_len,
+				 hdr_data);
 	*num_entries += create_hdr_descs(hdr_field, hdr_data, tot_len, hdr_len,
-			 txbuff->indir_arr + 1);
+					 indir_arr + 1);
 }
 
 static int ibmvnic_xmit_workarounds(struct sk_buff *skb,
@@ -1612,6 +1613,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned int tx_send_failed = 0;
 	netdev_tx_t ret = NETDEV_TX_OK;
 	unsigned int tx_map_failed = 0;
+	union sub_crq indir_arr[16];
 	unsigned int tx_dropped = 0;
 	unsigned int tx_packets = 0;
 	unsigned int tx_bytes = 0;
@@ -1696,11 +1698,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	tx_buff = &tx_pool->tx_buff[index];
 	tx_buff->skb = skb;
-	tx_buff->data_dma[0] = data_dma_addr;
-	tx_buff->data_len[0] = skb->len;
 	tx_buff->index = index;
 	tx_buff->pool_index = queue_num;
-	tx_buff->last_frag = true;
 
 	memset(&tx_crq, 0, sizeof(tx_crq));
 	tx_crq.v1.first = IBMVNIC_CRQ_CMD;
@@ -1747,7 +1746,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 	if ((*hdrs >> 7) & 1)
-		build_hdr_descs_arr(tx_buff, &num_entries, *hdrs);
+		build_hdr_descs_arr(skb, indir_arr, &num_entries, *hdrs);
 
 	tx_crq.v1.n_crq_elem = num_entries;
 	tx_buff->num_entries = num_entries;
@@ -1758,8 +1757,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 			goto tx_flush_err;
 	}
 
-	tx_buff->indir_arr[0] = tx_crq;
-	memcpy(&ind_bufp->indir_arr[ind_bufp->index], tx_buff->indir_arr,
+	indir_arr[0] = tx_crq;
+	memcpy(&ind_bufp->indir_arr[ind_bufp->index], &indir_arr[0],
 	       num_entries * sizeof(struct ibmvnic_generic_scrq));
 	ind_bufp->index += num_entries;
 	if (__netdev_tx_sent_queue(txq, skb->len,
@@ -3185,7 +3184,7 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	struct netdev_queue *txq;
 	union sub_crq *next;
 	int index;
-	int i, j;
+	int i;
 
 restart_loop:
 	while (pending_scrq(adapter, scrq)) {
@@ -3210,14 +3209,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 			}
 
 			txbuff = &tx_pool->tx_buff[index];
-
-			for (j = 0; j < IBMVNIC_MAX_FRAGS_PER_CRQ; j++) {
-				if (!txbuff->data_dma[j])
-					continue;
-
-				txbuff->data_dma[j] = 0;
-			}
-
 			num_packets++;
 			num_entries += txbuff->num_entries;
 			if (txbuff->skb) {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 4a63e9886719..16d892c3db0f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -226,8 +226,6 @@ struct ibmvnic_tx_comp_desc {
 #define IBMVNIC_TCP_CHKSUM		0x20
 #define IBMVNIC_UDP_CHKSUM		0x08
 
-#define IBMVNIC_MAX_FRAGS_PER_CRQ 3
-
 struct ibmvnic_tx_desc {
 	u8 first;
 	u8 type;
@@ -896,14 +894,8 @@ struct ibmvnic_long_term_buff {
 
 struct ibmvnic_tx_buff {
 	struct sk_buff *skb;
-	dma_addr_t data_dma[IBMVNIC_MAX_FRAGS_PER_CRQ];
-	unsigned int data_len[IBMVNIC_MAX_FRAGS_PER_CRQ];
 	int index;
 	int pool_index;
-	bool last_frag;
-	union sub_crq indir_arr[6];
-	u8 hdr_data[140];
-	dma_addr_t indir_dma;
 	int num_entries;
 };
 
-- 
2.26.2

