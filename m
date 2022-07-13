Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85EE57353A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiGMLSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236003AbiGMLSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0A63101482
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657711108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLRYZFEE5WheSOr0ZueH2oIEz+AIlR3j+gOBT1CAlzo=;
        b=LFQUcT2cetqSE77FnnU7LFhoypDLxqiMiqAK4o3LS4eezMMHW1+47ubA4xNDuuX0ZcQPyt
        WkN3MCxMqSnJC7WF7oL9hIViFGgiP8K6Lowmt5l6I8NhRL7i0LL++OjcOXKUpEpWXyhKVB
        b5QIMlC3/pr1ITzpmZVChXQ7A+pfzAg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-p4U2AZYUPGORMRTy5VqRAQ-1; Wed, 13 Jul 2022 07:18:28 -0400
X-MC-Unique: p4U2AZYUPGORMRTy5VqRAQ-1
Received: by mail-ej1-f71.google.com with SMTP id hq20-20020a1709073f1400b0072b9824f0a2so580223ejc.23
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yLRYZFEE5WheSOr0ZueH2oIEz+AIlR3j+gOBT1CAlzo=;
        b=vmpCg51pIHGljCSxg0b6uV+YHkmJGTkN+VCDv5QJWNHmSNn+XAQZPG/EsQl9sUcixv
         Cr51njjk/caSCVZkXo/moVzr0xWibfdE63Hi443NyGXgXRHYAV36XD6P8reiBSzidsbs
         VYpNv1LP1U1tJo9dRlUCd+zCmDp1gUR7+p7XpLNWJzdgilkVcXqvPt5UCfYgLFjzBLmv
         0NJ4b1rY/sPVxfPRmCz9OHEmvA6Wbx6PAZe2dY7u/1kpBfQWyRt/mMxYqEbI26jy3d+R
         SSc8MHlBRoCVSAR15BTjLB7KMKAwWVWT1f+eKAEeLkVSbJdh2/JfjJI6ZtTiq+MG7xFu
         DWfQ==
X-Gm-Message-State: AJIora+CzhIo3kNjSMvw6sdTzirnbvBBCLXgXh1+66V1Gv/eqP9zr+Ho
        28pDodg9bW+YbzKTkIGZqjC9EmfSTHDT6CD7azpw/0fonxKbhP/4ZpnItzrVbUgL73WH8gXEiG5
        nSP/0Ecq6JxuJNFE1
X-Received: by 2002:a17:906:cc12:b0:72b:67bb:80c3 with SMTP id ml18-20020a170906cc1200b0072b67bb80c3mr2868835ejb.668.1657711105122;
        Wed, 13 Jul 2022 04:18:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uBFxK6DbwgDOXIMNl+wGvmseBfFYC5zNP3nMDjTbia6fZ+NjHseC/3kcVLQORZRD33bQ8oSQ==
X-Received: by 2002:a17:906:cc12:b0:72b:67bb:80c3 with SMTP id ml18-20020a170906cc1200b0072b67bb80c3mr2868756ejb.668.1657711104006;
        Wed, 13 Jul 2022 04:18:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id kv21-20020a17090778d500b0070abf371274sm4814528ejc.136.2022.07.13.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:18:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1C6074D9914; Wed, 13 Jul 2022 13:14:39 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [RFC PATCH 12/17] bpf: Add helper to schedule an interface for TX dequeue
Date:   Wed, 13 Jul 2022 13:14:20 +0200
Message-Id: <20220713111430.134810-13-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a helper that a BPF program can call to schedule an interface for
transmission. The helper can be used from both a regular XDP program (to
schedule transmission after queueing a packet), and from a dequeue program
to (re-)schedule transmission after a dequeue operation. In particular, the
latter use can be combined with BPF timers to schedule delayed
transmission, for instance to implement traffic shaping.

