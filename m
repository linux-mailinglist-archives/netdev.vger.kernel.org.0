Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD3544A1A6
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbhKIBLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242014AbhKIBIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9001761A59;
        Tue,  9 Nov 2021 01:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419843;
        bh=bHa5gPhozM+s6vrbsoyeHM3zp4a5PsqgvND0jai6kAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6oAFhob9m48AisTdlKlukU/Cghj0bCNSaXx0LyuVByGmHi28pw0g4e0mIAa8NYgY
         7l3xD7MBG3aYCtXFrvCg+xtB/0YsIQ9Kz4Q4OZW8O6cCYVAWoNwTO+AfOvYDATSdHC
         3gOKDjTD/TuqtEgv6PmOHO0mDJdo0IhPKom1jUqdZvdFOgRImqQFqzGG2Gqmd4FQ88
         PG2nuYBOSisKEXJGX25um2+nnRXfVo7AYWsvvOvGO9KTJ6BqOh3L1GnivDqySNzmHG
         UQD2xepFJYAUBJgzGwgMqZUdz1GLe0mV5K5og1WHE/wuEDwxtgJkrgUwZ6p8P2y/Z9
         4Q36hwb/mXCrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 024/101] ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED
Date:   Mon,  8 Nov 2021 12:47:14 -0500
Message-Id: <20211108174832.1189312-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 441b3b5911f8ead7f2fe2336587b340a33044d58 ]

When wlan interface is up, 11d scan is sent to the firmware, and the
firmware needs to spend couple of seconds to complete the 11d scan. If
immediately a normal scan from user space arrives to ath11k, then the
normal scan request is also sent to the firmware, but the scan started
event will be reported to ath11k until the 11d scan complete. When timed
out for the scan started in ath11k, ath11k stops the normal scan and the
firmware reports WMI_SCAN_EVENT_DEQUEUED to ath11k for the normal scan.
ath11k has no handler for the event and then timed out for the scan
completed in ath11k_scan_stop(), and ath11k prints the following error
message.

[ 1491.604750] ath11k_pci 0000:02:00.0: failed to receive scan abort comple: timed out
[ 1491.604756] ath11k_pci 0000:02:00.0: failed to stop scan: -110
[ 1491.604758] ath11k_pci 0000:02:00.0: failed to start hw scan: -110

Add a handler for WMI_SCAN_EVENT_DEQUEUED and then complete the scan to
get rid of the above error message.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210914164226.38843-1-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 2f777d61f9065..cf0f778b0cbc9 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5856,6 +5856,8 @@ static void ath11k_scan_event(struct ath11k_base *ab, struct sk_buff *skb)
 		ath11k_wmi_event_scan_start_failed(ar);
 		break;
 	case WMI_SCAN_EVENT_DEQUEUED:
+		__ath11k_mac_scan_finish(ar);
+		break;
 	case WMI_SCAN_EVENT_PREEMPTED:
 	case WMI_SCAN_EVENT_RESTARTED:
 	case WMI_SCAN_EVENT_FOREIGN_CHAN_EXIT:
-- 
2.33.0

