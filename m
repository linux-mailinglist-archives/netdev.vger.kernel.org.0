Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EAF1380B6
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 11:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgAKKdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 05:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbgAKKdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 05:33:18 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 258A320842;
        Sat, 11 Jan 2020 10:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738797;
        bh=3s5JAX5Q2ODEjcC2HpUaI66ihhczXZpmWqli7dJibxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATaFfo20IkngoTDMZUK5hCOVAQBwZf/0VXTcrJH9miBnIU2MUhs5XwQ8wZZXySMXx
         w9ae/4kQjc4AXOE4lOkEPCIeVzsQ5YONt/rCyqzxoQ0BM8rqnboBc/vuKjWGiUz/Ww
         xUO1n3fvQw4OShYchTBQzCI+aVnp0gqE6bBeZ+KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 5.4 147/165] sch_cake: avoid possible divide by zero in cake_enqueue()
Date:   Sat, 11 Jan 2020 10:51:06 +0100
Message-Id: <20200111094939.776468385@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 68aab823c223646fab311f8a6581994facee66a0 ]

The variables 'window_interval' is u64 and do_div()
truncates it to 32 bits, which means it can test
non-zero and be truncated to zero for division.
The unit of window_interval is nanoseconds,
so its lower 32-bit is relatively easy to exceed.
Fix this issue by using div64_u64() instead.

Fixes: 7298de9cd725 ("sch_cake: Add ingress mode")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: cake@lists.bufferbloat.net
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1769,7 +1769,7 @@ static s32 cake_enqueue(struct sk_buff *
 						      q->avg_window_begin));
 			u64 b = q->avg_window_bytes * (u64)NSEC_PER_SEC;
 
-			do_div(b, window_interval);
+			b = div64_u64(b, window_interval);
 			q->avg_peak_bandwidth =
 				cake_ewma(q->avg_peak_bandwidth, b,
 					  b > q->avg_peak_bandwidth ? 2 : 8);


