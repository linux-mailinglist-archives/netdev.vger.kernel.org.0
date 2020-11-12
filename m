Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A832B0C7B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgKLSWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgKLSWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:25 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8B0C0617A6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id f18so4874609pgi.8
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PgdpGctimavYrhF92nrivoknxvlhXI55Yp4SkioIsfI=;
        b=k+kV09aOIJxhuGB1YRl3YhX982LI6kOnp+WyOCwbt42hxk4neEsIdUk7GN0SjPBlrI
         U5whd2QU/9pWwi5LtTsYmte/l8xL9K13tS8hreFP1nVYLylAGIwRQ6/zYD3YJopA7w9U
         WFG4moZKi25etht/lb1+HlrJyNV0ll0VrEWMz3FTCoMogYvhX2Is+0iIpaDvSTKptPR3
         GmCmDsMsOD8Rf1s/Tu5+qdYJ/+e7luqFePcLCY+I9SkyXfJeS66ii+4J47YbsJpbMYhL
         X6qxmonm6RZ7AgWD6Xgn2g9NLl84C4IpvrsBuoX1kU3Fxv1NzfXkICLNboZ4SbEqJlPs
         b+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PgdpGctimavYrhF92nrivoknxvlhXI55Yp4SkioIsfI=;
        b=FyDk/lvf9qEpUTUm2rA510OH7kwM7QKGnijH8Z6i3Jqii+mX8S5NJaaW/7FCWEmHBc
         HA/BZif7xu3hYaPxSUQcbijx9hngEmK/jJeEIz2fhJL7ynzs82W2aGbeH28Yt+l0wJIh
         bWsXe7PXC7LImfxMlXiCkCothOAQPIqUmLcyWk9LqfB+Hv/+D1rRUhRUYlrUKULVuzk0
         Sc/ibjnDvd4o97KY/7+pJ0C1RINdrRCEBHXucSbKa+d6USJG2uMjOc2eWX3bWaBqG3A3
         fEeKNA3eUToZdeTO0LdeQgA6hkQ2RVcLCM0GkWHmY4k1MeJS4fhyhdCEvzKoYXIu1j0y
         S3HA==
X-Gm-Message-State: AOAM532YdTP/b7v29SS6aaK0Q1RCdOaMAxgi3mMR3DuSyYdjY+DUve58
        wtMqVOa6LZdQgngr3TlxEIJONvyaXHur7g==
X-Google-Smtp-Source: ABdhPJwpQzpZ6whPeh+VhrUMEVxWxg1hbQuxwfhCquoaWejKOnU2mFZkDGgNTF+hFSSHtvT41dIHhw==
X-Received: by 2002:a17:90a:550d:: with SMTP id b13mr426505pji.133.1605205344366;
        Thu, 12 Nov 2020 10:22:24 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:23 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 7/8] ionic: change set_rx_mode from_ndo to can_sleep
Date:   Thu, 12 Nov 2020 10:22:07 -0800
Message-Id: <20201112182208.46770-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having two different ways of expressing the same
sleepability concept, using opposite logic, we can rework the
from_ndo to can_sleep for a more consistent usage.

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 58bf6e9314bb..7408755bac17 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1129,7 +1129,7 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 		lif->rx_mode = rx_mode;
 }
 
-static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
+static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_deferred_work *work;
@@ -1149,10 +1149,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	if (from_ndo)
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
+	if (can_sleep)
 		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	else
+		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
@@ -1164,10 +1164,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	if (from_ndo)
-		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
+	if (can_sleep)
 		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
@@ -1179,7 +1179,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	if (lif->rx_mode != rx_mode) {
-		if (from_ndo) {
+		if (!can_sleep) {
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
 				netdev_err(lif->netdev, "%s OOM\n", __func__);
@@ -1197,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 
 static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 {
-	ionic_set_rx_mode(netdev, true);
+	ionic_set_rx_mode(netdev, false);
 }
 
 static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
@@ -1784,7 +1784,7 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	if (lif->netdev->features & NETIF_F_RXHASH)
 		ionic_lif_rss_init(lif);
 
-	ionic_set_rx_mode(lif->netdev, false);
+	ionic_set_rx_mode(lif->netdev, true);
 
 	return 0;
 
-- 
2.17.1

