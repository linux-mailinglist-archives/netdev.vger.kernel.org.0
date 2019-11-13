Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007CCFA485
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfKMB4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfKMB4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 980832247C;
        Wed, 13 Nov 2019 01:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610160;
        bh=Pa9IDB6Fd3A8IIm+kJX6e40chC4y0g1zGgVAP5mCn/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huwAjqkPIMGYVEMdFklJgIADNpowjtEotdgqm3dJYhmFkVeknMHe66bqJAm8yyEW+
         Fh3+l2zxHL+Z6JpPFxYXKgWbtniYtiCoA3QCI26RvDGDOGXrzABDXfCQpy+2VXBASq
         d4XaGSC59MRGuAAJYQ/L7OrRUonUqFHlZjljhQ0s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 203/209] tcp: start receiver buffer autotuning sooner
Date:   Tue, 12 Nov 2019 20:50:19 -0500
Message-Id: <20191113015025.9685-203-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 041a14d2671573611ffd6412bc16e2f64469f7fb ]

Previously receiver buffer auto-tuning starts after receiving
one advertised window amount of data. After the initial receiver
buffer was raised by patch a337531b942b ("tcp: up initial rmem to
128KB and SYN rwin to around 64KB"), the reciver buffer may take
too long to start raising. To address this issue, this patch lowers
the initial bytes expected to receive roughly the expected sender's
initial window.

Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0e2b07be08585..57e8dad956ec4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -438,7 +438,7 @@ void tcp_init_buffer_space(struct sock *sk)
 	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
 		tcp_sndbuf_expand(sk);
 
-	tp->rcvq_space.space = tp->rcv_wnd;
+	tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
 	tcp_mstamp_refresh(tp);
 	tp->rcvq_space.time = tp->tcp_mstamp;
 	tp->rcvq_space.seq = tp->copied_seq;
-- 
2.20.1

