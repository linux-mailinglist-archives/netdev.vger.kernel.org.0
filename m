Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A001C2C4A
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgECMj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:39:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728289AbgECMjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:39:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 043CVxvR041629;
        Sun, 3 May 2020 08:39:45 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s28e8d5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 08:39:45 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 043CZhWr004008;
        Sun, 3 May 2020 12:39:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g6126n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 May 2020 12:39:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 043CdeUO852446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 May 2020 12:39:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 652D54C044;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 265DB4C040;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  3 May 2020 12:39:40 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next v2 02/11] net/smc: rkey processing for a new link as SMC client
Date:   Sun,  3 May 2020 14:38:41 +0200
Message-Id: <20200503123850.57261-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-03_09:2020-05-01,2020-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005030110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Part of the SMC client new link establishment process is the exchange of
rkeys for all used buffers.
Add new LLC message type ADD_LINK_CONTINUE which is used to exchange
rkeys of all current RMB buffers. Add functions to iterate over all
used RMB buffers of the link group, and implement the ADD_LINK_CONTINUE
processing.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_llc.h |   1 +
 2 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 8716d8739329..a06b618f172e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -70,6 +70,23 @@ struct smc_llc_msg_add_link {		/* type 0x02 */
 	u8 reserved[8];
 };
 
+struct smc_llc_msg_add_link_cont_rt {
+	__be32 rmb_key;
+	__be32 rmb_key_new;
+	__be64 rmb_vaddr_new;
+};
+
+#define SMC_LLC_RKEYS_PER_CONT_MSG	2
+
+struct smc_llc_msg_add_link_cont {	/* type 0x03 */
+	struct smc_llc_hdr hd;
+	u8 link_num;
+	u8 num_rkeys;
+	u8 reserved2[2];
+	struct smc_llc_msg_add_link_cont_rt rt[SMC_LLC_RKEYS_PER_CONT_MSG];
+	u8 reserved[4];
+} __packed;			/* format defined in RFC7609 */
+
 #define SMC_LLC_FLAG_DEL_LINK_ALL	0x40
 #define SMC_LLC_FLAG_DEL_LINK_ORDERLY	0x20
 
