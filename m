Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3120EB38
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 04:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgF3CBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 22:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgF3CBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 22:01:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC92CC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 19:01:36 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k186so697139pgd.0
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 19:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f6s3+N/l/0WDWgpGCsMT7CS1cyhKwDX+i+e3H53/NZM=;
        b=LNo4xNXX5SB3XJISmo8hPXGRZxgjTFMarzQ8kCsx+2u9Wk3UfeyspSEZTfg6r9hgQe
         /yWySpgKFpazbvHhkqjl0jcNE0fdky2s02SfkpieStmCBSGM8v/r2BjHPohP60BgQyRJ
         H/jCmFYwwbMnU33TCY5wXleSLP/hQfhpLx5fpmb+D1rxYIm5coZjKYQNcFygUpVYTQ+8
         jPKb+65LizZFd+MZOZMny9ZkpK0lZ5uKQN6ogkvcpFJislTNxLrWeJPObM4202yr4M7j
         BCrGn0gLX9pg7Hk6Rbpi8h2XP1lR6asx56SYnD74LCbCwcHsKSNiWzhjb/r6FgFyTNIA
         CHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f6s3+N/l/0WDWgpGCsMT7CS1cyhKwDX+i+e3H53/NZM=;
        b=deo7rf78ZQcsryQHASnr4S7NxKOO3ZV99qjEIu54U17PDr7TVeVn6MUV9f4/c96oX7
         PLtdGo8kY6K7/BbImcT6GhrcOIybwDbnY81QfsacDvDu2yteVRmd1uVV1YW5KrKgWVj8
         6yerih+j9AocygV1DScmNeigBBIj6wasLEGQ8GktGwb9h75cWOV56F38oqu3AAareYJn
         /9FXX2Nra9lt81C8ThTAmMwav7jlNgJQmQFtQoy7/88RPlnS04ORDaC/Ui1dDPcoCI1v
         JzZtqs+v1zxADPMfwthdiT02md6KK+app7YxjC5bQGHc+7se80Xt3se7PmHN9yy5ZZDl
         4gsQ==
X-Gm-Message-State: AOAM531NyAGqFPXREeh6hqyWI2ZEhIGeYbChwdxHzjU3zILT3LovTIS2
        4ASFEuodBi0UZ8h2SMfdvTMuo2kb4USp
X-Google-Smtp-Source: ABdhPJzCPyph4t3rTCmtmFMOoHBXalKCKdUAnE4hIAYzsaxRU2yOuVE9dYk8RzazctH0y70bnZpR3C+HMofB
X-Received: by 2002:a05:6a00:148c:: with SMTP id v12mr16632789pfu.171.1593482496248;
 Mon, 29 Jun 2020 19:01:36 -0700 (PDT)
Date:   Mon, 29 Jun 2020 19:01:32 -0700
Message-Id: <20200630020132.2332374-1-ysseung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next] tcp: call tcp_ack_tstamp() when not fully acked
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When skb is coalesced tcp_ack_tstamp() still needs to be called when not
fully acked in tcp_clean_rtx_queue(), otherwise SCM_TSTAMP_ACK
timestamps may never be fired. Since the original patch series had
dependent commits, this patch fixes the issue instead of reverting by
restoring calls to tcp_ack_tstamp() when skb is not fully acked.

Fixes: fdb7eb21ddd3 ("tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue())
Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_input.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8479b84f0a7f..12c26c9565b7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3172,8 +3172,11 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 	if (likely(between(tp->snd_up, prior_snd_una, tp->snd_una)))
 		tp->snd_up = tp->snd_una;
 
-	if (skb && (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
-		flag |= FLAG_SACK_RENEGING;
+	if (skb) {
+		tcp_ack_tstamp(sk, skb, prior_snd_una);
+		if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
+			flag |= FLAG_SACK_RENEGING;
+	}
 
 	if (likely(first_ackt) && !(flag & FLAG_RETRANS_DATA_ACKED)) {
 		seq_rtt_us = tcp_stamp_us_delta(tp->tcp_mstamp, first_ackt);
-- 
2.27.0.212.ge8ba1cc988-goog

