Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599C04E9E9B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbiC1SEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245180AbiC1SD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:03:27 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5851E4839F
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:46 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s13so3254303ljd.5
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ebBwZz+tPMFcNWlsXOiLh/rBq0m4vokTaCikxzbWZ+I=;
        b=X5IbPxKrawXidzt0MnlIlNI+6UIZPt+h4/uLtZpoPcDRK3/mblcLBLtig7VDNFv0qW
         d1AWci999VtlSKMSQLLwwJPMAvmK9T4JEgkOv6Rs3uZCQwL6RHdHArZvM8LuJveaYnX8
         XUeNnDbCi81y3FNC5HeeoJtIayhklwbXAUwtWbB/IA18+l/LQmDYqmh1REMnVeridmMw
         ZEM/vVUNoRlYR/XGP0JaB9AcwpoYqILQLe2TW6qAHlG8fplf4fjMlq1l/eMgJyz7KjYO
         0lFhtW32UBhAZFXejxggIipsUsubUwWhBEOwL8UJ/mYR9nC0o0YqdZqUcR/NlirC9pAq
         uNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ebBwZz+tPMFcNWlsXOiLh/rBq0m4vokTaCikxzbWZ+I=;
        b=RPHTvxre/P1wM2OONU4q6f1+FlZjSZ+G2/mNoX+z7AVaBvtL/fabIfHKjZ7ohKvrZ4
         DrLFUKwge/cNczYGmSTklNx26RUNhRF4bBR55FcyLz82k2cXXAAAnJGomCklIZOTYlr4
         dYPG3rYU+YfSSEDA4iuyrrzWCmt1hFy4Gtn5tLkLm6HUw7KpwMeyrvqBj3Uy5TKf8Jik
         /dmXyw0t7uz2uHBqjxNySXG9XE+c9VAkBxwY5p97MzLIqflPtcwH+K77gr3DQ5sMLt9v
         2nSCcIWXqHgl6+VDNLvRga4+eae1BqqO9THMHFvIG010KI7Sp6Gqm9M1JQC4hVfvsog/
         5gmA==
X-Gm-Message-State: AOAM532oYufhvg1u70XDtF3kQShQjRZ1iIowmFAqGitv1ETLXjrgFctM
        d3AFNH/fycY86bdCrquOo2imkFr7/cvBzEfD
X-Google-Smtp-Source: ABdhPJyANN2qk7qYtHOYQkQvlPtHqN9Y/L2X1B7fu4pz3Gp3gU0xyGflALuEDFEqbKW6LbQNUvTwUA==
X-Received: by 2002:a2e:9045:0:b0:249:78ba:fbf8 with SMTP id n5-20020a2e9045000000b0024978bafbf8mr21358898ljg.218.1648490504041;
        Mon, 28 Mar 2022 11:01:44 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id a4-20020a2eb164000000b0024988e1cfb6sm1801559ljm.94.2022.03.28.11.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:01:43 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, jasowang@redhat.com,
        mst@redhat.com, yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 3/4] drivers/net/virtio_net: Added RSS hash report.
Date:   Mon, 28 Mar 2022 20:53:35 +0300
Message-Id: <20220328175336.10802-4-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328175336.10802-1-andrew@daynix.com>
References: <20220328175336.10802-1-andrew@daynix.com>
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

Added features for RSS hash report.
If hash is provided - it sets to skb.
Added checks if rss and/or hash are enabled together.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 drivers/net/virtio_net.c | 55 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b5f2bb426a7b..c9472c30e8a2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -227,6 +227,7 @@ struct virtnet_info {
 
 	/* Host supports rss and/or hash report */
 	bool has_rss;
+	bool has_rss_hash_report;
 	u8 rss_key_size;
 	u16 rss_indir_table_size;
 	u32 rss_hash_types_supported;
@@ -1148,6 +1149,35 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	return NULL;
 }
 
+static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
+				struct sk_buff *skb)
+{
+	enum pkt_hash_types rss_hash_type;
+
+	if (!hdr_hash || !skb)
+		return;
+
+	switch ((int)hdr_hash->hash_report) {
+	case VIRTIO_NET_HASH_REPORT_TCPv4:
+	case VIRTIO_NET_HASH_REPORT_UDPv4:
+	case VIRTIO_NET_HASH_REPORT_TCPv6:
+	case VIRTIO_NET_HASH_REPORT_UDPv6:
+	case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
+	case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
+		rss_hash_type = PKT_HASH_TYPE_L4;
+		break;
+	case VIRTIO_NET_HASH_REPORT_IPv4:
+	case VIRTIO_NET_HASH_REPORT_IPv6:
+	case VIRTIO_NET_HASH_REPORT_IPv6_EX:
+		rss_hash_type = PKT_HASH_TYPE_L3;
+		break;
+	case VIRTIO_NET_HASH_REPORT_NONE:
+	default:
+		rss_hash_type = PKT_HASH_TYPE_NONE;
+	}
+	skb_set_hash(skb, (unsigned int)hdr_hash->hash_value, rss_hash_type);
+}
+
 static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 			void *buf, unsigned int len, void **ctx,
 			unsigned int *xdp_xmit,
@@ -1182,6 +1212,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 
 	hdr = skb_vnet_hdr(skb);
+	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
+		virtio_skb_set_hash((const struct virtio_net_hdr_v1_hash *)hdr, skb);
 
 	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2232,7 +2264,8 @@ static bool virtnet_commit_rss_command(struct virtnet_info *vi)
 	sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
-				  VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
+				  vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
+				  : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
 		dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
 		return false;
 	}
@@ -3231,6 +3264,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
 			     "VIRTIO_NET_F_CTRL_VQ"))) {
 		return false;
 	}
@@ -3366,8 +3401,13 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -3383,8 +3423,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 
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
@@ -3451,7 +3494,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
-	if (vi->has_rss)
+	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
 	err = register_netdev(dev);
@@ -3586,7 +3629,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
-- 
2.35.1

