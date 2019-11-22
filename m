Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B30410647F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfKVGNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbfKVGNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FD682070E;
        Fri, 22 Nov 2019 06:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403193;
        bh=0SJIu/LLaSM4AgdLArh7J6zCrTkadleCHhZA7yhGIFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yuGDeZMBbqXUryZxZL99a2rBSD5GUff9FOvXWEjyFsc4XTIA6546KBHPKOdhOObtg
         dGGlijwgef/FU/UulpGfQJLnc7ckgY1FynO+Ni5TRmvXr72xtvQNt4J7Sp1YLsZLnG
         aqzeoKr6JxRqwwOqalmA1P38zLPvs3sS1HMElLsU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/68] mwifiex: fix potential NULL dereference and use after free
Date:   Fri, 22 Nov 2019 01:12:04 -0500
Message-Id: <20191122061301.4947-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 1dcd9429212b98bea87fc6ec92fb50bf5953eb47 ]

There are two defects: (1) passing a NULL bss to
mwifiex_save_hidden_ssid_channels will result in NULL dereference,
(2) using bss after dropping the reference to it via cfg80211_put_bss.
To fix them, the patch moves the buggy code to the branch that bss is
not NULL and puts it before cfg80211_put_bss.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mwifiex/scan.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index b3fa3e4bed052..39b78dc1bd92b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1873,15 +1873,17 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 					    ETH_ALEN))
 					mwifiex_update_curr_bss_params(priv,
 								       bss);
-				cfg80211_put_bss(priv->wdev.wiphy, bss);
-			}
 
-			if ((chan->flags & IEEE80211_CHAN_RADAR) ||
-			    (chan->flags & IEEE80211_CHAN_NO_IR)) {
-				mwifiex_dbg(adapter, INFO,
-					    "radar or passive channel %d\n",
-					    channel);
-				mwifiex_save_hidden_ssid_channels(priv, bss);
+				if ((chan->flags & IEEE80211_CHAN_RADAR) ||
+				    (chan->flags & IEEE80211_CHAN_NO_IR)) {
+					mwifiex_dbg(adapter, INFO,
+						    "radar or passive channel %d\n",
+						    channel);
+					mwifiex_save_hidden_ssid_channels(priv,
+									  bss);
+				}
+
+				cfg80211_put_bss(priv->wdev.wiphy, bss);
 			}
 		}
 	} else {
-- 
2.20.1

