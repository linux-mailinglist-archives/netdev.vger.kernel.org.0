Return-Path: <netdev+bounces-5691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD79E71275C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9204F281850
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C44818B15;
	Fri, 26 May 2023 13:18:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FF518B13
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:18:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A596F12C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685107080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zUxuiTkmrqzvmRW/UGh5uDZ4UTdPNuTS5RrZxEmFp2s=;
	b=bAiRw4w0d8lMrFLD8jzfLx8Giivsq6iKky+GSJaOSC3oniadpOg9C9fEiALsSNEzfmPjhy
	+oDZ0mlHQ6PoicX/x+jkpOZhjA60zUDsDHGkyk++TUDKHZKok78QrIHb8HeGhQfqp1pMEJ
	+dW4TTJzxCCdfJvLl1l/Xr4hV/mCFTI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-eLmHSUJhNXqBsqVeWvlDKg-1; Fri, 26 May 2023 09:17:56 -0400
X-MC-Unique: eLmHSUJhNXqBsqVeWvlDKg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7682F29A9D50;
	Fri, 26 May 2023 13:17:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B0AEA492B0B;
	Fri, 26 May 2023 13:17:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <99284df8-9190-4deb-ad7c-c0557614a1c8@kili.mountain>
References: <99284df8-9190-4deb-ad7c-c0557614a1c8@kili.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>,
    Alexander Duyck <alexanderduyck@fb.com>,
    Jesper Dangaard Brouer <brouer@redhat.com>,
    Pavel Begunkov <asml.silence@gmail.com>,
    Kees Cook <keescook@chromium.org>, Jiri Benc <jbenc@redhat.com>,
    netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: fix signedness bug in skb_splice_from_iter()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <760141.1685107058.1@warthog.procyon.org.uk>
Date: Fri, 26 May 2023 14:17:38 +0100
Message-ID: <760142.1685107058@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dan Carpenter <dan.carpenter@linaro.org> wrote:

>  	while (iter->count > 0) {
>  		ssize_t space, nr;
> -		size_t off, len;
> +		ssize_t len;
> +		size_t off;

Good point, but why not just move len onto the preceding line?

 	while (iter->count > 0) {
-		ssize_t space, nr;
-		size_t off, len;
+		ssize_t space, nr, len;
+		size_t off;

David


