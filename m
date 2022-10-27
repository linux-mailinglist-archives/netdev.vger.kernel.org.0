Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2860FA5B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiJ0O0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiJ0O0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:26:18 -0400
X-Greylist: delayed 65 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Oct 2022 07:26:15 PDT
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E1817045D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:26:13 -0700 (PDT)
Received: from IT-EXMB-1-123.meizu.com (172.16.1.123) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 27 Oct
 2022 22:25:10 +0800
Received: from localhost.localdomain (172.16.215.21) by
 IT-EXMB-1-123.meizu.com (172.16.1.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Oct 2022 22:25:06 +0800
From:   Zhihao Chen <chenzhihao@meizu.com>
To:     <netdev@vger.kernel.org>
CC:     <baihaowen@meizu.com>, <steffen.klassert@secunet.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Chonglong Xu <xuchonglong@meizu.com>
Subject: [PATCH] xfrm:fix access to the null pointer in __xfrm_state_delete()
Date:   Thu, 27 Oct 2022 14:24:55 +0000
Message-ID: <20221027142455.3975224-1-chenzhihao@meizu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.16.215.21]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-123.meizu.com (172.16.1.123)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate the byseq node before removing it from the hlist of state_byseq.
km.seq cannot be used to determine whether the SA is in the byseq hlist
because xfrm_add_sa() may initialize km.seq to 0 and the SA is not inserted
into hlist. In later network communication, the seq field will increase
after the valid packet is received.

In the above case, the NULL pointer will be accessed and cause a kernel
panic when the SA is being removed from hlist by checking km.seq field in
__xfrm_state_delete().

Call trace:
_xfrm_state_delete+0xb0/0x370
xfrm_del_sa+0x1c8/0x378
xfrm_user_rcv_msg+0x220/0x2d8
netlink_rcv_skb+0x104/0x180
xfrm_netlink_rcv+0x6c/0x118
netlink_unicast_kernel+0x12c/0x320
netlink_unicast+0x1dc/0x424
netlink_sendmsg+0x4b8/0x730
sock_write_iter+0x14c/0x1d8
do_iter_readv_writev+0x164/0x1d8
do_iter_write+0x104/0x2c4
do_writev+0x1a4/0x2d4
_arm64_sys_writev+0x24/0x34
invoke_syscall+0x60/0x150
el0svc_common+0xc8/0x114
do_el0_svc+0x28/0xa0
el0_svc+0x28/0x90
el0t_64_sync_handler+0x88/0xec
el0t_64_sync+0x1b4/0x1b8

Fixes: fe9f1d8779cb ("xfrm: add state hashtable keyed by seq")
Signed-off-by: Zhihao Chen <chenzhihao@meizu.com>
Signed-off-by: Chonglong Xu <xuchonglong@meizu.com>
---
 net/xfrm/xfrm_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3d2fe7712ac5..72a6426baef4 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -687,7 +687,7 @@ int __xfrm_state_delete(struct xfrm_state *x)
 		list_del(&x->km.all);
 		hlist_del_rcu(&x->bydst);
 		hlist_del_rcu(&x->bysrc);
-		if (x->km.seq)
+		if (x->km.seq && !hlist_unhashed(&x->byseq))
 			hlist_del_rcu(&x->byseq);
 		if (x->id.spi)
 			hlist_del_rcu(&x->byspi);
-- 
2.25.1

