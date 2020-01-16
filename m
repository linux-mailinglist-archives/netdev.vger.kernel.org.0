Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E6B13E84D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404774AbgAPRbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404521AbgAPRad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:30:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1882724726;
        Thu, 16 Jan 2020 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195833;
        bh=1SjJAlZJgHXI8ZPZc0v1AGoOUn/u9gQxhzVoZQ7cp+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0YU8g8K22n1vSX3m8G8Oj3GQBJ+oWkAyBWO/6HQAwQIQGGHevu5d/m81MqDCMGa4
         YelmOT94UbjfZxnRvqNzZYL8W7hltmEuupk/JM0RJwpghVdf8ITIvK5fq2ramnJS7i
         O1l6iuLiMIN32ZXE1Li69i+DAEVBGbq4/T9E6bMA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 338/371] rtlwifi: Remove unnecessary NULL check in rtl_regd_init
Date:   Thu, 16 Jan 2020 12:23:30 -0500
Message-Id: <20200116172403.18149-281-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 091c6e9c083f7ebaff00b37ad13562d51464d175 ]

When building with Clang + -Wtautological-pointer-compare:

drivers/net/wireless/realtek/rtlwifi/regd.c:389:33: warning: comparison
of address of 'rtlpriv->regd' equal to a null pointer is always false
[-Wtautological-pointer-compare]
        if (wiphy == NULL || &rtlpriv->regd == NULL)
                              ~~~~~~~~~^~~~    ~~~~
1 warning generated.

The address of an array member is never NULL unless it is the first
struct member so remove the unnecessary check. This was addressed in
the staging version of the driver in commit f986978b32b3 ("Staging:
rtlwifi: remove unnecessary NULL check").

While we are here, fix the following checkpatch warning:

CHECK: Comparison to NULL could be written "!wiphy"
35: FILE: drivers/net/wireless/realtek/rtlwifi/regd.c:389:
+       if (wiphy == NULL)

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Link:https://github.com/ClangBuiltLinux/linux/issues/750
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 1bf3eb25c1da..72ca370331fb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -427,7 +427,7 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 	struct wiphy *wiphy = hw->wiphy;
 	struct country_code_to_enum_rd *country = NULL;
 
-	if (wiphy == NULL || &rtlpriv->regd == NULL)
+	if (!wiphy)
 		return -EINVAL;
 
 	/* init country_code from efuse channel plan */
-- 
2.20.1

