Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABBEE5A1D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfJZLsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:03 -0400
Received: from correo.us.es ([193.147.175.20]:46456 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbfJZLsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:48:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B990F8C3C46
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A948DA7E9B
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E5F7A7E98; Sat, 26 Oct 2019 13:47:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A60E6A7EC5;
        Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 74B6D42EE393;
        Sat, 26 Oct 2019 13:47:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 28/31] netfilter: ecache: don't look for ecache extension on dying/unconfirmed conntracks
Date:   Sat, 26 Oct 2019 13:47:30 +0200
Message-Id: <20191026114733.28111-29-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reported following splat:
BUG: KASAN: use-after-free in __nf_ct_ext_exist
include/net/netfilter/nf_conntrack_extend.h:53 [inline]
BUG: KASAN: use-after-free in nf_ct_deliver_cached_events+0x5c3/0x6d0
net/netfilter/nf_conntrack_ecache.c:205
nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:65 [inline]
nf_confirm+0x3d8/0x4d0 net/netfilter/nf_conntrack_proto.c:154
[..]

While there is no reproducer yet, the syzbot report contains one
interesting bit of information:

Freed by task 27585:
[..]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 nf_ct_ext_destroy+0x2ab/0x2e0 net/netfilter/nf_conntrack_extend.c:38
 nf_conntrack_free+0x8f/0xe0 net/netfilter/nf_conntrack_core.c:1418
 destroy_conntrack+0x1a2/0x270 net/netfilter/nf_conntrack_core.c:626
 nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:31 [inline]
 nf_ct_resolve_clash net/netfilter/nf_conntrack_core.c:915 [inline]
 ^^^^^^^^^^^^^^^^^^^
 __nf_conntrack_confirm+0x21ca/0x2830 net/netfilter/nf_conntrack_core.c:1038
 nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:63 [inline]
 nf_confirm+0x3e7/0x4d0 net/netfilter/nf_conntrack_proto.c:154

This is whats happening:

1. a conntrack entry is about to be confirmed (added to hash table).
2. a clash with existing entry is detected.
3. nf_ct_resolve_clash() puts skb->nfct (the "losing" entry).
4. this entry now has a refcount of 0 and is freed to SLAB_TYPESAFE_BY_RCU
   kmem cache.

skb->nfct has been replaced by the one found in the hash.
Problem is that nf_conntrack_confirm() uses the old ct:

static inline int nf_conntrack_confirm(struct sk_buff *skb)
{
 struct nf_conn *ct = (struct nf_conn *)skb_nfct(skb);
 int ret = NF_ACCEPT;

  if (ct) {
    if (!nf_ct_is_confirmed(ct))
       ret = __nf_conntrack_confirm(skb);
    if (likely(ret == NF_ACCEPT))
	nf_ct_deliver_cached_events(ct); /* This ct has refcount 0! */
  }
  return ret;
}

As of "netfilter: conntrack: free extension area immediately", we can't
access conntrack extensions in this case.

To fix this, make sure we check the dying bit presence before attempting
to get the eache extension.

Reported-by: syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
Fixes: 2ad9d7747c10d1 ("netfilter: conntrack: free extension area immediately")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ecache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 0d83c159671c..7956c9f19899 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -202,15 +202,15 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 	if (notify == NULL)
 		goto out_unlock;
 
+	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
+		goto out_unlock;
+
 	e = nf_ct_ecache_find(ct);
 	if (e == NULL)
 		goto out_unlock;
 
 	events = xchg(&e->cache, 0);
 
-	if (!nf_ct_is_confirmed(ct) || nf_ct_is_dying(ct))
-		goto out_unlock;
-
 	/* We make a copy of the missed event cache without taking
 	 * the lock, thus we may send missed events twice. However,
 	 * this does not harm and it happens very rarely. */
-- 
2.11.0

