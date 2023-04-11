Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9F6DE31F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjDKRuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:50:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B800640D5
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681235386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ef8XnWFgsT04MkS5RM8aidy/rRVFyqx0755dVLzx4LY=;
        b=aVOVGXmXNgseCI1GSl5XaKh9nU8uvyEX0Q7iica231xHRuHLduppEKoH+dMCAfhCgy8L+x
        ayPl7BcOAe6c1lcCmVS5zWuBRQpPsgHYsyrJRjKDS9ByRdzBL0AWZv49r4AspBL3Ult/I8
        sUTP6a7RFU5JJ2plbXliQUEH6K3IqHY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-C_cXOpSdMASPjUK6X9l8Jw-1; Tue, 11 Apr 2023 13:49:44 -0400
X-MC-Unique: C_cXOpSdMASPjUK6X9l8Jw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 668D985A588;
        Tue, 11 Apr 2023 17:49:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57602728FB;
        Tue, 11 Apr 2023 17:49:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CANn89iLW3_1SZV4EV3h2W45B_+b+R67fp40t8OaqpqLnVEhTew@mail.gmail.com>
References: <CANn89iLW3_1SZV4EV3h2W45B_+b+R67fp40t8OaqpqLnVEhTew@mail.gmail.com> <20230411160902.4134381-1-dhowells@redhat.com> <20230411160902.4134381-8-dhowells@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH net-next v6 07/18] tcp: Support MSG_SPLICE_PAGES
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4138302.1681235380.1@warthog.procyon.org.uk>
Date:   Tue, 11 Apr 2023 18:49:40 +0100
Message-ID: <4138303.1681235380@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

> > -                       zc = sk->sk_route_caps & NETIF_F_SG;
> > +                       if (sk->sk_route_caps & NETIF_F_SG)
> > +                               zc = 1;
> 
> zc is set to 0, 1, MSG_ZEROCOPY ,   MSG_SPLICE_PAGES
> 
> I find this a bit confusing. Maybe use a private enum ?

Meh.  That should be "zc = MSG_ZEROCOPY;".  Will fix.

David

