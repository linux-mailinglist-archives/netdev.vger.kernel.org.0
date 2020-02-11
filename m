Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8C7159274
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgBKPBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:01:02 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:01:02 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d8214ce4;
        Tue, 11 Feb 2020 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=ShufVLUsTcLwh/Zol/iMuQa/w
        RI=; b=DCRA4EKfbNe7DCa8OMo8rblwvizcUlR0wHVnUMYp8HKPGQ5dC029N1ucL
        +TttHpARLKROH80DIANivltvHQ/vVXyqlt9bZiLjd6EabDSVXHvEnMT7dK77Yp+A
        544pWhKTwH0Q7dR/cxyykFAMsx/ri3dbgbowWzQD+0+9FioI0uCT5uiZfq7yZnXW
        +YZPO2nVzI+7IDQkxlGHEKuYUGtSmlSvwD7EKc+4K5F7ufdc1Jbj83pNrt72dIFv
        ZhT97bPpNzvR2OQm2p8v0mdWH5cUIxpaMb+k008dFBnrdaOhI1+BlEioJdHPKGjr
        d6fc4vkUYwd5kWHHuTxSnt92o8DRA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00f3ff0b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:15 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v3 net 8/9] fm10k: remove skb_share_check from xmit path
Date:   Tue, 11 Feb 2020 16:00:27 +0100
Message-Id: <20200211150028.688073-9-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an impossible condition to reach; an skb in ndo_start_xmit won't
be shared by definition.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Link: https://lore.kernel.org/netdev/CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com/
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 0637ccadee79..b6cd7ab6efbe 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -641,11 +641,6 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *skb, struct net_device *dev)
 		struct vlan_hdr *vhdr;
 		__be16 proto;
 
-		/* make sure skb is not shared */
-		skb = skb_share_check(skb, GFP_ATOMIC);
-		if (!skb)
-			return NETDEV_TX_OK;
-
 		/* make sure there is enough room to move the ethernet header */
 		if (unlikely(!pskb_may_pull(skb, VLAN_ETH_HLEN)))
 			return NETDEV_TX_OK;
-- 
2.25.0

