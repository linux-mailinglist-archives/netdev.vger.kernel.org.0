Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E902359CB
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgHBS04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:26:56 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:36590 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726999AbgHBS0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 14:26:53 -0400
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 1052A2E12B8;
        Sun,  2 Aug 2020 21:26:46 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 9B27pMbQjV-QjqWaHgL;
        Sun, 02 Aug 2020 21:26:45 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596392805; bh=mQVqQ73mXZSebnv4KhFVJF49opvn1XFXAcjr00rCPUc=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=tAEUJGq9XHUZm8S5k8MNfi2eBkHdjcmRJk6e5N3bNtWeUUpVrl9DIPuA4cwl3WMSZ
         nJ55C3/VOvVvrhJfTPDq9D5tVMQIis0OjhCG8EFeAXsRSBBBEX7C/4paTOB78w4LJI
         WUd9wKyPydl880vmZFj6vs/fohE5KlY1191WQ5pg=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.220.66])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id BgDnkfhBPV-Qjj49Abd;
        Sun, 02 Aug 2020 21:26:45 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v4 2/2] bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
Date:   Sun,  2 Aug 2020 21:26:38 +0300
Message-Id: <20200802182638.77377-3-zeil@yandex-team.ru>
In-Reply-To: <20200802182638.77377-1-zeil@yandex-team.ru>
References: <20200802182638.77377-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now skb->dev is unconditionally set to the loopback device in current net
namespace. But if we want to test bpf program which contains code branch
based on ifindex condition (eg filters out localhost packets) it is useful
to allow specifying of ifindex from userspace. This patch adds such option
through ctx_in (__sk_buff) parameter.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/bpf/test_run.c                               | 22 ++++++++++++++++++++--
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c |  5 +++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2521b27..99cdd3c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -327,6 +327,12 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	/* priority is allowed */
 
 	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, priority),
+			   offsetof(struct __sk_buff, ifindex)))
+		return -EINVAL;
+
+	/* ifindex is allowed */
+
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, ifindex),
 			   offsetof(struct __sk_buff, cb)))
 		return -EINVAL;
 
@@ -381,6 +387,7 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 
 	__skb->mark = skb->mark;
 	__skb->priority = skb->priority;
+	__skb->ifindex = skb->dev->ifindex;
 	__skb->tstamp = skb->tstamp;
 	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
 	__skb->wire_len = cb->pkt_len;
@@ -391,6 +398,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
 	bool is_l2 = false, is_direct_pkt_access = false;
+	struct net *net = current->nsproxy->net_ns;
+	struct net_device *dev = net->loopback_dev;
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
@@ -432,7 +441,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		kfree(ctx);
 		return -ENOMEM;
 	}
-	sock_net_set(sk, current->nsproxy->net_ns);
+	sock_net_set(sk, net);
 	sock_init_data(NULL, sk);
 
 	skb = build_skb(data, 0);
@@ -446,7 +455,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 	__skb_put(skb, size);
-	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
+	if (ctx && ctx->ifindex > 1) {
+		dev = dev_get_by_index(net, ctx->ifindex);
+		if (!dev) {
+			ret = -ENODEV;
+			goto out;
+		}
+	}
+	skb->protocol = eth_type_trans(skb, dev);
 	skb_reset_network_header(skb);
 
 	switch (skb->protocol) {
@@ -498,6 +514,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		ret = bpf_ctx_finish(kattr, uattr, ctx,
 				     sizeof(struct __sk_buff));
 out:
+	if (dev && dev != net->loopback_dev)
+		dev_put(dev);
 	kfree_skb(skb);
 	bpf_sk_storage_free(sk);
 	kfree(sk);
diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index 7021b92..25de86a 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -11,6 +11,7 @@ void test_skb_ctx(void)
 		.cb[3] = 4,
 		.cb[4] = 5,
 		.priority = 6,
+		.ifindex = 1,
 		.tstamp = 7,
 		.wire_len = 100,
 		.gso_segs = 8,
@@ -92,6 +93,10 @@ void test_skb_ctx(void)
 		   "ctx_out_priority",
 		   "skb->priority == %d, expected %d\n",
 		   skb.priority, 7);
+	CHECK_ATTR(skb.ifindex != 1,
+		   "ctx_out_ifindex",
+		   "skb->ifindex == %d, expected %d\n",
+		   skb.ifindex, 1);
 	CHECK_ATTR(skb.tstamp != 8,
 		   "ctx_out_tstamp",
 		   "skb->tstamp == %lld, expected %d\n",
-- 
2.7.4

