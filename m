Return-Path: <netdev+bounces-4041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75CFD70A388
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 968F8281C12
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CE7365;
	Sat, 20 May 2023 00:01:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C33363
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 00:01:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0F51701
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684540898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRzUovfXnw170GzVg3YWYDNx7Fcy6r2PjCbmCvJAFKQ=;
	b=aC+/Iko3Vq5u3rkqbApPKHsujONg5Tb7nnB0hK/XYGg1qGdZRU4HUnQ8b2hya3JC0hy32p
	7WCBv0uwI0KMw1isivgybf3e8uyxBEWRPexPI4blmGKG0/L2WORwPW2qLV2Wb7dfAUFPt/
	fgacPR7UC0HVeBjl+GY/Lz2ol0QmNCk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-1JhP-Y78PWKPthfxNC2xdQ-1; Fri, 19 May 2023 20:01:35 -0400
X-MC-Unique: 1JhP-Y78PWKPthfxNC2xdQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4596E1C041B8;
	Sat, 20 May 2023 00:01:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B4E3740CFD48;
	Sat, 20 May 2023 00:01:31 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Hillf Danton <hdanton@sina.com>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	netdev@vger.kernel.org
Subject: [PATCH v21 13/30] net: Make sock_splice_read() use copy_splice_read() by default
Date: Sat, 20 May 2023 01:00:32 +0100
Message-Id: <20230520000049.2226926-14-dhowells@redhat.com>
In-Reply-To: <20230520000049.2226926-1-dhowells@redhat.com>
References: <20230520000049.2226926-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make sock_splice_read() use copy_splice_read() by default as
file_splice_read() will return immediately with 0 as a socket has no
pagecache and is a zero-size file.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Jens Axboe <axboe@kernel.dk>
cc: netdev@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-mm@kvack.org
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index b7e01d0fe082..401778380195 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1093,7 +1093,7 @@ static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 	struct socket *sock = file->private_data;
 
 	if (unlikely(!sock->ops->splice_read))
-		return generic_file_splice_read(file, ppos, pipe, len, flags);
+		return copy_splice_read(file, ppos, pipe, len, flags);
 
 	return sock->ops->splice_read(sock, ppos, pipe, len, flags);
 }


