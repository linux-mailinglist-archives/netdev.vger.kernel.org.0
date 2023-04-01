Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DDE6D3394
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjDATem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjDATej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:34:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FDF265A6
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:34:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t4so20333523wra.7
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 12:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680377666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYcvY7/n0dK3bMLRRvDjj77dAcZztA7VDmwIrehfiUI=;
        b=elu22nR9wDiNtXhdJADJ6UuT0VAUibzMR93rSlFFo6gXH3pKzcGk6VslIiwXCJsx0G
         di34W3KbjGXtSY7kBMK7nSwAofgCV0KOA1eRu35+yyPFcj1uac//GTsAt5NftsGsyuAv
         gbkKfB4rlgnNX1lAu/F0aPx72WcWFS6eL0Fck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680377666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYcvY7/n0dK3bMLRRvDjj77dAcZztA7VDmwIrehfiUI=;
        b=TGFrGI7uutHXPSd0YKsLP9H4m0t4PzQFH6U21iCReAsZZ52IufZHAc4/l1enL2V2OX
         6b0u1eTWPewv19bwH34Sl3YoJBdESLfVInsGl3TjXBt6HwujaVvqo4UdpDXFc/SjgkR1
         X6re81OhRtOxPz9Sn35Ka4/gtMv0olhZGieRilz/CBfBQ82n/pHqKpjK4AD7BMv5XIdX
         gM/NzXflUmcfCtTlGvgN9+zS00OWT/WPLGsqkYYg1KhuidMXQboyxfCpUYT/8rtMEYF1
         Q6BtNeTkrix2dXcgmu+kpFa2lvVxxZe+Onrwt173cJsMFHTBcDJJ2Tu60KeKfG5HASxg
         dfTw==
X-Gm-Message-State: AAQBX9cOTo+GtZ/1D1ohJRTelHymwzdxKE209Bd8vh3+hiV3ey4pAtqi
        7p5ruNgnYkG/XHenswh7tvuTcg==
X-Google-Smtp-Source: AKy350ZzY8w/o89sOjPGoyZheumjR9iBcMw45dBRuofc0aGDV+AkwDQQHLf4ie1437QFSPO2gWTKag==
X-Received: by 2002:a5d:6602:0:b0:2ce:a098:c6b8 with SMTP id n2-20020a5d6602000000b002cea098c6b8mr22833083wru.55.1680377666232;
        Sat, 01 Apr 2023 12:34:26 -0700 (PDT)
Received: from workstation.ehrig.io (tmo-065-106.customers.d1-online.com. [80.187.65.106])
        by smtp.gmail.com with ESMTPSA id b5-20020a5d4b85000000b002c559843748sm5600416wrt.10.2023.04.01.12.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:34:25 -0700 (PDT)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next 2/3] bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
Date:   Sat,  1 Apr 2023 22:33:27 +0200
Message-Id: <65b05e447b28d32fb0e07275dc988989f358da2c.1680379518.git.cehrig@cloudflare.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680379518.git.cehrig@cloudflare.com>
References: <cover.1680379518.git.cehrig@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new kfuncs that allow a BPF tc-hook, installed on an ipip
device in collect-metadata mode, to control FOU encap parameters on a
per-packet level. The set of kfuncs is registered with the fou module.

The bpf_skb_set_fou_encap kfunc is supposed to be used in tandem and after
a successful call to the bpf_skb_set_tunnel_key bpf-helper. UDP source and
destination ports can be controlled by passing a struct bpf_fou_encap. A
source port of zero will auto-assign a source port. enum bpf_fou_encap_type
is used to specify if the egress path should FOU or GUE encap the packet.

On the ingress path bpf_skb_get_fou_encap can be used to read UDP source
and destination ports from the receiver's point of view and allows for
packet multiplexing across different destination ports within a single
BPF program and ipip device.

Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
---
 include/net/fou.h   |   2 +
 net/ipv4/Makefile   |   2 +-
 net/ipv4/fou_bpf.c  | 118 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/fou_core.c |   5 ++
 4 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 net/ipv4/fou_bpf.c

diff --git a/include/net/fou.h b/include/net/fou.h
index 80f56e275b08..824eb4b231fd 100644
--- a/include/net/fou.h
+++ b/include/net/fou.h
@@ -17,4 +17,6 @@ int __fou_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
 int __gue_build_header(struct sk_buff *skb, struct ip_tunnel_encap *e,
 		       u8 *protocol, __be16 *sport, int type);
 
+int register_fou_bpf(void);
+
 #endif
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 880277c9fd07..b18ba8ef93ad 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_IP_MROUTE) += ipmr.o
 obj-$(CONFIG_IP_MROUTE_COMMON) += ipmr_base.o
 obj-$(CONFIG_NET_IPIP) += ipip.o
 gre-y := gre_demux.o
