Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2B480449
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhL0TIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbhL0THO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:07:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4629AC0698D7;
        Mon, 27 Dec 2021 11:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11EFEB8113A;
        Mon, 27 Dec 2021 19:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00947C36AED;
        Mon, 27 Dec 2021 19:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632017;
        bh=7v65NIKYKLtqaCIPUqAhVcawDbEbdJ2lZkTee9dCzF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW6hdwV/Px0lfZoPLHBfjn1U+fqDcIiIOJzkP92tbIGhaifwWaxl+BnYMVMvPbQMO
         LxgyMnTSXzMs0HeRv1XiAX5viMvig5riJQcVK0jsnXvmmUqUx5o72nhn8UrmDpfGVd
         Jf0g+OCXfRMlKb47GrnCsRAf9q9LDY73AOSEvXxuTAya++8ZrKgPkrY7Ns1O6njF/1
         Qc+PPiHhOl/CyBvOptajrnWVkGqEDw1/F7uzwNmEaxqZ77yVelljrI511tEFwlj/ag
         vzmFzsl+ssaxKoZBbZxSE1ygFyjI0z2vJ++kWJ/0IZbH/Sp3YEnmH/9+w/ACTlWVMy
         GqqgKZADI57lA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
        syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, courmisch@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/3] phonet/pep: refuse to enable an unbound pipe
Date:   Mon, 27 Dec 2021 14:06:52 -0500
Message-Id: <20211227190653.1043578-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190653.1043578-1-sashal@kernel.org>
References: <20211227190653.1043578-1-sashal@kernel.org>
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
index f6aa532bcbf64..1e7945df39928 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -956,6 +956,8 @@ static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
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

