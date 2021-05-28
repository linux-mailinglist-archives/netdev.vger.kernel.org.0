Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5781539464A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235570AbhE1RUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 13:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhE1RUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 13:20:13 -0400
Received: from mail-lj1-x261.google.com (mail-lj1-x261.google.com [IPv6:2a00:1450:4864:20::261])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA03C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 10:18:38 -0700 (PDT)
Received: by mail-lj1-x261.google.com with SMTP id 131so6228047ljj.3
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 10:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KYKqgQANPtUPJBFPn5nqJDx1hUVnyh7D4hnjBuY774A=;
        b=auw696tXO8E8CxLns4znme1CQYz1dq5v98WgfP5mCcPQbpMrOjYLRcHMJblRHwPeBU
         /estHoDSioHDCYldLfWDRMHVkK5/PqWTfHMJck2CS7sat75vv/II+YBI9k+ufbG5gKsY
         ap9vk8mywPWwZA1CG/DoNQy3ZFG4famA6Y6EFi+YderVM5DzRegbEzLqThNDSioqXS2A
         MkXd5AqXyFVYgF2Z30FIGPmutSr/0Ir71SueSqTCM+evtXrfSFcD6fK6wG4JgHgqQ3S5
         VVujwoDcYQLDqyu0fFNoTRxNYuQeK8NVOFFCLW+rbS9KUPAOVmFUMfDavLndR1/LvLWM
         I08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KYKqgQANPtUPJBFPn5nqJDx1hUVnyh7D4hnjBuY774A=;
        b=EOl6gFlbuW/ufbjInb5JS7oTh2fV7LV0iSFivs2cBWPgYAt7NhH9Xi6VnKM3ub8npQ
         /lVAQ9APyUCZvzy2VagBTZk0U/GGupLeoR0nw80dq2vvGJbaq8UmOpUcvZvICrh8TZ5l
         yB60tGGYZwQlbuasQTz81snPpxKtoBZiMYRRG8ev5YiXWAsVozosFGH1lQUJ6WB9r3Rl
         Pgh5eN+QQKGneh3rhdKM3ij3rF1onXCg4R47VV9u29ROKVi4v2KXkMDrUcDEprwF7qOK
         N8JbEyvS4EKnkBscaRi4799DyXQRnOf/7vgK+B6kshL1t4foFeVrK2p2TZKd09w+Tg+T
         EbNA==
X-Gm-Message-State: AOAM531bXeUSQw7jTNLQ/YfVDQVuEixiQwEoqCG98QWIJu12E/rqYNid
        Qz3lJC85QALB8XjfyLBuCO5gH91T/kHz1dd1DqKAlBoCHs6f
X-Google-Smtp-Source: ABdhPJzRp+aOmPaHAUZ1xj1YawTaDL8+ICPCL5ZFcl6EQtaBxO9BE/wPS8tfA2qufWT9GTswTMP39t4hkDjU
X-Received: by 2002:a2e:1f12:: with SMTP id f18mr7458666ljf.75.1622222316041;
        Fri, 28 May 2021 10:18:36 -0700 (PDT)
Received: from mta1.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id w1sm169969lft.28.2021.05.28.10.18.35
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 28 May 2021 10:18:36 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.122] (port=51686 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mta1.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1lmg82-0007tM-S8; Fri, 28 May 2021 19:18:34 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Amitkumar Karwar <amitkarwar@gmail.com>
Cc:     stable@vger.kernel.org, Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Marek Vasut <marex@denx.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rsi: fix broken AP mode due to unwanted encryption
Date:   Fri, 28 May 2021 19:17:44 +0200
Message-Id: <1622222314-17192-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In AP mode WPA-PSK connections were not established.

The reason was that the AP was sending the first message
of the 4 way handshake encrypted, even though no key had
(correctly) yet been set.

Fix this by adding an extra check that we have a key.

The redpine downstream out of tree driver does it this way too.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
CC: stable@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index ce98921..ef84262 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -203,6 +203,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
 
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
+	    (info->control.hw_key) &&
 	    (common->secinfo.security_enable)) {
 		if (rsi_is_cipher_wep(common))
 			ieee80211_size += 4;
-- 
1.9.1

