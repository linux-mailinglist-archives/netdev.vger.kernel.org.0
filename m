Return-Path: <netdev+bounces-5033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 120E870F781
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0C3B2813FE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7580B17ACE;
	Wed, 24 May 2023 13:21:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF1717AB5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:21:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CED3E61
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684934505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zd0OFfNiZ9y269Uix6ptp+k9hpY/9UM79H7Ki9EesyY=;
	b=DjlBz/coc0O71wbZwvZHEZca5XOTytG9R7EV5YgaooNyrPHa7CovY1dpEdwpNzUtp+ZXrH
	EkXV+FSsYdf+0/7Ex0kVwkpTpV8co6W1422vn/me6Isfo0EyoTdTGpQhAuz7ZZlPEmGQHe
	0T3LQ4KEvOvxjRGMtGV6Io7ziOTOLZs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-p0cb3Y9GNjKJiZIUxGFWzw-1; Wed, 24 May 2023 09:21:40 -0400
X-MC-Unique: p0cb3Y9GNjKJiZIUxGFWzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B37085A5AA;
	Wed, 24 May 2023 13:21:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9ED140C6EC4;
	Wed, 24 May 2023 13:21:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <82041a42-e7b0-bde3-0f70-8ad180565794@huawei.com>
References: <82041a42-e7b0-bde3-0f70-8ad180565794@huawei.com> <20230522121125.2595254-1-dhowells@redhat.com> <20230522121125.2595254-4-dhowells@redhat.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Al Viro <viro@zeniv.linux.org.uk>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Jeff Layton <jlayton@kernel.org>,
    Christian Brauner <brauner@kernel.org>,
    Chuck Lever III <chuck.lever@oracle.com>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org
Subject: Re: [PATCH net-next v10 03/16] net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3587227.1684934494.1@warthog.procyon.org.uk>
Date: Wed, 24 May 2023 14:21:34 +0100
Message-ID: <3587228.1684934494@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Yunsheng Lin <linyunsheng@huawei.com> wrote:

> > + * Returns the amount of data spliced/copied or -EMSGSIZE if there's
> 
> I am not seeing any copying done directly in the skb_splice_from_iter(),
> maybe iov_iter_extract_pages() has done copying for it?

Ah, I took the code for that out and deferred it.  The comment needs amending.

> > +			ret = skb_append_pagefrags(skb, page, off, part,
> > +						   frag_limit);
> > +			if (ret < 0) {
> > +				iov_iter_revert(iter, len);
> 
> I am not sure I understand the error handling here, doesn't 'len'
> indicate the remaining size of the data to be appended to skb,

Yes.

> maybe we should revert the size of data that is already appended to skb
> here?  Does 'spliced' need to be adjusted accordingly?

Neither.

> I am not very familiar with the 'struct iov_iter' yet

An iov_iter struct is a cursor over a buffer.  It advances as we draw data or
space from that buffer.  Sometimes we overdraw and have to back up a bit -
hence the revert function.  It could possibly be renamed to something more
appropriate as (if/when ITER_PIPE is removed) it doesn't actually change the
buffer.

So looking at skb_splice_from_iter():

iov_iter_extract_pages() is used to get a list of pages from the buffer that
we think we're going to be able to handle.  If the buffer is of type IOVEC or
UBUF those pages would have pins inserted into them also; otherwise no pin or
ref will be taken on them.  MSG_SPLICE_PAGES should not be used with IOVEC or
UBUF types for the moment as the network layer does not yet handle pins.

iov_iter_extract_pages() will advance the iterator past the page fragments it
has returned.  If skb_append_pagefrags() indicates that it could not attach
the page, this isn't necessarily fatal - it could return -EMSGSIZE to indicate
there was no space, in which case we return to the caller to create a new
skbuff.

If a non-fatal error occurs, we may already have committed some parts of the
buffer to the skbuff and rewinding into that part of the buffer would cause a
repeat of the data which would be bad.

What the iov_iter_revert() is doing is rewinding iterator back past the part
of the extracted pages that we didn't get to use so that we will pick up where
we left off next time we're called.  It does *not* and must not revert the
data we've already transferred.

Arguably, I should revert when I return -EIO because sendpage_ok() returned
false, but that's a fatal error.

David


