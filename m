Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB87C2EB13D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbhAERUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAERUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 12:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8FB22D57;
        Tue,  5 Jan 2021 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609867167;
        bh=jbafOIeCS2Z3MY/+jhbHLGBtjG+TRi8vMO2RAGkqXjo=;
        h=From:To:Cc:Subject:Date:From;
        b=uY12U7AA+qJ9G9meph4uLZcKDGIuk11c0g77rllwmpb0pUCAl9VBi7joQN21KxeZJ
         1M0vT8RLQScQV6uSkpZ6WSfn5iNWzVCkFxtzSkYaoIJkSprfmSAObnPrS0SEfSMyEJ
         kLfDT0JxVS1UNDrN/cGaLavwHSUd9knQhbrm/hn2zDmIU6J9BgwaaohhqWtc2nwtsB
         k2PDGVGdeS2t8KLkgDE7t2Py3n73p+ECS6VSarDvK5qWlYbr072Tmtw+Z4ac34sil1
         omk9EUwdaoaL2HN9v99uUAlDY6laT64410fs8cLpgxS3EZ3ZF9LHsCzsTQ5Somsq43
         M6lDrJUwaFuMg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Date:   Tue,  5 Jan 2021 18:19:21 +0100
Message-Id: <20210105171921.8022-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently mvpp2_xdp_setup won't allow attaching XDP program if
  mtu > ETH_DATA_LEN (1500).

The mvpp2_change_mtu on the other hand checks whether
  MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.

These two checks are semantically different.

Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
mvpp2_rx we have
  xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
  xdp.frame_sz = PAGE_SIZE;

Change the checks to check whether
  mtu > MVPP2_MAX_RX_BUF_SIZE

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Matteo Croce <mcroce@microsoft.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index afdd22827223..65490a0eb657 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4623,11 +4623,12 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
 	}
 
+	if (port->xdp_prog && mtu > MVPP2_MAX_RX_BUF_SIZE) {
+		netdev_err(dev, "Illegal MTU value %d for XDP mode\n", mtu);
+		return -EINVAL;
+	}
+
 	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
-		if (port->xdp_prog) {
-			netdev_err(dev, "Jumbo frames are not supported with XDP\n");
-			return -EINVAL;
-		}
 		if (priv->percpu_pools) {
 			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
 			mvpp2_bm_switch_buffers(priv, false);
@@ -4913,8 +4914,8 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
 	bool running = netif_running(port->dev);
 	bool reset = !prog != !port->xdp_prog;
 
-	if (port->dev->mtu > ETH_DATA_LEN) {
-		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP is not supported with jumbo frames enabled");
+	if (port->dev->mtu > MVPP2_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(bpf->extack, "MTU too large for XDP");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.26.2

