Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6857C49AF4D
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456026AbiAYJIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455339AbiAYJE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:04:26 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D01C061359
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:26 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id a25so11788634lji.9
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 00:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=baQ+umQNqHWDum1lpPhk7WW3HA5LDWS+YAun2KSlxoM=;
        b=wDBHF7w/TMCb+hQit42vS3t/lC2517uJvPUBhXqfdal8jFWSxDixIdeHImw94pMhB9
         W/f5jjHcIoSKzFZPwx0UyQRx1HbhvsrRTy9LNxD8iZoa251NscFVFZuAEscBM6N3hDsQ
         NnH2t8ECcNwthNO5DibTwt2kykb16IQ9DGEpoSY/KR5Am9y5CTGEvxZQXL/mauiXRIBU
         Qc21Vx3CCtxwjUFB5Iou22VHPZ1ostv8ol7NyHBmJQcMOTSFKVW2gJuEknM5jSEe0H1m
         9TNftXM0SRofdK18MnBocE0I8NruSmiIE4gm+emYaz4cUNijLiUedvW8GyyzRlA8BEsg
         X8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=baQ+umQNqHWDum1lpPhk7WW3HA5LDWS+YAun2KSlxoM=;
        b=UJt/MQVUgSLfw8weKs64q9stDsZrZdciK/MX1YirfdY76kaUhWwDGI3Lbl6cf5jcXH
         P29pZzwCFTEbGWxAam9t4xuKomj7m1CHoGADzcg0PL8neflxeaAzP+S7F/Zxn572nLpo
         4fBS7ywOEhS2Kr1BHT146r+gxwXxfQGolPOyGD4U1t6k8Uvt3q4XxHsmg3vvDsCjdNYU
         U8DWQBmEkHee1tkj2prLBxCL4FJ/rZCUsQ/r5FV9YRtn3A/cR1O+trjw3SvjIlBOIWAX
         HUA7vtmUQhL4a+88m6nqVCdH1kUjsUFUpYuGhNBlhcY+hQeXZ3P2/0VqR2NEQkJ+3LMF
         0YHA==
X-Gm-Message-State: AOAM533qM3PU27hu5r2QYUHRve4PDbYh4bMgHhY3SCUEI+74xXEUC78P
        /xhRGCitx+Jao074E3rjS2VQhg==
X-Google-Smtp-Source: ABdhPJxwoXFjwGNabYMY+I6uihGStNKdiHmxSD+sVeV0Up4jOraro+EZiNLGhfeRiUwhmTKg6Qqrhw==
X-Received: by 2002:a2e:7f10:: with SMTP id a16mr14008651ljd.48.1643100444520;
        Tue, 25 Jan 2022 00:47:24 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id q5sm1418944lfe.279.2022.01.25.00.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:47:24 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yuri.benditovich@daynix.com, yan@daynix.com
Subject: [RFC PATCH 4/5] linux/virtio_net.h: Added Support for GSO_UDP_L4 offload.
Date:   Tue, 25 Jan 2022 10:47:01 +0200
Message-Id: <20220125084702.3636253-5-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125084702.3636253-1-andrew@daynix.com>
References: <20220125084702.3636253-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, it's possible to convert vnet packets from/to skb.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/linux/virtio_net.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index a960de68ac69..9311d41d0a81 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -17,6 +17,9 @@ static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 	case VIRTIO_NET_HDR_GSO_UDP:
 		return protocol == cpu_to_be16(ETH_P_IP) ||
 		       protocol == cpu_to_be16(ETH_P_IPV6);
+	case VIRTIO_NET_HDR_GSO_UDP_L4:
+		return protocol == cpu_to_be16(ETH_P_IP) ||
+		       protocol == cpu_to_be16(ETH_P_IPV6);
 	default:
 		return false;
 	}
@@ -31,6 +34,7 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 	case VIRTIO_NET_HDR_GSO_UDP:
+	case VIRTIO_NET_HDR_GSO_UDP_L4:
 		skb->protocol = cpu_to_be16(ETH_P_IP);
 		break;
 	case VIRTIO_NET_HDR_GSO_TCPV6:
@@ -69,6 +73,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			ip_proto = IPPROTO_UDP;
 			thlen = sizeof(struct udphdr);
 			break;
+		case VIRTIO_NET_HDR_GSO_UDP_L4:
+			gso_type = SKB_GSO_UDP_L4;
+			ip_proto = IPPROTO_UDP;
+			thlen = sizeof(struct udphdr);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -182,6 +191,8 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
 		else if (sinfo->gso_type & SKB_GSO_TCPV6)
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
+		else if (sinfo->gso_type & SKB_GSO_UDP_L4)
+			hdr->gso_type = VIRTIO_NET_HDR_GSO_UDP_L4;
 		else
 			return -EINVAL;
 		if (sinfo->gso_type & SKB_GSO_TCP_ECN)
-- 
2.34.1

