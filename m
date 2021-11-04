Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8814458A3
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhKDRjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:39:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233921AbhKDRjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6742661168;
        Thu,  4 Nov 2021 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047399;
        bh=qY5DdSZWv4jcXWcIIMXiqwGuB+uIsQT0vjsVJj4CKFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTS+Ea/dslobVrr3gciNUnmej92Wz1HOe1LmDy2zpJb0KzObno9d2OKHe28HqkwdU
         QPbb8WfSf7NsHO8oKmGk8S2GExVxlUps2siBUl3OVDU1K8JXZw0c+gzx5CoBTQn7I+
         GPtk0IgOVt0BAZ1q7Qt1leVIB33WoA3vmCc9lu4jQKmk41eHpKxbGD1HBOZBEcAuRe
         vMdPxoC6CvL1mxA1N8PiZoMYhdNzcbYQw8WJtj7+gw9aSSkZ011uGRpgWE9Au9+gZz
         1V9NLRZDpGdr7kVKk0Thv4TQPrg1j+E7vp+S6C5kBvJ/MQg7XWewrOOLTnt6ve4QUo
         jc5RyyJhtuLiQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 10/23] net: mvneta: enable jumbo frames if the loaded XDP program support mb
Date:   Thu,  4 Nov 2021 18:35:30 +0100
Message-Id: <a09cdc585b574145e44634250a33138215fa5727.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode if the loaded program declare to properly support
xdp multi-buff. At same time reject a xdp program not supporting xdp
multi-buffer if the driver is running in xdp multi-buffer mode.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 8842c9c8c665..8b26d733b3cd 100644
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
 
@@ -4457,8 +4461,9 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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
2.31.1

