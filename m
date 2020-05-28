Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EFB1E6834
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405354AbgE1RFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405407AbgE1RFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 13:05:39 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2361C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 10:05:37 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w3so3779109qkb.6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 10:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tGkDf6mJcTrsNOnlJbD+viQnRh8tORh0UNParL/Vk5U=;
        b=lxXV/z/G/u1epdJi38cmDZQtoT9Qn2lUpCu7bG5AMGSGu0usr955VJ6TPUI6l8PVF+
         g3Hz5Tk4B25omEBuiQ1ldO0xYvgp6c8FtyE4Oz4NA61zN/5p+D5gEgOeaskIpcs9sTwy
         zhkL5k9tTSHPp9MZoWiqgJUe9IQb9ipPmrZOWq9F0zem7hGh/AsVGirwalRU+7Cj/Zba
         forM+LBgrwD4Bq4/w6ipCT/5UoyRPUAAaMROF5gYsQbu3lmHanW4GHK2tK+mM4iz2dQI
         30BMyDdApiO8nr4iXpuK04MhUGy1D023kxCFOnUFnkjgNJfM2yLoWWkSPvfo4BT7AqHu
         hF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tGkDf6mJcTrsNOnlJbD+viQnRh8tORh0UNParL/Vk5U=;
        b=GNt32WG8DAMrbFnu9vqPkuSLshYVZ2C39tDzeSO51v6DHof6VEghfa+X6jhMcVO5W+
         DF7N0m4d8MsKUwRXxO7UWcZ4L+DrVMs/JXHo/1G5JC86Z+hdCzVMp3IBBj3m9eJ7AU0S
         /2vFREHlj+BBQRIEVHc8ru3Mpvl+M6Zj2iFcLrkKLHwGtB1SG9DffDuqgK6Bu1330Dnn
         mQ+OuPaFX4JjkUQiyCmG0i9DtCAI/FqK1WDSVX4rNN65IecEaEjXodRZLJsmWuVDSxcx
         Z7DWX1i+FoRyfUQ2SkUyhulYFp1gncKRsnUuTGFxAaonhUezTlFKxm4NukPeEAflbHiv
         0vcQ==
X-Gm-Message-State: AOAM533cWwP679ZqATAcbMWSrOmakEZway6GYmWLCYX5HTmNBuiUf6xe
        C2ovUwTit4tuMYDrsfZANJfWxB2R
X-Google-Smtp-Source: ABdhPJx8hVQNaJ6r4unZReOfHqYa6WDE7JtamH/9gvw27W24PB8LrEwXRvsMj9ML3uAZd+N5E44fmQ==
X-Received: by 2002:a37:79c5:: with SMTP id u188mr3691862qkc.300.1590685536444;
        Thu, 28 May 2020 10:05:36 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id g66sm5151783qkb.122.2020.05.28.10.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 10:05:35 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] tun: correct header offsets in napi frags mode
Date:   Thu, 28 May 2020 13:05:32 -0400
Message-Id: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
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

Temporarily pull ETH_HLEN to make control flow the same for frags and
not frags. Then push the header just before calling napi_gro_frags.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Willem de Bruijn <willemb@google.com>
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
2.27.0.rc0.183.gde8f92d652-goog

