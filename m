Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF18343567A
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhJTX1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTX1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 19:27:20 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF0BC06161C;
        Wed, 20 Oct 2021 16:25:05 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f5so23860329pgc.12;
        Wed, 20 Oct 2021 16:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieoDA+u+AYvFmFKkyNKGp0HzFWSDaCPjd0PGlhhGXKY=;
        b=aLtS7ImiBgbG3BoYl0Xof4Wv9msZjEAlc6t9nxw+FCeU2ShxbGjDOQlgZyl9YqjiPQ
         ZKUTzxKVoO8mptHpmuTS4y417/BIg/keW97BV+szS2CGipUIN8KRlI2m4/lc3+UF7iw7
         o0hSN+wBkKgLljeF6qgeHTabrfNK5oxF3BdfVykW8JhYs8k4TSLiki1WHHxc9hqreUdC
         oTkt9g5D4rwTfkzHBu1Z3FrU7taoUbgNp3PL8fimlXsluh+mskhD7wSRgT/9uA+sRzcU
         0UFSuE5JNQearMWW/Gs/XRHxMCkT4O3o+Pf4rKQZDFDlLu+TWoVf5ITf8TFxfZzSvFRk
         1MEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieoDA+u+AYvFmFKkyNKGp0HzFWSDaCPjd0PGlhhGXKY=;
        b=AlT7oGoTdAFq1UNH5xCXDVAHPWuw6i6qgb2Vd+32bDi7I86e5OVKrSBLPgyYlHNiSX
         587Ods+R++o+OajvdHYhzibPLaoF7aStG1Tk2jwVP+SgK8dYFZBJbuFlsTich/h4yHPX
         ljg3F10984bQGvDTpqmDVoFz6iUelW6t3S6bDv3NEyKs9WuqFcWioVnd7mILO74ZGX5i
         ObNZ/3n0YbYl35WU4HCHXl4wYtKngrZMULLzkhz0sbKh8/yUSSn+Pq/H6LsgN8Gq26OZ
         qWSO4L8MDAN+T0GKBhLCtp9Zm12UcyrN96mO4uQ5NdjwLpAKoAW+e8QAHvmaYXaGbH2N
         iomg==
X-Gm-Message-State: AOAM532zx9W6iyMfChThW03lh1/rsHUFaUVp8x7+nArEI3EYMLMOgDMh
        KoMhj8sBnxFix7EDuG9+x3MnQw/hpd+Q6QgU
X-Google-Smtp-Source: ABdhPJxfh/hhjgjRMcRGRiebt8SEw8J5S7GO9vRQrWc7zuNxsrZ2lX6chPURASoMqqnEgXLNbjlNeA==
X-Received: by 2002:a63:e446:: with SMTP id i6mr1742997pgk.288.1634772304615;
        Wed, 20 Oct 2021 16:25:04 -0700 (PDT)
Received: from 192-168-1-105.tpgi.com.com (115-64-195-55.static.tpgi.com.au. [115.64.195.55])
        by smtp.gmail.com with ESMTPSA id e12sm3521107pfl.67.2021.10.20.16.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:25:04 -0700 (PDT)
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmaxwell37@gmail.com
Subject: [net-next] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
Date:   Thu, 21 Oct 2021 10:24:47 +1100
Message-Id: <20211020232447.9548-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c2d9830136d2..d2b06d8f0c37 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -938,7 +938,7 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
  */
 void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 {
-	if (skb && !skb->len) {
+	if (skb && !skb->len && !TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
 		tcp_unlink_write_queue(skb, sk);
 		if (tcp_write_queue_empty(sk))
 			tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
-- 
2.27.0