The helper always schedules transmission on the interface on the current
CPU. For cross-CPU operation, it is up to the BPF program to arrange for
the helper to be called on the appropriate CPU, either by configuring
hardware RSS appropriately, or by using a cpumap. Likewise, it is up to the
BPF programs to decide whether to use separate queues per CPU (by using
multiple maps to queue packets in), or accept the lock contention of using
a single map across CPUs.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h       | 11 +++++++
 net/core/filter.c              | 52 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 11 +++++++
 3 files changed, 74 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d44382644391..b352ecc280f4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5358,6 +5358,16 @@ union bpf_attr {
  *		*bpf_packet_dequeue()* (and checked to not be NULL).
  *	Return
  *		This always succeeds and returns zero.
+ *
+ * long bpf_schedule_iface_dequeue(void *ctx, int ifindex, int flags)
+ *	Description
+ *		Schedule the interface with index *ifindex* for transmission from
+ *		its dequeue program as soon as possible. The *flags* argument
+ *		must be zero.
+ *
+ *	Return
+ *		Returns zero on success, or -ENOENT if no dequeue program is
+ *		loaded on the interface.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5570,6 +5580,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(packet_dequeue),		\
 	FN(packet_drop),		\
+	FN(schedule_iface_dequeue),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index 7c89eaa01c29..bb556d873b52 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4431,6 +4431,54 @@ static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
 	.arg3_type      = ARG_ANYTHING,
 };
 
+static int bpf_schedule_iface_dequeue(struct net *net, int ifindex, int flags)
+{
+	struct net_device *dev;
+	struct bpf_prog *prog;
+
+	if (flags)
+		return -EINVAL;
+
+	dev = dev_get_by_index_rcu(net, ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	prog = rcu_dereference(dev->xdp_dequeue_prog);
+	if (!prog)
+		return -ENOENT;
+
+	dev_schedule_xdp_dequeue(dev);
+	return 0;
+}
+
+BPF_CALL_3(bpf_xdp_schedule_iface_dequeue, struct xdp_buff *, ctx, int, ifindex, int, flags)
+{
+	return bpf_schedule_iface_dequeue(dev_net(ctx->rxq->dev), ifindex, flags);
+}
+
+static const struct bpf_func_proto bpf_xdp_schedule_iface_dequeue_proto = {
+	.func           = bpf_xdp_schedule_iface_dequeue,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_ANYTHING,
+};
+
+BPF_CALL_3(bpf_dequeue_schedule_iface_dequeue, struct dequeue_data *, ctx, int, ifindex, int, flags)
+{
+	return bpf_schedule_iface_dequeue(dev_net(ctx->txq->dev), ifindex, flags);
+}
+
+static const struct bpf_func_proto bpf_dequeue_schedule_iface_dequeue_proto = {
+	.func           = bpf_dequeue_schedule_iface_dequeue,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_ANYTHING,
+};
+
 BTF_ID_LIST_SINGLE(xdp_md_btf_ids, struct, xdp_md)
 
 BPF_CALL_4(bpf_packet_dequeue, struct dequeue_data *, ctx, struct bpf_map *, map,
@@ -8068,6 +8116,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_fib_lookup_proto;
 	case BPF_FUNC_check_mtu:
 		return &bpf_xdp_check_mtu_proto;
+	case BPF_FUNC_schedule_iface_dequeue:
+		return &bpf_xdp_schedule_iface_dequeue_proto;
 #ifdef CONFIG_INET
 	case BPF_FUNC_sk_lookup_udp:
 		return &bpf_xdp_sk_lookup_udp_proto;
@@ -8105,6 +8155,8 @@ dequeue_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_packet_dequeue_proto;
 	case BPF_FUNC_packet_drop:
 		return &bpf_packet_drop_proto;
+	case BPF_FUNC_schedule_iface_dequeue:
+		return &bpf_dequeue_schedule_iface_dequeue_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1dab68a89e18..9eb9a5b52c76 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5358,6 +5358,16 @@ union bpf_attr {
  *		*bpf_packet_dequeue()* (and checked to not be NULL).
  *	Return
  *		This always succeeds and returns zero.
+ *
+ * long bpf_schedule_iface_dequeue(void *ctx, int ifindex, int flags)
+ *	Description
+ *		Schedule the interface with index *ifindex* for transmission from
+ *		its dequeue program as soon as possible. The *flags* argument
+ *		must be zero.
+ *
+ *	Return
+ *		Returns zero on success, or -ENOENT if no dequeue program is
+ *		loaded on the interface.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5570,6 +5580,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(packet_dequeue),		\
 	FN(packet_drop),		\
+	FN(schedule_iface_dequeue),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.37.0

