Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E991544A133
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbhKIBIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239393AbhKIBGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:06:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9D1561A2E;
        Tue,  9 Nov 2021 01:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419766;
        bh=2hvDv9wxZ+0b1dQ9oTl3HLQSryXIL1L4jzgyRKntOls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O786A43a4BfFfANlmCv8PvZpgLxNG1rdbsjwKiW08roW4iHd7IR3lnVvfwEms1k5h
         mLGid1OJHq9b6TK08RGh9LOa6llThN95Hue0Mur6+GaH30IZSony+9J9GkwuAuqJiV
         zz6jsBH6RpLg+AvbpZR2adyAF3M6faq0yHBWpOjyGU0CDKj5Kx0+8OGOpqbdv6QrbQ
         zQXVfGuSYlAxDE1g/AXrimrX2DkuZB/HwAyR0C1g4a51XrKesRRupUrawOTHrivzwK
         2aq1RgksvfJ5aqTKXTuK6qecmFUDkJuVTUx1+pAlw3JyNuZd6bVNv3nC4+G6S6rkAO
         cHXRrI3+zNpig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 031/138] ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED
Date:   Mon,  8 Nov 2021 12:44:57 -0500
Message-Id: <20211108174644.1187889-31-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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
index fa27115483c6c..72da1283f2ccb 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -6313,6 +6313,8 @@ static void ath11k_scan_event(struct ath11k_base *ab, struct sk_buff *skb)
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

