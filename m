Return-Path: <netdev+bounces-5721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 509FF71287E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A6A4281923
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AA227701;
	Fri, 26 May 2023 14:33:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C70271E1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:33:01 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025D91703
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:32:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id DAD0521B18;
	Fri, 26 May 2023 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1685111519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMxERdXx7wwqcXUcsFITgZvHQBWYGRWSZzCfKLrybFM=;
	b=Nq2iIcrFitbylzUVB2kXFh/eNTAnNolgrPnAvbtykyeAvuP0/Gt2PoHYqJDpwV6GoV2uqJ
	cbr3saZvoYdvXbZFUUIK7Aj94NlaWB/5Iigthonx4BL1qY2OXbpu40WfySE0wNgGPxz+nm
	FpgIHVZNoBxbWLdZtZBuGABf0/LEQvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1685111519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMxERdXx7wwqcXUcsFITgZvHQBWYGRWSZzCfKLrybFM=;
	b=o27bLuj+fU+1s0ceXb3c+/tNm5OWJW4HSP/9TCKMgHwFSPLC8QwgUaHWY9SxgbkuzEbVxe
	GpAD8gRLILBt/4Ag==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id B988C2C141;
	Fri, 26 May 2023 14:31:59 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id ABCC851C3F40; Fri, 26 May 2023 16:31:58 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH 1/3] net/tls: handle MSG_EOR for tls_sw TX flow
Date: Fri, 26 May 2023 16:31:50 +0200
Message-Id: <20230526143152.53954-2-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230526143152.53954-1-hare@suse.de>
References: <20230526143152.53954-1-hare@suse.de>
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

tls_sw_sendmsg() / tls_do_sw_sendpage() already handles
MSG_MORE / MSG_SENDPAGE_NOTLAST, but bails out on MSG_EOR.
But seeing that MSG_EOR is basically the opposite of
MSG_MORE / MSG_SENDPAGE_NOTLAST this patch adds handling
MSG_EOR by treating it as the negation of MSG_MORE.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 net/tls/tls_sw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 635b8bf6b937..be8e0459d403 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -953,9 +953,12 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int pending;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
-			       MSG_CMSG_COMPAT))
+			       MSG_EOR | MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
+	if (msg->msg_flags & MSG_EOR)
+		eor = true;
+
 	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
 	if (ret)
 		return ret;
@@ -1173,6 +1176,8 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	bool eor;
 
 	eor = !(flags & MSG_SENDPAGE_NOTLAST);
+	if (flags & MSG_EOR)
+		eor = true;
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
 	/* Call the sk_stream functions to manage the sndbuf mem. */
@@ -1274,7 +1279,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
 			   int offset, size_t size, int flags)
 {
-	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
+	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_EOR |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
 		      MSG_NO_SHARED_FRAGS))
 		return -EOPNOTSUPP;
@@ -1288,7 +1293,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	int ret;
 
-	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
+	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_EOR |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-- 
2.35.3


