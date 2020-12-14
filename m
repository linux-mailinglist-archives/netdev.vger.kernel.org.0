Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9D32D990D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407981AbgLNNjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbgLNNjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:39:40 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECB5C0613CF
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:38:59 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id w1so17834831ejf.11
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gp48xF2P6dw5q+ML1bhhwMXBZzVrfszuo5e2tABYGD4=;
        b=VT6Ve4IjFbK8FesIaXeupomg3NDuSR+ERSjVJa63nGwGWH7crhubW1lYl42LLhbosE
         NHogJCTLkQBsR2v9zkC8SHUzU8R0I88Ughg8+K32RBtScdfBK0nX0foY1wCtU8aAe8qA
         RC3CEB2YIYeCuki9tikxdb32eaXjQvwAFW++M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gp48xF2P6dw5q+ML1bhhwMXBZzVrfszuo5e2tABYGD4=;
        b=DCXjc7MunZdlyYvcspta/D1b1KPMCm0PzMIKjmAmqByhZyw36eL+hcmRoqfTKlI8o6
         SJvoRUwehViSqEDTB4oANZoG91tYTZ9phWMDaq3YO3gGd5j6WX8ODTgBoqstC+uwlz5O
         xasLxCrU0p/nBIhEPgz+PODMjac827+8xWkrVmfKeeDp+l1fbM7+fXlLgZrsDD+JfcPy
         g3lDw8H0a130T5sCp231tvBWn2OyDASY35+HLyxY8DzUFyzHFV7YHeLzI6j+hyPk2l7d
         37pxXtR1JlljC+69OLbI0VbEU+XsOsdIa1s5/901HJ/Ua91ahP518hVLSvdkz+BLqHP0
         ivaA==
X-Gm-Message-State: AOAM533A3O0E0VQ7sOcbHCnOiGxR3SEUruG61ApdohYOIVIicVzsKBFv
        lP/5yUJolICWPSW3HGQXi5Y1eA==
X-Google-Smtp-Source: ABdhPJyU7x/FkFIsdTcq2uGqkfD9k56+0UEl4tHI2XEBF/hSNhbhPjQhd6T0FzCZSPZIPJvRkz56zQ==
X-Received: by 2002:a17:906:40d3:: with SMTP id a19mr22012558ejk.98.1607953138684;
        Mon, 14 Dec 2020 05:38:58 -0800 (PST)
Received: from localhost.localdomain ([141.226.10.152])
        by smtp.gmail.com with ESMTPSA id da9sm15548239edb.84.2020.12.14.05.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 05:38:58 -0800 (PST)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH] xfrm: Fix oops in xfrm_replay_advance_bmp
Date:   Mon, 14 Dec 2020 15:38:32 +0200
Message-Id: <20201214133832.438945-1-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.29.2

