Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8124227A5CF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 05:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgI1Dl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 23:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1Dl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 23:41:58 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F499C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:41:58 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id z193so4997900vsz.10
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m9EtepEtVt3TGlrTSs3377Oy1G+hujBB1naLBHmKEMY=;
        b=DnEINd7vTZp2MLZJHSmRkhflGn+dhLAi3Stpt5pp2JgymWDTlLtnGvsGM7uelINWA3
         Fj9EydJQSa7/r+BF03qQSU2i5Et/CiWDuLPSQNFk+tHaFXx0078GoJ6BZFIV884YDdqi
         Nmtj6gHk9GibPyJeTJ4veZZXTZ4xYO6oKce1ROLNRIuyijJeLBMZ748rzp6jX8pOuJWQ
         2VkKx+Ug0cMPmOR3p96hWUZpdPL1H2coYSf0mNVP4+/izyBNzt13TFyfZLIZN5Psqmws
         ALncHlvaXJp7k7hDWeArk46isDQ6LJ3TOGxSVgzl1Mq/i0FinK+98pEltVYRHB9dev/D
         RxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m9EtepEtVt3TGlrTSs3377Oy1G+hujBB1naLBHmKEMY=;
        b=cRLVVgDuqpT4u+jO8kDSzMJ5MeTa9T7ATJMDvVF91Z5xB7uivj9LvoQspdOU/2A/xv
         XenBSyfKgnldMUW8HX/ZkirJ85mZBC3fjR2jPmDPLd8Op98FT+C4QSswD3Ph4wFVgUvE
         AoSeCyVbNKJFu7OrDTSs98eN60DhCbGKRbRVDYCcmP++O9hLtuZvjGwsXI0axfOrzUCD
         oe5obeUqWV9iOOxBnym1VXQ9IlzAvgG9PPOmqjdSF19b8UZHzlBLCQSfS+qjCvNcIOqy
         ihMi3ndOgXdEmTGGFKMYwIAcByV263/wAkntIBTN3vc8XDvQzGmhsmhHa62kKZM5ibh8
         8ipw==
X-Gm-Message-State: AOAM530sIe/QMGqGhWC0YW1IjvyxrGCB1CQDJNFtbz/Zeu6Ww5TvlDcV
        L/QskLhq1ZfZJJCcvXLZDSs=
X-Google-Smtp-Source: ABdhPJyH04luJ1UTcCe5FefXF8GSyZT+ghdCCiFnxbXOZwhxxncbiFm+7K9a9+Db4daXaBfejL7Esw==
X-Received: by 2002:a67:ea4e:: with SMTP id r14mr3944866vso.37.1601264517494;
        Sun, 27 Sep 2020 20:41:57 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id e3sm1363499vsa.8.2020.09.27.20.41.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 20:41:56 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH 1/2] virtio-net: don't disable guest csum when disable LRO
Date:   Mon, 28 Sep 2020 11:39:14 +0800
Message-Id: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Open vSwitch and Linux bridge will disable LRO of the interface
when this interface added to them. Now when disable the LRO, the
virtio-net csum is disable too. That drops the forwarding performance.

Fixes: e59ff2c49ae1 ("virtio-net: disable guest csum during XDP set")
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/virtio_net.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7145c83c6c8c..21b71148c532 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -63,6 +63,11 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_CSUM
 };
 
+#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
+				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
+				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
+				(1ULL << VIRTIO_NET_F_GUEST_UFO))
+
 struct virtnet_stat_desc {
 	char desc[ETH_GSTRING_LEN];
 	size_t offset;
@@ -2531,7 +2536,8 @@ static int virtnet_set_features(struct net_device *dev,
 		if (features & NETIF_F_LRO)
 			offloads = vi->guest_offloads_capable;
 		else
-			offloads = 0;
+			offloads = vi->guest_offloads_capable &
+				   ~GUEST_OFFLOAD_LRO_MASK;
 
 		err = virtnet_set_guest_offloads(vi, offloads);
 		if (err)
-- 
2.23.0

