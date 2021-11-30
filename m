Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DF4463382
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhK3L6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbhK3L55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:57:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC7CC061574;
        Tue, 30 Nov 2021 03:54:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 088AECE18C0;
        Tue, 30 Nov 2021 11:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEAAC53FCD;
        Tue, 30 Nov 2021 11:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273274;
        bh=kgQpFNfVEwTnn2+i68hOq+RLghJ35I+l77aHHuWJ/cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUxuzBwvTWztPEj0SR+N6A3O59Q2jtpiPip4/DJHNgc4GKNRLshEogpFh5EqKATpt
         4rFyYSL4AXwYAat6TR78SYhhKQd+/5KGwTvM5XbIDVjqN5x29sXXPsJyZjuDJ1jftZ
         xxbCHWwKpR/CzwJDVkzL2fEBWnxWvaqB3BE3dfCzX9d9l/lm2bv/90J5WdO4hKAqjz
         kbUxQaygzIDTZ3FU+eH+IjlIpL8nrrlrNr9/J7jjhRiay5RllRzOdWcv33iNNimDR5
         O+yclXlzohfdEI4bST+XrSow6ss6lieyQdv6zJWIOO1A2BdJY0AGIhvb+t6mMGq/Uo
         W1TmNmXcwXM3g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 10/23] net: mvneta: enable jumbo frames if the loaded XDP program support mb
Date:   Tue, 30 Nov 2021 12:52:54 +0100
Message-Id: <47932365c53acbf359c26944f0bec363928d342f.1638272238.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
2.31.1

