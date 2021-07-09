Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247EE3C26D6
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhGIPdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhGIPdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:33:20 -0400
X-Greylist: delayed 99 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jul 2021 08:30:36 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4918C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 08:30:36 -0700 (PDT)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 611132E1874;
        Fri,  9 Jul 2021 18:28:53 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id CB5nMnkuqO-SrxqxvS1;
        Fri, 09 Jul 2021 18:28:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1625844533; bh=HcxpaoacuINzegYawD7F4iQeV89EvFexuIAKNB4LHDM=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=f+0h8DoTR4eIGUWT/tNs3UJ4ZWwAqJKqvwscmzZQCRGnrPtqHLMMe1ofHDpEuBOI6
         Yh0A5pWYrNeySHRk6RXTw3D3KzQubxuQVmYmLhW1ycxNWAj4fcuzwg0XoSfbJh0EJd
         QHduCNeLkx4irzXZURBUWjV6oDZVvjPQsrhOd9aY=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.vla.yp-c.yandex.net (ov.vla.yp-c.yandex.net [2a02:6b8:c0f:1a86:0:696:9377:0])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6KT3znDMzJ-Sq2ea4iW;
        Fri, 09 Jul 2021 18:28:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, jhs@mojatatu.com,
        zeil@yandex-team.ru
Subject: [PATCH v2] net: send SYNACK packet with accepted fwmark
Date:   Fri,  9 Jul 2021 18:28:23 +0300
Message-Id: <20210709152823.2220-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
fixed IPv4 only.

This part is for the IPv6 side.

Fixes: e05a90ec9e16 ("net: reflect mark on tcp syn ack packets")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
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

