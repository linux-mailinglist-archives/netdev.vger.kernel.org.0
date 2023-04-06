Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC006D9489
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbjDFK5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbjDFK5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:57:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0FC5FC7
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 03:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680778601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zMeQxZQg6MXfV4MGHzz3ouxaZBZa4sXe5adkrdIvgDA=;
        b=h1kRa8TsbkiRR7MDE8muDt6upawdYYnAIe/YYxvx8FpAy5higCcTOr5p0hPapNKfj5Cwl/
        XLiz8DTBe1LHNupaEipjSEwuyAOGJrc0jqIBgfg9v8zfb8mvn4Ga+UuOyO8ub+8VJNDbe2
        lc38DKDNFHKVAfPajvDDDE8HzOx40Ys=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-dI7Qid53N0-2fcggxMEYxg-1; Thu, 06 Apr 2023 06:56:38 -0400
X-MC-Unique: dI7Qid53N0-2fcggxMEYxg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01EB9384708E;
        Thu,  6 Apr 2023 10:56:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B936492C14;
        Thu,  6 Apr 2023 10:56:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANn89iLFc3gxo-5gEn36VFYdocXQPiAqRsTPEHcB8JA3mw8+8g@mail.gmail.com>
References: <CANn89iLFc3gxo-5gEn36VFYdocXQPiAqRsTPEHcB8JA3mw8+8g@mail.gmail.com> <20230406094245.3633290-1-dhowells@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH net-next v5 00/19] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES), part 1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3636417.1680778595.1@warthog.procyon.org.uk>
Date:   Thu, 06 Apr 2023 11:56:35 +0100
Message-ID: <3636418.1680778595@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:

> > Here's the first tranche of patches towards providing a MSG_SPLICE_PAGES
> > internal sendmsg flag that is intended to replace the ->sendpage() op with
> > calls to sendmsg().  MSG_SPLICE is a hint that tells the protocol that it
> > should splice the pages supplied if it can and copy them if not.
> >
> 
> I find this patch series quite big/risky for 6.4

If you want me to hold this till after the merge window, that's fine.

> Can you spell out why we need "unspliceable pages support" ?
> This seems to add quite a lot of code in fast paths.

The patches to copy unspliceable pages (patches 6, 14 and 19) only really add
to the MSG_SPLICE_PAGES path - I don't know whether you count this as a fast
path or not.  (Or are you objecting to MSG_SPLICE_PAGES and getting rid of
sendpage in general?)

What I'm trying to do with this aspect is twofold:

Firstly, I'm trying to make it such that the layer above can send each
message in a single sendmsg() if possible.  This is possible with sunrpc and
siw, for example, but currently they make a whole bunch of separate calls into
the transport layer - typically at least three for header, body, trailer.

Secondly, I'm trying to avoid a double copy.  The layer above TCP/UDP/etc
(sunrpc[*], siw, etc.) needs to glue protocol bits on either end of the
message body and it may have this data in the slab or on the stack - which it
would then need to copy into a page fragment so that it can be zero-copied.
However, if the device can handle this or we don't have sufficient frags, the
network layer may decide to copy it anyway - I'm not sure how the higher layer
can determine this.

It just seems there are fewer places this is required if it can be done in the
network protocol.  Note that userspace cannot make use of this since they're
not allowed to set MSG_SPLICE_PAGES.

However, I have kept these bits separate and discard them if it's considered a
bad idea and that MSG_SPLICE_PAGES should, say, give an error in such a case.

David

[*] sunrpc, at least, seems to store the header and trailer in zerocopyable
    pages, but has an additional bit on the front that's not.

