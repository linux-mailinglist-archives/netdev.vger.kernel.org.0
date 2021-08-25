Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9AB3F7C35
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 20:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbhHYSbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 14:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbhHYSbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 14:31:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1475C0613D9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:31:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w6so86591plg.9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 11:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6dOXUoSPTypGPQDCucOQV34a6rWJR5EWTqmODKV08s=;
        b=YiOVAxh8heSMZTuQdsY3Rn90r7ckvGRPSgw6gusedwKl6hrqXtX+qL+HGrRI83QgZs
         m3pFCruNZauUuMVhH9M7YBc4vS7vGwyUtquoBBPcvoFTOF56RwP1TntNfwtSRIAZJIpT
         NU7ofXdsneBIS8e7YjQ6MdkdiWmzTxtzM7Mls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6dOXUoSPTypGPQDCucOQV34a6rWJR5EWTqmODKV08s=;
        b=bOXqlr26unz3Kcxrkv8nR0/gFJt3cNdfAaVJdkpr7pwYoDfdmkgYs443VO1pnUjkiZ
         v4wKoFZqg0Vs/43HY+ou+qN9SInx1dpLUfD+n7Kb5SQICUmtvjs3liu3yjPH1QX6UqDx
         02u8MwLu0Om7MgPm1PkY4jJq4zdtj/Y4XfZrFtvyGG31BmX9MN2byQz9ZEZEuYTxCYEv
         0BOLi4y63L/FrzoXfV8KGKnozG9i/u3449Iuj17uExYfLgxcJ3ViQ9c9QHMo7Njs4+/+
         3NNUHI2AbKacznU9JvfnS0d+rY2CkzKD4ogTXfA2lJq69datv4/Uo16e+kRVNpdz5D9g
         Cz+Q==
X-Gm-Message-State: AOAM533OiPYm+sH51rOnedWWAYay5Qwm+MtRYReEbu1ekvSa39B3kM9g
        Sx72TtFqhMQVg6605/cLWZoBCg==
X-Google-Smtp-Source: ABdhPJwuW+8E9IwXrJ6Bs6gnlyFZ9HmMjLjxedAJoqQTnZPubi7HPwA1Bb216qD2OnMWatoJkBD3jQ==
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr11866220pjb.23.1629916266354;
        Wed, 25 Aug 2021 11:31:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j9sm700035pgl.1.2021.08.25.11.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 11:31:05 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de: Restore channel index initialization
Date:   Wed, 25 Aug 2021 11:31:03 -0700
Message-Id: <20210825183103.1142909-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1333; h=from:subject; bh=Hw85ADjil8Tyn+cbVzUlabg2wwgY/mlYBNlLCrYximo=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhJoxntp7RbQ9YdoPTLDiD6nyn1nZUuZgcd7qA8AzQ LoTbsfyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYSaMZwAKCRCJcvTf3G3AJq0HD/ 9kc+5/HXPayu+LgCjEUEG+dTqq6bkKPnXVRQ7zWMCkT7ihzaUHCBEw9UZgcjMucAZ1HQsofxZomolf RtboXmrxE9/bTSbjHONDVtTo6ZZynqTyU7IbQ6aENortHOR4BCZ7/jWQ2yH9+AknPWve4A5hA7c1ZD 9ga3HHTctJ00csVbZ9x0ozOUTBRGcM69jDEu8vkQ+NY/nC7ls9VxYwTupGS73eWPUFfG1ctJz+gVBu INp+vEu7vgYFYDf7VrUeWSkm1QkXLTGdFFi9tivY0cLe74OqBTZutg/zHBARRjIku9HdPxf4KTTEce 84MK03bpAcIwsXzzAgGvj/nss7LHAEeYmyVqbryEU391TpScdAXCKIZlHORqlQYjLF3f+/KH0llJAS w6BU3q4mo/wYKs5Fe17Rt6bY3s1RsC/Ypphuy2h22H0GzoL9nWO5L6iihaNTddnULj+kflTswWTw2Y ++I69b2Otse7z07SuogA/eERasbX6Gxivt4Dz321weCd3CONopR9jUS/wAq63us7l5pzB2atCBZckG dHLBRsjWmp4ydQu+p6JJsbUJDD0LS1S+FeOhsbRRS5ZuemQzQswrTD/oR5p6HJBLZqSM1dgJ/txu8n B6TwEq4+ZOaw+CHavUlgovoQcx3SpUk00B1V3xJgfYTHWBvbAH94/GknfxQg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2G channel indexes still need "place" to be initialized, since it is
returned from this function when channel is less than 14.

Fixes: 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable initializations")
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Kaixu Xia <kaixuxia@tencent.com>
Cc: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 8ae69d914312..b32fa7a75f17 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -896,7 +896,7 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
 
 static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 {
-	u8 place;
+	u8 place = chnl;
 
 	if (chnl > 14) {
 		for (place = 14; place < sizeof(channel5g); place++) {
-- 
2.30.2

