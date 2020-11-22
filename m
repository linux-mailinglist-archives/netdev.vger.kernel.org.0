Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF072BC785
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 18:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgKVRjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 12:39:48 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:26544 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgKVRjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 12:39:47 -0500
Received: from localhost.localdomain ([81.185.166.181])
        by mwinf5d28 with ME
        id vVfh2300G3v9GFD03Vfi75; Sun, 22 Nov 2020 18:39:43 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Nov 2020 18:39:43 +0100
X-ME-IP: 81.185.166.181
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        gseset@codeaurora.org, mkenna@codeaurora.org,
        slakkavalli@datto.com, gsamin@codeaurora.org,
        pradeepc@codeaurora.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath11k: Fix an error handling path
Date:   Sun, 22 Nov 2020 18:39:43 +0100
Message-Id: <20201122173943.1366167-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'kzalloc' fails, we must return an error code.

While at it, remove a useless initialization of 'err' which could hide the
issue.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index c2b165158225..99a88ca83dea 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1585,15 +1585,17 @@ static int ath11k_qmi_fw_ind_register_send(struct ath11k_base *ab)
 	struct qmi_wlanfw_ind_register_resp_msg_v01 *resp;
 	struct qmi_handle *handle = &ab->qmi.handle;
 	struct qmi_txn txn;
-	int ret = 0;
+	int ret;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
 	resp = kzalloc(sizeof(*resp), GFP_KERNEL);
-	if (!resp)
+	if (!resp) {
+		ret = -ENOMEM;
 		goto resp_out;
+	}
 
 	req->client_id_valid = 1;
 	req->client_id = QMI_WLANFW_CLIENT_ID;
-- 
2.27.0

