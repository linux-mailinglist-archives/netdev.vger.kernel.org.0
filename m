Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39480FA285
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbfKMCCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbfKMCCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06FD204EC;
        Wed, 13 Nov 2019 02:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610532;
        bh=NpbV87MbFdzgksay7uQciuMhgTrAH0Ty1w4P1B34b8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rq+jCFzL3fSxgm9UAsv+Nbx+UaDiyN/HyLEaC8O0ZpbtMlAvJstJpfO4S2wE9lte4
         IYt+iSWCNDk7mkChSUGLDedsf6fsqrlGwXgxA99PEcn+gq55JGd6o6x+g3/LCmJcY5
         sld2i6Os4lfTaiOJK721HxrVrA4lQ4G9cMA8wlVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 24/48] brcmfmac: fix full timeout waiting for action frame on-channel tx
Date:   Tue, 12 Nov 2019 21:01:07 -0500
Message-Id: <20191113020131.13356-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chung-Hsien Hsu <stanley.hsu@cypress.com>

[ Upstream commit fbf07000960d9c8a13fdc17c6de0230d681c7543 ]

The driver sends an action frame down and waits for a completion signal
triggered by the received BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE event
to continue the process. However, the action frame could be transmitted
either on the current channel or on an off channel. For the on-channel
case, only BRCMF_E_ACTION_FRAME_COMPLETE event will be received when
the frame is transmitted, which make the driver always wait a full
timeout duration. This patch has the completion signal be triggered by
receiving the BRCMF_E_ACTION_FRAME_COMPLETE event for the on-channel
case.

This change fixes WFA p2p certification 5.1.19 failure.

Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c | 17 +++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index e6c8b0d5afe06..7dae935701a72 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1469,10 +1469,12 @@ int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
 		return 0;
 
 	if (e->event_code == BRCMF_E_ACTION_FRAME_COMPLETE) {
-		if (e->status == BRCMF_E_STATUS_SUCCESS)
+		if (e->status == BRCMF_E_STATUS_SUCCESS) {
 			set_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
 				&p2p->status);
-		else {
+			if (!p2p->wait_for_offchan_complete)
+				complete(&p2p->send_af_done);
+		} else {
 			set_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
 			/* If there is no ack, we don't need to wait for
 			 * WLC_E_ACTION_FRAME_OFFCHAN_COMPLETE event
@@ -1523,6 +1525,17 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 	p2p->af_sent_channel = le32_to_cpu(af_params->channel);
 	p2p->af_tx_sent_jiffies = jiffies;
 
+	if (test_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status) &&
+	    p2p->af_sent_channel ==
+	    ieee80211_frequency_to_channel(p2p->remain_on_channel.center_freq))
+		p2p->wait_for_offchan_complete = false;
+	else
+		p2p->wait_for_offchan_complete = true;
+
+	brcmf_dbg(TRACE, "Waiting for %s tx completion event\n",
+		  (p2p->wait_for_offchan_complete) ?
+		   "off-channel" : "on-channel");
+
 	timeout = wait_for_completion_timeout(&p2p->send_af_done,
 					msecs_to_jiffies(P2P_AF_MAX_WAIT_TIME));
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 5d49059021a9f..59e902adfc087 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -125,6 +125,7 @@ struct afx_hdl {
  * @gon_req_action: about to send go negotiation requets frame.
  * @block_gon_req_tx: drop tx go negotiation requets frame.
  * @p2pdev_dynamically: is p2p device if created by module param or supplicant.
+ * @wait_for_offchan_complete: wait for off-channel tx completion event.
  */
 struct brcmf_p2p_info {
 	struct brcmf_cfg80211_info *cfg;
@@ -146,6 +147,7 @@ struct brcmf_p2p_info {
 	bool gon_req_action;
 	bool block_gon_req_tx;
 	bool p2pdev_dynamically;
+	bool wait_for_offchan_complete;
 };
 
 s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced);
-- 
2.20.1

