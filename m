Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D0D43D2BA
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbhJ0UV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbhJ0UVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:21:55 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19882C061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id y1-20020a17090a134100b001a27a7e9c8dso5684938pjf.3
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oCVbn4+crfbJm61FKS7BRgKh14C9+eQiyLx9V/bT1mI=;
        b=Tdy0RelOXR2+1mLKFXHZ3cEX4gfiQHdpIgyPsVmefqqtsZwY9I73qJOFm4h3m1BNqH
         ph1MD0z6m5yPhWEIthAssVyRveNDnyJT4fa5KpAkUuC7XCtrzbvvwwdoc6kllXccCe3q
         ECxf7vscfEEjwV224C+kkcexncDVPT1z4fr9JytbdzxI0eqFigCUDJsHCyiLU2suhg+p
         eJYTVAJNR9yGp/w86KQrAUUfpfRaBrhCy3/WJrt2uKaAuEUk4lmyHjMRCaB4P2RoLJGO
         TGfB0RPd8ZfAsSsToG1cbq4YahiLw1VqezXsWj6l/NlQ7kzdZ1OItxEJ/ZBVTcwYLU/3
         Vxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oCVbn4+crfbJm61FKS7BRgKh14C9+eQiyLx9V/bT1mI=;
        b=eA4bX1aRY8zTHT/QujDVdQbNiNtRB/Fb+ny5TNnFN3SJNaMjjOyfJvk1dCSpWWC6F7
         yoEQG6EfEj8NI1EMCdlEexUw6C4fCdo4L3ViOFNvswG6QwRROUC8BTKKpSFzlSsdMn6+
         lblszAhXv2TyT2XNg7itfPmHAm6/OdYngUYzYQZn5xQUrgKcGSN8eLMZcFPt9o7NVUC0
         nhifUWTx+R8kxd/9xqWg/kwbnPb6nDt21jFYXeWQclmWvepZR/0fjW5gi/WKEJQXzQQP
         KdlgtKRZE8opHifGLUPgQe2EjOYVh/lklKd+zX2w8CwP+yGo5oy+DmR3FFRtyWv4foRa
         5Orw==
X-Gm-Message-State: AOAM53126YN9+tWzi9HdzqaxnnCqC6pBhgXIgoYVMMvK3YUGUwXHM2Bz
        YmPuOwMt8ah1Z0IX/EtCDvw=
X-Google-Smtp-Source: ABdhPJwKgR7SZPuAq6KEr689j00+BW1b1RF9a0pxa7ob8zticgE2SjO+MVXeFeT9Afn2J+4atd9DHw==
X-Received: by 2002:a17:90b:3793:: with SMTP id mz19mr8214096pjb.6.1635365969673;
        Wed, 27 Oct 2021 13:19:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/7] tcp: cleanup tcp_remove_empty_skb() use
Date:   Wed, 27 Oct 2021 13:19:18 -0700
Message-Id: <20211027201923.4162520-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

All tcp_remove_empty_skb() callers now use tcp_write_queue_tail()
for the skb argument, we can therefore factorize code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h    | 2 +-
 net/ipv4/tcp.c       | 9 +++++----
 net/mptcp/protocol.c | 4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 701587af685296a6b2372fee7b3e94f998c3bbe8..8e8c5922a7b0c0a268a4c5a53d223489a10ca0bd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -311,7 +311,7 @@ void tcp_shutdown(struct sock *sk, int how);
 int tcp_v4_early_demux(struct sk_buff *skb);
 int tcp_v4_rcv(struct sk_buff *skb);
 
-void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb);
+void tcp_remove_empty_skb(struct sock *sk);
 int tcp_v4_tw_remember_stamp(struct inet_timewait_sock *tw);
 int tcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4053ace0cd76fbf076e422017fa31a472f00d7ba..68b946cfd433720a034c2023a13c086428646c51 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -933,8 +933,10 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  * importantly be able to generate EPOLLOUT for Edge Trigger epoll()
  * users.
  */
-void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
+void tcp_remove_empty_skb(struct sock *sk)
 {
+	struct sk_buff *skb = tcp_write_queue_tail(sk);
+
 	if (skb && TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		tcp_unlink_write_queue(skb, sk);
 		if (tcp_write_queue_empty(sk))
@@ -1087,7 +1089,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 	return copied;
 
 do_error:
-	tcp_remove_empty_skb(sk, tcp_write_queue_tail(sk));
+	tcp_remove_empty_skb(sk);
 	if (copied)
 		goto out;
 out_err:
@@ -1408,8 +1410,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	return copied + copied_syn;
 
 do_error:
-	skb = tcp_write_queue_tail(sk);
-	tcp_remove_empty_skb(sk, skb);
+	tcp_remove_empty_skb(sk);
 
 	if (copied + copied_syn)
 		goto out;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cd6b11c9b54d18e03bd3572e1f96c78d3dc37a2d..ccd62a2727c36a749455d122c106b4c5f76ef2ba 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1335,7 +1335,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
 		if (snd_una != msk->snd_nxt) {
-			tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
+			tcp_remove_empty_skb(ssk);
 			return 0;
 		}
 
@@ -1351,7 +1351,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 
 	copy = min_t(size_t, copy, info->limit - info->sent);
 	if (!sk_wmem_schedule(ssk, copy)) {
-		tcp_remove_empty_skb(ssk, tcp_write_queue_tail(ssk));
+		tcp_remove_empty_skb(ssk);
 		return -ENOMEM;
 	}
 
-- 
2.33.0.1079.g6e70778dc9-goog

