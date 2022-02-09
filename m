Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5164AFCBE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241637AbiBITB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbiBITAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:00:38 -0500
Received: from smtp.smtpout.orange.fr (smtp10.smtpout.orange.fr [80.12.242.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7827BC003663
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 10:59:07 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id HsAznZHevbnFGHsAzncVqP; Wed, 09 Feb 2022 19:58:51 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 09 Feb 2022 19:58:51 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: [PATCH] nfp: flower: Fix a potential theorical leak in nfp_tunnel_add_shared_mac()
Date:   Wed,  9 Feb 2022 19:58:47 +0100
Message-Id: <49e30a009f6fc56cfb76eb2c922740ac64c7767d.1644433109.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
inclusive.
So NFP_MAX_MAC_INDEX (0xff) is a valid id

In order for the error handling path to work correctly, the 'invalid'
value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
inclusive.

So set it to -1.

While at it, use ida_alloc_xxx()/ida_free() instead to
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index ce865e619568..b60c2b78ba04 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -922,8 +922,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 			  int port, bool mod)
 {
 	struct nfp_flower_priv *priv = app->priv;
-	int ida_idx = NFP_MAX_MAC_INDEX, err;
 	struct nfp_tun_offloaded_mac *entry;
+	int ida_idx = -1, err;
 	u16 nfp_mac_idx = 0;
 
 	entry = nfp_tunnel_lookup_offloaded_macs(app, netdev->dev_addr);
@@ -942,8 +942,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	if (!nfp_mac_idx) {
 		/* Assign a global index if non-repr or MAC is now shared. */
 		if (entry || !port) {
-			ida_idx = ida_simple_get(&priv->tun.mac_off_ids, 0,
-						 NFP_MAX_MAC_INDEX, GFP_KERNEL);
+			ida_idx = ida_alloc_max(&priv->tun.mac_off_ids,
+						NFP_MAX_MAC_INDEX, GFP_KERNEL);
 			if (ida_idx < 0)
 				return ida_idx;
 
@@ -997,8 +997,8 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 err_free_entry:
 	kfree(entry);
 err_free_ida:
-	if (ida_idx != NFP_MAX_MAC_INDEX)
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+	if (ida_idx != -1)
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;
 }
@@ -1063,7 +1063,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		}
 
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 		entry->index = nfp_mac_idx;
 		return 0;
 	}
@@ -1077,7 +1077,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	/* If MAC has global ID then extract and free the ida entry. */
 	if (nfp_tunnel_is_mac_idx_global(entry->index)) {
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 	}
 
 	kfree(entry);
-- 
2.32.0

