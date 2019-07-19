Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEFA6EADD
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfGSSwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 14:52:43 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:40480 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfGSSwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 14:52:42 -0400
Received: by mail-qk1-f201.google.com with SMTP id c1so27034177qkl.7
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 11:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=44x+pq6iZC/dRul/wfwZjhOf8yeXX2ydpQcj62E5604=;
        b=eqndul6hXS6+4BM4rhpBHcXvSF5tCwh3gq79vOxu8oCMU8vqViCLl/6GqwCP5iYE6V
         AW82OHTLc/ty6Og9W6f+NOQatIOGZy7s85uGtQ+FBP5yiZIRjE7cLFBgGZwIPb9TH1eH
         5LFjh2mYrMu3BpXny0tJRFV+dkH4FpqujBR2mmme3yz2Idstx0qmox2/5K3Z6JJJmmni
         HOTgmeKIVMkDGo4UESjHx2tapgu28QUJWVWmdGecj/8gYmk/RZBWkzTNqMSkth6U+yp6
         hAHDbmQv44E6lzZ75f+peKBx2LuiQP68HMw6uA82lu5YUIR4L5LrL+GtmzTYF9cXVUby
         C72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=44x+pq6iZC/dRul/wfwZjhOf8yeXX2ydpQcj62E5604=;
        b=e9cMqMF/TxjafRAuRvLMB2/Eqwlns6mwYnzRBkckny+PSqRwwqUpxYcHLmUl7MTHhg
         YIjlgY5f9yKYoZm10s/L++Qe3D3YLtunsBnuaZdT+cmF7KE2RWNzWx0UlGXj/fjMNBSr
         5IvdLZqVDLXiW6+3srKyCLFn16QJiHS6yp2+p3waS8KoaJWxL5Tswd6rOzogxIdQSnna
         x3y699SEQbbCwKt0PcGuwQNEr/o+u3d6H+xfD9+Kk1CkqIF/l1xufCutZW5zZd9ivdJ0
         zzu/WGhrZSVE48kZjMaSKQaDltLw41rZiOYl7k1qe8T48F/uU9ItF60IfnKYZ6Fn3ccy
         s2vw==
X-Gm-Message-State: APjAAAXG2dUFAo3tfJqR4HmtlzqThXHkCYLpVAzbaKL+wGSmMVek9Bp7
        7ubhWe+mCTJWk+BtQ6A5ijHYOUpZzjBB3Q==
X-Google-Smtp-Source: APXvYqzbdp8X6wgCZAC7dwTSnLWC7qGdXYywlcjyK0PcxofbeRvLXsIiCzj0HrNrGqYX7i8vQyLyM6eaMlK5Ug==
X-Received: by 2002:ac8:3132:: with SMTP id g47mr38266432qtb.155.1563562361713;
 Fri, 19 Jul 2019 11:52:41 -0700 (PDT)
Date:   Fri, 19 Jul 2019 11:52:33 -0700
Message-Id: <20190719185233.242049-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH net] tcp: be more careful in tcp_fragment()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Prout <aprout@ll.mit.edu>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Jonathan Looney <jtl@netflix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some applications set tiny SO_SNDBUF values and expect
TCP to just work. Recent patches to address CVE-2019-11478
broke them in case of losses, since retransmits might
be prevented.

We should allow these flows to make progress.

This patch allows the first and last skb in retransmit queue
to be split even if memory limits are hit.

It also adds the some room due to the fact that tcp_sendmsg()
and tcp_sendpage() might overshoot sk_wmem_queued by about one full
TSO skb (64KB size). Note this allowance was already present
in stable backports for kernels < 4.15

Note for < 4.15 backports :
 tcp_rtx_queue_tail() will probably look like :

static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
{
	struct sk_buff *skb = tcp_send_head(sk);

	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
}

Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Andrew Prout <aprout@ll.mit.edu>
Tested-by: Andrew Prout <aprout@ll.mit.edu>
Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Tested-by: Michal Kubecek <mkubecek@suse.cz>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Christoph Paasch <cpaasch@apple.com>
Cc: Jonathan Looney <jtl@netflix.com>
---
 include/net/tcp.h     |  5 +++++
 net/ipv4/tcp_output.c | 13 +++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f42d300f0cfaa87520320dd287a7b4750adf7d8a..e5cf514ba118e688ce3b3da66f696abd47e1d10f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1709,6 +1709,11 @@ static inline struct sk_buff *tcp_rtx_queue_head(const struct sock *sk)
 	return skb_rb_first(&sk->tcp_rtx_queue);
 }
 
+static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
+{
+	return skb_rb_last(&sk->tcp_rtx_queue);
+}
+
 static inline struct sk_buff *tcp_write_queue_head(const struct sock *sk)
 {
 	return skb_peek(&sk->sk_write_queue);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4af1f5dae9d3e937ef39685355c9d3f19ff3ee3b..6e4afc48d7bba7cded4d3fe38f32ab02328f9e05 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1288,6 +1288,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
 	int nsize, old_factor;
+	long limit;
 	int nlen;
 	u8 flags;
 
@@ -1298,8 +1299,16 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
-		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
+	/* tcp_sendmsg() can overshoot sk_wmem_queued by one full size skb.
+	 * We need some allowance to not penalize applications setting small
+	 * SO_SNDBUF values.
+	 * Also allow first and last skb in retransmit queue to be split.
+	 */
+	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
+	if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
+		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE &&
+		     skb != tcp_rtx_queue_head(sk) &&
+		     skb != tcp_rtx_queue_tail(sk))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
-- 
2.22.0.657.g960e92d24f-goog