-fou-y := fou_core.o fou_nl.o
+fou-y := fou_core.o fou_nl.o fou_bpf.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
diff --git a/net/ipv4/fou_bpf.c b/net/ipv4/fou_bpf.c
new file mode 100644
index 000000000000..462298d87a2f
--- /dev/null
+++ b/net/ipv4/fou_bpf.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Unstable Fou Helpers for TC-BPF hook
+ *
+ * These are called from SCHED_CLS BPF programs. Note that it is
+ * allowed to break compatibility for these functions since the interface they
+ * are exposed through to BPF programs is explicitly unstable.
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+
+#include <net/dst_metadata.h>
+
+struct bpf_fou_encap {
+	__be16 sport;
+	__be16 dport;
+};
+
+enum bpf_fou_encap_type {
+	FOU_BPF_ENCAP_FOU,
+	FOU_BPF_ENCAP_GUE,
+};
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in BTF");
+
+/* bpf_skb_set_fou_encap - Set FOU encap parameters
+ *
+ * This function allows for using GUE or FOU encapsulation together with an
+ * ipip device in collect-metadata mode.
+ *
+ * It is meant to be used in BPF tc-hooks and after a call to the
+ * bpf_skb_set_tunnel_key helper, responsible for setting IP addresses.
+ *
+ * Parameters:
+ * @skb_ctx	Pointer to ctx (__sk_buff) in TC program. Cannot be NULL
+ * @encap	Pointer to a `struct bpf_fou_encap` storing UDP src and
+ * 		dst ports. If sport is set to 0 the kernel will auto-assign a
+ * 		port. This is similar to using `encap-sport auto`.
+ * 		Cannot be NULL
+ * @type	Encapsulation type for the packet. Their definitions are
+ * 		specified in `enum bpf_fou_encap_type`
+ */
+__bpf_kfunc int bpf_skb_set_fou_encap(struct __sk_buff *skb_ctx,
+				      struct bpf_fou_encap *encap, int type)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct ip_tunnel_info *info = skb_tunnel_info(skb);
+
+	if (unlikely(!encap))
+		return -EINVAL;
+
+	if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX)))
+		return -EINVAL;
+
+	switch (type) {
+	case FOU_BPF_ENCAP_FOU:
+		info->encap.type = TUNNEL_ENCAP_FOU;
+		break;
+	case FOU_BPF_ENCAP_GUE:
+		info->encap.type = TUNNEL_ENCAP_GUE;
+		break;
+	default:
+		info->encap.type = TUNNEL_ENCAP_NONE;
+	}
+
+	if (info->key.tun_flags & TUNNEL_CSUM)
+		info->encap.flags |= TUNNEL_ENCAP_FLAG_CSUM;
+
+	info->encap.sport = encap->sport;
+	info->encap.dport = encap->dport;
+
+	return 0;
+}
+
+/* bpf_skb_get_fou_encap - Get FOU encap parameters
+ *
+ * This function allows for reading encap metadata from a packet received
+ * on an ipip device in collect-metadata mode.
+ *
+ * Parameters:
+ * @skb_ctx	Pointer to ctx (__sk_buff) in TC program. Cannot be NULL
+ * @encap	Pointer to a struct bpf_fou_encap storing UDP source and
+ * 		destination port. Cannot be NULL
+ */
+__bpf_kfunc int bpf_skb_get_fou_encap(struct __sk_buff *skb_ctx,
+				      struct bpf_fou_encap *encap)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct ip_tunnel_info *info = skb_tunnel_info(skb);
+
+	if (unlikely(!info))
+		return -EINVAL;
+
+	encap->sport = info->encap.sport;
+	encap->dport = info->encap.dport;
+
+	return 0;
+}
+
+__diag_pop()
+
+BTF_SET8_START(fou_kfunc_set)
+BTF_ID_FLAGS(func, bpf_skb_set_fou_encap)
+BTF_ID_FLAGS(func, bpf_skb_get_fou_encap)
+BTF_SET8_END(fou_kfunc_set)
+
+static const struct btf_kfunc_id_set fou_bpf_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &fou_kfunc_set,
+};
+
+int register_fou_bpf(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
+					 &fou_bpf_kfunc_set);
+}
diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index cafec9b4eee0..0c41076e31ed 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -1236,10 +1236,15 @@ static int __init fou_init(void)
 	if (ret < 0)
 		goto unregister;
 
+	ret = register_fou_bpf();
+	if (ret < 0)
+		goto kfunc_failed;
+
 	ret = ip_tunnel_encap_add_fou_ops();
 	if (ret == 0)
 		return 0;
 
+kfunc_failed:
 	genl_unregister_family(&fou_nl_family);
 unregister:
 	unregister_pernet_device(&fou_net_ops);
-- 
2.39.2

