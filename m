Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4C32FE9CF
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbhAUMTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:19:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:54612 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbhAUMQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:16:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7F6B02027C;
        Thu, 21 Jan 2021 13:16:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ncZpjEadUzLw; Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9216720322;
        Thu, 21 Jan 2021 13:16:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 21 Jan 2021 13:16:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 21 Jan
 2021 13:16:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9BE353182BAE;
 Thu, 21 Jan 2021 13:16:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/5] xfrm: Fix oops in xfrm_replay_advance_bmp
Date:   Thu, 21 Jan 2021 13:15:54 +0100
Message-ID: <20210121121558.621339-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121121558.621339-1-steffen.klassert@secunet.com>
References: <20210121121558.621339-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shmulik Ladkani <shmulik@metanetworks.com>

When setting xfrm replay_window to values higher than 32, a rare
page-fault occurs in xfrm_replay_advance_bmp:

  BUG: unable to handle page fault for address: ffff8af350ad7920
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD ad001067 P4D ad001067 PUD 0
  Oops: 0002 [#1] SMP PTI
  CPU: 3 PID: 30 Comm: ksoftirqd/3 Kdump: loaded Not tainted 5.4.52-050452-generic #202007160732
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
  RIP: 0010:xfrm_replay_advance_bmp+0xbb/0x130
  RSP: 0018:ffffa1304013ba40 EFLAGS: 00010206
  RAX: 000000000000010d RBX: 0000000000000002 RCX: 00000000ffffff4b
  RDX: 0000000000000018 RSI: 00000000004c234c RDI: 00000000ffb3dbff
  RBP: ffffa1304013ba50 R08: ffff8af330ad7920 R09: 0000000007fffffa
  R10: 0000000000000800 R11: 0000000000000010 R12: ffff8af29d6258c0
  R13: ffff8af28b95c700 R14: 0000000000000000 R15: ffff8af29d6258fc
  FS:  0000000000000000(0000) GS:ffff8af339ac0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8af350ad7920 CR3: 0000000015ee4000 CR4: 00000000001406e0
  Call Trace:
   xfrm_input+0x4e5/0xa10
   xfrm4_rcv_encap+0xb5/0xe0
   xfrm4_udp_encap_rcv+0x140/0x1c0

Analysis revealed offending code is when accessing:

	replay_esn->bmp[nr] |= (1U << bitnr);

with 'nr' being 0x07fffffa.

This happened in an SMP system when reordering of packets was present;
A packet arrived with a "too old" sequence number (outside the window,
i.e 'diff > replay_window'), and therefore the following calculation:

			bitnr = replay_esn->replay_window - (diff - pos);

yields a negative result, but since bitnr is u32 we get a large unsigned
quantity (in crash dump above: 0xffffff4b seen in ecx).

This was supposed to be protected by xfrm_input()'s former call to:

		if (x->repl->check(x, skb, seq)) {

However, the state's spinlock x->lock is *released* after '->check()'
is performed, and gets re-acquired before '->advance()' - which gives a
chance for a different core to update the xfrm state, e.g. by advancing
'replay_esn->seq' when it encounters more packets - leading to a
'diff > replay_window' situation when original core continues to
xfrm_replay_advance_bmp().

An attempt to fix this issue was suggested in commit bcf66bf54aab
("xfrm: Perform a replay check after return from async codepaths"),
by calling 'x->repl->recheck()' after lock is re-acquired, but fix
applied only to asyncronous crypto algorithms.

Augment the fix, by *always* calling 'recheck()' - irrespective if we're
using async crypto.

Fixes: 0ebea8ef3559 ("[IPSEC]: Move state lock into x->type->input")
Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 37456d022cfa..61e6220ddd5a 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -660,7 +660,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		/* only the first xfrm gets the encap type */
 		encap_type = 0;
 
-		if (async && x->repl->recheck(x, skb, seq)) {
+		if (x->repl->recheck(x, skb, seq)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATESEQERROR);
 			goto drop_unlock;
 		}
-- 
2.25.1

