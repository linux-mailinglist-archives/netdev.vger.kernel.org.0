Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD73F5ED1
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237452AbhHXNSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbhHXNSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:18:45 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1939AC061764
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 06:18:01 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so1791373wmh.1
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 06:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qrTrr1okSA/fyylaW41NxAWOmdaQK6vB6FUFZcoBy8E=;
        b=VUrfu731jedX2nyO/kVotTBM+gs3Yalxz9o70AmMsj4zgfd2keaPly4AuihmEEkNuy
         6ncRjwZ2m6+5sfVEE7MQPDBd4JHqBGV0lOqDzz2E7ShOjEwyHWVhQA7Uc4jPE8N0T3X3
         9OqB/XdEmTUBvuZhmWlpifKYIY1Jp15btiTtldnf73qfj4R+M4Mydl9OEai++ucUHzyi
         zu/iqoGxCy4xQgmofGtNeoM13qjawhCD3YZwCXCLvatvXimgGA2rw5Q5RFvPZW6XwBbT
         1rk6YwKb9+/0ppqYzL9NBP/prYe4hWzZaR0IFMybm0LXAYDMR1c0geQGND2RMO0cDnf6
         QE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qrTrr1okSA/fyylaW41NxAWOmdaQK6vB6FUFZcoBy8E=;
        b=GW0AvmK5Ku5EY8fPe6DoUtzugEAwjwbIhRfPGDsHbNON2W9DeO9nqpczBKN5RQaf69
         U9ZlEDtX3FAZtG4GVuwp7ZFv9hFlReot0ti9FGW6exZQUbZcQEt69JKgW3XmgYwD8Zg2
         hsg2BUEgbWP7GaLKEBtbSary2NgCaFl/xuCjlDfwDmYzC2gd3BjyvLlZd5MpkyPIzXh3
         9O2R09wTfBxdgS9C6RCbiLUYnMm8aS3oNrR1YTlXF4hk/7eraTGTPmMhxC3FTIFUJjnX
         MqW/qKv45qDPPU1oAv17JGxrYHIUBWwX7zZB07sblD+n+EHtLWbEo8OdknQ2QVt98QaW
         aTbA==
X-Gm-Message-State: AOAM533Zvo/4eYd+2JSgMcKn5hmOwyppdB1VG5xJOb47x6wzbftsnibb
        rOpPELQQxxSVHXGk2Gan05B3Pg==
X-Google-Smtp-Source: ABdhPJwdAHnk9bDzljbdPivU065Yrg/pyJTBumtbzl7dI75ekN4HDB1t9EeUygwSL0qwGjtfvXlnVg==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr4205383wmj.144.1629811079530;
        Tue, 24 Aug 2021 06:17:59 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:edf4:979b:2385:1df8])
        by smtp.gmail.com with ESMTPSA id h4sm18266299wrm.42.2021.08.24.06.17.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 06:17:59 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] ath10k: Fix missing frame timestamp for beacon/probe-resp
Date:   Tue, 24 Aug 2021 15:28:53 +0200
Message-Id: <1629811733-7927-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a beacon or probe response, we should update the
boottime_ns field which is the timestamp the frame was received at.
(cf mac80211.h)

This fixes a scanning issue with Android since it relies on this
timestamp to determine when the AP has been seen for the last time
(via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).

Fixes: 5e3dd157d7e7 ("ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d48b922..33d23f1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2610,6 +2610,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (ieee80211_is_beacon(hdr->frame_control))
 		ath10k_mac_handle_beacon(ar, skb);
 
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
+		status->boottime_ns = ktime_get_boottime_ns();
+
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
-- 
2.7.4

