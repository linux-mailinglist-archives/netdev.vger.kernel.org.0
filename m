Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8910207F1D
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389702AbgFXWGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:06:21 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37289 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389453AbgFXWGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 18:06:19 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 21483d94;
        Wed, 24 Jun 2020 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=PMSW1JxYMnQhk8qd60Y9kOgVp
        eM=; b=fIQ1mC3JvgjY9VSaMhXmHUV/x6zWN8RCPRM99WCTZRw4KZdCNuJAt0YJq
        i4hzHZ4C3giwOSudSZOotsyoVmi57FpEZCymmrqp11smg5AwPSLe1uI+D0Rzfvq4
        Zxlmkdw/b3c82Az5rcBmdEuyh8Dayk5LTnguC2EEGfSPiGPybyOkQK4iSKtKRS/6
        qaVmcJvAd/65icLDLpVGEOgOvZrEBWY3w9F1+yYuoTmdTc+pQDyxGAYI1K3lpvDM
        A2nD6zPUKS0tgNVka6RZyCgn2W4TrqQOhTV+6N6TkY3bm8u4Ls03CGUcLBWoQOXH
        7mL/aID0K4zyqB8S6pCfWYiQfEm1w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 557d7f39 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 21:47:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/4] hns: do not cast return value of napi_gro_receive to null
Date:   Wed, 24 Jun 2020 16:06:05 -0600
Message-Id: <20200624220606.1390542-4-Jason@zx2c4.com>
In-Reply-To: <20200624220606.1390542-1-Jason@zx2c4.com>
References: <20200624220606.1390542-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically no drivers care about the return value here, and there's no
__must_check that would make casting to void sensible, so remove it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index c117074c16e3..23f278e46975 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -699,7 +699,7 @@ static void hns_nic_rx_up_pro(struct hns_nic_ring_data *ring_data,
 	struct net_device *ndev = ring_data->napi.dev;
 
 	skb->protocol = eth_type_trans(skb, ndev);
-	(void)napi_gro_receive(&ring_data->napi, skb);
+	napi_gro_receive(&ring_data->napi, skb);
 }
 
 static int hns_desc_unused(struct hnae_ring *ring)
-- 
2.27.0

