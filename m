Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B8B419E2B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhI0S1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbhI0S1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:27:09 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AECC061740
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:25:30 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id m6-20020a05620a24c600b004338e8a5a3cso74569800qkn.10
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AEdbX08kgGkeg4zYclXfcLJocSHrhkXOPVQK+H9otHc=;
        b=P+ywoHhrnbXSCfemGnHTWK5UvGep8d/jnkMz+obZOUKwpmMnEtSSfVpJ+ZtJQ+GEPW
         W8D90h4ak5LGZnUUxnanZ9RXpTBDCWyL/XxzKW1OVH428yRg8Mb0XtQTUae0MFtubIX4
         +b/UEfFlv12ENzhH8f/ZxKxDKRUGWIJM6wt2q6i0MUBZDtICG7bXsQZg61stCJr6m/IP
         /8lv0Cw7r+ZMoKmBrIlTZzSgvPQOewwHI4yqMrmyy6GstKIA2bvK02L7KNgA8oTOI/q6
         pOb5+Od7mB/yaXuEYfuxd2prLyGALUIitD8OTJCBWYfV+3i/rLv9EFNxNg0GN6od7B9A
         QxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AEdbX08kgGkeg4zYclXfcLJocSHrhkXOPVQK+H9otHc=;
        b=OUy3fLF9YNvBaUwkKV0VjhLXyYO04nSY6fVEkSs1/keRoC5kFM6WUHBpTxm7wbWNML
         RDuSDL0NvrM/FuottEagbT50doEwunE7EyWoRkLAztgy+1wTupNNGiSPCS728u9HFgZo
         3EFAwPbL8kpVCX/51Zd8jSsxsng4fEXxH8oP6fTh/sgw2j+S8Ul5hDs9sem1sip4F/gY
         13BOBfYbFCTtMAT4js99Z2l7brzsW3HLpqYPn01Bnop8mwgS8D7DDIZ3v0mrB6dJ/eO6
         eQNFwZezleFrQt3R0D84DwCJkm+7DeFq5Z0guywCIofOzIEQsJv4EOx0RK7RjCJgEavp
         GTXg==
X-Gm-Message-State: AOAM533NrMFolFHkxeHL1mrCskD/BXQmUleoXLWRTHsukPuDA0VunlCp
        W7Qrp/QCoTvUnX9SEsTZzHfv2L90Ehk=
X-Google-Smtp-Source: ABdhPJw89g0qCIkBZUfFQoq05k9ub2BcZrk+qNOtZQxqPhc+E2rnN4kCx+u8SZvQA4YXJilGmC9kQOSD474=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:889:3fd7:84f6:f39c])
 (user=weiwan job=sendgmr) by 2002:a05:6214:1351:: with SMTP id
 b17mr1150347qvw.11.1632767130035; Mon, 27 Sep 2021 11:25:30 -0700 (PDT)
Date:   Mon, 27 Sep 2021 11:25:22 -0700
In-Reply-To: <20210927182523.2704818-1-weiwan@google.com>
Message-Id: <20210927182523.2704818-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210927182523.2704818-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH net-next 2/3] tcp: adjust sndbuf according to sk_reserved_mem
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user sets SO_RESERVE_MEM socket option, in order to fully utilize the
reserved memory in memory pressure state on the tx path, we modify the
logic in sk_stream_moderate_sndbuf() to set sk_sndbuf according to
available reserved memory, instead of MIN_SOCK_SNDBUF, and adjust it
when new data is acked.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
---
 include/net/sock.h   |  1 +
 net/ipv4/tcp_input.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b0df2d3843fd..e6ad628adcd2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2388,6 +2388,7 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 		return;
 
 	val = min(sk->sk_sndbuf, sk->sk_wmem_queued >> 1);
+	val = max_t(u32, val, sk_unused_reserved_mem(sk));
 
 	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 141e85e6422b..a7611256f235 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5381,7 +5381,7 @@ static int tcp_prune_queue(struct sock *sk)
 	return -1;
 }
 
-static bool tcp_should_expand_sndbuf(const struct sock *sk)
+static bool tcp_should_expand_sndbuf(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
@@ -5392,8 +5392,18 @@ static bool tcp_should_expand_sndbuf(const struct sock *sk)
 		return false;
 
 	/* If we are under global TCP memory pressure, do not expand.  */
-	if (tcp_under_memory_pressure(sk))
+	if (tcp_under_memory_pressure(sk)) {
+		int unused_mem = sk_unused_reserved_mem(sk);
+
+		/* Adjust sndbuf according to reserved mem. But make sure
+		 * it never goes below SOCK_MIN_SNDBUF.
+		 * See sk_stream_moderate_sndbuf() for more details.
+		 */
+		if (unused_mem > SOCK_MIN_SNDBUF)
+			WRITE_ONCE(sk->sk_sndbuf, unused_mem);
+
 		return false;
+	}
 
 	/* If we are under soft global TCP memory pressure, do not expand.  */
 	if (sk_memory_allocated(sk) >= sk_prot_mem_limits(sk, 0))
-- 
2.33.0.685.g46640cef36-goog

