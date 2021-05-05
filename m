Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86D03741AE
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbhEEQkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234737AbhEEQi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:38:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0270761457;
        Wed,  5 May 2021 16:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232429;
        bh=lmCl/8+UbLLfBdAII2ABQDwTMsu3Sc1/051k2dkBo2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJ/93ym7o9WxX56djYAs23Tr7FR8hZ0yY1kYfd3OgZKYcAbc81ivICvue4cr3zoZD
         mwGcoIRZ9b1ukOhE5jcS/dfixKNhim5CqB1r+jt6lNAgRcOdH76/Eg/q0UoKXVNmza
         fD/kdjkDOuzO+5ODA68e0MiYwOSRv6UKANfvL4ocB7DXh63Vq238+zzcvJXoPQsoOE
         +1p/R79kEsS5K0A0Hgp0uxZrEVKS1xb74ysig5LWMjnzvNJqkz1JtKmke3hTEeN1Lv
         zpwgOKbJm4q7x4z6rv5oLn/RSlySGcY+2QRxUjn8Fsf7nPNTWwnWYRQstvSCdAvF79
         g6nCn1ZUsETUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Gibson <leegib@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 102/116] qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth
Date:   Wed,  5 May 2021 12:31:10 -0400
Message-Id: <20210505163125.3460440-102-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

