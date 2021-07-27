Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C683D80D1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhG0VHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbhG0VHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:07:14 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C52C061381
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:07:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i10so37550pla.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MXKHRxMVkVHDhZ+T8UiWjZTM6Vum4iJmblaVt4bfwFs=;
        b=QpC9SEfvlX7NSN3JfA2BC35zgCfrRNM89W+45O2qaetJB35LhamFXcVq9sw1mHkTeW
         /rqrtm+yHWSsc0IMWxYyPILgag6o+lXtAWSh9S38wjvoh0M06iGGbo4ZAdR2u94jE/Bx
         ERMjdPmbTbLpNm0w77EfMtJW7fsMMDFF057oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MXKHRxMVkVHDhZ+T8UiWjZTM6Vum4iJmblaVt4bfwFs=;
        b=oA3pxDtYsey8pcEQD7rDbd2hhfy3M7oAC3BgluAvOf8PWmumhcDMhtiZA4tCvPh1B1
         Ble5xXSC2QRXL2ItLgP3JqiexdJ82YWSqr1GOWc9LT5wckU8TWEb/s4jJQEEPGCdAfzN
         74s9Or8tv5zwqOb0LUeO6ahYZOkBRgzGCipBPxZS7Zzn34UDjbz76NNX6dbyU0HCuKKo
         c7RaLf+i9qPs/utZpt/xZHYe18frMG2de/lXYUZOegBRxPymSnb8xxSINpqhHmWCMhE3
         l9D8g5zellxL2QTKVItYeLEpqNOI/LyFEAiuzS8dPgpuKpbMJjNC+0pFxOD1F0aQA4Xs
         HboA==
X-Gm-Message-State: AOAM530bWbLR/LrtB31S2V1jus5kO/mbEHkOIL33PW9GUkDPSnk3r3EG
        1fWKve5vRVOwga0bhrvtSuQhZQ==
X-Google-Smtp-Source: ABdhPJyuaoJo7hoFf8hTjNgbyLAts3NdgvoF/5uezLGJPhXywqIjaeGrS9UFbajj1vPPHXYDl+4KUQ==
X-Received: by 2002:a05:6a00:1582:b029:332:67bf:c196 with SMTP id u2-20020a056a001582b029033267bfc196mr25270650pfk.52.1627420021064;
        Tue, 27 Jul 2021 14:07:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h9sm3809707pjk.56.2021.07.27.14.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:06:55 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 39/64] mac80211: Use memset_after() to clear tx status
Date:   Tue, 27 Jul 2021 13:58:30 -0700
Message-Id: <20210727205855.411487-40-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2852; h=from:subject; bh=zkH2Je2qGKqyQkSiaJEoBpiopw/INo+50iT5U6QcyXI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOJovWFhW+3LgOdJB6YTmyNLx9mPkMh18BW/VNJ BOSsU16JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBziQAKCRCJcvTf3G3AJj8qD/ 9f25pzpuHDI7d5bSyGKts0iDOiz738IV/yhdknEcL4rC+JiQ/OTrFsGvAMK4zbyT6SQdRvwS0HsQtW FYEY3eOTO0eTLsnAGwNaxw3v5PWM7YYyFygBYMhIhpCgVOighF6YCT2xPnQ7LTyYdpD6L907wxXQ8j oXJcLb9fiEh1t6mn0/dicUHKyTwKkM3fIt2Gx4jCa1Ahv5gyWFd8/4Lv2Yd8KCGn/qxkTG1noBJf5C 2f2h93mKKljmD+CJrJzh/ZYUKpdAY63NSAR4QmZHT60LwkIYj0Fml9G4YK2meArKeNsA1MmJjOiSI6 VkDc7dPKwda9+aKjazu66ex6TqkUbOA0oaukDd2Rq6affQhlkFzRMDK6xCOTPFSye9KgRo0AGn0Klz ni+fmXKvOFIQYweU5qyOYDeL9tYUxQqUBJ6xchOdLgNXFSn5zy34UvmTQoqrVdOTKt+ImUcuGG23jI EEF20MHn/CZclwSMToQj+7lt9iWIQlJAvkfgdTS5zOajot+7oVFGJNYCGUneXC6jvsB+pZPMryc6uu HiwAJXVMsA04PW1mZDRt3xVTJJXADFBiu1CYcDhtJQH//Kmpo9Ydh7kPS4mFHHztPd+qOEZ0St7xxf dvAPnwZQNjibJgICAOUq6/ISKZEK5Qq848MAz7EEKrmQeFoCi4Q4SxSehYJw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_after() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Note that the common helper, ieee80211_tx_info_clear_status(), does NOT
clear ack_signal, but the open-coded versions do. All three perform
checks that the ack_signal position hasn't changed, though.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
Should these each be clearing the same region? Because they're currently not.
---
 drivers/net/wireless/ath/carl9170/tx.c   | 4 +---
 drivers/net/wireless/intersil/p54/txrx.c | 4 +---
 include/net/mac80211.h                   | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 88444fe6d1c6..6d2115639434 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -278,9 +278,7 @@ static void carl9170_tx_release(struct kref *ref)
 	BUILD_BUG_ON(
 	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
 
-	memset(&txinfo->status.ack_signal, 0,
-	       sizeof(struct ieee80211_tx_info) -
-	       offsetof(struct ieee80211_tx_info, status.ack_signal));
+	memset_after(&txinfo->status, 0, rates);
 
 	if (atomic_read(&ar->tx_total_queued))
 		ar->tx_schedule = true;
diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 873fea59894f..f71b355f8583 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -431,9 +431,7 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	 * Clear manually, ieee80211_tx_info_clear_status would
 	 * clear the counts too and we need them.
 	 */
-	memset(&info->status.ack_signal, 0,
-	       sizeof(struct ieee80211_tx_info) -
-	       offsetof(struct ieee80211_tx_info, status.ack_signal));
+	memset_after(&info->status, 0, rates);
 	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
 			      status.ack_signal) != 20);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d8a1d09a2141..7abc1427aa8c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1200,9 +1200,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
 
 	BUILD_BUG_ON(
 	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
-	memset(&info->status.ampdu_ack_len, 0,
-	       sizeof(struct ieee80211_tx_info) -
-	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
+	memset_after(&info->status, 0, ack_signal);
 }
 
 
-- 
2.30.2

