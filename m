Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D6F6CFFCA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjC3JaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjC3J37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:29:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A1D6A74
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680168558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+XgWAMkX5gl81w36XkfWKNCMFULxOFJmmzo6Xs6xITY=;
        b=fDxXL5UFgf7aE0JobexeR6Ro6kgqZr/MbfxZ5xcUKUub+oNOMXk0RiW1VY1r6iO4QddRiK
        3AiCywBJKIaJZRe1rxh3E2RIeof9Mn7eI0iKiTTqAQALHUBpuITxXboiWR6LbePlqOUDkr
        N009oDwgkGBmvN6BD7JKfr0NTIWIblo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-jczfNWu4OtqMRHX0J7vacA-1; Thu, 30 Mar 2023 05:29:11 -0400
X-MC-Unique: jczfNWu4OtqMRHX0J7vacA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C7768828CB;
        Thu, 30 Mar 2023 09:29:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE8D34020C82;
        Thu, 30 Mar 2023 09:29:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
References: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-41-dhowells@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <777294.1680168547.1@warthog.procyon.org.uk>
Date:   Thu, 30 Mar 2023 10:29:07 +0100
Message-ID: <777295.1680168547@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever III <chuck.lever@oracle.com> wrote:

> It seems to me that you could eliminate the kernel_sendpage()
> consumer here in svc_tcp_sendmsg() without also replacing the
> kernel_sendmsg() calls. That would be a conservative step-wise
> approach which would carry less risk, and would accomplish
> your stated goal without more radical surgery.

Note that only the marker is sent with kernel_sendmsg() in the unmodified
code; the head and tail are sent with svc_tcp_send_kvec()... which uses
kernel_sendpage() which needs to be changed in my patchset.  I can make it do
individual sendmsg calls for all those for now.

David

