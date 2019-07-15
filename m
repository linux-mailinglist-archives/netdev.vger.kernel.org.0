Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBEF69000
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389896AbfGOOSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389871AbfGOOSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:18:23 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8954F2083D;
        Mon, 15 Jul 2019 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200302;
        bh=BpLbiFJmhWX7EEHeCpBV5nqlV3YJ8uX8UyP+7CTuPpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A32S7HYaEBCx+BjaLK+dGllVEnSAiJb9Q6nh8vwTjbe0A/qCZXDDVYyZHK/iicCD1
         YDQWpb6Dznm2zXC6cW9oWFp8I8a/V17OhHBlEcW37N6SxuNoDSa34U7t202KLveTp3
         UJsJvVPrSgC0/OTRrbq9NnEfBhfHOnD/bI+ofI7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/158] ath6kl: add some bounds checking
Date:   Mon, 15 Jul 2019 10:15:35 -0400
Message-Id: <20190715141809.8445-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5d6751eaff672ea77642e74e92e6c0ac7f9709ab ]

The "ev->traffic_class" and "reply->ac" variables come from the network
and they're used as an offset into the wmi->stream_exist_for_ac[] array.
Those variables are u8 so they can be 0-255 but the stream_exist_for_ac[]
array only has WMM_NUM_AC (4) elements.  We need to add a couple bounds
checks to prevent array overflows.

I also modified one existing check from "if (traffic_class > 3) {" to
"if (traffic_class >= WMM_NUM_AC) {" just to make them all consistent.

Fixes: bdcd81707973 (" Add ath6kl cleaned up driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 777acc564ac9..bc7916f2add0 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1178,6 +1178,10 @@ static int ath6kl_wmi_pstream_timeout_event_rx(struct wmi *wmi, u8 *datap,
 		return -EINVAL;
 
 	ev = (struct wmi_pstream_timeout_event *) datap;
+	if (ev->traffic_class >= WMM_NUM_AC) {
+		ath6kl_err("invalid traffic class: %d\n", ev->traffic_class);
+		return -EINVAL;
+	}
 
 	/*
 	 * When the pstream (fat pipe == AC) timesout, it means there were
@@ -1519,6 +1523,10 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 		return -EINVAL;
 
 	reply = (struct wmi_cac_event *) datap;
+	if (reply->ac >= WMM_NUM_AC) {
+		ath6kl_err("invalid AC: %d\n", reply->ac);
+		return -EINVAL;
+	}
 
 	if ((reply->cac_indication == CAC_INDICATION_ADMISSION_RESP) &&
 	    (reply->status_code != IEEE80211_TSPEC_STATUS_ADMISS_ACCEPTED)) {
@@ -2635,7 +2643,7 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
 	u16 active_tsids = 0;
 	int ret;
 
-	if (traffic_class > 3) {
+	if (traffic_class >= WMM_NUM_AC) {
 		ath6kl_err("invalid traffic class: %d\n", traffic_class);
 		return -EINVAL;
 	}
-- 
2.20.1

