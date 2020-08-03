Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933D123A18A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgHCJGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:06:14 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:38326 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgHCJGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:06:06 -0400
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id DEA692E14FC;
        Mon,  3 Aug 2020 12:06:03 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id V7kn8eU4FZ-62t8r06x;
        Mon, 03 Aug 2020 12:06:03 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596445563; bh=Oo66nsRaElryOZye3EqBLW8xrT36MuCfruXoPKVcSIE=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=C5PTJHjAH7WEn2JiVq7Dgqxlnt0aab036S0zJCKh/6wPHppVHlq9ve3GuEH2zoC8t
         IrSmPVpqqXir935Gqax0B2xYwGONTSX+PpofnNl4VAOJsJhNxWigJVSrZGdsCuMMKG
         kGAKFxnriMgUHjKzEALEtktI8TRYev21DIoL63tE=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.163.76-vpn.dhcp.yndx.net (178.154.163.76-vpn.dhcp.yndx.net [178.154.163.76])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 1ZDFznne1R-62iCIIr9;
        Mon, 03 Aug 2020 12:06:02 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     eric.dumazet@gmail.com, sdf@google.com
Subject: [PATCH bpf-next v6 2/2] bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
Date:   Mon,  3 Aug 2020 12:05:45 +0300
Message-Id: <20200803090545.82046-3-zeil@yandex-team.ru>
In-Reply-To: <20200803090545.82046-1-zeil@yandex-team.ru>
References: <20200803090545.82046-1-zeil@yandex-team.ru>
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
index 736a596..99eb8c6 100644
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
@@ -502,6 +518,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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

