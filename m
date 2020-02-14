Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8405115EF55
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbgBNQB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389195AbgBNQBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:01:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52EBE2082F;
        Fri, 14 Feb 2020 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696114;
        bh=ySzhj8c70C8x5NMMk9F+nbbW1KMpZZRpt6qN/z686dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjjmxWS0WM+UDHCKvFJyuJWQ8lJLarjIXji39xY9CHGIcGCctAP7/iYXv9bTEdupT
         EbYAVgHq1zSjnQ3uUASpMMlO3CUtxEPraM4un+hV/A75ZAtp4YpO77SGhzFPNX6ln+
         ydk0Vikj5xFW2j7hkWB3Idok35CL7QpLFdZ6p0VI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 003/459] ath10k: Fix qmi init error handling
Date:   Fri, 14 Feb 2020 10:54:13 -0500
Message-Id: <20200214160149.11681-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit f8a595a87e93a33a10879f4b856be818d2f53c84 ]

When ath10k_qmi_init() fails, the error handling does not free the irq
resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
(re-)register irqs which are already registered.

Fix this by doing a power off since we just powered on the hardware, and
freeing the irqs as error handling.

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index fc15a0037f0e6..63607c3b8e818 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1729,13 +1729,16 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	ret = ath10k_qmi_init(ar, msa_size);
 	if (ret) {
 		ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
-		goto err_core_destroy;
+		goto err_power_off;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
 
 	return 0;
 
+err_power_off:
+	ath10k_hw_power_off(ar);
+
 err_free_irq:
 	ath10k_snoc_free_irq(ar);
 
-- 
2.20.1

