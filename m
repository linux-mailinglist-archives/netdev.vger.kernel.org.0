Return-Path: <netdev+bounces-2849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2617044A3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7232D1C20D56
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8910519E7F;
	Tue, 16 May 2023 05:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78519E73
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:24:12 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C4D30C3
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:24:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 0E1A5207A4;
	Tue, 16 May 2023 07:24:09 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XVg-jl8Mueob; Tue, 16 May 2023 07:24:08 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 82B0F206BC;
	Tue, 16 May 2023 07:24:08 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 7D16D80004A;
	Tue, 16 May 2023 07:24:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 07:24:08 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 07:24:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id B98213182BEE; Tue, 16 May 2023 07:24:07 +0200 (CEST)
From: Steffen Klassert <steffen.klassert@secunet.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Steffen Klassert
	<steffen.klassert@secunet.com>, <netdev@vger.kernel.org>
Subject: [PATCH 2/7] xfrm: release all offloaded policy memory
Date: Tue, 16 May 2023 07:24:00 +0200
Message-ID: <20230516052405.2677554-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516052405.2677554-1-steffen.klassert@secunet.com>
References: <20230516052405.2677554-1-steffen.klassert@secunet.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Leon Romanovsky <leonro@nvidia.com>

Failure to add offloaded policy will cause to the following
error once user will try to reload driver.

Unregister_netdevice: waiting for eth3 to become free. Usage count = 2

This was caused by xfrm_dev_policy_add() which increments reference
to net_device. That reference was supposed to be decremented
in xfrm_dev_policy_free(). However the latter wasn't called.

 unregister_netdevice: waiting for eth3 to become free. Usage count = 2
 leaked reference.
  xfrm_dev_policy_add+0xff/0x3d0
  xfrm_policy_construct+0x352/0x420
  xfrm_add_policy+0x179/0x320
  xfrm_user_rcv_msg+0x1d2/0x3d0
  netlink_rcv_skb+0xe0/0x210
  xfrm_netlink_rcv+0x45/0x50
  netlink_unicast+0x346/0x490
  netlink_sendmsg+0x3b0/0x6c0
  sock_sendmsg+0x73/0xc0
  sock_write_iter+0x13b/0x1f0
  vfs_write+0x528/0x5d0
  ksys_write+0x120/0x150
  do_syscall_64+0x3d/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 103af2b3e986..af8fbcbfbe69 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1978,6 +1978,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (err) {
 		xfrm_dev_policy_delete(xp);
+		xfrm_dev_policy_free(xp);
 		security_xfrm_policy_free(xp->security);
 		kfree(xp);
 		return err;
-- 
2.34.1


