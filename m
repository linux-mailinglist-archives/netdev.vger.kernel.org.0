Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16E6297735
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755040AbgJWSrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465814AbgJWSrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:47:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA041C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 11:47:19 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 126so1630613pfu.4
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T2gwB+ITVXwkroQsi3Dg+i4xxr0YYvDubx8MDP+8X7U=;
        b=ieHpvsSlgGKZnLdZe7aELBsB+xECFhGo3pUOns8fR0+omyglnGYXsIq7jPppXglPpD
         fSOT3Yokjw9EyIsntUf4QHIeXTckc+cYSHm+4izJiJEQyhnF7mHTOVplqzW2qEQVLozk
         YEdwDB4Vby01B7EcYNF+S7Z+z9UuBZxs7OBT68xIgjp8DzyLMT/9jiBlvyZDBYz+Ds+0
         jydePMZ6Z7CvQ0UhAckGbv0U26kliFDuN9pst32saBjxP/DBfVzZb8V9ig0KllxuLn/f
         B5J2KviY/fpQ+J+gj9SLuDm6k6749FqLWVtAJm8czZcViGEyVE5nzTgWazYkXWKdAE8F
         EzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T2gwB+ITVXwkroQsi3Dg+i4xxr0YYvDubx8MDP+8X7U=;
        b=F9x2j6LNSGY3SdGckj5NCDiyUz8uM9qd/661sENlSpy8WuDnR5dJVFXqulG3VkbQ+p
         vk0hfnTdszWYHVp8DkWPpo5oHOsO9zwHTfBtDMJ6ry1WoZ88N9kNnC96mDmRhr8uYQY5
         BPKnuvV2yk8ARYaBaq9QSmvk+pKSg1V5oR8Pz4cmo5YQK2gSZEzyqz4495EFGW5d80am
         k9iDwja2Wbl5sK1GXPQkDoP/j4k30pgzsw+Jy+eQMBrD4s1yX3j2dYsGgQaA5HZG5isx
         dYMISI/DlE2w8YuYzm86EVu2cRD6iCKRJSe2gUI3fsVadSpQlXPxMIIWebf4Q5A5/4XK
         GvBA==
X-Gm-Message-State: AOAM530woyILKktoB98+ARrWLTigU28DHYqSiFxzvoUX4T90pIO/787i
        HnICeYnrAz+ALZgT+NQEezY=
X-Google-Smtp-Source: ABdhPJyhPZ6idaPP/T56yqDyqdAlnSQA7Ce3zRTStDHjNrry/k4ImMGd8OYDpbijHW+lrCMYa7qwQw==
X-Received: by 2002:a17:90a:7188:: with SMTP id i8mr4177655pjk.76.1603478839417;
        Fri, 23 Oct 2020 11:47:19 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id h21sm2644405pgi.88.2020.10.23.11.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:47:19 -0700 (PDT)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        ncardwell@google.com
Subject: [net v2] tcp: Prevent low rmem stalls with SO_RCVLOWAT.
Date:   Fri, 23 Oct 2020 11:47:09 -0700
Message-Id: <20201023184709.217614-1-arjunroy.kdev@gmail.com>
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
index bae4284bf542..b2bc3d7fe9e8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -485,6 +485,8 @@ static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 			return true;
 		if (tcp_rmem_pressure(sk))
 			return true;
+		if (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss)
+			return true;
 	}
 	if (sk->sk_prot->stream_memory_read)
 		return sk->sk_prot->stream_memory_read(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index fc445833b5e5..389d1b340248 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4908,7 +4908,8 @@ void tcp_data_ready(struct sock *sk)
 	int avail = tp->rcv_nxt - tp->copied_seq;
 
 	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
-	    !sock_flag(sk, SOCK_DONE))
+	    !sock_flag(sk, SOCK_DONE) &&
+	    tcp_receive_window(tp) > inet_csk(sk)->icsk_ack.rcv_mss)
 		return;
 
 	sk->sk_data_ready(sk);
-- 
2.29.0.rc2.309.g374f81d7ae-goog

