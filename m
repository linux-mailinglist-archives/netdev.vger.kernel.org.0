Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F79B31983C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhBLCN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBLCNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 21:13:53 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86079C0613D6
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 18:13:13 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n201so7830967iod.12
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 18:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KNCXIuhBf/yLZUR6g/Q3bWrDbjCkAY4sfEfqXAFf6ac=;
        b=PwLlHkN9fXZfpRWioXDoeeGXdYYWvqi46HIRhejT36qNkWkJyGKc4zk3p0GOfmzgr6
         Q/r+kYD7SMKLoFSi2dITxN9BC40NtITXEhxpXIFZ7jEQw+fgXpFsRrgxKaxo8EMxO880
         LfoxXYyzUgNNBgbgBxSnjPtjJfglTE2CrxRr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KNCXIuhBf/yLZUR6g/Q3bWrDbjCkAY4sfEfqXAFf6ac=;
        b=hVI8Y4A3j0lLsNo9XqPSomdlrB9WjIzqEXLcAQbMNc+SlJj1qJON4nHyoGNCZqOZsi
         Z9WPfGZq2jjd5huEB9vqI1BmKnkEitebuurbthdH/K3ffjyYZa0+JlAiqteHn6/C5lXl
         G1hTUppk8U9UmyhNjk16PF9+qbSotn8EBMONkqsCqS0ZcNFrdMCmlGSFpnQ7f1syoDlv
         94XLxkczJUWGZwfU9m8UFMWg44dLgwRHsJOPLDmplZNmG22S3dXPlSBsi27MSs2jWPn9
         dWazu1PHMbc7RkYsWMirWvU9ELXqXFrw422UATULPrlUmpIn0H8SnspL30HDsSJkeHG7
         FQnQ==
X-Gm-Message-State: AOAM532qchtynJ4i3BAxog7d9nfe85wEOLz5/mrvMPAlCDzhMWMxhrrR
        uK3Jy4D3fGEa+6rlpFpJP2N3XA==
X-Google-Smtp-Source: ABdhPJxHRgQuh8MMHCQ262DBYXeGkeepRITcB4r+KoyS6RHQeVleSejAtUPLHOQGUvq9MZCYHSNzWg==
X-Received: by 2002:a05:6602:2c4e:: with SMTP id x14mr548974iov.58.1613095992862;
        Thu, 11 Feb 2021 18:13:12 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c2sm3480594ilk.32.2021.02.11.18.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 18:13:12 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ath9k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()
Date:   Thu, 11 Feb 2021 19:13:05 -0700
Message-Id: <1cfa036227cfa9fdd04316c01e1d754f13a70d9e.1613090339.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1613090339.git.skhan@linuxfoundation.org>
References: <cover.1613090339.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
the resulting pointer is only valid under RCU lock as well.

Fix ath_tx_process_buffer() to hold RCU read lock before it calls
ieee80211_find_sta_by_ifaddr() and release it when the resulting
pointer is no longer needed.

This problem was found while reviewing code to debug RCU warn from
ath10k_wmi_tlv_parse_peer_stats_info() and a subsequent manual audit
of other callers of ieee80211_find_sta_by_ifaddr() that don't hold
RCU read lock.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
- Note: This patch is compile tested. I don't have access to
  hardware.

 drivers/net/wireless/ath/ath9k/xmit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e60d4737fc6e..1d36aae3f7b6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -701,6 +701,9 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 					     ts->ts_rateindex);
 
 	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
+
+	rcu_read_lock();
+
 	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
@@ -725,6 +728,8 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	if (!flush)
 		ath_txq_schedule(sc, txq);
+
+	rcu_read_unlock();
 }
 
 static bool ath_lookup_legacy(struct ath_buf *bf)
-- 
2.27.0

