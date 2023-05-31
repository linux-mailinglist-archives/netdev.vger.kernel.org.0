Return-Path: <netdev+bounces-6789-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29482718029
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4D252814DB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9241428E;
	Wed, 31 May 2023 12:45:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11114286
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:45:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A1E11F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685537140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VUrQef8DmIGGqxD5N5RNkU1BHyTMou9oFGzjwHHlMuE=;
	b=NfzssNqUk5tmPl+nL4WQR/jcLvil/LWuON6ryGBRTCY+wtL+UK/4QTjyqHjtPexoWXpKQU
	IaCJUYfsh9AXzIPtnEZh65B9jjU2B2TcDMdiCqJItmr+TDomeoP74+YRIn9y219y6ASPH0
	q/Wk1vT0nl38/FGOlCnKGOkOvIuO2ck=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-MLbnjYjsMtCMKcbnjqfptw-1; Wed, 31 May 2023 08:45:38 -0400
X-MC-Unique: MLbnjYjsMtCMKcbnjqfptw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE0311C0150B;
	Wed, 31 May 2023 12:45:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF7F20296C8;
	Wed, 31 May 2023 12:45:34 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
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
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH net-next v2 1/6] splice, net: Fix MSG_MORE signalling in splice_direct_to_actor()
Date: Wed, 31 May 2023 13:45:23 +0100
Message-ID: <20230531124528.699123-2-dhowells@redhat.com>
In-Reply-To: <20230531124528.699123-1-dhowells@redhat.com>
References: <20230531124528.699123-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

splice_direct_to_actor() doesn't manage SPLICE_F_MORE correctly - and, as a
result, incorrectly signals MSG_MORE when splicing to a socket.  The
problem happens when a short splice occurs because we got a short read due
to hitting the EOF on a file.  Because the length read (read_len) is less
than the remaining size to be spliced (len), SPLICE_F_MORE is set.

This causes MSG_MORE to be set by pipe_to_sendpage(), indicating to the
network protocol that more data is to be expected.  With the changes I want
to make to switch from using sendpage to using sendmsg(MSG_SPLICE_PAGES),
MSG_MORE needs to work properly.

This was observed with the multi_chunk_sendfile tests in the tls kselftest
program.  Some of those tests would hang and time out when the last chunk
of file was less than the sendfile request size.

This has been observed before[1] and worked around in AF_TLS[2].

Fix this by checking to see if the source file is seekable if we get a
short read and, if it is, checking to see if we hit the file size.  This
should also work for block devices.

This won't help procfiles and suchlike as they're zero length files that
can be read from[3].  To handle that, should splice make a zero-length call
with SPLICE_F_MORE cleared (assuming it wasn't set by userspace via
splice()) if it gets a zero-length read?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Christoph Hellwig <hch@lst.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>
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

Link: https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/ [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d452d48b9f8b1a7f8152d33ef52cfd7fe1735b0a [2]
Link: https://lore.kernel.org/r/CAHk-=wjDq5_wLWrapzFiJ3ZNn6aGFWeMJpAj5q+4z-Ok8DD9dA@mail.gmail.com/ [3]
---
 fs/splice.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3e06611d19ae..a7cf216c02a7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -982,10 +982,21 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		 * If this is the last data and SPLICE_F_MORE was not set
 		 * initially, clears it.
 		 */
-		if (read_len < len)
-			sd->flags |= SPLICE_F_MORE;
-		else if (!more)
+		if (read_len < len) {
+			struct inode *ii = in->f_mapping->host;
+
+			if (ii->i_fop->llseek != noop_llseek &&
+			    pos >= i_size_read(ii)) {
+				if (!more)
+					sd->flags &= ~SPLICE_F_MORE;
+			} else {
+				sd->flags |= SPLICE_F_MORE;
+			}
+
+		} else if (!more) {
 			sd->flags &= ~SPLICE_F_MORE;
+		}
+
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we


