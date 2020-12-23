Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA352E1344
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgLWCZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbgLWCZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7078D23333;
        Wed, 23 Dec 2020 02:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690302;
        bh=tRYjj1tnATnvy2ObahLEndF8reBD0F02HwaULfa6ITU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkPra7B5v2utUino4gPdmx14PHSGy3FHse56daOBzP+thPC1Ivx2hwvBG9CUDtFJ+
         AeOCnnoc0nPA471GfRpOTF+sm7Lt/2F2hN7jiR1nmUrQuzOT7G70OcqqKzC9GkgZdo
         H+6/y1iVtd9wX3kZIR4648SI11Le9MlqVZVNsbQhOUdrmWIAE3uQkmWT+6qAaoFkis
         pq0lwBEeQBIKz4YaswhQHwsNJfT8NDWLNlpp23N64UNCwVICqlMl47Ph26iRiriD04
         DOVxFvav4jf36J+2ip7zKCOV6KS3Zuq2Pdmb837RagVtoV5RJrzs31ylys2T7ona0o
         tPbTRnTAkGRWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaohui <ruc_zhangxiaohui@163.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 37/48] mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start
Date:   Tue, 22 Dec 2020 21:24:05 -0500
Message-Id: <20201223022417.2794032-37-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
 drivers/net/wireless/marvell/mwifiex/join.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index b89596c18b41a..313b5d9fd08ed 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -877,6 +877,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
 
+	if (req_ssid->ssid_len > IEEE80211_MAX_SSID_LEN)
+		req_ssid->ssid_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
 	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: SSID = %s\n",
-- 
2.27.0

