Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67C48043E
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhL0TIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhL0TGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:06:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A2EC061759;
        Mon, 27 Dec 2021 11:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2683CE114B;
        Mon, 27 Dec 2021 19:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD66BC36AED;
        Mon, 27 Dec 2021 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632004;
        bh=PA1oN4wx0dyYh4yduAXOkHiXkA9+L6rxmYpw6hghkns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fs97knrzcA9OBOW1o863NE80BKEwfKRvh3DZtwDQPvSUHj6eMDk2tO2lzqeaLE4e2
         wqjuZ9Cpy1zA/0xj6hLJfuNqXxZXHRs3swiDmn+qjKdcpsXZaojDm8ChF/GeJ7GUw6
         If3RfeDyEbnQZsK3tm6xuudvGIwt243W+zt0RjeDmPb/gvzg+SSfHlD5srZciulisC
         J6s/mGVZrMXMs8qSyGI09fMYtodr6XZarHidFKJIMr+SYDqRu3KGmIDELo2rWqPv+M
         mN7OiwyrE7BguEaxyALbq17lZthbgLeu8a/wGiXhLf3UqI80Ys1SIFbrSbMqTgBlgr
         AfqJ+HN6mgjEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
        syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/4] phonet/pep: refuse to enable an unbound pipe
Date:   Mon, 27 Dec 2021 14:06:28 -0500
Message-Id: <20211227190629.1043445-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190629.1043445-1-sashal@kernel.org>
References: <20211227190629.1043445-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rémi Denis-Courmont <remi@remlab.net>

[ Upstream commit 75a2f31520095600f650597c0ac41f48b5ba0068 ]

This ioctl() implicitly assumed that the socket was already bound to
a valid local socket name, i.e. Phonet object. If the socket was not
bound, two separate problems would occur:

1) We'd send an pipe enablement request with an invalid source object.
2) Later socket calls could BUG on the socket unexpectedly being
   connected yet not bound to a valid object.

Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com
Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index bffcef58ebf5c..b0d958cd1823e 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -959,6 +959,8 @@ static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
 			ret =  -EBUSY;
 		else if (sk->sk_state == TCP_ESTABLISHED)
 			ret = -EISCONN;
+		else if (!pn->pn_sk.sobject)
+			ret = -EADDRNOTAVAIL;
 		else
 			ret = pep_sock_enable(sk, NULL, 0);
 		release_sock(sk);
-- 
2.34.1

