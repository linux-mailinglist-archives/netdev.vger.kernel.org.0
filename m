Return-Path: <netdev+bounces-8970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A541E7266D2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 689DC281497
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5653E3732E;
	Wed,  7 Jun 2023 17:10:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3591137323
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:10:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEE31FC8
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686157816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E/4eS/lJzQiNy8tMpqwPuOfCnp2B44jW2PUSyg6nSfU=;
	b=CFj5ytPbPqocekeBESyX/EaPwNRjHGUuOfPO7hHaW4D2XDshGhxujateHBJhYU47nKFQQT
	k9KpGQzwjywNfHDtz59oGJxwVZbZte6d+zmBessfH2LqfSkyfYSXPzZwElkMNMkJVawEEd
	BXB70/tOzc45O+SuT7Juo9gM91b/pEw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-iNfVzKGiMs6NtphSbkk2cg-1; Wed, 07 Jun 2023 13:10:12 -0400
X-MC-Unique: iNfVzKGiMs6NtphSbkk2cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B6FF811E7F;
	Wed,  7 Jun 2023 17:10:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 398402166B26;
	Wed,  7 Jun 2023 17:10:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230607160528.20078-1-kuniyu@amazon.com>
References: <20230607160528.20078-1-kuniyu@amazon.com> <20230607140559.2263470-10-dhowells@redhat.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: dhowells@redhat.com, axboe@kernel.dk, borisp@nvidia.com,
    chuck.lever@oracle.com, cong.wang@bytedance.com, davem@davemloft.net,
    dsahern@kernel.org, edumazet@google.com, john.fastabend@gmail.com,
    kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
    netdev@vger.kernel.org, pabeni@redhat.com, tom@herbertland.com,
    tom@quantonium.net, torvalds@linux-foundation.org,
    willemdebruijn.kernel@gmail.com, willy@infradead.org
Subject: Re: [PATCH net-next v5 09/14] kcm: Use splice_eof() to flush
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2288535.1686157805.1@warthog.procyon.org.uk>
Date: Wed, 07 Jun 2023 18:10:05 +0100
Message-ID: <2288536.1686157805@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kuniyuki Iwashima <kuniyu@amazon.com> wrote:

> > +	if (skb_queue_empty(&sk->sk_write_queue))
> 
> nit: would be better to use skb_queue_empty_lockless().

Ok.

David


