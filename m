Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB0A47A177
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 18:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhLSRLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 12:11:30 -0500
Received: from vps-a2bccee9.vps.ovh.net ([51.75.19.47]:56024 "EHLO
        ursule.remlab.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhLSRL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 12:11:29 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2021 12:11:29 EST
Received: from basile.remlab.net (localhost [IPv6:::1])
        by ursule.remlab.net (Postfix) with ESMTP id E213EC0231;
        Sun, 19 Dec 2021 19:03:39 +0200 (EET)
From:   remi@remlab.net
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] phonet/pep: refuse to enable an unbound pipe
Date:   Sun, 19 Dec 2021 19:03:39 +0200
Message-Id: <20211219170339.630659-1-remi@remlab.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rémi Denis-Courmont <remi@remlab.net>

This ioctl() implicitly assumed that the socket was already bound to
a valid local socket name, i.e. Phonet object. If the socket was not
bound, two separate problems would occur:

1) We'd send an pipe enablement request with an invalid source object.
2) Later socket calls could BUG on the socket unexpectedly being
   connected yet not bound to a valid object.

Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com
Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
---
 net/phonet/pep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index b4f90afb0638..65d463ad8770 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -947,6 +947,8 @@ static int pep_ioctl(struct sock *sk, int cmd, unsigned long arg)
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

