Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA0753B26F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiFBELU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiFBELC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:11:02 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8307520E143;
        Wed,  1 Jun 2022 21:11:01 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id br33so1152279qkb.0;
        Wed, 01 Jun 2022 21:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Az3H6mCcLLep4GQG4xmrMeX0CApw/c7B0McOWkC+2b8=;
        b=ZEbbYlCJucSlJQMPa7jJYrIXBeVmrgfcZbzfwCCYixi8LJJrIUtATUZWzgMuPn9xT1
         S5SHN8vxDn9XuQDmeYlHo5YL502ZfM/9EuGM8uraNw3/+LA3W9kgb2+0xibKYfJzacOn
         ADqchS9HKHPblH9NVmo1ye7zFhTay3fTe3Ndlokp+5s9YQqTYa6kuCZPpgsgDsydlyJC
         +IXLR+aWQCpFWe6lNspuPPol6rxf7sqjn0/J92i0xYMVdzSPV359nEA2N5Zy6FbL1sT/
         YXxj/YWCmF3+bgLMeL2igYlgBvSOopg7Op2x4v4X26r16sT7e1bpCTbz+y82ZlCu2Ln6
         mO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Az3H6mCcLLep4GQG4xmrMeX0CApw/c7B0McOWkC+2b8=;
        b=24A4WL3KQWXgEBonmAQuWsuG2NYqRMA5k6bXH9JJCoy1/JomrebPtiywuS4iYh62Oq
         7u1VBtjqRZ5fuI7CqzM4XElAR1mNE44ZTKWtxPQLiHgSPyhwNXxZC744Ih6zMjFjKIzz
         kyO0vE0jn/63yL5MAbGSNvX2Xwi4Nn+qikvJsPVSpwlorPAZ8q8IhVoDvOdziXZ+5UsK
         nuSPvc0AHCXGQ4qHLvOUdeS6dwn33kfhSskkunVJyGd8Psdf81DvX1KfTnzVPESv8TWh
         GT683vB2tW/wJmFtV3K23L1sR7tiE0dXcICuv+BI6hoL7TS/Tg5HiBqIsXZNo9OAleBg
         MuOw==
X-Gm-Message-State: AOAM531C9cOGZtoQVEUCIFtjbYifY3du8oTQdZcqVpevJhZKIO6PxEDq
        QxTjDDLA1yDy48xNez3y6+936qYxWkA=
X-Google-Smtp-Source: ABdhPJz2DL9X5fPeDRN+tyhgWl5xOOEkExXZI+yvpPoOEp5wv0h9RhLfe9purYSP8kkgqbxljSjxqA==
X-Received: by 2002:a37:be06:0:b0:6a1:429:a49f with SMTP id o6-20020a37be06000000b006a10429a49fmr2202768qkf.6.1654143060376;
        Wed, 01 Jun 2022 21:11:00 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:d7c6:fc22:5340:d891])
        by smtp.gmail.com with ESMTPSA id i187-20020a3786c4000000b0069fc13ce1fesm2396654qkd.47.2022.06.01.21.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 21:10:59 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v5 5/5] net_sched: introduce helper bpf_skb_tc_classify()
Date:   Wed,  1 Jun 2022 21:10:28 -0700
Message-Id: <20220602041028.95124-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Introduce an eBPF helper function bpf_skb_tc_classify() to reuse exising
TC filters on *any* Qdisc to classify the skb.

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/uapi/linux/bpf.h |  1 +
 net/core/filter.c        |  5 +++
 net/sched/cls_api.c      | 69 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 148ec0c4e643..ad65859abbd5 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5462,6 +5462,7 @@ union bpf_attr {
 	FN(skb_map_pop),		\
 	FN(flow_map_push),		\
 	FN(flow_map_pop),		\
+	FN(skb_tc_classify),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 1205298a17ca..8bd8cf5d5d20 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7817,6 +7817,7 @@ const struct bpf_func_proto bpf_skb_map_push_proto __weak;
 const struct bpf_func_proto bpf_skb_map_pop_proto __weak;
 const struct bpf_func_proto bpf_flow_map_push_proto __weak;
 const struct bpf_func_proto bpf_flow_map_pop_proto __weak;
+const struct bpf_func_proto bpf_skb_tc_classify_proto __weak;
 
 static const struct bpf_func_proto *
 tc_qdisc_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
@@ -7830,6 +7831,10 @@ tc_qdisc_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_flow_map_push_proto;
 	case BPF_FUNC_flow_map_pop:
 		return &bpf_flow_map_pop_proto;
+#ifdef CONFIG_NET_CLS_ACT
+	case BPF_FUNC_skb_tc_classify:
+		return &bpf_skb_tc_classify_proto;
+#endif
 	default:
 		return tc_cls_act_func_proto(func_id, prog);
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9bb4d3dcc994..86a78265bc31 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -22,6 +22,7 @@
 #include <linux/idr.h>
 #include <linux/jhash.h>
 #include <linux/rculist.h>
+#include <linux/filter.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -1654,6 +1655,74 @@ int tcf_classify(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(tcf_classify);
 
+#ifdef CONFIG_BPF_SYSCALL
+BPF_CALL_3(bpf_skb_tc_classify, struct sk_buff *, skb, int, ifindex, u32, handle)
+{
+	struct net *net = dev_net(skb->dev);
+	const struct Qdisc_class_ops *cops;
+	struct tcf_result res = {};
+	struct tcf_block *block;
+	struct tcf_chain *chain;
+	struct net_device *dev;
+	unsigned long cl = 0;
+	struct Qdisc *q;
+	int result;
+
+	rcu_read_lock();
+	dev = dev_get_by_index_rcu(net, ifindex);
+	if (!dev)
+		goto out;
+	q = qdisc_lookup_rcu(dev, handle);
+	if (!q)
+		goto out;
+
+	cops = q->ops->cl_ops;
+	if (!cops)
+		goto out;
+	if (!cops->tcf_block)
+		goto out;
+	if (TC_H_MIN(handle)) {
+		cl = cops->find(q, handle);
+		if (cl == 0)
+			goto out;
+	}
+	block = cops->tcf_block(q, cl, NULL);
+	if (!block)
+		goto out;
+
+	for (chain = tcf_get_next_chain(block, NULL);
+	     chain;
+	     chain = tcf_get_next_chain(block, chain)) {
+		struct tcf_proto *tp;
+
+		result = tcf_classify(skb, NULL, tp, &res, false);
+		if (result  >= 0) {
+			switch (result) {
+			case TC_ACT_QUEUED:
+			case TC_ACT_STOLEN:
+			case TC_ACT_TRAP:
+				fallthrough;
+			case TC_ACT_SHOT:
+				rcu_read_unlock();
+				return 0;
+			}
+		}
+	}
+out:
+	rcu_read_unlock();
+	return res.class;
+}
+
+const struct bpf_func_proto bpf_skb_tc_classify_proto = {
+	.func		= bpf_skb_tc_classify,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+};
+#endif
+
 struct tcf_chain_info {
 	struct tcf_proto __rcu **pprev;
 	struct tcf_proto __rcu *next;
-- 
2.34.1

