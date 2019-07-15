Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01404695E3
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389354AbfGOOOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389338AbfGOOOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:14:25 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8163206B8;
        Mon, 15 Jul 2019 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200065;
        bh=JTd+nvtYMDH2bpBgUYGzSZ3B/HMdCsAQwzi9WqHURoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnbJNYqqaqh6PsOz/ak85W1bT6mfkaVpetkBD/yrZETvv9pvVxcpxvHdeTh59sSfY
         Pvi/C7F54VUY8u6pn/6/0S/HrvOVTPRvv9tBOo8iWEIvRfsh4Aqvayw6qwgHfTU29F
         +qa7qB9Nh6O4/AMbO1tzFUvY4zSSzdD3PwYjUKTo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dundi Raviteja <dundi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 175/219] ath10k: Fix memory leak in qmi
Date:   Mon, 15 Jul 2019 10:02:56 -0400
Message-Id: <20190715140341.6443-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dundi Raviteja <dundi@codeaurora.org>

[ Upstream commit c709df58832c5f575f0255bea4b09ad477fc62ea ]

Currently the memory allocated for qmi handle is
not being freed during de-init which leads to memory leak.

Free the allocated qmi memory in qmi deinit
to avoid memory leak.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Fixes: fda6fee0001e ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Dundi Raviteja <dundi@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index a7bc2c70d076..8f8f717a23ee 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1002,6 +1002,7 @@ int ath10k_qmi_deinit(struct ath10k *ar)
 	qmi_handle_release(&qmi->qmi_hdl);
 	cancel_work_sync(&qmi->event_work);
 	destroy_workqueue(qmi->event_wq);
+	kfree(qmi);
 	ar_snoc->qmi = NULL;
 
 	return 0;
-- 
2.20.1

