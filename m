Return-Path: <netdev+bounces-8977-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E875672674B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 505FD1C20898
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F3937357;
	Wed,  7 Jun 2023 17:29:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99671641B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:29:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D01E1993
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686158967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ce1A88jUKFjSY0Tt+7w8QiaS9zhzMSTost2c+cyMfRw=;
	b=fCIhCbIKjTYUYgWjT9n+kLNhg0q2A4kIfJwj8/7PgFg6+5ZC1HotewEjMX0nkMD1n2T33k
	WlkNY+JIY5n2MbSA8aoSFA/OZM7fxDaGY7f3NRjO70IzANrGkf6tfZV8rGROEcCYL0xyEM
	ZmFDWkgLrXMrsZLb+6pRj9fbjX4I0kw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-rIVfiEgZNeSYJi6TjNk2gw-1; Wed, 07 Jun 2023 13:29:20 -0400
X-MC-Unique: rIVfiEgZNeSYJi6TjNk2gw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF81A802E58;
	Wed,  7 Jun 2023 17:29:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B727D477F61;
	Wed,  7 Jun 2023 17:29:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230607101945.65c5df51@kernel.org>
References: <20230607101945.65c5df51@kernel.org> <20230607140559.2263470-1-dhowells@redhat.com> <20230607140559.2263470-12-dhowells@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Linus Torvalds <torvalds@linux-foundation.org>,
    Chuck Lever <chuck.lever@oracle.com>,
    Boris Pismenny <borisp@nvidia.com>,
    John Fastabend <john.fastabend@gmail.com>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 11/14] tls/sw: Support MSG_SPLICE_PAGES
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2291291.1686158954.1@warthog.procyon.org.uk>
Date: Wed, 07 Jun 2023 18:29:14 +0100
Message-ID: <2291292.1686158954@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> wrote:

> > +		if (put)
> > +			put_page(page);
> 
> is put ever set to true?

Ah, the copy-data-if-slab thing got removed.  I'll clean this bit up.

> > -		tls_ctx->pending_open_record_frags = true;
> >  		copied += try_to_copy;
> > +copied:
> > +		tls_ctx->pending_open_record_frags = true;
> 
> Why move pending-open-record-frags setting if it's also set before
> jumping?

I should probably remove it from before the goto - unless you'd prefer to do
it in both places.

David


