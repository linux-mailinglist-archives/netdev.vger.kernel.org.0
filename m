Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D270D6C8293
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCXQss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCXQsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:48:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5BD1DBAC
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679676479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GYpegQTjs8QE2vMjmbkJrxADGrCfBG31fu1995bYC+o=;
        b=XreL50cxO0Jbt53gBOWp8uopWnlXPVReXudSIPucA4sObw8uKRxVNB7lsajQsdg/GN/ouN
        krpJ+gGE737P61G/SUffp1JPcKhkDQabPbDe1qHzj85D4DBaPQ2T0Xr4sYeCBYPDTb+6l5
        6CzFdbp1h3oJTFhHkBWlblo2/I6rW1M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-VJ8UMeoZOXiWZHJjI0z7SQ-1; Fri, 24 Mar 2023 12:47:53 -0400
X-MC-Unique: VJ8UMeoZOXiWZHJjI0z7SQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2344801206;
        Fri, 24 Mar 2023 16:47:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB2EB492C3E;
        Fri, 24 Mar 2023 16:47:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZBPTC9WPYQGhFI30@gondor.apana.org.au>
References: <ZBPTC9WPYQGhFI30@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, willy@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        viro@zeniv.linux.org.uk, hch@infradead.org, axboe@kernel.dk,
        jlayton@kernel.org, brauner@kernel.org,
        torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 23/28] algif: Remove hash_sendpage*()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3763054.1679676470.1@warthog.procyon.org.uk>
Date:   Fri, 24 Mar 2023 16:47:50 +0000
Message-ID: <3763055.1679676470@warthog.procyon.org.uk>
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

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> David Howells <dhowells@redhat.com> wrote:
> > Remove hash_sendpage*() and use hash_sendmsg() as the latter seems to just
> > use the source pages directly anyway.
> 
> ...
> 
> > -       if (!(flags & MSG_MORE)) {
> > -               if (ctx->more)
> > -                       err = crypto_ahash_finup(&ctx->req);
> > -               else
> > -                       err = crypto_ahash_digest(&ctx->req);
> 
> You've just removed the optimised path from user-space to
> finup/digest.  You need to add them back to sendmsg if you
> want to eliminate sendpage.

I must be missing something, I think.  What's particularly optimal about the
code in hash_sendpage() but not hash_sendmsg()?  Is it that the former uses
finup/digest, but the latter ony does update+final?

Also, looking at:

	if (!ctx->more) {
		if ((msg->msg_flags & MSG_MORE))
			hash_free_result(sk, ctx);

how is ctx->more meant to be interpreted?  I'm guessing it means that we're
continuing to the previous op.  But we do we need to free any old result if
MSG_MORE is set, but not if it isn't?

David

