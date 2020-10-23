Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B21E297617
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 19:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753823AbgJWRtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 13:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462542AbgJWRtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 13:49:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D744CC0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 10:49:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w21so1914749pfc.7
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 10:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aV6QdPRmZdiaIywzMHVh9a9OFu0naPJhaN7MVBrt6Zk=;
        b=rlRYT7G66Se3Zs9EG6j4d0m3AG6IMEO0jzodI46JqSIhgaTimGhtvxfrMi2VfRamYm
         YiR0weCnfv92Lmf4QVZ4S/r8OhyfhmnIjP7x3koRyQzme6tBEXVRsMXtRxV2g4OvhTKU
         dfqC7P9uvxU8ao+mKQP+EvNF2orQcwFaQfRwB0qwgiIzlL6NHeTz0fB8zLwS9DTJM5Mb
         420azfRfH9qh0XyUCjCTPkStdmmA6xyobPPs9UAQ+WibOa9hdN+opDOpGDXWCiqSAKE9
         qB/kfpsURutS1M5rHCMLScEEs8Db1UB6fCgpqDPLPtX5Pwv19mjCHbUFzXcnnytqPzL4
         ZT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aV6QdPRmZdiaIywzMHVh9a9OFu0naPJhaN7MVBrt6Zk=;
        b=GGoaSYud5kCfsa0ihtn8u9bp3ZEr4Qz394M36PwdODjGA6hq/FylbWE8ttmrZ3I/p0
         DJouHZRkjzU1xa44PdDk1NsxTj6nL5uVJ1/6Q+DHCq90hK1H77JeQrUiuPYu66LOtL2O
         p9cjJMb2PJSF24Gko8bJ6KNp13TeDxIH6rV7cccmmr38iPTdwkwZ1IVOJL0Et6JPjqxn
         Qeq3TyYcq+kSnWDr5b3C+shdlfS1DXDKwzQZSih8IC1huwLy8vV8P+21o2ygvFEHVHTp
         SNP11EEb2fsmeNzVspbLYhWmOpVPP/tOcGTkU+hWKZ5fpIM/JlUWT3bVLLTZM4OBgxSn
         zEDg==
X-Gm-Message-State: AOAM533O264iROC/jzydsO7nGJO4FtPtFI81e6BnGiXrGy9psTUMnGPy
        o4UDEd41/Y+3ht3YDkxgjGnlAyPEXpA=
X-Google-Smtp-Source: ABdhPJzV/tSK8Xxkdgcmnjt70RADve4wGoo717321iZEURNHG88sqwZItwcTnkJE90Xd1bh92H/NVQ==
X-Received: by 2002:a65:508a:: with SMTP id r10mr3067751pgp.307.1603475355304;
        Fri, 23 Oct 2020 10:49:15 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id b6sm3060679pjq.42.2020.10.23.10.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 10:49:14 -0700 (PDT)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        ncardwell@google.com
Subject: [net] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
Date:   Fri, 23 Oct 2020 10:48:57 -0700
Message-Id: <20201023174856.200394-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

With SO_RCVLOWAT, under memory pressure,
it is possible to enter a state where:

1. We have not received enough bytes to satisfy SO_RCVLOWAT.
2. We have not entered buffer pressure (see tcp_rmem_pressure()).
3. But, we do not have enough buffer space to accept more packets.

In this case, we advertise 0 rwnd (due to #3) but the application does
not drain the receive queue (no wakeup because of #1 and #2) so the
flow stalls.

Modify the heuristic for SO_RCVLOWAT so that, if we are advertising
rwnd<=rcv_mss, force a wakeup to prevent a stall.

Without this patch, setting tcp_rmem to 6143 and disabling TCP
autotune causes a stalled flow. With this patch, no stall occurs. This
is with RPC-style traffic with large messages.

Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>

---
 net/ipv4/tcp.c       | 2 ++
 net/ipv4/tcp_input.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index de19af65bc70..f605cf87b9be 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -521,6 +521,8 @@ static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 			return true;
 		if (tcp_rmem_pressure(sk))
 			return true;
+		if (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss)
+			return true;
 	}
 	if (sk->sk_prot->stream_memory_read)
 		return sk->sk_prot->stream_memory_read(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d285d67c0ef2..30b450ebaae0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5294,7 +5294,8 @@ void tcp_data_ready(struct sock *sk)
 	int avail = tp->rcv_nxt - tp->copied_seq;
 
 	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
-	    !sock_flag(sk, SOCK_DONE))
+	    !sock_flag(sk, SOCK_DONE) &&
+	    tcp_receive_window(tp) > inet_csk(sk)->icsk_ack.rcv_mss)
 		return;
 
 	DIRECT_CALL(sock, sk_data_ready, sk->sk_data_ready, sk);
-- 
2.29.0.rc2.309.g374f81d7ae-goog

