Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA61B33CA
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 05:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfIPDqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 23:46:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41070 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfIPDqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 23:46:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8G3hwwY088447;
        Mon, 16 Sep 2019 03:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=vNyavF+kNZ2EentgkgqouBtUF5BzDxaCPrvgmTdCd9I=;
 b=EJ8AcB/CxPBGTcQoc8+e3QHx1tEnOtacfeXDsolfGqcNSw1+KYAIKekDctVymWYSHGgp
 nzo3mTPbLGBD25bGkQLamylSxDEwsDYIrdxVxMclkBe6mVaivW1p+babRcE7edhYCz01
 iyRJuIAGxjhgAAic9BOkK3RoBMpRkKJlPUrdK18cBHSWVbIiBknnLuTdw1/MmU1SLAv1
 ZbT8wFLNbZ4knovVYzL8ytn1S9i1KvMX40ddRi33MS+dIf1poZwL7XoDwaMnZC/aAdYI
 LM1yX/jg9zuqZleZ49OplYdJoS6MISONMWFLCqcelqx37Tf7iembWDCD0nI827hGSwB+ 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v0ruqcrqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 03:46:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8G3hs2A195467;
        Mon, 16 Sep 2019 03:46:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v0nb3tekb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 03:46:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8G3kOHS018384;
        Mon, 16 Sep 2019 03:46:25 GMT
Received: from linux.cn.oracle.com (/10.182.69.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Sep 2019 20:46:24 -0700
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     xen-devel@lists.xenproject.org
Cc:     netdev@vger.kernel.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] xen-netfront: do not assume sk_buff_head list is empty in error handling
Date:   Mon, 16 Sep 2019 11:46:59 +0800
Message-Id: <1568605619-22219-1-git-send-email-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9381 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9381 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb_shinfo(skb) is not able to cache extra fragment (that is,
skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS), xennet_fill_frags() assumes
the sk_buff_head list is already empty. As a result, cons is increased only
by 1 and returns to error handling path in xennet_poll().

However, if the sk_buff_head list is not empty, queue->rx.rsp_cons may be
set incorrectly. That is, queue->rx.rsp_cons would point to the rx ring
buffer entries whose queue->rx_skbs[i] and queue->grant_rx_ref[i] are
already cleared to NULL. This leads to NULL pointer access in the next
iteration to process rx ring buffer entries.

Below is how xennet_poll() does error handling. All remaining entries in
tmpq are accounted to queue->rx.rsp_cons without assuming how many
outstanding skbs are remained in the list.

 985 static int xennet_poll(struct napi_struct *napi, int budget)
... ...
1032           if (unlikely(xennet_set_skb_gso(skb, gso))) {
1033                   __skb_queue_head(&tmpq, skb);
1034                   queue->rx.rsp_cons += skb_queue_len(&tmpq);
1035                   goto err;
1036           }

It is better to always have the error handling in the same way.

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/xen-netfront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 8d33970..5f5722b 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -906,7 +906,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
 			__pskb_pull_tail(skb, pull_to - skb_headlen(skb));
 		}
 		if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
-			queue->rx.rsp_cons = ++cons;
+			queue->rx.rsp_cons = ++cons + skb_queue_len(list);
 			kfree_skb(nskb);
 			return ~0U;
 		}
-- 
2.7.4

