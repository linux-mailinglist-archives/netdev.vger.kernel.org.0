Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1D1B66FA
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgDWWot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgDWWot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:44:49 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4A0C09B042;
        Thu, 23 Apr 2020 15:44:49 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o15so3646559pgi.1;
        Thu, 23 Apr 2020 15:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q+5+rmKFTBDtKZKbExYcccSKJKHcBafdo/2P8vmaWnw=;
        b=jYf/qew2xwPt9wR4+QEpY5eosGKsR8x7sO08Ou2nIuqjazuWaNJedOIeReMizXRUWm
         0W2wImgewUR6e6/IFzyK154ENOZAEvE4jp0OABYALrVS+WcxK9MW4iJyJM0dU+oa8qz0
         Of7v5LSpAdOJL2bG6v44cKAjCNieafiHTPEPjHuw1wZ3uhIBAVl2p2IZLbR+ToF8evIY
         E1Py7yTVpBgv+4ADoYyDny88glxDS6oc0BXoVtJWbLwZ273oQR3NwQj3hh9V+IZZAlMr
         TofOjFMZX1rqJzC8LZg4GiZhCGbl7n2tFlGQtv+IbDp9J2oIvO1O2GsYX1UgBYDjwjl7
         qr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q+5+rmKFTBDtKZKbExYcccSKJKHcBafdo/2P8vmaWnw=;
        b=QpOqsZzE+wJOOFTLHWNjsY47Hx+me86ZiEy0AGG1ms9ViAMJeYNSnWJ3buPt/VLZpm
         b9QfxlyPDtMVxK5lImPXpDkkUDqRhEQcv0AtlwvfrYYz1Vl4B+PgZ301WnNj7Sm0rGCB
         ZGruvrTuGmRDHLULxONJwKmNIncd6yPJTBA2J5D9VvociRb1GcJIC6+tlI+KC67soV1N
         nUTa//FADTLYmpUqLuTprFRoAwp3L9cQ8kjrVX0557z6m8VwVsAT3fCSk13X3p8XIzGp
         D3aBiNZ8F+owC2SWSRwMxt5k1/Tspy9XQhaCbB8tYW42FT2kx5oiQfc2fMG4Y+DkutUL
         7fTA==
X-Gm-Message-State: AGi0PuappjJAN3pHSRMue5tAgvJyrvqfzMlBJeONObtCHnLdZrY9MY5m
        if513/XR0a3qh/VdSn9BxKQ=
X-Google-Smtp-Source: APiQypI2HBCHdZt/kkfyjEZauH2K10lXc6jJryXBIdqUUdgKM0XaVnRjnv0nBLj31dG0zpeG/xO57A==
X-Received: by 2002:a62:e211:: with SMTP id a17mr5610467pfi.250.1587681888677;
        Thu, 23 Apr 2020 15:44:48 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h31sm3405815pjb.33.2020.04.23.15.44.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 15:44:48 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net] net: bcmgenet: correct per TX/RX ring statistics
Date:   Thu, 23 Apr 2020 15:44:17 -0700
Message-Id: <1587681857-19734-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change to track net_device_stats per ring to better support SMP
missed updating the rx_dropped member.

The ndo_get_stats method is also needed to combine the results for
ethtool statistics (-S) before filling in the ethtool structure.

Fixes: 37a30b435b92 ("net: bcmgenet: Track per TX/RX rings statistics")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d975338bf78d..c4765bbe527b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -934,6 +934,8 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
 	if (netif_running(dev))
 		bcmgenet_update_mib_counters(priv);
 
+	dev->netdev_ops->ndo_get_stats(dev);
+
 	for (i = 0; i < BCMGENET_STATS_LEN; i++) {
 		const struct bcmgenet_stats *s;
 		char *p;
@@ -3156,6 +3158,7 @@ static struct net_device_stats *bcmgenet_get_stats(struct net_device *dev)
 	dev->stats.rx_packets = rx_packets;
 	dev->stats.rx_errors = rx_errors;
 	dev->stats.rx_missed_errors = rx_errors;
+	dev->stats.rx_dropped = rx_dropped;
 	return &dev->stats;
 }
 
-- 
2.7.4

