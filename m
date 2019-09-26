Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32C2BFB95
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 00:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfIZW4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 18:56:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39096 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfIZW4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 18:56:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so4177714wml.4;
        Thu, 26 Sep 2019 15:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q3J4HBnNW4Hl+Gjxw0HAbYQSV7ljaMhCOnbd8J0BKfw=;
        b=OGcVLqNDzgAxc2ptvHjEJc0ZnwDU+dw0zjb3h1aCQBF9EI5cq/LjPDZNYcm8rVYcB3
         yWUVna7KCPCAomjPQVODfwf2sBswGjY3TYOxR6o2BZ06XNQHTCLYinXTfDrDXwvsVJBW
         NKQBR/jf7Itslea+zewbR842C8+FDa/rPHIT9dqYDJCjR71WO53XPlZMNUfTyJwkKpVr
         NzgSobk/sbtPj6Lpwsjp8xAx6AkaVAtHx5B3lLFULed6HdOfoRwCQ6eEKo8Jbn7SUC81
         xoCTp2AubiWE+YmzLRFgXGxALTme01kpIocxZ2x80dkidGoFp6X5kUjdemN0pTPT67Xt
         iTzw==
X-Gm-Message-State: APjAAAV6zLbTVlt/pc6MvSipCKYaXTaoYxJPMTZxthHBBq3mNP+5J12p
        C0M6K4tFSA7eyjqroyjOzfo=
X-Google-Smtp-Source: APXvYqxrKsKE3nBWyY+NBDRt5sgGhpX8jpg+uUmLH1ydlfeiF9neM0okf0pfLaVTq7mi5G3PAWSx4w==
X-Received: by 2002:a1c:a516:: with SMTP id o22mr5117224wme.116.1569538575651;
        Thu, 26 Sep 2019 15:56:15 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id f17sm668350wru.29.2019.09.26.15.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 15:56:14 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
Cc:     Denis Efremov <efremov@linux.com>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH] ath9k_hw: fix uninitialized variable data
Date:   Fri, 27 Sep 2019 01:56:04 +0300
Message-Id: <20190926225604.9342-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, data variable in ar9003_hw_thermo_cal_apply() could be
uninitialized if ar9300_otp_read_word() will fail to read the value.
Initialize data variable with 0 to prevent an undefined behavior. This
will be enough to handle error case when ar9300_otp_read_word() fails.

Fixes: 80fe43f2bbd5 ("ath9k_hw: Read and configure thermocal for AR9462")
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 2b29bf4730f6..b4885a700296 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4183,7 +4183,7 @@ static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
 
 static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 {
-	u32 data, ko, kg;
+	u32 data = 0, ko, kg;
 
 	if (!AR_SREV_9462_20_OR_LATER(ah))
 		return;
-- 
2.21.0

