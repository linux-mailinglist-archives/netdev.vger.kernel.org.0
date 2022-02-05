Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B604AA6AB
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379490AbiBEEzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBEEzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:55:07 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8F8C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:55:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso7997613pjt.3
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 20:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P2HOz1+MCi8770EQ0Ai1OiuUYB+0FqYYKNHmz4yauAM=;
        b=OLyPVOsPZfabDglpKB2ZxH9vZYk5drcozOzl5hjWLtGUYfB/3ETu7e7bXOxnWg2Ut3
         Kwzm2Ii/KZMK269XjP+iO1dbsKZimpmjOiJaBXI77xW4f/rQkp851Gbct1/JsGpAhxeb
         Y6JP1Vac/8KDForSx4aBoyAeWPGcWLF4TIRQHrvLc85hzhXPfYHdWoBBNjE9aogNDYjS
         gTgV83bZuGSAV1yrNxwMR11n/LeHXpNV0M+AyHbzBEY9K7eD/q0bM4SqeH7v188lYFP9
         bTXmQrxbgFepVmfN5OwhRKanwd3jWF5iwoSZjT00R8vAKrEXk1SRFGXP7BYlzW3lkORg
         uj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P2HOz1+MCi8770EQ0Ai1OiuUYB+0FqYYKNHmz4yauAM=;
        b=mL0KrGngCdjmWWaH9Rsxj0OZiG3P9/oaqpTtrqNtA3ZMuk7xoyHn7xe87OWIm1Od0k
         ygczc5xinVHfHvih3f86ngGI5QSAWGR3ZMs3MKpVhVQMfLYzifMFwZiVt7mjWmYauXAW
         QXiEci2+3zYxNQzG4w23NbEuWCzMYEdddGut3IAkP8Oos9NLt3ZUhDq7l3BVxOnJenG4
         xelVhTmM7MyFfzNUByX9+jdIlqy+mgkMemHTQAVCWjpYGUk7+wDUcJFxzTtFRQF+qoKp
         jeZO69EIVBnPgNbDEg6mwh8WYFvzo1gW0q0MTA6R1m+Sg/hexYjh4gpvh3z2vwlJXzHe
         PMyg==
X-Gm-Message-State: AOAM533wKx1SCg/jN2zuu05Bw17l6NnKmALhSxE+c9LF9Bok0V7wsVed
        /BYcPNxdEXaCknV1mMBFfc4=
X-Google-Smtp-Source: ABdhPJwnD+mVOLmOAi3s/tUF7ezZurOLXIoxUhKTywRbhudQRHwxfA+XY1Z+Bf/+r18ohjWwFX5lHg==
X-Received: by 2002:a17:90a:400e:: with SMTP id u14mr2546353pjc.147.1644036906213;
        Fri, 04 Feb 2022 20:55:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id a38sm4102747pfx.162.2022.02.04.20.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 20:55:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] net: typhoon: implement ndo_features_check method
Date:   Fri,  4 Feb 2022 20:54:59 -0800
Message-Id: <20220205045459.3457024-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Instead of disabling TSO at compile time if MAX_SKB_FRAGS > 32,
implement ndo_features_check() method for this driver for
a more dynamic handling.

If skb has more than 32 frags and is a GSO packet, force
software segmentation.

Most locally generated packets will use a small number
of fragments anyway.

For forwarding workloads, we can limit gro_max_size at ingress,
we might also implement gro_max_segs if needed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/3com/typhoon.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 8aec5d9fbfef2803c181387537300502a937caf0..08f6c42a1e3803006159915cfdae1e72c5e30335 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -138,11 +138,6 @@ MODULE_PARM_DESC(use_mmio, "Use MMIO (1) or PIO(0) to access the NIC. "
 module_param(rx_copybreak, int, 0);
 module_param(use_mmio, int, 0);
 
-#if defined(NETIF_F_TSO) && MAX_SKB_FRAGS > 32
-#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
-#undef NETIF_F_TSO
-#endif
-
 #if TXLO_ENTRIES <= (2 * MAX_SKB_FRAGS)
 #error TX ring too small!
 #endif
@@ -2261,9 +2256,25 @@ typhoon_test_mmio(struct pci_dev *pdev)
 	return mode;
 }
 
+#if MAX_SKB_FRAGS > 32
+static netdev_features_t typhoon_features_check(struct sk_buff *skb,
+						struct net_device *dev,
+						netdev_features_t features)
+{
+	if (skb_shinfo(skb)->nr_frags > 32 && skb_is_gso(skb))
+		features &= ~NETIF_F_GSO_MASK;
+
+	features = vlan_features_check(skb, features);
+	return vxlan_features_check(skb, features);
+}
+#endif
+
 static const struct net_device_ops typhoon_netdev_ops = {
 	.ndo_open		= typhoon_open,
 	.ndo_stop		= typhoon_close,
+#if MAX_SKB_FRAGS > 32
+	.ndo_features_check	= typhoon_features_check,
+#endif
 	.ndo_start_xmit		= typhoon_start_tx,
 	.ndo_set_rx_mode	= typhoon_set_rx_mode,
 	.ndo_tx_timeout		= typhoon_tx_timeout,
-- 
2.35.0.263.gb82422642f-goog

