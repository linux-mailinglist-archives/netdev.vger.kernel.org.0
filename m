Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CB02059B6
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbgFWRfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733241AbgFWRfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A324D20774;
        Tue, 23 Jun 2020 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933738;
        bh=boPdYnru8phemdGqCpuKpNL84NgVCqhwYi4yrMm6mGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zygpxxubmAS/JNt9Uf/0e5UgTGtZxLtsQ7frgKbHGPxTk7/ezuq6PraaYznRSTyh5
         Ion/J8Z7EWrihXpVUflyPQph6kHYVBgNTDXtDFu3XOaYBX//b8uJvT81NOi1xnwWeK
         rKvGklVLG4pOLFWpt4cpv0+K80kdsLwHQ37V2tM8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 12/28] mvpp2: ethtool rxtx stats fix
Date:   Tue, 23 Jun 2020 13:35:07 -0400
Message-Id: <20200623173523.1355411-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

[ Upstream commit cc970925feb9a38c2f0d34305518e00a3084ce85 ]

The ethtool rx and tx queue statistics are reporting wrong values.
Fix reading out the correct ones.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2b5dad2ec650c..5d4ec95be8691 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1544,7 +1544,7 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 	for (q = 0; q < port->ntxqs; q++)
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_txq_regs); i++)
 			*pstats++ += mvpp2_read_index(port->priv,
-						      MVPP22_CTRS_TX_CTR(port->id, i),
+						      MVPP22_CTRS_TX_CTR(port->id, q),
 						      mvpp2_ethtool_txq_regs[i].offset);
 
 	/* Rxqs are numbered from 0 from the user standpoint, but not from the
@@ -1553,7 +1553,7 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 	for (q = 0; q < port->nrxqs; q++)
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_rxq_regs); i++)
 			*pstats++ += mvpp2_read_index(port->priv,
-						      port->first_rxq + i,
+						      port->first_rxq + q,
 						      mvpp2_ethtool_rxq_regs[i].offset);
 }
 
-- 
2.25.1

