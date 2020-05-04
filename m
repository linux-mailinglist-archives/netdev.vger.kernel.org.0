Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8E1C406B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 18:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbgEDQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 12:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgEDQs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 12:48:59 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F9BC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 09:48:58 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 23so223663qkf.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 09:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9x9HKRXKxxVl+pdU9Ao1YZ51nD3dKH9WcqdonJorQg=;
        b=vXH5ulJo8rEvxMNkZ+U81UifIJRKRyZhGD1arHYqpOZfnRi2qx6QILYay9NDMiUGV/
         +J9ryzU68m1pmlj1MkwW+W2xbXywmc/LlLKPomss6vXLJuxlWez7tlu4ItidwiD9/W4b
         bF3K8lBjLF4j7k3TLttoZV9hPHpMnk3z63Z3VPy8vH2yhv8hL0ZzczD1Y5gR7xdyhoBi
         RerCkwwYGcfSavUlInCpiAKYSuGnsvi1MUWMEUxD6tShRdh5Ic1S59G0vYh5YFDSVuOg
         7+h59qz2/wdqphV5H1jslT3yTMLRRaxYyimUMQJ8T2dNynBtJhFbFQsHSE0SM2sfrC6d
         CY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9x9HKRXKxxVl+pdU9Ao1YZ51nD3dKH9WcqdonJorQg=;
        b=W9JnOvK37pQ1lFqK6MDk87D4/blSn4UoRpokNIWOqZU5TLO+/EkDhHg7906moo8iKz
         dDCekZ6Dp6B+GrFzYhJmnNGKpgDhGNOFjYoq9kZV6vFbqgYascF0xiPa/S3rTn+Nn1YD
         nPTPsQBrYmKWx+qcJffg5lO3f0n35ZFsYFFDRKGqICVeO4Y9PDqgY/2LutNH4EX02u/+
         rIZdrFFz/4UgxabajWnxnP2EMv9mPRYhtIxF8dmdKXBsF7MBH0VaSPuUnQGGch0569+G
         hQCBamSSv7wGPHLiwRnUj7pNo6hiKas/oI2tH86lTbCTjrTylBayyygzil2tZZIRBCql
         OiCg==
X-Gm-Message-State: AGi0PuYc6c0P4+9QnzjmzHznZHbTZs4jx45I2VZM+k04gtvFsGjikxn3
        i8+wBKNcFXP5EDdMHhw5HadwBDRk
X-Google-Smtp-Source: APiQypImPuFnTlDh2Vs8zHrg01EDzJmFjtC9m+ms119a7i6sw7Wfjg+CdRmR63B5pzWC/qF4FHI4cw==
X-Received: by 2002:a05:620a:1509:: with SMTP id i9mr31242qkk.445.1588610937808;
        Mon, 04 May 2020 09:48:57 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id q185sm806045qkf.100.2020.05.04.09.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 09:48:57 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: stricter validation of untrusted gso packets
Date:   Mon,  4 May 2020 12:48:54 -0400
Message-Id: <20200504164855.154740-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Syzkaller again found a path to a kernel crash through bad gso input:
a packet with transport header extending beyond skb_headlen(skb).

Tighten validation at kernel entry:

- Verify that the transport header lies within the linear section.

    To avoid pulling linux/tcp.h, verify just sizeof tcphdr.
    tcp_gso_segment will call pskb_may_pull (th->doff * 4) before use.

- Match the gso_type against the ip_proto found by the flow dissector.

Fixes: bfd5f4a3d605 ("packet: Add GSO/csum offload support.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 0d1fe9297ac6..6f6ade63b04c 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -3,6 +3,8 @@
 #define _LINUX_VIRTIO_NET_H
 
 #include <linux/if_vlan.h>
+#include <uapi/linux/tcp.h>
+#include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
 
 static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
@@ -28,17 +30,25 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 					bool little_endian)
 {
 	unsigned int gso_type = 0;
+	unsigned int thlen = 0;
+	unsigned int ip_proto;
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 		case VIRTIO_NET_HDR_GSO_TCPV4:
 			gso_type = SKB_GSO_TCPV4;
+			ip_proto = IPPROTO_TCP;
+			thlen = sizeof(struct tcphdr);
 			break;
 		case VIRTIO_NET_HDR_GSO_TCPV6:
 			gso_type = SKB_GSO_TCPV6;
+			ip_proto = IPPROTO_TCP;
+			thlen = sizeof(struct tcphdr);
 			break;
 		case VIRTIO_NET_HDR_GSO_UDP:
 			gso_type = SKB_GSO_UDP;
+			ip_proto = IPPROTO_UDP;
+			thlen = sizeof(struct udphdr);
 			break;
 		default:
 			return -EINVAL;
@@ -57,16 +67,22 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
+
+		if (skb_transport_offset(skb) + thlen > skb_headlen(skb))
+			return -EINVAL;
 	} else {
 		/* gso packets without NEEDS_CSUM do not set transport_offset.
 		 * probe and drop if does not match one of the above types.
 		 */
 		if (gso_type && skb->network_header) {
+			struct flow_keys_basic keys;
+
 			if (!skb->protocol)
 				virtio_net_hdr_set_proto(skb, hdr);
 retry:
-			skb_probe_transport_header(skb);
-			if (!skb_transport_header_was_set(skb)) {
+			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
+							      NULL, 0, 0, 0,
+							      0)) {
 				/* UFO does not specify ipv4 or 6: try both */
 				if (gso_type & SKB_GSO_UDP &&
 				    skb->protocol == htons(ETH_P_IP)) {
@@ -75,6 +91,12 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 				}
 				return -EINVAL;
 			}
+
+			if (keys.control.thoff + thlen > skb_headlen(skb) ||
+			    keys.basic.ip_proto != ip_proto)
+				return -EINVAL;
+
+			skb_set_transport_header(skb, keys.control.thoff);
 		}
 	}
 
-- 
2.26.2.526.g744177e7f7-goog

