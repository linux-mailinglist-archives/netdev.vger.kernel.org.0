Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4ACA42FFF8
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 06:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhJPEFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 00:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhJPEFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 00:05:20 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120E3C061570;
        Fri, 15 Oct 2021 21:03:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g14so10065967pfm.1;
        Fri, 15 Oct 2021 21:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Kk4lSYh9qkuEZmg+x+V6fdHeoATR2kzm3gew8LTGr5o=;
        b=RBv3o9l7VdkjYj6oLj9MoBjumwoquSll2FMivWFrNA+hBr647UdCvkxXL62PVDa/wX
         DH8RiihLHeYJw3KN/9fL8Q2BkmnGVGB3v/RG3KeUqggK10uRI5gGTnqBCVWvf0ipTKmp
         EJE3mQfFgC5JXUo2Xzc8m7dGMaP9rRh4tb5+eIr8str75QgfrTTPAeoWFcnhA+FeWuZi
         sx4k9Cpb/1QTu1YHKdm+iyRiHJkOXcdtEySCe6gpMTs/CSzod4v2mU38DBIYr1uhx+Ev
         Cj4wTmPWvf9CUvsRtdOGy6lU8XvsAcDMnQwOjVpuEdqkibum0gAaOnKQe/beINedqxKO
         EPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Kk4lSYh9qkuEZmg+x+V6fdHeoATR2kzm3gew8LTGr5o=;
        b=IATa2YyetbOgQcaB9n7QCQJgR53/ovfgVf1nt0Y1yEehuKZtWxFgmV0BdIecdnScyK
         dZ/NXd11HsNDefdnI1Ap0VBlDC/REs1XOpX96cgDhvCokPvCwSHW6TP94gMMLFEX9Jv3
         GGK1Rk8todsVfM6T5MYUe5Pj+yNjiHnhuWJNET1aT6L36MCgOaHJyyVR7eg9qaWXXENg
         2QmuPLcpdEvYeoQ9uyzvaRJ7H1UV5HjaU6rn24qjfn8Ud+7Igd5YZm/o/ymgpZaM7ieD
         SXjTTvqCbHeQW79/8HimDb9U4ZCj1X6G8EsG424d88exI6Io6siBe35qbpGt+VINffEN
         Likg==
X-Gm-Message-State: AOAM531c0H8IuPIq0ddtr3wFkXUzf6iPEZsldMnSV67Ssi3LPzFES2bK
        59Fz04WEc01HsUZ/QNtCnw==
X-Google-Smtp-Source: ABdhPJzdkyGjKqXCFWf5xUKBnNxoRsOJQA0pvyX43lv7izN8gaMOwNGPw8XQ/CA4QBHahvcJwSNe7A==
X-Received: by 2002:a63:6d08:: with SMTP id i8mr11913751pgc.368.1634356991192;
        Fri, 15 Oct 2021 21:03:11 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id x23sm6617177pfq.146.2021.10.15.21.03.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Oct 2021 21:03:10 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] mwl8k: Fix UAF in mwl8k_fw_state_machine()
Date:   Sat, 16 Oct 2021 04:02:59 +0000
Message-Id: <1634356979-6211-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the driver fails to request the firmware, it calls its error
handler. In the error handler, the driver detaches device from driver
first before releasing the firmware, which can cause a UAF bug.

Fix this by releasing firmware first.

The following log reveals it:

[    9.007301 ] BUG: KASAN: use-after-free in mwl8k_fw_state_machine+0x320/0xba0
[    9.010143 ] Workqueue: events request_firmware_work_func
[    9.010830 ] Call Trace:
[    9.010830 ]  dump_stack_lvl+0xa8/0xd1
[    9.010830 ]  print_address_description+0x87/0x3b0
[    9.010830 ]  kasan_report+0x172/0x1c0
[    9.010830 ]  ? mutex_unlock+0xd/0x10
[    9.010830 ]  ? mwl8k_fw_state_machine+0x320/0xba0
[    9.010830 ]  ? mwl8k_fw_state_machine+0x320/0xba0
[    9.010830 ]  __asan_report_load8_noabort+0x14/0x20
[    9.010830 ]  mwl8k_fw_state_machine+0x320/0xba0
[    9.010830 ]  ? mwl8k_load_firmware+0x5f0/0x5f0
[    9.010830 ]  request_firmware_work_func+0x172/0x250
[    9.010830 ]  ? read_lock_is_recursive+0x20/0x20
[    9.010830 ]  ? process_one_work+0x7a1/0x1100
[    9.010830 ]  ? request_firmware_nowait+0x460/0x460
[    9.010830 ]  ? __this_cpu_preempt_check+0x13/0x20
[    9.010830 ]  process_one_work+0x9bb/0x1100

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/wireless/marvell/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 3bf6571f4149..529e325498cd 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -5800,8 +5800,8 @@ static void mwl8k_fw_state_machine(const struct firmware *fw, void *context)
 fail:
 	priv->fw_state = FW_STATE_ERROR;
 	complete(&priv->firmware_loading_complete);
-	device_release_driver(&priv->pdev->dev);
 	mwl8k_release_firmware(priv);
+	device_release_driver(&priv->pdev->dev);
 }
 
 #define MAX_RESTART_ATTEMPTS 1
-- 
2.17.6

