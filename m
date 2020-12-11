Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B4B2D7596
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395568AbgLKM2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405455AbgLKM1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:40 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D55BC0617B0
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:23 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id e7so10624431ljg.10
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=346/Rc08FgiFF6S7Lt/UlGl6DNz4PYBAMKEmKoZCeHQ=;
        b=RmdgQLqem1s9Q58W21CifzoepXVXUTb4U+L1q9V2hgQeANWNLbv2T+1YFRZOAb1E6O
         zYiGzwkyfv+Ci6rc8RCUecdunSZeyGj5ej/YfkpUEwgZtCApjBT6WEWFyOvdjNLNwV1a
         lVWpfcgj/2thF99d4FIAD/p9KrrVMp2YlMm+at4FfmS9WuAWReIgRmnmXB5hxuG0Hbqk
         RMcU0ArzNibtPNwF9wKfwpBl024HsFtR9iEkVWQKGhb45q7VWWt08F/xtUi3aZCSwcEv
         xuljNfgumaJC42TXF60V0KYn4wQ7IESUDDgFxevcLOcfCb7mgsfUO5NdI6+sJy+yO46E
         IuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=346/Rc08FgiFF6S7Lt/UlGl6DNz4PYBAMKEmKoZCeHQ=;
        b=PzwK8ovM4p3wT1r6g4yZxN55oadrypJIagqs7ac8fpluCK1adUJTpjnIp53Tk38gmm
         JtInXtMpc34/sdMFvj6L3hdii0OoMQ6vBMzfEoamA1ypGC8mtEwwipOKiiUITozrzPpq
         nmYviWkSDb47OnufHP9O2LvDeXgCdmo4U28C6V8FQrWawpTPV0mY9R5M+MNWuQtMwo3B
         9pT0RIJVziRPNf8/kpQnrqqP2pCPtVyxSmhV3ituv2O6ySEZeTaj35A7MNLvVBOPg+1x
         3m+/B8Adnxdc5mm9WGm5ZThzUNO9gGIr/PD+z6uVZeEK9GkP2JL8OsWWFW2pCNpClAsR
         oYCQ==
X-Gm-Message-State: AOAM5321jf/GPqJONUpvh7eX/p6r4xTKAz9lbCVgwylIQtUfRriSIdGU
        UyVwpLuPsoMkxT6nB+gV6TRW2Mf3kfC/FA==
X-Google-Smtp-Source: ABdhPJxBEcwXnQV9Oxh4hU00KFaY1+bAAUMu7kGljna2iakJOSkPUk75E0zOj4GXMC/1dAdmSgMPYA==
X-Received: by 2002:a2e:9bd5:: with SMTP id w21mr5007336ljj.432.1607689581467;
        Fri, 11 Dec 2020 04:26:21 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:20 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 08/12] gtp: set dev features to enable GSO
Date:   Fri, 11 Dec 2020 13:26:08 +0100
Message-Id: <20201211122612.869225-9-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211122612.869225-1-jonas@norrbonn.se>
References: <20201211122612.869225-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 236ebbcb37bf..7bbeec173113 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -536,7 +536,11 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(r))
 		goto err_rt;
 
-	skb_reset_inner_headers(skb);
+	r = udp_tunnel_handle_offloads(skb, true);
+	if (unlikely(r))
+		goto err_rt;
+
+	skb_set_inner_protocol(skb, skb->protocol);
 
 	gtp_push_header(skb, pctx, &port);
 
@@ -618,6 +622,8 @@ static void gtp_link_setup(struct net_device *dev)
 
 	dev->priv_flags	|= IFF_NO_QUEUE;
 	dev->features	|= NETIF_F_LLTX;
+	dev->hw_features |= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
+	dev->features	|= NETIF_F_SG | NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM;
 	netif_keep_dst(dev);
 
 	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
-- 
2.27.0

