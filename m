Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0D46D4347
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjDCLTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjDCLTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:19:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23847618E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680520703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3+8yBXuWwYwm/RpoWa1fwtJLk+q+QMOFz0XiMtf0/1A=;
        b=Ti4npY8JzUOpQ0E0WPvNBsyYSahBsKbY5+SD3nDJ38j4MR9wWyMyOP3oq7Gcm9qD2OgG+W
        EiNoBccCSpJcov72qAMq+9pEApDEix18PsggnJTkGjke0a61rNms/p9Ee8KakaZ2bnQAGd
        SxnODm5dh6vdmotqEdW5w87ShG4nT+E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-IM_VxcVZO1G8AD9YNK54hg-1; Mon, 03 Apr 2023 07:18:18 -0400
X-MC-Unique: IM_VxcVZO1G8AD9YNK54hg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BE111C06EC7;
        Mon,  3 Apr 2023 11:18:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1D8140C20FA;
        Mon,  3 Apr 2023 11:18:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch>
References: <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch> <20230331160914.1608208-1-dhowells@redhat.com> <20230331160914.1608208-16-dhowells@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 15/55] ip, udp: Support MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1822262.1680520695.1@warthog.procyon.org.uk>
Date:   Mon, 03 Apr 2023 12:18:15 +0100
Message-ID: <1822263.1680520695@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> These functions are derived from and replace ip_append_page.
> That can be removed once udp_sendpage is converted?

Yeah, looks like it.

David

