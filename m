Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB60934DA9A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhC2WXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhC2WWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A30F561997;
        Mon, 29 Mar 2021 22:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056553;
        bh=kOujJ64lk4ZjIev0NMFLYLG5QfMNx+7zWxDaYstGh6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqG+829l4erwe5miK5sydNUCa9M4VbgXIUg264+YwV2/mOB+WtiW5GDYp916vhmiC
         9bN+Ml62SEmIhvueYvpTgayTykPA2BZK2ILmopHwZX+1Ddn30EDtyyA9x+uUbF1RFi
         yWE3fUGA0VuRDrqFWWlF+Z60xHHuhC0c1frSMsjlnninkCS99TeDxiqF1NQEMSfwoL
         6Jul3IOEOpRQ3WMINskJmiOId43oJprZ7qIFB8L3XOtk5uxGRNrq+gpYCaTZHnhd/s
         SmV/zN7tmFu/82MxClmAiFcggd6xICbqezXQQDM2knfXGr3JGZMPBxJSoSf8bVUs0x
         JvX9MUGHUMNmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     liuyacan <yacanliu@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/33] net: correct sk_acceptq_is_full()
Date:   Mon, 29 Mar 2021 18:21:57 -0400
Message-Id: <20210329222222.2382987-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
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
index 253202dcc5e6..8cdc009d7636 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -930,7 +930,7 @@ static inline void sk_acceptq_added(struct sock *sk)
 
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
+	return READ_ONCE(sk->sk_ack_backlog) >= READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 /*
-- 
2.30.1

