Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0111E7B54
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgE2LK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:10:57 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39916 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgE2LKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:10:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C83AA205B4;
        Fri, 29 May 2020 13:10:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UqrnWa_JtOon; Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 12C09205AE;
        Fri, 29 May 2020 13:10:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:10:41 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:10:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4C704318076F;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 15/15] xfrm: fix a NULL-ptr deref in xfrm_local_error
Date:   Fri, 29 May 2020 13:04:08 +0200
Message-ID: <20200529110408.6349-16-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

This patch is to fix a crash:

  [ ] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [ ] general protection fault: 0000 [#1] SMP KASAN PTI
  [ ] RIP: 0010:ipv6_local_error+0xac/0x7a0
  [ ] Call Trace:
  [ ]  xfrm6_local_error+0x1eb/0x300
  [ ]  xfrm_local_error+0x95/0x130
  [ ]  __xfrm6_output+0x65f/0xb50
  [ ]  xfrm6_output+0x106/0x46f
  [ ]  udp_tunnel6_xmit_skb+0x618/0xbf0 [ip6_udp_tunnel]
  [ ]  vxlan_xmit_one+0xbc6/0x2c60 [vxlan]
  [ ]  vxlan_xmit+0x6a0/0x4276 [vxlan]
  [ ]  dev_hard_start_xmit+0x165/0x820
  [ ]  __dev_queue_xmit+0x1ff0/0x2b90
  [ ]  ip_finish_output2+0xd3e/0x1480
  [ ]  ip_do_fragment+0x182d/0x2210
  [ ]  ip_output+0x1d0/0x510
  [ ]  ip_send_skb+0x37/0xa0
  [ ]  raw_sendmsg+0x1b4c/0x2b80
  [ ]  sock_sendmsg+0xc0/0x110

This occurred when sending a v4 skb over vxlan6 over ipsec, in which case
skb->protocol == htons(ETH_P_IPV6) while skb->sk->sk_family == AF_INET in
xfrm_local_error(). Then it will go to xfrm6_local_error() where it tries
to get ipv6 info from a ipv4 sk.

This issue was actually fixed by Commit 628e341f319f ("xfrm: make local
error reporting more robust"), but brought back by Commit 844d48746e4b
("xfrm: choose protocol family by skb protocol").

So to fix it, we should call xfrm6_local_error() only when skb->protocol
is htons(ETH_P_IPV6) and skb->sk->sk_family is AF_INET6.

Fixes: 844d48746e4b ("xfrm: choose protocol family by skb protocol")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 69c33cab8f49..69c4900db817 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -642,7 +642,8 @@ void xfrm_local_error(struct sk_buff *skb, int mtu)
 
 	if (skb->protocol == htons(ETH_P_IP))
 		proto = AF_INET;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (skb->protocol == htons(ETH_P_IPV6) &&
+		 skb->sk->sk_family == AF_INET6)
 		proto = AF_INET6;
 	else
 		return;
-- 
2.17.1

