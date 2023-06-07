Return-Path: <netdev+bounces-8979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F385726768
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 840281C20BC7
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D4537B6D;
	Wed,  7 Jun 2023 17:32:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759EF3735D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:32:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF4A2110
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686159118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xc3kt7fbXK4RZZ9hervM2RINSzi1H8nscf+Y8dFfX2M=;
	b=NUy/+MOmuIqmZNSaZdmHTRmUXWaUcTKDRDBbso9GPSirl8WjLiRmKQSxSeWWyB7iPPt7ux
	YPtaoYFBtvyYb/vIxK7RlqUfBX+TaVW2Hja4b22KYV+xGEFh/z6zHdyRfldeocFJ0dubTd
	OwM70rpH2QlHIyYxSPcastx7Vba1+n0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-6fb_cFy7NMyCZG_m0dqakA-1; Wed, 07 Jun 2023 13:31:54 -0400
X-MC-Unique: 6fb_cFy7NMyCZG_m0dqakA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24F610328C9;
	Wed,  7 Jun 2023 17:31:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF14A2166B25;
	Wed,  7 Jun 2023 17:31:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2291292.1686158954@warthog.procyon.org.uk>
References: <2291292.1686158954@warthog.procyon.org.uk> <20230607101945.65c5df51@kernel.org> <20230607140559.2263470-1-dhowells@redhat.com> <20230607140559.2263470-12-dhowells@redhat.com>
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
Content-ID: <2293094.1686159070.1@warthog.procyon.org.uk>
Date: Wed, 07 Jun 2023 18:31:10 +0100
Message-ID: <2293095.1686159070@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

David Howells <dhowells@redhat.com> wrote:

> > > -		tls_ctx->pending_open_record_frags = true;
> > >  		copied += try_to_copy;
> > > +copied:
> > > +		tls_ctx->pending_open_record_frags = true;
> > 
> > Why move pending-open-record-frags setting if it's also set before
> > jumping?
> 
> I should probably remove it from before the goto - unless you'd prefer to do
> it in both places.

Actually, I need to keep the one before the goto.

David


