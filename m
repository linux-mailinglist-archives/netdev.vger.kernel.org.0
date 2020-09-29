Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79B227BA95
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgI2CA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbgI2CA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:00:29 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB91C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:00:28 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so2976105pfa.10
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KZ5xri8CQiZYZj5fH/BoFFdOUERtgpkqpdPrf8thG10=;
        b=falqCPFRNf4yuXs1tPP0AWaCUb9J9ze+NW/b219ZjILt2GTS3g3X0Jv0vSqGL1URZz
         Avazh/aSyNL0TEww1UyaGRV2bKrxl/tCnWZZ+CoZgXU+UwX0juTHPqgyUfSlkaGZrHTc
         AenTdX/6qPw6U2hJN0+5/9qH8wExSDe2Ln47DS1SVeHhgmDjvgatN2/rizaGrkiJR3MS
         QedeszadGVIroIVVa4osksE8agcll8/mGdbrW/wWNC5MSL9Xjd0H/53lL0oX5GMlLSg7
         aErt073q2Oz8YTIVQFz4hFIwXYqxf9IRICfn3ehyIuTq8qhom0uyl7bh8vpwZMjpUR/E
         J3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KZ5xri8CQiZYZj5fH/BoFFdOUERtgpkqpdPrf8thG10=;
        b=Buj8QVPFIhF39tn0lPhVBdm/aSYxlKOqXiIJ8uG/j3+V2f4H5CJxkzUKKyeIgbUlzF
         0fvuqLQqUtAtZg6I4ui/e23dDlHqpMa9P1/gd5R1LUX88pSLbb5E1vwbiL3uygWoHfYw
         oWFm8ghyBfm2RareSNP9Lx+WnqNJLEihQRYRDrZTpiwvTNPE6UwnRY1bUi1EyGZ3n7Hq
         WNu41XirMNg+SWXZ3xqfbo0SBPbR9qIctXF81ok3D4NXvIzRAdrUEH5w+1Bx2A7nEgxs
         8/GAXY3ndMPAWZ5G5fjR5YBJqcPD0MhkcOdXgY8e+qnLT+4Bo5EjMvjBwEuxt7+UDZ2t
         7u0g==
X-Gm-Message-State: AOAM530t+iT72w2XIy1AhP/i9h3PBa2t8PZATPEF1QXLX4oVXNuXSWjS
        Dpd82dgHFW4aRlceG9FNrlk=
X-Google-Smtp-Source: ABdhPJwS7R20w5F0VpaYUmjll5GcEfWdzUhSgZ4eWTqyCvOG1XTY5MXYyKKK6VNYsyF84hW4pidqkg==
X-Received: by 2002:a63:801:: with SMTP id 1mr1497724pgi.48.1601344828521;
        Mon, 28 Sep 2020 19:00:28 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id e21sm2567486pgi.91.2020.09.28.19.00.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 19:00:27 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     jasowang@redhat.com, mst@redhat.com, willemb@google.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net v2] virtio-net: don't disable guest csum when disable LRO
Date:   Tue, 29 Sep 2020 09:58:06 +0800
Message-Id: <20200929015806.19171-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Open vSwitch and Linux bridge will disable LRO of the interface
when this interface added to them. Now when disable the LRO, the
virtio-net csum is disable too. That drops the forwarding performance.

Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2:
* change the fix-tag
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

