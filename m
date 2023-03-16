Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02A56BD710
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCPR3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCPR3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:29:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8E6B06D9
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678987696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hzxcSRtKQlA0e6rFrTWceT+M7ty2llKw335P2T8iHI=;
        b=Af5LtK5x01goFUnCAhElq7DRGLniWa45bxWOCw/Hmxf2fOv6/AaOeUVgv1iwCzIOWzDmAM
        tjWSsbwZAh/24d5lLSUtSnZi5EtAK0du2vTvRD9b1ItF9vgqKnmQYEvtrbIQuUIasdUUAy
        9zHipDa2fqCRb9mHYN3HoAxZx9ESOus=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-X_O2pjKoObCWcsos-J3Lyg-1; Thu, 16 Mar 2023 13:28:11 -0400
X-MC-Unique: X_O2pjKoObCWcsos-J3Lyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BAE7857FBF;
        Thu, 16 Mar 2023 17:28:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EDC135454;
        Thu, 16 Mar 2023 17:28:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <4EDC79DC-0C32-40FD-9C35-164C7A077922@oracle.com>
References: <4EDC79DC-0C32-40FD-9C35-164C7A077922@oracle.com> <20230316152618.711970-1-dhowells@redhat.com> <20230316152618.711970-28-dhowells@redhat.com> <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, Trond Myklebust <trondmy@hammerspace.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffrey Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <782775.1678987682.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 16 Mar 2023 17:28:02 +0000
Message-ID: <782776.1678987682@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever III <chuck.lever@oracle.com> wrote:

> That means I haven't seen the cover letter and do not have any
> context for this proposed change.

https://lore.kernel.org/linux-fsdevel/20230316152618.711970-1-dhowells@red=
hat.com/

> We've tried combining the sendpages calls in here before. It
> results in a significant and measurable performance regression.
> See:
> =

> da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg for socket =
sends")

The commit replaced the use of sendpage with sendmsg, but that took away t=
he
zerocopy aspect of sendpage.  The idea behind MSG_SPLICE_PAGES is that it
allows you to do keep that.  I'll have to try reapplying this commit and
adding the MSG_SPLICE_PAGES flag.

> Therefore, this kind of change needs to be accompanied by both
> benchmark results and some field testing to convince me it won't
> cause harm.

Yep.

> And, we have to make certain that this doesn't break operation
> with kTLS sockets... do they support MSG_SPLICE_PAGES ?

I haven't yet tackled AF_TLS, AF_KCM or AF_SMC as they seem significantly =
more
complex than TCP and UDP.  I thought I'd get some feedback on what I have
before I tried my hand at those.

David

