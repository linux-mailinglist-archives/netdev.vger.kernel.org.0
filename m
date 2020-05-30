Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024091E9377
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 21:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgE3Tlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 15:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3Tlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 15:41:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDECC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:41:35 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c12so4721060qtq.11
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 12:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPaIxWKkpcCxszKpNRD/R3HrsJ3MVk3apXnzwZEK7lA=;
        b=fKGVFo/yCy4D5ArkPopWdLgSq+KLzWhljSl0GLSw7dhcwMAw7Mc2+BYzz/6V2zzddk
         fVrcpY9eKO62dCKZtxbGQUNo8URQ1anxz3a0KndrCcN4ifo1MakzblRlNivWYaeF/QVo
         P9ObNwVYz5q/icVASpLl49XO6TJUnzYQo7tUSuf9NzITaD6ahDQpXn8nxQgIiDg4gdrn
         3NjumLlvGSMjq2s0w31NYTmwfegDsCgJkO1ar4KF+rwlIzB7wl6+0GnU2BVLXj/PwDuZ
         ZJWn89kt4ZVshBoyvITC5D0pW3wRIM0uPGfi74YMhzyvNvdVI06yFHILhsPnxvJX/glK
         mHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPaIxWKkpcCxszKpNRD/R3HrsJ3MVk3apXnzwZEK7lA=;
        b=g9exe1hy0qWDryis5O+C8tgz6O6eLt3dQbCg1kERAZLKBvJ34iTRKipTLgOTmrHBLr
         P8xOwi8yLSatcwc5siJygS+Ds9zOgxPwrcrqERD2Jx4d0hbgEUwqRSFU+aeC20ZZzmX7
         gIsXHS1r+tdLiqctYk1RyWsMWoUpoRM746Bc4y4cSpXeww88y6uby7qjbVD4EzDeLxOk
         tczxlPBeRR6auR3ZR9hcTbCCqfCd9VEYr2J3pZ3605aE79J0thoC4j9gWUwBl0bNSHVr
         kBUOxxxs8a07qByywU4Nb/DU7Egc5dn2U9PLIgKhqZCCbE60wAj7XJR4VIxfqFvVi9TW
         Htjw==
X-Gm-Message-State: AOAM531YhwnQ/Ax8sn/LNpVOF8KOarNoIphAPxWEF2/7ZMiB9XpU1vUk
        +4IAoQT02z0eIS4x4R6kPgpsRA3f
X-Google-Smtp-Source: ABdhPJxXXnGAlg64FHSX1ASo9yCIDfoptsTbavaVxrjh+H0se6hXxRFdNd1w34tkBSDiDr2y6eb0Fw==
X-Received: by 2002:ac8:754f:: with SMTP id b15mr13863498qtr.375.1590867693873;
        Sat, 30 May 2020 12:41:33 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id 205sm10024536qkh.94.2020.05.30.12.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 12:41:33 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Subject: [PATCH net v2] tun: correct header offsets in napi frags mode
Date:   Sat, 30 May 2020 15:41:31 -0400
Message-Id: <20200530194131.80155-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Tun in IFF_NAPI_FRAGS mode calls napi_gro_frags. Unlike netif_rx and
netif_gro_receive, this expects skb->data to point to the mac layer.

But skb_probe_transport_header, __skb_get_hash_symmetric, and
xdp_do_generic in tun_get_user need skb->data to point to the network
header. Flow dissection also needs skb->protocol set, so
eth_type_trans has to be called.

Ensure the link layer header lies in linear as eth_type_trans pulls
ETH_HLEN. Then take the same code paths for frags as for not frags.
Push the link layer header back just before calling napi_gro_frags.

By pulling up to ETH_HLEN from frag0 into linear, this disables the
frag0 optimization in the special case when IFF_NAPI_FRAGS is used
with zero length iov[0] (and thus empty skb->linear).

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Petar Penkov <ppenkov@google.com>
---
 drivers/net/tun.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 44889eba1dbc..b984733c6c31 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1871,8 +1871,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb->dev = tun->dev;
 		break;
 	case IFF_TAP:
-		if (!frags)
-			skb->protocol = eth_type_trans(skb, tun->dev);
+		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
+			err = -ENOMEM;
+			goto drop;
+		}
+		skb->protocol = eth_type_trans(skb, tun->dev);
 		break;
 	}
 
@@ -1929,9 +1932,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	}
 
 	if (frags) {
+		u32 headlen;
+
 		/* Exercise flow dissector code path. */
-		u32 headlen = eth_get_headlen(tun->dev, skb->data,
-					      skb_headlen(skb));
+		skb_push(skb, ETH_HLEN);
+		headlen = eth_get_headlen(tun->dev, skb->data,
+					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
 			this_cpu_inc(tun->pcpu_stats->rx_dropped);
-- 
2.27.0.rc2.251.g90737beb825-goog

