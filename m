Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8593A72CF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFOAOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:14:11 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:45974 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFOAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:14:11 -0400
Received: by mail-qk1-f182.google.com with SMTP id d196so35156909qkg.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmIONWC9nd7fP7WQBXbeHQMo9i/5X+tKVlS3hKYyQ0I=;
        b=RYOZUUPltI68JrBHYKiydRijuJUV+w4hYqOlBczuS6rZBSC9kyE1cG8N7ydSbXLuZk
         AxiKZjNZY9Xlr9JLUVXzL712sglPTKZtA90PZS1yJ8If/I8LuJj7SPirvFhVXbuRuZTf
         7iP4iZ5WwGFt9g7k2u2v8LTLRWHmbn4x4FKILghet4YNhmhNGu2McCNTPkUnNRl2848d
         MUFsw6aStNrQ5PKn6VZXzYkVa3sBE08LIvBv4fNU/Kru1r7RPaNj1Wy+as9TtV1tq/N1
         urT3IVHRYB5rh5/zZyTvgvxp2hlWS6cATfALIv2ciiS7PCxEcNK/UgX+NqeepS/MIzGV
         l92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmIONWC9nd7fP7WQBXbeHQMo9i/5X+tKVlS3hKYyQ0I=;
        b=jX+AL3TXOMMpDRV76tl5SRVwj2DGv653UNJCnxHnXUsWFtxb9yvUHxxmFUSynopQBX
         T+sVdW+Yt6A0g5jceqHNyLFTDG/WXhCxwWXXN1/Znh4QxmIJEL1Gu/ngRGVTLrGgHJb3
         TejdbCBFd8HMRTvNq49Vlo+9Td9oPGYb9t41dv6N8jQ0Ms7WgOGqvbo/zn62r3n2ia+j
         IqhiJCRnB73DwpViziJr0UdE56CzHMK7rKAUNMfEDzjRKgEqKpZ8QpNLmxtR5rhksHmK
         HGkXPl1vWmJn4HRE9MlyWA0MG0wo6IWCPmFXr/W0DZw8PjcUby2+IZVZhciytmHNnGz/
         pg6g==
X-Gm-Message-State: AOAM532vNXgIluCmQqiXShM83ZrPG7jG9tMKD0vvoA5IMNQ9UVXEf5oP
        PwjLbalaobRhAND0EUNegFHYZypAI0s=
X-Google-Smtp-Source: ABdhPJxyUhNRIG6Td51p7rAH2xPbM/121t96wHtUC63fk33NXQsP/LNPPRKAJtPaH1BsF0uy6N1IXg==
X-Received: by 2002:a37:6609:: with SMTP id a9mr19243579qkc.459.1623715867270;
        Mon, 14 Jun 2021 17:11:07 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:592b:4d3c:3a31:b1fe])
        by smtp.gmail.com with ESMTPSA id e1sm11153087qti.27.2021.06.14.17.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:11:07 -0700 (PDT)
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
Subject: [PATCH net-next v6 2/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Mon, 14 Jun 2021 20:10:59 -0400
Message-Id: <20210615001100.1008325-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
References: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
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
index afbfef4402f5..2422166c2d8c 100644
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

