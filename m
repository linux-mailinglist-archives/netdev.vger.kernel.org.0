Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6DD4AE082
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384796AbiBHSQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359792AbiBHSPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:15:49 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADA6C061579
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:15:48 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id a25so57687lji.9
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 10:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeDa8/+i+0/WSOJjpKaKDeiKBL8K+DH4jQ8xLEyH/fA=;
        b=K97B6MHUWpfWgbAU2Rh8UCNhcaxz8QGzNF3GU5IeSq1tYKzT7M7gIgFf/OTnFT5eF2
         FHQJhInSqqCilz8Sm3uJHfTSH8REwcWhp+GTLyowJLqv3C1i9k6hXFKQxmSLfYY7ougF
         fZiC5RUC42rGu4Zpa7Cr0wFIfMimdyspg02ofA3/5wEdoF0oRosKtISY3NZIeIkZy8ex
         YQgy1HvF/gL/+YMZXWHjRx0oQL6r+ZUfRugNmw0zWxi0hP2MPXsD56tK/CX/JLd1Dq+3
         Yz83J+/FnLkt7cTlXHtCW5xhDFywoamNVPCKDhydCRrYWyJqmTYI80TDGriIaSi+yZul
         GRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeDa8/+i+0/WSOJjpKaKDeiKBL8K+DH4jQ8xLEyH/fA=;
        b=mKuDDJM83hwPRguhpnISUjS0CT4kGAYGnynuU09bOvrRKIbWWT9ZH37eQERLSwuTRe
         hukH7Vp0pmLxbhGaK2mi0fV4MpddyEeCl1bnQ48tVc+1vCvyQ9ykgh5L1kwPYtlCSfsj
         IRlfid0wSt4ZfHZD7sMiEZWJ6z0emiHjGGM9y1bSa2uuFts3vjICWET7UKZl2NgNIRqm
         WYbbHdtVeoPCcsEWa0ugGeaxWVVvq42UDrwjq3Jl+OYbG90l85xOZD8rCqRZewH/WlBq
         Q1stS8O803JbsQj5lWNNfKUlra+e29+5N1t7/htLN4BfpkibGTewIZL15Ar0WpPoOgAk
         IWXQ==
X-Gm-Message-State: AOAM530ZnNSUjKlvWqUlv7u1DFi/AFFWpNKPBybSabx+JlT9HEz4DP2S
        CnlfJUqbOw5Trtd9HL536Fj5pBs56xD+JjyE
X-Google-Smtp-Source: ABdhPJykupL7odp9QVTsrBwCWK4bTleiMiC0985vIJCvmAIJxHvKoMeCRDmQM8LqPuK+Rh7y5sj54Q==
X-Received: by 2002:a2e:9bd4:: with SMTP id w20mr3612480ljj.324.1644344146110;
        Tue, 08 Feb 2022 10:15:46 -0800 (PST)
Received: from navi.cosmonova.net.ua ([95.67.24.131])
        by smtp.gmail.com with ESMTPSA id p16sm2125082ljc.86.2022.02.08.10.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 10:15:45 -0800 (PST)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v3 3/4] drivers/net/virtio_net: Added RSS hash report.
Date:   Tue,  8 Feb 2022 20:15:09 +0200
Message-Id: <20220208181510.787069-4-andrew@daynix.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208181510.787069-1-andrew@daynix.com>
References: <20220208181510.787069-1-andrew@daynix.com>
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

Added features for RSS hash report.
If hash is provided - it sets to skb.
Added checks if rss and/or hash are enabled together.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 51 ++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 495aed524e33..543da2fbdd2d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -227,6 +227,7 @@ struct virtnet_info {
 
 	/* Host supports rss and/or hash report */
 	bool has_rss;
+	bool has_rss_hash_report;
 	u8 rss_key_size;
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
@@ -421,7 +422,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 	hdr_len = vi->hdr_len;
 	if (vi->mergeable_rx_bufs)
-		hdr_padded_len = sizeof(*hdr);
+		hdr_padded_len = hdr_len;
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
@@ -1156,6 +1157,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	struct net_device *dev = vi->dev;
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
+	struct virtio_net_hdr_v1_hash *hdr_hash;
+	enum pkt_hash_types rss_hash_type;
 
 	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
@@ -1182,6 +1185,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 
 	hdr = skb_vnet_hdr(skb);
+	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report) {
+		hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
+
+		switch (hdr_hash->hash_report) {
+		case VIRTIO_NET_HASH_REPORT_TCPv4:
+		case VIRTIO_NET_HASH_REPORT_UDPv4:
+		case VIRTIO_NET_HASH_REPORT_TCPv6:
+		case VIRTIO_NET_HASH_REPORT_UDPv6:
+		case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
+		case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
+			rss_hash_type = PKT_HASH_TYPE_L4;
+			break;
+		case VIRTIO_NET_HASH_REPORT_IPv4:
+		case VIRTIO_NET_HASH_REPORT_IPv6:
+		case VIRTIO_NET_HASH_REPORT_IPv6_EX:
+			rss_hash_type = PKT_HASH_TYPE_L3;
+			break;
+		case VIRTIO_NET_HASH_REPORT_NONE:
+		default:
+			rss_hash_type = PKT_HASH_TYPE_NONE;
+		}
+		skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
+	}
 
 	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2232,7 +2258,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
-				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
+				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
+				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
 		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
 		return false;
 	}
@@ -3230,6 +3257,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
 			     "VIRTIO_NET_F_CTRL_VQ"))) {
 		return false;
 	}
@@ -3365,8 +3394,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
+		vi->has_rss_hash_report = true;
+
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
 		vi->has_rss = true;
+
+	if (vi->has_rss || vi->has_rss_hash_report) {
 		vi->rss_indir_table_size =
 			virtio_cread16(vdev, offsetof(struct virtio_net_config,
 				rss_max_indirection_table_length));
@@ -3382,8 +3416,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 		dev->hw_features |= NETIF_F_RXHASH;
 	}
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
-	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
+
+	if (vi->has_rss_hash_report)
+		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
+	else if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
+		 virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
 		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
 	else
 		vi->hdr_len = sizeof(struct virtio_net_hdr);
@@ -3450,7 +3487,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
-	if (vi->has_rss)
+	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
 	err = register_netdev(dev);
@@ -3585,7 +3622,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
-- 
2.34.1

