Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B1B2B17C5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgKMJH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMJH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:07:56 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9B0C0613D1;
        Fri, 13 Nov 2020 01:07:56 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id 74so12741845lfo.5;
        Fri, 13 Nov 2020 01:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lR7/8vjXJDBM73PVRP/RhfEwJV/6UykOcvsNpMs/RAE=;
        b=cXKphYEMrBWFsSAa2+890QE7UsPFgUnJm7kKit91fFJrp3FJULrOTbjYIn5Oo1T3rl
         BWYXXOTj+sOzD6G5ITNcokkG6aFPZYHajJ0EmNFyttZQ2LiII68OaQ23kpbOnkzdUuQG
         eBTxlIZGTW524iE1sbUuOewyIWkFVukBgSdUrrM2SmWFHNlynjf5svkFHYm3nEDNB7Wt
         DdocptY4OqYdGOu00ThUMbL1HUSiNqMddLtZQMDEfb1Q/FbFEpJlKB4+5BkGtsiQa1+G
         8gUrTQFvd/jkWS5TJawiOFD5pVZCHlddnhnQdMDJsJaGEgaXeCg1F+ti0u0GRq0ZQekf
         T8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lR7/8vjXJDBM73PVRP/RhfEwJV/6UykOcvsNpMs/RAE=;
        b=hYeLveu1K9TlVtz5jf9akPzyXo6vxGqUjOyGLOr+m+EMbKFY6Xq7ItH+AcwA0uqqEj
         OqfRm+uKCLIfYPxPO1sZSlIGq2xDlJKCwirpOWv/v4Vh0KeTFCGPSKnjMwbviPren1Bt
         psn0IgPTh5zyhOsRjZGMNBlvDF9yLNbQczFQm/4rANQvTvFzD7QJ4DMsj7UR7FUo1t3E
         xym0KpAtSz0vAJ0wXtI6kdqPLeg7OasQTBOffqnXhHzms8l0fwYEr3rFi2vkGcWWV4er
         ozq4mAtrxFWQDpwQnxWsnLRqs69N+GawmiIuEjpsKWPoW4E8k7zMeDy7+SMrr/WKSigR
         mVpw==
X-Gm-Message-State: AOAM5319CD2ksWi7XKR5DRf8NUMfRJuBhNwK54fbAKrRTXmswFQue7II
        Fd17vpC6P7wqBOWhTolGKyY=
X-Google-Smtp-Source: ABdhPJyxGKAD90tNpLzL0m0Fm78FGMIIHqz4xSYuklo+YQHPvL9qyzVt/XUep8Eex1S2SHDQgBemGA==
X-Received: by 2002:a19:c191:: with SMTP id r139mr535421lff.258.1605258474914;
        Fri, 13 Nov 2020 01:07:54 -0800 (PST)
Received: from localhost.localdomain (dmjt96jhvbz3j2f08hy-4.rev.dnainternet.fi. [2001:14bb:51:e1dd:1cd1:d2e:7b13:dc30])
        by smtp.gmail.com with ESMTPSA id a8sm603684ljq.77.2020.11.13.01.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 01:07:54 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH v2 3/3] net: xfrm: use core API for updating/providing stats
Date:   Fri, 13 Nov 2020 11:07:34 +0200
Message-Id: <20201113090734.117349-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <59b6c94d-e0de-e4f5-d02e-e799694f6dc8@gmail.com>
References: <59b6c94d-e0de-e4f5-d02e-e799694f6dc8@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
stats.

Use this function instead of own code.

While on it, remove xfrmi_get_stats64() and replace it with
dev_get_tstats64().

Signed-off-by: Lev Stipakov <lev@openvpn.net>
---
 
 v2: replace xfrmi_get_stats64() vs dev_get_tstats64()

 net/xfrm/xfrm_interface.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9b8e292a7c6a..697cdcfbb5e1 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -319,12 +319,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 	err = dst_output(xi->net, skb->sk, skb);
 	if (net_xmit_eval(err) == 0) {
-		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
-
-		u64_stats_update_begin(&tstats->syncp);
-		tstats->tx_bytes += length;
-		tstats->tx_packets++;
-		u64_stats_update_end(&tstats->syncp);
+		dev_sw_netstats_tx_add(dev, 1, length);
 	} else {
 		stats->tx_errors++;
 		stats->tx_aborted_errors++;
@@ -538,15 +533,6 @@ static int xfrmi_update(struct xfrm_if *xi, struct xfrm_if_parms *p)
 	return err;
 }
 
-static void xfrmi_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *s)
-{
-	dev_fetch_sw_netstats(s, dev->tstats);
-
-	s->rx_dropped = dev->stats.rx_dropped;
-	s->tx_dropped = dev->stats.tx_dropped;
-}
-
 static int xfrmi_get_iflink(const struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
@@ -554,12 +540,11 @@ static int xfrmi_get_iflink(const struct net_device *dev)
 	return xi->p.link;
 }
 
-
 static const struct net_device_ops xfrmi_netdev_ops = {
 	.ndo_init	= xfrmi_dev_init,
 	.ndo_uninit	= xfrmi_dev_uninit,
 	.ndo_start_xmit = xfrmi_xmit,
-	.ndo_get_stats64 = xfrmi_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = xfrmi_get_iflink,
 };
 
-- 
2.25.1

