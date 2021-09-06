Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EDC401E39
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244010AbhIFQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:27:44 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:38065 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243691AbhIFQ1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 12:27:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 17DF6CC00FD;
        Mon,  6 Sep 2021 18:26:37 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  6 Sep 2021 18:26:34 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id D1CDBCC00FC;
        Mon,  6 Sep 2021 18:26:34 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id C8F8D340D60; Mon,  6 Sep 2021 18:26:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id C4B2B340D5D;
        Mon,  6 Sep 2021 18:26:34 +0200 (CEST)
Date:   Mon, 6 Sep 2021 18:26:34 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH 1/1] netfilter: ipset: Fix oversized kvmalloc() calls
Message-ID: <4591ee34-aa44-92d-51a8-22e8be5db20@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 09:45:49 2021 -0700

    mm: don't allow oversized kvmalloc() calls

limits the max allocatable memory via kvmalloc() to MAX_INT. Apply the
same limit in ipset.

Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com
Reported-by: syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com
Reported-by: syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6186358eac7c..6e391308431d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -130,11 +130,11 @@ htable_size(u8 hbits)
 {
 	size_t hsize;
 
-	/* We must fit both into u32 in jhash and size_t */
+	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable)) / sizeof(struct hbucket *)
+	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 
-- 
2.20.1

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
