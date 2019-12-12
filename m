Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CAE11D830
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbfLLUzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:55:44 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:45097 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfLLUzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 15:55:44 -0500
Received: by mail-pf1-f202.google.com with SMTP id x21so23195pfp.12
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 12:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EpyDNDYeLGxwn+USrdxWDhMzrxJdC0I1/5c9j25Btgg=;
        b=fIJBB6tor5LfC8Fgps0hBoB2/wKYg2ioDhm3OQvdKvVjnIRJPTOrgVknCYNfJf7Ne+
         Ls/hh/1EZZhM/PWvM+rfgggTtpGhng6IG/+F+ywbqFTp+h2qkdJPwd/22Vqvw6BE/CMZ
         ttZMQTcg1iN9LM/6vkYrXzS/kOgnu21fQZTsin0g55PG4/p6enVWtIx3XjctfuadRFg6
         GFQ9j267Yl4Uect2bs2qMM3S3HGp0PwVYzCCVCpcBJtGQ3/zBtyKX0A8G59+jr+hnO/6
         xi8it8bVFAY4NX9srxNgACvJ6Bu8dSdjhXcb0xNz2b6pvFr4IwDkGO9UwWcQoXS8cn/v
         u+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EpyDNDYeLGxwn+USrdxWDhMzrxJdC0I1/5c9j25Btgg=;
        b=IQ6s9pSa2YvBB7FIT+ULWUfdgctDnnGLfOn/CwExex3W1b+Ok3c8ZD61TNG2dCSNtb
         aYMHFh3nI6EPmJp3SKgK8q6D6lA7+yBSCOmNS+u5b/VNl7ciUqsEEJnuFZp70AurTfE6
         o8XwMrDk/m4klr67fCcFrJlSNsspasVp2p1yI41cEnXkTiM3fg9ILFsj7M/N/JSr5DdN
         tZdR1aUOlpbDW5QxPcFQ644JN9iQVQEL+UYa2MeXplyc39A+Rhal0/Re5wFCMNfcYfKq
         m5XxOGqd9lHi+OkVdw88cRoyEw9y9BcpExhj8G5Q1Y2+aKD4KrMddYn9haOtVKKs8F+k
         /Fvg==
X-Gm-Message-State: APjAAAWjsxzwBsTbbLTcps9quMHwkVWt4EU3sAZZUb6ln4s90Bwp0Odc
        sZxC89kQ/bZxcINrbeN8bSBKRnRyyzOzXg==
X-Google-Smtp-Source: APXvYqx0Ue0UQvb0id1RExwtJ7LiwcQF0BwJqSIgf3bRntNGGulMHbRLqoH3683une6s/vTfE3sbg/KJSwquyA==
X-Received: by 2002:a63:4303:: with SMTP id q3mr12790552pga.439.1576184143238;
 Thu, 12 Dec 2019 12:55:43 -0800 (PST)
Date:   Thu, 12 Dec 2019 12:55:29 -0800
In-Reply-To: <20191212205531.213908-1-edumazet@google.com>
Message-Id: <20191212205531.213908-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191212205531.213908-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 1/3] tcp: do not send empty skb from tcp_write_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Backport of commit fdfc5c8594c2 ("tcp: remove empty skb from
write queue in error cases") in linux-4.14 stable triggered
various bugs. One of them has been fixed in commit ba2ddb43f270
("tcp: Don't dequeue SYN/FIN-segments from write-queue"), but
we still have crashes in some occasions.

Root-cause is that when tcp_sendmsg() has allocated a fresh
skb and could not append a fragment before being blocked
in sk_stream_wait_memory(), tcp_write_xmit() might be called
and decide to send this fresh and empty skb.

Sending an empty packet is not only silly, it might have caused
many issues we had in the past with tp->packets_out being
out of sync.

Fixes: c65f7f00c587 ("[TCP]: Simplify SKB data portion allocation with NETIF_F_SG.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Christoph Paasch <cpaasch@apple.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Cc: Jason Baron <jbaron@akamai.com>
---
 net/ipv4/tcp_output.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b184f03d743715ef4b2d166ceae651529be77953..57f434a8e41ffd6bc584cb4d9e87703491a378c1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2438,6 +2438,14 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		if (tcp_small_queue_check(sk, skb, 0))
 			break;
 
+		/* Argh, we hit an empty skb(), presumably a thread
+		 * is sleeping in sendmsg()/sk_stream_wait_memory().
+		 * We do not want to send a pure-ack packet and have
+		 * a strange looking rtx queue with empty packet(s).
+		 */
+		if (TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq)
+			break;
+
 		if (unlikely(tcp_transmit_skb(sk, skb, 1, gfp)))
 			break;
 
-- 
2.24.1.735.g03f4e72817-goog

