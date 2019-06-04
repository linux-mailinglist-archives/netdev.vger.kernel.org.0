Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCB93543E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfFDXbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfFDXWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C07020B7C;
        Tue,  4 Jun 2019 23:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690569;
        bh=iWSbiFnhIIDjOnuZj9cOzoMDZNfvc7+hkcwYKwJDwXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17/AV3t35NCiU90irG8+4mrObsgBjaN/vSAebZmwq8K4eaJ/phXmxxZysLhDwM3Ht
         dqBkjye1ZUrgx3LFXrrvufQcCy/g1MIXxUkn8yQFvvp3mppTSP5QN/KV8/oMQ8WH/m
         DtSLfVYpLN4WuUrgdDwEUE2T+t61JP8xtknEYwKI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 23/60] enetc: Fix NULL dma address unmap for Tx BD extensions
Date:   Tue,  4 Jun 2019 19:21:33 -0400
Message-Id: <20190604232212.6753-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit f4a0be84d73ec648628bf8094600ceb73cb6073f ]

For the unlikely case of TxBD extensions (i.e. ptp)
the driver tries to unmap the tx_swbd corresponding
to the extension, which is bogus as it has no buffer
attached.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5bb9eb35d76d..491475d87736 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -313,7 +313,9 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
 		bool is_eof = !!tx_swbd->skb;
 
-		enetc_unmap_tx_buff(tx_ring, tx_swbd);
+		if (likely(tx_swbd->dma))
+			enetc_unmap_tx_buff(tx_ring, tx_swbd);
+
 		if (is_eof) {
 			napi_consume_skb(tx_swbd->skb, napi_budget);
 			tx_swbd->skb = NULL;
-- 
2.20.1

