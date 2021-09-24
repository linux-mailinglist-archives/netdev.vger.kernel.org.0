Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FE3417D93
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345637AbhIXWNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49758 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhIXWMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:12:54 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id CFA8C63EA7;
        Sat, 25 Sep 2021 00:09:58 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 01/15] netfilter: ipset: Fix oversized kvmalloc() calls
Date:   Sat, 25 Sep 2021 00:10:59 +0200
Message-Id: <20210924221113.348767-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

