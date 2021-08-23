Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9EE3F5351
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhHWWVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhHWWVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 18:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A045B61037;
        Mon, 23 Aug 2021 22:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629757264;
        bh=c2dWCa0HWj45H4vSGrBr15OdWr53psJLo9xCrc1YnH4=;
        h=From:To:Cc:Subject:Date:From;
        b=e/1yYmL+23yyZdPAJh2VFBrbAvT2tVHcyZv2NdRUkAro1/nv233SU7opLMPeUu5os
         Xh22G+UnbeWNRwbguEYjwxiSL1Yb1IjnKg+DorzBMakWzQCuVtV9KWFlSQtEqrZg2x
         7hkauGS+GBVwZfGsxEHjWjjxZbezxu45Q4HEWyIW7m+PHUbxF1pffyH2toKjxtotB8
         QJ2cXyZJeVUcKrrJT2Bt7l2eCQWQ5kHlCPJgFIgt6yAw/dWdNXcUw5vQAPw77WI4+J
         KYbWUMQJr8iR/Jf8RGpV88AvYDQ4PfM67mWXEGh+4BxvfJSZjqeKhl+ReMjNNferiX
         UeX+cTO7PS8Gg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] rtlwifi: rtl8192de: Fix initialization of place in _rtl92c_phy_get_rightchnlplace()
Date:   Mon, 23 Aug 2021 15:20:14 -0700
Message-Id: <20210823222014.764557-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:901:6: warning:
variable 'place' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
        if (chnl > 14) {
            ^~~~~~~~~
drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:909:9: note:
uninitialized use occurs here
        return place;
               ^~~~~
drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:901:2: note: remove
the 'if' if its condition is always true
        if (chnl > 14) {
        ^~~~~~~~~~~~~~~
drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:899:10: note:
initialize the variable 'place' to silence this warning
        u8 place;
                ^
                 = '\0'
1 warning generated.

Commit 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable
initializations") removed the initialization of place but it appears
that this removal was in the wrong function.

_rtl92c_phy_get_rightchnlplace() returns place's value at the end of the
function so now if the if statement is false, place never gets
initialized. Add that initialization back to address the warning.

place's initialization is not necessary in
rtl92d_get_rightchnlplace_for_iqk() as place is only used within the if
statement so it can be removed, which is likely what was intended in the
first place.

Fixes: 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable initializations")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 8ae69d914312..9b83c710c9b8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -896,7 +896,7 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
 
 static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 {
-	u8 place;
+	u8 place = chnl;
 
 	if (chnl > 14) {
 		for (place = 14; place < sizeof(channel5g); place++) {
@@ -1363,7 +1363,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 
 u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 {
-	u8 place = chnl;
+	u8 place;
 
 	if (chnl > 14) {
 		for (place = 14; place < sizeof(channel_all); place++) {

base-commit: 609c1308fbc6446fd6d8fec42b80e157768a5362
-- 
2.33.0

