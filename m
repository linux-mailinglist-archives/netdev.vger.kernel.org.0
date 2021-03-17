Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C333F01A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCQMS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhCQMSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 08:18:18 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B163C06174A;
        Wed, 17 Mar 2021 05:18:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lr13so2223429ejb.8;
        Wed, 17 Mar 2021 05:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5N6Wrb+7I1coNpm4gtBKvbrfokvWhrg9piV4XwzHCg=;
        b=LkTAvUIv2c08lGXVubN0boeSaP5tZsOQHfrjsgC12FrfOgqWaii/qNa7/6gDZlTnES
         9K8ob5YKPVdoamI5qk02W+zJ//DwOnr9v5yKwDIJcVtz88qwnOUhpy+wkHQzN+m0Uag0
         7UIJVXM4QMYt5tBCmYcFVkEJQuT/MkwwTFcwGn8D1E+GT5XEWW2oABuCV9Lh2p0FQp+U
         vU521/k5V3knepvZJ/Xj9fNITXqXeJrOfb2K8ZWx//mMl5OzvX/Fec8QgRIsiNPQbjw3
         eOyHERfgd28/PJbMICNlDn539dKJLwTh3FJ7qE71QjsZbpKBAuf/aZhdfeWTOW599TN7
         upyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v5N6Wrb+7I1coNpm4gtBKvbrfokvWhrg9piV4XwzHCg=;
        b=F/p/L39LDE1IBC5Fe1lXzZXjP/ICeCWwvBLca/6y9fpFqmf5DuvA1OXUwCHskpSyDk
         IqRv1c9PS8GiIPfYA+NsOcNBnXHVQcsWwfvJTYGxmu72SD9wp8wMYqttc+MIMGJFVeyk
         srIqgj4HOM+OqVt1EYddwA9G4DXRgDpvPqSLkAl3DsNbI0xSv06+A+RWkVAQ+e8M8VM9
         PFno/qh8vrV7Nth6ZaTgIK6LyN1p12qBZPwV6LQmNOP7hAO09Qjz93yn3XQPfNGP0HLi
         TY4aV0jd9fkXp2B1aCRwpypGoc3J04zOkC7kz7IrZBiuApgsCa8Ekh5NEgkX9cMGaUoj
         eRzg==
X-Gm-Message-State: AOAM530XFpQqKtpI2vbZwvH3/ZNy2wXNyjuEucrWUdD/mFKcNnFYpjiw
        IXHgEZJLlIKx1o7h96b2scOBXvKSeNNpY8ai
X-Google-Smtp-Source: ABdhPJybO/Q00n5VVmOuBQJHeMQ+9ors8Bof6REOLhaDmiddfN+vsPFOTVHyNiSo68oDee+A8TZAJw==
X-Received: by 2002:a17:906:151a:: with SMTP id b26mr15364067ejd.492.1615983497009;
        Wed, 17 Mar 2021 05:18:17 -0700 (PDT)
Received: from ubuntudesktop.lan (205.158.32.217.dyn.plus.net. [217.32.158.205])
        by smtp.gmail.com with ESMTPSA id b22sm12239375edv.96.2021.03.17.05.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 05:18:16 -0700 (PDT)
From:   Lee Gibson <leegib@gmail.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Gibson <leegib@gmail.com>
Subject: [PATCH] wl1251: Fix possible buffer overflow in wl1251_cmd_scan
Date:   Wed, 17 Mar 2021 12:18:07 +0000
Message-Id: <20210317121807.389169-1-leegib@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function wl1251_cmd_scan calls memcpy without checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
---
 drivers/net/wireless/ti/wl1251/cmd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 498c8db2eb48..e4d028a53d91 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -455,8 +455,11 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 	}
 
 	cmd->params.ssid_len = ssid_len;
-	if (ssid)
-		memcpy(cmd->params.ssid, ssid, ssid_len);
+	if (ssid) {
+		int len = min_t(int, ssid_len, IEEE80211_MAX_SSID_LEN);
+
+		memcpy(cmd->params.ssid, ssid, len);
+	}
 
 	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
 	if (ret < 0) {
-- 
2.25.1

