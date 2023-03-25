Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278756C8CA7
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjCYIei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjCYIeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:34:37 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D9018173;
        Sat, 25 Mar 2023 01:34:36 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id f17so2927872oiw.10;
        Sat, 25 Mar 2023 01:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679733276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TC1VviM7kJDuwC/+3CMrSgl8Bi7rZU2Q6IqzYrz0DpI=;
        b=Ghnvyg7aycOtgQ6MkB2h4AzEv+KZcO4mvdIb6sFX5SWQD5BGVTS4ogaOqpmBJQrHvh
         50CPoyWg4Jp8PBqBdpougNl96VLCvzKEt/fw2Kw+miIMoFkjkNLYtEr3KCeiqupqC3kL
         8eTlJBpkgbf1XGNrXDrfL3BQdwq7fl0+CQ3o2T1vvn7H2BHTldKBHfE7D6uhAyJIbnAZ
         Yxk+bi1GWICMu/0ER7T8BtqFyfmwvVpppo0l+O3dEuw9wxA/atEHsjptuCj0bgw4J4kW
         cJKg4gxHUPBQYtmtbYZLVDd54EOtxenO0crt+vgdRj7SDnqF6iE/n1spGN5m2vJHZg2F
         0KHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679733276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TC1VviM7kJDuwC/+3CMrSgl8Bi7rZU2Q6IqzYrz0DpI=;
        b=RHUUS39pX9K16D8lhC0KYLQAotSDYjDlcHCSirHzTFtNStsoyXdZvEOCZrjuSK7PwI
         GGJtnQ0MYFH80Eh5GtJxWycpmdV/PahDvCyh/EqIrBh/Dq08founZValBYHVP6PmbL0y
         dxUnOC8+7Xs9pNTwAX+L6ZOl2lJfoA2qnwIf34+Fxzs6DWlh2LdZx6GTBlNVwWnv3Q1x
         uSlmN5PuExa6E8MRxkZTUjfLrdhqaxma7DPcPa9UbMJ7NAd4ddgeIeNMTvNcz79w1jUn
         YV5qSR/l5GYmk6/N1I0xi/3oPth8VQ+EHLLuuf1PFtJopzG9zXKG5fXLrddYmctq9JQb
         hsrw==
X-Gm-Message-State: AO0yUKUw5xkbQ8DLVWfhy7q6Q0Q/xbVqlHgGyffWI2ecEh1+MjhkPqhl
        rHk587OfMXvp3R1dNx/FRUY=
X-Google-Smtp-Source: AK7set9bQM0ODRq2OSSCH9JYneSRL/IROaVz4SRcvzDdcnYBZq2VtVjbiXvwjyYGtNnmdl/aLFlC1g==
X-Received: by 2002:aca:2102:0:b0:387:3a49:472b with SMTP id 2-20020aca2102000000b003873a49472bmr2513878oiz.19.1679733276216;
        Sat, 25 Mar 2023 01:34:36 -0700 (PDT)
Received: from chcpu13.cse.ust.hk (191host119.mobilenet.cse.ust.hk. [143.89.191.119])
        by smtp.gmail.com with ESMTPSA id u47-20020a4a8c32000000b0053bb2ae3a78sm2206173ooj.24.2023.03.25.01.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 01:34:35 -0700 (PDT)
From:   Wei Chen <harperchen1110@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH] wireless: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
Date:   Sat, 25 Mar 2023 08:34:29 +0000
Message-Id: <20230325083429.3571917-1-harperchen1110@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user or user-provided data buffer
is invalid, rtl_debugfs_set_write_rfreg should return negative error code
instead of a positive value count.

Fix this bug by returning correct error code. Moreover, the check of buffer
against null is removed since it will be handled by copy_from_user.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 3e7f9b4f1f19..9eb26dfe4ca9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -375,8 +375,8 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
 
 	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -386,7 +386,7 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
 	if (num != 4) {
 		rtl_dbg(rtlpriv, COMP_ERR, DBG_DMESG,
 			"Format is <path> <addr> <mask> <data>\n");
-		return count;
+		return -EINVAL;
 	}
 
 	rtl_set_rfreg(hw, path, addr, bitmask, data);
-- 
2.25.1

