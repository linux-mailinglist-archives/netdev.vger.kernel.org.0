Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC2413864
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 11:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfEDJKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 05:10:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45928 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfEDJKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 05:10:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id e24so4109490pfi.12;
        Sat, 04 May 2019 02:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=weyn+CHVWujXbQhxQpPXY+MmlPD3OaJ4CkltxPjfrS4=;
        b=GX1wUbavt4/yeinpEnt7G2fmTCdYJ9kThtfe5FiGkRtqRpYj0PH5HJUNhAxuG+G0PO
         Lgn+96yNkQ8xZNxbYtEElcrlGz49Ze6NAzDamdrDNFjxCIYe9wnMZDW9JUiFzLRXU6Zg
         RLdi6HBpjD0EcKxEf6Hr2pA5yOeoHR3uPcOBbq5L0mUE28iwCq8din3Wyn+IhRFEcFUY
         4Zex3MuxV0laRfO7Xz7VWlI3cyI8m4LedyLp+iHhmXzW4ay4CLzGfj4gVZWsn2KPRn8c
         o2GNGL/sUpN2sjq0E893V2hmsWcnwnfvKQI+2ypviuDGHRcqChtOT+2iuOZORaJcfLZV
         UB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=weyn+CHVWujXbQhxQpPXY+MmlPD3OaJ4CkltxPjfrS4=;
        b=bDNSq2yk4PrFCo687XuZ3q0v56N3jb8O3QOJUbs/7vA1kvLgFYShAJIuBdK+VBmz4G
         IFihM0Mjxb64WPMBcqVeRJvGJhd2P7gxbhpSApoI/edWIxuRTqLE1tlr4cxslIr1QPRt
         /o/l40yCFJWv/ltGL9E/fU2rQyYmn9ZDhtCR8JhBDzR/zS4kxlVvqDB4eGVCHlNhMQKN
         jIqeYMyegTohUXDhUzOQJasm9uBAd6u7ziNRfm/evYUmPnGavtay4sfPf0wQuolOmP7J
         tV0NIBCORzlaEjKTMvYtb1RLizvv/cmz+dzIUs32APlFWYhKlh6l3AJjWHnzwlD8+KVb
         b3mg==
X-Gm-Message-State: APjAAAWItNaxtukoDY+T7OO8PvlhEnWkr/9eNCzSMgahzlSPxb8G+6x+
        GAF53849mPCvGncQW6s4Okc=
X-Google-Smtp-Source: APXvYqzQaP3Vs7X9Cum2Z7PgW42q0Cahgu53Yir7dPOIiaVQSVyphkycH/dr0MPdOVXn3iWNrPWxig==
X-Received: by 2002:aa7:8252:: with SMTP id e18mr17944696pfn.105.1556961012702;
        Sat, 04 May 2019 02:10:12 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id 19sm9225490pfs.104.2019.05.04.02.10.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 02:10:11 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net,
        colin.king@canonical.com, yuehaibing@huawei.com
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: b43: Avoid possible double calls to b43_one_core_detach()
Date:   Sat,  4 May 2019 17:10:00 +0800
Message-Id: <20190504091000.18665-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In b43_request_firmware(), when ieee80211_register_hw() fails,
b43_one_core_detach() is called. In b43_bcma_remove() and
b43_ssb_remove(), b43_one_core_detach() is called again. In this case, 
null-pointer dereferences and double-free problems can occur when 
the driver is removed.

To fix this bug, the call to b43_one_core_detach() in
b43_request_firmware() is deleted.

This bug is found by a runtime fuzzing tool named FIZZER written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 74be3c809225..e666a472a0da 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -2610,18 +2610,13 @@ static void b43_request_firmware(struct work_struct *work)
 
 	err = ieee80211_register_hw(wl->hw);
 	if (err)
-		goto err_one_core_detach;
+		goto out;
 	wl->hw_registered = true;
 	b43_leds_register(wl->current_dev);
 
 	/* Register HW RNG driver */
 	b43_rng_init(wl);
 
-	goto out;
-
-err_one_core_detach:
-	b43_one_core_detach(dev->dev);
-
 out:
 	kfree(ctx);
 }
-- 
2.17.0

