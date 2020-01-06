Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA332130CA4
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 04:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgAFDv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 22:51:29 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64314 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbgAFDv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 22:51:29 -0500
Received: from fsav107.sakura.ne.jp (fsav107.sakura.ne.jp [27.133.134.234])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 0063pLeB023959;
        Mon, 6 Jan 2020 12:51:21 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav107.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav107.sakura.ne.jp);
 Mon, 06 Jan 2020 12:51:21 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav107.sakura.ne.jp)
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 0063pLIj023953;
        Mon, 6 Jan 2020 12:51:21 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: (from i-love@localhost)
        by www262.sakura.ne.jp (8.15.2/8.15.2/Submit) id 0063pLqJ023952;
        Mon, 6 Jan 2020 12:51:21 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Message-Id: <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
X-Authentication-Warning: www262.sakura.ne.jp: i-love set sender to penguin-kernel@i-love.sakura.ne.jp using -f
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on debian
 buster
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     David Ahern <dsahern@gmail.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
MIME-Version: 1.0
Date:   Mon, 06 Jan 2020 12:51:21 +0900
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
In-Reply-To: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

Thank you for reporting. Will you confirm that this patch fixes your problem?
----------------------------------------
From 06a61125a79139941cdebee3a24b0b4bed576742 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 6 Jan 2020 12:46:49 +0900
Subject: [PATCH] smack: Don't reject IPv6's bind() when socket family is invalid

David Ahern has reported that commit b9ef5513c99bf9c8 ("smack: Check
address length before reading address family") breaks ping program in
Debian Buster because that version of ping program is by error using
AF_UNSPEC instead of AF_INET6 when calling connect().

Since rawv6_bind() will fail with -EINVAL and __inet6_bind() from
inet6_bind() will fail with -EAFNOSUPPORT if sin6_family != AF_INET6,
smack_socket_bind() can return 0 rather than -EINVAL.

Reported-by: David Ahern <dsahern@gmail.com>
Bisected-by: David Ahern <dsahern@gmail.com>
Fixes: b9ef5513c99bf9c8 ("smack: Check address length before reading address family")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable@vger.kernel.org
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ecea41ce919b..5b2177724d5e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2810,7 +2810,7 @@ static int smack_socket_bind(struct socket *sock, struct sockaddr *address,
 	if (sock->sk != NULL && sock->sk->sk_family == PF_INET6) {
 		if (addrlen < SIN6_LEN_RFC2133 ||
 		    address->sa_family != AF_INET6)
-			return -EINVAL;
+			return 0;
 		smk_ipv6_port_label(sock, address);
 	}
 	return 0;
-- 
2.16.6
