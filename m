Return-Path: <netdev+bounces-3575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A3E707E25
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5342528194D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93B4A646;
	Thu, 18 May 2023 10:32:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E3F125B5
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:32:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5391FE0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684405942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xvdLsUePIbjtTkW6j7lbSgd+yLcI9cd8EilJc/yrXPk=;
	b=eeCcQnc3fPaXS7eLCE0gCp/WAxn6zEjJra939Z5tH8Xqo5XrFuopsqU6ncQNJNyvyH0+yH
	8TcxDesw5RBVzbdPDY8qD2enMks6dIgQ/pZCchAmbSCPjxnW0G3fFTNK6x1ZVdcYUnjU27
	Cykb+cBpbdczKY8s+XN8B/aaUY2McFA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-GprdNpoONKe8cXikBHQH_Q-1; Thu, 18 May 2023 06:32:19 -0400
X-MC-Unique: GprdNpoONKe8cXikBHQH_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A57AD282CCAD;
	Thu, 18 May 2023 10:32:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22EA8C15BA0;
	Thu, 18 May 2023 10:32:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <47caea363e844bf716867c6a128d374cae4a5772.camel@redhat.com>
References: <47caea363e844bf716867c6a128d374cae4a5772.camel@redhat.com> <93aba6cc363e94a6efe433b3c77ec1b6b54f2919.camel@redhat.com> <20230515093345.396978-1-dhowells@redhat.com> <20230515093345.396978-4-dhowells@redhat.com> <1347187.1684403608@warthog.procyon.org.uk>
To: Paolo Abeni <pabeni@redhat.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Al Viro <viro@zeniv.linux.org.uk>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Jeff Layton <jlayton@kernel.org>,
    Christian Brauner <brauner@kernel.org>,
    Chuck Lever III <chuck.lever@oracle.com>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org
Subject: Re: [PATCH net-next v7 03/16] net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1348732.1684405935.1@warthog.procyon.org.uk>
Date: Thu, 18 May 2023 11:32:15 +0100
Message-ID: <1348733.1684405935@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Paolo Abeni <pabeni@redhat.com> wrote:

> Side node: we need the whole series alltogether, you need to repost
> even the unmodified patches.

Any other things to change before I do that?

David


