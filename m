Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963023583BE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhDHMwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhDHMwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 08:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9B661164;
        Thu,  8 Apr 2021 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617886309;
        bh=edUoQAGUDnArCwWyIwnFifxASFS7ClzZ0XGvSgwZG78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHPwH3op0mHG2mH4U9s1LD5nns0J6Xe3jM/sOmGQ3RxyBEE//a8bKO6v9kdOK8ev9
         pr38PTRoZ9qjpbDiOEjVZtnyjHZYpVBNScJv/qwngFTRPoMTjh4mr4HJ/dtJ4n35R9
         SwSCYRCgPr6Ta46SoCH+hAZbByiMqLBOux1MXRKsOqNOGfHwAfG/Co539NLvzfDpmY
         SPzUeRoi3DTI+kCpSL9dj0uRgsTitqKRItkr8SWdK4IwztDhnTKS1tEn3BGPXVC/fv
         RgDThYORHtqY2UN49iqTU1yoVqK2E9flvz8H6GRHMf2a/Dt/Dr4SferV4oakaLpyw3
         W2IE9YpoHh9Zw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: [PATCH v8 bpf-next 06/14] net: mvneta: enable jumbo frames for XDP
Date:   Thu,  8 Apr 2021 14:50:58 +0200
Message-Id: <ccfee0a32656a9b081cec769b469dea8d184383f.1617885385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
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
index e95d8df0fcdb..8489a7522453 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3771,11 +3771,6 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
-		return -EINVAL;
-	}
-
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -4477,11 +4472,6 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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
2.30.2

