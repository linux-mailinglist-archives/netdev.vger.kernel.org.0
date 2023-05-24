Return-Path: <netdev+bounces-5088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F9170FA35
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D88D71C20E4A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3251D19BA5;
	Wed, 24 May 2023 15:33:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2560619BA4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:33:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC790191
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684942398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HDfdVGS42cRDlfVmkzM60v0gqW3TrtFRZVqqSMTDfdY=;
	b=aFfZhxi8oehXzWhEbQVlRTvVbMFGPma8OEbTx4wrmZUhG2YbGXpPUCQg6j2VMM7zUmd3zR
	HLgK2I/h4UgS1l6KsikywT1RfV7BBkxoo6e7cI/ca2jRUjOfr/erMDpYmgp6gkg8rr8tw2
	QWROQ1NW17Bu/oCiK2LERYwgnauwtPI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-iEbf6p2kN9S3oSPRTvetUQ-1; Wed, 24 May 2023 11:33:15 -0400
X-MC-Unique: iEbf6p2kN9S3oSPRTvetUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA3AE280BC9A;
	Wed, 24 May 2023 15:33:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03A338162;
	Wed, 24 May 2023 15:33:12 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/12] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES), part 3
Date: Wed, 24 May 2023 16:32:59 +0100
Message-Id: <20230524153311.3625329-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here's the third tranche of patches towards providing a MSG_SPLICE_PAGES
internal sendmsg flag that is intended to replace the ->sendpage() op with
calls to sendmsg().  MSG_SPLICE_PAGES is a hint that tells the protocol
that it should splice the pages supplied if it can and copy them if not.

The primary focus of this tranche is to allow data passed in the slab to be
copied into page fragments (appending it to existing free space within an
sk_buff could also be possible), thereby allowing a single sendmsg() to mix
data held in the slab (such as higher-level protocol pieces) and data held
in pages (such as content for a network filesystem).  This puts the copying
in (mostly) one place: skb_splice_from_iter().

To make this work, some sort of locking is needed with the allocator.  I've
chosen to make the allocator internally have a separate bucket per cpu, as
the netdev and napi allocators already do - and then share the allocated
pages amongst those services that were using their own allocators.  I'm not
sure that the existing usage of the allocator is completely thread safe.

TLS is also converted here because that does things differently and uses
sk_msg rather than sk_buff - and so can't use skb_splice_from_iter().

So, firstly the page_frag_alloc_align() allocator is overhauled:

 (1) Split it out from mm/page_alloc.c into its own file,
     mm/page_frag_alloc.c.

 (2) Add a common function to clear an allocator.

 (3) Make the alignment specification consistent with some of the wrapper
     functions.

 (4) Make it use multipage folios rather than compound pages.

 (5) Make it handle __GFP_ZERO, rather than devolving this to the page
     allocator.

     Note that the current behaviour is potentially broken as the page may
     get reused if all refs have been dropped, but it doesn't then get
     cleared.  This might mean that the NVMe over TCP driver, for example,
     will malfunction under some circumstances.

 (6) Give it per-cpu buckets to allocate from to avoid the need for locking
     against users on other cpus.

 (7) The netdev_alloc_cache and the napi fragment cache are then recast
     in terms of this and some private allocators are removed.

We can then make use of the page fragment allocator to copy data that is
resident in the slab rather than returning EIO:

 (8) Make skb_splice_from_iter() copy data provided in the slab to page
     fragments.

 (9) Implement MSG_SPLICE_PAGES support in the AF_TLS-sw sendmsg and make
     tls_sw_sendpage() just a wrapper around sendmsg().

(10) Implement MSG_SPLICE_PAGES support in AF_TLS-device and make
     tls_device_sendpage() just a wrapper around sendmsg().

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-3

David

Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=51c78a4d532efe9543a4df019ff405f05c6157f6 # part 1

David Howells (12):
  mm: Move the page fragment allocator from page_alloc.c into its own
    file
  mm: Provide a page_frag_cache allocator cleanup function
  mm: Make the page_frag_cache allocator alignment param a pow-of-2
  mm: Make the page_frag_cache allocator use multipage folios
  mm: Make the page_frag_cache allocator handle __GFP_ZERO itself
  mm: Make the page_frag_cache allocator use per-cpu
  net: Clean up users of netdev_alloc_cache and napi_frag_cache
  net: Copy slab data for sendmsg(MSG_SPLICE_PAGES)
  tls/sw: Support MSG_SPLICE_PAGES
  tls/sw: Convert tls_sw_sendpage() to use MSG_SPLICE_PAGES
  tls/device: Support MSG_SPLICE_PAGES
  tls/device: Convert tls_device_sendpage() to use MSG_SPLICE_PAGES

 drivers/net/ethernet/google/gve/gve.h      |   1 -
 drivers/net/ethernet/google/gve/gve_main.c |  16 --
 drivers/net/ethernet/google/gve/gve_rx.c   |   2 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c |  19 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h |   2 -
 drivers/nvme/host/tcp.c                    |  19 +-
 drivers/nvme/target/tcp.c                  |  22 +-
 include/linux/gfp.h                        |  17 +-
 include/linux/mm_types.h                   |  13 +-
 include/linux/skbuff.h                     |  28 +--
 mm/Makefile                                |   2 +-
 mm/page_alloc.c                            | 126 ------------
 mm/page_frag_alloc.c                       | 206 +++++++++++++++++++
 net/core/skbuff.c                          |  94 +++++----
 net/tls/tls_device.c                       |  93 ++++-----
 net/tls/tls_sw.c                           | 221 ++++++++-------------
 16 files changed, 418 insertions(+), 463 deletions(-)
 create mode 100644 mm/page_frag_alloc.c


