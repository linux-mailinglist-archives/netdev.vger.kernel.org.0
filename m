Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF206D4325
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjDCLNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjDCLNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:13:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258021881C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:12:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q19so25859259wrc.5
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680520358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZLNuzKtLWlgs6Y6X1IWZZsYIByhDy9cqzVY3QztvD8=;
        b=jy4FFCj4W1GPd4u8mxyCmg4yJi77U4RIvAPJDqPUF6xM2iipbQVCdxInK0RyZQL1jC
         YNCS9mjeGD+40sd3I2njZqs0B0FrJL+6HH4/5l5Fhu7r3F+yESzWaovZ5i35jvNq/BcZ
         RMqREAWTYHZX6CDc5Gq7Wv9BzcwemCDUcYkc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZLNuzKtLWlgs6Y6X1IWZZsYIByhDy9cqzVY3QztvD8=;
        b=OeWv+/xjUQxZ/l55/XsveFy9ORCu6E3jrKFqJ0KWWU7gXyZK/gJvmPjzPRa8VXpnj0
         14Re/JWxWBsGNDHnTZ8PGJhdnZNVHfqjRTM7ntb7rOJwx+z224Bni4HbTTxLPDOHvLNH
         5X1KiMw1feXV+GMT+IzAS9k1cz1YwSw7OxYYfGy0gRTZheQKdtKObXDRCbfLx3HmyWl1
         1Y6jre1u529scrJJNZOeuoc0iXbnVfAylfDF3fFJ1vpv6DWB05PQf6WPxd6IlrphIbox
         hsQJ6D5BUI96CUkK+3JLFNy3sFvviEpGAw9r0B9TKnHVC1OGM+U/UNfOV+XCydu0d/D8
         EeVQ==
X-Gm-Message-State: AAQBX9feqMEe3D/eRPcZQXi7Zaz/ffu3jiz39YZ1udHN4R3DacJ8JaDP
        tZKwGyso8o9Kp5pg+4OEqvcVhg==
X-Google-Smtp-Source: AKy350b6PtyTH2NhbmRpAUnOLx+YvBEU55u36HMrmiJvHzsHE0fiO2hXXXIdpHRUgB8aNeHN85j9kg==
X-Received: by 2002:a5d:4ecc:0:b0:2d1:9ce9:2b99 with SMTP id s12-20020a5d4ecc000000b002d19ce92b99mr25187273wrv.18.1680520358383;
        Mon, 03 Apr 2023 04:12:38 -0700 (PDT)
Received: from workstation.ehrig.io (tmo-066-125.customers.d1-online.com. [80.187.66.125])
        by smtp.gmail.com with ESMTPSA id y11-20020adffa4b000000b002c7066a6f77sm9505517wrr.31.2023.04.03.04.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:12:37 -0700 (PDT)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, kernel-team@cloudflare.com,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/3] bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
Date:   Mon,  3 Apr 2023 14:12:08 +0200
Message-Id: <e17c94a646b63e78ce0dbf3f04b2c33dc948a32d.1680520500.git.cehrig@cloudflare.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680520500.git.cehrig@cloudflare.com>
References: <cover.1680520500.git.cehrig@cloudflare.com>
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

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202304020425.L8MwfV5h-lkp@intel.com/
Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
---
 include/net/fou.h   |   2 +
 net/ipv4/Makefile   |   2 +-
 net/ipv4/fou_bpf.c  | 119 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/fou_core.c |   5 ++
 4 files changed, 127 insertions(+), 1 deletion(-)
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
index 000000000000..3760a14b6b57
--- /dev/null
+++ b/net/ipv4/fou_bpf.c
@@ -0,0 +1,119 @@
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
+#include <net/fou.h>
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

