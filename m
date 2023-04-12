Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA846E0257
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjDLXNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjDLXNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C283F8E
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 16:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681341169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DqjVx8DdVE7yyHJKc/GaG9WLw8shGI6NpWmfl69SUoE=;
        b=No226KILXjpLNzH8tfjJGn+SkMp0y/YGzTsed1Al8RB5eY/t7la8q/5n2bv+t4k3dKYRlV
        WNQzfzbSvAJhA5SCDKGglheh793ZukFtBRVjBgb6Zom8VPMsY+om7jUE7jbXTB5iMcZxtq
        EBrpFfsk7N617gngqoBZB0tY0Rg2ee0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-RzSsyzYVPU2T4nYnBVXo7Q-1; Wed, 12 Apr 2023 19:12:47 -0400
X-MC-Unique: RzSsyzYVPU2T4nYnBVXo7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D72A7101A550;
        Wed, 12 Apr 2023 23:12:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78B9A2166B26;
        Wed, 12 Apr 2023 23:12:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZDbO3haK/1+7xdRC@infradead.org>
References: <ZDbO3haK/1+7xdRC@infradead.org> <20230411160902.4134381-1-dhowells@redhat.com> <20230411160902.4134381-5-dhowells@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        Shailend Chand <shailend@google.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/18] mm: Make the page_frag_cache allocator use per-cpu
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <399349.1681341160.1@warthog.procyon.org.uk>
Date:   Thu, 13 Apr 2023 00:12:40 +0100
Message-ID: <399350.1681341160@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Apr 11, 2023 at 05:08:48PM +0100, David Howells wrote:
> > Make the page_frag_cache allocator have a separate allocation bucket for
> > each cpu to avoid racing.  This means that no lock is required, other than
> > preempt disablement, to allocate from it, though if a softirq wants to
> > access it, then softirq disablement will need to be added.
> ...
> Let me ask a third time as I've not got an answer the last two times:

Sorry about that.  I think the problem is that the copy of the message from
you directly to me arrives after the first copy that comes via a mailing list
and google then deletes the direct one - as obviously no one could possibly
want duplicates, right? :-/ - and so you usually get consigned to the
linux-kernel or linux-fsdevel mailing list folder.

> > Make the NVMe, mediatek and GVE drivers pass in NULL to page_frag_cache()
> > and use the default allocation buckets rather than defining their own.
> 
> why are these callers treated different from the others?

There are only four users of struct page_frag_cache, the one these patches
modify::

 (1) GVE.
 (2) Mediatek.
 (3) NVMe.
 (4) skbuff.

Note that things are slightly confused by there being three very similarly
named frag allocators (page_frag and page_frag_1k in addition to
page_frag_cache) and the __page_frag_cache_drain() function gets used for
things other than just page_frag_cache.

I've replaced the single allocation buckets with per-cpu allocation buckets
for (1), (2) and (3) so that no locking[*] is required other than pinning it
to the cpu temporarily - but I can't test them as I don't have hardware.

[*] Note that what's upstream doesn't have locking, and I'm not sure all the
    users of it are SMP-safe.

That leaves (4).

Upstream, skbuff.c creates two separate per-cpu frag caches and I've elected
to retain that, except that the per-cpu bits are now inside the frag allocator
as I'm not entirely sure of the reason that there's a separate napi frag cache
to the netdev_alloc_cache.

The general page_frag_cache allocator is used by skb_splice_from_iter() if it
encounters a page it can't take a ref on, so it has been tested through that
using sunrpc, sunrpc+siw and cifs+siw.

> Can you show any performance numbers?

As far as I can tell, it doesn't make any obvious difference to directly
pumping data through TCP or TLS over TCP or transferring data over a network
filesystem such as sunrpc or cifs using siw/TCP.  I've tested this between two
machines over a 1G and a 10G link.

I can generate some actual numbers tomorrow.


Actually, I probably can drop these patches 2-4 from this patchset and just
use the netdev_alloc_cache in skb_splice_from_iter() for now.  Since that
copies unspliceable data, I no longer need to allocate frags in the next layer
up.

David

