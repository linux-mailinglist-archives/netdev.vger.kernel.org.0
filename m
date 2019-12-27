Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5332D12B828
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfL0Rxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727438AbfL0Rmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 892DF2176D;
        Fri, 27 Dec 2019 17:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468566;
        bh=wBvesqRv6+JFHdNYD/+gWe4AyEM41kdiYVzP5Y+yzNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGhnuMWy97Z5DH5iv+8/Hy88QIZ9y7guuns7388WSHq7iJL1yETl8opu9K6OuCsU2
         MMt3tRJ6beTWqgV3kQpIfotd6bRFdWz3poATOABzsTxpqa2HHFlUhePMp/5j0U2Bcj
         tlDTslWr071X86RE0oVMN39Moxcxi7vTVicnNUL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20B=C3=BChler?= <source@stbuehler.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 091/187] cfg80211: fix double-free after changing network namespace
Date:   Fri, 27 Dec 2019 12:39:19 -0500
Message-Id: <20191227174055.4923-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Bühler <source@stbuehler.de>

[ Upstream commit 56cb31e185adb61f930743a9b70e700a43625386 ]

If wdev->wext.keys was initialized it didn't get reset to NULL on
unregister (and it doesn't get set in cfg80211_init_wdev either), but
wdev is reused if unregister was triggered through
cfg80211_switch_netns.

The next unregister (for whatever reason) will try to free
wdev->wext.keys again.

Signed-off-by: Stefan Bühler <source@stbuehler.de>
Link: https://lore.kernel.org/r/20191126100543.782023-1-stefan.buehler@tik.uni-stuttgart.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 350513744575..3e25229a059d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1102,6 +1102,7 @@ static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
 
 #ifdef CONFIG_CFG80211_WEXT
 	kzfree(wdev->wext.keys);
+	wdev->wext.keys = NULL;
 #endif
 	/* only initialized if we have a netdev */
 	if (wdev->netdev)
-- 
2.20.1

