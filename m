Return-Path: <netdev+bounces-5701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EA47127E6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06E531C2109F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8D81EA91;
	Fri, 26 May 2023 13:59:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524B41EA7F
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:59:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D38DF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685109569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZR+i/KA4SM5MJbNxGgeo60QfZYJs7gffgNmM3EOr+0=;
	b=Bq9sJ2AS63Bpq0+cAGexhWtnmp0k6DR1JhQKaQi7uOWxiJzrPyPggNFebNEBAxFuhQVkSm
	xyfTF1MVoIZhhQyF1EzrCC1XdowYnFRZhPF8KmING+UVCjCXEubxNOrxq/ycBPs9O5vztm
	H+qkZIpPPrha55E7wmtqOsqvFKtiIdU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-NAJcYUu3MISI0BN9tbIX4w-1; Fri, 26 May 2023 09:59:26 -0400
X-MC-Unique: NAJcYUu3MISI0BN9tbIX4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B145985A5A8;
	Fri, 26 May 2023 13:59:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29A307C2A;
	Fri, 26 May 2023 13:59:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
References: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>,
    Alexander Duyck <alexanderduyck@fb.com>,
    Jesper Dangaard Brouer <brouer@redhat.com>,
    Pavel Begunkov <asml.silence@gmail.com>,
    Kees Cook <keescook@chromium.org>, Jiri Benc <jbenc@redhat.com>,
    netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: fix signedness bug in skb_splice_from_iter()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <881536.1685109556.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 May 2023 14:59:16 +0100
Message-ID: <881537.1685109556@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dan Carpenter <dan.carpenter@linaro.org> wrote:

> The "len" variable needs to be signed for the error handling to work
> correctly.
> =

> Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff=
 for MSG_SPLICE_PAGES")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: David Howells <dhowells@redhat.com>


