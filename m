Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E803F2FD4
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbhHTPoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241277AbhHTPn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32F9A61131;
        Fri, 20 Aug 2021 15:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629474198;
        bh=J5iOBu/RLfyzoRs9yjGqJItDxrunul1v7IRB0KBNpLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI2RdjQLlTKguLAGT+Ot3FGvd1TU4hRVBoqF5Usxb81p7LbSwmgmpj59Pl95IJ+0r
         pLAY9eT83fGEtfAs/FE2mw3rqE/PMAAF04Nzc2LoOWznKcaBmfzaKnIPt1ccvtpreo
         fkpJqHx2rlIjyIAssEYbFaxcXG0R7iSK4Cv5LanoB3riVA3HQ3F0yY1Yts/svl+NTS
         FAON+KCNNQTLa89C1NVlL8g3flMugcnl4zoDUv5s0uFY/IXWljcP9FOJgD1eDKF2lA
         YyLPslI4SklD+fAR3L59XvwsM31Vi+y86g8gTqesfMNJ29Dg4cq6XaKEDrk9LNfOxL
         4pVcKSX6utnMA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v12 bpf-next 09/18] net: mvneta: enable jumbo frames for XDP
Date:   Fri, 20 Aug 2021 17:40:22 +0200
Message-Id: <855da36f6c4f5fca872f1cfd13842374945db88f.1629473233.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
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
index dde1c28b0ea8..3dbcb067346c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3767,11 +3767,6 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
-		return -EINVAL;
-	}
-
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -4481,11 +4476,6 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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

