Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140D811965E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfLJV0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729547AbfLJVZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 757E9207FF;
        Tue, 10 Dec 2019 21:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013137;
        bh=TwguYHy5B2a16ohKMwc5Zw/HtcD9V/CMiposwe5BYww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iN88OXThYgWjRaUO9bAro76ikREJcW0RyFM5mY9f/oSuMd0AgAchstMOQfLMRU4Qe
         /7fhAHGQc5z/tlXQCte5L8pLXieZzAShlQdsl4HcxOfffAWfwHB+JiHWrC/azjyQ6M
         VVnyzXNnymlW50z4o4NWr0g+o99gWFOMMNJ8/p/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Allen Pais <allen.pais@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 021/292] libertas: fix a potential NULL pointer dereference
Date:   Tue, 10 Dec 2019 16:20:40 -0500
Message-Id: <20191210212511.11392-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.pais@oracle.com>

[ Upstream commit 7da413a18583baaf35dd4a8eb414fa410367d7f2 ]

alloc_workqueue is not checked for errors and as a result,
a potential NULL dereference could occur.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
index 242d8845da3fa..30f1025ecb9bc 100644
--- a/drivers/net/wireless/marvell/libertas/if_sdio.c
+++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
@@ -1179,6 +1179,10 @@ static int if_sdio_probe(struct sdio_func *func,
 
 	spin_lock_init(&card->lock);
 	card->workqueue = alloc_workqueue("libertas_sdio", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!card->workqueue)) {
+		ret = -ENOMEM;
+		goto err_queue;
+	}
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 	init_waitqueue_head(&card->pwron_waitq);
 
@@ -1230,6 +1234,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	lbs_remove_card(priv);
 free:
 	destroy_workqueue(card->workqueue);
+err_queue:
 	while (card->packets) {
 		packet = card->packets;
 		card->packets = card->packets->next;
-- 
2.20.1

