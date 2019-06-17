Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083E349550
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfFQWmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:42:35 -0400
Received: from mail.us.es ([193.147.175.20]:36216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbfFQWmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:42:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1A82BEBA6
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:42:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93494DA708
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:42:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9299CDA707; Tue, 18 Jun 2019 00:42:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81755DA70C;
        Tue, 18 Jun 2019 00:42:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:42:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 50A144265A2F;
        Tue, 18 Jun 2019 00:42:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/3] netfilter: ipv6: nf_defrag: accept duplicate fragments again
Date:   Tue, 18 Jun 2019 00:42:23 +0200
Message-Id: <20190617224223.1004-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190617224223.1004-1-pablo@netfilter.org>
References: <20190617224223.1004-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

When fixing the skb leak introduced by the conversion to rbtree, I
forgot about the special case of duplicate fragments. The condition
under the 'insert_error' label isn't effective anymore as
nf_ct_frg6_gather() doesn't override the returned value anymore. So
duplicate fragments now get NF_DROP verdict.

To accept duplicate fragments again, handle them specially as soon as
inet_frag_queue_insert() reports them. Return -EINPROGRESS which will
translate to NF_STOLEN verdict, like any accepted fragment. However,
such packets don't carry any new information and aren't queued, so we
just drop them immediately.

Fixes: a0d56cb911ca ("netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5b3f65e29b6f..8951de8b568f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -265,8 +265,14 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 
 	prev = fq->q.fragments_tail;
 	err = inet_frag_queue_insert(&fq->q, skb, offset, end);
-	if (err)
+	if (err) {
+		if (err == IPFRAG_DUP) {
+			/* No error for duplicates, pretend they got queued. */
+			kfree_skb(skb);
+			return -EINPROGRESS;
+		}
 		goto insert_error;
+	}
 
 	if (dev)
 		fq->iif = dev->ifindex;
@@ -304,8 +310,6 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	return -EINPROGRESS;
 
 insert_error:
-	if (err == IPFRAG_DUP)
-		goto err;
 	inet_frag_kill(&fq->q);
 err:
 	skb_dst_drop(skb);
-- 
2.11.0

