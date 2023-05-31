Return-Path: <netdev+bounces-6883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4CB7188FC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A8EA1C20F00
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C2B18C0B;
	Wed, 31 May 2023 18:01:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5800171C4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:01:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7578912B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685556080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGjsT8NGr6NLH3bPSVx6y2orm6yJThklHunLB8j4RRA=;
	b=LgG5duyfE2wobiTljFYE1ggbm/qDq949dlFUihVvgyPaYH2X5OG3B6h/0q7ni891ryTpC7
	4GKqqPoU1CXh6eFZAb37O5DkSemGKrpjQx9y0vaKVQw4XEAKXdv/YmkA6w+LiAsXr0prfy
	pnlpOSTELf0fyHKlXoAYHlgTLYBZlUg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-9iETfq-bNr2iMFFzxZdwtg-1; Wed, 31 May 2023 14:01:16 -0400
X-MC-Unique: 9iETfq-bNr2iMFFzxZdwtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37FCC384CC47;
	Wed, 31 May 2023 18:01:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 628BB2166B25;
	Wed, 31 May 2023 18:01:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZHd9vCcBNtjkqeqg@corigine.com>
References: <ZHd9vCcBNtjkqeqg@corigine.com> <20230531124528.699123-1-dhowells@redhat.com> <20230531124528.699123-3-dhowells@redhat.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
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
Subject: Re: [PATCH net-next v2 2/6] net: Block MSG_SENDPAGE_* from being passed to sendmsg() by userspace
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <724854.1685556072.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 31 May 2023 19:01:12 +0100
Message-ID: <724855.1685556072@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Simon Horman <simon.horman@corigine.com> wrote:

> > sendpage is removed as a whole slew of pages will be passed in in one =
go by
> =

> on the off-chance that you need to respin for some other reason:
> =

> 	s/in in/in/

What I wrote is correct - there should be two ins.  I could write it as:

	... passed in [as an argument] in one go...

For your amusement, consider:

	All the faith he had had had had no effect on the outcome of his life.

	https://ell.stackexchange.com/questions/285066/explanation-for-had-had-ha=
d-had-being-grammatically-correct

David


