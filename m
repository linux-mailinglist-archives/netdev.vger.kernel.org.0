Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DDC6BD7CB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjCPSHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCPSHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA073B874
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678990018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z72FvUn0C+zfgOKSCB7WUz6jlvrWtPw83T7jP3vhoiw=;
        b=BYRDiBJ9ZO8vTjB8+VSWevOeyLwxYNKCO0nF1HbRDz35JtgHLAW2HTBzKE3ZAqT2uoMoGq
        dx1byxgEcv9odeiUT3UDb+nQAZxJvR2MfpXAPP7Ag3g63a35R6vpEtaXwbGOkr7nR6LojB
        B5qqs9zj1GXdx1jD/MJ5TKzp8W1bjZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-2akiADSaMgOJWrCm9Xiyrw-1; Thu, 16 Mar 2023 14:06:54 -0400
X-MC-Unique: 2akiADSaMgOJWrCm9Xiyrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80B5D101A54F;
        Thu, 16 Mar 2023 18:06:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56F502166B29;
        Thu, 16 Mar 2023 18:06:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com>
References: <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com> <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com> <20230316152618.711970-1-dhowells@redhat.com> <20230316152618.711970-28-dhowells@redhat.com> <754534.1678983891@warthog.procyon.org.uk>
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
Content-ID: <809994.1678990010.1@warthog.procyon.org.uk>
Date:   Thu, 16 Mar 2023 18:06:50 +0000
Message-ID: <809995.1678990010@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

> 1) This is code that is common to the client and the server. Why are we
> adding unused 3 bvec slots to every client RPC call?

Fair point, but I'm trying to avoid making four+ sendmsg calls in nfsd rather
than one.

> 2) It obfuscates the existence of these bvec slots.

True, it'd be nice to find a better way to do it.  Question is, can the client
make use of MSG_SPLICE_PAGES also?

> 3) knfsd may use splice_direct_to_actor() in order to avoid copying the page
> cache data into private buffers (it just takes a reference to the
> pages). Using MSG_SPLICE_PAGES will presumably require it to protect those
> pages against further writes while the socket is referencing them.

Upstream sunrpc is using sendpage with TCP.  It already has that issue.
MSG_SPLICE_PAGES is a way of doing sendpage through sendmsg.

David

