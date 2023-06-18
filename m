Return-Path: <netdev+bounces-11785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62381734735
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:29:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D632810A4
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56BE63D4;
	Sun, 18 Jun 2023 17:29:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B7A1FC4
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 17:29:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1188D10FF
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687109328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccXraZTQ7XryyK5LpNAR74GJ0dtmJGkdhwIEf8RJTcI=;
	b=Z0GbKvUTg9HYKhexFu9ohLnAnLShQ0tXKmctMwfWEFXH94TpdkhHSjDKr4HZYIuw+A0pBt
	rQyIZ3zKhwsfFTI3a9RPUbLkF1j3VU3UoVP/wqm78KDWY4WeYe3B0Hd96yg3D+yjOosHV9
	YpubQaZN5vzqy9f1d5s87ug7LqJNC8c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-QbA_4gTuPJSb27gVyaPZjw-1; Sun, 18 Jun 2023 13:28:44 -0400
X-MC-Unique: QbA_4gTuPJSb27gVyaPZjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D77563804A4C;
	Sun, 18 Jun 2023 17:28:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB45F40C20F5;
	Sun, 18 Jun 2023 17:28:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <648f353c55ce8_33cfbc29413@willemb.c.googlers.com.notmuch>
References: <648f353c55ce8_33cfbc29413@willemb.c.googlers.com.notmuch> <20230617121146.716077-1-dhowells@redhat.com> <20230617121146.716077-11-dhowells@redhat.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Alexander Duyck <alexander.duyck@gmail.com>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org,
    Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
    Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org
Subject: Re: [PATCH net-next v2 10/17] nvme: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <754954.1687109273.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
From: David Howells <dhowells@redhat.com>
Date: Sun, 18 Jun 2023 18:28:41 +0100
Message-ID: <755077.1687109321@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

>     struct bio_vec bvec;
>     struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES | ... };
> =

>     ..
> =

>     bvec_set_virt
>     iov_iter_bvec
>     sock_sendmsg
> =

> is a frequent pattern. Does it make sense to define a wrapper? Same for =
bvec_set_page.

I dunno.  I'm trying to move towards aggregating multiple pages in a bvec
before calling sendmsg if possible rather than doing it one page at a time=
,
but it's easier and more obvious in some places than others.

David


