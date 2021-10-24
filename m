Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8F6438CAD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 01:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhJYABx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 20:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJYABw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 20:01:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42661C061745;
        Sun, 24 Oct 2021 16:59:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id om14so6912302pjb.5;
        Sun, 24 Oct 2021 16:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UdgLpBv9vUiEAI9nTW/FcpPBhUsrQ/P7VYlSz31nv50=;
        b=Gms+8I7iaJEgEXiIv/FGzWD9TR0ORSFGUhDym/fmuiDnyjg4Nt7R5pH4dS+AuS/uK0
         LucW5KThyrVQgzMbntBLB0rljHjolwOGcDA4OF4yeZIAf/LnxyColxJ6Yhotj+TVLkCZ
         dBZ6UA4nPGDVYQAqILTQxevfu3VuZ47sPPRtp6RlOTpyHABB5iqhcJCoKlPM6+xbeTOH
         gUZDpyVykiWrV3mfYLJUlmYrflwLVs823wQ/CzQoMLb+2R7wpT6COOt4C0TVyE0siLD4
         ksqG9ZHMhWzcMRPlDNNkdGTvay02HvnJdJJUcuc9Xok1GRXWIDCU73/DsiiziWLTQAHK
         NUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UdgLpBv9vUiEAI9nTW/FcpPBhUsrQ/P7VYlSz31nv50=;
        b=LUeYU7WdC2HuLg9sXXzQ15M4YUMf0N8mr9X4kSEQ8hw6Zgk06f7REZYzA4iKMFiQzz
         emsuXmnWj45vMDA9L3Yi/yf6MVHe+EtT2V3vugj8jz2ZRZOl0RCmZi27AJrrf042HVNC
         J5YFt9tJX+5DL+kxU8uKtefL4apLUfqTjdmKne4Sb3iyrufDon82Nl6JF+r0JyOqVYKw
         d6cA1g4Q/8qNS8oCovWVLs2Et+DCwId7WHqvBcZcfmGPoIURq2KmstYY0MQYNVB3EKNr
         HlRJdD+scH30ST1heF9TxQ4xk7n/yyBNM7V9p5BxDtYHPIFR1FZWYiOsJMX0SJ61ABIc
         J+MQ==
X-Gm-Message-State: AOAM533GWP9kj6mBUNqp/XWGFNNheJvbrc8IRSxNXXvm5ZY7jG6Igoxq
        jMTg3LNe2HB+LEhdO97qn5U=
X-Google-Smtp-Source: ABdhPJyqH14nH/Dlyi7vBdkZc8TyTinpzmNMw6iyZIloODpmX5/zNdd5vQRMlLSCiVxKpZc8PlBasg==
X-Received: by 2002:a17:90a:1485:: with SMTP id k5mr18901264pja.74.1635119970599;
        Sun, 24 Oct 2021 16:59:30 -0700 (PDT)
Received: from 192-168-1-105.tpgi.com.com (115-64-195-55.static.tpgi.com.au. [115.64.195.55])
        by smtp.gmail.com with ESMTPSA id d19sm17104677pfl.129.2021.10.24.16.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 16:59:29 -0700 (PDT)
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmaxwell37@gmail.com
Subject: [net-next v1] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
Date:   Mon, 25 Oct 2021 10:59:03 +1100
Message-Id: <20211024235903.371430-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1: Implement a more general statement as recommended by Eric Dumazet. The 
sequence number will be advanced, so this check will fix the FIN case and 
other cases. 

A customer reported sockets stuck in the CLOSING state. A Vmcore revealed that 
the write_queue was not empty as determined by tcp_write_queue_empty() but the 
sk_buff containing the FIN flag had been freed and the socket was zombied in 
that state. Corresponding pcaps show no FIN from the Linux kernel on the wire.

Some instrumentation was added to the kernel and it was found that there is a 
timing window where tcp_sendmsg() can run after tcp_send_fin().

tcp_sendmsg() will hit an error, for example:

1269 ▹       if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))↩
1270 ▹       ▹       goto do_error;↩

tcp_remove_empty_skb() will then free the FIN sk_buff as "skb->len == 0". The
TCP socket is now wedged in the FIN-WAIT-1 state because the FIN is never sent.

If the other side sends a FIN packet the socket will transition to CLOSING and
remain that way until the system is rebooted.

Fix this by checking for the FIN flag in the sk_buff and don't free it if that 
is the case. Testing confirmed that fixed the issue.

Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cases")
Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
Reported-by: Monir Zouaoui <Monir.Zouaoui@mail.schwarz>
Reported-by: Simon Stier <simon.stier@mail.schwarz>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c2d9830136d2..56ff7c746f88 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -938,7 +938,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  */
 void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
-	if (skb && !skb->len) {
+	if (skb && TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		tcp_unlink_write_queue(skb, sk);
 		if (tcp_write_queue_empty(sk))
 			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
-- 
2.27.0