@@ -121,6 +138,7 @@ struct smc_llc_msg_delete_rkey {	/* type 0x09 */
 union smc_llc_msg {
 	struct smc_llc_msg_confirm_link confirm_link;
 	struct smc_llc_msg_add_link add_link;
+	struct smc_llc_msg_add_link_cont add_link_cont;
 	struct smc_llc_msg_del_link delete_link;
 
 	struct smc_llc_msg_confirm_rkey confirm_rkey;
@@ -566,6 +584,137 @@ static int smc_llc_alloc_alt_link(struct smc_link_group *lgr,
 	return -EMLINK;
 }
 
+/* return first buffer from any of the next buf lists */
+static struct smc_buf_desc *_smc_llc_get_next_rmb(struct smc_link_group *lgr,
+						  int *buf_lst)
+{
+	struct smc_buf_desc *buf_pos;
+
+	while (*buf_lst < SMC_RMBE_SIZES) {
+		buf_pos = list_first_entry_or_null(&lgr->rmbs[*buf_lst],
+						   struct smc_buf_desc, list);
+		if (buf_pos)
+			return buf_pos;
+		(*buf_lst)++;
+	}
+	return NULL;
+}
+
+/* return next rmb from buffer lists */
+static struct smc_buf_desc *smc_llc_get_next_rmb(struct smc_link_group *lgr,
+						 int *buf_lst,
+						 struct smc_buf_desc *buf_pos)
+{
+	struct smc_buf_desc *buf_next;
+
+	if (!buf_pos || list_is_last(&buf_pos->list, &lgr->rmbs[*buf_lst])) {
+		(*buf_lst)++;
+		return _smc_llc_get_next_rmb(lgr, buf_lst);
+	}
+	buf_next = list_next_entry(buf_pos, list);
+	return buf_next;
+}
+
+static struct smc_buf_desc *smc_llc_get_first_rmb(struct smc_link_group *lgr,
+						  int *buf_lst)
+{
+	*buf_lst = 0;
+	return smc_llc_get_next_rmb(lgr, buf_lst, NULL);
+}
+
+/* send one add_link_continue msg */
+static int smc_llc_add_link_cont(struct smc_link *link,
+				 struct smc_link *link_new, u8 *num_rkeys_todo,
+				 int *buf_lst, struct smc_buf_desc **buf_pos)
+{
+	struct smc_llc_msg_add_link_cont *addc_llc;
+	struct smc_link_group *lgr = link->lgr;
+	int prim_lnk_idx, lnk_idx, i, rc;
+	struct smc_wr_tx_pend_priv *pend;
+	struct smc_wr_buf *wr_buf;
+	struct smc_buf_desc *rmb;
+	u8 n;
+
+	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
+	if (rc)
+		return rc;
+	addc_llc = (struct smc_llc_msg_add_link_cont *)wr_buf;
+	memset(addc_llc, 0, sizeof(*addc_llc));
+
+	prim_lnk_idx = link->link_idx;
+	lnk_idx = link_new->link_idx;
+	addc_llc->link_num = link_new->link_id;
+	addc_llc->num_rkeys = *num_rkeys_todo;
+	n = *num_rkeys_todo;
+	for (i = 0; i < min_t(u8, n, SMC_LLC_RKEYS_PER_CONT_MSG); i++) {
+		if (!*buf_pos) {
+			addc_llc->num_rkeys = addc_llc->num_rkeys -
+					      *num_rkeys_todo;
+			*num_rkeys_todo = 0;
+			break;
+		}
+		rmb = *buf_pos;
+
+		addc_llc->rt[i].rmb_key = htonl(rmb->mr_rx[prim_lnk_idx]->rkey);
+		addc_llc->rt[i].rmb_key_new = htonl(rmb->mr_rx[lnk_idx]->rkey);
+		addc_llc->rt[i].rmb_vaddr_new =
+			cpu_to_be64((u64)sg_dma_address(rmb->sgt[lnk_idx].sgl));
+
+		(*num_rkeys_todo)--;
+		*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
+		while (*buf_pos && !(*buf_pos)->used)
+			*buf_pos = smc_llc_get_next_rmb(lgr, buf_lst, *buf_pos);
+	}
+	addc_llc->hd.common.type = SMC_LLC_ADD_LINK_CONT;
+	addc_llc->hd.length = sizeof(struct smc_llc_msg_add_link_cont);
+	if (lgr->role == SMC_CLNT)
+		addc_llc->hd.flags |= SMC_LLC_FLAG_RESP;
+	return smc_wr_tx_send(link, pend);
+}
+
+static int smc_llc_cli_rkey_exchange(struct smc_link *link,
+				     struct smc_link *link_new)
+{
+	struct smc_llc_msg_add_link_cont *addc_llc;
+	struct smc_link_group *lgr = link->lgr;
+	u8 max, num_rkeys_send, num_rkeys_recv;
+	struct smc_llc_qentry *qentry;
+	struct smc_buf_desc *buf_pos;
+	int buf_lst;
+	int rc = 0;
+	int i;
+
+	mutex_lock(&lgr->rmbs_lock);
+	num_rkeys_send = lgr->conns_num;
+	buf_pos = smc_llc_get_first_rmb(lgr, &buf_lst);
+	do {
+		qentry = smc_llc_wait(lgr, NULL, SMC_LLC_WAIT_TIME,
+				      SMC_LLC_ADD_LINK_CONT);
+		if (!qentry) {
+			rc = -ETIMEDOUT;
+			break;
+		}
+		addc_llc = &qentry->msg.add_link_cont;
+		num_rkeys_recv = addc_llc->num_rkeys;
+		max = min_t(u8, num_rkeys_recv, SMC_LLC_RKEYS_PER_CONT_MSG);
+		for (i = 0; i < max; i++) {
+			smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
+				       addc_llc->rt[i].rmb_key,
+				       addc_llc->rt[i].rmb_vaddr_new,
+				       addc_llc->rt[i].rmb_key_new);
+			num_rkeys_recv--;
+		}
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		rc = smc_llc_add_link_cont(link, link_new, &num_rkeys_send,
+					   &buf_lst, &buf_pos);
+		if (rc)
+			break;
+	} while (num_rkeys_send || num_rkeys_recv);
+
+	mutex_unlock(&lgr->rmbs_lock);
+	return rc;
+}
+
 /* prepare and send an add link reject response */
 static int smc_llc_cli_add_link_reject(struct smc_llc_qentry *qentry)
 {
@@ -631,7 +780,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
 				   lnk_new->gid, lnk_new, SMC_LLC_RESP);
 	if (rc)
 		goto out_clear_lnk;
-	/* tbd: rc = smc_llc_cli_rkey_exchange(link, lnk_new); */
+	rc = smc_llc_cli_rkey_exchange(link, lnk_new);
 	if (rc) {
 		rc = 0;
 		goto out_clear_lnk;
@@ -794,6 +943,7 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		}
 		return;
 	case SMC_LLC_CONFIRM_LINK:
+	case SMC_LLC_ADD_LINK_CONT:
 		if (lgr->llc_flow_lcl.type != SMC_LLC_FLOW_NONE) {
 			/* a flow is waiting for this message */
 			smc_llc_flow_qentry_set(&lgr->llc_flow_lcl, qentry);
@@ -873,6 +1023,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 		break;
 	case SMC_LLC_ADD_LINK:
 	case SMC_LLC_CONFIRM_LINK:
+	case SMC_LLC_ADD_LINK_CONT:
 	case SMC_LLC_CONFIRM_RKEY:
 	case SMC_LLC_DELETE_RKEY:
 		/* assign responses to the local flow, we requested them */
@@ -1092,6 +1243,10 @@ static struct smc_wr_rx_handler smc_llc_rx_handlers[] = {
 		.handler	= smc_llc_rx_handler,
 		.type		= SMC_LLC_ADD_LINK
 	},
+	{
+		.handler	= smc_llc_rx_handler,
+		.type		= SMC_LLC_ADD_LINK_CONT
+	},
 	{
 		.handler	= smc_llc_rx_handler,
 		.type		= SMC_LLC_DELETE_LINK
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 4ed4486e5082..97a4f02f5a93 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -28,6 +28,7 @@ enum smc_llc_reqresp {
 enum smc_llc_msg_type {
 	SMC_LLC_CONFIRM_LINK		= 0x01,
 	SMC_LLC_ADD_LINK		= 0x02,
+	SMC_LLC_ADD_LINK_CONT		= 0x03,
 	SMC_LLC_DELETE_LINK		= 0x04,
 	SMC_LLC_CONFIRM_RKEY		= 0x06,
 	SMC_LLC_TEST_LINK		= 0x07,
-- 
2.17.1

