Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFAD47AE3D
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhLTO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 09:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbhLTO5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 09:57:10 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931EDC08ED36
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:49:13 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id n15so10004632qta.0
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgiAL6+9Cn5VrMf5vyzz26rDBTaUVBJwEWdvD3nY96I=;
        b=DSEvX1FCt4Wf1TBJVFCAfLzs9iAtZJBzV0LblrxqXiPLTMmShQcoBYucyfY6+VgOmI
         qjsVJwZr5Y80xvPJjQX9ry/me+2XNnwXSZWWVwNLd7CibYZjMEuosbmmaDf/lQNANVOB
         nHKA0n9BijT/5ojn7t83CSIHzKh5MImx1xwA17dfWiQ0HxTyKN2YA6am1vyAHZVy0c0j
         KausprL7XRna9RDzu2k/IlP3Kh2LNtfgVZmD8P5IhS+uRbQGHfdRoHR9NY6FaWn2E2gW
         NLMmZHk4m5GNjcPS3vaN4wsEkBXbX6nLPrUwWYsIP/d0qVPRE/XNtK+u6YCc4Lx0lQ8n
         oGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pgiAL6+9Cn5VrMf5vyzz26rDBTaUVBJwEWdvD3nY96I=;
        b=L+K2FZi2BDiBjmFKcaTnAVkYN1V5Ny6vR2Tzo6KUjKDo1yPZLNaxURhOHD2hYgGSaL
         kziUo/5dwAFJ0Fh2VajzdeCQdxDgtCglDj4LlZZ2d80IYlxWsoSU1e7CIK9yoLQ+vqx/
         S+G6ckazDnFX6TUN3z5jasT2GmvBizc3sjb5rJ5gcDfbOk0YmgmB/nxKIzQNZz49dcIX
         Ix0E1zTxkxqGMXryHwBW0OgPJvxRyDVZwjAMoYzZVURmMZwbTFVQ6E+O77VV7lRBx+Ue
         vaG5Ti1HqwWl5WRhwIAwhCVs8cR57U71wtWrgvrCiUotLG4HzBZgFBxzqh5iokHtIEzg
         Bwpg==
X-Gm-Message-State: AOAM533CFACYDjEQyyXoHycR13eC/pjNwxisc+oO5/ScMVZamro2CVtt
        jYeFoLGb3X4RAZINgxnq5hpiiTGbZoM=
X-Google-Smtp-Source: ABdhPJyY9h6NYSBULKcNO7CTD7vetRIh5WciUfqBx1Xx89nonl0bn+TZEa2nBFr+bWJ+mByM8MVVHA==
X-Received: by 2002:ac8:5f82:: with SMTP id j2mr12549284qta.572.1640011752699;
        Mon, 20 Dec 2021 06:49:12 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id br13sm11983233qkb.10.2021.12.20.06.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:49:12 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nemeth@redhat.com,
        Willem de Bruijn <willemb@google.com>,
        Andrew Melnichenko <andrew@daynix.com>
Subject: [PATCH net] net: accept UFOv6 packages in virtio_net_hdr_to_skb
Date:   Mon, 20 Dec 2021 09:49:01 -0500
Message-Id: <20211220144901.2784030-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Skb with skb->protocol 0 at the time of virtio_net_hdr_to_skb may have
a protocol inferred from virtio_net_hdr with virtio_net_hdr_set_proto.

Unlike TCP, UDP does not have separate types for IPv4 and IPv6. Type
VIRTIO_NET_HDR_GSO_UDP is guessed to be IPv4/UDP. As of the below
commit, UFOv6 packets are dropped due to not matching the protocol as
obtained from dev_parse_header_protocol.

Invert the test to take that L2 protocol field as starting point and
pass both UFOv4 and UFOv6 for VIRTIO_NET_HDR_GSO_UDP.

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Link: https://lore.kernel.org/netdev/CABcq3pG9GRCYqFDBAJ48H1vpnnX=41u+MhQnayF1ztLH4WX0Fw@mail.gmail.com/
Reported-by: Andrew Melnichenko <andrew@daynix.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 04e87f4b9417..22dd48c82560 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -7,6 +7,21 @@
 #include <uapi/linux/udp.h>
 #include <uapi/linux/virtio_net.h>
 
+static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
+{
+	switch (gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+	case VIRTIO_NET_HDR_GSO_TCPV4:
+		return protocol == cpu_to_be16(ETH_P_IP);
+	case VIRTIO_NET_HDR_GSO_TCPV6:
+		return protocol == cpu_to_be16(ETH_P_IPV6);
+	case VIRTIO_NET_HDR_GSO_UDP:
+		return protocol == cpu_to_be16(ETH_P_IP) ||
+		       protocol == cpu_to_be16(ETH_P_IPV6);
+	default:
+		return false;
+	}
+}
+
 static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 					   const struct virtio_net_hdr *hdr)
 {
@@ -88,9 +103,12 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			if (!skb->protocol) {
 				__be16 protocol = dev_parse_header_protocol(skb);
 
-				virtio_net_hdr_set_proto(skb, hdr);
-				if (protocol && protocol != skb->protocol)
+				if (!protocol)
+					virtio_net_hdr_set_proto(skb, hdr);
+				else if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
 					return -EINVAL;
+				else
+					skb->protocol = protocol;
 			}
 retry:
 			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
-- 
2.34.1.173.g76aa8bc2d0-goog

