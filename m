Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031C467F868
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 15:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbjA1OHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 09:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbjA1OHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 09:07:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED281C33C;
        Sat, 28 Jan 2023 06:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E4B60C0F;
        Sat, 28 Jan 2023 14:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11250C433EF;
        Sat, 28 Jan 2023 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674914813;
        bh=EUEjHYCFZLBlSjnOAZ24J2T1iHJ/3Lz1NQeBwSmXZYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pf5Xt0MMQj9ubWCH3TYJtbdixcglozu74c0/YKKT3nWNZh9wuB5fYMm5dwYmE4iFe
         7CdqTlyuL5p6NtpA6p/Z2hp9tRJmWlLhSE/UyHH2a9HbrMwlvE4+D4nyY2jJC8dGih
         I21+j4+c2BYmTW1NVPWyGRpfF6aKR6w0GE8tykfffBdCOaGzF4IYqjX94o0RAvI/RG
         OBc372u53/OSoGrS6SyIwpChCW7vElQgydxw/CCQRXwREUtZeKHOanqPY04X3861Qt
         zOKoQ8pijWvOZ9K6n/fhO1GUoXdwiPnSQppfh0Bo1aRxDLO4TpuFjWaLedYa8RNGb1
         3wQcgRA5sIyXQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev, sdf@google.com
Subject: [PATCH v4 bpf-next 3/8] xsk: add usage of XDP features flags
Date:   Sat, 28 Jan 2023 15:06:14 +0100
Message-Id: <e2caea4cad530f2780e1debf6512842cbb28c962.1674913191.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674913191.git.lorenzo@kernel.org>
References: <cover.1674913191.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <alardam@gmail.com>

Change necessary condition check for XSK from ndo functions to
xdp features flags.

Signed-off-by: Marek Majtyka <alardam@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/xdp/xsk_buff_pool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index ed6c71826d31..b2df1e0f8153 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -140,6 +140,10 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
+#define NETDEV_XDP_ACT_ZC	(NETDEV_XDP_ACT_BASIC |		\
+				 NETDEV_XDP_ACT_REDIRECT |	\
+				 NETDEV_XDP_ACT_XSK_ZEROCOPY)
+
 int xp_assign_dev(struct xsk_buff_pool *pool,
 		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
@@ -178,8 +182,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 		/* For copy-mode, we are done. */
 		return 0;
 
-	if (!netdev->netdev_ops->ndo_bpf ||
-	    !netdev->netdev_ops->ndo_xsk_wakeup) {
+	if ((netdev->xdp_features & NETDEV_XDP_ACT_ZC) != NETDEV_XDP_ACT_ZC) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_pool;
 	}
-- 
2.39.1

