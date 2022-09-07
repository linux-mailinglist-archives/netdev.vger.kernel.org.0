Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362F05B03E1
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 14:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIGM0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 08:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIGM0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 08:26:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B7EA7AA2;
        Wed,  7 Sep 2022 05:26:48 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287CCkGC032327;
        Wed, 7 Sep 2022 12:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=k2B2oN3072AB2Rz6ArgU/pPbCW/fz3Toyh8pu5ZbGMo=;
 b=gkgGwzP+wB76xsXa42n71HtWA50v68O99Q/LhFQGBxupe6DHX3GV5QfMl0jcwolCQXCu
 G96Rc8r9Q1W1KrdxzWVt7ReiZEuJv4D290+kzuUx6+VtvHv/IgGb3FtGsJc+seF2avA1
 N6VVdWAqfXWZZQUCMK1lxXEDWtPSUWGtXTGvXh3Gw7nXMysN/WV3IkmqeWsNZ9R6kAFJ
 9wvBp5jjrLS15mpIyT0Y4m42MLrfooP+y4Gn61IBSzC2Opjcy8zR/bDHL+2tr7OMFrwF
 wOVLrd3bsy8sacCOXKRxket4SWgKuUyTF432Ux6k4GDSqi3oXZ9uxcJtUetX12BFbJCQ XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jeu3urdhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 12:26:40 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 287CD6pO001690;
        Wed, 7 Sep 2022 12:26:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jeu3urdgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 12:26:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 287CKKOY007821;
        Wed, 7 Sep 2022 12:26:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3jbxj8w59h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 12:26:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 287CQYoj33358192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Sep 2022 12:26:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC04A4C04E;
        Wed,  7 Sep 2022 12:26:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 470264C044;
        Wed,  7 Sep 2022 12:26:34 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box.com (unknown [9.145.95.28])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Sep 2022 12:26:34 +0000 (GMT)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [RFC net] tcp: Fix performance regression for request-response workloads
Date:   Wed,  7 Sep 2022 14:25:06 +0200
Message-Id: <20220907122505.26953-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lOSIx08iXjPCtsoCO8dLpaklPROtkUAw
X-Proofpoint-GUID: YdK8nzAPWPEFyCPILRPAxC_dU-3M1B6d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_06,2022-09-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 spamscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since linear payload was removed even for single small messages,
an additional page is required and we are measuring performance impact.

3613b3dbd1ad ("tcp: prepare skbs for better sack shifting")
explicitely allowed "payload in skb->head for first skb put in the queue,
to not impact RPC workloads."
472c2e07eef0 ("tcp: add one skb cache for tx")
made that obsolete and removed it.
When 
d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache")
reverted it, this piece was not reverted and not added back in.

When running uperf with a request-response pattern with 1k payload
and 250 connections parallel, we measure 13% difference in throughput
for our PCI based network interfaces since 472c2e07eef0.
(our IO MMU is sensitive to the number of mapped pages)

Could you please consider allowing linear payload for the first
skb in queue again? A patch proposal is appended below.

Kind regards
Alexandra

---------------------------------------------------------------

tcp: allow linear skb payload for first in queue

Allow payload in skb->head for first skb in the queue,
RPC workloads will benefit.

Fixes: 472c2e07eef0 ("tcp: add one skb cache for tx")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 net/ipv4/tcp.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e5011c136fdb..f7cbccd41d85 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1154,6 +1154,30 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset,
 }
 EXPORT_SYMBOL(tcp_sendpage);
 
+/* Do not bother using a page frag for very small frames.
+ * But use this heuristic only for the first skb in write queue.
+ *
+ * Having no payload in skb->head allows better SACK shifting
+ * in tcp_shift_skb_data(), reducing sack/rack overhead, because
+ * write queue has less skbs.
+ * Each skb can hold up to MAX_SKB_FRAGS * 32Kbytes, or ~0.5 MB.
+ * This also speeds up tso_fragment(), since it won't fallback
+ * to tcp_fragment().
+ */
+static int linear_payload_sz(bool first_skb)
+{
+		if (first_skb)
+			return SKB_WITH_OVERHEAD(2048 - MAX_TCP_HEADER);
+		return 0;
+}
+
+static int select_size(bool first_skb, bool zc)
+{
+		if (zc)
+			return 0;
+		return linear_payload_sz(first_skb);
+}
+
 void tcp_free_fastopen_req(struct tcp_sock *tp)
 {
 	if (tp->fastopen_req) {
@@ -1311,6 +1335,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 		if (copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
 			bool first_skb;
+			int linear;
 
 new_segment:
 			if (!sk_stream_memory_free(sk))
@@ -1322,7 +1347,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 					goto restart;
 			}
 			first_skb = tcp_rtx_and_write_queues_empty(sk);
-			skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
+			linear = select_size(first_skb, zc);
+			skb = tcp_stream_alloc_skb(sk, linear,
+						   sk->sk_allocation,
 						   first_skb);
 			if (!skb)
 				goto wait_for_space;
@@ -1344,7 +1371,15 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (!zc) {
+		/* Where to copy to? */
+		if (skb_availroom(skb) > 0 && !zc) {
+			/* We have some space in skb head. Superb! */
+			copy = min_t(int, copy, skb_availroom(skb));
+			err = skb_add_data_nocache(sk, skb, &msg->msg_iter,
+						   copy);
+			if (err)
+				goto do_error;
+		} else if (!zc) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
-- 
2.24.3 (Apple Git-128)

