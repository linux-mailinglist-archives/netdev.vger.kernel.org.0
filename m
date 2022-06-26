Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C755B163
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 13:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbiFZK7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 06:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiFZK7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 06:59:36 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58A538B6;
        Sun, 26 Jun 2022 03:59:35 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id bo5so6510359pfb.4;
        Sun, 26 Jun 2022 03:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Vg0cRpEtb7ifVHWlwN4JySsa2TxMFUY1alHj7UpNopU=;
        b=eA4fAhRYOxinFBIKOjsdC5/JMtdwRbDdcLmMQfLEP8BUXn+jdxzL/SFPRhPbP7sl5s
         B2tMBHS4ffugy61meKrUepvXyx5eGMIO9aQswV591V9aDB9uTZevnRSGuQ+WW+O3d850
         9ga84NWlQn4qmwvua2hq28dpR3CqMZJ8C6yTLj6USWIbE5RSYJ25wj8JwQRcozQ+Axeh
         yt2/7Q7CR+KaeVvtf4KOsNS9vjdPom2WbO65C3y7RRt21g8xTDi2K/bh2lDc5f1tNQXa
         /1kO1n5V0s+bJd64f/vfjrF2kalUnCKp/BTo/dlj0bTpuogGXLyWMbvyV61OokjiQTTp
         XQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Vg0cRpEtb7ifVHWlwN4JySsa2TxMFUY1alHj7UpNopU=;
        b=txWyG6dqIjMLD+pOU6xeknTJz/sBgGgvU+zaTIisUaWzRM82UK1NFOAmqUOnsC2MWA
         ILJwoeE4eorXyL3Qwq6tY28iZSjaw2d2JVp+D0REsj9BhEJvv8EPWteGKmIGEwrVuSrl
         ZkqCv+HLF0bEMxlKOisO9qXSnlFG75d0axp4kmiVTCTXjc9qgAuSCfJjGOWacbowd5fa
         rFrPFexwfI3+c/2E4O4MaOtkZb2WkuzPmGcZq8olDdiRJ/Z1bCgjukeyrddY7LOPDuJ9
         3Z4gwnjblW2UbBMXUfoqMjuvYimnmAswMedQlw8YGpPMLytWvB8iqtSyuSYr+4/NJ48O
         p/Kw==
X-Gm-Message-State: AJIora8PEmp56eQmS2tom4equBYsRcLaIpnJNC+SYEaSpyQM5ybCf6s3
        LS1cST34MrGEgzYQCMp7Nq0=
X-Google-Smtp-Source: AGRyM1t9jm7Eg21m24Ktie7XX0KqKdjojE4Y8MgzYJx2RCv9lcN2U4EXgyZLQBiZWJRepJ+nQq5Q4w==
X-Received: by 2002:a63:1a0f:0:b0:3fe:4da7:1a38 with SMTP id a15-20020a631a0f000000b003fe4da71a38mr7561453pga.332.1656241175238;
        Sun, 26 Jun 2022 03:59:35 -0700 (PDT)
Received: from ubuntu ([175.124.254.119])
        by smtp.gmail.com with ESMTPSA id a27-20020aa794bb000000b005252a06750esm5019941pfl.182.2022.06.26.03.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 03:59:34 -0700 (PDT)
Date:   Sun, 26 Jun 2022 03:59:31 -0700
From:   Hyunwoo Kim <imv4bel@gmail.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] iwlwifi: pcie: Fixed integer overflow in
 iwl_write_to_user_buf
Message-ID: <20220626105931.GA57801@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An integer overflow occurs in the iwl_write_to_user_buf() function,
   which is called by the iwl_dbgfs_monitor_data_read() function.

static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
				  void *buf, ssize_t *size,
				  ssize_t *bytes_copied)
{
	int buf_size_left = count - *bytes_copied;

	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
	if (*size > buf_size_left)
		*size = buf_size_left;

If the user passes a SIZE_MAX value to the "ssize_t count" parameter,
   the ssize_t count parameter is assigned to "int buf_size_left".
Then compare "*size" with "buf_size_left" . Here, "buf_size_left" is a
negative number, so "*size" is assigned "buf_size_left" and goes into
the third argument of the copy_to_user function, causing a heap overflow.

This is not a security vulnerability because iwl_dbgfs_monitor_data_read()
is a debugfs operation with 0400 privileges.

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bd50f52a1aad..fded5d305b11 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2854,7 +2854,7 @@ static bool iwl_write_to_user_buf(char __user *user_buf, ssize_t count,
 				  void *buf, ssize_t *size,
 				  ssize_t *bytes_copied)
 {
-	int buf_size_left = count - *bytes_copied;
+	ssize_t buf_size_left = count - *bytes_copied;
 
 	buf_size_left = buf_size_left - (buf_size_left % sizeof(u32));
 	if (*size > buf_size_left)
-- 
2.25.1

Dear all,

I submitted this patch 11 days ago.

Can I get feedback on this patch?

Regards,
Hyunwoo Kim.
