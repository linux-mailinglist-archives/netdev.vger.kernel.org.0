Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B239FC3672
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 15:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388879AbfJAN4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 09:56:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388872AbfJAN4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 09:56:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91DiVIs069498;
        Tue, 1 Oct 2019 13:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=9GWeqhJnT5PGkazNzMmgVhKC+DkKpsNOs2T2q3VSXac=;
 b=YQ9au5zrbo5ogpT38yZosjjBdTHx3lvFjGT7Jr6XFzkxCpLXFQOoyF9og7t6J7v18n2u
 8mkyXJpxHWgj3DF8LmyF14FN5B2/PE5RiFiyZbZeY+v64dyTRNvMxvAQ54Eg8yO1DmO0
 j+d83AnWQFcM5XyK0c3GrLTdSmo3KXL0cMGM3Ahr9nCm6tDoYHXPP545TXCTURQH0Qas
 5csgLO3K/EDUD15D0ctQklBzF7R32Og/2PBggtrmMIzcvM4Rjirt47o6yVJWtuMxWI+4
 LsH1cpmqvvZpCmGKtUmfq2Fa7fRj4+0b/1rXU2oOwiA4zji6sF6363ueSoD7gLZOuP65 FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05rp0hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 13:56:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91DheEB025460;
        Tue, 1 Oct 2019 13:56:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vbmpymbq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 13:56:26 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x91DuOvF026286;
        Tue, 1 Oct 2019 13:56:24 GMT
Received: from linux.cn.oracle.com (/10.182.69.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 06:56:23 -0700
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     jgross@suse.com, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: [PATCH v2 1/1] xen-netfront: do not use ~0U as error return value for xennet_fill_frags()
Date:   Tue,  1 Oct 2019 21:56:41 +0800
Message-Id: <1569938201-23620-1-git-send-email-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=963
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010125
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

This patch changes the return type of xennet_fill_frags() to indicate
whether it is successful or failed. The queue->rx.rsp_cons will be
always updated inside this function.

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Always update queue->rx.rsp_cons inside xennet_fill_frags() so we do
    not need to add extra argument to xennet_fill_frags().

 drivers/net/xen-netfront.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index e14ec75..482c6c8 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -887,9 +887,9 @@ static int xennet_set_skb_gso(struct sk_buff *skb,
 	return 0;
 }
 
-static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
-				  struct sk_buff *skb,
-				  struct sk_buff_head *list)
+static int xennet_fill_frags(struct netfront_queue *queue,
+			     struct sk_buff *skb,
+			     struct sk_buff_head *list)
 {
 	RING_IDX cons = queue->rx.rsp_cons;
 	struct sk_buff *nskb;
@@ -908,7 +908,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
 		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
 			queue->rx.rsp_cons = ++cons + skb_queue_len(list);
 			kfree_skb(nskb);
-			return ~0U;
+			return -ENOENT;
 		}
 
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -919,7 +919,9 @@ static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
 		kfree_skb(nskb);
 	}
 
-	return cons;
+	queue->rx.rsp_cons = cons;
+
+	return 0;
 }
 
 static int checksum_setup(struct net_device *dev, struct sk_buff *skb)
@@ -1045,8 +1047,7 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		i = xennet_fill_frags(queue, skb, &tmpq);
-		if (unlikely(i == ~0U))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
 			goto err;
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
@@ -1056,7 +1057,7 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 
 		__skb_queue_tail(&rxq, skb);
 
-		queue->rx.rsp_cons = ++i;
+		i = ++queue->rx.rsp_cons;
 		work_done++;
 	}
 
-- 
2.7.4

