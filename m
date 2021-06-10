Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41BB3A336D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFJSmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:42:19 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:35366 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhFJSmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:42:18 -0400
Received: by mail-qk1-f169.google.com with SMTP id j189so28425943qkf.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZjXhf7xAD+q7I3H4p27TsjOp3/FmCkJmtXEFpGE8R+U=;
        b=s5sO2tuUO0C6soSsx5At8DXsS68EqrCKWcfCasGxEIX3po6NaqoUFjnFdmuH0izr4n
         nXrtq1JPKTvx6GiAhLa76MtQvUuX/E7ygLeRZffs3P/61HCN324eUp3gz3KBoLIeHc9u
         0GLPRIxNFLxXUz/ADjujwA/li09uINvqJiQ0kwvKyQZcLzYbWjCb6qo1E2uIUqENrMtT
         Yh3qL5zRO6N+TTA250GGD3EJzKs4Zl0Haz0nXyB5BgpPRmYg4yWjKAuQdnvnNFqvNelF
         7nXIxKMB8WM0MM5CRAz1rPP7AI6bscMxaF7mhGIx3I3iA2G0mFldony5sITqWJJJJ3KU
         FxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZjXhf7xAD+q7I3H4p27TsjOp3/FmCkJmtXEFpGE8R+U=;
        b=hM4GoGk7IHY0Z/y/53AUrHJWYyMemenjkoT31CS3FSdL7MKKbTgETNmsXT3QbJ3j/f
         m/A1A+WaHBHVtuJVFX4lQJ4ZX0RhPnO4r3cvUdRC5m9URTY+8RidbkNHTCLKULVvkhg5
         WT+IxooS57aGaubG6bmXaYfJcwoRMBY0Vfo/OpicDSLVGjCXll4zZyzoUiQaoulnlZLh
         HGWXJXEAZiIvWUYR1TB+XrkomRGZ3bufXOk873TKP841iThlc3oouzFctMKdrA4rNEoL
         kSffAXxcC5iZDhTxcO4+89CR7ply0zNBKNPPqKzY0WfEU3zZqxOYfuvlzSKpoMb6xTmV
         T9oQ==
X-Gm-Message-State: AOAM531qffdljX2AgESm5gWyPCrlVlDFx0l4jbRu3dlMEvcCqSN7eo+s
        hgiVmbnSyd40nQA/RM1bz7UxEEQBcb0=
X-Google-Smtp-Source: ABdhPJyerJec6utNxCtCtFD6kafgEE8CVvsNHjStWb4/k+lTm/k/RTlcPmhezf/tChRKB03gNnmhCg==
X-Received: by 2002:a37:cc5:: with SMTP id 188mr959960qkm.112.1623350344358;
        Thu, 10 Jun 2021 11:39:04 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:840f:b35f:63b2:482e])
        by smtp.gmail.com with ESMTPSA id a134sm2760350qkg.114.2021.06.10.11.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:39:04 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v5 2/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Thu, 10 Jun 2021 14:38:52 -0400
Message-Id: <20210610183853.3530712-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
References: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Syzkaller bugs have resulted from loose specification of
virtio_net_hdr[1]. Enable execution of a BPF flow dissector program
in virtio_net_hdr_to_skb to validate the vnet header and drop bad
input.

Introduce a new sysctl net.core.flow_dissect_vnet_hdr controlling a
static key to decide whether to perform flow dissection. When the key
is false, virtio_net_hdr_to_skb computes as before.

A permissive specification of vnet headers is part of the ABI. Some
applications now depend on it. Still, many of these packets are bogus.
Give admins the option to interpret behavior more strictly. For
instance, verifying that a VIRTIO_NET_HDR_GSO_TCPV6 header matches a
packet with unencapsulated IPv6/TCP without extension headers, with
payload length exceeding gso_size and hdr_len exactly at TCP payload
offset.

BPF flow dissection implements protocol parsing in an safe way. And is
configurable, so can be as pedantic as the workload allows (e.g.,
dropping UFO altogether).

Vnet_header flow dissection is *not* a substitute for fixing bugs when
reported. But even if not enabled continuously, offers a quick path to
mitigating vulnerabilities.

[1] https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0

Changes
v4:
  - Expand commit message with rationale for bpf flow dissector based
    implementation
v3:
  - Move sysctl_flow_dissect_vnet_hdr_key definition to
    flow_dissector.c to fix CONFIG_SYSCTL warning when building UML

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Tanner Love <tannerlove@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 25 +++++++++++++++++++++----
 net/core/flow_dissector.c  |  3 +++
 net/core/sysctl_net_core.c |  9 +++++++++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b465f8f3e554..b67b5413f2ce 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -25,10 +25,13 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	return 0;
 }
 
+DECLARE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
+
 static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 					const struct virtio_net_hdr *hdr,
 					bool little_endian)
 {
+	struct flow_keys_basic keys;
 	unsigned int gso_type = 0;
 	unsigned int thlen = 0;
 	unsigned int p_off = 0;
@@ -78,13 +81,24 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		p_off = skb_transport_offset(skb) + thlen;
 		if (!pskb_may_pull(skb, p_off))
 			return -EINVAL;
-	} else {
+	}
+
+	/* BPF flow dissection for optional strict validation.
+	 *
+	 * Admins can define permitted packets more strictly, such as dropping
+	 * deprecated UDP_UFO packets and requiring skb->protocol to be non-zero
+	 * and matching packet headers.
+	 */
+	if (static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
+	    !__skb_flow_dissect_flow_keys_basic(NULL, skb, &keys, NULL, 0, 0, 0,
+						0, hdr, little_endian))
+		return -EINVAL;
+
+	if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM)) {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
 		 * probe and drop if does not match one of the above types.
 		 */
 		if (gso_type && skb->network_header) {
-			struct flow_keys_basic keys;
-
 			if (!skb->protocol) {
 				__be16 protocol = dev_parse_header_protocol(skb);
 
@@ -92,8 +106,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 				if (protocol && protocol != skb->protocol)
 					return -EINVAL;
 			}
+
 retry:
-			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
+			/* only if flow dissection not already done */
+			if (!static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
+			    !skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
 							      NULL, 0, 0, 0,
 							      0)) {
 				/* UFO does not specify ipv4 or 6: try both */
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index d3df4339e0ae..ce02b76d2308 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -35,6 +35,9 @@
 #endif
 #include <linux/bpf-netns.h>
 
+DEFINE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
+EXPORT_SYMBOL(sysctl_flow_dissect_vnet_hdr_key);
+
 static void dissector_set_key(struct flow_dissector *flow_dissector,
 			      enum flow_dissector_key_id key_id)
 {
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index c8496c1142c9..c01b9366bb75 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -36,6 +36,8 @@ static int net_msg_warn;	/* Unused, but still a sysctl */
 int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
 EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 
+DECLARE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
+
 /* 0 - Keep current behavior:
  *     IPv4: inherit all current settings from init_net
  *     IPv6: reset all settings to default
@@ -580,6 +582,13 @@ static struct ctl_table net_core_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &int_3600,
 	},
+	{
+		.procname       = "flow_dissect_vnet_hdr",
+		.data           = &sysctl_flow_dissect_vnet_hdr_key.key,
+		.maxlen         = sizeof(sysctl_flow_dissect_vnet_hdr_key),
+		.mode           = 0644,
+		.proc_handler   = proc_do_static_key,
+	},
 	{ }
 };
 
-- 
2.32.0.272.g935e593368-goog

