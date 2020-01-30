Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8431C14D510
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 02:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgA3B7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 20:59:11 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33501 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgA3B7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 20:59:11 -0500
Received: by mail-ot1-f66.google.com with SMTP id b18so1695480otp.0;
        Wed, 29 Jan 2020 17:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i88Mz1HHfHLRjCoXJjYlUuVlF7tVe72iHNwcP0Yi878=;
        b=FVzpVYqBOkYJARKHKHz9NHlb+5/d7Vt+y/cLQ9kbw3/DGLgrZUfmFvhTPbXxBB40ev
         oE1abXhHnNBgzBj1j3EOAabKBgjxt1eRdkKZBx4HjFUjZyq3ytVXrVOzPkZ5YBJTKnRT
         kcDOi9OglnDClR0mdlIcNuZH7M/LoORTZphTZy+gLkKsXsNZutbn8GS0av34/GlQ2MdA
         c+TjAOf7/GCrZgxK9twfKuDfelQJ30hPK4IVMFksBOmDMIk0mihHjq5lv90Y4lztsRAx
         evEW3LpbForUZMEVfuyWogpNsH3eiuFWc/IPpUDlf6zj4hyJko7j4fbrvrPMMq+a7acZ
         fsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i88Mz1HHfHLRjCoXJjYlUuVlF7tVe72iHNwcP0Yi878=;
        b=ExnGDzs8EqYn973RGjETx9Cno+OFLSuBhxd7y0rsTZoyeaLqeYw0WFgrnwYmNnryNm
         6pRp0OFFCcIb+S05qmxX/i8u6zPzKsD0L0avroWiKFt24eKC8xM1VwYA82Cora+ou6OC
         EG0QWCFwsYG6rO3bO8BQjfUeYvPOaeGLVEz7hbl6Np8RK9Jyjg5OzIaOOmWH90uUOimK
         7eQszoYdNuXSffvbjcXbdrMKT7TcNG1cEfjV1Clf30mWNn5OBhb2h4aOk7s5YwZSDLym
         0HMlGgyQWf7b4rNZ1iAfYvsN9I8V+nDjDuDsk+fUkAGyHOIhrQwqwJw39Q1LI96pVo38
         CPLQ==
X-Gm-Message-State: APjAAAXXCx1YDUeY+S72oF0fszQ8FJydBjwf3bJ2/XgrhlSaao2uO8Kw
        ip96s7+rjKABDoUAfH3D8j8=
X-Google-Smtp-Source: APXvYqwf3Y2XAi7u2qNJRKRkKDQV20c+PEuElI0yUCGY1S8JLzS4wxhZN5rjfaR7wsnHeHMBXU6t5g==
X-Received: by 2002:a05:6830:4cd:: with SMTP id s13mr1710548otd.181.1580349550068;
        Wed, 29 Jan 2020 17:59:10 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id r13sm1216891oic.52.2020.01.29.17.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 17:59:09 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        ci_notify@linaro.org
Subject: [PATCH] ath11k: Silence clang -Wsometimes-uninitialized in ath11k_update_per_peer_stats_from_txcompl
Date:   Wed, 29 Jan 2020 18:59:05 -0700
Message-Id: <20200130015905.18610-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns a few times (trimmed for brevity):

../drivers/net/wireless/ath/ath11k/debugfs_sta.c:185:7: warning:
variable 'rate_idx' is used uninitialized whenever 'if' condition is
false [-Wsometimes-uninitialized]

It is not wrong, rate_idx is only initialized in the first if block.
However, this is not necessarily an issue in practice because rate_idx
will only be used when initialized because
ath11k_accumulate_per_peer_tx_stats only uses rate_idx when flags is not
set to RATE_INFO_FLAGS_HE_MCS, RATE_INFO_FLAGS_VHT_MCS, or
RATE_INFO_FLAGS_MCS. Still, it is not good to stick uninitialized values
into another function so initialize it to zero to prevent any issues
down the line.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Link: https://github.com/ClangBuiltLinux/linux/issues/832
Reported-by: ci_notify@linaro.org
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/ath/ath11k/debugfs_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs_sta.c b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
index 743760c9bcae..a5bdd16d6d46 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs_sta.c
@@ -136,7 +136,7 @@ void ath11k_update_per_peer_stats_from_txcompl(struct ath11k *ar,
 	struct ath11k_sta *arsta;
 	struct ieee80211_sta *sta;
 	u16 rate;
-	u8 rate_idx;
+	u8 rate_idx = 0;
 	int ret;
 	u8 mcs;
 
-- 
2.25.0

