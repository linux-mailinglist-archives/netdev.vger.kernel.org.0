Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A9426B3E
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbhJHMxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242186AbhJHMxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:53:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7AC60EE5;
        Fri,  8 Oct 2021 12:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633697497;
        bh=3G/RafxqRsoUxzAR8DiopT742KZr2VFh9s76ievytB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUG7XpwXMSKDLPUThHKGjR+HBCKfft8USbsJpq6lxn/O8Q/s43oKHnpMLXpNiFYW3
         TFIYEOnRzbKI2WQ5cj00ysMwqtIheRaIxloFJgxqXcSNnspxVjf7BFThbJT9Tve6Dt
         xFpYceUag4mo3XkJOxudvl6hNnfIhTrNtHVof9A1XU/pq9+1Nx8uJuWszfsrEsQ4+S
         Mi4oWojfPGK7R9mE5LSuG37DkIhyT5EIHBe4/i4VS9W+//WlFnWCVQrR3epOk3xLny
         V43jOA9BZpwAJ1bzVnLu+f5quaQ3Xma5VolylIPBh9L7DilPlG05YIad4pNv+3v2Ap
         /4NEPT55Llvsg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v15 bpf-next 09/18] net: mvneta: enable jumbo frames for XDP
Date:   Fri,  8 Oct 2021 14:49:47 +0200
Message-Id: <9a8997a4d87cb5a2d58765e237b5f3b47b77aecc.1633697183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 26b52ca8b5b6..88e57dfdcf86 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3759,11 +3759,6 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
-		return -EINVAL;
-	}
-
 	dev->mtu = mtu;
 
 	if (!netif_running(dev)) {
@@ -4473,11 +4468,6 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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

