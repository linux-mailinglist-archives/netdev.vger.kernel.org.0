Return-Path: <netdev+bounces-11396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D93732EF4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D996F1C20AF1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F61ABE57;
	Fri, 16 Jun 2023 10:39:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E3FBA23
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:39:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B8B22BA9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686911887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eIOLShY/ZmsNAmLuX2YSma08DfvRfpLXlZqs26cgyEs=;
	b=A4Fn9yT+9e8UJ8qSvS/GDruCooarNm+aCA2ypxUDqMZtOaff9Vl5ihj1GoG18yH91zV8T0
	Ey5nqaPeE+jQ/JGH46dBr0/0F9yLAIuompVKP888ECXA1NEwQe5F9RCNPjZ7pZN8Fuw/D0
	CwlmXt8tNsWnehX1Sbv6Q0W+v6/CmME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-CGjzTS8uMVWdy5Eg3ByHXw-1; Fri, 16 Jun 2023 06:38:01 -0400
X-MC-Unique: CGjzTS8uMVWdy5Eg3ByHXw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D5978028B2;
	Fri, 16 Jun 2023 10:38:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5E20492C38;
	Fri, 16 Jun 2023 10:37:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZIw4+Go7ZIth+CsY@gondor.apana.org.au>
References: <ZIw4+Go7ZIth+CsY@gondor.apana.org.au> <1679829.1686785273@warthog.procyon.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com,
    syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com,
    syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com,
    syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
    Matthew Wilcox <willy@infradead.org>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <426352.1686911878.1@warthog.procyon.org.uk>
Date: Fri, 16 Jun 2023 11:37:58 +0100
Message-ID: <426353.1686911878@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Can you have a look at:

	https://lore.kernel.org/r/415439.1686877276@warthog.procyon.org.uk/

I'm proposing that as an alternative to this patch.

David


