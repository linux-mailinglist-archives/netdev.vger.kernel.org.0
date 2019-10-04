Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6ACC3C9
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 21:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfJDTxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 15:53:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40488 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730746AbfJDTxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 15:53:24 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so16072146iof.7;
        Fri, 04 Oct 2019 12:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MS6KPA7Zwid+VvXpcQaJcC4Lhg7r0UTgc+r5bTRTQzQ=;
        b=GxQstqbCOnLx126tgUZiwbsF2HdhWFfLVbG+e7xb9YbNaC6njmdUbzMzN9hS0DGF2R
         sCdH2HCG67lanBOwPlb0dywPzS3GkIh1bQJmVjcTxJfy9IcXrGP3gydoilg6SbK1D3WU
         fTopxDbTJUzZJOrOm43pQT6TPyanbS/pZdUjRmpaHAFag65or/YOsJ/m9nCcx7FPiFfU
         5EZ78zQXs2t1aBxFtr3v+0Vj4gwQ5VOaA2R+0vc1ZcLUf8EqHrSK/krgcsi3Ne1wet/m
         dD0goUMsqDttAaGSGJKTqO5zk3zwpfQg9NLaMCi7Tm6dYbWl5QPU3bH/JKcau1qQvcKN
         INFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MS6KPA7Zwid+VvXpcQaJcC4Lhg7r0UTgc+r5bTRTQzQ=;
        b=slJE3/amUNdhsDLKpndhZkaLmtiq+9Fj7lGj0GbJn4qH5mI/8BfmaKa2pBJ/Po9da+
         XsJP059xy5OcCHNBOPD5GLeNMaCgfhh2tRdJ+OTY/n00Vf3H/Sn0zi6U6e+eDMytNOnA
         a0B9OPc/euWHI6n9lrDb31dkuTf4vRrt7Q+7zakEceZsvs43SS9OBLycubjMy4Q2E0k4
         Ba/nxv0maIWzhG2w8+YKjETokh+CmRFLHN28Tq4UzC4m044oMkFr9dNHm6tLxTdIvR7y
         ZILwNQ61ed6I5kVc0zjXeqoOwW6wVDccdjJU2TQ1PrYB6JGtfD1WwhHZYafYqZh+treD
         74KQ==
X-Gm-Message-State: APjAAAXocd0F+QrGt2dZL7u7sg2b5PGrdcHM89B+AWOSmERHsgFdAt5T
        +cHCW7KLfnOGkrJY3YwOTs6atrnaBqc=
X-Google-Smtp-Source: APXvYqydhL1ReOzniYD5VzA4lRSsmW1hKT4R+X4IRWehJs3tidGK8O1cUqJEdOSyeOWpsRQpCOoyaQ==
X-Received: by 2002:a92:db0c:: with SMTP id b12mr16542465iln.27.1570218803179;
        Fri, 04 Oct 2019 12:53:23 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id t9sm2420224iop.86.2019.10.04.12.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 12:53:22 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: fix memory leak in rtl_usb_probe
Date:   Fri,  4 Oct 2019 14:53:14 -0500
Message-Id: <20191004195315.21168-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl_usb_probe, a new hw is allocated via ieee80211_alloc_hw(). This
allocation should be released in case of allocation failure for
rtlpriv->usb_data.

Fixes: a7959c1394d4 ("rtlwifi: Preallocate USB read buffers and eliminate kalloc in read routine")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 4b59f3b46b28..265f95261da8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1021,8 +1021,10 @@ int rtl_usb_probe(struct usb_interface *intf,
 	rtlpriv->hw = hw;
 	rtlpriv->usb_data = kcalloc(RTL_USB_MAX_RX_COUNT, sizeof(u32),
 				    GFP_KERNEL);
-	if (!rtlpriv->usb_data)
+	if (!rtlpriv->usb_data) {
+		ieee80211_free_hw(hw);
 		return -ENOMEM;
+	}
 
 	/* this spin lock must be initialized early */
 	spin_lock_init(&rtlpriv->locks.usb_lock);
-- 
2.17.1

