Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC37CF836
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfJHLbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:31:03 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:6372 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730696AbfJHLbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1669; q=dns/txt; s=iport;
  t=1570534262; x=1571743862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=E6mvPI/jrMzl8BMFUt1v1Gx63mXyoc7xO3NymshYyTA=;
  b=ELlWEXj3IHwAunXjUFeT5uzqHOjdaLvt5x87pAiE9wedod4hVfP/PSot
   nJJtpPT9b6EojQGVQj+HiiaiON9/xiI8GTxIrImX3QLtxzdW63YaCL4KZ
   SeM8pDjIeFHAbA3NsMMrdygrvbPpoEz4Y+l9S9ZDVnpU9oIQfs19lsd+Z
   w=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17697350"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:55 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe53031991;
        Tue, 8 Oct 2019 11:23:55 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 stable 05/10] netfilter: ipv6: nf_defrag: fix NULL deref panic
Date:   Tue,  8 Oct 2019 13:23:04 +0200
Message-Id: <20191008112309.9571-6-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e97ac12859db ("netfilter: ipv6: nf_defrag: fix NULL deref panic")
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Dec 8 23:35:19 2015 +0100

Valdis reports NULL deref in nf_ct_frag6_gather.
Problem is bogus use of skb_queue_walk() -- we miss first skb in the list
since we start with head->next instead of head.

In case the element we're looking for was head->next we won't find
a result and then trip over NULL iter.

(defrag uses plain NULL-terminated list rather than one terminated by
head-of-list-pointer, which is what skb_queue_walk expects).

Fixes: 029f7f3b8701cc7a ("netfilter: ipv6: nf_defrag: avoid/free clone operations")
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 394aeb1..5640e041 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -415,11 +415,14 @@ nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *prev,  struct net_devic
 			return false;
 
 		fp->next = prev->next;
-		skb_queue_walk(head, iter) {
-			if (iter->next != prev)
-				continue;
-			iter->next = fp;
-			break;
+
+		iter = head;
+		while (iter) {
+			if (iter->next == prev) {
+				iter->next = fp;
+				break;
+			}
+			iter = iter->next;
 		}
 
 		skb_morph(prev, head);
-- 
2.10.2

