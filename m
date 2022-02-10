Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF84B183C
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbiBJWfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:35:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiBJWfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:35:06 -0500
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30315F47
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:35:07 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id II1pnjJ4L9r2MII1pnUsZS; Thu, 10 Feb 2022 23:35:05 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 10 Feb 2022 23:35:05 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] nfp: flower: Remove usage of the deprecated ida_simple_xxx API
Date:   Thu, 10 Feb 2022 23:35:04 +0100
Message-Id: <721abecd2f40bed319ab9fb3feebbea8431b73ed.1644532467.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
References: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
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

Use ida_alloc_xxx()/ida_free() instead to
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../net/ethernet/netronome/nfp/flower/tunnel_conf.c    | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 9244b35e3855..c71bd555f482 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
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
 
@@ -998,7 +998,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	kfree(entry);
 err_free_ida:
 	if (ida_idx != -1)
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;
 }
@@ -1061,7 +1061,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 		}
 
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 		entry->index = nfp_mac_idx;
 		return 0;
 	}
@@ -1081,7 +1081,7 @@ nfp_tunnel_del_shared_mac(struct nfp_app *app, struct net_device *netdev,
 	/* If MAC has global ID then extract and free the ida entry. */
 	if (nfp_tunnel_is_mac_idx_global(nfp_mac_idx)) {
 		ida_idx = nfp_tunnel_get_ida_from_global_mac_idx(entry->index);
-		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
+		ida_free(&priv->tun.mac_off_ids, ida_idx);
 	}
 
 	kfree(entry);
-- 
2.32.0

