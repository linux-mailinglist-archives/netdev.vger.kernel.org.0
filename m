Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F223C1C3C
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfI3Hou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 03:44:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbfI3Hos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 03:44:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8U7i9bK157904;
        Mon, 30 Sep 2019 07:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=E1+AZyCgUqnQ9IKyi0G2G7XawCcrfnF8283UFDFFdrk=;
 b=qdV6WffL8Rwfaz7N3i/T/9eJYQa6GILhkNP9fZ/+zhSt/+g+M6YaV+4MjdXw5xaYS5sy
 z9dZyhhViOxvCSQf0MhCU0BEINo8bHjFiXMNykVtuD8LC3WTQpoKLGSMhi2TUPgROIn3
 jEP4COMyPS5Ze5dWdjbODKNlx/tE/TA5Sy5Es8MTQLWLqlX0tR8jpwuDTHx5W7zLXTK9
 NnAkJbLCjfF4/m5H9IwYQhOnuOlNgvmsbtsOywyt7+wxbe5Wsvvf3dWIzUHrkSjFBAur
 hNpKxMGxK6+FqYQYzhAzf2Li+1nKwVwzAUuuP9EbWSZURPmSTsC8V+PT08Y9Wge1eRqZ wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v9xxud1b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 07:44:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8U7iR5J152532;
        Mon, 30 Sep 2019 07:44:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vayqwd0uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 07:44:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8U7i6Ql003170;
        Mon, 30 Sep 2019 07:44:06 GMT
Received: from linux.cn.oracle.com (/10.182.69.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 00:44:05 -0700
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, davem@davemloft.net, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] xen-netfront: do not use ~0U as error return value for xennet_fill_frags()
Date:   Mon, 30 Sep 2019 15:44:29 +0800
Message-Id: <1569829469-16143-1-git-send-email-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9395 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300082
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9395 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=964 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xennet_fill_frags() uses ~0U as return value when the sk_buff is not able
to cache extra fragments. This is incorrect because the return type of
xennet_fill_frags() is RING_IDX and 0xffffffff is an expected value for
ring buffer index.

In the situation when the rsp_cons is approaching 0xffffffff, the return
value of xennet_fill_frags() may become 0xffffffff which xennet_poll() (the
caller) would regard as error. As a result, queue->rx.rsp_cons is set
incorrectly because it is updated only when there is error. If there is no
error, xennet_poll() would be responsible to update queue->rx.rsp_cons.
Finally, queue->rx.rsp_cons would point to the rx ring buffer entries whose
queue->rx_skbs[i] and queue->grant_rx_ref[i] are already cleared to NULL.
This leads to NULL pointer access in the next iteration to process rx ring
buffer entries.

The symptom is similar to the one fixed in
commit 00b368502d18 ("xen-netfront: do not assume sk_buff_head list is
empty in error handling").

This patch uses an extra argument to help return if there is error in
xennet_fill_frags().

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/xen-netfront.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e14ec75..c2a1e09 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -889,11 +889,14 @@ static int xennet_set_skb_gso(struct sk_buff *skb,
 
 static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
 				  struct sk_buff *skb,
-				  struct sk_buff_head *list)
+				  struct sk_buff_head *list,
+				  int *errno)
 {
 	RING_IDX cons = queue->rx.rsp_cons;
 	struct sk_buff *nskb;
 
+	*errno = 0;
+
 	while ((nskb = __skb_dequeue(list))) {
 		struct xen_netif_rx_response *rx =
 			RING_GET_RESPONSE(&queue->rx, ++cons);
@@ -908,6 +911,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
 		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
 			queue->rx.rsp_cons = ++cons + skb_queue_len(list);
 			kfree_skb(nskb);
+			*errno = -ENOENT;
 			return ~0U;
 		}
 
@@ -1009,6 +1013,8 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 	i = queue->rx.rsp_cons;
 	work_done = 0;
 	while ((i != rp) && (work_done < budget)) {
+		int errno;
+
 		memcpy(rx, RING_GET_RESPONSE(&queue->rx, i), sizeof(*rx));
 		memset(extras, 0, sizeof(rinfo.extras));
 
@@ -1045,8 +1051,8 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		i = xennet_fill_frags(queue, skb, &tmpq);
-		if (unlikely(i == ~0U))
+		i = xennet_fill_frags(queue, skb, &tmpq, &errno);
+		if (unlikely(errno == -ENOENT))
 			goto err;
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
-- 
2.7.4

