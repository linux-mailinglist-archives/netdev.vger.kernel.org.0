Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695D01920D7
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 06:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgCYF6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 01:58:06 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38240 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCYF6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 01:58:05 -0400
Received: by mail-pj1-f65.google.com with SMTP id m15so567705pje.3;
        Tue, 24 Mar 2020 22:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CzUUymxXRSfD4sSJMrl2KmAUGvBYRZv7HnQuFNAlbzs=;
        b=GT89g1V4wu01Gj4QgRlQ6nmJ2w5vKrcsuS7V4H1RBTzAJDvo1d6q38YAavo3iOfEFY
         yQcBQD6WNtLCEL7GqaOA24ydNIaKhl2y3XDve1SAcFkD79qegaByrJ7seOVAXoPkIKZ3
         B7APyX2ZSjWVLtdCtx2QZ9KQnvKmv9i9EOfET4lBedv1M7OoGS5LSpRhzmmw5lfdO7aD
         jU6QIq0qxW7HftflDXoKCzab4PThhZZ6kql9iXVxa2BUWyznk+60WzJrx3gmtB9+hKVQ
         A/8S8O5kRrk7FC3Gw2yathC0ZdewDiDhFiqlxsn3aGsP/rJuXRFEa6/IMjBxOLu7wpka
         uGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=CzUUymxXRSfD4sSJMrl2KmAUGvBYRZv7HnQuFNAlbzs=;
        b=D8OQzV2x1rNlwHJrVvLwQ3PlQIyU2yx1YHysRpxF3i+hHWP4eg7L3i9swnPvvVQM05
         TSH3XgF3sFX6iBHaqEV/Mxlf4B/OxezNWZ9M6uZW3Q5YdWFEFeldSQifHAdX8NBuLgxw
         QuhT6W4tmGH7u6+57Pt5nEULu3Qd+iGlqP+qzz467JHvH8ERaY6EWLuIPeVHuGJYdlrn
         SpOhFzch356IPYFVsRjZnxIYELSqPTdhEPnBhhjLDAtwAA49IQss6+pi+rVmAUQ9nA1n
         YuzX5PyWw8KawOaXXaLWbP51lEvbVRxtjmV5K8dkOkDUr+TqTbmAvtLZNi15IwuW21FY
         ncPA==
X-Gm-Message-State: ANhLgQ3Ec5E6LMkyPQiZhPeCzZ8eLdHcu6sC7iv/vXTSDdzMbPPGZ7Eg
        2rR3G7AhDGsIPyHRph/E/SQJuSfZ
X-Google-Smtp-Source: ADFU+vuBZfYz7CTyQ907Sw5wisJn4pSfBGd1ZQqGnu+xZ73KDmCSHVvJ8s7TutM2Aq2LemYI3W766Q==
X-Received: by 2002:a17:902:aa97:: with SMTP id d23mr1703856plr.244.1585115882272;
        Tue, 24 Mar 2020 22:58:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id e10sm17605716pfm.121.2020.03.24.22.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 22:58:01 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv2 bpf-next 4/5] bpf: Don't refcount LISTEN sockets in sk_assign()
Date:   Tue, 24 Mar 2020 22:57:44 -0700
Message-Id: <20200325055745.10710-5-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325055745.10710-1-joe@wand.net.nz>
References: <20200325055745.10710-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid taking a reference on listen sockets by checking the socket type
in the sk_assign and in the corresponding skb_steal_sock() code in the
the transport layer, and by ensuring that the prefetch free (sock_pfree)
function uses the same logic to check whether the socket is refcounted.

Suggested-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Joe Stringer <joe@wand.net.nz>
---
v2: Initial version
---
 include/net/sock.h | 25 +++++++++++++++++--------
 net/core/filter.c  |  6 +++---
 net/core/sock.c    |  3 ++-
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1ca2e808cb8e..3ec1865f173e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2533,6 +2533,21 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 	return skb->destructor == sock_pfree;
 }
 
+/* This helper checks if a socket is a full socket,
+ * ie _not_ a timewait or request socket.
+ */
+static inline bool sk_fullsock(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
+}
+
+static inline bool
+sk_is_refcounted(struct sock *sk)
+{
+	/* Only full sockets have sk->sk_flags. */
+	return !sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE);
+}
+
 /**
  * skb_steal_sock
  * @skb to steal the socket from
@@ -2545,6 +2560,8 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
 		struct sock *sk = skb->sk;
 
 		*refcounted = true;
+		if (skb_sk_is_prefetched(skb))
+			*refcounted = sk_is_refcounted(sk);
 		skb->destructor = NULL;
 		skb->sk = NULL;
 		return sk;
@@ -2553,14 +2570,6 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
 	return NULL;
 }
 
-/* This helper checks if a socket is a full socket,
- * ie _not_ a timewait or request socket.
- */
-static inline bool sk_fullsock(const struct sock *sk)
-{
-	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
-}
-
 /* Checks if this SKB belongs to an HW offloaded socket
  * and whether any SW fallbacks are required based on dev.
  * Check decrypted mark in case skb_orphan() cleared socket.
diff --git a/net/core/filter.c b/net/core/filter.c
index 0fada7fe9b75..997b8606167e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5343,8 +5343,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	/* Only full sockets have sk->sk_flags. */
-	if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
+	if (sk_is_refcounted(sk))
 		sock_gen_put(sk);
 	return 0;
 }
@@ -5870,7 +5869,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 		return -ESOCKTNOSUPPORT;
 	if (unlikely(dev_net(skb->dev) != sock_net(sk)))
 		return -ENETUNREACH;
-	if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+	if (sk_is_refcounted(sk) &&
+	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 		return -ENOENT;
 
 	skb_orphan(skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index cfaf60267360..a2ab79446f59 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2076,7 +2076,8 @@ EXPORT_SYMBOL(sock_efree);
  */
 void sock_pfree(struct sk_buff *skb)
 {
-	sock_edemux(skb);
+	if (sk_is_refcounted(skb->sk))
+		sock_edemux(skb);
 }
 EXPORT_SYMBOL(sock_pfree);
 
-- 
2.20.1

