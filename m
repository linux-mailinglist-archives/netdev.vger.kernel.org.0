Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2996334DA4F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhC2WWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231901AbhC2WVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D7A61997;
        Mon, 29 Mar 2021 22:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056506;
        bh=Mgwobo5/9WXCj/unRT9tgKnEKQ7Mukqd40EUKr4ygz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m76yheSX+k/ARSLTKSQmkj5krz6r8zW61OasltbBRcffI5kCzo0AMUeJJ9dKCQPSp
         0Fa/GfZEjWumfn2olI21fgIophia3S193k0ZYR+kg98CLKzrp4fYoMukKR+8dqKaGQ
         lpdi4OzFSztPi2tTOm8jhdfshdC+nzKUDsoUf9/OkyrOOLW4GMzdvifqvt2UTlHKK7
         J519Fk3cUptAHbduWlLZRQHDjK7ugNMbAMSwbylCry2R8KtinUggjxMk9ihWGHZ3zY
         jTBrc/u5GZ9JhDKiTZemNfXvZztB6oKitG5TaAF8BtoiL/tcp/QEkT6o+jQXfifdAC
         hkqNCZZO37j3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuyacan <yacanliu@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 10/38] net: correct sk_acceptq_is_full()
Date:   Mon, 29 Mar 2021 18:21:05 -0400
Message-Id: <20210329222133.2382393-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <yacanliu@163.com>

[ Upstream commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab ]

The "backlog" argument in listen() specifies
the maximom length of pending connections,
so the accept queue should be considered full
if there are exactly "backlog" elements.

Signed-off-by: liuyacan <yacanliu@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 129d200bccb4..a95f38a4b8c6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -936,7 +936,7 @@ static inline void sk_acceptq_added(struct sock *sk)
 
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
+	return READ_ONCE(sk->sk_ack_backlog) >= READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 /*
-- 
2.30.1

