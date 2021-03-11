Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F0337F20
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCKUgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhCKUfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:35:50 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E14C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 18so341602pfo.6
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EM9m5r1jnvP1QElpZ6X50oQX5qBOeqTxmC+ieY+4/Mk=;
        b=R8pCDqfPbu2JdixRvvg6+IRlH7vCwYR5aFZ0yHNvvmphuU0WpeqSq9SC+pmHfKGBK/
         dkQA962ni3RiBcTgGWcQUqFvD3vBZaR+1nbLquQaIMrpVw4OZBPttXd1l5UQVDaQsjyu
         zQH6Ig/x8hySzCWzUEDy0KR8gRzskO2CaWhm+vkjSHIaTF9O3FzPJNxSPiC97OF97bWe
         gGI3jwNfdDjBdEOiewuTuViahUo7rqPTvBWgv/C7k8x2BNCQqpL9nONwRgCva5wnHO6r
         s+t52wz4BOn4TX9A3OWgYP1URdn8MUsy1sQlamtzt2BM7JXJnErsYRGp7CHv685g9k16
         DVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EM9m5r1jnvP1QElpZ6X50oQX5qBOeqTxmC+ieY+4/Mk=;
        b=Xx40Zw77Wz7qBTWs6YGoN7Due4t40XePIr180NSuC7yM6vXlT/3VOiS+Nz4pFrT3os
         9ZvVvj98f0CZycXSxe7GiLubJNpc5FNPkM/9if7Vm6E5MAAG2UyXanuwI1Z2FuHT8kYt
         CbE4wt2OQhFaoZVDQLbMdPuuEfDpFWOVfm7G8iktX0P3N4MuaBTxTa9Db/oFcr2kJNhY
         YTte6mGYhdgKa1J3eEmwdoaAe6jAhlMG7ZKZC/vOsHjAGy4R7NsRKWXSQcJZVZTc7zFP
         68+gsD7Sqp74Ls1PiLQKUB7NwThX+ILvmjNT29IRoduSHhE3NneYZ0pbtRuYgFBjccHO
         b3mg==
X-Gm-Message-State: AOAM531leO4dTMTKqE79sFYaU60WVByem2gU7FS0H6j9cJt3pYokjwiP
        1+8B5QXT323ML3VyJDmsHC2MfNI17ug=
X-Google-Smtp-Source: ABdhPJwadOdHGoT/ygUbfZ8n71Xl0YxIbD2Dmx1ZEpIv/krKn9bKqtgNVQlXnXyWtfWx8K1ND29j7A==
X-Received: by 2002:aa7:9281:0:b029:1ec:48b2:811c with SMTP id j1-20020aa792810000b02901ec48b2811cmr9176269pfa.18.1615494950071;
        Thu, 11 Mar 2021 12:35:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id 25sm3232745pfh.199.2021.03.11.12.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 12:35:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next 1/3] tcp: plug skb_still_in_host_queue() to TSQ
Date:   Thu, 11 Mar 2021 12:35:04 -0800
Message-Id: <20210311203506.3450792-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210311203506.3450792-1-eric.dumazet@gmail.com>
References: <20210311203506.3450792-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Jakub and Neil reported an increase of RTO timers whenever
TX completions are delayed a bit more (by increasing
NIC TX coalescing parameters)

Main issue is that TCP stack has a logic preventing a packet
being retransmit if the prior clone has not yet been
orphaned or freed.

This logic came with commit 1f3279ae0c13 ("tcp: avoid
retransmits of TCP packets hanging in host queues")

Thankfully, in the case skb_still_in_host_queue() detects
the initial clone is still in flight, it can use TSQ logic
that will eventually retry later, at the moment the clone
is freed or orphaned.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Neil Spring <ntspring@fb.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
---
 include/linux/skbuff.h |  2 +-
 net/ipv4/tcp_output.c  | 12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0503c917d77301f433122bf34a659bb855763144..483e89348f78b48235748de37ae3ea7ec9450491 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1140,7 +1140,7 @@ static inline bool skb_fclone_busy(const struct sock *sk,
 
 	return skb->fclone == SKB_FCLONE_ORIG &&
 	       refcount_read(&fclones->fclone_ref) > 1 &&
-	       fclones->skb2.sk == sk;
+	       READ_ONCE(fclones->skb2.sk) == sk;
 }
 
 /**
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fbf140a770d8e21b936369b79abbe9857537acd8..0dbf208a4f2f17c630084e87f4a9a2ad0dc24168 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2775,13 +2775,17 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
  * a packet is still in a qdisc or driver queue.
  * In this case, there is very little point doing a retransmit !
  */
-static bool skb_still_in_host_queue(const struct sock *sk,
+static bool skb_still_in_host_queue(struct sock *sk,
 				    const struct sk_buff *skb)
 {
 	if (unlikely(skb_fclone_busy(sk, skb))) {
-		NET_INC_STATS(sock_net(sk),
-			      LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
-		return true;
+		set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
+		smp_mb__after_atomic();
+		if (skb_fclone_busy(sk, skb)) {
+			NET_INC_STATS(sock_net(sk),
+				      LINUX_MIB_TCPSPURIOUS_RTX_HOSTQUEUES);
+			return true;
+		}
 	}
 	return false;
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

