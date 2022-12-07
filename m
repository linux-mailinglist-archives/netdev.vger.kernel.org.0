Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B91645951
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiLGLvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiLGLvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:51:40 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563A350D60
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:51:35 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id t17so13418885eju.1
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 03:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XMtP14B7qgPGyencUQ441983HC3jgMwtJjN+dpKWwyo=;
        b=5PwLz66EoXm/pQQmlpL7Thi8Bik05FDzBuJ6U1efGar6l2qNC50/MOdysQIGWFUqxq
         2isSlvgV0SU9y0gA8EYFxLIrrQrsl6Zh2nVUH5vdfWP+5M+GhoWywYn21jq4uiJ9FCvd
         XM+soq9miOdKIFQFN94Ref9VbFhFtT54JxqXY0bsahsfBy6EIdySJUoyVB5EaNVM+Eki
         97n/zCoTPX+PrW+0QqsfghBfhQkXvqfN4fr6A7yDBWYjLQIE/1qgsEWRYJI+Seou1mG/
         /YntbZqgdV+uJJX1nqrO4BsFyIsXq24UA+CDKRSkAQZF4oBjIdVdmOj4KdUBsVgEnVkY
         Iulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XMtP14B7qgPGyencUQ441983HC3jgMwtJjN+dpKWwyo=;
        b=fmfyQFLDuD58LLPbgBmeUIABdjifNwrrOQxx2e16jtjmLlCOc0T0i/l9uPsDPG/trF
         5krBL/WW+oAgxkImA0y8uM9AfdjUmUhvlRnrd3u3HQZdQGtzMDZNCNGldPjpf5GLpWSZ
         L2qGgUhV6A+VzcFOFyeCsSHx1EvobKN5n8Ek+4tOJzVeZZoOLRDXkATDDiqI+vNBS2Vy
         onwcnFt+CJuR1ygGPIuNGwYYweiPGCBRqMdO9qfeeGbeDEzTNT7ue3bqKyvPHI6p/35O
         XUQaPW78czvSxTVJmTj86JnzzD4iGcp8uSluGwwQqSYpteC/FOVY7L059T59J9RDfpvB
         AlHA==
X-Gm-Message-State: ANoB5plSW94lxyYJTxNIoaVtSk7JGv2wqqBLZoL9Ha64mu8K6bizxl1d
        9YacoegYrLdN+dWj7SOz8ZhpQg==
X-Google-Smtp-Source: AA0mqf6dB/YbyuUWSS2DbhXio3PDff2r31R483hX8azPX7si2rj/3NsNmK4wYmoBRtkX+7w8pu+5dg==
X-Received: by 2002:a17:906:1713:b0:7a3:fc74:7fb4 with SMTP id c19-20020a170906171300b007a3fc747fb4mr80015173eje.17.1670413893893;
        Wed, 07 Dec 2022 03:51:33 -0800 (PST)
Received: from localhost.localdomain ([193.33.38.48])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402181a00b004618a89d273sm2132816edy.36.2022.12.07.03.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 03:51:33 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 6/6] drivers/net/virtio_net.c: Added USO support.
Date:   Wed,  7 Dec 2022 13:35:58 +0200
Message-Id: <20221207113558.19003-7-andrew@daynix.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207113558.19003-1-andrew@daynix.com>
References: <20221207113558.19003-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, it possible to enable GSO_UDP_L4("tx-udp-segmentation") for VirtioNet.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 86e52454b5b5..97d63c819c7b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -60,13 +60,17 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_TSO6,
 	VIRTIO_NET_F_GUEST_ECN,
 	VIRTIO_NET_F_GUEST_UFO,
-	VIRTIO_NET_F_GUEST_CSUM
+	VIRTIO_NET_F_GUEST_CSUM,
+	VIRTIO_NET_F_GUEST_USO4,
+	VIRTIO_NET_F_GUEST_USO6
 };
 
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
-				(1ULL << VIRTIO_NET_F_GUEST_UFO))
+				(1ULL << VIRTIO_NET_F_GUEST_UFO)  | \
+				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
+				(1ULL << VIRTIO_NET_F_GUEST_USO6))
 
 struct virtnet_stat_desc {
 	char desc[ETH_GSTRING_LEN];
@@ -3085,7 +3089,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6))) {
 		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
 		return -EOPNOTSUPP;
 	}
@@ -3690,7 +3696,9 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
 	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
-		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
+		(virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) &&
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6));
 }
 
 static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
@@ -3759,6 +3767,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev->hw_features |= NETIF_F_TSO6;
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
 			dev->hw_features |= NETIF_F_TSO_ECN;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
+			dev->hw_features |= NETIF_F_GSO_UDP_L4;
 
 		dev->features |= NETIF_F_GSO_ROBUST;
 
@@ -4036,6 +4046,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
 	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
 	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO, \
+	VIRTIO_NET_F_HOST_USO, VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
 	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
 	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
-- 
2.38.1

