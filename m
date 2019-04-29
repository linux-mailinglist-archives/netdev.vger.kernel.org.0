Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A01FECEA
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729672AbfD2Wqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:46 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56392 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbfD2Wqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:44 -0400
Received: by mail-pg1-f201.google.com with SMTP id h14so8005975pgn.23
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1bAvjfrXE6WvOR3zk+mJOm/kTVLM0/P03sOXOgxXWTE=;
        b=lYFAc8wc/pFvZZrZdxqpypiSZhEzAQ8uOVhV+WWo81QSAdHO0FPivfWQ+9IqWZOBy0
         ZzEu5WluJJ+bTFCrVUtuOijLpk1+wMAmubxgCM260aKox1uTY1Mq99TdL9JHA4DT5oz2
         32TtYBhcDFdFF2hpLQdnPKVBDPmcAA3aor1WBeYwg+93/NS5fM2DtdHAHldT+vrw1Mjp
         9/3rub8wAhUPNlxM4EuUh2OOMbzcYqoQd3yU5ZiRs1m/cTaNHsg+bq7Dwth9abK1DPXv
         WfbSVFWOou/Eq07bczF+kvKAYKaiUGcvzkSCceGbC+GeoBBOzG3FK71WJ17HekNx1NVQ
         dCKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1bAvjfrXE6WvOR3zk+mJOm/kTVLM0/P03sOXOgxXWTE=;
        b=FgTKasOekXykcWccFi36AI8Bl65q0j85cPCeYaQ8mU4pgilC9LrFzhdwqFiZplPpNq
         YNKDBL5etNHO2aqrJFYMCou7HPC9FMrHOvn5cHCJJDOU8gYzLvNGLW510qLDXiYerNvC
         1PQQ78NSS/hM6KHU4j91AqbbQKs3hEL+RVdJnmMF3gCAM2lNb/ysdENTU0NN5bMLwEww
         DmunQrQ/HcadTNrf5FUyifrf3d6pHHNLk7fQZvE6a3GDFfknZB3Slu1AQNoAC9PSdt7l
         6XpFW0+h9JD8fdzUMmweIzdDXShcmIjjypLr1iBanVsdOLYKs7QOldbzuVDwIPUilEsa
         6hEw==
X-Gm-Message-State: APjAAAUA2AJ3h5E1uPdrsd1fmwmhw/7x0fnSO9Ab1NwPbZgr5+NJBysT
        9C/XOBP9hvEiDHgfqGd+4kVf4Hnr+78=
X-Google-Smtp-Source: APXvYqw3+WI9BJk1J9KrP3q+AWtffzXL2W+P++HS7oFJjz/nlj/O1Lqw8bprhQ2aAB2ZUrxMH+KVTlk7A/0=
X-Received: by 2002:a65:518d:: with SMTP id h13mr62913548pgq.259.1556578003868;
 Mon, 29 Apr 2019 15:46:43 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:18 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-7-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 6/8] tcp: undo cwnd on Fast Open spurious SYNACK retransmit
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes passive Fast Open reverts the cwnd to default
initial cwnd (10 packets) if the SYNACK timeout is spurious.

Passive Fast Open uses a full socket during handshake so it can
use the existing undo logic to detect spurious retransmission
by recording the first SYNACK timeout in key state variable
retrans_stamp. Upon receiving the ACK of the SYNACK, if the socket
has sent some data before the timeout, the spurious timeout
is detected by tcp_try_undo_recovery() in tcp_process_loss()
in tcp_ack().

But if the socket has not send any data yet, tcp_ack() does not
execute the undo code since no data is acknowledged. The fix is to
check such case explicitly after tcp_ack() during the ACK processing
in SYN_RECV state. In addition this is checked in FIN_WAIT_1 state
in case the server closes the socket before handshake completes.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 53b4c5a3113b..3a40584cb473 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6089,6 +6089,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		 * so release it.
 		 */
 		if (req) {
+			tcp_try_undo_loss(sk, false);
 			inet_csk(sk)->icsk_retransmits = 0;
 			reqsk_fastopen_remove(sk, req, false);
 			/* Re-arm the timer because data may have been sent out.
@@ -6143,6 +6144,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		 * our SYNACK so stop the SYNACK timer.
 		 */
 		if (req) {
+			tcp_try_undo_loss(sk, false);
+			inet_csk(sk)->icsk_retransmits = 0;
 			/* We no longer need the request sock. */
 			reqsk_fastopen_remove(sk, req, false);
 			tcp_rearm_rto(sk);
-- 
2.21.0.593.g511ec345e18-goog

