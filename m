Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDD981A579
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 01:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfEJXA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 19:00:28 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:35294 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfEJXA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 19:00:28 -0400
Received: by mail-pl1-f201.google.com with SMTP id x5so4530674pll.2
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 16:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jco5PLy+8J9k+x4i/mg08hrd7SanJhCfc2NnQwxAQmw=;
        b=abo5SQeO6nBWkT3vkAvcoBbIZcyCDgjlfY0RxKA8d38MINFAVRYz8b2lscPbW0eJXc
         H5+4vcFRCpGBkJ2GdMEUXacsUoR4fLjmnqpJSfplc74hw4gU7UuASmTMLt+N/LKjgjgO
         JgI6Y3306uAjBsBm8G8RNojBeQcch6l+j10ZB23oBeoYlm9SIE23o9d3vF2Q/cPu+ekp
         i5QimYpSIGlh1apd9xMHwH/z88Q2lbOUoh1meRWt5VJLmiAKZSPBiLKq7Sm8FVBnVLrk
         tRT8Gc9TSnZbLEWNZMheQ/YmS2NdMMf+qhkSkBHnq666Lf+DtvTbVlLJW+hz0T7SduF4
         ATSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jco5PLy+8J9k+x4i/mg08hrd7SanJhCfc2NnQwxAQmw=;
        b=ZzHxMu4mpN2c2Brea063Gx2daWpRhEFfaFNmNoqE2leD7Nm6UK10iZ+/UZF0JACRjj
         tk1EoEAVvwbVrtntlE/lWXeBJKSgfEE9+eyuw8UHNYYa7PSUbv999seRs92TDKqrr6nr
         rmnHnULMV6yyS0aoh50C6tSxl5ps25lUhOmo4I/jysm+ZWsXPITM3ZGRETEQil4zovP/
         2fsPTxMganChfMyF1svgShsDpFyh4ajjEYfHJWfDbmSQy45RfKNYomkjBYg5fF6+seXD
         RSTkPHUeOnsH+JmxUVaZuHeLClMqJx1UULcGafqEv6gh4jrkAGDpel8eM6DyKqpvPKKv
         XUHg==
X-Gm-Message-State: APjAAAWANQytMFfZQ+C+eSeZFl2ufxptG3K4A9f/W1b3QAOik3AM46gA
        ylcGMsKhhUshAi+mUc0tYlQrDN5+rkA=
X-Google-Smtp-Source: APXvYqy2rhSIavsNNr5TEe9OYTWE1v+yroR7RPMnxKLeFgO04oX+NbEhw+At73bGfHwjJKER2zev+7oppRw=
X-Received: by 2002:a63:1e4d:: with SMTP id p13mr16696155pgm.125.1557529227309;
 Fri, 10 May 2019 16:00:27 -0700 (PDT)
Date:   Fri, 10 May 2019 16:00:19 -0700
Message-Id: <20190510230019.137937-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] tcp: fix retrans timestamp on passive Fast Open
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3844718c20d0 ("tcp: properly track retry time on
passive Fast Open") sets the start of SYNACK retransmission
time on passive Fast Open in "retrans_stamp". However the
timestamp is not reset upon the handshake has completed. As a
result, future data packet retransmission may not update it in
tcp_retransmit_skb(). This may lead to socket aborting earlier
unexpectedly by retransmits_timed_out() since retrans_stamp remains
the SYNACK rtx time.

This bug only manifests on passive TFO sender that a) suffered
SYNACK timeout and then b) stalls on very first loss recovery. Any
successful loss recovery would reset the timestamp to avoid this
issue.

Fixes: 3844718c20d0 ("tcp: properly track retry time on passive Fast Open")
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 20f6fac5882e..cf69f50855ea 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6024,6 +6024,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 {
 	tcp_try_undo_loss(sk, false);
+
+	/* Reset rtx states to prevent spurious retransmits_timed_out() */
+	tcp_sk(sk)->retrans_stamp = 0;
 	inet_csk(sk)->icsk_retransmits = 0;
 
 	/* Once we leave TCP_SYN_RECV or TCP_FIN_WAIT_1,
-- 
2.21.0.1020.gf2820cf01a-goog

