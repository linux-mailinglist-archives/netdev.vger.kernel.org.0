Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9482B850A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgKRToq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRTop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 14:44:45 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D23C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 11:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=tZKPGKSmmymGtXeC01Q9elUkxGGGyHcAJWQbaIKvDiE=; b=de6nFAXCaYzzhFAyhMcuGWgeiX
        Is+KH9FFxdk3HbwBqr0HEsL5iPVtVtNzb8YgKk1UNUgEVW6SFWt0fDGaO9CrL7hvn8FMCKKLBavVl
        n/hUCe38DTeJ9YTi/cmD8Kme1Ah6QSOXQyQ6Im1v0Eg3JArbSUbwFvkzAQbfDsOLFvvqTEA6rHE6U
        PWoszB6MXbFVlKD8+iwNCV2TeR1r/YxHMbnU5jse6ux40HKHcerBToq7UchhI8mBivpOTpDsZ5JI2
        0Uc8ty8uS1CAasz18PFX7Nb7ynlBNPauWv75n14ZLY890XDdFcqOaXAd0z/hmLutZYZ/lBp/jrueg
        GTgzzVCw==;
Received: from [2601:1c0:6280:3f0::bcc4] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfTNi-0007k7-Ib; Wed, 18 Nov 2020 19:44:43 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: stream: fix TCP references when INET is not enabled
Date:   Wed, 18 Nov 2020 11:44:38 -0800
Message-Id: <20201118194438.674-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build of net/core/stream.o when CONFIG_INET is not enabled.
Fixes these build errors (sample):

ld: net/core/stream.o: in function `sk_stream_write_space':
(.text+0x27e): undefined reference to `tcp_stream_memory_free'
ld: (.text+0x29c): undefined reference to `tcp_stream_memory_free'
ld: (.text+0x2ab): undefined reference to `tcp_stream_memory_free'
ld: net/core/stream.o: in function `sk_stream_wait_memory':
(.text+0x5a1): undefined reference to `tcp_stream_memory_free'
ld: (.text+0x5bf): undefined reference to `tcp_stream_memory_free'

Fixes: 1c5f2ced136a ("tcp: avoid indirect call to tcp_stream_memory_free()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 include/net/sock.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20201118.orig/include/net/sock.h
+++ linux-next-20201118/include/net/sock.h
@@ -1271,10 +1271,15 @@ static inline bool __sk_stream_memory_fr
 	if (READ_ONCE(sk->sk_wmem_queued) >= READ_ONCE(sk->sk_sndbuf))
 		return false;
 
+#ifdef CONFIG_INET
 	return sk->sk_prot->stream_memory_free ?
 		INDIRECT_CALL_1(sk->sk_prot->stream_memory_free,
 			        tcp_stream_memory_free,
 				sk, wake) : true;
+#else
+	return sk->sk_prot->stream_memory_free ?
+		sk->sk_prot->stream_memory_free(sk, wake) : true;
+#endif
 }
 
 static inline bool sk_stream_memory_free(const struct sock *sk)
