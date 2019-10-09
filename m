Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD2AD1B68
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbfJIWKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:10:19 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:51092 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJIWKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:10:19 -0400
Received: by mail-pl1-f201.google.com with SMTP id y13so2375649plr.17
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 15:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5MasWc16hxbdVQn+byby2Ehi98+vK7cxAt0AXgPrlSM=;
        b=g+hk2foQQDLoaBkaO6YFa2sHyRneqnFQaJ8J8uChDS+4Rx4hhOgVzemO/DYk64xvEH
         a34f80sQQKv8AmvG8j/505/LMMz+PfsH8BgQXGPkhj867eEzUvTQ6Jn3AtmmtH1Uf2fd
         n95wT7c5Hy1fX18WigZlWAop7tpBfk1xV8VYQqjV7+yCH/938TRyX+SowtVkVGY9SJ13
         RYpavApsQswVuA6uRhiPf1d5wzo8jKtGYTR9MjDdF6K1tR1ElQdWdUPyygMCG2+O/BGi
         ZcJriwJOas0Kzj+UThMFeKRlkFWU5KAaG0PjT4wJvhLV1X3crj9ByoD8MUrLEthBPOuE
         +2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5MasWc16hxbdVQn+byby2Ehi98+vK7cxAt0AXgPrlSM=;
        b=r6xexHVSVPHLQ5E/rrssGz4rQqCTFvfl2Nftd3cSGGmXxuNVHywPRVEHlXHE0Wf2Db
         v4QXA3AYbiQY/lwS7PvipWXyTQoMBZDKuEv8cU+J+KnixGz7bRk5IvcvKHXlMWGqr0Lb
         CnpmIa6qOJj1OlFtBhnrgM1D6Z4rBGrun2YoZ85b+ViLaGgt/C+tOjWlvX0qcdyfIDCa
         nsA8dRjTEIQKQhpDc46tbS7G/Evsifi2hrQ3iSCY3cu4xcqQz6cRLJM6E/Fc7A0uJzLj
         c6EGqVhUJX/Tgw1elmAIacIObIiQ/fWeAFmB49EkLVo18n3Ck/5f/euSctimMvrpfN/L
         UQEg==
X-Gm-Message-State: APjAAAUczjmwBsvT3cDA8FHjlasSA0HByHDf2R9eKijc1CrgEKH0pDG7
        bginJkLBB8UZltk3xwJmBwUcyoBS03LUmg==
X-Google-Smtp-Source: APXvYqxKefxl9tsI64VdxQrh1OhBZgZOz41bLcFxu0iM4nBC/4Qu+N3/GrmJbBthWkSnfsKOVc9ob34p2fbbgQ==
X-Received: by 2002:a63:67c3:: with SMTP id b186mr6801334pgc.152.1570659018720;
 Wed, 09 Oct 2019 15:10:18 -0700 (PDT)
Date:   Wed,  9 Oct 2019 15:10:15 -0700
Message-Id: <20191009221015.36077-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] tcp: annotate lockless access to tcp_memory_pressure
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_memory_pressure is read without holding any lock,
and its value could be changed on other cpus.

Use READ_ONCE() to annotate these lockless reads.

The write side is already using atomic ops.

Fixes: b8da51ebb1aa ("tcp: introduce tcp_under_memory_pressure()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h | 2 +-
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c9a3f9688223b231e5a8c90c2494ad85f3d63cfc..88e63d64c698229379a953101a8aab2bca55ed1a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -258,7 +258,7 @@ static inline bool tcp_under_memory_pressure(const struct sock *sk)
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return tcp_memory_pressure;
+	return READ_ONCE(tcp_memory_pressure);
 }
 /*
  * The next routines deal with comparing 32 bit unsigned ints
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f98a1882e537dca0102e829cb349be50302d83ab..888c92b63f5a6dc4b935cca7c979c1e559126d44 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -326,7 +326,7 @@ void tcp_enter_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
 
-	if (tcp_memory_pressure)
+	if (READ_ONCE(tcp_memory_pressure))
 		return;
 	val = jiffies;
 
@@ -341,7 +341,7 @@ void tcp_leave_memory_pressure(struct sock *sk)
 {
 	unsigned long val;
 
-	if (!tcp_memory_pressure)
+	if (!READ_ONCE(tcp_memory_pressure))
 		return;
 	val = xchg(&tcp_memory_pressure, 0);
 	if (val)
-- 
2.23.0.581.g78d2f28ef7-goog

