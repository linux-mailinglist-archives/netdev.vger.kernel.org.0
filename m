Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EB9DC422
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 13:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407836AbfJRLn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 07:43:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390498AbfJRLn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 07:43:26 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 197526412E
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:43:26 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id r17so5193474qkm.16
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 04:43:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Ub6Gl8wiH8cmKTsFrafRHW9fuJ5vrtuEMWyvrQhDdg=;
        b=ervJqIv15L6OllSg68bxTTutwmTN5kLY8N6G9nSHZaQ6ELuafhKd2dHtCH0+kl1vNV
         e69VEn1kUZtrYC5PL5FsZb7vPwqSHh/qN29Cd3Q0xRnndhIymLjAAokDadEVUGc7KTX7
         M6Zx7xW6d+o0rZBS8tw+585HA/SGx9ketzx8UZJ+fMQX0XvT9Ip44ZKgTzYEpKXLMBRM
         lb9TZjFAkMDs4tjnVh9S55iPGLeN6t4i+l1lXw9uOFVwXHel0iivkLg1c52qmyqBnfCo
         NWj9xckDw4YFfMrCv2xG3KmpSURgHOIjM//BCs2sEr+o0xD66Sa/v0FzViUR8jYsY5ch
         JGvA==
X-Gm-Message-State: APjAAAV3x9z4DhPri90o8/L4AGysVyfF9iNOPrkwBPCyb5Jnc0H3hRuf
        pt86JT0FSpFUigMqYRnbJZHw1H94HpbAKRSEqEHMK/7jGq13SCYb3h+KzmQstvG0mew4Owcz5q4
        RJudwdgKyAL212ugS
X-Received: by 2002:ac8:141a:: with SMTP id k26mr9417399qtj.372.1571399005325;
        Fri, 18 Oct 2019 04:43:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwjEavSnVnimGynhK2zUjx91XWTp3w/V3NUGx/C7pvOgTC+fTUzLspHsEQefImPQDlxwBybyQ==
X-Received: by 2002:ac8:141a:: with SMTP id k26mr9417366qtj.372.1571399005006;
        Fri, 18 Oct 2019 04:43:25 -0700 (PDT)
Received: from labbott-redhat.redhat.com (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id d205sm3031043qke.96.2019.10.18.04.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 04:43:24 -0700 (PDT)
From:   Laura Abbott <labbott@redhat.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Laura Abbott <labbott@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Waisman <nico@semmle.com>
Subject: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
Date:   Fri, 18 Oct 2019 07:43:21 -0400
Message-Id: <20191018114321.13131-1-labbott@redhat.com>
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
Bound noa_num against P2P_MAX_NOA_NUM.

Reported-by: Nicolas Waisman <nico@semmle.com>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Use P2P_MAX_NOA_NUM instead of erroring out.
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 70f04c2f5b17..fff8dda14023 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -754,6 +754,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM)
+					noa_num = P2P_MAX_NOA_NUM;
+
 			}
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
@@ -848,6 +851,9 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
 				return;
 			} else {
 				noa_num = (noa_len - 2) / 13;
+				if (noa_num > P2P_MAX_NOA_NUM)
+					noa_num = P2P_MAX_NOA_NUM;
+
 			}
 			noa_index = ie[3];
 			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
-- 
2.21.0

