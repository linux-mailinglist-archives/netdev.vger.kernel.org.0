Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02EC3BC22F
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhGERVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGERVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 13:21:19 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1D9C061574;
        Mon,  5 Jul 2021 10:18:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id y17so18846003pgf.12;
        Mon, 05 Jul 2021 10:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8AsOPg4uvziFNGy4LwJbOa0Julbheb6cKC2U9CBvyi8=;
        b=upNQc2CcpFBftWiYE6Px2uScC9wQC67aHGAdWpMcWEUpbU+a9XaRFECmqLlUbxDM9m
         uP6wB+P6LsRPHlGn+k4pZtEx/R5+oTlbl9Y5VF+a+fyos7kwxCm1RD6yNutR/P+IFiyn
         4TGigeKDNE6KCBnH0PfR8LpOW/uYhBUny3CcQHmODyuZUa9qM9X8QugLAl6UD5X1TtJF
         y+V8mD9x/ciCVuqqzYAFx8AV2J0iD/3vJM9wnDGBICaRyRmFCweTbkkINDU3NHDEltzg
         /lFSS53bYMQvFfxyeTuvBxa3aIw7FBn1DwzjRersxWRKyJOiQxFhofUjqX/pOvZMpCja
         ELSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8AsOPg4uvziFNGy4LwJbOa0Julbheb6cKC2U9CBvyi8=;
        b=IJFRBLW/3N1ke0IGS+5sG8PGK9DdeLG8lYvOY/EjwI9POLaVQzk9Qm1uU6ewjec3Xq
         cAaq3WJ3sF116/aDy+UtG0O9WSlwJzs47DO309Pl3VKUCxpee0GVyJ6hCKBBFhtXZ5/Y
         vBs8USkwPogJ/BT1BFaPvuKtM4TbEwiDhEvNTXn8Aw8Xqi93OxWZais0FV30K2OJek8i
         zu17o+/Rt9bkjdZpLJdwV6uzSbOpS5S79m0pdlOlWNQmvCeYoEpX4tPBKrophVwL1/Vu
         C49N+S90cnrnZuq9lnbDE0QCqSE+ZSFNsgNo7b6j+FAQHNLhgDvbpk2xcGr1nUoITnB8
         b5gQ==
X-Gm-Message-State: AOAM530QoCH73oe+PEekuxnUy8SIoToSxzuzapuphu48lUEaufGFgSJR
        9TdQ0IZizrIhdgEQ+gfYjUo=
X-Google-Smtp-Source: ABdhPJxs/nY4JyPTwoilJvNPBltEPhPrGuUa2VABDHNtmXi9TLeDaL/dlTprvVj8RoPbhY9AglqMcQ==
X-Received: by 2002:a63:e214:: with SMTP id q20mr15107616pgh.437.1625505521847;
        Mon, 05 Jul 2021 10:18:41 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id w123sm14059300pff.152.2021.07.05.10.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 10:18:41 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     yhs@fb.com, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, ycheng@google.com, ncardwell@google.com,
        yyd@google.com
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Subject: [PATCH v5] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
Date:   Tue,  6 Jul 2021 01:18:23 +0800
Message-Id: <20210705171823.524171-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes a bug (found by syzkaller) that could cause spurious
double-initializations for congestion control modules, which could cause
memory leaks orother problems for congestion control modules (like CDG)
that allocate memory in their init functions.

The buggy scenario constructed by syzkaller was something like:

(1) create a TCP socket
(2) initiate a TFO connect via sendto()
(3) while socket is in TCP_SYN_SENT, call setsockopt(TCP_CONGESTION),
    which calls:
       tcp_set_congestion_control() ->
         tcp_reinit_congestion_control() ->
           tcp_init_congestion_control()
(4) receive ACK, connection is established, call tcp_init_transfer(),
    set icsk_ca_initialized=0 (without first calling cc->release()),
    call tcp_init_congestion_control() again.

Note that in this sequence tcp_init_congestion_control() is called
twice without a cc->release() call in between. Thus, for CC modules
that allocate memory in their init() function, e.g, CDG, a memory leak
may occur. The syzkaller tool managed to find a reproducer that
triggered such a leak in CDG.

The bug was introduced when that commit 8919a9b31eb4 ("tcp: Only init
congestion control if not initialized already")
introduced icsk_ca_initialized and set icsk_ca_initialized to 0 in
tcp_init_transfer(), missing the possibility for a sequence like the
one above, where a process could call setsockopt(TCP_CONGESTION) in
state TCP_SYN_SENT (i.e. after the connect() or TFO open sendmsg()),
which would call tcp_init_congestion_control(). It did not intend to
reset any initialization that the user had already explicitly made;
it just missed the possibility of that particular sequence (which
syzkaller managed to find).

Fixes: 8919a9b31eb4 (tcp: Only init congestion control if not initialized already)
Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
V2:     - Modify the Subject line.
        - Adjust the commit message.
        - Add Fixes: tag.
V3:     - Fix netdev/verify_fixes format error.
V4:     - Add blamed authors to receiver list.
V5:	- Add comment about the congestion control initialization.
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7d5e59f688de..84c70843b404 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5922,8 +5922,8 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp = tcp_jiffies32;

-	icsk->icsk_ca_initialized = 0;
 	bpf_skops_established(sk, bpf_op, skb);
+	/* Initialize congestion control unless BPF initialized it already: */
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
--
2.25.1

