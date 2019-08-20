Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C0B96C6A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfHTWd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730983AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=waO2JwpBXdWHyRZFOnonh6emzAyL3KyxKm8YUitOyec=; b=FMYL65xn2z9b/O6U7QHAESO6wm
        +62ikzccBeuT/AP/SWhttGbDbcxq4G1yEUPlhWS5js+fwdplKFOva4ojF+rNejckvsBc5u7uu1oDU
        S7Ac6xEQFO4h5mKqii5hsZ/aEQtAPpbpHHKOrC6l2/nAhhRXuVSulxChV1rhcBQG+X4F+tMJuCusE
        Q9/TY29ifodNUf2Fm301y2hQuhtF+KMJEU8NER6tpavFFR8hTlMBms0Z1w5LuZtJa9KasDBByAZj4
        BmbGTyUJDwa4gkDxBbDupHDky4d4JrmRU73FbD72D5soOb+EHwkUs9ktGNNeEUOKmZg7lkcvUSyKl
        OHFiokqA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qx-Eg; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 15/38] nfp: Convert internal ports to XArray
Date:   Tue, 20 Aug 2019 15:32:36 -0700
Message-Id: <20190820223259.22348-16-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Since nfp_fl_internal_ports was only an IDR and the lock to protect it,
replace the entire data structure with an XArray (which has an embedded
lock).

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 .../net/ethernet/netronome/nfp/flower/main.c  | 44 +++++++------------
 .../net/ethernet/netronome/nfp/flower/main.h  | 12 +----
 2 files changed, 17 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index 7a20447cca19..706ae41645f5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -40,35 +40,31 @@ nfp_flower_lookup_internal_port_id(struct nfp_flower_priv *priv,
 				   struct net_device *netdev)
 {
 	struct net_device *entry;
-	int i, id = 0;
+	unsigned long i;
 
-	rcu_read_lock();
-	idr_for_each_entry(&priv->internal_ports.port_ids, entry, i)
-		if (entry == netdev) {
-			id = i;
-			break;
-		}
-	rcu_read_unlock();
+	xa_for_each(&priv->internal_ports, i, entry) {
+		if (entry == netdev)
+			return i;
+	}
 
-	return id;
+	return 0;
 }
 
 static int
 nfp_flower_get_internal_port_id(struct nfp_app *app, struct net_device *netdev)
 {
 	struct nfp_flower_priv *priv = app->priv;
-	int id;
+	int err, id;
 
 	id = nfp_flower_lookup_internal_port_id(priv, netdev);
 	if (id > 0)
 		return id;
 
-	idr_preload(GFP_ATOMIC);
-	spin_lock_bh(&priv->internal_ports.lock);
-	id = idr_alloc(&priv->internal_ports.port_ids, netdev,
-		       NFP_MIN_INT_PORT_ID, NFP_MAX_INT_PORT_ID, GFP_ATOMIC);
-	spin_unlock_bh(&priv->internal_ports.lock);
-	idr_preload_end();
+	err = xa_alloc_bh(&priv->internal_ports, &id, netdev,
+		       XA_LIMIT(NFP_MIN_INT_PORT_ID, NFP_MAX_INT_PORT_ID),
+		       GFP_ATOMIC);
+	if (err < 0)
+		return err;
 
 	return id;
 }
@@ -95,13 +91,8 @@ static struct net_device *
 nfp_flower_get_netdev_from_internal_port_id(struct nfp_app *app, int port_id)
 {
 	struct nfp_flower_priv *priv = app->priv;
-	struct net_device *netdev;
-
-	rcu_read_lock();
-	netdev = idr_find(&priv->internal_ports.port_ids, port_id);
-	rcu_read_unlock();
 
-	return netdev;
+	return xa_load(&priv->internal_ports, port_id);
 }
 
 static void
@@ -114,9 +105,7 @@ nfp_flower_free_internal_port_id(struct nfp_app *app, struct net_device *netdev)
 	if (!id)
 		return;
 
-	spin_lock_bh(&priv->internal_ports.lock);
-	idr_remove(&priv->internal_ports.port_ids, id);
-	spin_unlock_bh(&priv->internal_ports.lock);
+	xa_erase_bh(&priv->internal_ports, id);
 }
 
 static int
@@ -133,13 +122,12 @@ nfp_flower_internal_port_event_handler(struct nfp_app *app,
 
 static void nfp_flower_internal_port_init(struct nfp_flower_priv *priv)
 {
-	spin_lock_init(&priv->internal_ports.lock);
-	idr_init(&priv->internal_ports.port_ids);
+	xa_init_flags(&priv->internal_ports, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_BH);
 }
 
 static void nfp_flower_internal_port_cleanup(struct nfp_flower_priv *priv)
 {
-	idr_destroy(&priv->internal_ports.port_ids);
+	xa_destroy(&priv->internal_ports);
 }
 
 static struct nfp_flower_non_repr_priv *
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 31d94592a7c0..735e995ae740 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -119,16 +119,6 @@ struct nfp_fl_lag {
 	struct sk_buff_head retrans_skbs;
 };
 
-/**
- * struct nfp_fl_internal_ports - Flower APP priv data for additional ports
- * @port_ids:	Assignment of ids to any additional ports
- * @lock:	Lock for extra ports list
- */
-struct nfp_fl_internal_ports {
-	struct idr port_ids;
-	spinlock_t lock;
-};
-
 /**
  * struct nfp_flower_priv - Flower APP per-vNIC priv data
  * @app:		Back pointer to app
@@ -191,7 +181,7 @@ struct nfp_flower_priv {
 	struct list_head non_repr_priv;
 	unsigned int active_mem_unit;
 	unsigned int total_mem_units;
-	struct nfp_fl_internal_ports internal_ports;
+	struct xarray internal_ports;
 	struct delayed_work qos_stats_work;
 	unsigned int qos_rate_limiters;
 	spinlock_t qos_stats_lock; /* Protect the qos stats */
-- 
2.23.0.rc1

