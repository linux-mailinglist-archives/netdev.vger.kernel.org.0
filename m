Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C7514F258
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgAaSoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:44:55 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:55961 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgAaSoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:44:54 -0500
Received: by mail-pl1-f201.google.com with SMTP id w11so4141826plp.22
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AjAkTNDr2233p2IsU1c1Ora2GqPHuxW+c5h75hAiFoc=;
        b=HXXuenkS5xKpaexlcbBPT0AuH2ta2sxOlWPTKsr5DGl1eR2n4hA9lQssUCBTNd18do
         XQcNa+ljVC97HYRuBP3gMjkmjPdokp+i6kvYi86HkXMlQFAbtXBCr2deCsTIWS5Daznk
         RUl4m3ehNJ97K2xQy7GszXdIBXOeu29iIncWeGgZSbbJStc5/yAAz/K/GkvywQRV9xoU
         gpZIlAmaXtKS23i6ZCN5Uyv9SEBw956Kww6GdgaABCg8imi81zq6NTOOm9mUMWqR3cT/
         INHbaX+EZzCnr46xinar3UzXAxQ8OGi5X9+yrjw6KSvzwiiq56+jgjRP9yamTWlTfQjE
         HUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AjAkTNDr2233p2IsU1c1Ora2GqPHuxW+c5h75hAiFoc=;
        b=dPHQeFlYWHC6UobMxReSH7TIMdGaLM74JLPIEq2+g3s4xEsQOhN5Lywq3U2r+R/2Z7
         EuSvecCgvRvotrHZAZmxHuZ9TfMhBrrq6ovwUgmvUsXz5LosIBYZW5eC8w/yg3B1BtW/
         GqyIUFt436CJSpeinifsZfnhjDML+PJKC1ThoCVpd1uH8jlndSLmxN1Z6Ai1zjMl+tMd
         v109vitRxsloCjD3fQetd3GycREZlQ78u8Nc3Rii27V4t33PYm8jjmgyl6W2+Jl4BCE8
         t5u6PP+3g5PE+6ho1xIPVdUlmp+P4u8Utr6We/eDEpmPUJ+QyaMMHF7rrQ8hj+SscNpH
         IfPQ==
X-Gm-Message-State: APjAAAXl1l89JqRswgoHjDdAeSVJx+2kxrvPwHi7NJMJG22jbwAZG9YH
        dBzR+sYESIMqhrOM/HTlVOROr20o+1OdZQ==
X-Google-Smtp-Source: APXvYqx9Kyb3XvBAXk/BJ+xpgFiobw0qEqdlhNQQlf/dQVvUqqfcEMxvCC7SycuSv3RtX+H8xvT0a8wnoxRFbA==
X-Received: by 2002:a63:7843:: with SMTP id t64mr11668261pgc.144.1580496294137;
 Fri, 31 Jan 2020 10:44:54 -0800 (PST)
Date:   Fri, 31 Jan 2020 10:44:50 -0800
Message-Id: <20200131184450.159417-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] tcp: clear tp->segs_{in|out} in tcp_disconnect()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp->segs_in and tp->segs_out need to be cleared in tcp_disconnect().

tcp_disconnect() is rarely used, but it is worth fixing it.

Fixes: 2efd055c53c0 ("tcp: add tcpi_segs_in and tcpi_segs_out to tcp_info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3b601823f69a93dd20f9a4876945a87cd2196dc9..eb2d80519f8e5ad165ca3b8acef2b10bdf8b7345 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2639,6 +2639,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	sk->sk_rx_dst = NULL;
 	tcp_saved_syn_free(tp);
 	tp->compressed_ack = 0;
+	tp->segs_in = 0;
+	tp->segs_out = 0;
 	tp->bytes_sent = 0;
 	tp->bytes_acked = 0;
 	tp->bytes_received = 0;
-- 
2.25.0.341.g760bfbb309-goog

