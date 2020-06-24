Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D1C207F1B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389395AbgFXWGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:06:18 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37289 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388749AbgFXWGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 18:06:17 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c59dc5be;
        Wed, 24 Jun 2020 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=k6TDfchJl1xwN8eYnLY7MdqX7
        ZE=; b=h8d4+PidyauR4fEn6UYPApJO4nHTDiWptKTF5H5VXPs6YxmY+7dOTmB3V
        PL7k6aKGh+qurZhShm+Y04Btga8HVYdM1AksqjEI2iS9Lm4HsnATaW//rZfSVVlY
        H3dCakpirhojaYvNldrpSVMa2QFZcbzoX5sugHFaCNYaMzzHnx20Ywu4a8dVkeoQ
        IwbFy+vhP+nRbPMMTOGSIF8CPh9g2IqDT+TjWqcc9WaccZRFgWBBuzLPKzfjr4ZA
        Xnq1rsk8ghfYvlrprfUhTZZcAZOgB3NAhID4rE/47QkarJNDO+G9+XaDlmtRHzb0
        lbO/sj/KW6+S0ocw+1WTyUCHCRXrw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cfe6519e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 21:47:10 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/4] wireguard: receive: account for napi_gro_receive never returning GRO_DROP
Date:   Wed, 24 Jun 2020 16:06:03 -0600
Message-Id: <20200624220606.1390542-2-Jason@zx2c4.com>
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

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Fixes: 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 91438144e4f7..9b2ab6fc91cd 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -414,14 +414,8 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	if (unlikely(routed_peer != peer))
 		goto dishonest_packet_peer;
 
-	if (unlikely(napi_gro_receive(&peer->napi, skb) == GRO_DROP)) {
-		++dev->stats.rx_dropped;
-		net_dbg_ratelimited("%s: Failed to give packet to userspace from peer %llu (%pISpfsc)\n",
-				    dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
-	} else {
-		update_rx_stats(peer, message_data_len(len_before_trim));
-	}
+	napi_gro_receive(&peer->napi, skb);
+	update_rx_stats(peer, message_data_len(len_before_trim));
 	return;
 
 dishonest_packet_peer:
-- 
2.27.0

