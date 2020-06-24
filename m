Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358CA207F1C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389594AbgFXWGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:06:20 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37289 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389299AbgFXWGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 18:06:18 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id aab2e22f;
        Wed, 24 Jun 2020 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=KJFj0AvgPuSYF9k38/rwChLnu
        Yg=; b=j6zftUIKiGwR4G8Jq1wwk0xC2iXWipAY0vJqhD4aBN8qcWYFm3n78EsDE
        DVJjSYfw/1u7piveM3263JU48IvruOr8TmyTcnXLvK/hbd5Rn7kLbjr/Grj9nLrQ
        lHJGc9kX7qm0TF7JePJ6BK1pDvAI/ZGUZ9OFpAh24zMEEIucRierOGRXQrr3mXMD
        j3Agk9yZLbl9fnbUt/VCwu5+mGjJfAZPUaRDbaOvo833nJLmmu+RN4ZahFZ6cmVf
        7QQtJlUqaRsNy3xPqNN83Y9HMw2LppTTk+xpYnsnBVXTAuexw4jweEVySxFi+CAT
        q1wGqtStbBtq6ayxyxvtMGphU0G9Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 39b7a5a4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 21:47:12 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/4] socionext: account for napi_gro_receive never returning GRO_DROP
Date:   Wed, 24 Jun 2020 16:06:04 -0600
Message-Id: <20200624220606.1390542-3-Jason@zx2c4.com>
In-Reply-To: <20200624220606.1390542-1-Jason@zx2c4.com>
References: <20200624220606.1390542-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_gro_receive function no longer returns GRO_DROP ever, making
handling GRO_DROP dead code. This commit removes that dead code.
Further, it's not even clear that device drivers have any business in
taking action after passing off received packets; that's arguably out of
their hands.

Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/ethernet/socionext/netsec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 328bc38848bb..0f366cc50b74 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1044,8 +1044,9 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 next:
-		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
-		    xdp_result) {
+		if (skb)
+			napi_gro_receive(&priv->napi, skb);
+		if (skb || xdp_result) {
 			ndev->stats.rx_packets++;
 			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
 		}
-- 
2.27.0

