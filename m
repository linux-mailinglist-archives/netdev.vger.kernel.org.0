Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10E9F4A72
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391926AbfKHMJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388519AbfKHLkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B91D321D7F;
        Fri,  8 Nov 2019 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213211;
        bh=e6m2D9GsLTb/2SC3kjO+2tBWWWAaE8pBWyaHznMx5kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNVFxTDeFTQayrAGyXVaoWCYBium5U7HCQaNG9QUvvKhicK0+QWXlAKTiSFLI/P/d
         0R571ACA0kFLRVltjBe2eoys3XCZ2CgAQiZRnHhNJeZJM97K9oNEBH52R3V775sutb
         sPfWCiy9aG+iB/sdEVEs+PWsB6+Mxwlz2eFtLU4w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "K.T.VIJAYAKUMAAR" <vijay.bvb@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 092/205] ath10k: avoid possible memory access violation
Date:   Fri,  8 Nov 2019 06:35:59 -0500
Message-Id: <20191108113752.12502-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "K.T.VIJAYAKUMAAR" <vijay.bvb@samsung.com>

[ Upstream commit 97c69a70dc2cecb2c3b96a66529e0082dabc2d2c ]

array "ctl_power_table" access index "pream" is initialized with -1 and
is raised as a static analysis tool issue.
[drivers\net\wireless\ath\ath10k\wmi.c:4719] ->
[drivers\net\wireless\ath\ath10k\wmi.c:4730]: (error) Array index -1 is
out of bounds.

Since the "pream" index for accessing ctl_power_table array is initialized
with -1, there is a chance of memory access violation for the cases below.
1) wmi_pdev_tpc_final_table_event change frequency is between 2483 and 5180
2) pream_idx is out of the enumeration ranges of wmi_tpc_pream_2ghz,
wmi_tpc_pream_5ghz

Signed-off-by: K.T.VIJAYAKUMAAR <vijay.bvb@samsung.com>
[kvalo@codeaurora.org: clean up the warning message]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9f31b9a108507..583147f00fa4e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4785,6 +4785,13 @@ ath10k_wmi_tpc_final_get_rate(struct ath10k *ar,
 		}
 	}
 
+	if (pream == -1) {
+		ath10k_warn(ar, "unknown wmi tpc final index and frequency: %u, %u\n",
+			    pream_idx, __le32_to_cpu(ev->chan_freq));
+		tpc = 0;
+		goto out;
+	}
+
 	if (pream == 4)
 		tpc = min_t(u8, ev->rates_array[rate_idx],
 			    ev->max_reg_allow_pow[ch]);
-- 
2.20.1

