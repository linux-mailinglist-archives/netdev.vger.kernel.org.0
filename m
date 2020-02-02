Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3CE14FEBD
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 19:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgBBSUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 13:20:19 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43761 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgBBSUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 13:20:19 -0500
Received: by mail-pg1-f194.google.com with SMTP id u131so6527203pgc.10
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 10:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=68R/uEyiTaSgTq/VZ0Z5OXVbbDqLwzkIjDfuEBNv2Cs=;
        b=RDT1MbFYVbPL5fS/i7u16bZ5xXG1m/OY87R/XFN8yP72JCeEUwb3oxFqimeHEWw+Fy
         luJhhqNR/6uX+XaU5rPjql9E23XA+6f9wyh/IihhUU5V5X0RJGS7u7d6UGvj/9pAmDJp
         kVph7LuMnQK1PBxUO6RTTc6ZluHXq26GOwl7v3eDAWkXLFapmeqR437m6T88rxhjQY+M
         YT4TQv8g/Y3gu/e/I37KlST3OJfSb5YIqeDvRSQNaTFe52NbvoicHWsUB++M53ZuUvfs
         4t8rY16AXT4OOpd8ukVXDu/Rhx66xVk8gQ5oTi6OC4VpVlV1X1QR3He/PSiWlOGiJG4J
         znMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=68R/uEyiTaSgTq/VZ0Z5OXVbbDqLwzkIjDfuEBNv2Cs=;
        b=PLbqjIBu/m28QPP06G+IqKJYGbP8XaAg+FLiRa804AR2NLiQflUv1aV9VA725TBXoy
         /d2vRdY6FMLf8D9o27yPnUpRcfIqFae8DEjVKm/ydC7Z+++a09Q5vFdw7vf/Y/kpP2mz
         /rPlkK9vNmTz34JDuOkPK+1IhdsxkjUgoDgbpzf6xwYgKqjgM7YZBxdTVPFQ3Dw+YYSq
         32bo7nEfe03xJwxE8uj3xyO4S9Bt7/URugfpxs7E4Bq5Vg4SGpCS7ItgfDH0OwlgZOX6
         3o+eEhWEnaepM50jzFWQfmTAjLicFcfMW1lfHL7U2y4Vt58DWND63DL4VYuZGFP2FwXi
         uTsA==
X-Gm-Message-State: APjAAAWEU/Bu2KfcADejvs897KKoEh8hcme30l2bOn8LI+kgFAWV4fr+
        CAETlnbDAQ/UVsYEUuaNlPAPcUhQCDU=
X-Google-Smtp-Source: APXvYqx33kLDTZKblSSemGpNdV8PT7W69yttyW6GQmdNqZHAcrlIkp1+4lKxWpwfBDFQwBXrGpwvJg==
X-Received: by 2002:a63:3c2:: with SMTP id 185mr5310488pgd.72.1580667618256;
        Sun, 02 Feb 2020 10:20:18 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id g11sm16778083pgd.26.2020.02.02.10.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 10:20:17 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix an OOB access in cls_tcindex
Date:   Sun,  2 Feb 2020 10:19:50 -0800
Message-Id: <20200202181950.18439-1-xiyou.wangcong@gmail.com>
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
as cp->hash may need them for computation.

Reported-and-tested-by: syzbot+35d4dea36c387813ed31@syzkaller.appspotmail.com
Fixes: 331b72922c5f ("net: sched: RCU cls_tcindex")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 3d4a1280352f..2ba8c034fce8 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -333,6 +333,25 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
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

