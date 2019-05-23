Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0428138
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfEWPba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:31:30 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36756 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730760AbfEWPb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:31:29 -0400
Received: by mail-ed1-f66.google.com with SMTP id a8so9831471edx.3;
        Thu, 23 May 2019 08:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PiGyHyQZ8LHM1OYtHic8yAJxd7r19cMB3vpmM17O/Tk=;
        b=OEstBFl6Pv5yiCjvX2V1LFuTtKFeAPY5Fm3hPe3+FLcRM7XuCG8Rst9B6j85OMvBUy
         /0pQxT9n5M4qEqyib/2VTTznI1oVtk5L6U0XJgZne/3lkTey62apoBzMCFB8MCA6ezJ+
         Qy6W1JIBKMbzyMjRrDghrsGeWh1rNQ6/619CVIy21T1T7/KqUmsYi6FZbZV185/l7JFO
         WjBwfDLYbLemYGGYODwvap1dXV0XtscTFei7zPDjNSueCQLzrdf8Y2/ZU+CmdnTdQFQH
         1mrLMioFHh3XM9DNbX/mfpcouT6Kt30Q0Sko7jSlGRL3qR5UccTHFjO0JLi0kcOIUDR1
         RDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PiGyHyQZ8LHM1OYtHic8yAJxd7r19cMB3vpmM17O/Tk=;
        b=O9S4c7/dzmovZiKzk3P4O/zmTOIn9fw5Z1RTyhTEov/pQ+Zn7VAYA0Q3bvOTHb5urn
         KA3/BicGjtROV8ZUirl3Lp3dmFrjjL/119paOW9EtBYHmqRyNKsNy69JJ0ylV1SdRAvp
         jtw0U/6qzuQwXE+d1i/FcIlvoxfwL1Xvzn/CzgYFDw1RDNl8R8roVXV+PgUU0CXPT1Yw
         F5zrB6fWeUUTV2dndMxqG4NrLAu0Jy125EoQ2j6XpH/mD/RwlOeCu+mlybajo/+nc5CY
         VNFg+otLnDHF3uP2RFxox6YeDbpJb9tQs6WXTHnWfLhARHT2TSgQF+F7RnRwbKM4obGg
         Pb3g==
X-Gm-Message-State: APjAAAW/eG0cfl6eFFaUz3P5KqzeIgSD0o4fTXoNL4MemCnPaia749eh
        GUdfI/B3vf7nRf05ySwIic0=
X-Google-Smtp-Source: APXvYqziauBYmeiv1KJjJonuVENYXzwdeuIYXeli6zRcLXfp+aqM29rGxkCEPB7y4q2vIDY2TbsO7Q==
X-Received: by 2002:a50:bb24:: with SMTP id y33mr97321551ede.116.1558625487453;
        Thu, 23 May 2019 08:31:27 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id c20sm4498011ejr.69.2019.05.23.08.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:31:26 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2 5.2] rsi: Properly initialize data in rsi_sdio_ta_reset
Date:   Thu, 23 May 2019 08:30:08 -0700
Message-Id: <20190523153007.112231-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0.rc1
In-Reply-To: <20190502151548.11143-1-natechancellor@gmail.com>
References: <20190502151548.11143-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with -Wuninitialized, Clang warns:

drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
is uninitialized when used here [-Wuninitialized]
        put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
                                                 ^~~~
drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
variable 'data' to silence this warning
        u8 *data;
                ^
                 = NULL
1 warning generated.

Using Clang's suggestion of initializing data to NULL wouldn't work out
because data will be dereferenced by put_unaligned_le32. Use kzalloc to
properly initialize data, which matches a couple of other places in this
driver.

Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
Link: https://github.com/ClangBuiltLinux/linux/issues/464
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Use RSI_9116_REG_SIZE instead of sizeof(u32) for kzalloc thanks to
  review from Arnd.

 drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index f9c67ed473d1..b42cd50b837e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -929,11 +929,15 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 	u32 addr;
 	u8 *data;
 
+	data = kzalloc(RSI_9116_REG_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	status = rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"Unable to set ms word to common reg\n");
-		return status;
+		goto err;
 	}
 
 	rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
@@ -944,7 +948,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to hold TA threads\n");
-		return status;
+		goto err;
 	}
 
 	put_unaligned_le32(TA_SOFT_RST_CLR, data);
@@ -954,7 +958,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to get TA out of reset\n");
-		return status;
+		goto err;
 	}
 
 	put_unaligned_le32(TA_PC_ZERO, data);
@@ -964,7 +968,8 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to Reset TA PC value\n");
-		return -EINVAL;
+		status = -EINVAL;
+		goto err;
 	}
 
 	put_unaligned_le32(TA_RELEASE_THREAD_VALUE, data);
@@ -974,17 +979,19 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to release TA threads\n");
-		return status;
+		goto err;
 	}
 
 	status = rsi_sdio_master_access_msword(adapter, MISC_CFG_BASE_ADDR);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to set ms word to common reg\n");
-		return status;
+		goto err;
 	}
 	rsi_dbg(INIT_ZONE, "***** TA Reset done *****\n");
 
-	return 0;
+err:
+	kfree(data);
+	return status;
 }
 
 static struct rsi_host_intf_ops sdio_host_intf_ops = {
-- 
2.22.0.rc1

