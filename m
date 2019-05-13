Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00721BBFA
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbfEMRcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 13:32:11 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:46893 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbfEMRcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 13:32:10 -0400
Received: by mail-yw1-f74.google.com with SMTP id 201so26230856ywr.13
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 10:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mzcL6jNjDjcF3QWivV+dxb1wcI4GCI2i0yikAROHGQ8=;
        b=d6/TwV8rmdeBITnutzv9eKXw4V9AxOj/UdcxN+VkNw6YFkYR8ZpewtaM1b6q8SVzbO
         N9YbD14MS5LXxUwVOibKbFWiESH8NChOXzV/dUEbFQ1QZTnRJQ137UNxF/irMp2tqNLC
         gR+ov+5Ck/v6VoperNtEq/IxDtJVRQmQeBrlur8/CIJSULvQyPn8OfGRyPlPKRj1dy8P
         GBHSCY3XnCseK7Ks8WdeN+gJtxR4sGD6GNdT9+y0c5MQy40bnHpnWprrvKUs+9ZK0W6Z
         herhR28Cd9dmYmB60Dlh57hi7v7RKbAcdpN4tbTf5ao8oImfsROPB7bzoHUNAJR7PrRQ
         hHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mzcL6jNjDjcF3QWivV+dxb1wcI4GCI2i0yikAROHGQ8=;
        b=ncnuSSEhvjNve9baiyXfFUJFjfAGBm3uTmuq1yrqWYJVWPfVPFeOFQgx8nqCAMwPzu
         YnFC6R+LR7Ptmk0yXi03gyxRTd9bbHTrR5i2YoHarD0MAivXfDZETnT0lihH0z4kaOV0
         nnaMud4lbYu9HzcjLmwN3C/vxD2hk4iNRpV092/Z9RPC/jCVYgRncGJRIzc11cbHrbwv
         6E7T1iiDu2hYe3/I62KX3e0KsSSpTIZaTPXvpgHZZOluYZyw+CrwxjjtlZbVnExPC/mB
         I9etDaqDNnuLbgz6pnpO2pLGWRLw8nS/O87Rtdt6xDPVQpp6MbFs0W9CXBoK1v0WFJU1
         mAgw==
X-Gm-Message-State: APjAAAWLGMucaeiTFWoSTB5/WKX7XdkC+ObXSw2hm5esnI9VSRcP2Q1S
        fiGUAiDcgY0ESa2O/LQIGRB05sObTu4=
X-Google-Smtp-Source: APXvYqxu/wK7h5vGy/yzJ1ZdrS8/hxZ2QCNBucLdqnl8KfVzCH2wrmVD59caWiOw0V0ZZyvIMyVWkTz19Jc=
X-Received: by 2002:a25:2ac6:: with SMTP id q189mr14046078ybq.310.1557768729989;
 Mon, 13 May 2019 10:32:09 -0700 (PDT)
Date:   Mon, 13 May 2019 10:32:05 -0700
Message-Id: <20190513173205.212181-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2 net] tcp: fix retrans timestamp on passive Fast Open
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c7d13c8faa74 ("tcp: properly track retry time on
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

Fixes: c7d13c8faa74 ("tcp: properly track retry time on passive Fast Open")
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

