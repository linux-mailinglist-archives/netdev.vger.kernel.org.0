Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E35337972
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCKQdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:33:18 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:45568 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhCKQdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:33:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9XIU1
        AsxRHmXGdjDfHdKw5hhP95GaH/WKq3BV21SW+8=; b=n/rpuV1bL19IG36B22qE4
        uVh10bbSJwkWHzPJgu7todPM+TzFXMqHEAqu8GjRvMZuOKb0Ioe/R6BuIqugMk14
        WJwyT23DimFt9UbO5+lchIN49SJMYvCCxIjgetZ5YtPr0zCnkPDlT25T8zJ+Q7km
        awX8bl7nmkk0RT3xq9vv0s=
Received: from localhost.localdomain (unknown [47.89.231.3])
        by smtp5 (Coremail) with SMTP id HdxpCgB3nE0pRkpgOHt4AA--.201S2;
        Fri, 12 Mar 2021 00:32:49 +0800 (CST)
From:   yacanliu@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuyacan <yacanliu@163.com>
Subject: [PATCH] net: correct sk_acceptq_is_full()
Date:   Fri, 12 Mar 2021 00:32:25 +0800
Message-Id: <20210311163225.5900-1-yacanliu@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgB3nE0pRkpgOHt4AA--.201S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GryxGw17Zr1fXF4xKF1Dtrb_yoW3twbEkw
        n7Xrn0ka1rZFnIy393Ka1DXr4rK3yxAFykuF1fZFZ3Awn7Grs8Wry5urnFya15Cws7Zr4f
        C3WkZryUtFWfGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRMjg4DUUUUU==
X-Originating-IP: [47.89.231.3]
X-CM-SenderInfo: p1dft0xolxqiywtou0bp/xtbBaRJSS1Xlts9qFgAAsX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <yacanliu@163.com>

The "backlog" argument in listen() specifies
the maximom length of pending connections,
so the accept queue should be considered full
if there are exactly "backlog" elements.

Signed-off-by: liuyacan <yacanliu@163.com>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 636810ddcd9b..0b6266fd6bf6 100644
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
2.25.1

