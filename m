Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD393DE100
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhHBUua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhHBUu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:50:28 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7ECC06175F;
        Mon,  2 Aug 2021 13:50:17 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id a12so12596421qtb.2;
        Mon, 02 Aug 2021 13:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8WYVXOVWiAw8d7j2eGAl0yg+RDALNOfe7GgbVDGVAc4=;
        b=VnjAFAemJq7ihtDJ7NxlEU7/0xTvyvRt2v2vVf/fRGgKpYUIFXR0YzO9miMP9XAN2N
         1PAJg4Eh5bHGmtcC1QdvonNV3RXDCPPXrntjzmuwBx7LY6Re47tBJ890i1nKDAzcMu5o
         spBndUfPh5E1bqKQD9xUdlS4ZC0qWf8+RUZgm+kmnxRfxUPOF/GiNbA5QTBT/yV6IfbJ
         jFEp3XbARn6lBKzqiXeSV7mWJF+9TLqfRIc0AdYzp0MDQUHJcfO95frK2iyU9fEzTyNZ
         vPDUmMG6JY6Mkx636hUiJoT7wCmtt8nF1qvTK5shXGd9YJVzQxBIAG/BmCm1MgFlHN5N
         8YCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8WYVXOVWiAw8d7j2eGAl0yg+RDALNOfe7GgbVDGVAc4=;
        b=OCfQOTOW7qzzlXbC+37WoCWy03IECvA41zxGQP30Ftb3M5aH3UYSACxDlPoZaPPH5r
         up+Gh4ho2qmvX5rQen1zVYALj6T+U+R8rOhlm7OoQPEs+frNYGmn0m9I+dtf1AM12OtD
         8wf6IB8N9omtuLWijZwA2ZlPR4F4MI+bE6ntcpUvQwhU2qABTgIXLIsULaahbbQv+a/v
         Q1LyTE3v0uvzcKyh1YwRNSs6SIZaBTLYe2vEWaB2q+ZIvmJsmmjhK4RySGFyyy+SRrkW
         07ydtxIUDTJaUJag52PkbqRzUvdRNDwvtcxTsKlVpjOEDN8FlU13fLI9DLnRX/FBu4nN
         byIQ==
X-Gm-Message-State: AOAM533Aa1u4UOo5IHn2ineSgaGromiIcgiUjI8/Ff1MJIPHPWzvIvCF
        fR+q+hGK15JegBIaH7vH6Q==
X-Google-Smtp-Source: ABdhPJyYmgAdgsomZUjQ8CQeLqiUjImJD46X2QTAAnsDu9RhWHw75i2rFDENdYTzO1sz9J/1157ohQ==
X-Received: by 2002:ac8:66ca:: with SMTP id m10mr15318804qtp.171.1627937416360;
        Mon, 02 Aug 2021 13:50:16 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id q11sm6374623qkm.56.2021.08.02.13.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:50:15 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 1/2] net/sched: sch_ingress: Support clsact egress mini-Qdisc option
Date:   Mon,  2 Aug 2021 13:49:47 -0700
Message-Id: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

If the ingress Qdisc is in use, currently it is not possible to add
another clsact egress mini-Qdisc to the same device without taking down
the ingress Qdisc, since both sch_ingress and sch_clsact use the same
handle (0xFFFF0000).

Add a "change" option for sch_ingress, so that users can enable or disable
a clsact egress mini-Qdisc, without suffering from downtime:

    $ tc qdisc add dev eth0 ingress
    $ tc qdisc change dev eth0 ingress clsact-on

Then users can add filters to the egress mini-Qdisc as usual:

    $ tc filter add dev eth0 egress protocol ip prio 10 \
	    matchall action skbmod swap mac

Deleting the ingress Qdisc removes the egress mini-Qdisc as well.  To
remove egress mini-Qdisc only, use:

    $ tc qdisc change dev eth0 ingress clsact-off

