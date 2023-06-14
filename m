Return-Path: <netdev+bounces-10598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 936DE72F4AA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F21E1C20B17
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2191E1C04;
	Wed, 14 Jun 2023 06:22:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDCB17FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:22:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CE61BE8
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:22:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7C4631FDE3;
	Wed, 14 Jun 2023 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686723740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T918lJ4pe3lcEkph+FxYYA6LurkHM2prd62WZyXU2AU=;
	b=QfD4PjsCgF76xTyyVv37gUpmF4iqdhlGLd4g8mqmj9XHiONe2f7pDWXz2lzr3oE2U8SSoE
	qUO5QJ8u+RMGdpFT+I5ae4ZUNqVtIcRp4XcpT71SFK2He5H8EiE9pY1EUgUFeUtn70rgxJ
	0n7Aqq8v5Wy+KhNca6L9bfyrgPWr1qY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686723740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T918lJ4pe3lcEkph+FxYYA6LurkHM2prd62WZyXU2AU=;
	b=rmzjnlosgAcExS2zTgLABEXuOPJALQh30nAki4XIgYzxwIzn+tVgU/7njg/jZpxiSwxmDj
	N9iipf0vkW+qxqBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id 5E0252C143;
	Wed, 14 Jun 2023 06:22:20 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id 52F9F51C4DDB; Wed, 14 Jun 2023 08:22:20 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] net/tls: handle MSG_EOR for tls_device TX flow
Date: Wed, 14 Jun 2023 08:22:10 +0200
Message-Id: <20230614062212.73288-3-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230614062212.73288-1-hare@suse.de>
References: <20230614062212.73288-1-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tls_push_data() MSG_MORE / MSG_SENDPAGE_NOTLAST, but bails
out on MSG_EOR.
But seeing that MSG_EOR is basically the opposite of
MSG_MORE / MSG_SENDPAGE_NOTLAST this patch adds handling
MSG_EOR by treating it as the absence of MSG_MORE.
Consequently we should return an error when both are set.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 net/tls/tls_device.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b4864d55900f..2103d8b7b316 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -440,11 +440,6 @@ static int tls_push_data(struct sock *sk,
 	int copy, rc = 0;
 	long timeo;
 
-	if (flags &
-	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST |
-	      MSG_SPLICE_PAGES))
-		return -EOPNOTSUPP;
-
 	if (unlikely(sk->sk_err))
 		return -sk->sk_err;
 
@@ -536,6 +531,10 @@ static int tls_push_data(struct sock *sk,
 				more = true;
 				break;
 			}
+			if (flags & MSG_EOR) {
+				more = false;
+				break;
+			}
 
 			done = true;
 		}
@@ -582,6 +581,14 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	if (!tls_ctx->zerocopy_sendfile)
 		msg->msg_flags &= ~MSG_SPLICE_PAGES;
 
+	if (msg->msg_flags &
+	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST |
+	      MSG_SPLICE_PAGES | MSG_EOR))
+		return -EOPNOTSUPP;
+
+	if ((msg->msg_flags & (MSG_MORE | MSG_EOR)) == (MSG_MORE | MSG_EOR))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
 
@@ -627,9 +634,17 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 	struct bio_vec bvec;
 	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 
+	if (flags &
+	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST |
+	      MSG_SPLICE_PAGES | MSG_EOR))
+		return -EOPNOTSUPP;
+
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		msg.msg_flags |= MSG_MORE;
 
+	if ((msg.msg_flags & (MSG_MORE | MSG_EOR)) == (MSG_MORE | MSG_EOR))
+		return -EINVAL;
+
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-- 
2.35.3


