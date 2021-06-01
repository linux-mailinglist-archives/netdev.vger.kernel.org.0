Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45492397C55
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhFAWUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhFAWUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:20:32 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF7C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 15:18:50 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id k19so463921qta.2
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 15:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nfeztu6o8kkxABpPg61jumMbzqlXlkFBS8u2O17zCNY=;
        b=rlkFwpQh/ZtbuCr66G/lXj382+lr27tjGk0NFVjW11ECQzoSVfvsyd7gDA3UTXdU5k
         p2ARSgkOB0NwDCyZxo9x+N4GFWkqebAg3FbwF0K1P/hR43tvDDD1Vpzf7vq8mtv0gxqT
         txCTz8dTFkJC+ySJRu88l20pmY+UQNeWaYzf86xAg3Kh10sjst2ZSmxpMrs/qsMpQ/rG
         T5aVJvjXHvPSwYQzrgTpkqo6jRRkbaUjJfKzt1Ta6GO8ljC9BOJH01lrUjf9TMMnmpz4
         UY/HCUAXql7WnPcnZMrjftw9RqiQx91CJue3OixTxRDLMTWTtet8+BGlwp8moxWY024A
         svng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nfeztu6o8kkxABpPg61jumMbzqlXlkFBS8u2O17zCNY=;
        b=NUYhINQil6XAV16XuhD67nJddX81xaqjlWAWO8ef+H2kI8x2ikyZEY4Sjude27h8kT
         i2tL5pWLwpWQtiGieX+25l0MYP96Ie5aWNwQtC3ck2I84fjioZGM5ao5rU5ttEOHExRu
         AgA0QELjT3NIOV669yFjVhapxbjZjRgaF4zhIkOPkKug+JU2mTJk5c/WN0rwQuBz/qls
         F0vLNbJ1haaxvDaI1YTtHfvnt17vkWUlIg7jrZW4GiarWsFTZ2erhUif25hBWKUI/XsD
         20sMH0mkpBf8QxIRvyCmmPJUN95cUW9J3O1fujN8A+BGnmge2xAUGNayEbimSswLMd2O
         1Q6g==
X-Gm-Message-State: AOAM531La/6CvOZ8M4aQ6vjp0ahYLLJxzQD8f1kk0fAuhZmIAyeAEcCk
        pTagFrDJ5wth8IjF2Uqg/PgU/6fksArGFw==
X-Google-Smtp-Source: ABdhPJwUj3C504PYluR2iGAmOzrJURPY0Dml4q8MkECucYpFCB4CEdeFHbtSyLBwbGba/FD0n3Yh3w==
X-Received: by 2002:ac8:6051:: with SMTP id k17mr21817044qtm.23.1622585929165;
        Tue, 01 Jun 2021 15:18:49 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:56ea:5ee7:bba5:d755])
        by smtp.gmail.com with ESMTPSA id n25sm1279282qtr.8.2021.06.01.15.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 15:18:48 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3 2/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Tue,  1 Jun 2021 18:18:39 -0400
Message-Id: <20210601221841.1251830-3-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
In-Reply-To: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
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

[ um build error ]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Tanner Love <tannerlove@google.com>
Suggested-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 25 +++++++++++++++++++++----
 net/core/flow_dissector.c  |  3 +++
 net/core/sysctl_net_core.c |  9 +++++++++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b465f8f3e554..cdc6152b40c6 100644
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
index 4b171ebec084..ae2ce382f4f4 100644
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
2.32.0.rc0.204.g9fa02ecfa5-goog

