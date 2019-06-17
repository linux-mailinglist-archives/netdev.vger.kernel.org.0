Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3338F48996
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfFQREd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:04:33 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:46766 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFQREd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:04:33 -0400
Received: by mail-yb1-f202.google.com with SMTP id v15so11278921ybe.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZWi+a+h1F7JSKoGZGugQTAEE1gevuEuH0Hoa8w4oacw=;
        b=sWuL1ht6WSML6G23cNq3htXh8Qs6sLCTkSPrRPUgJ2A8+ZCkp9bU+PPMli0ckcyAQq
         S9T5SC6k7yep5w3fTskNgzBO8ySPbZOIOAMZfv01kRhBwDWaXHDqWnAx14qijo3FPH+Z
         lxpJGGZMb3OM+L5NqsXnf9Myg2Nt0fC/Mvs0N4e8MW3vU6T/zZFwa3uzeQwQScgR7T2n
         4saSVhlDC37Z0bmIaW8x0v4sRHxZDYEZC/BcghcrVNltxnQMLbgLbi7jnSG6VMnMAPUG
         hnGS79iDb25+YnZSJTsmbG/8NUWYxHwiGJJxtfRW+9P1CmC5pkr2UBeUTRjG1D+DESL/
         MK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZWi+a+h1F7JSKoGZGugQTAEE1gevuEuH0Hoa8w4oacw=;
        b=Be3PUaGHGkArAKI2LszGueKaElU7UrgnERv05X5i+6JkYqa1UY/WBZa+PQgh5K+Xjg
         uG22KNd7Ph73KIXE6jajvF3LrE87f4MjPshzxyg3j60S/qjtO3VSo4qUE0SQidhkpcdO
         N3sIAvWPYqAaXq8nPSLLP8UBZdW1nsy8Mf36L/AJ2rmKsTAeQ2pBk1yTzWZ4c4Rj14mw
         ACp5aNaXEt6KS6zb/vbh7DWSLPk9iTdW8EeP/t8vtw6xitNMg9ZGHbB0Ev3LYbblFvNf
         A3JJQ71MSAvQ/AvgUsIXsgfNFfNyHCsuvQm7RNQBYnFwsiQ/O8LeFV7IJ2X4U5pqx7Aq
         Tv6g==
X-Gm-Message-State: APjAAAVo2vXQdjKZYgF+0BtYKQvOq7AvRVejy7cyv6WwcFh2DvAVxgUz
        GTBwHf8UBuMCAbbxLOlmHPKga1a7FrCc6g==
X-Google-Smtp-Source: APXvYqx6QJrlucdGBiIStUk3tw7sURYJt2r5GI38qf7dX8qPv35VITWkOEGbLxli6GYzLWAJCMYZyiECcjN8/A==
X-Received: by 2002:a25:fc15:: with SMTP id v21mr46823381ybd.463.1560791072501;
 Mon, 17 Jun 2019 10:04:32 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:03:51 -0700
In-Reply-To: <20190617170354.37770-1-edumazet@google.com>
Message-Id: <20190617170354.37770-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190617170354.37770-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 1/4] tcp: limit payload size of sacked skbs
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Looney reported that TCP can trigger the following crash
in tcp_shifted_skb() :

	BUG_ON(tcp_skb_pcount(skb) < pcount);

This can happen if the remote peer has advertized the smallest
MSS that linux TCP accepts : 48

An skb can hold 17 fragments, and each fragment can hold 32KB
on x86, or 64KB on PowerPC.

This means that the 16bit witdh of TCP_SKB_CB(skb)->tcp_gso_segs
can overflow.

Note that tcp_sendmsg() builds skbs with less than 64KB
of payload, so this problem needs SACK to be enabled.
SACK blocks allow TCP to coalesce multiple skbs in the retransmit
queue, thus filling the 17 fragments to maximal capacity.

CVE-2019-11477 -- u16 overflow of TCP_SKB_CB(skb)->tcp_gso_segs

Fixes: 832d11c5cd07 ("tcp: Try to restore large SKBs while SACK processing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Bruce Curtis <brucec@netflix.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/tcp.h   |  4 ++++
 include/net/tcp.h     |  2 ++
 net/ipv4/tcp.c        |  1 +
 net/ipv4/tcp_input.c  | 26 ++++++++++++++++++++------
 net/ipv4/tcp_output.c |  6 +++---
 5 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 711361af9ce019f08c8b6accc33220b673b34d56..9a478a0cd3a20b40ed344f178e35228a0b8ee203 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -484,4 +484,8 @@ static inline u16 tcp_mss_clamp(const struct tcp_sock *tp, u16 mss)
 
 	return (user_mss && user_mss < mss) ? user_mss : mss;
 }
