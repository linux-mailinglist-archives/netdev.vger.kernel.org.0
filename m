Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26119488C72
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiAIVHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiAIVHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:07:18 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E53BC061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:07:18 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o12so37538395lfk.1
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 13:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uG1TFygcuHO7vcN1VeccDOe78rhsfnpTNXRs/s5AciY=;
        b=IB0QPQ0bTMVO7PZtDHKhx20evVfLgpnfnA6QKEYRn+WQLPF6DWJ2RxtA2/0/eb3atB
         3ZCsAEtXrRNOU9p4RBDkWzzPlwhabrXhSU9/ofxE/zKFTl1q0pw3rvY5eDx3gsvkRlnS
         mrPcDaRcxKCigvj0Cz8nKdMmW0SlFiMSvn4euaGhaW1Y0r4zogX9OLDMZGasx1DG+wuw
         sGFtWFrdqndEP+ONlh0ouUUVHXtynScLstgUiZqvqgMgVy5D+oA23pOS8hlm/FoCpvgd
         WJl3oA4yTmQWld1uQhZc9Pck/ww1xQiCKKoXBY+Gn+248cyLM7D97JwEuaznaY4MuAKj
         tLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uG1TFygcuHO7vcN1VeccDOe78rhsfnpTNXRs/s5AciY=;
        b=OdhI6aHNdeZPlcRpvhX8VVBS0vD3jyr7gON0LuxkWLl43GIxQKRcy631yV0eqLhO6z
         U2ooAMN07VGSHsfh2V96+cDGRZKrSEhRmFrCkmO1ke/vDEX8uOFUsqj4uMU0z4oVSWyU
         z7SuKOn5SzGan7D42mXhZRJq2TOYIlFcF87fiH/lL3IMNsxowLBbVvc3kgJDfShLDQd7
         CB98bXM3JOGmgSfbba9A1YeWGtkz+t1JVz/WVSZ2/5yA3NPp8U6TW+Ez79HMow06fxMR
         qmTht/wrO7K4EvQgB94KBBJg8fgKcYRYJqjVKyf8AWV2YyqFF0M/To/KIaqUjYMcpjZb
         IC4Q==
X-Gm-Message-State: AOAM531hn7fozT3z5hGvQXAwXxa+68IPGO2xSLT9Hzx2vOsrsqg/EkVk
        Q1v5IfyNwQIOqt941Klm/GW37wd9aZ73IM+x
X-Google-Smtp-Source: ABdhPJxeRI+9T37ZGNuxNPDVJXBNo2d8k6wTSUFr4KBufW5inOMyrUHtS3fD/r5SHOBxdL/rymmUkQ==
X-Received: by 2002:a2e:8802:: with SMTP id x2mr57534346ljh.382.1641762436228;
        Sun, 09 Jan 2022 13:07:16 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p17sm766129lfu.233.2022.01.09.13.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 13:07:15 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH 1/4] drivers/net/virtio_net: Fixed padded vheader to use v1 with hash.
Date:   Sun,  9 Jan 2022 23:06:56 +0200
Message-Id: <20220109210659.2866740-2-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220109210659.2866740-1-andrew@daynix.com>
References: <20220109210659.2866740-1-andrew@daynix.com>
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
 drivers/net/virtio_net.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b107835242ad..66439ca488f4 100644
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
@@ -395,7 +395,9 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	hdr_p = p;
 
 	hdr_len = vi->hdr_len;
-	if (vi->mergeable_rx_bufs)
+	if (vi->has_rss_hash_report)
+		hdr_padded_len = sizeof(struct virtio_net_hdr_v1_hash);
+	else if (vi->mergeable_rx_bufs)
 		hdr_padded_len = sizeof(*hdr);
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
@@ -1266,7 +1268,8 @@ static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
 					  struct ewma_pkt_len *avg_pkt_len,
 					  unsigned int room)
 {
-	const size_t hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	struct virtnet_info *vi = rq->vq->vdev->priv;
+	const size_t hdr_len = vi->hdr_len;
 	unsigned int len;
 
 	if (room)
@@ -2849,7 +2852,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
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

