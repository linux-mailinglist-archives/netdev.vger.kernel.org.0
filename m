Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747462DA7F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfE2KZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:25:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40606 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfE2KZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:25:47 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hVvmC-0003is-8q; Wed, 29 May 2019 10:25:44 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 2/4] ip: fail fast on IP defrag errors
Date:   Wed, 29 May 2019 12:25:40 +0200
Message-Id: <20190529102542.17742-3-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529102542.17742-1-stefan.bader@canonical.com>
References: <20190529102542.17742-1-stefan.bader@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Oskolkov <posk@google.com>

The current behavior of IP defragmentation is inconsistent:
- some overlapping/wrong length fragments are dropped without
  affecting the queue;
- most overlapping fragments cause the whole frag queue to be dropped.

This patch brings consistency: if a bad fragment is detected,
the whole frag queue is dropped. Two major benefits:
- fail fast: corrupted frag queues are cleared immediately, instead of
  by timeout;
- testing of overlapping fragments is now much easier: any kind of
  random fragment length mutation now leads to the frag queue being
  discarded (IP packet dropped); before this patch, some overlaps were
  "corrected", with tests not seeing expected packet drops.

Note that in one case (see "if (end&7)" conditional) the current
behavior is preserved as there are concerns that this could be
legitimate padding.

Signed-off-by: Peter Oskolkov <posk@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

(backported from commit 0ff89efb524631ac9901b81446b453c29711c376)
[smb: context adjustments and ignoring those changes already done
      in backport for "net: ipv4: do not handle duplicate fragments
      as overlapping"]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 net/ipv4/ip_fragment.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 5387e6ab78d7..a53652c8c0fd 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -382,7 +382,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 		 */
 		if (end < qp->q.len ||
 		    ((qp->q.flags & INET_FRAG_LAST_IN) && end != qp->q.len))
-			goto err;
+			goto discard_qp;
 		qp->q.flags |= INET_FRAG_LAST_IN;
 		qp->q.len = end;
 	} else {
@@ -394,20 +394,20 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 		if (end > qp->q.len) {
 			/* Some bits beyond end -> corruption. */
 			if (qp->q.flags & INET_FRAG_LAST_IN)
-				goto err;
+				goto discard_qp;
 			qp->q.len = end;
 		}
 	}
 	if (end == offset)
-		goto err;
+		goto discard_qp;
 
 	err = -ENOMEM;
 	if (!pskb_pull(skb, skb_network_offset(skb) + ihl))
-		goto err;
+		goto discard_qp;
 
 	err = pskb_trim_rcsum(skb, end - offset);
 	if (err)
-		goto err;
+		goto discard_qp;
 
 	/* Note : skb->rbnode and skb->dev share the same location. */
 	dev = skb->dev;
@@ -434,7 +434,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 		/* This is the common case: skb goes to the end. */
 		/* Detect and discard overlaps. */
 		if (offset < prev_tail->ip_defrag_offset + prev_tail->len)
-			goto discard_qp;
+			goto overlap;
 		if (offset == prev_tail->ip_defrag_offset + prev_tail->len)
 			ip4_frag_append_to_last_run(&qp->q, skb);
 		else
@@ -457,7 +457,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 				 end <= skb1_run_end)
 				goto err; /* No new data, potential duplicate */
 			else
-				goto discard_qp; /* Found an overlap */
+				goto overlap; /* Found an overlap */
 		} while (*rbn);
 		/* Here we have parent properly set, and rbn pointing to
 		 * one of its NULL left/right children. Insert skb.
@@ -494,15 +494,18 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 		skb->_skb_refdst = 0UL;
 		err = ip_frag_reasm(qp, skb, prev_tail, dev);
 		skb->_skb_refdst = orefdst;
+		if (err)
+			inet_frag_kill(&qp->q);
 		return err;
 	}
 
 	skb_dst_drop(skb);
 	return -EINPROGRESS;
 
+overlap:
+	IP_INC_STATS_BH(net, IPSTATS_MIB_REASM_OVERLAPS);
 discard_qp:
 	inet_frag_kill(&qp->q);
-	IP_INC_STATS_BH(net, IPSTATS_MIB_REASM_OVERLAPS);
 err:
 	kfree_skb(skb);
 	return err;
-- 
2.17.1

