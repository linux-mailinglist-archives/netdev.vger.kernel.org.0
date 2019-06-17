Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7547948B86
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfFQSLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:11:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45450 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfFQSLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:11:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id j19so11845398qtr.12
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OLcMrwIGxGfiBP59PlNzaCCXz7xv1kWBjQx2oRR1Rhc=;
        b=C0szVlzbpe3g6UOW22Ys3sdL1YQZda+KO6tcAtJ51fW0+Vi47i+7m58sc98NFcyysd
         f9ayG5/X6RHkhUasWuFNslLXr/nRQdQGJdlKRItXUpaWYju05QXrC/2YrtkL41jTsFTl
         y4JF29Tj142wrhuaagHUib51rtHu3DXYcjaoL40XtCMaRVUkYG0JnuFI5L+gfxUxEUnj
         yND2w8N2HPydbWvZgqjj3I1+mL6ddieFMoNJ0mEAVa6nVNRqtDP6RhmgL/HtwfIoLJJ4
         IYy1Hv46PGybG0RMe7e02rvY99lTHZozTuD/sgNWtrzuj1IrAWTm7PguTtbDF7NUDxqg
         FjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OLcMrwIGxGfiBP59PlNzaCCXz7xv1kWBjQx2oRR1Rhc=;
        b=sq8juFYH8fS2SyQGMV2glOHu6f0sGAKVpnB9mfldcyrZ+idB8JvdGDrlzFas29ONNj
         KztabdZpKrsV3dJeuZKqPNfnMcd9I7jy6mE3MQo1KLErFkl6fpeZzXSx5GudVPs7Ca5s
         63w6EqZOCdWdSECuExy5nJEsLk/Amu3FjDWD9Qk/bELD15CGoLYLVCKzZqjACCGilVSm
         xmY6ejliSIv42mTljVgJ811B/Bpn8OkvYRUuZR+h0nftlFyF2EAnZ19iU+mxCTGjpv3Z
         z0ayzY+BdZxT8N8jIfIdp+YcYVwShVFRwStop0gzkc/HDYx4loIX/WTWEyqjVVvUyxjK
         e+ww==
X-Gm-Message-State: APjAAAUcK8VhY4tPthqL2ofkvdH9yRWoCga5gBxVRwa2BhMeV6ptLHV9
        msThOMYGKsOKeXMmH41sYSI/hw==
X-Google-Smtp-Source: APXvYqzD0Ja6so/a+AZf+grGMi9cjkQzrrVtQwPPUetv+lpori5bW/JG1nikeF+yai65Z2WlhDA+dA==
X-Received: by 2002:a0c:adef:: with SMTP id x44mr22810137qvc.153.1560795092607;
        Mon, 17 Jun 2019 11:11:32 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x10sm9048564qtc.34.2019.06.17.11.11.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 11:11:32 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, xiyou.wangcong@gmail.com
Cc:     stephen@networkplumber.org, jhs@mojatatu.com, jiri@resnulli.us,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, edumazet@google.com, posk@google.com,
        nhorman@tuxdriver.com
Subject: [PATCH net v2 1/2] net: netem: fix backlog accounting for corrupted GSO frames
Date:   Mon, 17 Jun 2019 11:11:10 -0700
Message-Id: <20190617181111.5025-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617181111.5025-1-jakub.kicinski@netronome.com>
References: <20190617181111.5025-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When GSO frame has to be corrupted netem uses skb_gso_segment()
to produce the list of frames, and re-enqueues the segments one
by one.  The backlog length has to be adjusted to account for
new frames.

The current calculation is incorrect, leading to wrong backlog
lengths in the parent qdisc (both bytes and packets), and
incorrect packet backlog count in netem itself.

Parent backlog goes negative, netem's packet backlog counts
all non-first segments twice (thus remaining non-zero even
after qdisc is emptied).

Move the variables used to count the adjustment into local
scope to make 100% sure they aren't used at any stage in
backports.

Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/sched/sch_netem.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 956ff3da81f4..3b3e2d772c3b 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -439,8 +439,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct netem_skb_cb *cb;
 	struct sk_buff *skb2;
 	struct sk_buff *segs = NULL;
-	unsigned int len = 0, last_len, prev_len = qdisc_pkt_len(skb);
-	int nb = 0;
+	unsigned int prev_len = qdisc_pkt_len(skb);
 	int count = 1;
 	int rc = NET_XMIT_SUCCESS;
 	int rc_drop = NET_XMIT_DROP;
@@ -497,6 +496,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			segs = netem_segment(skb, sch, to_free);
 			if (!segs)
 				return rc_drop;
+			qdisc_skb_cb(segs)->pkt_len = segs->len;
 		} else {
 			segs = skb;
 		}
@@ -593,6 +593,11 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 finish_segs:
 	if (segs) {
+		unsigned int len, last_len;
+		int nb = 0;
+
+		len = skb->len;
+
 		while (segs) {
 			skb2 = segs->next;
 			skb_mark_not_on_list(segs);
@@ -608,9 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			}
 			segs = skb2;
 		}
-		sch->q.qlen += nb;
-		if (nb > 1)
-			qdisc_tree_reduce_backlog(sch, 1 - nb, prev_len - len);
+		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.21.0

