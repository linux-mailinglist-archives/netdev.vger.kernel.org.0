Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161BE3B353C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhFXSKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhFXSJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:09:57 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8813BC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:37 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id t6-20020ac80dc60000b029024e988e8277so7084424qti.23
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gTAys659jFcQRh+qKUfqA5gfoSdfjPUJRzzvjwrYuAo=;
        b=NBTFpDNy9AKZ4IHC+NaPLY5SD9XxCiX715u4Nsyr1ZAyylzzH0U7+71I7ZUv174w7H
         2Jri71+F/voV6HsGWGieS4yDfqGxjLWRKCnjibXLcMALaMHowWkRI9kHEzgoAnfi4euE
         ugTrj+Rhwwmhdrv0YQ0qG6tAC1HfeW9hxktfBoYzPpEnkgBIoZWQIjT3DPq8Y4guPa1m
         Rn8kAftHuVjkSX7rszdk0xwSCXs0qYqnQeAO306nR/GZB6HZK8XH8QQEWOSzB7bLQEgF
         ymyz7r0Xh2r2eK+Rud3ZPjX1h8RhtYkPBtkYDVuzsi02aqyeZ/hWq36Y33NBSzLFkxO5
         pXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gTAys659jFcQRh+qKUfqA5gfoSdfjPUJRzzvjwrYuAo=;
        b=MMIacD4x/PkFKGd8houcBkzkuvp3GLS+H7oEsbebYG2d5SGEsWzXrC6u4Nr2vzJx4f
         GmnUKnxx9Akd+OLpzmxc17IOhHGZOYuVFleP4dc1zIZiPRCstAtjmMOoV/9YjbqTsM7x
         et18ZOuWygQX0vxtkj458Xeyy6FU125O6ewviJs0DwCW6uyl1VmXmj2n9ET4Y8d41ElQ
         bkFr0tuwl0yrv7zP/vfm3204MQXfpXtIQB14kS4n4o+kLBGaghTfLKIlRpbB11H6DgL2
         dk/mauh2Q/zVA2E/uL66kewJCSrV/S2MHhcpxIYw4I/ZpgMbGN9e1tzHmj+mZnMReIY2
         n6ug==
X-Gm-Message-State: AOAM532r1CH8hMS3kZLI4qWCRPV6HJF+Irf8mgs1687GiBv4jxIRvL6J
        vE2EGYksDHDGmmAmycKtGg41Nks=
X-Google-Smtp-Source: ABdhPJyFphAOCIaksQBDH63k3Yv3rPocrULg+pIBM4SyCoqPmerMqN5sLE8yU4TeydA/2esiJVEfAV8=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a0c:e94c:: with SMTP id n12mr6778703qvo.61.1624558056708;
 Thu, 24 Jun 2021 11:07:36 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:19 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-4-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 03/16] gve: gve_rx_copy: Move padding to an argument
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future use cases will have a different padding value.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c    | 4 ++--
 drivers/net/ethernet/google/gve/gve_utils.c | 5 +++--
 drivers/net/ethernet/google/gve/gve_utils.h | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 2cfedf4bf5d8..c51578c1e2b2 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -350,7 +350,7 @@ gve_rx_qpl(struct device *dev, struct net_device *netdev,
 			gve_rx_flip_buff(page_info, &data_slot->qpl_offset);
 		}
 	} else {
-		skb = gve_rx_copy(netdev, napi, page_info, len);
+		skb = gve_rx_copy(netdev, napi, page_info, len, GVE_RX_PAD);
 		if (skb) {
 			u64_stats_update_begin(&rx->statss);
 			rx->rx_copied_pkt++;
@@ -392,7 +392,7 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 
 	if (len <= priv->rx_copybreak) {
 		/* Just copy small packets */
-		skb = gve_rx_copy(dev, napi, page_info, len);
+		skb = gve_rx_copy(dev, napi, page_info, len, GVE_RX_PAD);
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_copied_pkt++;
 		rx->rx_copybreak_pkt++;
diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index 2bfff0f75519..eb3d67c8b3ac 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -45,10 +45,11 @@ void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx)
 }
 
 struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
-			    struct gve_rx_slot_page_info *page_info, u16 len)
+			    struct gve_rx_slot_page_info *page_info, u16 len,
+			    u16 pad)
 {
 	struct sk_buff *skb = napi_alloc_skb(napi, len);
-	void *va = page_info->page_address + GVE_RX_PAD +
+	void *va = page_info->page_address + pad +
 		   (page_info->page_offset ? PAGE_SIZE / 2 : 0);
 
 	if (unlikely(!skb))
diff --git a/drivers/net/ethernet/google/gve/gve_utils.h b/drivers/net/ethernet/google/gve/gve_utils.h
index 76540374a083..8fb39b990bbc 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.h
+++ b/drivers/net/ethernet/google/gve/gve_utils.h
@@ -18,7 +18,8 @@ void gve_rx_remove_from_block(struct gve_priv *priv, int queue_idx);
 void gve_rx_add_to_block(struct gve_priv *priv, int queue_idx);
 
 struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
-			    struct gve_rx_slot_page_info *page_info, u16 len);
+			    struct gve_rx_slot_page_info *page_info, u16 len,
+			    u16 pad);
 
 #endif /* _GVE_UTILS_H */
 
-- 
2.32.0.288.g62a8d224e6-goog

