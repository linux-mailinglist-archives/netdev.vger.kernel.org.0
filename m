Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C2B2B38FD
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 21:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgKOUQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 15:16:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35384 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKOUQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 15:16:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFKFgcE070900;
        Sun, 15 Nov 2020 20:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=aAP7NEpPhJaLfVSkAw1EFepSSFXX6aFlTtVNOEDZoYM=;
 b=FFBX/ieyMiBRg6X3MSa/FhJ0gMN00AodZoSmj5NAGxeMbjNubqu7Bug/MZDLVCOJc+t1
 Bj3zgJu6yw6bY8mMXTjuhBcDRBfIu9XRDeOozsL8QlQ9ya/qZRZ/gPYN3AZuCnrniapL
 fTbQCba1N6QiQRKhZ001rm08bG1k8Cb95TV8z6UP+oDn5Ua7K1Ni3ZgNrgm75dSC0HnW
 LRdCZAIu53QqKisN5CMgmclAUd0vuYaEdFo5Hbsv2Q9eZmXf/jZ/bSds03K3gl23NoJ/
 vyDvwlMkCFX0C9h+8TckQD9xMDcVfyYGPHGKPKsRWCNvJDD5OakTXfwTL/st69pvpvDL cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76kjr11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 20:16:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AFKB9iT027537;
        Sun, 15 Nov 2020 20:14:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34ts4vnn6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 20:14:25 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AFKEM4S015914;
        Sun, 15 Nov 2020 20:14:22 GMT
Received: from localhost.localdomain (/10.211.9.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Nov 2020 12:14:22 -0800
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     linux-mm@kvack.org, netdev@vger.kernel.org
Cc:     willy@infradead.org, aruna.ramakrishna@oracle.com,
        bert.barbe@oracle.com, rama.nichanamatlu@oracle.com,
        venkat.x.venkatsubra@oracle.com, manjunath.b.patil@oracle.com,
        joe.jin@oracle.com, srinivas.eeda@oracle.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, vbabka@suse.cz, dongli.zhang@oracle.com
Subject: [PATCH v3 1/1] page_frag: Recover from memory pressure
Date:   Sun, 15 Nov 2020 12:10:29 -0800
Message-Id: <20201115201029.11903-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9806 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9806 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethernet driver may allocate skb (and skb->data) via napi_alloc_skb().
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
re-allocated, even if the kernel is not under memory pressure any longer.

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

Fix this by freeing and re-allocating the page instead of recycling it.

References: https://lore.kernel.org/lkml/20201103193239.1807-1-dongli.zhang@oracle.com/
References: https://lore.kernel.org/linux-mm/20201105042140.5253-1-willy@infradead.org/
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bert Barbe <bert.barbe@oracle.com>
Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: SRINIVAS <srinivas.eeda@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
Changed since v1:
  - change author from Matthew to Dongli
  - Add references to all prior discussions
  - Add more details to commit message
Changed since v2:
  - add unlikely (suggested by Eric Dumazet)

 mm/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23f5066bd4a5..91129ce75ed4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5103,6 +5103,11 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
 			goto refill;
 
+		if (unlikely(nc->pfmemalloc)) {
+			free_the_page(page, compound_order(page));
+			goto refill;
+		}
+
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
 		/* if size can vary use size else just use PAGE_SIZE */
 		size = nc->size;
-- 
2.17.1

