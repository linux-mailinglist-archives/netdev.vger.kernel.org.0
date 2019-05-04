Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F601398F
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfEDLrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:24 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46802 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfEDLrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id i31so9682919qti.13
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pFIHOirtnJtH94H68TfIrsic9+mHJebIqhaVfmtn/C4=;
        b=ciTS8f/8SxaiSBXALIMgeVi1TMoytNK8VX5LK2qVwF29FjuL4mlv4ePKgmFPH3oLMG
         AW9nhg+gnRT3b5g2brkWCy+5C4Zy9GFEogWpxbVq9kxap9VJlDDLoSkbki5BxYJS44RE
         jZSgg+a0zMy8psjHt7YD11wX+AcW58YqdlpICvYIxRs7ybvHIJNd7K6gJQGSMkaxm5Ii
         OF+/wUALEbaoYT3c61Jc55/SA4bv+tLdfgoLDtuGGHuLm0LFjLe07h8XcU/TjFSbY6M1
         l1XpuGkzFfDGf2AvXoEFBTTSZMVrF40BvGt1ovWKrH8r9qhKc9SHme0YdGXBdiz2sG/f
         rd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pFIHOirtnJtH94H68TfIrsic9+mHJebIqhaVfmtn/C4=;
        b=dS2ok4jFJ4KFtTL8AJuoZHez0EayYo+LAo4NOnEPndMXUavol6RjYpXvOTRiQntWAM
         ve4LsxTzws1pmHWWdMbzfCGPcW7dfj9ESXhlxkUfCK133Bwyp+tcBpqg8NCYWkfrhawg
         MYjk4tDN5LCPJUNRh1DfuT4dFmh6XP55PfVRss+ZPHCCcO8/1vb9oD3vxaOTfo9MPykp
         LAjvGfnCXXi+DUAjJgzJM729QodKsTEH/SNEGQmX1t/wfMsxtKCMBAGya40+gfBAmRx+
         BLFZ9ki2dfBkUpbC4J6D3WL4PKhuGk74UVk+FFoDvMh2psYVpf7MWDy0xPdHQCWLd72f
         Z8rA==
X-Gm-Message-State: APjAAAURMdHi/F0pv9p+Btcu8vXo7eZfyoz9+3o8KgJKvU1zY0bBW8zL
        IktT8sEchXOhBCPUmDxO20ZSzg==
X-Google-Smtp-Source: APXvYqwCP4FCz7cabtRUf9T1TkNyYBj5GYgxBw1qWgA5Fpu71LI0OoRsA+PWASv8+UwYWM8+SKBhIg==
X-Received: by 2002:a0c:b5c2:: with SMTP id o2mr12440400qvf.58.1556970440778;
        Sat, 04 May 2019 04:47:20 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:20 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 10/13] net/sched: add block pointer to tc_cls_common_offload structure
Date:   Sat,  4 May 2019 04:46:25 -0700
Message-Id: <20190504114628.14755-11-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Some actions like the police action are stateful and could share state
between devices. This is incompatible with offloading to multiple devices
and drivers might want to test for shared blocks when offloading.
Store a pointer to the tcf_block structure in the tc_cls_common_offload
structure to allow drivers to determine when offloads apply to a shared
block.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/pkt_cls.h    |  8 ++++++++
 net/sched/cls_bpf.c      |  7 ++++---
 net/sched/cls_flower.c   | 11 +++++++----
 net/sched/cls_matchall.c | 12 ++++++++----
 net/sched/cls_u32.c      | 17 +++++++++++------
 5 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 161fcf8516ac..eed98f8fcb5e 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -100,6 +100,11 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode);
 
 #else
+static inline bool tcf_block_shared(struct tcf_block *block)
+{
+	return false;
+}
+
 static inline
 int tcf_block_get(struct tcf_block **p_block,
 		  struct tcf_proto __rcu **p_filter_chain, struct Qdisc *q,
@@ -624,6 +629,7 @@ struct tc_cls_common_offload {
 	u32 chain_index;
 	__be16 protocol;
 	u32 prio;
+	struct tcf_block *block;
 	struct netlink_ext_ack *extack;
 };
 
@@ -725,11 +731,13 @@ static inline bool tc_in_hw(u32 flags)
 static inline void
 tc_cls_common_offload_init(struct tc_cls_common_offload *cls_common,
 			   const struct tcf_proto *tp, u32 flags,
+			   struct tcf_block *block,
 			   struct netlink_ext_ack *extack)
 {
 	cls_common->chain_index = tp->chain->index;
 	cls_common->protocol = tp->protocol;
 	cls_common->prio = tp->prio;
+	cls_common->block = block;
 	if (tc_skip_sw(flags) || flags & TCA_CLS_FLAGS_VERBOSE)
 		cls_common->extack = extack;
 }
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 9bcf499cce0c..ce7ff286ccb8 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -157,7 +157,7 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 	skip_sw = prog && tc_skip_sw(prog->gen_flags);
 	obj = prog ?: oldprog;
 
-	tc_cls_common_offload_init(&cls_bpf.common, tp, obj->gen_flags,
+	tc_cls_common_offload_init(&cls_bpf.common, tp, obj->gen_flags, block,
 				   extack);
 	cls_bpf.command = TC_CLSBPF_OFFLOAD;
 	cls_bpf.exts = &obj->exts;
@@ -227,7 +227,8 @@ static void cls_bpf_offload_update_stats(struct tcf_proto *tp,
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_bpf_offload cls_bpf = {};
 
-	tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags, NULL);
+	tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags, block,
+				   NULL);
 	cls_bpf.command = TC_CLSBPF_STATS;
 	cls_bpf.exts = &prog->exts;
 	cls_bpf.prog = prog->filter;
@@ -669,7 +670,7 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			continue;
 
 		tc_cls_common_offload_init(&cls_bpf.common, tp, prog->gen_flags,
-					   extack);
+					   block, extack);
 		cls_bpf.command = TC_CLSBPF_OFFLOAD;
 		cls_bpf.exts = &prog->exts;
 		cls_bpf.prog = add ? prog->filter : NULL;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index f6685fc53119..3cb372b0e933 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -389,7 +389,8 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 	if (!rtnl_held)
 		rtnl_lock();
 
