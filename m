Return-Path: <netdev+bounces-4710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C687770DFB1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91CAB1C20D5B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA911F19B;
	Tue, 23 May 2023 14:52:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDB31F17A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:52:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA0EC6
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684853575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KHDYxPG+OnNKEEbmravfdg4Ujk0LU1sywu09RiZg4i4=;
	b=Pxy/DukBKmiPPwZYmi69iMfbYvO35YY/9sFvaSUf7LyOMFHU8LCBe6HMGZAtsnHMPIsY++
	STDQ2hsGpIORn0wR7agpR4C1ZKYvKtQvx2y1yzuoRwD2RKuvkmWV5a1uURPyCrYcu5cNsN
	LkxvWormqo4OCZknj4h3GgH6LSiQ3+c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-gQyoRNafPJqNEodLpHa1nw-1; Tue, 23 May 2023 10:52:50 -0400
X-MC-Unique: gQyoRNafPJqNEodLpHa1nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 063B929AA3B0;
	Tue, 23 May 2023 14:52:50 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.23])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 620A11121314;
	Tue, 23 May 2023 14:52:49 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
	by firesoul.localdomain (Postfix) with ESMTP id 3A424307372E8;
	Tue, 23 May 2023 16:52:48 +0200 (CEST)
Subject: [PATCH RFC net-next/mm V4 0/2] page_pool: new approach for leak
 detection and shutdown phase
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>, netdev@vger.kernel.org,
 Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org,
 Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, lorenzo@kernel.org,
 =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 linyunsheng@huawei.com, bpf@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 willy@infradead.org
Date: Tue, 23 May 2023 16:52:48 +0200
Message-ID: <168485351546.2849279.13771638045665633339.stgit@firesoul>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Patchset change summary:
 - Remove PP workqueue and inflight warnings, instead rely on inflight
   pages to trigger cleanup
 - Moves leak detection to the MM-layer page allocator when combined
   with CONFIG_DEBUG_VM.

The page_pool (PP) workqueue calling page_pool_release_retry generate
too many false-positive reports. Further more, these reports of
page_pool shutdown still having inflight packets are not very helpful
to track down the root-cause.

In the past these reports have helped us catch driver bugs, that
leaked pages by invoking put_page directly, often in code paths
handling error cases. PP pages had a shorter lifespan (within driver
and XDP code paths). Since PP pages got a recycle return path for
SKBs, the lifespan for a PP page can be much longer. Thus, it is time
to revisit periodic release retry mechanism. The default 60 sec
lifespan assumption is obviously wrong/obsolete, as things like TCP
sockets can keep SKBs around for much longer (e.g. retransmits,
timeouts, NAPI defer schemes etc).

The inflight reports, means one of two things: (1) API user is still
holding on, or (2) page got leaked and will never be returned to PP.
The PP need to accept it have no control over (1) how long outstanding
PP pages are kept by the API users. What we really want to is to catch
are(2) pages that "leak". Meaning they didn't get proper returned via
PP APIs.

Leaked PP pages result in these issues: (A) We can never release
page_pool memory structs, which (B) holds on to a refcnt on struct
device for DMA mapping, and (C) leaking DMA-mappings that (D) means a
hardware device can potentially write into a page returned to the page
allocator.

V4: Use RCU sync method to resolve races

V3: Fix races found Toke

V2: Fix race found by Yunsheng Lin <linyunsheng@huawei.com>

---

Jesper Dangaard Brouer (2):
      mm/page_pool: catch page_pool memory leaks
      page_pool: Remove workqueue in new shutdown scheme


 include/net/page_pool.h |  10 +--
 mm/page_alloc.c         |   7 ++
 net/core/page_pool.c    | 138 ++++++++++++++++++++++++++++------------
 3 files changed, 111 insertions(+), 44 deletions(-)

--


