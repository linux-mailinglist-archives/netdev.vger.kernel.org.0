Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9953D490358
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 09:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiAQIAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 03:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiAQIAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 03:00:34 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAFEC06173F
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 00:00:34 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id m1so54458342lfq.4
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 00:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aE+gOvLd3VLDh4TGDkR9cJ5k95oZ+26Kjnw0rS0ttNo=;
        b=DfxL1QWHgUjqNAn2Tt/PAep9IT/Qnv557uZrmdj0BN53Xo5Io9ZI7yokDnufroR+Gt
         6FtLF5vHW56MO7SdFiNf0PaJUpsODk/DhzUYWL0Tyk468Ia42X9GQIBnrnft5iYDX7aH
         kvQvZSU4hBYcJ/1X2JIUK9/1Om8cDfM3cznV/wGAQc5Hx/EG4T0/fon8y0FqN3LOBydD
         P/yRPNP3bBGreriRG/a5SPq3HViPHa2YZOzM1iDlgGVnXYwNyfhU8SPnPxOv3VBe8cT0
         NDDJ7868yppWnb4L3rKfxpb+GJOKMVM8stVJQEK05PAEExxbzf7m7uIlBnwvxfO+Pqbt
         F8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aE+gOvLd3VLDh4TGDkR9cJ5k95oZ+26Kjnw0rS0ttNo=;
        b=rxZd7vOGktTyUYJgkugtj6ZmQobn9E9nuPjnjRElWoFs1eUe18w3sQ9DNNh0jKwxQE
         YfvoxoYpvW/KuDujFf1vJYmkoS2dMJ3RD8RmLVrjW6uqaSSugeyf97/OXe+feROs5x4Z
         565uDJzExhQ9SNO5ON0aEAyYA0glTRmqYocc1UHxaVw0iQx5Ccz7cop63Uv4B2WfnkGi
         Ok3ICmpthCPB36EBuuRScOTeUowOhohh6DWTMppymwdHdEe92PKSxrngergLsaFmMPAo
         R2KIw0uTErR6DMQvcDRbPWi8MC7q90fiKsy0CUD2z6rcPdZwHqzCXY0YBwO/VeNdQEZu
         4L1g==
X-Gm-Message-State: AOAM533qWOD01iDlqyhe88z3wR9XgleXBGJvyFnSWhej862pvCxyxJQH
        taCPMlzx8pc11iqnbYbsGr/qrvKL+8J6WsXEq+I=
X-Google-Smtp-Source: ABdhPJxOzAx74592F+FW3dwVZjqGCvoIwq/B+TmrOWzKFWTocF/luxu/JYeT4FVVLUDrrilZMYcc7A==
X-Received: by 2002:a05:6512:3184:: with SMTP id i4mr15831976lfe.673.1642406432060;
        Mon, 17 Jan 2022 00:00:32 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id x18sm1279423ljd.105.2022.01.17.00.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:00:31 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v2 1/4] drivers/net/virtio_net: Fixed padded vheader to use v1 with hash.
Date:   Mon, 17 Jan 2022 10:00:06 +0200
Message-Id: <20220117080009.3055012-2-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117080009.3055012-1-andrew@daynix.com>
References: <20220117080009.3055012-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header v1 provides additional info about RSS.
Added changes to computing proper header length.
In the next patches, the header may contain RSS hash info
for the hash population.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 569eecfbc2cd..05fe5ba32187 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -242,13 +242,13 @@ struct virtnet_info {
 };
 
 struct padded_vnet_hdr {
-	struct virtio_net_hdr_mrg_rxbuf hdr;
+	struct virtio_net_hdr_v1_hash hdr;
 	/*
 	 * hdr is in a separate sg buffer, and data sg buffer shares same page
 	 * with this header sg. This padding makes next sg 16 byte aligned
 	 * after the header.
 	 */
-	char padding[4];
+	char padding[12];
 };
 
 static bool is_xdp_frame(void *ptr)
@@ -1266,7 +1266,8 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
 					  struct ewma_pkt_len *avg_pkt_len,
 					  unsigned int room)
 {
-	const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	struct virtnet_info *vi = rq->vq->vdev->priv;
+	const size_t hdr_len = vi->hdr_len;
 	unsigned int len;
 
 	if (room)
@@ -2851,7 +2852,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
  */
 static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqueue *vq)
 {
-	const unsigned int hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	const unsigned int hdr_len = vi->hdr_len;
 	unsigned int rq_size = virtqueue_get_vring_size(vq);
 	unsigned int packet_len = vi->big_packets ? IP_MAX_MTU : vi->dev->max_mtu;
 	unsigned int buf_len = hdr_len + ETH_HLEN + VLAN_HLEN + packet_len;
-- 
2.34.1

