Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB2A5F58FF
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiJERSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiJERSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:18:16 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493953A157;
        Wed,  5 Oct 2022 10:18:11 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id i9so7352929qvu.1;
        Wed, 05 Oct 2022 10:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Vs/rP4IDV/yKojwamvZ9fmwsEFJF87oNCRi38myhe58=;
        b=jwaA/ryGa3BWj7GzdeC5+oqAxFxxpksehzr+ELMt+kPKPf9yhDFyTXsqA3DlIQN7Qb
         Ed0V5AMHHgwT2SfFitIMsoo1T9K/Or2sMvVGHUtb+Ip/FoU+io9euDo7rTEHHhiZa+47
         n8TB24IddJqTFQ3prk+pfI/zGfIisvu7KCiN1lxYGkyeuLMJ70H+R0/NftOOvWXyeJRH
         pgipVPN/N0KNK/xF4e9/QCXZLl4fKknk9G9eIZw4jfk9TMBOeeF1p8Dn9lOwH3ZZRUHT
         oc6csXvAhg5Fp/Nv8ji9wl/e9ICd7zlMITDj/OoQYrlqc50ywuofnK+D9CYVhvaqYM9C
         CcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Vs/rP4IDV/yKojwamvZ9fmwsEFJF87oNCRi38myhe58=;
        b=tmP03Qyww8njw+Jvy45a3fKPKpD3/bSproiYNPUDTwEHZnAEVbUtx06978xe5iGe9l
         zqyY0K7mGQHX90Y1o+KijbZ3juI/Yip40KY3P9c5TVsS3R+5Oa9zFWQzWT1wj8CRO9fs
         fHlVbOqJBLULidFW28mFqSPylToQdanXLe7Q6CKB6uBsvLRfO5DAUp2oOBeP+BLwez2Y
         1WoqGi9tkxw92A0jX+sPIwvxY0ZNF13i+PMaQ2TnbK2v+AfVo33ZXCi78db9n/RHSp0J
         cq0KLCYksb+fNDS7X0YitWdP458JBdieaGoTYN9vuV55GCniNBB2/VHrbvFIUDmsBA3U
         BzBw==
X-Gm-Message-State: ACrzQf0LKGSiKyopiTjQP4glHLXfboDQjlk7qLNXMO3vISa3+uT/9gGr
        wstidetkb2um5HZuevtuo9fAFMtC1fc=
X-Google-Smtp-Source: AMsMyM5r/2zJpIbjtabbsuMXMdw+/w9El5wJ7ps4NSmBwrzKGqk0K8nceMKR3GlL9XY5rpvJnZg7qw==
X-Received: by 2002:a05:6214:c66:b0:4ac:b026:458b with SMTP id t6-20020a0562140c6600b004acb026458bmr666694qvj.20.1664990268939;
        Wed, 05 Oct 2022 10:17:48 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2bd1:c1af:4b3b:4384])
        by smtp.gmail.com with ESMTPSA id m13-20020ac85b0d000000b003913996dce3sm1764552qtw.6.2022.10.05.10.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:17:48 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yangpeihao@sjtu.edu.cn, toke@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, bpf@vger.kernel.org, sdf@google.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v6 5/5] net_sched: Introduce helper bpf_skb_tc_classify()
Date:   Wed,  5 Oct 2022 10:17:09 -0700
Message-Id: <20221005171709.150520-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
References: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 net/core/filter.c        | 17 +++++++++-
 net/sched/cls_api.c      | 69 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c21fd1f189bc..7ed04736c4e4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5650,6 +5650,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(ktime_get_tai_ns),		\
 	FN(user_ringbuf_drain),		\
+	FN(skb_tc_classify),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 7a271b77a2cc..d1ed60114794 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7926,6 +7926,21 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
+const struct bpf_func_proto bpf_skb_tc_classify_proto __weak;
+
+static const struct bpf_func_proto *
+tc_qdisc_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+#ifdef CONFIG_NET_CLS_ACT
+	case BPF_FUNC_skb_tc_classify:
+		return &bpf_skb_tc_classify_proto;
+#endif
+	default:
+		return tc_cls_act_func_proto(func_id, prog);
+	}
+}
+
 static const struct bpf_func_proto *
 xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -10656,7 +10671,7 @@ const struct bpf_prog_ops tc_cls_act_prog_ops = {
 };
 
 const struct bpf_verifier_ops tc_qdisc_verifier_ops = {
-	.get_func_proto		= tc_cls_act_func_proto,
+	.get_func_proto		= tc_qdisc_func_proto,
 	.is_valid_access	= tc_cls_act_is_valid_access,
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 50566db45949..64470a8947b1 100644
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
@@ -1655,6 +1656,74 @@ int tcf_classify(struct sk_buff *skb,
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

