Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC224B183D
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344998AbiBJWe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:34:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243209AbiBJWe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:34:56 -0500
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05965F47
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:34:56 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id II1dnjIzz9r2MII1enUsYH; Thu, 10 Feb 2022 23:34:55 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 10 Feb 2022 23:34:55 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: [PATCH v2 1/2] nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()
Date:   Thu, 10 Feb 2022 23:34:52 +0100
Message-Id: <4acb805751f2cf5de8d69e9602a88ec39feff9fc.1644532467.git.christophe.jaillet@wanadoo.fr>
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
So NFP_MAX_MAC_INDEX (0xff) is a valid id.

In order for the error handling path to work correctly, the 'invalid'
value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
inclusive.

So set it to -1.

Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index cd50db779dda..9244b35e3855 100644
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
@@ -997,7 +997,7 @@ nfp_tunnel_add_shared_mac(struct nfp_app *app, struct net_device *netdev,
 err_free_entry:
 	kfree(entry);
 err_free_ida:
-	if (ida_idx != NFP_MAX_MAC_INDEX)
+	if (ida_idx != -1)
 		ida_simple_remove(&priv->tun.mac_off_ids, ida_idx);
 
 	return err;
-- 
2.32.0

