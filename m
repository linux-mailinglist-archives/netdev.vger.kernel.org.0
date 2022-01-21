Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88AD495D64
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379895AbiAUKLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:11:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35366 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379928AbiAUKL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:11:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC9AC61A0C;
        Fri, 21 Jan 2022 10:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E943C340E2;
        Fri, 21 Jan 2022 10:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759885;
        bh=nZiSoy8kR5WsaUy4n5sZKEgIpzHuClFsB4fuWmFCQME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuppkCj2MRR4Hld08gdtzaf7J1d7lMpNEINJzROWe3dcaQtM2bjwa7H4Ne98E9YOA
         okiHdOG/wP1Vz/toB6VHElsp2hdiQQkS2dIoWHIE58JyMQ326pIbDgB6JS7ti9wS5D
         LPwR1lcz/1b0vhvtKyW5YqrNbLsb5JEUE1dDSjXQqCi2ody0XARNrnaONX+GLW41d+
         Vjfr+K2VSADRS6iDzm0ZY05YKDiuWqHIQiYEzseKAU32AmcX0lnP5uC7cj5gZIccU3
         G0RmHWT4zoBbq3M0FX0lIuYexTwejikL+xMI9ID2La6usy14A9mOdCjv+6Zols2PQc
         Sh6G1SczPjtlQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 10/23] net: mvneta: enable jumbo frames if the loaded XDP program support frags
Date:   Fri, 21 Jan 2022 11:09:53 +0100
Message-Id: <6909f81a3cbb8fb6b88e914752c26395771b882a.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the capability to receive jumbo frames even if the interface is
running in XDP mode if the loaded program declare to properly support
xdp frags. At same time reject a xdp program not supporting xdp frags
if the driver is running in xdp frags mode.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c2248e23edcc..1ba49e464f36 100644
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
+	if (prog && !prog->aux->xdp_has_frags &&
+	    mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		netdev_info(dev, "Illegal MTU %d for XDP prog without frags\n",
+			    mtu);
+
 		return -EINVAL;
 	}
 
@@ -4528,8 +4532,9 @@ static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct bpf_prog *old_prog;
 
-	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
-		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+	if (prog && !prog->aux->xdp_has_frags &&
+	    dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(extack, "prog does not support XDP frags");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.34.1

