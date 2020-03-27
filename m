Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECF619529E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgC0IKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:10:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55008 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgC0IKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 04:10:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C12C8204B4;
        Fri, 27 Mar 2020 09:10:16 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FdQa0ETOQfEH; Fri, 27 Mar 2020 09:10:16 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5971420501;
        Fri, 27 Mar 2020 09:10:14 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 27 Mar 2020 09:10:14 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 09:10:13 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 212BD31802DC;
 Fri, 27 Mar 2020 09:10:13 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/8] xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire
Date:   Fri, 27 Mar 2020 09:10:03 +0100
Message-ID: <20200327081007.1185-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327081007.1185-1-steffen.klassert@secunet.com>
References: <20200327081007.1185-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Without doing verify_sec_ctx_len() check in xfrm_add_acquire(), it may be
out-of-bounds to access uctx->ctx_str with uctx->ctx_len, as noticed by
syz:

  BUG: KASAN: slab-out-of-bounds in selinux_xfrm_alloc_user+0x237/0x430
  Read of size 768 at addr ffff8880123be9b4 by task syz-executor.1/11650

  Call Trace:
   dump_stack+0xe8/0x16e
   print_address_description.cold.3+0x9/0x23b
   kasan_report.cold.4+0x64/0x95
   memcpy+0x1f/0x50
   selinux_xfrm_alloc_user+0x237/0x430
   security_xfrm_policy_alloc+0x5c/0xb0
   xfrm_policy_construct+0x2b1/0x650
   xfrm_add_acquire+0x21d/0xa10
   xfrm_user_rcv_msg+0x431/0x6f0
   netlink_rcv_skb+0x15a/0x410
   xfrm_netlink_rcv+0x6d/0x90
   netlink_unicast+0x50e/0x6a0
   netlink_sendmsg+0x8ae/0xd40
   sock_sendmsg+0x133/0x170
   ___sys_sendmsg+0x834/0x9a0
   __sys_sendmsg+0x100/0x1e0
   do_syscall_64+0xe5/0x660
   entry_SYSCALL_64_after_hwframe+0x6a/0xdf

So fix it by adding the missing verify_sec_ctx_len check there.

Fixes: 980ebd25794f ("[IPSEC]: Sync series - acquire insert")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 38ff02d31402..e6cfaa680ef3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2274,6 +2274,9 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	xfrm_mark_get(attrs, &mark);
 
 	err = verify_newpolicy_info(&ua->policy);
+	if (err)
+		goto free_state;
+	err = verify_sec_ctx_len(attrs);
 	if (err)
 		goto free_state;
 
-- 
2.17.1

