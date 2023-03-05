Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660326AB144
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 16:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCEPt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 10:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCEPt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 10:49:56 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAE4F95A
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 07:49:53 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id d41-20020a05600c4c2900b003e9e066550fso3837873wmp.4
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 07:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LRSi5Bvl9ju1evxZ3BXsn8YIc0x56b4op0gZguf5otI=;
        b=WzIHvLW3VsTPXF/J1xy7AlHLM7xTSfKkGngJmaS/prSZXFoWcyisDbT8PYDi5iL3Ch
         VARShU/DyT1QWlxwzVH4RE+E8iSs2bnCXEFmFl/nu059RzW+YVQKCAUhcWbmxg0X3BJc
         t/SLzCFh6l3Ftyv+8nBz7jXTYAIgHxlluj6OPCq8EIHSuDX/3KJbMoJo1AkNol0l+52R
         CDxpZKpR62ScRTaeZFAeMaP9x6grZBtmlgyi+1/74kREA8lHl/UPyglzhFdYgTJLPBMX
         j2lYRJLh/i/X+Mw2yqdwMiaL5MLgOsrV5N//vc+D9fAlmmPbUnfL71QgsdGbufw7JlGk
         HATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LRSi5Bvl9ju1evxZ3BXsn8YIc0x56b4op0gZguf5otI=;
        b=glBO8eroPNLgZxkWBLL+UcS7FfkMoQd7ULL3booDYhzy6kQOW6sixZidWbDk2Ombly
         TJOjESA5CFZN4qXON9Xjlgb0bn88X5n1Oz/vT0DNLOesMNnaS29+jiit5raveRbPS0BJ
         In2geaNHLnH7L2AfiSshBVNiVnwrbqzrUiSQFjivxh6b/CmKx7HOxC14yKz+GhSSTWUx
         DVb6kxAbOF06YAIMF47u3AOCCZGmS2eolSASyTu28NQXYUYX5IHKjfFuANFTrvpcSx3k
         JtEerbZFzVMByG1ixFxJ6ldoJZC879l92DCY9yF0PvD+4pb3q7ZDsgFXWmiwsAgJq1x8
         GYlw==
X-Gm-Message-State: AO0yUKXSH+ooakZLOcHUcZvyo0yznb5g52tSNqpGSjg9dZsqZmRdYMsY
        dvj7CAmykbZWOdikTIlPFet2CRrZOfPcwDC1gN8=
X-Google-Smtp-Source: AK7set9r/iHAEz/eGxdl8GVFDBZKTINAY8Bc9v/muO8YAkId5A84EpF780HbjLIZYesr4PVqsKC6Gg==
X-Received: by 2002:a05:600c:a4c:b0:3dc:d5c:76d9 with SMTP id c12-20020a05600c0a4c00b003dc0d5c76d9mr7389089wmq.0.1678031390593;
        Sun, 05 Mar 2023 07:49:50 -0800 (PST)
Received: from alvaro-dell.. (bzq-84-110-153-254.static-ip.bezeqint.net. [84.110.153.254])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c12cc00b003de2fc8214esm7761724wmd.20.2023.03.05.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 07:49:49 -0800 (PST)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] virtio-net: unify notifications coalescing structs
Date:   Sun,  5 Mar 2023 17:49:42 +0200
Message-Id: <20230305154942.1770925-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unify virtio_net_ctrl_coal_tx and virtio_net_ctrl_coal_rx structs into a
single struct, virtio_net_ctrl_coal, as they are identical.

This patch follows the VirtIO spec patch:
https://lists.oasis-open.org/archives/virtio-comment/202302/msg00431.html

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 drivers/net/virtio_net.c        | 15 +++++++--------
 include/uapi/linux/virtio_net.h | 24 +++++++-----------------
 2 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fb5e68ed3ec..86b6b3e0257 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2883,12 +2883,11 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 				       struct ethtool_coalesce *ec)
 {
 	struct scatterlist sgs_tx, sgs_rx;
-	struct virtio_net_ctrl_coal_tx coal_tx;
-	struct virtio_net_ctrl_coal_rx coal_rx;
+	struct virtio_net_ctrl_coal coal_params;
 
-	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
-	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
-	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
+	coal_params.max_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
+	coal_params.max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
+	sg_init_one(&sgs_tx, &coal_params, sizeof(coal_params));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
 				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
@@ -2899,9 +2898,9 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 	vi->tx_usecs = ec->tx_coalesce_usecs;
 	vi->tx_max_packets = ec->tx_max_coalesced_frames;
 
-	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
-	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
-	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
+	coal_params.max_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
+	coal_params.max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
+	sg_init_one(&sgs_rx, &coal_params, sizeof(coal_params));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
 				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index b4062bed186..ce044260e02 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -367,28 +367,18 @@ struct virtio_net_hash_config {
  * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
  */
 #define VIRTIO_NET_CTRL_NOTF_COAL		6
-/*
- * Set the tx-usecs/tx-max-packets parameters.
- */
-struct virtio_net_ctrl_coal_tx {
-	/* Maximum number of packets to send before a TX notification */
-	__le32 tx_max_packets;
-	/* Maximum number of usecs to delay a TX notification */
-	__le32 tx_usecs;
-};
-
-#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
 
 /*
- * Set the rx-usecs/rx-max-packets parameters.
+ * Set the max_usecs/max_packets coalescing parameters for all transmit/receive virtqueues.
  */
-struct virtio_net_ctrl_coal_rx {
-	/* Maximum number of packets to receive before a RX notification */
-	__le32 rx_max_packets;
-	/* Maximum number of usecs to delay a RX notification */
-	__le32 rx_usecs;
+struct virtio_net_ctrl_coal {
+	/* Maximum number of packets to send/receive before a TX/RX notification */
+	__le32 max_packets;
+	/* Maximum number of microseconds to delay a TX/RX notification */
+	__le32 max_usecs;
 };
 
+#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
 #define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET		1
 
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
-- 
2.34.1

