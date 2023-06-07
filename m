Return-Path: <netdev+bounces-8891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 136CD726317
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702521C208D3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1965C1ACA1;
	Wed,  7 Jun 2023 14:42:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FF414291
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:42:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DA11BC3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686148923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VfP0KSvbwDpdDK3r99Lo/bGf0PzU9/ETfdNk/1wpqNM=;
	b=M/t9JxpGG1lbOnwlNGraRSDI9k3eoqUMm34VSpojC1SuXDkyN1Q6V7yXoxUuV2scLYcIb5
	KVaangsk4sJou22PCdyWtVM+WeIKAxTmW9KtQvq7DDjttR44yCnUcfjAgi49Jzc9eFwvxu
	3AN1CdREjEuFg0MA6MSIAvMdFvKTfXA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-yTkbrzWfOVqVewkXPojfRg-1; Wed, 07 Jun 2023 10:06:48 -0400
X-MC-Unique: yTkbrzWfOVqVewkXPojfRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C33823806705;
	Wed,  7 Jun 2023 14:06:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F23512026D6A;
	Wed,  7 Jun 2023 14:06:43 +0000 (UTC)
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
Subject: [PATCH net-next v5 10/14] splice, net: Fix SPLICE_F_MORE signalling in splice_direct_to_actor()
Date: Wed,  7 Jun 2023 15:05:55 +0100
Message-ID: <20230607140559.2263470-11-dhowells@redhat.com>
In-Reply-To: <20230607140559.2263470-1-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
MSG_MORE set.

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
when we've read sufficient data to fulfill the request.

If, however, we get a premature EOF from ->splice_read(), have sent at
least one byte and SPLICE_F_MORE was not set by the caller, ->splice_eof()
will be invoked.

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

Notes:
    ver #4)
     - Use ->splice_eof() to signal a premature EOF to the splice output.

 fs/splice.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 67dbd85db207..67ddaac1f5c5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1063,13 +1063,17 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
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
 
@@ -1085,14 +1089,12 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
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


