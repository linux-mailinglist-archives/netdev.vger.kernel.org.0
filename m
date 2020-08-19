Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0D249FA6
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgHSNYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbgHSNRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 09:17:22 -0400
Received: from lore-desk.redhat.com (unknown [151.48.139.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27FE2208A9;
        Wed, 19 Aug 2020 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597842900;
        bh=fo0o3GunFroC3MY9AJkF6FV+TMBbGRrcxaXtHMFQ80E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExpqzWXVZbwJuDBPgyQWd2uP6uMQT4z6zJCdbWbE+tpuLHXQCJ1+gqkdsFW3dA2VN
         /MXH+LGzIHLgQkUMdhSXMxgLPwm6vhKu24d5MaBr8j833YHTnuZpGvwMP/WVGIdkJH
         5DgwFpi/2g8S107abeBT5Qgx7I4aq3SeT5f0kiEc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org
Subject: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Date:   Wed, 19 Aug 2020 15:13:51 +0200
Message-Id: <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1597842004.git.lorenzo@kernel.org>
References: <cover.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index efac4a5e0439..42f7614cd67c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3735,11 +3735,6 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
-		return -EINVAL;
-	}
-
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -4437,11 +4432,6 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 
-	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
-		return -EOPNOTSUPP;
-	}
-
 	if (pp->bm_priv) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Hardware Buffer Management not supported on XDP");
-- 
2.26.2

