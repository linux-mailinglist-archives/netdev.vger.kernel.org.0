Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DE93A6708
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhFNMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhFNMxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7633D6134F;
        Mon, 14 Jun 2021 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675059;
        bh=mnga0PPw6gBLpUsVl6ojsAX0mRejzoCGvDtYlRVZF7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pETRHBJcVq5tvNOQvvWZnKJYWEuVqIVZf7U4mGmXbdVdZDJW+uU6r/4C77aqAHc61
         hXDnYr1h2eJ6ByuKTjpOfJB2hKjzAbQZmQBQHHzTHJKyuACCdBPe6EYN3emDp80YS/
         sSfv/nfo7u9ubRNiJxq/SzVKp2BA+RPjS0DQJW08Od3Q9Mlvn8+OTiwkJ/7hiwcaC0
         YIhrK7zUV9WMjkFFo4tQJfUnt62jkIwa6fT3T3isNSNNfogg34NFlRyvWSBfYf09SF
         a7wDJ71eVPjgH4wTusghZhm6Dlox3JsZwfrvXvF8KKLwvVvKRZQQ67MQy7lL6tqgKe
         9DALIV2G74CCA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 06/14] net: mvneta: enable jumbo frames for XDP
Date:   Mon, 14 Jun 2021 14:49:44 +0200
Message-Id: <eaa4405b02ce8f397ef1f2667d9acb196b7e241e.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ab57be38ba03..505bec673ff7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3780,11 +3780,6 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
-		return -EINVAL;
-	}
-
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -4486,11 +4481,6 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 
-	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
-		return -EOPNOTSUPP;
-	}
-
 	if (pp->bm_priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Hardware Buffer Management not supported on XDP");
-- 
2.31.1

