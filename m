Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AEA2E1624
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgLWC6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbgLWCUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3087225AC;
        Wed, 23 Dec 2020 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690015;
        bh=ZqsyhDJr975uH78eq9vlqfIjc4P44FyApTZEkqL50qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=py3Szs3P2mDnGr+6zQ5Bk835mT58sT/be7XwyTBNAb3M443WVAA2nNnyIkjDsquyA
         98gRF9GhnqzjAmUY2dFj/AZRl9Rha8SJP0s2xIowMFqVF0ROjVB5fNSv3ejZoDS8hE
         7VMLUFf3pIigugVPE6KY4ULyNy3E3ZAuuYjo15YbZriL4N2Ohe2A9ax7QvakSVGazX
         Pznc5qSAdMn+YozP0PPvdMqXuNg+DdnhUsqljKm9QKFbiD2GbRgHiBETOPbALs+L0/
         SbcfgPINOOgMoOucRLFNuHzIOxMCuVNK89FMAJ4l0jbBGCRIA+nV4sBGxtIo38R6KD
         ZKEWGGRjvM73A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Xiaohui <ruc_zhangxiaohui@163.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 094/130] mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start
Date:   Tue, 22 Dec 2020 21:17:37 -0500
Message-Id: <20201223021813.2791612-94-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index d87aeff70cefb..c2cb1e711c06e 100644
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

