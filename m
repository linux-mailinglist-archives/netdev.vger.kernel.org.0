Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3057E6E167D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjDMV14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDMV1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:27:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C72AD04
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681421228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXoXuwHwggTCSjwlFujDwYoatDG4/c/4JuEabqde8o4=;
        b=TWlNl70PAMNa1a8keJVL24i+9ZnhEVLoczerAJeHfPyCjQKFfgxd+te9HPp4fWeE0WuhP9
        JJGBPLMFZG/IL9d1ZYFaCRwN9yRHx4i703GuXevS5gaPH0hGOGXAJFwFv7wiVqRVoEeiTv
        GRFoFfILgqD2xXpXr2SzodZcBD+Y/6k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-FAdCCV2ANj2qvZ0o-Yp-KQ-1; Thu, 13 Apr 2023 17:27:00 -0400
X-MC-Unique: FAdCCV2ANj2qvZ0o-Yp-KQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCF173C0F22E;
        Thu, 13 Apr 2023 21:26:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA69CC16028;
        Thu, 13 Apr 2023 21:26:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230413044123.GB3390869@ZenIV>
References: <20230413044123.GB3390869@ZenIV> <20230411160902.4134381-1-dhowells@redhat.com> <20230411160902.4134381-7-dhowells@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: How to determine if a page can be spliced into an skbuff, or if it should be copied/rejected?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1208133.1681421217.1@warthog.procyon.org.uk>
Date:   Thu, 13 Apr 2023 22:26:57 +0100
Message-ID: <1208134.1681421217@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Tue, Apr 11, 2023 at 05:08:50PM +0100, David Howells wrote:
> > Add a function to handle MSG_SPLICE_PAGES being passed internally to
> > sendmsg().  Pages are spliced into the given socket buffer if possible and
> > copied in if not (ie. they're slab pages or have a zero refcount).
> 
> That "ie." would better be "e.g." - that condition is *not* enough for
> tell the unsafe ones from the rest.
> 
> sendpage_ok() would be better off called "might_be_ok_to_sendpage()".
> If it's false, we'd better not grab a reference to the page and expect the
> sucker to stay safe until the reference is dropped.  However, AFAICS
> it might return true on a page that is not safe in that respect.
> 
> What rules do you propose for sendpage users?  "Pass whatever page reference
> you want, it'll do the right thing"?  Anything short of that would better
> be documented as explicitly as possible...

Hmmm...  Fair point.  Is everything passed through splice guaranteed to be
safe, I wonder?  Probably not because vmsplice().  Does that mean the existing
callers of sendpage_ok() are also making unviable assumptions?

So there are the following 'classes' of memory that I can immediately think
of:

 - Zero page				Splice (no ref?)
 - Kernel core data			Splice
 - Module core data (vmalloc'd)		Splice
 - Supervisor stack			Copy
 - Slab objects				Copy
 - Page frags				Splice
 - Other skbuff frags			Splice
 - Arbitrary pages (eg. sunrpc xdr buf)	Splice (probably)
 - Ordinary pipe buffers		Splice
 - Spliced tmpfs			Splice
 - Spliced pagecache (file/block)	Splice
 - Spliced DIO file/block		Splice
 - Vmspliced mmap'd anon		Splice (with pin?)
 - Vmspliced MAP_SHARED pagecache	Splice (with pin?)
 - Vmspliced MAP_SHARED DAX		Splice?
 - Vmspliced MAP_SHARED MTD		Splice?
 - Vmspliced MAP_SHARED other device	Reject? (e.g. graphics card mem)
 - Vmspliced /dev/{mem,kmem}		Reject?
 
Question is how to tell that we're looking at something that must be copied or
rejected?  sendpage_ok() checks the PG_slab bit and the pagecount, for
example.

David

