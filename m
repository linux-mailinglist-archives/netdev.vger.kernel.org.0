Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BB331B149
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBNQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNQjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 11:39:22 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25C3C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:38:42 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r5so858171wmp.1
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fVI7gjSrPQWTPZIF3lno4IgXoY5osdZEypxlTe2oH48=;
        b=IPBlBCTpbTW2x3Te0JiYWQsSXl2m6zLnRZFLIQg1fKUnTWCmYxhnDMfff2M8FBNzgt
         FgOWuiZWPHokUFdYkRZAAuo5UyokLCTUN9u4smd5xJ/Z6oaIfvVnrZ9skC0TS9k+dBY3
         oNpkSBIG/inAgGYGy0djmQ62hz/bxl9sg6EdrEu+tSPSILhz2TgkNEQ4jippvlkJ9/zI
         2wtbkwT1aRvC61aR9MFEl4KFx5ZYd5HR/v8plIGkZDyFRoyy+CiXuFtU1IYO8notYPW1
         t8MizOnFB0Yxzrwxix7JFPVukzEU321tCD5fBS9akPtHKQ3unIqPTvdVeRRN4hqI2Dgc
         /dBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fVI7gjSrPQWTPZIF3lno4IgXoY5osdZEypxlTe2oH48=;
        b=f/mxvc5n1AP7IM/a68XJ+0YnZ2NLSNBe9zQ5d3ZfXCOJakHNyQvfIlPRAETp3EoyOK
         0ExBomuYC6Afirp6ONVk10bEB5QBJKMZ2qukScnd1B8w1f24TaYzlCYu1KpWJ92xJ5Sw
         gmhdlNT9qYp+oFbl69n2+XFN+0y2u+jNZLwSQUg7v4f+kikw3zWRuBBGn/0CSalwUGFG
         Utr+AnTxRlybc7g8JCgpRGQ3b2enSro9JGRscYBcjfAPtguEeWRPvlb+7n83XmSRETw7
         bFZxh5GbX3A+Q87hPsIU4PTtbeMSI9xLky7V4LXWhnif/tz2/4knBeKRAk6At0loPQmC
         oJDA==
X-Gm-Message-State: AOAM532g6gxltHfAw5ZX2FWWcGMb9NUL+P0hSxnSkm3nLe8Tl/CVPAag
        dHCLZ+Eug63oeb4Bg5MS598utYRQNFPNsQ==
X-Google-Smtp-Source: ABdhPJyqjO4PeSpOyyUhOBe/A6vHqBVB2w4u1k1gXh7QZN8MU/wbO4y/vyNL+8FjXXcGFP7hy8Cpow==
X-Received: by 2002:a05:600c:4fcf:: with SMTP id o15mr5169712wmq.96.1613320721430;
        Sun, 14 Feb 2021 08:38:41 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:59b:23b9:f1a6:60c? (p200300ea8f395b00059b23b9f1a6060c.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:59b:23b9:f1a6:60c])
        by smtp.googlemail.com with ESMTPSA id b2sm17366294wrn.2.2021.02.14.08.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 08:38:41 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: fix resuming from suspend on RTL8105e if
 machine runs on battery
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <5b0846b2-64ca-90ee-b5a5-533286961142@gmail.com>
Date:   Sun, 14 Feb 2021 17:38:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Armin reported that after referenced commit his RTL8105e is dead when
resuming from suspend and machine runs on battery. This patch has been
confirmed to fix the issue.

Fixes: e80bd76fbf56 ("r8169: work around power-saving bug on some chip versions")
Reported-by: Armin Wolf <W_Armin@gmx.de>
Tested-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
- This fix applies on net-next. For net I submitted a separate patch.
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 04231585e..376dfd011 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1252,6 +1252,7 @@ static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
 		if (enable)
-- 
2.30.1

