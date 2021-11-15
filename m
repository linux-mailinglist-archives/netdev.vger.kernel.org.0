Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB524514AE
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349281AbhKOUL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345801AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5FDC0BC9B2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so46552pju.3
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/TovmZ1K9tI8NqkLQ22dxDQKHjvouGKJ4E5JFP7fCMI=;
        b=LaTELH5xEJ7GuwtDwCpPRABIlLYpzMHtMFTcnJzjvv8mhwM1piwT8wN872jz993JFs
         lZ3uGPctLaor9B3wZwfNJSBdROVnEM0pbktSKtDRO4i1x14Zd+yJ9ztd/j2H4N0oQ3J2
         BL6VxWSUAeoUKXIaChpE9J8KbXW4H0DPBrEWzNy7mfp3D4M6/JEPXseT3eg31vZdF/Ns
         nhHpXX2LZI6wDI3eJTCekHlucQY3A8PxoIdV9gGASUykjw1bPTS1KacumUqetCL+uFiK
         qti3ODBzSHwN3jLhBF0M17crwWDIiTGkc2p6e2E+vsYgQoWVT0J72qMEjc0i8iSmuX06
         LU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/TovmZ1K9tI8NqkLQ22dxDQKHjvouGKJ4E5JFP7fCMI=;
        b=elB1WS/Pv6K9720JqKSwJ42mCyuJDQm4IC3FKABzq/CXtMtONXe3ubfT0np1qAGTQ3
         lJvXNXLloimc1l6mvpkfD8C+STiVKOABpyOdzzPgWvOruWMmI6sMTwcja6SORHo3TSzK
         ENWRebj6bCOUqkX1zCe19qdRfhDW9X4OUdcUuLkVpO6QvrBnDIR1Iq4CkK/sFkiH3ThS
         tCcoQZXwuidycm2nb9JJTZqFVAFwFSgX38DRlpuYDT7I3dewUheevdOemfopbr3cFvjF
         FMYzFgmlPxRZXCM8DbvwLRSOWn5lX1tN9tnqk978d+6LAw838P0+wp1SUs2NO7YfWimS
         IZrA==
X-Gm-Message-State: AOAM531Ni6s9mK2JpmAZnhRt6xr0uaupL4htYq7lPs9t2immGv0Q+zke
        ncG7+4b+7YAxnE5ajLDKVL4=
X-Google-Smtp-Source: ABdhPJyxbtPnWrfk5qbBYM656FNSH3TD/LAiC2K2Kba/d01i/1MEWglfXLEH9Vqds3sFW1Y0tSBncw==
X-Received: by 2002:a17:90b:4f83:: with SMTP id qe3mr68157606pjb.56.1637002995217;
        Mon, 15 Nov 2021 11:03:15 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 11/20] tcp: small optimization in tcp recvmsg()
Date:   Mon, 15 Nov 2021 11:02:40 -0800
Message-Id: <20211115190249.3936899-12-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

When reading large chunks of data, incoming packets might
be added to the backlog from BH.

tcp recvmsg() detects the backlog queue is not empty, and uses
a release_sock()/lock_sock() pair to process this backlog.

We now have __sk_flush_backlog() to perform this
a bit faster.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 862e8cb8dda51e76300a427783a7d8c32e82cc7f..24d77a32c9cbcdf0e4380ec6d9aa3e42d2cf8730 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2409,8 +2409,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 		if (copied >= target) {
 			/* Do not sleep, just process backlog. */
-			release_sock(sk);
-			lock_sock(sk);
+			__sk_flush_backlog(sk);
 		} else {
 			sk_wait_data(sk, &timeo, last);
 		}
-- 
2.34.0.rc1.387.gb447b232ab-goog