-	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, block,
+				   extack);
 	cls_flower.command = TC_CLSFLOWER_DESTROY;
 	cls_flower.cookie = (unsigned long) f;
 
@@ -422,7 +423,8 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	}
 
-	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, block,
+				   extack);
 	cls_flower.command = TC_CLSFLOWER_REPLACE;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.rule->match.dissector = &f->mask->dissector;
@@ -478,7 +480,8 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 	if (!rtnl_held)
 		rtnl_lock();
 
-	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
+	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, block,
+				   NULL);
 	cls_flower.command = TC_CLSFLOWER_STATS;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.classid = f->res.classid;
@@ -1757,7 +1760,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 		}
 
 		tc_cls_common_offload_init(&cls_flower.common, tp, f->flags,
-					   extack);
+					   block, extack);
 		cls_flower.command = add ?
 			TC_CLSFLOWER_REPLACE : TC_CLSFLOWER_DESTROY;
 		cls_flower.cookie = (unsigned long)f;
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index da916f39b719..820938fa09ed 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -71,7 +71,8 @@ static void mall_destroy_hw_filter(struct tcf_proto *tp,
 	struct tc_cls_matchall_offload cls_mall = {};
 	struct tcf_block *block = tp->chain->block;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
+				   extack);
 	cls_mall.command = TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = cookie;
 
@@ -93,7 +94,8 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	if (!cls_mall.rule)
 		return -ENOMEM;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
+				   extack);
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
@@ -293,7 +295,8 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 	if (!cls_mall.rule)
 		return -ENOMEM;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
+				   extack);
 	cls_mall.command = add ?
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
@@ -328,7 +331,8 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	struct tc_cls_matchall_offload cls_mall = {};
 	struct tcf_block *block = tp->chain->block;
 
-	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, NULL);
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, block,
+				   NULL);
 	cls_mall.command = TC_CLSMATCHALL_STATS;
 	cls_mall.cookie = cookie;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4b8710a266cc..2feed0ffa269 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -485,7 +485,8 @@ static void u32_clear_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, h->flags, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, h->flags, block,
+				   extack);
 	cls_u32.command = TC_CLSU32_DELETE_HNODE;
 	cls_u32.hnode.divisor = h->divisor;
 	cls_u32.hnode.handle = h->handle;
@@ -503,7 +504,7 @@ static int u32_replace_hw_hnode(struct tcf_proto *tp, struct tc_u_hnode *h,
 	bool offloaded = false;
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, flags, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, flags, block, extack);
 	cls_u32.command = TC_CLSU32_NEW_HNODE;
 	cls_u32.hnode.divisor = h->divisor;
 	cls_u32.hnode.handle = h->handle;
@@ -529,7 +530,8 @@ static void u32_remove_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, block,
+				   extack);
 	cls_u32.command = TC_CLSU32_DELETE_KNODE;
 	cls_u32.knode.handle = n->handle;
 
@@ -546,7 +548,7 @@ static int u32_replace_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	bool skip_sw = tc_skip_sw(flags);
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, flags, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, flags, block, extack);
 	cls_u32.command = TC_CLSU32_REPLACE_KNODE;
 	cls_u32.knode.handle = n->handle;
 	cls_u32.knode.fshift = n->fshift;
@@ -1170,10 +1172,12 @@ static int u32_reoffload_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 			       bool add, tc_setup_cb_t *cb, void *cb_priv,
 			       struct netlink_ext_ack *extack)
 {
+	struct tcf_block *block = tp->chain->block;
 	struct tc_cls_u32_offload cls_u32 = {};
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, ht->flags, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, ht->flags, block,
+				   extack);
 	cls_u32.command = add ? TC_CLSU32_NEW_HNODE : TC_CLSU32_DELETE_HNODE;
 	cls_u32.hnode.divisor = ht->divisor;
 	cls_u32.hnode.handle = ht->handle;
@@ -1195,7 +1199,8 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	struct tc_cls_u32_offload cls_u32 = {};
 	int err;
 
-	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, extack);
+	tc_cls_common_offload_init(&cls_u32.common, tp, n->flags, block,
+				   extack);
 	cls_u32.command = add ?
 		TC_CLSU32_REPLACE_KNODE : TC_CLSU32_DELETE_KNODE;
 	cls_u32.knode.handle = n->handle;
-- 
2.21.0

