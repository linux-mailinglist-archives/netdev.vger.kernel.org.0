Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EADD17E91F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCITtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:49:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgCITtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 15:49:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029JcG5Y028438
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 12:49:31 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ynu7jrbvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 12:49:31 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 12:49:30 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 0F8822E432EC0; Mon,  9 Mar 2020 12:49:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <brouer@redhat.com>, <ilias.apalodimas@linaro.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Date:   Mon, 9 Mar 2020 12:49:29 -0700
Message-ID: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_09:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=931 priorityscore=1501 impostorscore=0
 clxscore=1034 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netpoll may be called from IRQ context, which may access the
page pool ring.  The current _bh variants do not provide sufficient
protection, so use irqsave/restore instead.

Error observed on a modified mlx4 driver, but the code path exists
for any driver which calls page_pool_recycle from napi poll.

WARNING: CPU: 34 PID: 550248 at /ro/source/kernel/softirq.c:161 __local_bh_enable_ip+0x35/0x50

    __page_pool_finish_recycle+0x14f/0x180
    mlx4_en_recycle_tx_desc+0x44/0x50
    mlx4_en_process_tx_cq+0x19f/0x440
    mlx4_en_poll_rx_cq+0xd4/0xf0
    netpoll_poll_dev+0xc2/0x190
    netpoll_send_skb_on_dev+0xf5/0x230
    netpoll_send_udp+0x2b3/0x3cd
    write_ext_msg+0x1be/0x1d0
    console_unlock+0x22e/0x500
    vprintk_emit+0x23a/0x360
    printk+0x48/0x4a
    hpet_rtc_interrupt.cold.17+0xe/0x1a
    __handle_irq_event_percpu+0x43/0x180
    handle_irq_event_percpu+0x20/0x60
    handle_irq_event+0x2a/0x47
    handle_edge_irq+0x8e/0x190
    handle_irq+0xbf/0x100
    do_IRQ+0x41/0xc0
    common_interrupt+0xf/0xf
    </IRQ>

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/page_pool.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 626db912fce4..df9804e85a40 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -102,6 +102,7 @@ noinline
 static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 {
 	struct ptr_ring *r = &pool->ring;
+	unsigned long flags;
 	struct page *page;
 	int pref_nid; /* preferred NUMA node */
 
@@ -120,7 +121,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 #endif
 
 	/* Slower-path: Get pages from locked ring queue */
-	spin_lock(&r->consumer_lock);
+	spin_lock_irqsave(&r->consumer_lock, flags);
 
 	/* Refill alloc array, but only if NUMA match */
 	do {
@@ -146,7 +147,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	if (likely(pool->alloc.count > 0))
 		page = pool->alloc.cache[--pool->alloc.count];
 
-	spin_unlock(&r->consumer_lock);
+	spin_unlock_irqrestore(&r->consumer_lock, flags);
 	return page;
 }
 
@@ -321,11 +322,8 @@ static void page_pool_return_page(struct page_pool *pool, struct page *page)
 static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 {
 	int ret;
-	/* BH protection not needed if current is serving softirq */
-	if (in_serving_softirq())
-		ret = ptr_ring_produce(&pool->ring, page);
-	else
-		ret = ptr_ring_produce_bh(&pool->ring, page);
+
+	ret = ptr_ring_produce_any(&pool->ring, page);
 
 	return (ret == 0) ? true : false;
 }
@@ -411,7 +409,7 @@ static void page_pool_empty_ring(struct page_pool *pool)
 	struct page *page;
 
 	/* Empty recycle ring */
-	while ((page = ptr_ring_consume_bh(&pool->ring))) {
+	while ((page = ptr_ring_consume_any(&pool->ring))) {
 		/* Verify the refcnt invariant of cached pages */
 		if (!(page_ref_count(page) == 1))
 			pr_crit("%s() page_pool refcnt %d violation\n",
-- 
2.17.1

