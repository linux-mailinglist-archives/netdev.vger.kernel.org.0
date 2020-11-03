Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E602A503F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgKCThM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:37:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgKCThM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:37:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3JZ8Vc186834;
        Tue, 3 Nov 2020 19:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=YH5qs3ECwIUFehV5nWCcU1wrJlau/0WJfkMsxtIJe9c=;
 b=BVpG3BI8HrP72ZvUl4B2PeIMOmoyNVmQJiHdTzXOqFY3lP0skPEmhtFItMQ2Xn5HNRAB
 AtF6JDOerH2yynwCiP7rC3AAMgkcM1M8KRYpYXgvGERDfj5GygLCmG6OzoMQZlG79tPt
 SnT0XY15HbcRkUihP2MU+TsexDa7e+s/FkufAnmNNWDtOgyVOdPcYjG5qs1hCHz9hm6C
 g1ZpPfZAqro60DgnTDiuO2nXqJOAMIslG13VCGvpu5ff77QNQX3Ru46lVodjMcJSnpDh
 kNVY7OkwqhwLiI8dzfQsFQxwJ6JytoCv4x0VlBEg877Biwh4526xbB3ssd4jgnw07eOi SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34hhw2k5xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 19:37:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3JYnWx194954;
        Tue, 3 Nov 2020 19:35:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34jf48y4mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 19:35:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3JYwdD005340;
        Tue, 3 Nov 2020 19:34:58 GMT
Received: from localhost.localdomain (/10.211.9.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 11:34:57 -0800
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     linux-mm@kvack.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, dongli.zhang@oracle.com,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com
Subject: [PATCH 1/1] mm: avoid re-using pfmemalloc page in page_frag_alloc()
Date:   Tue,  3 Nov 2020 11:32:39 -0800
Message-Id: <20201103193239.1807-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethernet driver may allocates skb (and skb->data) via napi_alloc_skb().
This ends up to page_frag_alloc() to allocate skb->data from
page_frag_cache->va.

During the memory pressure, page_frag_cache->va may be allocated as
pfmemalloc page. As a result, the skb->pfmemalloc is always true as
skb->data is from page_frag_cache->va. The skb will be dropped if the
sock (receiver) does not have SOCK_MEMALLOC. This is expected behaviour
under memory pressure.

However, once kernel is not under memory pressure any longer (suppose large
amount of memory pages are just reclaimed), the page_frag_alloc() may still
re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
result, the skb->pfmemalloc is always true unless page_frag_cache->va is
re-allocated, even the kernel is not under memory pressure any longer.

Here is how kernel runs into issue.

1. The kernel is under memory pressure and allocation of
PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
the pfmemalloc page is allocated for page_frag_cache->va.

2: All skb->data from page_frag_cache->va (pfmemalloc) will have
skb->pfmemalloc=true. The skb will always be dropped by sock without
SOCK_MEMALLOC. This is an expected behaviour.

3. Suppose a large amount of pages are reclaimed and kernel is not under
memory pressure any longer. We expect skb->pfmemalloc drop will not happen.

4. Unfortunately, page_frag_alloc() does not proactively re-allocate
page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
skb->pfmemalloc is always true even kernel is not under memory pressure any
longer.

Therefore, this patch always checks and tries to avoid re-using the
pfmemalloc page for page_frag_alloc->va.

Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bert Barbe <bert.barbe@oracle.com>
Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: SRINIVAS <srinivas.eeda@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 mm/page_alloc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23f5066bd4a5..291df2f9f8f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5075,6 +5075,16 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 	struct page *page;
 	int offset;
 
+	/*
+	 * Try to avoid re-using pfmemalloc page because kernel may already
+	 * run out of the memory pressure situation at any time.
+	 */
+	if (unlikely(nc->va && nc->pfmemalloc)) {
+		page = virt_to_page(nc->va);
+		__page_frag_cache_drain(page, nc->pagecnt_bias);
+		nc->va = NULL;
+	}
+
 	if (unlikely(!nc->va)) {
 refill:
 		page = __page_frag_cache_refill(nc, gfp_mask);
-- 
2.17.1

