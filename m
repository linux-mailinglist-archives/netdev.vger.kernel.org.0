Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CE039FAE3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhFHPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:35 -0400
Received: from simonwunderlich.de ([79.140.42.25]:34656 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhFHPhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:24 -0400
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D1ABA17405B;
        Tue,  8 Jun 2021 17:27:06 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 11/11] batman-adv: Drop reduntant batadv interface check
Date:   Tue,  8 Jun 2021 17:27:00 +0200
Message-Id: <20210608152700.30315-12-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

If batadv_hardif_enable_interface is called then its called from its
callback ndo_add_slave. It is therefore not necessary to check if it is a
batadv interface.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 44b0aa30c30a..55d97e18aa4a 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -9,7 +9,6 @@
 
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
-#include <linux/errno.h>
 #include <linux/gfp.h>
 #include <linux/if.h>
 #include <linux/if_arp.h>
@@ -698,14 +697,6 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 	kref_get(&hard_iface->refcount);
 
 	dev_hold(soft_iface);
-
-	if (!batadv_softif_is_valid(soft_iface)) {
-		pr_err("Can't create batman mesh interface %s: already exists as regular interface\n",
-		       soft_iface->name);
-		ret = -EINVAL;
-		goto err_dev;
-	}
-
 	hard_iface->soft_iface = soft_iface;
 	bat_priv = netdev_priv(hard_iface->soft_iface);
 
-- 
2.20.1

