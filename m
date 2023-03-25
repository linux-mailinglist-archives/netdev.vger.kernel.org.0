Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE626C8C7B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjCYIQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjCYIPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:15:55 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462EF19F07;
        Sat, 25 Mar 2023 01:14:51 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id f17so2910078oiw.10;
        Sat, 25 Mar 2023 01:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679732089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UNEJO+btUHDVv8kAHfbox96db3jjTTQ4tn8tm1TepCE=;
        b=l3/Bc6LbfBxhPAE6W9T1hqH74mCbAYSIPSk+g4PM+ZC5xxtxwhuPzMctI1TOFnSncJ
         gfV3iaeMHghACeP3fPbu35I5/rRznJbEGDA7LAVy4KbYak3nBlPrczln18PhiOJc6lwi
         v4iM7KXLz5AH3tpHtS+ZVe87UO5J/8F3vVM+l2HzoRlx73R+YTofdcqow6MEBLNNl+nG
         Jzv+/c8YT74szh5uXFMKSPmuwdD6Gfh1mGBv5CVuKqatpGIvvEJRLBWR5qX7GU00W3Gc
         hDbH6SwTXQ5orTVX+vQZzZ908FmxYZpq80AcSBPUHd7enfkKujSNgruIys8CHUGvIau4
         heKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679732089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UNEJO+btUHDVv8kAHfbox96db3jjTTQ4tn8tm1TepCE=;
        b=gW7PLi7mH58wgolGaWnFCazBI0SdzEMxkST7d0wztIzAcZ+g+IrySI968vqE1NkOS0
         6YoF+W4j9ia8s2LZlAkoL02NRCDhpoU7UVSI8QEAEyoVEeOKZKUPMSu4aNl38dgbb5nA
         rmbPv+k3f5jWS6BMM1LYlBcJfooEY/wn0XKr/o3eSPKPe0xw8CQQS07gMByEYd9uBpJA
         +OiHJMmoZtvQurr5LGvAixzbE7EC88zn1c3WkYrH9DEc+xxTu39PSE0jqqOMpM0pPAcf
         rF+dIYBRSGCvsDtKLr60EOiZNvpdbP13cUMymP87JtpzD/jk1bA/E0C63brhiVjyPNbi
         n5Gg==
X-Gm-Message-State: AO0yUKXCyvg//R+f/Q5/zcBT/S6syrFXxH+D5rpvOF78qYNgE9jPHdlR
        GxG3eLmVxwtni2gUSJGTYJY=
X-Google-Smtp-Source: AK7set8Nm1tQ9MdjKOZ7l1fhSklIp1/yLsjpfGTiaNvbBY5NzHhhKdDwS3+cfJOC/YO87bB6sWlhVA==
X-Received: by 2002:a05:6808:118c:b0:386:fb78:a4cb with SMTP id j12-20020a056808118c00b00386fb78a4cbmr3099127oil.43.1679732089398;
        Sat, 25 Mar 2023 01:14:49 -0700 (PDT)
Received: from chcpu13.cse.ust.hk (191host119.mobilenet.cse.ust.hk. [143.89.191.119])
        by smtp.gmail.com with ESMTPSA id x81-20020acae054000000b0038779c9e6a1sm1935469oig.41.2023.03.25.01.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 01:14:49 -0700 (PDT)
From:   Wei Chen <harperchen1110@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH] wireless: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_reg()
Date:   Sat, 25 Mar 2023 08:14:29 +0000
Message-Id: <20230325081429.3567671-1-harperchen1110@gmail.com>
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
is invalid, rtl_debugfs_set_write_reg should return negative error code 
instead of a positive value count.

Fix this bug by returning correct error code. Moreover, the check of buffer
against null is removed since it will be handled by copy_from_user.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 0b1bc04cb6ad..3e7f9b4f1f19 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -278,8 +278,8 @@ static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
 
 	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -287,7 +287,7 @@ static ssize_t rtl_debugfs_set_write_reg(struct file *filp,
 	num = sscanf(tmp, "%x %x %x", &addr, &val, &len);
 
 	if (num !=  3)
-		return count;
+		return -EINVAL;
 
 	switch (len) {
 	case 1:
-- 
2.25.1

