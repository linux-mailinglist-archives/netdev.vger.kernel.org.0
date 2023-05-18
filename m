Return-Path: <netdev+bounces-3644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB70708256
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39580281974
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521AE23C85;
	Thu, 18 May 2023 13:11:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463F123C67
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:11:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D4F1FFE
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684415405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GTuF8vICULjztdbI9Ra7D/w4MHEw9VemXTv0OLuiYcE=;
	b=D5ZLJcVs4wW3XFXLmTv5asQdVcOD/KxD0xN0Jlc2uIxFRlDV2D1XPeByW9FE9wsurGrZ2e
	HIsucvTpaA6FLfkknNBxjE7h7xBsYbI4L0NNQmSpw0b6mvYm/wMNbr8Wy/ACqgRDbcY005
	c4Q8q2Lu6pz4qKQfo0IaUxRJDycDbaM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-OaJ1R-89MS2CWKeq3ZymZA-1; Thu, 18 May 2023 09:09:59 -0400
X-MC-Unique: OaJ1R-89MS2CWKeq3ZymZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AE9480101C;
	Thu, 18 May 2023 13:09:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 041062166B32;
	Thu, 18 May 2023 13:09:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230518113453.1350757-1-dhowells@redhat.com>
References: <20230518113453.1350757-1-dhowells@redhat.com>
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
    linux-mm@kvack.org
Subject: Re: [PATCH net-next v8 00/16] splice, net: Replace sendpage with sendmsg(MSG_SPLICE_PAGES), part 1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1521560.1684415394.1@warthog.procyon.org.uk>
Date: Thu, 18 May 2023 14:09:54 +0100
Message-ID: <1521561.1684415394@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There was a conflict with upstream net-next, so I've posted a new version that
fixes that.

David


