Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406A6524BBB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353313AbiELLdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 07:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353267AbiELLd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 07:33:26 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4811C15E4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:25 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id m23so6150436ljc.0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 04:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AuhXnTyXYfvNbLOGsXvQgDXjLOOfx+AfDHJa0gr2Q8A=;
        b=e/NKJfA0K3TVh2Uqqes8Fg6Z0r2h5rdevnONjrKcIbdfkj32ctf6vWieQiM2iNM0ve
         jlsoNaxpzQNSTeGfXF1xckXcKIlmKBHG7B/SulZth7jNS0kFG/Pxh9wGjH53ks8fpkAi
         ePuZRaOVxGFoNjIiGrhuvLNoNL9w6aND2iTpY1lO3SK76sZZmfjJVuqs1RX2HCVN9VCw
         4ZXSmCNyRtn5/xqrzSvgv8I1wET3wo/vDSgB2F+PRw0jG7/TV9n/zqkaPin4vQ9aL8LK
         efFxugQHftyB5jB7VyCChE1nUuORIYIeLOQS6v+XH1C8bBjTz+PRvO7yrXgp7hG6ERxJ
         hgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AuhXnTyXYfvNbLOGsXvQgDXjLOOfx+AfDHJa0gr2Q8A=;
        b=lYy7iKNqPgzavD7Ig5MIyryecZo3bgZv/Lm8iLioFRYvyp1xS3nMEgQMKZ1mSlIUUS
         Chyxnswn65oelJx8rU9nrxPAdhjTJ9Ec5bVI6NDrjT57DcmTzhxvuH5Qa60/1EJzk3mQ
         MNRCmQSCmTlA1m9nx1dDiMffgrv7nb0u0Bazp+VRwHRwq5amEZ89EjlRYGosmtKoL++l
         kkHoCdtecQXHhRx6fg9zths3KuAYSFErqK94xkjMkahnavHpb+s9nGCFOJXkzpFvHzb9
         UEbNBy/7bOcDY0cqcI9g43pQXVccOyCy7XIl1v7WSiM4B9spN85ret4CrlEzQTEDgMs/
         De9Q==
X-Gm-Message-State: AOAM531vvzsjYdx9XDrRMu40fMa7awU06DEwOtUdDC4XJ/nfgDUkjoWO
        ULrz1Wyu9kT/Cr+4wLYxfAj3Zw==
X-Google-Smtp-Source: ABdhPJwOHf2aNvhc0cKjwxuR/gjiWUyFUU8LZPUO4MjSQClRg+GqK0Z8piXa6I+W2Y/Uroj3iNEMGw==
X-Received: by 2002:a2e:9dca:0:b0:24f:2924:9295 with SMTP id x10-20020a2e9dca000000b0024f29249295mr20745904ljj.480.1652355204073;
        Thu, 12 May 2022 04:33:24 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id r29-20020ac25a5d000000b0047255d211a6sm741758lfn.213.2022.05.12.04.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 04:33:23 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH v2 5/5] drivers/net/virtio_net.c: Added USO support.
Date:   Thu, 12 May 2022 14:23:47 +0300
Message-Id: <20220512112347.18717-6-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220512112347.18717-1-andrew@daynix.com>
References: <20220512112347.18717-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index cbba9d2e8f32..17fb8be7e4f7 100644
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
@@ -2867,7 +2871,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
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
@@ -3507,6 +3513,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev->hw_features |= NETIF_F_TSO6;
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
 			dev->hw_features |= NETIF_F_TSO_ECN;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
+			dev->hw_features |= NETIF_F_GSO_UDP_L4;
 
 		dev->features |= NETIF_F_GSO_ROBUST;
 
@@ -3552,7 +3560,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO) ||
+	    (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_USO4) &&
+	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_USO6)))
 		vi->big_packets = true;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
@@ -3780,6 +3790,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
 	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
 	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO, \
+	VIRTIO_NET_F_HOST_USO, VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
 	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
 	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
-- 
2.35.1

