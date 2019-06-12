Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D37A42F5E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfFLSwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:52:31 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34370 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:52:31 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so7385661qkt.1
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+qRZCLWeYyL7AiMKUPOUUuUoHJTdcKKfTN9LYgXV6GA=;
        b=kkDcH8sYBK52aZhJz9cLUwG6gXGC3VP+Nom7SEPJ8F/z/gcrJ2geFZ/GkBj2287faT
         mWn9HmqMRZffObhYvumFGnZlT/mOdMbk+oSeHCJZergtImiIIWvyYJ5qOp/T+NJ/n3IP
         Ixsv4NS2OoSzKtg6c8TK5huw/r8rKJsG0sabIht05lFmpnt9ckIm6JlEmkXPDxjg0LV2
         fjeFP3A0rq10QZu8U5TUvNBYtOVltb5AqV0w1K1LNSogugQGKZgdijyyDcKFgHZiyNYg
         ZKbhIzwItrxVK6e8D4JQnxO3gHb7R++SnzmGAHGl0YFGKiy5s0h2UZR+IhyPPwkBRJRW
         orpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+qRZCLWeYyL7AiMKUPOUUuUoHJTdcKKfTN9LYgXV6GA=;
        b=KpGEC8jcYZLeOzD8zPqefxoJNo27uphkdzfG1t7QwBmmqsVvbWuMMX0TAPpTrS8mzT
         1CgzpKSDTOwODxDH5gykx/2BUjDBBhdbLwkxS0+87416laVxqDhEt/0Uxurpo+C9TmTY
         G62xiCBpwEhuDDpfogK5bMxc/5Igtxkd1wYLaLLPeEROmlCb819DKRJSB1uR02BXLRcC
         lAdS31LprE2bDyJW9Hj2Psa6x1AbRoFNuJtjQpULBG+ahmS5FZWSY91WE7DI3RAthLfW
         a4uAjWCx3VafP5bZ9e66hectrcL3ijIl8MwiF9wLtTmMXKQMlzslyCYzGgSo8rmyd6K1
         uG2A==
X-Gm-Message-State: APjAAAVcDMBJ9oB4Q4MIJJlpPowRzEE8s0qn5Od0JvUzwt2AcKRzE7Wj
        AK0PlTFrzi9MLfxgqp81YWsfoA==
X-Google-Smtp-Source: APXvYqxdn/mEBBN4kebXpudyqKNEMKS0pz4lQ8LpzQNEERC4FKNU37F9Qu9OP5Ksvp9VrcytmTXYmw==
X-Received: by 2002:a37:ea16:: with SMTP id t22mr68504341qkj.337.1560365550264;
        Wed, 12 Jun 2019 11:52:30 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u2sm303692qtj.97.2019.06.12.11.52.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 11:52:29 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, edumazet@google.com, posk@google.com
Subject: [PATCH net] net: netem: fix use after free and double free with packet corruption
Date:   Wed, 12 Jun 2019 11:51:21 -0700
Message-Id: <20190612185121.4175-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brendan reports that the use of netem's packet corruption capability
leads to strange crashes.  This seems to be caused by
commit d66280b12bd7 ("net: netem: use a list in addition to rbtree")
which uses skb->next pointer to construct a fast-path queue of
in-order skbs.

Packet corruption code has to invoke skb_gso_segment() in case
of skbs in need of GSO.  skb_gso_segment() returns a list of
skbs.  If next pointers of the skbs on that list do not get cleared
fast path list goes into the weeds and tries to access the next
segment skb multiple times.

Reported-by: Brendan Galloway <brendan.galloway@netronome.com>
Fixes: d66280b12bd7 ("net: netem: use a list in addition to rbtree")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/sched/sch_netem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 956ff3da81f4..1fd4405611e5 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -494,16 +494,13 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (q->corrupt && q->corrupt >= get_crandom(&q->corrupt_cor)) {
 		if (skb_is_gso(skb)) {
-			segs = netem_segment(skb, sch, to_free);
-			if (!segs)
+			skb = netem_segment(skb, sch, to_free);
+			if (!skb)
 				return rc_drop;
-		} else {
-			segs = skb;
+			segs = skb->next;
+			skb_mark_not_on_list(skb);
 		}
 
-		skb = segs;
-		segs = segs->next;
-
 		skb = skb_unshare(skb, GFP_ATOMIC);
 		if (unlikely(!skb)) {
 			qdisc_qstats_drop(sch);
-- 
2.21.0

