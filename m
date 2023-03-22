Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D476C4B58
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjCVNLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCVNLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B4661A90
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679490614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OgqnJyMoSlwpApjnjq5FXvCo3gtvaNVn/rTRRodDgl4=;
        b=Q8k3OA2oOru21+s3zAJPwysnoxTOnm51eqH37ZnMPDak2uRQ7fHGYFSy/g6JD6tmX8vrO4
        xMlezEdhwgxQr/0FblMzClHJ7suD+oYEjYFwwAQS0arpc0u0zrrT0Ky426MMY9nOiDBKnq
        KWa/DyVAfA9XRU7GsWJVZaNC0kZ/UrQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-x_WLiTFRNCqXFBDIY2WLhQ-1; Wed, 22 Mar 2023 09:10:10 -0400
X-MC-Unique: x_WLiTFRNCqXFBDIY2WLhQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E1D2886467;
        Wed, 22 Mar 2023 13:10:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5195642C827;
        Wed, 22 Mar 2023 13:10:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com>
References: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com> <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com> <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com> <20230316152618.711970-1-dhowells@redhat.com> <20230316152618.711970-28-dhowells@redhat.com> <754534.1678983891@warthog.procyon.org.uk> <809995.1678990010@warthog.procyon.org.uk>
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
Content-ID: <3243439.1679490606.1@warthog.procyon.org.uk>
Date:   Wed, 22 Mar 2023 13:10:06 +0000
Message-ID: <3243440.1679490606@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trond Myklebust <trondmy@hammerspace.com> wrote:

> Add an enum iter_type for ITER_ITER ? :-)

Actually, that might not be such a bad idea, now that I've pondered on it some
more.  Give it an array of iterators and add a flag to each iterator to say if
it can be spliced from or not.

Once ITER_PIPE is killed off, advancing and reverting over it should be pretty
straightforward - though each iterator would also need to keep track of how
big it started off as in order that it can be reverted over.

David

