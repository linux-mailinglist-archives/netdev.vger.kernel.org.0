Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A543C237B
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 14:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhGIMkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 08:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhGIMkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 08:40:15 -0400
X-Greylist: delayed 91 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jul 2021 05:37:31 PDT
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D97C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 05:37:31 -0700 (PDT)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 135682E16C0;
        Fri,  9 Jul 2021 15:35:57 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id sJ7nlnpQEv-ZuxuAjqk;
        Fri, 09 Jul 2021 15:35:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1625834156; bh=i0zDog5SY0CX7eUtnGl+ExMPmyt16MsJN6nNenW+768=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=uEotA/Jb7t+oHfge6kjMe+kKbD6hMwg6ad45hxEo0Iap4NhgupM6xgsxKwfoFHWDg
         miOIwV6UF8aBto8TxF9D2zOEWmz4ukvNRVmWC2kkA7oz1hzDMNuXpSNxQqC1yabobu
         St2lsncLwS7eFqkLVTb6pJ6dhbcAZX77nX0SltO0=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.vla.yp-c.yandex.net (ov.vla.yp-c.yandex.net [2a02:6b8:c0f:1a86:0:696:9377:0])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id RQ1ZCdLPZj-Zu2Sum4K;
        Fri, 09 Jul 2021 15:35:56 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, jhs@mojatatu.com,
        zeil@yandex-team.ru
Subject: [PATCH] net: send SYNACK packet with accepted fwmark
Date:   Fri,  9 Jul 2021 15:35:12 +0300
Message-Id: <20210709123512.6853-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
fixed IPv4 only.

This part is for the IPv6 side.

Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 323989927a0a..0ce52d46e4f8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -555,7 +555,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		opt = ireq->ipv6_opt;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,
+		err = ip6_xmit(sk, skb, fl6, skb->mark ? : sk->sk_mark, opt,
 			       tclass, sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
-- 
2.17.1

