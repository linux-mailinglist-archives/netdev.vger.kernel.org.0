Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C63106195
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfKVF54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729550AbfKVF5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1161C20717;
        Fri, 22 Nov 2019 05:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402272;
        bh=gmEmMwBpratgRQVW/qWF9gmbRLer7I/p+Mnl3cfi5xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mw6Fp6YLFvsT+MhsmepctQECq22vlbYqPel0HjR2upKuh4Qrs03qKAZr/lMg7ic7B
         H7skZfN7pmzzkfyVtmOpS+1Y1H2+Xn97dzJsPOFGR0qsXwjxSm0V3Cyh6dlkHzYjD0
         q8jR61laoDw9qSqPGEGzbNSJXGxaX/XH+f+21Gjw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 112/127] net: fix possible overflow in __sk_mem_raise_allocated()
Date:   Fri, 22 Nov 2019 00:55:30 -0500
Message-Id: <20191122055544.3299-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5bf325a53202b8728cf7013b72688c46071e212e ]

With many active TCP sockets, fat TCP sockets could fool
__sk_mem_raise_allocated() thanks to an overflow.

They would increase their share of the memory, instead
of decreasing it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 +-
 net/core/sock.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 780c6c0a86f04..0af46cbd3649c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1232,7 +1232,7 @@ static inline void sk_sockets_allocated_inc(struct sock *sk)
 	percpu_counter_inc(sk->sk_prot->sockets_allocated);
 }
 
-static inline int
+static inline u64
 sk_sockets_allocated_read_positive(struct sock *sk)
 {
 	return percpu_counter_read_positive(sk->sk_prot->sockets_allocated);
diff --git a/net/core/sock.c b/net/core/sock.c
index 7ccbcd853cbce..90ccbbf9e6b00 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2357,7 +2357,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	}
 
 	if (sk_has_memory_pressure(sk)) {
-		int alloc;
+		u64 alloc;
 
 		if (!sk_under_memory_pressure(sk))
 			return 1;
-- 
2.20.1

