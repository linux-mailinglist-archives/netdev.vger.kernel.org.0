Return-Path: <netdev+bounces-8087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB37722A8D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 554B81C20AA4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4111F93D;
	Mon,  5 Jun 2023 15:12:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100C46FDE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:12:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8EAF7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685977918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7+4neYa+KPrHcno9XIjF3OujcOMhzN8ihQFE0Ns9n7U=;
	b=IRMr+MXinZ04W0LPKbqvOdfYzGia9wpYmQ1nKMoJElO7n+l/lqq1VW+imJOICvzsMjFkuw
	HyIDFEXFxOa2SUvjq23EChzybhoV90huJyNvwmCBG9I7Y5rLj/PPYzOPWXtZyz+BIPiqQI
	FetepdbbOvEFJl+gXWiK3Kw+Iww5ATM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-7F3PerAVOMir1dYQzXhJMg-1; Mon, 05 Jun 2023 11:11:55 -0400
X-MC-Unique: 7F3PerAVOMir1dYQzXhJMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F28091034AAA;
	Mon,  5 Jun 2023 15:10:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D0FDC2166B25;
	Mon,  5 Jun 2023 15:10:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZH32Jp1Iop8FaDtC@corigine.com>
References: <ZH32Jp1Iop8FaDtC@corigine.com> <20230605124600.1722160-1-dhowells@redhat.com> <20230605124600.1722160-4-dhowells@redhat.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Linus Torvalds <torvalds@linux-foundation.org>,
    Chuck Lever <chuck.lever@oracle.com>,
    Boris Pismenny <borisp@nvidia.com>,
    John Fastabend <john.fastabend@gmail.com>,
    Jakub Kicinski <kuba@kernel.org>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 03/11] splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1729073.1685977857.1@warthog.procyon.org.uk>
Date: Mon, 05 Jun 2023 16:10:57 +0100
Message-ID: <1729074.1685977857@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Simon Horman <simon.horman@corigine.com> wrote:

> I'm assuming the answer is that this cannot occur,
> but I thought I should mention this anyway.
> 
> If the initial value of len is 0 (or less).
> ...
> > +	return spliced ?: ret;
> 
> Then ret will be used uninitialised here.

len shouldn't be <0 as it's size_t.

I don't think it should be possible to get there with len==0 - at least from
userspace.  sys_splice() returns immediately and sys_sendfile() either splices
to a pipe or goes via splice_direct_to_actor() will just drop straight out.
But there are kernel users - nfsd for example - but I don't know if they would
splice directly to a socket.

That said, it's probably worth preclearing ret just to be sure.

David


