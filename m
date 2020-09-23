Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7927523E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 09:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIWHXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 03:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgIWHXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 03:23:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB8DC061755;
        Wed, 23 Sep 2020 00:23:43 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z19so14480713pfn.8;
        Wed, 23 Sep 2020 00:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=szhTKPsLT/eSqNOiv7SSKyT6k55mYaygdNpzPFJobRA=;
        b=lAV2HgFm3i12ZhfzcZs7hI+uSznUgTzTt0c3xxoBW+TBpd5p2/JzzvxxFBuIyI3hCc
         N2i+L6tPahh+K5Fa+V+q19wGXaM83YPYSJaLvfO47TCLOWQ9KepswaoY7bkSrefllb3l
         Czr3J2ZUgKBk1jswTIkA1gBcbkzZ2AJ25+kaMfhEGWPmHGL/rbHXatJ/sTB/QD1JDcup
         DK4aLpd/IBqPHNSwa7vRcgrFBBrfJZ27DLmBfQcmn84rwwPptl7Ez038HHnEypDTqnbX
         G2s2b7q29eQpt+PR9i/HRS3h9iA1ZArcT+o5iua8duCL0wXK4PxMfvYVdi4zTEWmnerW
         pxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=szhTKPsLT/eSqNOiv7SSKyT6k55mYaygdNpzPFJobRA=;
        b=X9lLWqKvMul7o8/HHqtY+ghOe9Dzvo7243e0n36PXdhnzVlPZ7BQ5P0zYlQhOgwq5u
         pLTC2qGQ9Zs0mUxx5x72eRCTEvHRbX4ieex78bxKP7R1JRbfHGBcwqUdpjLPl/ygrWJz
         EVPSP2L1NNPDAf7oUrgkD7BAEFDhFNLje0ByXFQZVGyLvQeGgEWy50vociqEjCwEkGZt
         nrAjF+bDUjg1IkmMBzNyLzCTjYj4FdwjCvezeeDrsz/tGzwFOF6MlGdS0qtoxVnz8iTh
         xYAWcae6vuu2WvUnSsXdy26XJeKFo1lFO6dMJIHwIAKKqJH2eWY8HMGSwNvGTeqKhRLS
         dcfA==
X-Gm-Message-State: AOAM5332yxvc8KZbCPWP1+eE/43XIfWFaxproZxfvVHfxpW7wmDk6mKC
        5xmCvhpPwEsPv/6gF7t4lLT/5XP4dv3yO/bW
X-Google-Smtp-Source: ABdhPJykWM4yTeAs7d6cEkEdgequ5c4SvoiXrWx+APLXbxFDYZdhvlVH4iSEIUDKvF31Asx7uONIKw==
X-Received: by 2002:a05:6a00:888:b029:13f:f7eb:578c with SMTP id q8-20020a056a000888b029013ff7eb578cmr7869549pfj.10.1600845822996;
        Wed, 23 Sep 2020 00:23:42 -0700 (PDT)
Received: from guoguo-omen.lan ([156.96.148.94])
        by smtp.gmail.com with ESMTPSA id n7sm16585488pfq.114.2020.09.23.00.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 00:23:42 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7615: retry if mt7615_mcu_init returns -EAGAIN
Date:   Wed, 23 Sep 2020 15:23:03 +0800
Message-Id: <20200923072330.1311907-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mt7615_load_patch in mt7615/mcu.c sometimes fails with:
mt7622-wmac 18000000.wmac: Failed to get patch semaphore
and returns -EAGAIN. But this error is returned all the way up to
mt7615_init_work with no actual retrial performed, leaving a
broken wireless phy.
Wait a bit and retry for up to 10 times before giving up.

Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
On my mt7622 board mt7615_load_patch always fails the first time
and it then succeeded on the first retry added by this patch.
"10 times" is an arbitarily picked value and it'll still leave a
broken phy behind if all 10 retries failed. I don't know if that's
okay. Suggestions are welcome!

 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index 7224a00782115..2272f6bcaafe7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -16,8 +16,15 @@ static void mt7615_init_work(struct work_struct *work)
 {
 	struct mt7615_dev *dev = container_of(work, struct mt7615_dev,
 					      mcu_work);
+	int i, ret;
 
-	if (mt7615_mcu_init(dev))
+	ret = mt7615_mcu_init(dev);
+	for (i = 0; (ret == -EAGAIN) && (i < 10); i++) {
+		msleep(200);
+		ret = mt7615_mcu_init(dev);
+	}
+
+	if (ret)
 		return;
 
 	mt7615_mcu_set_eeprom(dev);
-- 
2.26.2

