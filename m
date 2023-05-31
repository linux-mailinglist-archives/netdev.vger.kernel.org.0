Return-Path: <netdev+bounces-6790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E8871802A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 444D71C20E4C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A0612B71;
	Wed, 31 May 2023 12:45:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D481F14286
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:45:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ADE11F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685537144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=704Gul1es5vKB8f3fNlqLP0xfed1dEhsuWb+SLm3klg=;
	b=WEbs/vgqtdc7UsAEh8O4M0ghNHBj1PiB9QnqdNiMATXe6KuZ8WDckAVxnrIYpEeGtRZpVz
	Dgg/KbMZeVf2+T/0e7BHrIPzac6BBLQbKaYG70TI6YRnEFVgKwlbEQiY+ZZqfCwLCr/t0y
	9hwdKHHc0uU/gAIZpQIyaU3KoQxhhLU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-u-3ocbAEPfKvWCDqcrmGEg-1; Wed, 31 May 2023 08:45:41 -0400
X-MC-Unique: u-3ocbAEPfKvWCDqcrmGEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A721F3C0C897;
	Wed, 31 May 2023 12:45:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B74EE112132E;
	Wed, 31 May 2023 12:45:38 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/6] net: Block MSG_SENDPAGE_* from being passed to sendmsg() by userspace
Date: Wed, 31 May 2023 13:45:24 +0100
Message-ID: <20230531124528.699123-3-dhowells@redhat.com>
In-Reply-To: <20230531124528.699123-1-dhowells@redhat.com>
References: <20230531124528.699123-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It is necessary to allow MSG_SENDPAGE_* to be passed into ->sendmsg() to
allow sendmsg(MSG_SPLICE_PAGES) to replace ->sendpage().  Unblocking them
in the network protocol, however, allows these flags to be passed in by
userspace too[1].

Fix this by marking MSG_SENDPAGE_NOPOLICY, MSG_SENDPAGE_NOTLAST and
MSG_SENDPAGE_DECRYPTED as internal flags, which causes sendmsg() to object
if they are passed to sendmsg() by userspace.  Network protocol ->sendmsg()
implementations can then allow them through.

Note that it should be possible to remove MSG_SENDPAGE_NOTLAST once
sendpage is removed as a whole slew of pages will be passed in in one go by
splice through sendmsg, with MSG_MORE being set if it has more data waiting
in the pipe.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/20230526181338.03a99016@kernel.org/ [1]
---
 include/linux/socket.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index bd1cc3238851..3fd3436bc09f 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -339,7 +339,9 @@ struct ucred {
 #endif
 
 /* Flags to be cleared on entry by sendmsg and sendmmsg syscalls */
-#define MSG_INTERNAL_SENDMSG_FLAGS (MSG_SPLICE_PAGES)
+#define MSG_INTERNAL_SENDMSG_FLAGS \
+	(MSG_SPLICE_PAGES | MSG_SENDPAGE_NOPOLICY | MSG_SENDPAGE_NOTLAST | \
+	 MSG_SENDPAGE_DECRYPTED)
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
 #define SOL_IP		0


