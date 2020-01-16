Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3EC13E72C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390647AbgAPRNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:13:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732928AbgAPRNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:13:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C672469A;
        Thu, 16 Jan 2020 17:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194785;
        bh=vVBgfAgrUKbiJfJ+p2gwwtvtOIeZjbHCGsOwRk3w3v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DP01mDaPqUKEw9+e+mRDmyE6xKMcA06ktmrz4UKejyIa2yw7OdtmVy2qgx+oJReW
         UYTxeYo+DW2eqNvLne/2GbiUWwHX0zdJ9ZAS6SpKKsgSgZwqv+dF1smliFz2Zm0dTa
         l2udGtPgqH5ynPUWD434Q7/Hpda3BqXOO48lNNzk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 600/671] net: netem: fix error path for corrupted GSO frames
Date:   Thu, 16 Jan 2020 12:03:58 -0500
Message-Id: <20200116170509.12787-337-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit a7fa12d15855904aff1716e1fc723c03ba38c5cc ]

To corrupt a GSO frame we first perform segmentation.  We then
proceed using the first segment instead of the full GSO skb and
requeue the rest of the segments as separate packets.

If there are any issues with processing the first segment we
still want to process the rest, therefore we jump to the
finish_segs label.

Commit 177b8007463c ("net: netem: fix backlog accounting for
corrupted GSO frames") started using the pointer to the first
segment in the "rest of segments processing", but as mentioned
above the first segment may had already been freed at this point.

Backlog corrections for parent qdiscs have to be adjusted.

Fixes: 177b8007463c ("net: netem: fix backlog accounting for corrupted GSO frames")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 1cd7266140e6..7660aa5b80da 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -509,6 +509,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb)) {
 			qdisc_drop(skb, sch, to_free);
+			skb = NULL;
 			goto finish_segs;
 		}
 
@@ -584,9 +585,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 finish_segs:
 	if (segs) {
 		unsigned int len, last_len;
-		int nb = 0;
+		int nb;
 
-		len = skb->len;
+		len = skb ? skb->len : 0;
+		nb = skb ? 1 : 0;
 
 		while (segs) {
 			skb2 = segs->next;
@@ -603,7 +605,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			}
 			segs = skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		/* Parent qdiscs accounted for 1 skb of size @prev_len */
+		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.20.1

