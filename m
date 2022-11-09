Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83E762362E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiKIVxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiKIVxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:53:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EB331ED7;
        Wed,  9 Nov 2022 13:52:47 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so3127621pjk.2;
        Wed, 09 Nov 2022 13:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yrMnjVPG4cOOqiZYZR1WL3gTbiRvMDdOGJcJaC5E70=;
        b=foCuYIvAy5RbnThGkpxQ5X+07GLMfgIUbArzLtLyDyVTxYTmbWJ+vwAXSj31YDCk7x
         6QdBtbbcfVVSbNX0zRVsQQqc9ksv+KS+qs2rTt2UTzE0r6jdLGudtiQxa0A+WbpAmBh6
         C3zW5rSGImi3Se/jmjA79w4d2RNmfIUzbrjIdo/hMhKLe6EhzBNReRKdiO5DHs1QIb4e
         uF/EmIxMM6CCOBFkX5qtvJ/m3IlTLhQkEvk6UJxcmRE4zHXaznAT7H7JgJ0T6pZZzu/u
         DZTQs35gfFgfaSYtuAXkZTquNOA40otzmjWlEqwW1D1Org2nRGAUzYxhbs948F9eH9I1
         djig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9yrMnjVPG4cOOqiZYZR1WL3gTbiRvMDdOGJcJaC5E70=;
        b=FdP4q9gppoXjCyzgB17ks9rhRc0/VB4xIfGfkZoPYd1AllUG/l10BI8gK+bR50P0zj
         q7sR6k171HlyLNJVVkvmXdMey0AxG5YdZr9vQun8W4yqqh0OsHuxx0ih/rNh4QaeCLGE
         xi9lI5XGmZlh3bQg80d3hY7wAfpXidEozU6HKROvkRM3Z0394wEstk2e6vFXHVq9IRS4
         scoSb/qmPELbYoqvJrWYrvlNNidTrh4OH0g8jKxO652myXUHnAKlgZkUg54bY3xHCe5o
         pmuxKgNf1IoSyAD+8ff3tsc1yyCW7wo1+ul0OPWD1sC+to40IYJ2FUK90SKJFw9a6csP
         ei9g==
X-Gm-Message-State: ACrzQf2aNIxpsPefBxTjPuEGh+Umvuoy1zAD3f5WNhJ+1F+WcS9+/qIN
        4sMI7JwZ0vxPX5bFAGL3FI0=
X-Google-Smtp-Source: AMsMyM4PjZRb1eAT5hZOYvYgfF4sAZjmh3I2hSgwGXtWQEzgoJXKUavNVBxrSXVU9jWYZR55fMAEAw==
X-Received: by 2002:a17:90a:5d06:b0:212:f8e5:81ab with SMTP id s6-20020a17090a5d0600b00212f8e581abmr1254282pji.114.1668030767077;
        Wed, 09 Nov 2022 13:52:47 -0800 (PST)
Received: from john.lan ([98.97.44.95])
        by smtp.gmail.com with ESMTPSA id h3-20020aa796c3000000b0056246403534sm8727802pfq.88.2022.11.09.13.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 13:52:46 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     hawk@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, sdf@google.com
Subject: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Date:   Wed,  9 Nov 2022 13:52:41 -0800
Message-Id: <20221109215242.1279993-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221109215242.1279993-1-john.fastabend@gmail.com>
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
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

Allow xdp progs to read the net_device structure. Its useful to extract
info from the dev itself. Currently, our tracing tooling uses kprobes
to capture statistics and information about running net devices. We use
kprobes instead of other hooks tc/xdp because we need to collect
information about the interface not exposed through the xdp_md structures.
This has some down sides that we want to avoid by moving these into the
XDP hook itself. First, placing the kprobes in a generic function in
the kernel is after XDP so we miss redirects and such done by the
XDP networking program. And its needless overhead because we are
already paying the cost for calling the XDP program, calling yet
another prog is a waste. Better to do everything in one hook from
performance side.

Of course we could one-off each one of these fields, but that would
explode the xdp_md struct and then require writing convert_ctx_access
writers for each field. By using BTF we avoid writing field specific
convertion logic, BTF just knows how to read the fields, we don't
have to add many fields to xdp_md, and I don't have to get every
field we will use in the future correct.

For reference current examples in our code base use the ifindex,
ifname, qdisc stats, net_ns fields, among others. With this
patch we can now do the following,

        dev = ctx->rx_dev;
        net = dev->nd_net.net;

	uid.ifindex = dev->ifindex;
	memcpy(uid.ifname, dev->ifname, NAME);
        if (net)
		uid.inum = net->ns.inum;

to report the name, index and ns.inum which identifies an
interface in our system.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 19 +++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 94659f6b3395..50403eb3b6cf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6123,6 +6123,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__bpf_md_ptr(struct net_device *, rx_dev); /* rxq->dev */
 };
 
 /* DEVMAP map-value layout
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..d445ffbea8f1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8686,6 +8686,8 @@ static bool __is_valid_xdp_access(int off, int size)
 	return true;
 }
 
+BTF_ID_LIST_SINGLE(btf_xdp_get_netdev_id, struct, net_device)
+
 static bool xdp_is_valid_access(int off, int size,
 				enum bpf_access_type type,
 				const struct bpf_prog *prog,
@@ -8718,6 +8720,15 @@ static bool xdp_is_valid_access(int off, int size,
 	case offsetof(struct xdp_md, data_end):
 		info->reg_type = PTR_TO_PACKET_END;
 		break;
+	case offsetof(struct xdp_md, rx_dev):
+		info->reg_type = PTR_TO_BTF_ID;
+		info->btf_id = btf_xdp_get_netdev_id[0];
+		info->btf = bpf_get_btf_vmlinux();
+	        if (IS_ERR_OR_NULL(info->btf))
+			return false;
+		if (size != sizeof(u64))
+			return false;
+		return true;
 	}
 
 	return __is_valid_xdp_access(off, size);
@@ -9808,6 +9819,14 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
 				      offsetof(struct net_device, ifindex));
 		break;
+	case offsetof(struct xdp_md, rx_dev):
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_buff, rxq));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
+				      si->dst_reg, si->dst_reg,
+				      offsetof(struct xdp_rxq_info, dev));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 94659f6b3395..50403eb3b6cf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6123,6 +6123,7 @@ struct xdp_md {
 	__u32 rx_queue_index;  /* rxq->queue_index  */
 
 	__u32 egress_ifindex;  /* txq->dev->ifindex */
+	__bpf_md_ptr(struct net_device *, rx_dev); /* rxq->dev */
 };
 
 /* DEVMAP map-value layout
-- 
2.33.0

