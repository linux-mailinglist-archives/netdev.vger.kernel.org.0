Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF431A859
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhBLXaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhBLXaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:30:14 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5582DC06178B
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:28:51 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u8so867730ior.13
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8w8XQdxn9R0vTUUYKwbH7//7X6JrjWFRUImHZ2qHCEA=;
        b=MsK4Yp5tiWM/fulpatrxLLYBqeCGXaamHRMCb6oq63sXWcNUVVP2iuH/EpRTU/P71N
         U5wVLxv4rRqyBLWYgo0h0gt5H8QyMeMDAyvdeKpgYBwlKGWxkRM7vtC8dzVJXzNqIv/F
         go9UPLuCyA4cdM5ZZwhtXWdBYV1CGlDpw4UV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8w8XQdxn9R0vTUUYKwbH7//7X6JrjWFRUImHZ2qHCEA=;
        b=Z0szrkxSzt/Be6DSV8ICPT/NxcrEf8KSuhCqsfyY/YDVm1ecjJKuKn1DQTt+ApBMsV
         Fr4DM6i6FFIkxOuR6PDB5U794bGF7VErc+47G6hUH4ZdrH5o+5GxRv0TMUJBdBR48ymM
         VYmQ5gcVyyk82vTdJwHyiYweoxeLcFSPolV/qF0ZFiZ89+6JJ6MZIGoYi7vb9fxMRB9G
         4DGehk+D8EmWwxVZSKiuLJtUYdxX6+dymqkqvB7+xiCqFDs5NuioRBvjoIUWRjFb+M1d
         WINV0vPjvPjCiSgqWuwwuv2zvdMtOPkBg9FVmSH1EX/ATX0+0235cliqG3EQ2Zx6eRUS
         Scag==
X-Gm-Message-State: AOAM531Z5OCr+4DsynburcL/fP4JhPfKYdJK3Lf3qDudrwx6AN40cuI5
        yBXf2hYz4kXHf0oF5DciGCfa4g==
X-Google-Smtp-Source: ABdhPJyflu0RNWiIV3nbQa149G0hby7tBp9QoVfXWvAf6vhrbVm0ZDp9jsGcpqvP08a3LAahnffRrg==
X-Received: by 2002:a05:6638:3c6:: with SMTP id r6mr4761929jaq.115.1613172530821;
        Fri, 12 Feb 2021 15:28:50 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i20sm5180328ilc.2.2021.02.12.15.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:28:50 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath10k: detect conf_mutex held ath10k_drain_tx() calls
Date:   Fri, 12 Feb 2021 16:28:43 -0700
Message-Id: <0686097db95ae32ce6805e5163798d912b394f37.1613171185.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1613171185.git.skhan@linuxfoundation.org>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
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

Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c202b167d8c6..7de05b679ad2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4728,6 +4728,8 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 /* Must not be called with conf_mutex held as workers can use that also. */
 void ath10k_drain_tx(struct ath10k *ar)
 {
+	lockdep_assert_not_held(&ar->conf_mutex);
+
 	/* make sure rcu-protected mac80211 tx path itself is drained */
 	synchronize_net();
 
-- 
2.27.0

