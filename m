Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2C5F58F7
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 19:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJERSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 13:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiJERSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 13:18:13 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E165726111;
        Wed,  5 Oct 2022 10:18:10 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id mx8so4474643qvb.8;
        Wed, 05 Oct 2022 10:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ZhAUYVqrdKYklNGIsEXG4znDGVspQ80aq1aJ4554Cc0=;
        b=XVTKmDU0btvmwiJm2tarmHaZXjec2OSoNYPt63uGtSpVIlbgGxxTyuah0+G6y1HLtX
         F6klWNxyzedwZVUyRj7krLaQ0z3XH/eNh6t40mdbgi2JqaLqp08TDjZgwgKAOuZ8ZjTy
         WdVkG4C6pdiufVYjfrv6cpVa9Srhw7wXLPU1t60Udf9RcYKsdthZmwqRdllwo02XTdFh
         gQOHI3iHD4CWkAD94mzYBD5JKRzRMZ5Im1TtdJTLZe1n5l+BJCd2kX0BWb7BlQ/vAbXB
         +DhBou99kHHwyokw32MDyYQDxqlC+sXs06p/uFEf9SK9ws1mrI0EsuO/RzdMZ1eqzLzr
         f+0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ZhAUYVqrdKYklNGIsEXG4znDGVspQ80aq1aJ4554Cc0=;
        b=GUh1NOpC+kRZs96b6VZQyLzlnmxKH8rru88vtKdR09PVpNwMDGAaKLqXzwYgwGT7Ft
         /hVz5qS0IYqE/fuotrM6EVOIqblN3KG8kkIn1yFRgKggqs6/NdKQZClRTSo8y9tP9h6X
         zP/FlC40dTwaa/uLfkZjIFeMqwg8U1PfrfxZ9jjrkksGFC4yGZBaWpNk3ZfFcuCL2c1z
         lXtscKKRvFIrxpUs9OL/rYj3XbGP/bvD2ZNbwI/eubtGKoCiiwRtykAKbMTToIkDUo8q
         pb66INSct8elNZeFACBty/jdJBGFsLkcOoUVYI67bVCHi0G9dz64XBg3yIURmyrjBL25
         Uysw==
X-Gm-Message-State: ACrzQf2JP0b7JrnMEzrHbnEgpvt/tFalXFWRMyU4cKoMWcArWKf+VVBm
        g9JD11aBGqSRnxyEN3HLPhs6BpFg7WY=
X-Google-Smtp-Source: AMsMyM5IYwCwEN1mk5GDaZ6ZOVUMnadpOXpI0I2WBqgbWV4iXT2KsktcL7kQ9PlOgCTMzQKL3g9upA==
X-Received: by 2002:a05:6214:5018:b0:4b1:c2d9:f0a with SMTP id jo24-20020a056214501800b004b1c2d90f0amr615128qvb.45.1664990267095;
        Wed, 05 Oct 2022 10:17:47 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2bd1:c1af:4b3b:4384])
        by smtp.gmail.com with ESMTPSA id m13-20020ac85b0d000000b003913996dce3sm1764552qtw.6.2022.10.05.10.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:17:46 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yangpeihao@sjtu.edu.cn, toke@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, bpf@vger.kernel.org, sdf@google.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v6 4/5] net_sched: Add kfuncs for storing skb
Date:   Wed,  5 Oct 2022 10:17:08 -0700
Message-Id: <20221005171709.150520-5-xiyou.wangcong@gmail.com>
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

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/sched/sch_bpf.c | 81 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_bpf.c b/net/sched/sch_bpf.c
index 2998d576708d..6850eb8bb574 100644
--- a/net/sched/sch_bpf.c
+++ b/net/sched/sch_bpf.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/filter.h>
 #include <linux/bpf.h>
+#include <linux/btf_ids.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -468,9 +469,87 @@ static struct Qdisc_ops sch_bpf_qdisc_ops __read_mostly = {
 	.owner		=	THIS_MODULE,
 };
 
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in vmlinux BTF");
+
+/**
+ * bpf_skb_acquire - Acquire a reference to an skb. An skb acquired by this
+ * kfunc which is not stored in a map as a kptr, must be released by calling
+ * bpf_skb_release().
+ * @p: The skb on which a reference is being acquired.
+ */
+__used noinline
+struct sk_buff *bpf_skb_acquire(struct sk_buff *p)
+{
+	return skb_get(p);
+}
+
+/**
+ * bpf_skb_kptr_get - Acquire a reference on a struct sk_buff kptr. An skb
+ * kptr acquired by this kfunc which is not subsequently stored in a map, must
+ * be released by calling bpf_skb_release().
+ * @pp: A pointer to an skb kptr on which a reference is being acquired.
+ */
+__used noinline
+struct sk_buff *bpf_skb_kptr_get(struct sk_buff **pp)
+{
+	struct sk_buff *p;
+
+	rcu_read_lock();
+	p = READ_ONCE(*pp);
+	if (p && !refcount_inc_not_zero(&p->users))
+		p = NULL;
+	rcu_read_unlock();
+
+	return p;
+}
+
+/**
+ * bpf_skb_release - Release the reference acquired on a struct sk_buff *.
+ * @p: The skb on which a reference is being released.
+ */
+__used noinline void bpf_skb_release(struct sk_buff *p)
+{
+	consume_skb(p);
+}
+
+__diag_pop();
+
+BTF_SET8_START(skb_kfunc_btf_ids)
+BTF_ID_FLAGS(func, bpf_skb_acquire, KF_ACQUIRE)
+BTF_ID_FLAGS(func, bpf_skb_kptr_get, KF_ACQUIRE | KF_KPTR_GET | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_skb_release, KF_RELEASE | KF_TRUSTED_ARGS)
+BTF_SET8_END(skb_kfunc_btf_ids)
+
+static const struct btf_kfunc_id_set skb_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &skb_kfunc_btf_ids,
+};
+
+BTF_ID_LIST(skb_kfunc_dtor_ids)
+BTF_ID(struct, sk_buff)
+BTF_ID(func, bpf_skb_release)
+
 static int __init sch_bpf_mod_init(void)
 {
-	return register_qdisc(&sch_bpf_qdisc_ops);
+	int ret;
+	const struct btf_id_dtor_kfunc skb_kfunc_dtors[] = {
+		{
+			.btf_id       = skb_kfunc_dtor_ids[0],
+			.kfunc_btf_id = skb_kfunc_dtor_ids[1]
+		},
+	};
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_QDISC, &skb_kfunc_set);
+	if (ret)
+		return ret;
+	ret = register_btf_id_dtor_kfuncs(skb_kfunc_dtors,
+					  ARRAY_SIZE(skb_kfunc_dtors),
+					  THIS_MODULE);
+	if (ret == 0)
+		return register_qdisc(&sch_bpf_qdisc_ops);
+	return ret;
 }
 
 static void __exit sch_bpf_mod_exit(void)
-- 
2.34.1

