Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8670422158E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGOTvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgGOTvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:51:51 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841F4C061755;
        Wed, 15 Jul 2020 12:51:50 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 2FAC72E1469;
        Wed, 15 Jul 2020 22:51:48 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id N0TQNKhr8x-pks8uhH3;
        Wed, 15 Jul 2020 22:51:48 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594842708; bh=vNbjcbjkLVIDD/QHy81iuVCbyu7JHtnrx3RDpfYls/w=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=AM5HUUwf6CGqurt7ZEYnrRCcGOoPwy61j2VdsR+3xBHaXlGnjgdKG8Ecmz5Xp1eln
         ZVuLMos2pej21EhGYcCHD/5A3E5aU8RIM2rr411YBnDvzbR8AcAprmPLcAuvUBTiGs
         yw/o/RfPjrKUY6u+i1BPp4xrrKHRPa1DX2VtZU8g=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.121.196-vpn.dhcp.yndx.net (37.9.121.196-vpn.dhcp.yndx.net [37.9.121.196])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id kLmvqU3zdD-pkiKw5vq;
        Wed, 15 Jul 2020 22:51:46 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v3 2/4] bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
Date:   Wed, 15 Jul 2020 22:51:30 +0300
Message-Id: <20200715195132.4286-3-zeil@yandex-team.ru>
In-Reply-To: <20200715195132.4286-1-zeil@yandex-team.ru>
References: <20200715195132.4286-1-zeil@yandex-team.ru>
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
index 0c3283d..0e92973 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -310,6 +310,12 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
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
 
@@ -364,6 +370,7 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 
 	__skb->mark = skb->mark;
 	__skb->priority = skb->priority;
+	__skb->ifindex = skb->dev->ifindex;
 	__skb->tstamp = skb->tstamp;
 	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
 	__skb->wire_len = cb->pkt_len;
@@ -374,6 +381,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
 	bool is_l2 = false, is_direct_pkt_access = false;
+	struct net *net = current->nsproxy->net_ns;
+	struct net_device *dev = net->loopback_dev;
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
@@ -415,7 +424,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		kfree(ctx);
 		return -ENOMEM;
 	}
-	sock_net_set(sk, current->nsproxy->net_ns);
+	sock_net_set(sk, net);
 	sock_init_data(NULL, sk);
 
 	skb = build_skb(data, 0);
@@ -429,7 +438,14 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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
@@ -481,6 +497,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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

