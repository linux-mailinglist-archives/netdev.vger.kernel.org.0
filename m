Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A38470A19
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343566AbhLJTT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:19:29 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59754 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343559AbhLJTT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:19:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A7F6CE2D28;
        Fri, 10 Dec 2021 19:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABABC341CC;
        Fri, 10 Dec 2021 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163750;
        bh=Vy7o5Lt/C70n/L3jin128JQiCJefaHSdAsTbi/wT9N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsiL7jEmisyNqDUOIpG04qTNaNESIKuHYlk3CeDFFf8qjimvtdD6eXKQ7NlTBjvX0
         F466EcbaSZmeDMmPUJRALIbgvmxAheO3Wzn2HQrEJfAaMxXg7nEt6mno4cwmrbYbYY
         n/jQYgFyS/0ujTvyD8p5hXtNpVJsADrSlUTWNO9eUw4Tqaf3sHg6v1mWp3kkhmJd3G
         RWJkZpylUrF2eT0LcsgcjXQlocIT2bcXXZ4WsYFuiayYYhq5P2PZFiPVdM8FfEYEjq
         YKcI+zu7c7RwOewv2v9/txEWIwl8x5AgwPrktuCGgXfdnFrh5JIj8UB29SBsZMQmUA
         wUbtInHqYdfww==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 10/23] net: mvneta: enable jumbo frames if the loaded XDP program support mb
Date:   Fri, 10 Dec 2021 20:14:17 +0100
Message-Id: <af8a15403900c7bc4ac7f02eb5be7e1615314eb2.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode if the loaded program declare to properly support
xdp multi-buff. At same time reject a xdp program not supporting xdp
multi-buffer if the driver is running in xdp multi-buffer mode.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 332699960b53..98db3d03116a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3750,6 +3750,7 @@ static void mvneta_percpu_disable(void *arg)
 static int mvneta_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
+	struct bpf_prog *prog = pp->xdp_prog;
 	int ret;
 
 	if (!IS_ALIGNED(MVNETA_RX_PKT_SIZE(mtu), 8)) {
@@ -3758,8 +3759,11 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
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
 
@@ -4428,8 +4432,9 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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

