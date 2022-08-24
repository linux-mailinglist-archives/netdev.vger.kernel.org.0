Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9E159F2E7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 07:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiHXFCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 01:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiHXFCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 01:02:24 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4904457E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 22:02:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B8BA820527;
        Wed, 24 Aug 2022 07:02:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jMxkVzYuEGB6; Wed, 24 Aug 2022 07:02:18 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 613CE20536;
        Wed, 24 Aug 2022 07:02:17 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 4F56380004A;
        Wed, 24 Aug 2022 07:02:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 24 Aug 2022 07:02:17 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 24 Aug
 2022 07:02:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DC0FB3182A0D; Wed, 24 Aug 2022 07:02:15 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/6] xfrm: policy: fix metadata dst->dev xmit null pointer dereference
Date:   Wed, 24 Aug 2022 07:02:13 +0200
Message-ID: <20220824050213.3643599-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824050213.3643599-1-steffen.klassert@secunet.com>
References: <20220824050213.3643599-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <razor@blackwall.org>

When we try to transmit an skb with metadata_dst attached (i.e. dst->dev
== NULL) through xfrm interface we can hit a null pointer dereference[1]
in xfrmi_xmit2() -> xfrm_lookup_with_ifid() due to the check for a
loopback skb device when there's no policy which dereferences dst->dev
unconditionally. Not having dst->dev can be interepreted as it not being
a loopback device, so just add a check for a null dst_orig->dev.

With this fix xfrm interface's Tx error counters go up as usual.

[1] net-next calltrace captured via netconsole:
  BUG: kernel NULL pointer dereference, address: 00000000000000c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP
  CPU: 1 PID: 7231 Comm: ping Kdump: loaded Not tainted 5.19.0+ #24
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-1.fc36 04/01/2014
  RIP: 0010:xfrm_lookup_with_ifid+0x5eb/0xa60
  Code: 8d 74 24 38 e8 26 a4 37 00 48 89 c1 e9 12 fc ff ff 49 63 ed 41 83 fd be 0f 85 be 01 00 00 41 be ff ff ff ff 45 31 ed 48 8b 03 <f6> 80 c0 00 00 00 08 75 0f 41 80 bc 24 19 0d 00 00 01 0f 84 1e 02
  RSP: 0018:ffffb0db82c679f0 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffffd0db7fcad430 RCX: ffffb0db82c67a10
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb0db82c67a80
  RBP: ffffb0db82c67a80 R08: ffffb0db82c67a14 R09: 0000000000000000
  R10: 0000000000000000 R11: ffff8fa449667dc8 R12: ffffffff966db880
  R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
  FS:  00007ff35c83f000(0000) GS:ffff8fa478480000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000c0 CR3: 000000001ebb7000 CR4: 0000000000350ee0
  Call Trace:
   <TASK>
   xfrmi_xmit+0xde/0x460
   ? tcf_bpf_act+0x13d/0x2a0
   dev_hard_start_xmit+0x72/0x1e0
   __dev_queue_xmit+0x251/0xd30
   ip_finish_output2+0x140/0x550
   ip_push_pending_frames+0x56/0x80
   raw_sendmsg+0x663/0x10a0
   ? try_charge_memcg+0x3fd/0x7a0
   ? __mod_memcg_lruvec_state+0x93/0x110
   ? sock_sendmsg+0x30/0x40
   sock_sendmsg+0x30/0x40
   __sys_sendto+0xeb/0x130
   ? handle_mm_fault+0xae/0x280
   ? do_user_addr_fault+0x1e7/0x680
   ? kvm_read_and_reset_apf_flags+0x3b/0x50
   __x64_sys_sendto+0x20/0x30
   do_syscall_64+0x34/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  RIP: 0033:0x7ff35cac1366
  Code: eb 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 55 48 83 ec 30 44 89 4c 24 2c 4c 89
  RSP: 002b:00007fff738e4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00007fff738e57b0 RCX: 00007ff35cac1366
  RDX: 0000000000000040 RSI: 0000557164e4b450 RDI: 0000000000000003
  RBP: 0000557164e4b450 R08: 00007fff738e7a2c R09: 0000000000000010
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
  R13: 00007fff738e5770 R14: 00007fff738e4030 R15: 0000001d00000001
   </TASK>
  Modules linked in: netconsole veth br_netfilter bridge bonding virtio_net [last unloaded: netconsole]
  CR2: 00000000000000c0

CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4f8bbb825abc..cc6ab79609e2 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3162,7 +3162,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 	return dst;
 
 nopol:
-	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
+	if ((!dst_orig->dev || !(dst_orig->dev->flags & IFF_LOOPBACK)) &&
 	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
-- 
2.25.1

