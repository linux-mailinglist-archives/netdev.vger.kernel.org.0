Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EA42D2F59
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729667AbgLHQWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgLHQWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 11:22:16 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F47C061793
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 08:21:36 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 69so4747897pgg.8
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 08:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YGQYij9I5NODaVylR3JxP0AXZQFLt6q3/K8z5SAOXLA=;
        b=qoyRRCTKp3Ce+VLsxU3SleCEA2bLf4MXJH7tDExdrtcuYvSqUGWGTpjAea7LqLtd4f
         XT3AGMB0b+tsfmkNDM+s3mbD+dC7gXelLMqJC0PJuftuFyY4CZ6Yc0hlvjqjpBPanoBW
         7/lDwVGtyoWXinR77Zuna9HJU+s43xR2UqGtS1VVJftHzxGulwHSWxtWugUjPFPzbc2r
         1bpfArOccv1uWKHY5Kh0ZebENkBsvcFtzmEXqqCnIF2mUkZFGUhqfOievcbIimXR03Gn
         SrXK2E6f/TS1sIdXKDZCcy4clkVgXnwDkIdXTRmv5fUTZHgZ0pbSgeqKqEx2KqswxpHb
         XfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YGQYij9I5NODaVylR3JxP0AXZQFLt6q3/K8z5SAOXLA=;
        b=Yzytw44utwVPMA64HNDOqdTqm5+kCxh5wErESJmhBncaMyB4xMxs02dlL9OCIuQtwK
         +rJHPtUkpQlmCx2GDnX3OEWmvqtS6i+aGxzIiEQ72JPi/CjfzIxTUZxwclcwuiLuEiIa
         3aEbGHFMUgxFdBjePGM5rlo/zw9YRUs25tm1BgAR/HF+M6hmKGmxr8g/LtBwjTAzpuUe
         UM9LX03cSVMESfwCGsYn/Uu6lFhn7mutEYuZ7febvfdNiFZtpnUk/sAMk8V5WSlr4m8a
         QApb1l7ocbWV+fWUMV2HkodV0TmisZRTKx9KrEpHgby5AidpC8Z+ZrBMHr31VaXqK8vR
         kPJQ==
X-Gm-Message-State: AOAM532UOIy6VUTYZ8jgX2IFYe3/NADhILCXBaaS2nXgn912vOAc8VN5
        PNyzd4SSzxXJ3x/QTZ+AOymBBzeUJ70=
X-Google-Smtp-Source: ABdhPJwilUXYV5ldv5WNxowrt95vz4tRQPyLYwBt6JX9x7AEjKFWIn89hQ5P3R5cHp85hjGV4wsv6w==
X-Received: by 2002:a63:6207:: with SMTP id w7mr9217674pgb.164.1607444496167;
        Tue, 08 Dec 2020 08:21:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id j14sm7110350pfi.3.2020.12.08.08.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 08:21:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Subject: [PATCH net] tcp: select sane initial rcvq_space.space for big MSS
Date:   Tue,  8 Dec 2020 08:21:31 -0800
Message-Id: <20201208162131.313635-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Before commit a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
small tcp_rmem[1] values were overridden by tcp_fixup_rcvbuf() to accommodate various MSS.

This is no longer the case, and Hazem Mohamed Abuelfotoh reported
that DRS would not work for MTU 9000 endpoints receiving regular (1500 bytes) frames.

Root cause is that tcp_init_buffer_space() uses tp->rcv_wnd for upper limit
of rcvq_space.space computation, while it can select later a smaller
value for tp->rcv_ssthresh and tp->window_clamp.

ss -temoi on receiver would show :

skmem:(r0,rb131072,t0,tb46080,f0,w0,o0,bl0,d0) rcv_space:62496 rcv_ssthresh:56596

This means that TCP can not increase its window in tcp_grow_window(),
and that DRS can never kick.

Fix this by making sure that rcvq_space.space is not bigger than number of bytes
that can be held in TCP receive queue.

People unable/unwilling to change their kernel can work around this issue by
selecting a bigger tcp_rmem[1] value as in :

echo "4096 196608 6291456" >/proc/sys/net/ipv4/tcp_rmem

Based on an initial report and patch from Hazem Mohamed Abuelfotoh
 https://lore.kernel.org/netdev/20201204180622.14285-1-abuehaze@amazon.com/

Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 389d1b34024854a9bdcbe861d4820d1bfb495e24..ef4bdb038a4bbbd949868a01dc855bba0e90b9ca 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -510,7 +510,6 @@ static void tcp_init_buffer_space(struct sock *sk)
 	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
 		tcp_sndbuf_expand(sk);
 
-	tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
 	tcp_mstamp_refresh(tp);
 	tp->rcvq_space.time = tp->tcp_mstamp;
 	tp->rcvq_space.seq = tp->copied_seq;
@@ -534,6 +533,8 @@ static void tcp_init_buffer_space(struct sock *sk)
 
 	tp->rcv_ssthresh = min(tp->rcv_ssthresh, tp->window_clamp);
 	tp->snd_cwnd_stamp = tcp_jiffies32;
+	tp->rcvq_space.space = min3(tp->rcv_ssthresh, tp->rcv_wnd,
+				    (u32)TCP_INIT_CWND * tp->advmss);
 }
 
 /* 4. Recalculate window clamp after socket hit its memory bounds. */
-- 
2.29.2.576.ga3fc446d84-goog

