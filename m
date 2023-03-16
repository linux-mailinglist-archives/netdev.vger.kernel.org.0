Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9796BD581
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCPQZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCPQZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37143D521
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 09:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678983898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P2ASxqGtebQqLOzZD8O/ATkw0sdUpI75GL+Hn4BrEXQ=;
        b=c+JrYdWnHsz6Kk43nn/yqyF78OvCl22DL6cqEPlOYJJZxzrNnlPjXl0nbWjIrPf+b2FhAe
        Issbh1cRTEOi5FNX7rNjt46ACD6dYlOaYUn1U1FJwHmkQmuEvOfGJdvdllD+Z2xNWHA20/
        DPUy/4/ZM9RuG+2WTgqEGJwu3+HEhn8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-gfY7XOqBPESOSXRoa7US_w-1; Thu, 16 Mar 2023 12:24:55 -0400
X-MC-Unique: gfY7XOqBPESOSXRoa7US_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 620A93C1068F;
        Thu, 16 Mar 2023 16:24:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 076984042AC8;
        Thu, 16 Mar 2023 16:24:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
References: <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com> <20230316152618.711970-1-dhowells@redhat.com> <20230316152618.711970-28-dhowells@redhat.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
        Charles Edward Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <754533.1678983891.1@warthog.procyon.org.uk>
Date:   Thu, 16 Mar 2023 16:24:51 +0000
Message-ID: <754534.1678983891@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trond Myklebust <trondmy@hammerspace.com> wrote:

> > + buf->bvec += 2;
> > + buf->bvec[-2].bv_page = NULL;
> > + buf->bvec[-1].bv_page = NULL;
> 
> NACK.

Can you elaborate?

Is it that you dislike allocating extra slots for protocol bits?  Or just that
the bvec[] is offset by 2?  Or some other reason?

David

