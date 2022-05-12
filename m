Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3CC524BB8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353253AbiELLdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353204AbiELLd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:33:26 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A991CD278
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:24 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d15so8524322lfk.5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEd6sKxlslOXYob+aYfGwuvE08ax3brjjZ3tUvtT5nY=;
        b=mCHGtsjtThp07FRQVWEOYHDAwe2bBM2SDMWFzwOclYH/rUTFzeOEkDMmdNLQf39AT2
         O2mNEgmOZg/cHw7jlv0Osi3mhNGYG0l8Xz49E+1YMT0zwPkbiMC1s3QXwWiOOzm0dn4X
         2Tt81II75xQVgnFqgQ4NbIPn1AZm3tiuyTeEaqNvgHmAKCVh0lGRJrDT4/tSsVjAaDDv
         qsFOHs+FzmaSvfyupxUNCNbI/vncTof4xDFmBCYbWV3Z3eudplwDwY4YBoYZgzUj00Ow
         igGvTMUVJu/KWjf1Sm5CwmrI00a5XCneA5bhaUdYVtKeqDokXwPGjxLL6ljRGAZjKuv8
         FF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEd6sKxlslOXYob+aYfGwuvE08ax3brjjZ3tUvtT5nY=;
        b=Q+7Sj4VqsoDJB4IBPXXPPv8hcbllYiOUSzZFDYUufzsM6mDOxny+JTFZEUejS5asi8
         KTmEl4DMT9LZTmTFCFRu/Bi7bvIGKs7N86nvvydU6MghuSrL4G0OZx5nKBsWgbhHvi3g
         08kiVve3yxJXlXwuVvOskNIy+5Xury05A9xYqFJFlRjXd7P7ymkubpa+coEgJaTRPwA/
         L9C3AibP+gXhaorspJoNWgzgAmdVBdRYeRwiX4TRg5olkklcFdRzDTeXSUGasAs0cNoI
         fgxMR8ItzwyOFkDOMC8rhJxnjMTnO1ri2PLKKkvWW+6Cf/GDlb2deBswo31t4qb6XH+t
         17cA==
X-Gm-Message-State: AOAM531P05nvXaY0tJGFD8RzWOSqUPKrBcG3d2wNUGPLS1gZhTbQtK2G
        tobdItACAhD3ONatjH11CEWznw==
X-Google-Smtp-Source: ABdhPJydZzsXkKuh6xmb+KoEHAkgMMM0h42G7A/Eo3hW5TLHRzkOvvI0WdKXGyQ3m/jp7y02DTwP9Q==
X-Received: by 2002:a05:6512:4009:b0:46d:31b:e05a with SMTP id br9-20020a056512400900b0046d031be05amr24343108lfb.528.1652355203000;
        Thu, 12 May 2022 04:33:23 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id r29-20020ac25a5d000000b0047255d211a6sm741758lfn.213.2022.05.12.04.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 04:33:22 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH v2 4/5] linux/virtio_net.h: Support USO offload in vnet header.
Date:   Thu, 12 May 2022 14:23:46 +0300
Message-Id: <20220512112347.18717-5-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512112347.18717-1-andrew@daynix.com>
References: <20220512112347.18717-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, it's possible to convert USO vnet packets from/to skb.
Added support for GSO_UDP_L4 offload.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 include/linux/virtio_net.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index a960de68ac69..bdf8de2cdd93 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -15,6 +15,7 @@ static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 	case VIRTIO_NET_HDR_GSO_TCPV6:
 		return protocol == cpu_to_be16(ETH_P_IPV6);
 	case VIRTIO_NET_HDR_GSO_UDP:
+	case VIRTIO_NET_HDR_GSO_UDP_L4:
 		return protocol == cpu_to_be16(ETH_P_IP) ||
 		       protocol == cpu_to_be16(ETH_P_IPV6);
 	default:
@@ -31,6 +32,7 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 	case VIRTIO_NET_HDR_GSO_UDP:
+	case VIRTIO_NET_HDR_GSO_UDP_L4:
 		skb->protocol = cpu_to_be16(ETH_P_IP);
 		break;
 	case VIRTIO_NET_HDR_GSO_TCPV6:
@@ -69,6 +71,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
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
@@ -182,6 +189,8 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
 		else if (sinfo->gso_type & SKB_GSO_TCPV6)
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
+		else if (sinfo->gso_type & SKB_GSO_UDP_L4)
+			hdr->gso_type = VIRTIO_NET_HDR_GSO_UDP_L4;
 		else
 			return -EINVAL;
 		if (sinfo->gso_type & SKB_GSO_TCP_ECN)
-- 
2.35.1

