Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3569AB37
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjBQMQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjBQMQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:16:31 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF37F6A075
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:15:52 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p5so803303wmg.4
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fdAd75IKeGuiZC/gLVi/q5gzUOXi0Tilg6lxXWoO9Ic=;
        b=GLRo7GjrvRH2s3vxMtLX0NXuTsxH0mOLf2t4mh+bq3UTYnPxFxKa+aclc+N+Bg3Kwr
         YhZ3Q/YibkXLUgFCiJCvVHqL2bEj+abEN0qdl8U5gOAWUqE5iyXBh6lsQKU1DEbwatXG
         KC7YrbwNFJoQZFY7hEZdnGWp2I0etkgmkx2PoLCj0NYqjd8VSY+Wc8gRvz/toEHQtmdh
         +GLu/q2T/nM7PbNfwmlceO9Y7wPiUSgghmxHOiIdgHidKmWDDHQdsTLeRl1/6vUIvTbu
         wwcYTU3RgeLp62a/vPt+KntMJKKQ56Vp6E1QXJNJS2QAICNb95NoTqDxcLZwCWpmq+sK
         o5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fdAd75IKeGuiZC/gLVi/q5gzUOXi0Tilg6lxXWoO9Ic=;
        b=FFqYOTxC3PeGoMum2qxsdGFGvzzHhi9oiKSxghvyMWrjBD2tKehJYxEL2tQiiN6x1C
         ErMyeduTQh8eOeAgYu0mdgRn7Fu72YcmKwIebe6nyESEXhCe/SU/3MWHNyWTesj/Lc0a
         Lwttwp8ZBWxEgtE6Gw2StMUo/NRdsi64Njhe3mqnZf2xYxM95ta3pLOMf964A8kyRJDo
         5qbDJr3MHb1Wa9orcn56cphQEUUUW+catZMrvQ0zOAWATN8+lda4PG9shVYd+eQNVzVH
         Q7BxGO41tKyLwKUrtqEJNV7+Hlw0zV8ROzBPsMh4AiBsD2AyfIMEPVIQ3efTaZUDvGVm
         gHSw==
X-Gm-Message-State: AO0yUKVhyMzjnyxRIrjAWD5z3qHpo/ceSFG3jEP8aHq57Y+qsbl/mgVG
        mcXtUhViX/C3VeK+ZEQCsCxWypQFkjkJBRmx+B/TFg==
X-Google-Smtp-Source: AK7set+NC36+Q5PbXb31/vlW/fxp3sjTPYoccHDngY01oTfli/nug4z1vpF9dVoW6KhN6RJwOVlWRQ==
X-Received: by 2002:a05:600c:2eca:b0:3df:f7e7:5f01 with SMTP id q10-20020a05600c2eca00b003dff7e75f01mr777021wmn.15.1676636150111;
        Fri, 17 Feb 2023 04:15:50 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c024400b003e01493b136sm8425722wmj.43.2023.02.17.04.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 04:15:49 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [patch net-next] net: virtio_net: implement exact header length guest feature
Date:   Fri, 17 Feb 2023 13:15:47 +0100
Message-Id: <20230217121547.3958716-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
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

From: Jiri Pirko <jiri@nvidia.com>

virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).

Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
set implicates that the driver provides the exact size of the header.

The driver already complies to fill the correct value. Introduce the
feature and advertise it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/virtio_net.c        | 6 ++++--
 include/uapi/linux/virtio_net.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fb5e68ed3ec2..e85b03988733 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_UFO,
 	VIRTIO_NET_F_GUEST_CSUM,
 	VIRTIO_NET_F_GUEST_USO4,
-	VIRTIO_NET_F_GUEST_USO6
+	VIRTIO_NET_F_GUEST_USO6,
+	VIRTIO_NET_F_GUEST_HDRLEN
 };
 
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
@@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
+	VIRTIO_NET_F_GUEST_HDRLEN
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index b4062bed186a..12c1c9699935 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -61,6 +61,7 @@
 #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
 #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
+#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
 #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
-- 
2.39.0

