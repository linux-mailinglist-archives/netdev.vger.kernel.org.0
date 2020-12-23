Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF3E2E1303
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgLWC1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730913AbgLWC0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:26:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205C32332A;
        Wed, 23 Dec 2020 02:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690355;
        bh=au8gNUmjCcxfgczqLam57knzjW+A5ZRyBxc0fF4OJWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cx4aDXdmTfqnQuiJ0noj6Om1uieTCiiT1Oc9n9eBZGxP41paqJ4YAw2BzqaOCqQkz
         hYHM3BzdYFoRh9ydTMuXWWJCp/ocPJoJmR2oKrCdAs2aJjv9Jn7/EIVDzbZELLv/nU
         R7vO6s0ip0x5SHhYemxfAosHaMmKJM3cgHdJf96W6Fw1G8Pxi0v891fY5h6+5l3oUu
         dxTa5b0iyWK14XGma0RY1gDa5cqlOnWQf+ZrsxX4AkTnlHo4DRqmjEBTL3NT6HYq1W
         w19xlpaaVDGZsJjQLfQvUY3soubTdL9eLJVFd3XzEcbQ9awb7VR+cedjRKunN+aUQI
         xxeMpaIOVBi6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaohui <ruc_zhangxiaohui@163.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 31/38] mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start
Date:   Tue, 22 Dec 2020 21:25:09 -0500
Message-Id: <20201223022516.2794471-31-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

[ Upstream commit 5c455c5ab332773464d02ba17015acdca198f03d ]

mwifiex_cmd_802_11_ad_hoc_start() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service
or the execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201206084801.26479-1-ruc_zhangxiaohui@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mwifiex/join.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 6378dfd3b4e86..83b7cd5bdf930 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -856,6 +856,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
 
+	if (req_ssid->ssid_len > IEEE80211_MAX_SSID_LEN)
+		req_ssid->ssid_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
 	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: SSID = %s\n",
-- 
2.27.0

