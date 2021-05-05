Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7816A3742BD
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhEEQr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhEEQpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A2B561937;
        Wed,  5 May 2021 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232588;
        bh=lmCl/8+UbLLfBdAII2ABQDwTMsu3Sc1/051k2dkBo2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbvysId1i2HEeHF4+tRky0UtiVG9j9nbrcJxLEAzYPxZeg7bA6/NuTm2gy1BPsRR0
         6kJ51e7rqk2wqw3zCXTS08vcvJ3mdXNG6mvN53xiFq5gehEuBSx0h3j8L8QnFsgBB4
         2aFPAui/UFiIVNC0L+KcFlJ8TKkPFv3TpgYGFKeA16JLLUypX25C1volR+tS5QySnZ
         8u1EMBmy2Kv0FvhGeWcF3544WqnZRGXOo3Mn6E/fWOvF0gpSk4bsgqzR7L9Z4dhbsR
         RUTYHj/fjZMtoyjvOSTY0DrjmO/YnpH6/FGmj6shYKy8GkzPMtaeK0LxBxeYKxDw72
         rqnN+74HfUA7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Gibson <leegib@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 092/104] qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth
Date:   Wed,  5 May 2021 12:34:01 -0400
Message-Id: <20210505163413.3461611-92-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lee Gibson <leegib@gmail.com>

[ Upstream commit 130f634da1af649205f4a3dd86cbe5c126b57914 ]

Function qtnf_event_handle_external_auth calls memcpy without
checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210419145842.345787-1-leegib@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index c775c177933b..8dc80574d08d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -570,8 +570,10 @@ qtnf_event_handle_external_auth(struct qtnf_vif *vif,
 		return 0;
 
 	if (ev->ssid_len) {
-		memcpy(auth.ssid.ssid, ev->ssid, ev->ssid_len);
-		auth.ssid.ssid_len = ev->ssid_len;
+		int len = clamp_val(ev->ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		memcpy(auth.ssid.ssid, ev->ssid, len);
+		auth.ssid.ssid_len = len;
 	}
 
 	auth.key_mgmt_suite = le32_to_cpu(ev->akm_suite);
-- 
2.30.2

