Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA55C0511
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiIURFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIURFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:05:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BA994132
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 10:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663779936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dop/yQNgSfer6xycyc296gMaMN1mBOfePrFpa2HytUk=;
        b=R5ShYha6rj+tfovEcVz+HDjgtBXX5CAku8W8i0xVDCrGe5OC/ibbV7FGm/rTw3ABSrY2j1
        6gvwrR4BrOWBbODZOJDwfjIEvy8R6SDpf4ZV9htXSC4ppC07+41BWCKuVGb8irvqEol7CW
        4keqWUFnd0jb9xPCv9u7ZviDOmMNdcM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-eFrvd1nMP6SY8s_uPWvKVA-1; Wed, 21 Sep 2022 13:05:35 -0400
X-MC-Unique: eFrvd1nMP6SY8s_uPWvKVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F45D3C021A3;
        Wed, 21 Sep 2022 17:05:34 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 072E540C6EC2;
        Wed, 21 Sep 2022 17:05:34 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id EC12230721A6C;
        Wed, 21 Sep 2022 19:05:32 +0200 (CEST)
Subject: [PATCH net-next] xdp: improve page_pool xdp_return performance
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>, mtahhan@redhat.com,
        mcroce@microsoft.com
Date:   Wed, 21 Sep 2022 19:05:32 +0200
Message-ID: <166377993287.1737053.10258297257583703949.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During LPC2022 I meetup with my page_pool co-maintainer Ilias. When
discussing page_pool code we realised/remembered certain optimizations
had not been fully utilised.

Since commit c07aea3ef4d4 ("mm: add a signature in struct page") struct
page have a direct pointer to the page_pool object this page was
allocated from.

Thus, with this info it is possible to skip the rhashtable_lookup to
find the page_pool object in __xdp_return().

The rcu_read_lock can be removed as it was tied to xdp_mem_allocator.
The page_pool object is still safe to access as it tracks inflight pages
and (potentially) schedules final release from a work queue.

Created a micro benchmark of XDP redirecting from mlx5 into veth with
XDP_DROP bpf-prog on the peer veth device. This increased performance
6.5% from approx 8.45Mpps to 9Mpps corresponding to using 7 nanosec
(27 cycles at 3.8GHz) less per packet.

Suggested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/xdp.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 24420209bf0e..844c9d99dc0e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -375,19 +375,17 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
 void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
 		  struct xdp_buff *xdp)
 {
-	struct xdp_mem_allocator *xa;
 	struct page *page;
 
 	switch (mem->type) {
 	case MEM_TYPE_PAGE_POOL:
-		rcu_read_lock();
-		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
-		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
 		page = virt_to_head_page(data);
 		if (napi_direct && xdp_return_frame_no_direct())
 			napi_direct = false;
-		page_pool_put_full_page(xa->page_pool, page, napi_direct);
-		rcu_read_unlock();
+		/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
+		 * as mem->type knows this a page_pool page
+		 */
+		page_pool_put_full_page(page->pp, page, napi_direct);
 		break;
 	case MEM_TYPE_PAGE_SHARED:
 		page_frag_free(data);


