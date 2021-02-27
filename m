Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374BE326AA4
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhB0AId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhB0AIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:08:24 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DACC061794
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:07:07 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id q9so9575110ilo.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KDyipOQ/zGVT/OsO6YP4rsNag+Kuytihig+gLKvB9Z8=;
        b=LaYZeGozYDZh8m9Zcr5DguvGQyzVvG1qk6+v/7FntdsL/I3sVG06wPjHdPnjcZrUET
         xY5SJ7hU/xLUPFWSmJiJh2JucnddnVTTkkP5NzwA29W6K1xcDQ1SIXbxGUPeBds0IIBb
         /0QQjolx3Ez78Pr0DP8b/cqMkvnkaddIjzBWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KDyipOQ/zGVT/OsO6YP4rsNag+Kuytihig+gLKvB9Z8=;
        b=h0oELELQB5oUXDERqtMCg9woILo86O0gCNkMecX/MEvSE7shneeFadiD0D9oO9IfuF
         nE4hfPDXmmYZ41NHmIJ9GUW0KV8XmrnKoGgjWQqEEyZ2M5DqZxiDlihzdXAqQ8mA5TRZ
         7KbYEghEsYTFPIovVGbQk19embkc8AitU1PG8G5YDsjqth5i7/7Hub76+Zaa37+4ej/K
         KmFZ2tmpgKqK5ibRByxrYBEKQ4kEHwfcbpsz8KchMzgdDWpkslz9IBW7gzeqv0Ot3Kb9
         aO2rCVxTb9qECLztvFHDp7jGXKmcmVlWPQNzJNw8crQgSAm6uKL3kvT020vWm2b90pUV
         0ynQ==
X-Gm-Message-State: AOAM5315ZkSLzmNE+b9zTcl4nNsN83UMDuf97WS6Eyi3xOz6Br8jHY8U
        vlI9ZXU2uHKjBSAxz+jgtAVOLg==
X-Google-Smtp-Source: ABdhPJwzOwoAwB9GujMwkiN8ETBH1uSIX3ovqFMW7TfdMkfk0kJBXFE16/UXQm9KzXnBkIgQeIHe0w==
X-Received: by 2002:a92:cd8a:: with SMTP id r10mr4471884ilb.110.1614384427380;
        Fri, 26 Feb 2021 16:07:07 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w16sm5228805ilh.35.2021.02.26.16.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:07:07 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] ath10k: detect conf_mutex held ath10k_drain_tx() calls
Date:   Fri, 26 Feb 2021 17:07:00 -0700
Message-Id: <c9c2cd7b79f5551741c063239013919bf0e3f984.1614383025.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1614383025.git.skhan@linuxfoundation.org>
References: <cover.1614383025.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath10k_drain_tx() must not be called with conf_mutex held as workers can
use that also. Add call to lockdep_assert_not_held() on conf_mutex to
detect if conf_mutex is held by the caller.

The idea for this patch stemmed from coming across the comment block
above the ath10k_drain_tx() while reviewing the conf_mutex holds during
to debug the conf_mutex lock assert in ath10k_debug_fw_stats_request().

Adding detection to assert on conf_mutex hold will help detect incorrect
usages that could lead to locking problems when async worker routines try
to call this routine.

Link: https://lore.kernel.org/lkml/37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org/
Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bb6c5ee43ac0..5ce4f8d038b9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4727,6 +4727,8 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 /* Must not be called with conf_mutex held as workers can use that also. */
 void ath10k_drain_tx(struct ath10k *ar)
 {
+	lockdep_assert_not_held(&ar->conf_mutex);
+
 	/* make sure rcu-protected mac80211 tx path itself is drained */
 	synchronize_net();
 
-- 
2.27.0

