Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EB739FD0B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhFHRFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:05:41 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:45668 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbhFHRFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:05:40 -0400
Received: by mail-qk1-f174.google.com with SMTP id d196so15741133qkg.12
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VA3XTpAdO8FCTIiLG6gwXF+Ua5OIw71tru/IIjOdw6k=;
        b=RB0nJ/fujTAEj52iN2C96wfpSRuRAbz4bmdOclrhkP13v9zAjakfUsjVun27lmcWhN
         +/A5KsvpL2qCJt5FGP+J17Q3GGz34wlBwgu8PyblqdyDu2r56p9O0WZPCkZ3PcRNIiWN
         0vqSLKU+v48ElVzhUw5b2tIRbWTovqXScfwJjwB793ydyHi0wh3GmLqB8Jl+1E+VYgLt
         BZ1fXQrRMsktBvMcHbeB3d5HGuYS17UAz6QF3I8ncHk3zJxkMp8Mu+mR+fbJrkJXgUFm
         /zQSZEpv0VSwas7xf2MhGI+jRI3SqCetVKXrKhlbClqoPT9FOYJFJVBqnZmomVuW02Kv
         L+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VA3XTpAdO8FCTIiLG6gwXF+Ua5OIw71tru/IIjOdw6k=;
        b=UBm1PbkNhBuCbxaNGGihUO/xOlISSiR2DIn3brGkwTxLkrR0QZGgA59LUWjBOzu1Xv
         Ywvh37xmOORzy6WDFy5sbnwv6ZdplM2uRp9wTprlIkKiS9X4TUZ52PUj6z9beEuqALWh
         Tx/iblVgtawUxDXIfhm24IRvcgeS8HcUhUCq9CUo7sDeM9+LBLAo20v4oF3w4QVS6IeN
         1mBB68/b/0XqpwGvp9rf5vCPa54tTNZCZleddF/P/VkkjHpbyQ2UpaG9X9UPJp7rfy6P
         7txoIYpH4TU2LT+uGhu0n6igx0rBm+L1YBYP7+SpjhKVKKdGTEcB77Xb6Ug3A8lW+rhb
         kLhA==
X-Gm-Message-State: AOAM531OJO/yNzEzC8yyxBRLdTFbxnkEgF5gMA0RGrY966LlJnFHSe04
        n+2pTCW5/7ClZzBDCXWJdTHiOaRokPE=
X-Google-Smtp-Source: ABdhPJxp5Fml9AtvurrDRoZAou2yO+lKSv/2KMMfFxaj+18/SgG7wxe8/peDRu6gp+P9n1bLipXPxw==
X-Received: by 2002:a05:620a:9d2:: with SMTP id y18mr13771208qky.172.1623171751634;
        Tue, 08 Jun 2021 10:02:31 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:9f44:8134:602c:7e3e])
        by smtp.gmail.com with ESMTPSA id 97sm10969017qte.20.2021.06.08.10.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 10:02:31 -0700 (PDT)
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
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Tue,  8 Jun 2021 13:02:23 -0400
Message-Id: <20210608170224.1138264-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
In-Reply-To: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
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
index 4bdad2b1d3a0..27a6ad7c72da 100644
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
2.32.0.rc1.229.g3e70b5a671-goog

