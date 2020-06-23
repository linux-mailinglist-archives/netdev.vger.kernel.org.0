Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A8205971
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387761AbgFWRkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbgFWRgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFA8207E8;
        Tue, 23 Jun 2020 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933771;
        bh=ez4L1fsHzJhgXsyFXp9KSPER2M2z0E/8Xu7wZlzJmzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OROq1rbDilmmCFsQ1d87mB2BKKAcXn9et7DWT3lImLAISnddVXIW3+AIsRxzJt4b2
         31SEXSypS0BKI2T/RwBUC+x3f9B/fX4Fc6AkR+Ykb5wtleMprOmvgidDmzCjQqwVg5
         O4SbsfS/1b5yw5lTAQWKtC+E6Hqn6SR9+6LAkCLE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/24] rocker: fix incorrect error handling in dma_rings_init
Date:   Tue, 23 Jun 2020 13:35:45 -0400
Message-Id: <20200623173559.1355728-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173559.1355728-1-sashal@kernel.org>
References: <20200623173559.1355728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 58d0c864e1a759a15c9df78f50ea5a5c32b3989e ]

In rocker_dma_rings_init, the goto blocks in case of errors
caused by the functions rocker_dma_cmd_ring_waits_alloc() and
rocker_dma_ring_create() are incorrect. The patch fixes the
order consistent with cleanup in rocker_dma_rings_fini().

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 786b158bd3050..5abb3f9684ffd 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -647,10 +647,10 @@ static int rocker_dma_rings_init(struct rocker *rocker)
 err_dma_event_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker->event_ring);
 err_dma_event_ring_create:
+	rocker_dma_cmd_ring_waits_free(rocker);
+err_dma_cmd_ring_waits_alloc:
 	rocker_dma_ring_bufs_free(rocker, &rocker->cmd_ring,
 				  PCI_DMA_BIDIRECTIONAL);
-err_dma_cmd_ring_waits_alloc:
-	rocker_dma_cmd_ring_waits_free(rocker);
 err_dma_cmd_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker->cmd_ring);
 	return err;
-- 
2.25.1

