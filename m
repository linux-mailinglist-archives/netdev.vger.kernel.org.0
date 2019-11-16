Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BA4FEF20
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731678AbfKPP4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbfKPPzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:55:22 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B3A218DE;
        Sat, 16 Nov 2019 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919722;
        bh=/DuRqBacLBPF71Nt1vdYFOxtF5gUZeFLy40QWej2VrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfaGz2wKXNZISU47kfigeuhAfxesPb1jKPLhdI+v0DdmiHBJZ8MMu+VUGr9h44v63
         TMQGP3fKiQ8e8a04thNNkjFxDtPG2miflHQhjKFwJOA/Op3G1q5ECJxv1Yg0fdL9iI
         5XGiORAy1a9+G8Gi9MHlXqtJ8WHOvFj1kSMqU/Ak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 63/77] brcmsmac: never log "tid x is not agg'able" by default
Date:   Sat, 16 Nov 2019 10:53:25 -0500
Message-Id: <20191116155339.11909-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>

[ Upstream commit 96fca788e5788b7ea3b0050eb35a343637e0a465 ]

This message greatly spams the log under heavy Tx of frames with BK access
class which is especially true when operating as AP. It is also not informative
as the "agg'ablity" of TIDs are set once and never change.
Fix this by logging only in debug mode.

Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index e3b01d804cf24..a4e1eec96c60d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -846,8 +846,8 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		status = brcms_c_aggregatable(wl->wlc, tid);
 		spin_unlock_bh(&wl->lock);
 		if (!status) {
-			brcms_err(wl->wlc->hw->d11core,
-				  "START: tid %d is not agg\'able\n", tid);
+			brcms_dbg_ht(wl->wlc->hw->d11core,
+				     "START: tid %d is not agg\'able\n", tid);
 			return -EINVAL;
 		}
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-- 
2.20.1

