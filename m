Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75378D9C14
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389397AbfJPU51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbfJPU50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 16:57:26 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 036A2C04AC50
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 20:57:26 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id d6so65493qtn.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 13:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBQ7gpZ68XC9yJUIRmvhGT9ykcxZ7LBo1PQ5kgI2O8M=;
        b=MieQ3uXYm5VvK+R/0x5vupBFkbINUFftrh8JB9NfRWlqjMGcXm0tpWM2x8qxrrVnwe
         2RHeidykTQlxyK1CKEQ83sOFpBYrQ/hxAiKNFxqteZWpfBm8V46EZHVQ+PnkV0V6AwzA
         Klq9K/Uu7Yb403vQd+rLijKSASRParp+neLEmbpt/PtFIA02wDmKbJ9JT5MxIwI1QEme
         PpfyEkdd2TKX5Wos/F81Qurae16mJPV4Lypj4/J39aqqUrMEyNUXTTINdMTd9JMeylR2
         r9Lrd1ImZTvbqAONK92ibG0WEO1033W0tI8kIQ/8V2dDPNPAMnvJtw19flopOtKVwTSu
         8+qg==
X-Gm-Message-State: APjAAAWmvZ8tef44NtNVKeodOoRAOZ3e9CZHwpDj9Gm0p4ot2jwMKxnq
        0l5Gvhy1TxjmtuFex0sBQxozMzXcLcd4cjsmqeNTm6U+HuIphzZGjOF1Ko8fmw1XdELJ1vPzWMA
        DG3oTrTE6nWawtqV9
X-Received: by 2002:a0c:eda9:: with SMTP id h9mr30851qvr.125.1571259444743;
        Wed, 16 Oct 2019 13:57:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtZQ1p9uv2sCQ5sckBZmJmAmvdBRNeFuMdkuR0mLRWv2XsHKm8h8LAyLgrLZlCxrCo9UBhpQ==
X-Received: by 2002:a0c:eda9:: with SMTP id h9mr30831qvr.125.1571259444351;
        Wed, 16 Oct 2019 13:57:24 -0700 (PDT)
Received: from labbott-redhat.redhat.com (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id 16sm26966qkj.59.2019.10.16.13.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 13:57:23 -0700 (PDT)
From:   Laura Abbott <labbott@redhat.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Laura Abbott <labbott@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Waisman <nico@semmle.com>
Subject: [PATCH] rtlwifi: Fix potential overflow on P2P code
Date:   Wed, 16 Oct 2019 16:57:16 -0400
Message-Id: <20191016205716.2843-1-labbott@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Waisman noticed that even though noa_len is checked for
a compatible length it's still possible to overrun the buffers
of p2pinfo since there's no check on the upper bound of noa_num.
Bounds check noa_num against P2P_MAX_NOA_NUM.

Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
Compile tested only as this was reported to the security list.
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 70f04c2f5b17..c5cff598383d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -754,6 +754,13 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM) {
+					RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+						 "P2P notice of absence: invalid noa_num.%d\n",
+						 noa_num);
+					return;
+				}
+
 			}
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
@@ -848,6 +855,13 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM) {
+					RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
+						 "P2P notice of absence: invalid noa_len.%d\n",
+						 noa_len);
+					return;
+
+				}
 			}
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
-- 
2.21.0

