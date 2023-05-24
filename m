Return-Path: <netdev+bounces-5094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A1570FA5D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0F0B28149D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00A819BB1;
	Wed, 24 May 2023 15:34:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD719BA0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:34:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B957E42
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684942422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uekJL1E5Uz+9JLqowhoPzZVYALfVqMM/z7Y13jfCLzU=;
	b=goBkd0OowYWyH3QUPeS3qWxBlGoHkHgSDnWtPPThmZjoQLf+Dx8VCmbgEpcr17+WibYYzg
	tnhem5GYfUXEOCXSMvqq7tI9kqo9RdMGEnkwxJAFzOP9WG9rWgquHsBKCDZtCLNII3j6F3
	vcWQqo+xo3DMCX3bzqxinsHrBh9dC4U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-UtOOYHJNMQqeOwkvKYu_rw-1; Wed, 24 May 2023 11:33:38 -0400
X-MC-Unique: UtOOYHJNMQqeOwkvKYu_rw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F027280BCA2;
	Wed, 24 May 2023 15:33:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A068492B0A;
	Wed, 24 May 2023 15:33:32 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jeroen de Borst <jeroendb@google.com>,
	Catherine Sullivan <csully@google.com>,
	Shailend Chand <shailend@google.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-nvme@lists.infradead.org
Subject: [PATCH net-next 05/12] mm: Make the page_frag_cache allocator handle __GFP_ZERO itself
Date: Wed, 24 May 2023 16:33:04 +0100
Message-Id: <20230524153311.3625329-6-dhowells@redhat.com>
In-Reply-To: <20230524153311.3625329-1-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make the page_frag_cache allocator handle __GFP_ZERO itself rather than
passing it off to the page allocator.  There may be a mix of callers, some
specifying __GFP_ZERO and some not - and even if all specify __GFP_ZERO, we
might refurbish the page, in which case the returned memory doesn't get
cleared.

This is a potential bug in the nvme over TCP driver.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Jeroen de Borst <jeroendb@google.com>
cc: Catherine Sullivan <csully@google.com>
cc: Shailend Chand <shailend@google.com>
cc: Felix Fietkau <nbd@nbd.name>
cc: John Crispin <john@phrozen.org>
cc: Sean Wang <sean.wang@mediatek.com>
cc: Mark Lee <Mark-MC.Lee@mediatek.com>
cc: Lorenzo Bianconi <lorenzo@kernel.org>
cc: Matthias Brugger <matthias.bgg@gmail.com>
cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
cc: Keith Busch <kbusch@kernel.org>
cc: Jens Axboe <axboe@fb.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Sagi Grimberg <sagi@grimberg.me>
cc: Chaitanya Kulkarni <kch@nvidia.com>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
cc: linux-arm-kernel@lists.infradead.org
cc: linux-mediatek@lists.infradead.org
cc: linux-nvme@lists.infradead.org
cc: linux-mm@kvack.org
---
 mm/page_frag_alloc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/page_frag_alloc.c b/mm/page_frag_alloc.c
index ffd68bfb677d..2b73c7f5d9a9 100644
--- a/mm/page_frag_alloc.c
+++ b/mm/page_frag_alloc.c
@@ -23,7 +23,10 @@ static struct folio *page_frag_cache_refill(struct page_frag_cache *nc,
 					    gfp_t gfp_mask)
 {
 	struct folio *folio = NULL;
-	gfp_t gfp = gfp_mask;
+	gfp_t gfp;
+
+	gfp_mask &= ~__GFP_ZERO;
+	gfp = gfp_mask;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
 	gfp_mask |= __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
@@ -71,6 +74,7 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 {
 	struct folio *folio = nc->folio;
 	size_t offset;
+	void *p;
 
 	WARN_ON_ONCE(!is_power_of_2(align));
 
@@ -133,7 +137,10 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
 	offset &= ~(align - 1);
 	nc->offset = offset;
 
-	return folio_address(folio) + offset;
+	p = folio_address(folio) + offset;
+	if (gfp_mask & __GFP_ZERO)
+		return memset(p, 0, fragsz);
+	return p;
 }
 EXPORT_SYMBOL(page_frag_alloc_align);
 


