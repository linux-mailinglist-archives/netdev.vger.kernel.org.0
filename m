Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3922DA41D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 00:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbgLNXZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 18:25:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40559 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbgLNXZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 18:25:07 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1koxCT-0002DV-Rd; Mon, 14 Dec 2020 23:24:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: add missing null check on allocated skb
Date:   Mon, 14 Dec 2020 23:24:17 +0000
Message-Id: <20201214232417.84556-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the null check on a newly allocated skb is missing and
this can lead to a null pointer dereference is the allocation fails.
Fix this by adding a null check and returning -ENOMEM.

Addresses-Coverity: ("Dereference null return")
Fixes: 43ed15e1ee01 ("ath11k: put hw to DBS using WMI_PDEV_SET_HW_MODE_CMDID")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index da4b546b62cb..c869ff479212 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3460,6 +3460,8 @@ int ath11k_wmi_set_hw_mode(struct ath11k_base *ab,
 	len = sizeof(*cmd);
 
 	skb = ath11k_wmi_alloc_skb(wmi_ab, len);
+	if (!skb)
+		return -ENOMEM;
 	cmd = (struct wmi_pdev_set_hw_mode_cmd_param *)skb->data;
 
 	cmd->tlv_header = FIELD_PREP(WMI_TLV_TAG, WMI_TAG_PDEV_SET_HW_MODE_CMD) |
-- 
2.29.2

