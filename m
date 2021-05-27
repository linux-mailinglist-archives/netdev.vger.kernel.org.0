Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE103937CD
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhE0VOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 17:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbhE0VN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 17:13:58 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B955C061760
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 14:12:25 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 76so2104303qkn.13
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 14:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SIe9zUzXkAQz1y6Sqd15GO+8qYPx3M6sSjI36nGtGVQ=;
        b=TIbrnAClam9R6NKpCLvATdTz36I/CWuJ3C+gbmyerIal8NZ569jfqLR9rTR7Fc4Zds
         NIK5qhUO51RYvcJ/N19DuBgmxZ0+oZ2Wa7YBP8logDEBty7WELUfSS8t3R99J6zxWrnc
         m78dmbsHEZvt7RzhgdGDQcvdmDgpNJb56qtOI3UUFopa8S12JPvzqta2/DSKxoF5sK0C
         SeeIuyHBcVsT/0NAdcE49eoVMUzSQEz8GojWFJtIO5G9xKr3YCCZuDviC9o7MIicrUHs
         b6KLe4PV+hktQ+L5Q8X9dFEp9m2vfo2B+oW1sH0cS0biskYFNUomHqlzYLeG8TF4Nek1
         RGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SIe9zUzXkAQz1y6Sqd15GO+8qYPx3M6sSjI36nGtGVQ=;
        b=KpoNl4qEXoV/8aIVlCGCfD/2StX940FFUsHWsJ2rmj8yjvl+SA9R64ZwDHGOS9SpA7
         97Vvej9cNw0g+aroD4mRFKdrHwRQY6djGecB2wVS601QqvuksqPQE6hLqEEh6djcAdHj
         fby7B7LKC9MA6Z7B1J/2LERE2a/dkOTgZiIBG1rWbo6ScR6O/Xi3XEGlhs41wq22uZbY
         v2rf0Mak9/7MsmJTumSzbFClN3jdXlqv9bNNT40eYpF4LkCAppYRQb8Qmmq7yRKrN09Q
         vkyBtd1BdcHTEqRiRpkzRsbfys6qKzejTt7nW61pSxSLjk8G499jsfGuGIespRfRwmUo
         RYzg==
X-Gm-Message-State: AOAM5312D7BiYhgjb79yKibWBLYIFjNM0MbinOhi1xYzYvUSdFP2ZYE+
        cfirLXOmbfX+qT8ZE3I5x9NWWnNQs9g=
X-Google-Smtp-Source: ABdhPJz09fkjcSE4MLjmujNjRs/2X4hN7a1oSIDZ8chDRP846yBJMKyenh9Kln5zkwgasAPQVH3Tjw==
X-Received: by 2002:a37:91c2:: with SMTP id t185mr536850qkd.430.1622149944188;
        Thu, 27 May 2021 14:12:24 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:2437:9aae:c493:2542])
        by smtp.gmail.com with ESMTPSA id f19sm2271362qkg.70.2021.05.27.14.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 14:12:23 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 2/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Thu, 27 May 2021 17:12:13 -0400
Message-Id: <20210527211214.1960922-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
In-Reply-To: <20210527211214.1960922-1-tannerlove.kernel@gmail.com>
References: <20210527211214.1960922-1-tannerlove.kernel@gmail.com>
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

The existing behavior of accepting these vnet headers is part of the
ABI. But individual admins may want to enforce restrictions. For
example, verifying that a GSO_TCPV4 gso_type matches packet contents:
unencapsulated TCP/IPV4 packet with payload exceeding gso_size and
hdr_len at payload offset.

Introduce a new sysctl net.core.flow_dissect_vnet_hdr controlling a
static key to decide whether to perform flow dissection. When the key
is false, virtio_net_hdr_to_skb computes as before.

[1] https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0

Signed-off-by: Tanner Love <tannerlove@google.com>
Suggested-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 27 +++++++++++++++++++++++----
 net/core/sysctl_net_core.c | 10 ++++++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b465f8f3e554..a92fcf38087d 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -3,6 +3,8 @@
 #define _LINUX_VIRTIO_NET_H
 
 #include <linux/if_vlan.h>
+#include <linux/jump_label.h>
+#include <net/sock.h>
 #include <uapi/linux/tcp.h>
 #include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
@@ -25,10 +27,13 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
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
@@ -78,13 +83,24 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
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
+						0, hdr))
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
 
@@ -92,8 +108,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
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
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index c8496c1142c9..277eb6ba3b01 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -36,6 +36,9 @@ static int net_msg_warn;	/* Unused, but still a sysctl */
 int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
 EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 
+DEFINE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
+EXPORT_SYMBOL(sysctl_flow_dissect_vnet_hdr_key);
+
 /* 0 - Keep current behavior:
  *     IPv4: inherit all current settings from init_net
  *     IPv6: reset all settings to default
@@ -580,6 +583,13 @@ static struct ctl_table net_core_table[] = {
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
2.32.0.rc0.204.g9fa02ecfa5-goog

