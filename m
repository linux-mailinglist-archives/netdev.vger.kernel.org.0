Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACDC150121
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgBCFO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:14:58 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40117 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgBCFO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 00:14:58 -0500
Received: by mail-pl1-f193.google.com with SMTP id y1so5352310plp.7
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 21:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4MOIQw1tBZmfRePPY8LylCz80OhJk3nXpzzSUsoXyg=;
        b=Cz2ycYgo/tze7bKAGgjJVeK0NQbKvCJogkyb2rV8ReR82X9lgreNDnFUPwtEgwQDp/
         7g0rDCaeY82dy9eTO1i6Yp+Nr6Xaf4WHY0e3z1wnLCSSwTMdbOaZqwCpQDPyuaEuv3m1
         5uFKHsLkIAqRW8oaxwqbDlRbK3SXpysmWhK+kwG5MJQJGaCIDMxifwbW7AVsSsyKhGd4
         foOspYKaPTP54mPvbxVyPlpzdvNCpzoPNPAbRIcvcY4GfWM7HUTWJmWv9gL+QUFxTpin
         o2hIjJViokg10fGni7XyBNGwZbBPuoIopx38LoGInYO15zJWac4ViWENoVOPllBWNAh7
         ogLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E4MOIQw1tBZmfRePPY8LylCz80OhJk3nXpzzSUsoXyg=;
        b=N1lD+djI30LXimUwGXfp3dYvo0v3R2smiF5tjvhjc/MeB0+aNSh7pBP4xDHHXzi346
         fuQLMU0h0CcvMtVE1YTSoCk69pcs9Fc/9X8a+bkweOGMiyOEeWry3S0SXg7H3sGXArv+
         azkAkyEpi5buQ9BYiTAVbb8TXFq7vtsSx0M9wty4tsOSPnvq460kWzoA6JcSt4mToNW+
         rLB0mIMx3+7uhfnyjjoYIKWEhSeAVdDnBOZTsBP0GyA2IVbQe57L8+Ftl2o0Z7dRT7M0
         oWhNWBp+7ullhkb8jeluKeLk5/kHs4neTEu8AzsFcbR6sHqHycy4niDdS0otHZFoByOi
         lcBg==
X-Gm-Message-State: APjAAAWtpRwHrIwh+61libEL9cOqypaZ7Zldbos0y9iz3PMfsrqBVh0/
        X0/Yd8VOzbmxxcWY53o5hu5DDQoAx90=
X-Google-Smtp-Source: APXvYqw9ExsoMiU/l52xcFs/a4GuXkpeXca3GGLzZYvV3daHem06AVc9gxyhIAMBzL/Be6tJgBShmQ==
X-Received: by 2002:a17:902:820b:: with SMTP id x11mr21950600pln.196.1580706897708;
        Sun, 02 Feb 2020 21:14:57 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 28sm14476636pgl.42.2020.02.02.21.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 21:14:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Subject: [Patch net v2] net_sched: fix an OOB access in cls_tcindex
Date:   Sun,  2 Feb 2020 21:14:35 -0800
Message-Id: <20200203051435.11272-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Eric noticed, tcindex_alloc_perfect_hash() uses cp->hash
to compute the size of memory allocation, but cp->hash is
set again after the allocation, this caused an out-of-bound
access.

So we have to move all cp->hash initialization and computation
before the memory allocation. Move cp->mask and cp->shift together
as cp->hash may need them for computation too.

Reported-and-tested-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 3d4a1280352f..0323aee03de7 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -333,12 +333,31 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	cp->fall_through = p->fall_through;
 	cp->tp = tp;
 
+	if (tb[TCA_TCINDEX_HASH])
+		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
+
+	if (tb[TCA_TCINDEX_MASK])
+		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
+
+	if (tb[TCA_TCINDEX_SHIFT])
+		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
+
+	if (!cp->hash) {
+		/* Hash not specified, use perfect hash if the upper limit
+		 * of the hashing index is below the threshold.
+		 */
+		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
+			cp->hash = (cp->mask >> cp->shift) + 1;
+		else
+			cp->hash = DEFAULT_HASH_SIZE;
+	}
+
 	if (p->perfect) {
 		int i;
 
 		if (tcindex_alloc_perfect_hash(net, cp) < 0)
 			goto errout;
-		for (i = 0; i < cp->hash; i++)
+		for (i = 0; i < min(cp->hash, p->hash); i++)
 			cp->perfect[i].res = p->perfect[i].res;
 		balloc = 1;
 	}
@@ -350,15 +369,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	if (old_r)
 		cr = r->res;
 
-	if (tb[TCA_TCINDEX_HASH])
-		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
-
-	if (tb[TCA_TCINDEX_MASK])
-		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
-
-	if (tb[TCA_TCINDEX_SHIFT])
-		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-
 	err = -EBUSY;
 
 	/* Hash already allocated, make sure that we still meet the
@@ -376,16 +386,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	if (tb[TCA_TCINDEX_FALL_THROUGH])
 		cp->fall_through = nla_get_u32(tb[TCA_TCINDEX_FALL_THROUGH]);
 
-	if (!cp->hash) {
-		/* Hash not specified, use perfect hash if the upper limit
-		 * of the hashing index is below the threshold.
-		 */
-		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
-			cp->hash = (cp->mask >> cp->shift) + 1;
-		else
-			cp->hash = DEFAULT_HASH_SIZE;
-	}
-
 	if (!cp->perfect && !cp->h)
 		cp->alloc_hash = cp->hash;
 
-- 
2.21.1

