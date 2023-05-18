Return-Path: <netdev+bounces-3584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7877707F65
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3122A1C21071
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C31019524;
	Thu, 18 May 2023 11:34:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD5C1951C
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:34:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29156FA
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684409678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tvt4OPfykmXBYH1YwFClcybVueKBqhEtSqnlBvdPPa4=;
	b=JJDHx+p/p4x7ThhHmu3soWxxyizzSkp16LzrhexCF4KPhT4EQWbql73mhYXH2bcCM+swOp
	Yf7X9c8qTTc9mbVj09RGYqhjBhxVB63PUj/CKUPbg76Tfgss44eJRUHvjO+wP6TnVYVtQr
	KERZ+l2lUAyhT9+SSV1htuFIXbWuwpY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-6odubZSPN4yr4v_rYda7YQ-1; Thu, 18 May 2023 07:34:34 -0400
X-MC-Unique: 6odubZSPN4yr4v_rYda7YQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF37E180521E;
	Thu, 18 May 2023 11:34:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08A3C2026D16;
	Thu, 18 May 2023 11:34:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <78a9f2e83af3ab732e9cedd46c1265b7366cd91f.camel@redhat.com>
References: <78a9f2e83af3ab732e9cedd46c1265b7366cd91f.camel@redhat.com> <47caea363e844bf716867c6a128d374cae4a5772.camel@redhat.com> <93aba6cc363e94a6efe433b3c77ec1b6b54f2919.camel@redhat.com> <20230515093345.396978-1-dhowells@redhat.com> <20230515093345.396978-4-dhowells@redhat.com> <1347187.1684403608@warthog.procyon.org.uk> <1348733.1684405935@warthog.procyon.org.uk>
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
Content-ID: <1350691.1684409670.1@warthog.procyon.org.uk>
Date: Thu, 18 May 2023 12:34:30 +0100
Message-ID: <1350692.1684409670@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Paolo Abeni <pabeni@redhat.com> wrote:

> > Any other things to change before I do that?
> 
> I went through the series and don't have other comments.

Thanks!

David


