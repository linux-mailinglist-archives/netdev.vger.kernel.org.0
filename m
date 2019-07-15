Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3751869082
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390576AbfGOOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389980AbfGOOWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:22:14 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC13721537;
        Mon, 15 Jul 2019 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200533;
        bh=pmy5RsvSnntt88as8HVTsqIhOyEpxosL3yqLQzs25Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saB9OzN12PJNfF6PbM2bwnFgSsNNki1RMYVznlWUsbSaP/xzDicFWEyHIStK0SdSo
         6/3Hs+3R0Qb65uZL/+xm8+Sj+44KVpE2E2/0ulWn8EjBDjzhYrBI35i5QIjRV2Ufsl
         RTm1nlDN7A5qJOx1UDxC7QHncQDvwunYvNvD7ID4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 069/158] qed: iWARP - Fix tc for MPA ll2 connection
Date:   Mon, 15 Jul 2019 10:16:40 -0400
Message-Id: <20190715141809.8445-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit cb94d52b93c74fe1f2595734fabeda9f8ae891ee ]

The driver needs to assign a lossless traffic class for the MPA ll2
connection to ensure no packets are dropped when returning from the
driver as they will never be re-transmitted by the peer.

Fixes: ae3488ff37dc ("qed: Add ll2 connection for processing unaligned MPA packets")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index b7471e48db7b..7002a660b6b4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2709,6 +2709,8 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	data.input.rx_num_desc = n_ooo_bufs * 2;
 	data.input.tx_num_desc = data.input.rx_num_desc;
 	data.input.tx_max_bds_per_packet = QED_IWARP_MAX_BDS_PER_FPDU;
+	data.input.tx_tc = PKT_LB_TC;
+	data.input.tx_dest = QED_LL2_TX_DEST_LB;
 	data.p_connection_handle = &iwarp_info->ll2_mpa_handle;
 	data.input.secondary_queue = true;
 	data.cbs = &cbs;
-- 
2.20.1

