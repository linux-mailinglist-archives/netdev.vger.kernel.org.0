Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8CF3DEEB7
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbhHCNFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:05:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235975AbhHCNFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 09:05:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A3A560FC2;
        Tue,  3 Aug 2021 13:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627995936;
        bh=NGAJNeM/mqhj9ZJSxeWUnRZrs6SfmuBgq/fZ6D0LlVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7ybBoYngYmPWl5Nsbe/aBDY8tQfrUOxhA8BZ4KBHyxWbBIIm0k7kPD7QngkGRlh7
         WyZDSf7yaglGvcNqoM+iwlcBPkn2N3dz3EjoHLkzQ4mcMQIDPEetAJ6cATT0Et3Fnt
         zhvnSj9t5HwCye7O+f1ZgZdNHCjx1lN4tvy/EU4fWvRTSjK5GQVZ+SnIkAWn/buMbH
         U4E5cVWfj/98wSOqMnXbzJ08VNjtsvSNac0NKOuDLqlZ2sdxEXTGuYhPhSXAbfwlMZ
         xfq1no4oEbzCQnHrHPYYXe8vousi70ItCXwjzvA0cVBWEO0QDKZDa/7lVVVrZUbRyf
         r+IOWR5YLFeEQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, simon.horman@corigine.com,
        alexanderduyck@fb.com, oss-drivers@corigine.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] nfp: use netif_set_real_num_queues()
Date:   Tue,  3 Aug 2021 06:05:27 -0700
Message-Id: <20210803130527.2411250-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803130527.2411250-1-kuba@kernel.org>
References: <20210803130527.2411250-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid reconfig problems due to failures in netif_set_real_num_tx_queues()
by using netif_set_real_num_queues().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 15078f9dc9f1..5bfa22accf2c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3281,17 +3281,12 @@ static int nfp_net_dp_swap_enable(struct nfp_net *nn, struct nfp_net_dp *dp)
 	for (r = 0; r <	nn->max_r_vecs; r++)
 		nfp_net_vector_assign_rings(&nn->dp, &nn->r_vecs[r], r);
 
-	err = netif_set_real_num_rx_queues(nn->dp.netdev, nn->dp.num_rx_rings);
+	err = netif_set_real_num_queues(nn->dp.netdev,
+					nn->dp.num_stack_tx_rings,
+					nn->dp.num_rx_rings);
 	if (err)
 		return err;
 
-	if (nn->dp.netdev->real_num_tx_queues != nn->dp.num_stack_tx_rings) {
-		err = netif_set_real_num_tx_queues(nn->dp.netdev,
-						   nn->dp.num_stack_tx_rings);
-		if (err)
-			return err;
-	}
-
 	return nfp_net_set_config_and_enable(nn);
 }
 
-- 
2.31.1

