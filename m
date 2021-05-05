Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85C337455B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhEEREs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237185AbhEEQ7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34B39619A9;
        Wed,  5 May 2021 16:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232797;
        bh=dgAa2UF2g95aptcaS8MYcsNqgBJZ5ZbWtL3Cy9DdzoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMzzO/cbxaIOYO68J4cDgYKGrmipgQJ6fXPmIiC+CHhjJvq1Ji6Chc12cRuj/wTzL
         KNo2q01Z2zlKV8eqE/uJDShaYbTvoS6itgXfS49cOL8T47s07j8zVDVSTQM6iqZNu8
         LnWyzbmqLa9GMEqTMQRSkMsvkbej50X7VedG+DlK8Bq3kO9XJYipvjC5S0Dgh4Quee
         niu6GpxDq0VJLwImRqKh2l+S2gCxqkabteHOuZiK9KKimZ95pFo8M1A5+8lZ6uy0rr
         TVY8ch+WC8w/YHEXtxXqq9Bz6Nvk47X1uSDLjYVDQRGbxdBCOmFQQZrRtKaxExJlRo
         bnfYrjvpjYZ5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Gibson <leegib@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/46] qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth
Date:   Wed,  5 May 2021 12:38:51 -0400
Message-Id: <20210505163856.3463279-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
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
index 7846383c8828..3f24dbdae8d0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -599,8 +599,10 @@ qtnf_event_handle_external_auth(struct qtnf_vif *vif,
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