+
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
+		  int shiftlen);
+
 #endif	/* _LINUX_TCP_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index ac2f53fbfa6b4cbf1fc615c952a5e1cac1124300..582c0caa98116740b5bde8c5dbb5d94fc69d1caa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -51,6 +51,8 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 #define MAX_TCP_HEADER	(128 + MAX_HEADER)
 #define MAX_TCP_OPTION_SPACE 40
+#define TCP_MIN_SND_MSS		48
+#define TCP_MIN_GSO_SIZE	(TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)
 
 /*
  * Never offer a window over 32767 without using window scaling. Some
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f448a288d158c4baa6d8d5ed82c4b129404233a1..7dc9ab84bb69aa90953e98f9763287fcee3a1659 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3873,6 +3873,7 @@ void __init tcp_init(void)
 	unsigned long limit;
 	unsigned int i;
 
+	BUILD_BUG_ON(TCP_MIN_SND_MSS <= MAX_TCP_OPTION_SPACE);
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) >
 		     FIELD_SIZEOF(struct sk_buff, cb));
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 38dfc308c0fb9832facadb0aeec8f3e4931901f4..d95ee40df6c2b020d590018bc41833b8a6aefa4a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1302,7 +1302,7 @@ static bool tcp_shifted_skb(struct sock *sk, struct sk_buff *prev,
 	TCP_SKB_CB(skb)->seq += shifted;
 
 	tcp_skb_pcount_add(prev, pcount);
-	BUG_ON(tcp_skb_pcount(skb) < pcount);
+	WARN_ON_ONCE(tcp_skb_pcount(skb) < pcount);
 	tcp_skb_pcount_add(skb, -pcount);
 
 	/* When we're adding to gso_segs == 1, gso_size will be zero,
@@ -1368,6 +1368,21 @@ static int skb_can_shift(const struct sk_buff *skb)
 	return !skb_headlen(skb) && skb_is_nonlinear(skb);
 }
 
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from,
+		  int pcount, int shiftlen)
+{
+	/* TCP min gso_size is 8 bytes (TCP_MIN_GSO_SIZE)
+	 * Since TCP_SKB_CB(skb)->tcp_gso_segs is 16 bits, we need
+	 * to make sure not storing more than 65535 * 8 bytes per skb,
+	 * even if current MSS is bigger.
+	 */
+	if (unlikely(to->len + shiftlen >= 65535 * TCP_MIN_GSO_SIZE))
+		return 0;
+	if (unlikely(tcp_skb_pcount(to) + pcount > 65535))
+		return 0;
+	return skb_shift(to, from, shiftlen);
+}
+
 /* Try collapsing SACK blocks spanning across multiple skbs to a single
  * skb.
  */
@@ -1473,7 +1488,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	if (!after(TCP_SKB_CB(skb)->seq + len, tp->snd_una))
 		goto fallback;
 
-	if (!skb_shift(prev, skb, len))
+	if (!tcp_skb_shift(prev, skb, pcount, len))
 		goto fallback;
 	if (!tcp_shifted_skb(sk, prev, skb, state, pcount, len, mss, dup_sack))
 		goto out;
@@ -1491,11 +1506,10 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 		goto out;
 
 	len = skb->len;
-	if (skb_shift(prev, skb, len)) {
-		pcount += tcp_skb_pcount(skb);
-		tcp_shifted_skb(sk, prev, skb, state, tcp_skb_pcount(skb),
+	pcount = tcp_skb_pcount(skb);
+	if (tcp_skb_shift(prev, skb, pcount, len))
+		tcp_shifted_skb(sk, prev, skb, state, pcount,
 				len, mss, 0);
-	}
 
 out:
 	return prev;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f429e856e2631a9e6de1d2e060406742f97e538e..b8e3bbb852117459d131fbb41d69ae63bd251a3e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1454,8 +1454,8 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	if (mss_now < 48)
-		mss_now = 48;
+	if (mss_now < TCP_MIN_SND_MSS)
+		mss_now = TCP_MIN_SND_MSS;
 	return mss_now;
 }
 
@@ -2747,7 +2747,7 @@ static bool tcp_collapse_retrans(struct sock *sk, struct sk_buff *skb)
 		if (next_skb_size <= skb_availroom(skb))
 			skb_copy_bits(next_skb, 0, skb_put(skb, next_skb_size),
 				      next_skb_size);
-		else if (!skb_shift(skb, next_skb, next_skb_size))
+		else if (!tcp_skb_shift(skb, next_skb, 1, next_skb_size))
 			return false;
 	}
 	tcp_highest_sack_replace(sk, next_skb, skb);
-- 
2.22.0.410.gd8fdbe21b5-goog

