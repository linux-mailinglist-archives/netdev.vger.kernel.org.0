Return-Path: <netdev+bounces-7451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F35E720584
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8498A281253
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E5C1B8F6;
	Fri,  2 Jun 2023 15:08:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6652119E63
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:08:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C214CE4A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685718509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyBtAHnxIDOUxFx8QcCqc48iyvS91zdxptS6bgS5LhE=;
	b=Kwvr6nEJPCjtsqpQeS5DkJPp4skcMBfsM/eEaY66xVcEBuUvWEFlEnigdnjbEL9T9Fyd48
	fl0Q1GLtics6RaaYtjVPFa2IN43Jh0npXlLE3kDeZUl3VNIo9KvdWrqvBVEcRKzUzqkY16
	cztjpvx+9dgyMEGN8N0rmwlRkp3Q2n0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-HJKW5r7wNUG_h4BsM00Cfg-1; Fri, 02 Jun 2023 11:08:26 -0400
X-MC-Unique: HJKW5r7wNUG_h4BsM00Cfg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42DA4811E8F;
	Fri,  2 Jun 2023 15:08:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30388492B00;
	Fri,  2 Jun 2023 15:08:22 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH net-next v3 05/11] splice, net: Fix SPLICE_F_MORE signalling in splice_direct_to_actor()
Date: Fri,  2 Jun 2023 16:07:46 +0100
Message-ID: <20230602150752.1306532-6-dhowells@redhat.com>
In-Reply-To: <20230602150752.1306532-1-dhowells@redhat.com>
References: <20230602150752.1306532-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

splice_direct_to_actor() doesn't manage SPLICE_F_MORE correctly[1] - and,
as a result, it incorrectly signals/fails to signal MSG_MORE when splicing
to a socket.  The problem I'm seeing happens when a short splice occurs
because we got a short read due to hitting the EOF on a file: as the length
read (read_len) is less than the remaining size to be spliced (len),
SPLICE_F_MORE (and thus MSG_MORE) is set.

The issue is that, for the moment, we have no way to know *why* the short
read occurred and so can't make a good decision on whether we *should* keep
MSG_MORE set.  Further, the argument can be made that it should be left to
userspace to decide how to handle it - userspace could perform some sort of
cancellation for example.

MSG_SENDPAGE_NOTLAST was added to work around this, but that is also set
incorrectly under some circumstances - for example if a short read fills a
single pipe_buffer, but the next read would return more (seqfile can do
this).

This was observed with the multi_chunk_sendfile tests in the tls kselftest
program.  Some of those tests would hang and time out when the last chunk
of file was less than the sendfile request size:

	build/kselftest/net/tls -r tls.12_aes_gcm.multi_chunk_sendfile

This has been observed before[2] and worked around in AF_TLS[3].

Fix this by making splice_direct_to_actor() always signal SPLICE_F_MORE if
we haven't yet hit the requested operation size.  SPLICE_F_MORE remains
signalled if the user passed it in to splice() but otherwise gets cleared
when we've read sufficient data to fulfill the request.  The cleanup of a
short splice to userspace is left to userspace.

[!] Note that this changes user-visible behaviour.  It will cause the
    multi_chunk_sendfile tests in the TLS kselftest to fail.  This failure
    in the testsuite will be addressed in a subsequent patch by making
    userspace do a zero-length send().

It appears that SPLICE_F_MORE is only used by splice-to-socket.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Matthew Wilcox <willy@infradead.org>
cc: Jan Kara <jack@suse.cz>
cc: Jeff Layton <jlayton@kernel.org>
cc: David Hildenbrand <david@redhat.com>
cc: Christian Brauner <brauner@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-fsdevel@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-mm@kvack.org
cc: netdev@vger.kernel.org

Link: https://lore.kernel.org/r/499791.1685485603@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/r/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/ [2]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d452d48b9f8b1a7f8152d33ef52cfd7fe1735b0a [3]
---
 fs/splice.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9b1d43c0c562..c71bd8e03469 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1052,13 +1052,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 	 */
 	bytes = 0;
 	len = sd->total_len;
+
+	/* Don't block on output, we have to drain the direct pipe. */
 	flags = sd->flags;
+	sd->flags &= ~SPLICE_F_NONBLOCK;
 
 	/*
-	 * Don't block on output, we have to drain the direct pipe.
+	 * We signal MORE until we've read sufficient data to fulfill the
+	 * request and we keep signalling it if the caller set it.
 	 */
-	sd->flags &= ~SPLICE_F_NONBLOCK;
 	more = sd->flags & SPLICE_F_MORE;
+	sd->flags |= SPLICE_F_MORE;
 
 	WARN_ON_ONCE(!pipe_empty(pipe->head, pipe->tail));
 
@@ -1074,14 +1078,12 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		sd->total_len = read_len;
 
 		/*
-		 * If more data is pending, set SPLICE_F_MORE
-		 * If this is the last data and SPLICE_F_MORE was not set
-		 * initially, clears it.
+		 * If we now have sufficient data to fulfill the request then
+		 * we clear SPLICE_F_MORE if it was not set initially.
 		 */
-		if (read_len < len)
-			sd->flags |= SPLICE_F_MORE;
-		else if (!more)
+		if (read_len >= len && !more)
 			sd->flags &= ~SPLICE_F_MORE;
+
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we


