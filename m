Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6047B823
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhLUCEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbhLUCCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:02:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EF0C07E5E0;
        Mon, 20 Dec 2021 18:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EA866137A;
        Tue, 21 Dec 2021 02:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B54C36AE9;
        Tue, 21 Dec 2021 02:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052110;
        bh=A3AasHvCSJvx+Vf7Qurl525kl0kgh+hgX6cjatUB8ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQn7oWnA18dEYzFoQVGZUjzMqOKtGKHOuLzkTvkHKStUOlbyXYuZiRTtbhaUlljv7
         cOf78OAyNiWrkNrB5owk4rs6HONtti2e6Z/iwuVA9NaPYuRGjFsQ9ZCayjXlQITZPm
         ksPCE1fh78/SsbyaaROQgfKg3A/y0jBNmzae3u5tRs/wrw0FPDqWaqdcDdYt7xwgEt
         Il7uRePLaFkyXKoSK4qNbqIeJRRQ8NhZqTVpuDdT7uEI0N7YQsShlqP6P+Oar0Ybgn
         D0JPBKLUiJ6k6ndYqMybOgEY+/jk2yb0ZB1eqxD9WHqVlDPhZ1nQKHE9XDhoQUJB+S
         6d63GvsteX10Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/9] phonet: refcount leak in pep_sock_accep
Date:   Mon, 20 Dec 2021 21:01:18 -0500
Message-Id: <20211221020123.117380-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020123.117380-1-sashal@kernel.org>
References: <20211221020123.117380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit bcd0f93353326954817a4f9fa55ec57fb38acbb0 ]

sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
invoked in subsequent failure branches(pep_accept_conn() != 0).

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index bffcef58ebf5c..f1bdd4f1b1b43 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -881,6 +881,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
-- 
2.34.1

