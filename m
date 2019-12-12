Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7278111D832
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbfLLUzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:55:50 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:45406 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfLLUzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 15:55:50 -0500
Received: by mail-pl1-f201.google.com with SMTP id b8so1345085plz.12
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 12:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wNBMoZn5iwsjfwv4pTpwB3l+ScgfwaZHacHZoyQcDKE=;
        b=HW6FH4F2IbhgoalDzRIu78flDY6tCrnzVhovLq9TXcv1gs8JsBZyW7zWpndaLTMtQZ
         OmqSMxdcPiOAWB7BoGXhfRoyKItt3+PfwL4xtLmiNw2Sv2YVWQcwDCBj0vvgRW+O2EdY
         6ZYUopMQpHlsQy3nCd3FMUVpgtFFXQgxEcGmQHDY0mIo/ieH53sMXK7dlMOWzGU64e+F
         1tM2gJ0iyPjOPaivj5MndhfXLg7ykg0DsiPSiYyniEPr1QOvOgi+cE3f8jBii80MdnO5
         Qi/lsqqNNz63l8qwaBuo9ymsUFcvB3/+qGMxyw6r2rbudmhNshZNLT5vzEFm1cnykow2
         Q0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wNBMoZn5iwsjfwv4pTpwB3l+ScgfwaZHacHZoyQcDKE=;
        b=Ilmp6cw6cKrl5Kq5hkjwnlLYJ/47kXd+65UImnNFjnrMrIkgKti5dETX35V4K35WWy
         f8fGttjC+GSc25mdmxTAyJNsATFH2Lsgxo45NEccxA/Xy6J01svXrjm9rfOet0C/8Tgh
         LHNlToYbuhUm+IPshxBvw1d9ZThb9L+wwDsQC3oe3Ob+B6a60cEgTFwRvSa1AJqeyH4R
         c7tIgB5ZRTdOAxG6THD+L5N/U03UCgP8MCpt3z807LkLZiK+gbP3JMMC7+V4D6UTQdb8
         149WOTEY7lCKwK7Kmj6lIV26HYf9pQuC3OmLRzirPbmVOMj5NlryKNkDh90RYqUq4aGP
         TRxA==
X-Gm-Message-State: APjAAAUANeGkDfBlHszx13vRG8M8yO1MprEea4bBnECUAhEXZ0behCAz
        grh048zeuKoIgndAaidYoRa7tUMBCStwzg==
X-Google-Smtp-Source: APXvYqyImeanmfLETH99i+tFEHm7L9ck6Nazhh4vxTs+fbbdTg7X/vsvMbZfdMWMp+AhSBSLWSYbS0SfGaeUQQ==
X-Received: by 2002:a65:644b:: with SMTP id s11mr12514383pgv.332.1576184149535;
 Thu, 12 Dec 2019 12:55:49 -0800 (PST)
Date:   Thu, 12 Dec 2019 12:55:31 -0800
In-Reply-To: <20191212205531.213908-1-edumazet@google.com>
Message-Id: <20191212205531.213908-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191212205531.213908-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 3/3] tcp: refine rule to allow EPOLLOUT generation under
 mem pressure
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the time commit ce5ec440994b ("tcp: ensure epoll edge trigger
wakeup when write queue is empty") was added to the kernel,
we still had a single write queue, combining rtx and write queues.

Once we moved the rtx queue into a separate rb-tree, testing
if sk_write_queue is empty has been suboptimal.

Indeed, if we have packets in the rtx queue, we probably want
to delay the EPOLLOUT generation at the time incoming packets
will free them, making room, but more importantly avoiding
flooding application with EPOLLOUT events.

Solution is to use tcp_rtx_and_write_queues_empty() helper.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8a39ee79489192c02385aaadc8d1ae969fb55d23..716938313a32534f312c6b90f66ff7870177b4a5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1087,8 +1087,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		goto out;
 out_err:
 	/* make sure we wake any epoll edge trigger waiter */
-	if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
-		     err == -EAGAIN)) {
+	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
 		sk->sk_write_space(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
@@ -1419,8 +1418,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	sock_zerocopy_put_abort(uarg, true);
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
-	if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
-		     err == -EAGAIN)) {
+	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
 		sk->sk_write_space(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
-- 
2.24.1.735.g03f4e72817-goog

