Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F2F4803AD
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhL0TEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:04:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39784 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhL0TEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:04:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28F906118C;
        Mon, 27 Dec 2021 19:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95CCC36AED;
        Mon, 27 Dec 2021 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631870;
        bh=nvOIk0ngkOrLThPXg8LEpM3FP4rmMAUV61xQofTxdo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvjqDjY4eiiODG8iYUh5pIOpXO+unfiGg1YUC209WZg2S3Xrqsu/wGxhVCkmvYPKV
         gGTwrQHGYqg7vaUX3Wfv/o7JO/kp6pB6vy58MReNbL9aTHgw8H/5Hj+bal/uWa8shF
         ez8J7coz/T6TNdiXgM8y1ZsofolAXQySSyucb8juvx5hTe4+v4rJrveo5/qe023N5t
         IZUuohvb6jIDwqMTblt10udw1UDQ44+LXd3w6HmR2RyENcMHaiafw5E4IctV/cQvfD
         pQbNTTewoBzno7GIShgL39dnXkouCphakUJSWoHkeHHrzoiEA4RI9EbgafA9oM9tbJ
         rLO1/uLGCNk/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
        syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/26] phonet/pep: refuse to enable an unbound pipe
Date:   Mon, 27 Dec 2021 14:03:20 -0500
Message-Id: <20211227190327.1042326-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
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
index a1525916885ae..72018e5e4d8ef 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -946,6 +946,8 @@ static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
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

