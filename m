Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0E12E567
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 21:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfE2TeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 15:34:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45612 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2TeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 15:34:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id t1so4061657qtc.12
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=01+Ie6CLfHPKOYKN8E/zxFpoYc7CQc9jAgSj/7deQVI=;
        b=No/5yMZ7t+NjOgPmVQICbxZquQSWTUxFaWfrX4NjDcdXIOLOnKHkXW7bUslOsLRlZH
         OyKAry4xtlelGMzFsFHprL4hVL8wpSoqf+HKAzytEN6wbRuZawGe/5kF6YsHb56Ol/jR
         Vb4SdJp0mIa2n/7CIG8dHCYMFv2cjY9BhJSACLimLVOzzbhU51QiYY33JbfyshV38yQv
         PT5UOW5tTP/vnsOGMXJ2NZcQ9GqjB5g0Hl1BlFh0RTmeqoKvrN1p0m0vYrZZ9Ql70lez
         tnYErdNMB0bc0VaFcR+BjVasWC2gJJWaVXaaw2iN3GSqh7bNhAUETFaG8KxUQavIRKUC
         wnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=01+Ie6CLfHPKOYKN8E/zxFpoYc7CQc9jAgSj/7deQVI=;
        b=ZpDr+puC+pd1/eOcVxrFSDFMgit/jr/i65XZw1SsrT34JHa7xgpCH3uXzRqKCRZS17
         JChUUMpP6B+Z2xqXoezv4t4zo9wxzy5UQm5moyeEvY/2SFxxk9BNVFeyg3yezLqxF0YF
         0IPupP4+ljPltFO/10YYXjK8CDv2/cnf0BkPKQcDQPaaI2iB00mLxUfOts0xUQtgbkVO
         o+NKqKWOHo8IPwWmIFXgmYPIx9ZrXl/a4bmOiv21fndYTp/lLA7YVJepi4RIZci47gwM
         Wf8W6ZxDmcsDzkr8MlWeXqdTwn1djMSznmnjJcgN6oaC0PeZU6+Wmcy8syT14BDiwU/F
         SDwA==
X-Gm-Message-State: APjAAAVB//zay2+Yi/FZJSgJxOkDkGuloU2z35sLvTmSzkQ+K7l5XOZi
        QltljVngvWV0jrXOFyHHzs26aLrd
X-Google-Smtp-Source: APXvYqyFMpPPHrlHDJZCxPY57OY6b2KcBnyOtlbbMRlraxwlBJBvDVFirjA8HIITkMtEfuWfzvujpg==
X-Received: by 2002:ac8:87d:: with SMTP id x58mr540570qth.368.1559158440083;
        Wed, 29 May 2019 12:34:00 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id c5sm151007qtj.27.2019.05.29.12.33.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 12:33:59 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: correct zerocopy refcnt with udp MSG_MORE
Date:   Wed, 29 May 2019 15:33:57 -0400
Message-Id: <20190529193357.73457-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

TCP zerocopy takes a uarg reference for every skb, plus one for the
tcp_sendmsg_locked datapath temporarily, to avoid reaching refcnt zero
as it builds, sends and frees skbs inside its inner loop.

UDP and RAW zerocopy do not send inside the inner loop so do not need
the extra sock_zerocopy_get + sock_zerocopy_put pair. Commit
52900d22288ed ("udp: elide zerocopy operation in hot path") introduced
extra_uref to pass the initial reference taken in sock_zerocopy_alloc
to the first generated skb.

But, sock_zerocopy_realloc takes this extra reference at the start of
every call. With MSG_MORE, no new skb may be generated to attach the
extra_uref to, so refcnt is incorrectly 2 with only one skb.

Do not take the extra ref if uarg && !tcp, which implies MSG_MORE.
Update extra_uref accordingly.

This conditional assignment triggers a false positive may be used
uninitialized warning, so have to initialize extra_uref at define.

Fixes: 52900d22288ed ("udp: elide zerocopy operation in hot path")
Reported-by: syzbot <syzkaller@googlegroups.com>
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c     | 6 +++++-
 net/ipv4/ip_output.c  | 4 ++--
 net/ipv6/ip6_output.c | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e89be62826937..eaad23f9c7b5b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1036,7 +1036,11 @@ struct ubuf_info *sock_zerocopy_realloc(struct sock *sk, size_t size,
 			uarg->len++;
 			uarg->bytelen = bytelen;
 			atomic_set(&sk->sk_zckey, ++next);
-			sock_zerocopy_get(uarg);
+
+			/* no extra ref when appending to datagram (MSG_MORE) */
+			if (sk->sk_type == SOCK_STREAM)
+				sock_zerocopy_get(uarg);
+
 			return uarg;
 		}
 	}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index bfd0ca554977a..8c9189a41b136 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -878,7 +878,7 @@ static int __ip_append_data(struct sock *sk,
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref;
+	bool paged, extra_uref = false;
 	u32 tskey = 0;
 
 	skb = skb_peek_tail(queue);
@@ -918,7 +918,7 @@ static int __ip_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = true;
+		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index adef2236abe2e..f9e43323e6673 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1275,7 +1275,7 @@ static int __ip6_append_data(struct sock *sk,
 	int csummode = CHECKSUM_NONE;
 	unsigned int maxnonfragsize, headersize;
 	unsigned int wmem_alloc_delta = 0;
-	bool paged, extra_uref;
+	bool paged, extra_uref = false;
 
 	skb = skb_peek_tail(queue);
 	if (!skb) {
@@ -1344,7 +1344,7 @@ static int __ip6_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = true;
+		extra_uref = !skb;	/* only extra ref if !MSG_MORE */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
-- 
2.22.0.rc1.257.g3120a18244-goog

