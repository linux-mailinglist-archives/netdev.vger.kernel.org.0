Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE89052476D
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351195AbiELHxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346458AbiELHxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:53:05 -0400
X-Greylist: delayed 476 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 May 2022 00:53:04 PDT
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C46E252B4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:53:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E5A742060D;
        Thu, 12 May 2022 09:45:05 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GUncMoDAUZUE; Thu, 12 May 2022 09:45:05 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 05520205E7;
        Thu, 12 May 2022 09:45:05 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id E981B80004A;
        Thu, 12 May 2022 09:45:04 +0200 (CEST)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 09:45:04 +0200
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 12 May
 2022 09:45:04 +0200
Date:   Thu, 12 May 2022 09:44:57 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH RFC ipsec] xfrm: fix panic in xfrm_delete from userspace on
 ARM 32
Message-ID: <00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A kernel panic was reported on ARM 32 architecture.
In spite of initialization, x = kmem_cache_zalloc(xfrm_state_cache, GFP_ATOMIC),
x->mapping_maxage appears to be nozero and cause kernel panic in
xfrm_state_delete().

https://github.com/strongswan/strongswan/issues/992

(__xfrm_state_delete) from [<c091ad58>] (xfrm_state_delete+0x24/0x44)
(xfrm_state_delete) from [<bf4c31e4>] (xfrm_del_sa+0x94/0xe4 [xfrm_user])
(xfrm_del_sa [xfrm_user]) from [<bf4c2180>] (xfrm_user_rcv_msg+0xe0/0x1d0 [xfrm_user])
(xfrm_user_rcv_msg [xfrm_user]) from [<c0878da4>] (netlink_rcv_skb+0xd8/0x148)
(netlink_rcv_skb) from [<bf4c1724>] (xfrm_netlink_rcv+0x2c/0x48 [xfrm_user])
(xfrm_netlink_rcv [xfrm_user]) from [<c0878408>] (netlink_unicast+0x208/0x31c)
(netlink_unicast) from [<c0878710>] (netlink_sendmsg+0x1f4/0x468)
(netlink_sendmsg) from [<c07e1408>] (__sys_sendto+0xd4/0x13c)

Even if x->mapping_maxage is non zero I can't explain the cause of panic.
However, roth-m reports setting  x->mapping_maxage = 0 fix the panic!

I am still not sure of the cause. So I proposing the fix as an RFC.
Anyone has experience with nondeterministic kmem_cache_zalloc() on 32 bit ARM hardware?
Note other initializations in xfrm_state_alloc() x->replay_maxage = 0. I
wonder why those were added when there is kmem_cache_zalloc call above.

The bug report mentioned OpenWRT tool chain and OpenWRT kernel.

Fixes: 4e484b3e969b ("xfrm: rate limit SA mapping change message to user space")
Reported-by: https://github.com/roth-m
Suggested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b749935152ba..1724a9bd232e 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -654,6 +654,9 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 		x->lft.hard_packet_limit = XFRM_INF;
 		x->replay_maxage = 0;
 		x->replay_maxdiff = 0;
+		x->mapping_maxage = 0;
+		x->new_mapping = 0;
+		x->new_mapping_sport = 0;
 		spin_lock_init(&x->lock);
 	}
 	return x;
--
2.30.2

