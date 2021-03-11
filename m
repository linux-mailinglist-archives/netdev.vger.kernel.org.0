Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF94F337F21
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhCKUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhCKUfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:35:53 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C19C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:53 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q5so1762334pgk.5
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 12:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xXyWNZ0PgxUeV/fSkM7g3dWQRQWscdwMGs9fFM2ZZzY=;
        b=XOYkC3egtbvg+RnRkDZVqC16nIPjvXWcrs9fPgeba22gI+3NPKaNUAX1zgqDho+CJY
         MPdUUz2RfVhinhun3pf8voFD+T5Bx2wtGFkrgVPoikUi97WI8rXbyKNgXOUbAYmyDXur
         pvQxV4+ZBRmqZD8DupSrvonctLzJJntiYmX5uzJGEDEHXmY0EfpmbkYrMbkHcjCu+BKe
         CROYJYMhaAcrhVAe0rNlFjbS6laIUVWvTWsOTz+K8XTZ+MfNfpgSlzGgCWApKWb/bFgt
         16oGwHEGvGd9znS7CGUKjomi7C6KGtq1mdfMWpk4cfI9Ee3wA9sPLZcltBj9LtGv4hWP
         d3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xXyWNZ0PgxUeV/fSkM7g3dWQRQWscdwMGs9fFM2ZZzY=;
        b=MEh33VKnqJcKnasX4fpSgtBNFlPEbC3TMMyekYpXkfHZ2/+ZuIyf+lFNfdbfjAFMCv
         LUaVq4X3kMdPdqKfQps4htmycUPGHr5hThRWTl0fQHkz81Io8nEdDWkdxUD8oBo3VRum
         EkWtQ9W4g2mCfXsf0SbyP9Y+7kMzPXUa4X8vO6wmVqCB+QeXpqYosCvooFX4op+NdAWW
         zyMCoS3Z+tSQhtZea3CxS6QeIgnJQ1VQt5PapO33RM475ltHRkYsI+o3wb3LBcA6S15t
         yUUevWxG5Irp56+tckNoyBbPvUxREx086xbw8rabMjuPHYI+MGu0Je9vhmn27zTx7NTS
         NEaw==
X-Gm-Message-State: AOAM532swEXINmIU3oiAYrzDa2GMlZABfosff+vh0U6zEjO/CMk6QLcI
        rOI/wFiKWhwJGu/SfKusTx4=
X-Google-Smtp-Source: ABdhPJzpnPJXwngsBmYFpASkG3ie8LEIl0ak6V7UM37bM9hETYA6XOhHkn+6G0K/z2dHJRUHbvbhbQ==
X-Received: by 2002:a62:3c4:0:b029:1ee:9771:2621 with SMTP id 187-20020a6203c40000b02901ee97712621mr9082176pfd.47.1615494952640;
        Thu, 11 Mar 2021 12:35:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5186:d796:2218:6442])
        by smtp.gmail.com with ESMTPSA id 25sm3232745pfh.199.2021.03.11.12.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 12:35:52 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next 2/3] tcp: consider using standard rtx logic in tcp_rcv_fastopen_synack()
Date:   Thu, 11 Mar 2021 12:35:05 -0800
Message-Id: <20210311203506.3450792-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210311203506.3450792-1-eric.dumazet@gmail.com>
References: <20210311203506.3450792-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Jakub reported Data included in a Fastopen SYN that had to be
retransmit would have to wait for an RTO if TX completions are slow,
even with prior fix.

This is because tcp_rcv_fastopen_synack() does not use standard
rtx logic, meaning TSQ handler exits early in tcp_tsq_write()
because tp->lost_out == tp->retrans_out

Lets make tcp_rcv_fastopen_synack() use standard rtx logic,
by using tcp_mark_skb_lost() on the skb thats needs to be
sent again.

Not this raised a warning in tcp_fastretrans_alert() during my tests
since we consider the data not being aknowledged
by the receiver does not mean packet was lost on the network.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_input.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 69a545db80d2ead47ffcf2f3819a6d066e95f35d..4cf4dd532d1c65bba417a66ba6b7783491b6380a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2914,7 +2914,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	/* D. Check state exit conditions. State can be terminated
 	 *    when high_seq is ACKed. */
 	if (icsk->icsk_ca_state == TCP_CA_Open) {
-		WARN_ON(tp->retrans_out != 0);
+		WARN_ON(tp->retrans_out != 0 && !tp->syn_data);
 		tp->retrans_stamp = 0;
 	} else if (!before(tp->snd_una, tp->high_seq)) {
 		switch (icsk->icsk_ca_state) {
@@ -5994,11 +5994,9 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 			tp->fastopen_client_fail = TFO_SYN_RETRANSMITTED;
 		else
 			tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
-		skb_rbtree_walk_from(data) {
-			if (__tcp_retransmit_skb(sk, data, 1))
-				break;
-		}
-		tcp_rearm_rto(sk);
+		skb_rbtree_walk_from(data)
+			 tcp_mark_skb_lost(sk, data);
+		tcp_xmit_retransmit_queue(sk);
 		NET_INC_STATS(sock_net(sk),
 				LINUX_MIB_TCPFASTOPENACTIVEFAIL);
 		return true;
-- 
2.31.0.rc2.261.g7f71774620-goog

