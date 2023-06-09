Return-Path: <netdev+bounces-9535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15ABC729AB3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F3B51C21040
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E530E154B5;
	Fri,  9 Jun 2023 12:52:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA25D1391
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:52:51 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F844227
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:52:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 74AA31FDF9;
	Fri,  9 Jun 2023 12:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1686315119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/MJTUeDZzlx42IR4b00ab5UFRMqUbHmDFYZj2cxqws=;
	b=vjQuoMKATJ5i0NjZWQPLIbymLEKHNphMb/w57LuuY15zXpfP/Cw2cQ1Ik/KKGO2JuyHREm
	fh8nAqPI2iOPnVHfpPwGsh2Tz/FaFqbdPHnwMmbVRBVsFjg2CflyT9ras7wfFX6uuDUP/l
	Dkea67LLVCC2OZYymH55WczhCVup0gk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1686315119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/MJTUeDZzlx42IR4b00ab5UFRMqUbHmDFYZj2cxqws=;
	b=MXRSZC0Kn9nDXdaleumWbkBGFgI7mgGfcmhVsFKr6LrXqAcHFIr/n19d4fPsQe1gPzCX20
	6VNPwxDU0peGkyCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
	by relay2.suse.de (Postfix) with ESMTP id 5FB2D2C143;
	Fri,  9 Jun 2023 12:51:59 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
	id 5482251C48C1; Fri,  9 Jun 2023 14:51:59 +0200 (CEST)
From: Hannes Reinecke <hare@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] net/tls: handle MSG_EOR for tls_device TX flow
Date: Fri,  9 Jun 2023 14:51:51 +0200
Message-Id: <20230609125153.3919-3-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230609125153.3919-1-hare@suse.de>
References: <20230609125153.3919-1-hare@suse.de>
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
MSG_EOR by treating it as the negation of MSG_MORE.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 net/tls/tls_device.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a7cc4f9faac2..9603a3c9ec24 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -449,7 +449,7 @@ static int tls_push_data(struct sock *sk,
 	long timeo;
 
 	if (flags &
-	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
+	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST | MSG_EOR))
 		return -EOPNOTSUPP;
 
 	if (unlikely(sk->sk_err))
@@ -529,6 +529,10 @@ static int tls_push_data(struct sock *sk,
 				more = true;
 				break;
 			}
+			if (flags & MSG_EOR) {
+				more = false;
+				break;
+			}
 
 			done = true;
 		}
@@ -603,6 +607,8 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
+	if (flags & MSG_EOR)
+		flags &= ~(MSG_MORE | MSG_SENDPAGE_NOTLAST);
 
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
-- 
2.35.3


