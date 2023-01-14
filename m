Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B702166AC47
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjANPzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjANPzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:55:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499D77EED;
        Sat, 14 Jan 2023 07:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCE0460B43;
        Sat, 14 Jan 2023 15:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21E0C433D2;
        Sat, 14 Jan 2023 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673711701;
        bh=8bcWrSdLkPBLDabPqoyHtUr2JYRbbglpSB6VTJ2pAFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aTVVQJdL88/PrLXgpptFkPZL/QS6rkeh4uvkbfxkmT+D/lABzyfJh9F0HJLKjQjiQ
         uzThsYPEWEPqICD1ucLX4Dp5RdGZGgBfrZNS82SY3s8HIBKfMDCzI0iecKklriYOtU
         60bypyR8ydj9mYxUP47vx3y79qR1LStpukQvm+CgR5b5tI3tgyoKfw3C+v+H2X2FAd
         dXG7aCNj4SmA/Q92jEs0azMVf+lm+tRUnqyMA0jtuJ6/M3l0oOguzYy/7PuenHFoQw
         /XhXFPXas/Dew395G9E9GdTTOC0n/lFFMHLsueJkdLp6GArZGR2jlJMifonouoBYVq
         yeqjST+PZM4DQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: [RFC v2 bpf-next 3/7] xsk: add usage of XDP features flags
Date:   Sat, 14 Jan 2023 16:54:33 +0100
Message-Id: <36956338853442e6d546687678a93470a164ff17.1673710867.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673710866.git.lorenzo@kernel.org>
References: <cover.1673710866.git.lorenzo@kernel.org>
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
 net/xdp/xsk_buff_pool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index ed6c71826d31..2e6fa082142a 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -178,8 +178,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
 		/* For copy-mode, we are done. */
 		return 0;
 
-	if (!netdev->netdev_ops->ndo_bpf ||
-	    !netdev->netdev_ops->ndo_xsk_wakeup) {
+	if ((netdev->xdp_features & NETDEV_XDP_ACT_ZC) != NETDEV_XDP_ACT_ZC) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_pool;
 	}
-- 
2.39.0