Finally, if the egress mini-Qdisc is enabled, the "show" command will
print out a "clsact" flag to indicate it:

    $ tc qdisc show ingress
    qdisc ingress ffff: dev eth0 parent ffff:fff1 ----------------
    $ tc qdisc change dev eth0 ingress clsact-on
    $ tc qdisc show ingress
    qdisc ingress ffff: dev eth0 parent ffff:fff1 ---------------- clsact

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 include/uapi/linux/pkt_sched.h | 12 +++++
 net/sched/sch_ingress.c        | 92 ++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 79a699f106b1..cb0eb5dd848a 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -586,6 +586,18 @@ enum {
 
 #define TCA_ATM_MAX	(__TCA_ATM_MAX - 1)
 
+/* INGRESS section */
+
+enum {
+	TCA_INGRESS_UNSPEC,
+	TCA_INGRESS_FLAGS,
+#define	TC_INGRESS_CLSACT	   _BITUL(0)	/* enable clsact egress mini-Qdisc */
+#define	TC_INGRESS_SUPPORTED_FLAGS TC_INGRESS_CLSACT
+	__TCA_INGRESS_MAX,
+};
+
+#define	TCA_INGRESS_MAX	(__TCA_INGRESS_MAX - 1)
+
 /* Network emulator */
 
 enum {
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 84838128b9c5..96e00e9e727b 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -16,8 +16,12 @@
 
 struct ingress_sched_data {
 	struct tcf_block *block;
+	struct tcf_block *egress_block;
 	struct tcf_block_ext_info block_info;
+	struct tcf_block_ext_info egress_block_info;
 	struct mini_Qdisc_pair miniqp;
+	struct mini_Qdisc_pair miniqp_egress;
+	bool clsact;
 };
 
 static struct Qdisc *ingress_leaf(struct Qdisc *sch, unsigned long arg)
@@ -27,6 +31,11 @@ static struct Qdisc *ingress_leaf(struct Qdisc *sch, unsigned long arg)
 
 static unsigned long ingress_find(struct Qdisc *sch, u32 classid)
 {
+	struct ingress_sched_data *q = qdisc_priv(sch);
+
+	if (q->clsact && TC_H_MIN(classid) == TC_H_MIN(TC_H_MIN_EGRESS))
+		return TC_H_MIN(TC_H_MIN_EGRESS);
+
 	return TC_H_MIN(classid) + 1;
 }
 
@@ -49,6 +58,9 @@ static struct tcf_block *ingress_tcf_block(struct Qdisc *sch, unsigned long cl,
 {
 	struct ingress_sched_data *q = qdisc_priv(sch);
 
+	if (q->clsact && cl == TC_H_MIN(TC_H_MIN_EGRESS))
+		return q->egress_block;
+
 	return q->block;
 }
 
@@ -66,6 +78,14 @@ static void ingress_ingress_block_set(struct Qdisc *sch, u32 block_index)
 	q->block_info.block_index = block_index;
 }
 
+static void ingress_egress_block_set(struct Qdisc *sch, u32 block_index)
+{
+	struct ingress_sched_data *q = qdisc_priv(sch);
+
+	if (q->clsact)
+		q->egress_block_info.block_index = block_index;
+}
+
 static u32 ingress_ingress_block_get(struct Qdisc *sch)
 {
 	struct ingress_sched_data *q = qdisc_priv(sch);
@@ -73,6 +93,13 @@ static u32 ingress_ingress_block_get(struct Qdisc *sch)
 	return q->block_info.block_index;
 }
 
+static u32 ingress_egress_block_get(struct Qdisc *sch)
+{
+	struct ingress_sched_data *q = qdisc_priv(sch);
+
+	return q->clsact ? q->egress_block_info.block_index : 0;
+}
+
 static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
 			struct netlink_ext_ack *extack)
 {
@@ -103,16 +130,78 @@ static void ingress_destroy(struct Qdisc *sch)
 
 	tcf_block_put_ext(q->block, sch, &q->block_info);
 	net_dec_ingress_queue();
+
+	if (q->clsact) {
+		tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
+		net_dec_egress_queue();
+	}
+}
+
+static const struct nla_policy ingress_policy[TCA_INGRESS_MAX + 1] = {
+	[TCA_INGRESS_FLAGS] = NLA_POLICY_BITFIELD32(TC_INGRESS_SUPPORTED_FLAGS),
+};
+
+static int ingress_change(struct Qdisc *sch, struct nlattr *arg, struct netlink_ext_ack *extack)
+{
+	struct ingress_sched_data *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct nlattr *tb[TCA_INGRESS_MAX + 1];
+	struct nla_bitfield32 flags;
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, TCA_INGRESS_MAX, arg, ingress_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_INGRESS_FLAGS])
+		return -EINVAL;
+
+	flags = nla_get_bitfield32(tb[TCA_INGRESS_FLAGS]);
+
+	if (flags.value & TC_INGRESS_CLSACT) {
+		if (q->clsact)
+			return -EEXIST;
+
+		/* enable clsact egress mini-Qdisc */
+		mini_qdisc_pair_init(&q->miniqp_egress, sch, &dev->miniq_egress);
+
+		q->egress_block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS;
+		q->egress_block_info.chain_head_change = clsact_chain_head_change;
+		q->egress_block_info.chain_head_change_priv = &q->miniqp_egress;
+
+		err = tcf_block_get_ext(&q->egress_block, sch, &q->egress_block_info, extack);
+		if (err)
+			return err;
+
+		net_inc_egress_queue();
+		q->clsact = true;
+	} else {
+		if (!q->clsact)
+			return -ENOENT;
+
+		/* disable clsact egress mini-Qdisc */
+		tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
+
+		net_dec_egress_queue();
+		q->clsact = false;
+	}
+
+	return 0;
 }
 
 static int ingress_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
+	struct ingress_sched_data *q = qdisc_priv(sch);
 	struct nlattr *nest;
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
 
+	if (nla_put_bitfield32(skb, TCA_INGRESS_FLAGS, q->clsact ? TC_INGRESS_CLSACT : 0,
+			       TC_INGRESS_SUPPORTED_FLAGS))
+		goto nla_put_failure;
+
 	return nla_nest_end(skb, nest);
 
 nla_put_failure:
@@ -137,9 +226,12 @@ static struct Qdisc_ops ingress_qdisc_ops __read_mostly = {
 	.static_flags		=	TCQ_F_CPUSTATS,
 	.init			=	ingress_init,
 	.destroy		=	ingress_destroy,
+	.change			=	ingress_change,
 	.dump			=	ingress_dump,
 	.ingress_block_set	=	ingress_ingress_block_set,
+	.egress_block_set	=	ingress_egress_block_set,
 	.ingress_block_get	=	ingress_ingress_block_get,
+	.egress_block_get	=	ingress_egress_block_get,
 	.owner			=	THIS_MODULE,
 };
 
-- 
2.20.1

