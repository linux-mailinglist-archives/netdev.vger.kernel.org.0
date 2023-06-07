Return-Path: <netdev+bounces-8906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEEA7263DA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 222901C20E3D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D041ACD2;
	Wed,  7 Jun 2023 15:12:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C801D1ACBB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:12:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF71BE5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686150751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K3r/K8HkhE4xuB+jM5Kf0f4GFwH3PwislIM7Zb9RO88=;
	b=BSUv9phKv+HaNbts1G8phbE0gay1U6CVVibR5GI+Zt24EUeFyhK1XQ1TbI6CPao+pCQXMD
	Xa/YVL8nCJb77bdV4tv0jxqjmI2u7lBCi1yIzGssf5dKgS9gruTd2tHINnKlKK9bEiEE2s
	g0pvwwkz20vxzNp1NiAMuK4WF/3O0CA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-v6-IUeUzMTyM9FIOsecLMw-1; Wed, 07 Jun 2023 11:12:28 -0400
X-MC-Unique: v6-IUeUzMTyM9FIOsecLMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93FE0848B6F;
	Wed,  7 Jun 2023 15:03:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C69F82166B25;
	Wed,  7 Jun 2023 15:03:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4c49176f-147a-4283-f1b1-32aac7b4b996@gmail.com>
References: <4c49176f-147a-4283-f1b1-32aac7b4b996@gmail.com> <20230522121125.2595254-1-dhowells@redhat.com> <20230522121125.2595254-9-dhowells@redhat.com>
To: Tariq Toukan <ttoukan.linux@gmail.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>,
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
    linux-mm@kvack.org, Boris Pismenny <borisp@nvidia.com>,
    John Fastabend <john.fastabend@gmail.com>,
    Gal Pressman <gal@nvidia.com>, ranro@nvidia.com, samiram@nvidia.com,
    drort@nvidia.com, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next v10 08/16] tls: Inline do_tcp_sendpages()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2267271.1686150217.1@warthog.procyon.org.uk>
Date: Wed, 07 Jun 2023 16:03:37 +0100
Message-ID: <2267272.1686150217@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tariq Toukan <ttoukan.linux@gmail.com> wrote:

> My team spotted a new degradation in TLS TX device offload, bisected to this
> patch.

I presume you're using some hardware (I'm guessing Mellanox?) that can
actually do TLS offload?  Unfortunately, I don't have any hardware that can do
this, so I can't test the tls_device stuff.

> From a quick look at the patch, it's not clear to me what's going wrong.
> Please let us know of any helpful information that we can provide to help in
> the debug.

Can you find out what source line this corresponds to?

	RIP: 0010:skb_splice_from_iter+0x102/0x300

Assuming you're building your own kernel, something like the following might
do the trick:

	echo "RIP: 0010:skb_splice_from_iter+0x102/0x300" |
	./scripts/decode_stacktrace.sh /my/built/vmlinux /my/build/tree

if you run it in the kernel source tree you're using and substitute the
paths to vmlinux and the build tree for modules.

David


