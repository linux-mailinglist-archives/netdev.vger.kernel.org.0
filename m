Return-Path: <netdev+bounces-7449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C82C720576
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17724281A05
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F078219E5E;
	Fri,  2 Jun 2023 15:08:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AA6258F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:08:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771F31B7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685718503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GeaP7/vo94ZZDrAoROnlgLmkpbcL++cZl5U43JLGl7Y=;
	b=KLEEllfSyhwmgqwFB3a+iG9viqWsqQty8grmtA0NwQgxCroYbA29wBNnPpV4elW+31wmV1
	X60orwWgzmovj8QMUl/o1K2647aMkP0lNhQg1WtHuVCpmm4uWwiY1/UMlL2AJwsrdKiTZ3
	JpAJH4l6HTEoz3UwTVMuJ6dJi4zEMg4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-r53cRdYeNt22xXrH4BTZSw-1; Fri, 02 Jun 2023 11:08:17 -0400
X-MC-Unique: r53cRdYeNt22xXrH4BTZSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77FF23C0BE49;
	Fri,  2 Jun 2023 15:08:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D52340CFD46;
	Fri,  2 Jun 2023 15:08:14 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 03/11] tls/sw: Use zero-length sendmsg() without MSG_MORE to flush
Date: Fri,  2 Jun 2023 16:07:44 +0100
Message-ID: <20230602150752.1306532-4-dhowells@redhat.com>
In-Reply-To: <20230602150752.1306532-1-dhowells@redhat.com>
References: <20230602150752.1306532-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow userspace to end a TLS record without supplying any data by calling
send()/sendto()/sendmsg() with no data and no MSG_MORE flag.  This can be
used to flush a previous send/splice that had MSG_MORE or SPLICE_F_MORE set
or a sendfile() that was incomplete.

Without this, a zero-length send to tls-sw is just ignored.  I think
tls-device will do the right thing without modification.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/tls/tls_sw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index cac1adc968e8..6aa6d17888f5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -945,7 +945,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct tls_rec *rec;
 	int required_size;
 	int num_async = 0;
-	bool full_record;
+	bool full_record = false;
 	int record_room;
 	int num_zc = 0;
 	int orig_size;
@@ -971,6 +971,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		}
 	}
 
+	if (!msg_data_left(msg) && eor)
+		goto just_flush;
+
 	while (msg_data_left(msg)) {
 		if (sk->sk_err) {
 			ret = -sk->sk_err;
@@ -1082,6 +1085,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		 */
 		tls_ctx->pending_open_record_frags = true;
 		copied += try_to_copy;
+just_flush:
 		if (full_record || eor) {
 			ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
 						  record_type, &copied,


