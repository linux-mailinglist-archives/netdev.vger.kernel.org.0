Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C1E4BF7B2
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiBVMCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiBVMCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:02:18 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CAD3A5CE
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:01:34 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j7so24288233lfu.6
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n3UASRZlY1ToiL7j+vac0NlVXBZTlgkBMPexZZH8C6k=;
        b=jfaaQzt2S7n0OU7ynyl2Zhip7Vyr+DHnL9LJyepA4ZNXRE9resVnk0PfuPpiHwVgmv
         vc2LMRDDw7PXrFF+RwoHuL+N5XGRecNv6Xdg2nxH+WmG8dHpIOlsC7h/xjSmDqT0QYoN
         7UedikiWkX28zzjYFTqfQz0kVkC/9ZWleFJq/VRgEkI0cuWLLa5npcR5eH3D+jBW7dn8
         Dd2FqZpaSxA+qcvhd9TwDpaa64BxgJPmQ5Bpyl2JJKYpz7azy4CKTbT/wyDTFC98cQLt
         8XwUZI/LOEiVm3Kq98P+TPakizi5Yu9yMEPTFVB4ObozltO0EN2e7if4eM8qYhMomM8D
         BS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3UASRZlY1ToiL7j+vac0NlVXBZTlgkBMPexZZH8C6k=;
        b=KtxpCo2VsU2yTiZYo0b2v1DDMLz4XppS/OF1Wf4MbPljxgsPmBPyLdEcHj/Ih617HV
         ursXzr9XGJQ49qr/dKb1PpSYo4GmrmydazPylzR3FRlBQrLIHpvNIUqtYaSvJBxEnoYX
         fDt1qSOJI4Klj8J5CeSFlDsaFwqDAdqBrrZcKS7kQPdblX/PV3wyxOZKS8BYgp15o3uC
         rR2ZiVnhSYQ3mJrNfrUBcFAU50DvaeLKwVaZe7dweNK669wCkSGaNO5b3OmnlZkUTgOV
         Z+HX+FxfrQSEqExsIcBkKpODkrGRxEgW6hnVFRsIjmR+cUpY8kV5HjPz2gnsPvvn7ajG
         aAzQ==
X-Gm-Message-State: AOAM533BebxKfViugu2dFiaidzo1jbLeFqx0CsrDPDyb7zVEmRN3CpyS
        /vNW4/encXL1l7LkUFUOfdKaNOYTAWFLDw==
X-Google-Smtp-Source: ABdhPJxfECW7k15BXfCXRoSbeWdHBJQv9NiMF3cf/3Wxvkuewc/sFAJroFOpkeE7UPLyzzlXEZPF9Q==
X-Received: by 2002:a05:6512:3698:b0:443:a348:d252 with SMTP id d24-20020a056512369800b00443a348d252mr16851784lfs.193.1645531292541;
        Tue, 22 Feb 2022 04:01:32 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id v29sm1664024ljv.72.2022.02.22.04.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 04:01:32 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v4 1/4] drivers/net/virtio_net: Fixed padded vheader to use v1 with hash.
Date:   Tue, 22 Feb 2022 14:00:51 +0200
Message-Id: <20220222120054.400208-2-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220222120054.400208-1-andrew@daynix.com>
References: <20220222120054.400208-1-andrew@daynix.com>
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

The header v1 provides additional info about RSS.
Added changes to computing proper header length.
In the next patches, the header may contain RSS hash info
for the hash population.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a801ea40908f..b9ed7c55d9a0 100644
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
@@ -396,7 +396,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 	hdr_len = vi->hdr_len;
 	if (vi->mergeable_rx_bufs)
-		hdr_padded_len = sizeof(*hdr);
+		hdr_padded_len = hdr_len;
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
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

