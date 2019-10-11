Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1371BD41B6
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfJKNpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbfJKNpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:45:49 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B79F8214AF;
        Fri, 11 Oct 2019 13:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570801548;
        bh=t3N/zb2nVp5R6SC85ixIbYWMZVnTHT/MT2ybJbe+qCE=;
        h=From:To:Cc:Subject:Date:From;
        b=zP4WtRG6NYRGfdUvPX8MR1wRL+MpAWPQqc6d0d2sg4gFm8ihI6Nmvt0O3laA1pjNl
         c6Da5b+O/MuPttQ3KylOSXH6DhB9xEiFbJ68ZHmNDzZypp+6AqrHzUejwz2HnQQCv4
         Mb5Gdu0GToHXkWztmvp7SNwCDMmPPhjQL7wlBYDE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ilias.apalodimas@linaro.org
Subject: [PATCH net] net: socionext: netsec: fix xdp stats accounting
Date:   Fri, 11 Oct 2019 15:45:38 +0200
Message-Id: <40c5519a86f2c611de84661a9d1e136bda2cd78e.1570801159.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increment netdev rx counters even for XDP_DROP verdict. Moreover report
even tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or
TYPE_NETSEC_XDP_NDO)

Fixes: ba2b232108d3 ("net: netsec: add XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
just compiled not tested on a real device
---
 drivers/net/ethernet/socionext/netsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f9e6744d8fd6..b1c2a79899b3 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -252,7 +252,6 @@
 #define NETSEC_XDP_CONSUMED      BIT(0)
 #define NETSEC_XDP_TX            BIT(1)
 #define NETSEC_XDP_REDIR         BIT(2)
-#define NETSEC_XDP_RX_OK (NETSEC_XDP_PASS | NETSEC_XDP_TX | NETSEC_XDP_REDIR)
 
 enum ring_id {
 	NETSEC_RING_TX = 0,
@@ -661,6 +660,7 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 			bytes += desc->skb->len;
 			dev_kfree_skb(desc->skb);
 		} else {
+			bytes += desc->xdpf->len;
 			xdp_return_frame(desc->xdpf);
 		}
 next:
@@ -1030,7 +1030,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 next:
 		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
-		    xdp_result & NETSEC_XDP_RX_OK) {
+		    xdp_result) {
 			ndev->stats.rx_packets++;
 			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
 		}
-- 
2.21.0

