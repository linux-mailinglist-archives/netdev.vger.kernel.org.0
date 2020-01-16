Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB43613F2B5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403914AbgAPShO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390597AbgAPRMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F306246A8;
        Thu, 16 Jan 2020 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194773;
        bh=lLTcFMjmMQvYwBf03Xi2wZfqBy5ho+jZ75pidxUCjoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgTKuq7KAKnhcEu0izomNDtlPKRBvtA7ANQQwHriYGn8fHqLk4uODx8jOKirABGIW
         S2+fzd+zVKhOie6HFz7vnrw6u0rOXBE0d9lmnRB8XBCsz73Q9GhNQomGU97IcEbKk2
         Lclyg06NSuCCGtByi4vM5i4ZWsaHPnb54oGUH7DU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 591/671] tcp: annotate lockless access to tcp_memory_pressure
Date:   Thu, 16 Jan 2020 12:03:49 -0500
Message-Id: <20200116170509.12787-328-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1f142c17d19a5618d5a633195a46f2c8be9bf232 ]

tcp_memory_pressure is read without holding any lock,
and its value could be changed on other cpus.

Use READ_ONCE() to annotate these lockless reads.

The write side is already using atomic ops.

Fixes: b8da51ebb1aa ("tcp: introduce tcp_under_memory_pressure()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 2 +-
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ac4ffe8013d8..918bfd0d7d1f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -261,7 +261,7 @@ static inline bool tcp_under_memory_pressure(const struct sock *sk)
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return tcp_memory_pressure;
+	return READ_ONCE(tcp_memory_pressure);
 }
 /*
  * The next routines deal with comparing 32 bit unsigned ints
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7561fa1bcc3e..3c181ca714d0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -325,7 +325,7 @@ void tcp_enter_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
 
-	if (tcp_memory_pressure)
+	if (READ_ONCE(tcp_memory_pressure))
 		return;
 	val = jiffies;
 
@@ -340,7 +340,7 @@ void tcp_leave_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
 
-	if (!tcp_memory_pressure)
+	if (!READ_ONCE(tcp_memory_pressure))
 		return;
 	val = xchg(&tcp_memory_pressure, 0);
 	if (val)
-- 
2.20.1

