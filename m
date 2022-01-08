Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17244488366
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbiAHLyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:54:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51632 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiAHLyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:54:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5EBFB80862;
        Sat,  8 Jan 2022 11:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DDCC36AE5;
        Sat,  8 Jan 2022 11:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642874;
        bh=zu589/XwF6lrUgCqu7HVtivRftWhHCJuHypZdovrccw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvP0Pu+alZsoo1e2qc0GR1gk/Zs0bHxzX3LOi8cR9z+oO9DdrHE/BXbiUbnRn/qAd
         z9mfEBSO+/wiENpXTi2ZusX6kxBRZlohmhI0A35JwxLqPMCCSpZH+eUOwBZmqYAc74
         uzB1+40jLmoNHmU9524Vy/28dN4gFUukEEvQ33evmSWjeTSmyigg35tc7k8KsUDOjI
         BeK5pH8kgW1cuvHRNEwyF2RRSO+BBDraD0xBzQH1/YLkYYglWtd45m8SZ4IVYYEPLB
         DgzfNsNwvXrzD94Tm6yfZDbWOl4IZPjiQ1+/Hf3hryrc5YGXovu7EL4kNKqfumcEXz
         ZXu6VpBFnbq/A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 10/23] net: mvneta: enable jumbo frames if the loaded XDP program support mb
Date:   Sat,  8 Jan 2022 12:53:13 +0100
Message-Id: <ec183c1006c4924005f20b64136fa974107d98fc.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode if the loaded program declare to properly support
xdp multi-buff. At same time reject a xdp program not supporting xdp
multi-buffer if the driver is running in xdp multi-buffer mode.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 94f22563695d..bec18136d29a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3778,6 +3778,7 @@ static void mvneta_percpu_disable(void *arg)
 static int mvneta_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
+	struct bpf_prog *prog = pp->xdp_prog;
 	int ret;
 
 	if (!IS_ALIGNED(MVNETA_RX_PKT_SIZE(mtu), 8)) {
@@ -3786,8 +3787,11 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
+	if (prog && !prog->aux->xdp_mb && mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		netdev_info(dev,
+			    "Illegal MTU %d for XDP prog without multi-buf\n",
+			    mtu);
+
 		return -EINVAL;
 	}
 
@@ -4528,8 +4532,9 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 
-	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+	if (prog && !prog->aux->xdp_mb && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "prog does not support XDP multi-buff");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.33.1

