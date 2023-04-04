Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEDB6D6A42
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbjDDRRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235922AbjDDRRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:17:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A021FC8
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680628620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9/qlLB/Y+0maKwWIY7hsMZMlokqBZ5/HAXA6LW4lTOs=;
        b=Pjq99K9XW1XZC5MdcTf0K9ga/O1OmzKVlF51RTy22G6iQwZz5FJH1wfgo7I6F851TuvQoD
        lUpH8+gKOmufIZblgj2HCRFnPycQLMNV5TC/1cE11GDo6Oo9WWJsiiy3nB1Kwe2apzffOL
        Szd9ch0eeCMR45Mc4+wOaWOI36P+DD8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-G6S7IDCqOw2DtHaojdd83w-1; Tue, 04 Apr 2023 13:16:57 -0400
X-MC-Unique: G6S7IDCqOw2DtHaojdd83w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BA5B857FB7;
        Tue,  4 Apr 2023 17:16:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56604C33187;
        Tue,  4 Apr 2023 17:16:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <642c5731a7cc5_337e2c208b0@willemb.c.googlers.com.notmuch>
References: <642c5731a7cc5_337e2c208b0@willemb.c.googlers.com.notmuch> <642ad8b66acfe_302ae1208e7@willemb.c.googlers.com.notmuch> <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch> <20230331160914.1608208-1-dhowells@redhat.com> <20230331160914.1608208-16-dhowells@redhat.com> <1818504.1680515446@warthog.procyon.org.uk> <2258798.1680559496@warthog.procyon.org.uk>
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
Content-ID: <2688905.1680628610.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 04 Apr 2023 18:16:50 +0100
Message-ID: <2688906.1680628610@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

> > Okay.  How about the attached?  This seems to work.  Just setting "pag=
ed" to
> > true seems to do the right thing in __ip_append_data() when allocating=
 /
> > setting up the skbuff, and then __ip_splice_pages() is called to add t=
he
> > pages.
> =

> If this works, much preferred. Looks great to me.

:-)

> As said, then __ip_splice_pages() probably no longer needs the
> preamble to copy initial header bytes.

Sorry, what?  It only attaches pages extracted from the iterator.

David

