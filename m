Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3591D5FA1
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgEPI1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgEPI1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:27:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CF5C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:27:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g11so1921884plp.1
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nJVp21Cy9jUL0NoDLZPalfQBYTt3+XPtVFzS+s6PvFE=;
        b=MEe5nPobbxUiolZc+2N9Rhr6laDY7PCRvnjV/a3naM0vQ7HANfqlXBNOvlI/Z/21M4
         F/hKYOnPkJaKeBDSndSiMkedzs0t0lFK26q76VaWQlsXPF3GVyFY4fY2z9Up+Ms+9BUp
         pdaMgYb8vjQhwJwLTKZI83Pyl6tGQr+sfTe/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nJVp21Cy9jUL0NoDLZPalfQBYTt3+XPtVFzS+s6PvFE=;
        b=jkknbk+3zQ2zzQtJLnb7YvD5QwKUYTyilFv8KqFL4kLe+PJBPGvDA/CIOvxbdR3ILu
         tPSZCaAmVmmtGcwPellYQ6P8KnEui4cQavBpjwiAts1unkZ11aqT1rxq5h0XyuYGjwys
         RxJyWQ6ONj4MsVbr4pMOuQ+Hp+GrNqYAwI3Bb+btr6qEAH66a0S7cmxvi5zPvUlPNOSv
         6IWHeeHkwKqGDxeZAHSHlfp99NehDFXWQOE+7JaR/h3ObQoAfg2o55EQ+UvJ8UGqBZRX
         NILNoPfkWXcSxf8BVGeCCR9aN5rm/qEhaOEfnbMkeEoT/C6awbYiD5VROX9SUAgcvUmP
         GlQA==
X-Gm-Message-State: AOAM533oONyNdpvjKVUfyZs7bKIsd2Wh4I5kxvh7q93Lmk5h17AMq+G/
        dO5JDR9STaCtUUbIvTTtPSSzaFZNAlM=
X-Google-Smtp-Source: ABdhPJwmGqtjhKKJT63inl/05ckFgq3f11qhjjDKvhbeZiekt+KE4JO9a2HL0eeMPFtaeh6wG/1XSA==
X-Received: by 2002:a17:902:c403:: with SMTP id k3mr7306382plk.12.1589617657911;
        Sat, 16 May 2020 01:27:37 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d20sm3176131pjs.12.2020.05.16.01.27.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 01:27:36 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     jeyu@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2] bnxt_en: use new module_firmware_crashed()
Date:   Sat, 16 May 2020 13:55:29 +0530
Message-Id: <1589617529-24009-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
---
v2: Move call module_firmware_crashed() to bnxt_fw_fatal_recover().
This will optimize to make the call at one central place.

Please append to the patchset:
("[PATCH v2 00/15] net: taint when the device driver firmware crashes")
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb..1e37938 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -121,6 +121,7 @@ static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
 	if (!priv_ctx)
 		return -EOPNOTSUPP;
 
+	module_firmware_crashed();
 	bp->fw_health->fatal = true;
 	event = fw_reporter_ctx->sp_event;
 	if (event == BNXT_FW_RESET_NOTIFY_SP_EVENT)
-- 
1.8.3.1

