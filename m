Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0600E597F49
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243612AbiHRHeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240770AbiHRHeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:34:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE94A1D24;
        Thu, 18 Aug 2022 00:34:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pm17so901401pjb.3;
        Thu, 18 Aug 2022 00:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=9O3+WKD7KG8oLgiPdm+AUt4w5isiLEzFoAsTOOJLFII=;
        b=GkCH/1S/xdnSR4xpgdPt00VtsCKRTZbW5Imi3RI7xf+fyZGLeTZNIoao8LdoJG/Aga
         tH4MkKOiuliUkatlBuKCC6hT0fPteT5NYWxOeWiUByj1oOFjNaqJXDWJWn53G6NTpDcb
         4sdn52ar7FU2zmvoQfMRy+GvxCsGQuUO3N9x2ipWfkc30H7AOeM+noRB3I6vPD8ncwhK
         FNLxMAXZyciCmOvwA2Ew3ikemHPYC7JSCLau/RX4fKCYtSvkX4G5lH4bPBZ+mgGeUUdv
         RYu+vUejSeZv9F910n3062fBxZHSUkn8GA9ViNGzK0Ib6qEEMZ4YLPbCbmd7vnCAXd5k
         60EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=9O3+WKD7KG8oLgiPdm+AUt4w5isiLEzFoAsTOOJLFII=;
        b=E81N4U+zED5vdT8NdGwVI6g5D4SXhpdCrYeTru2WgG65x6qG+pFpOO+109uWIujg25
         QGQ4feVgeHcfLA3qyPduVvF+w6yu14DHNGIfwlDnmCqECeDic1MiB6WhVji2ImtoiHwc
         tDo6Vp1JTm+d+mThk9C+EnwQ+1uxe99L+J049Bo+/VChwY6/pg99jjg+t4YuobYeT5mL
         XKq07mZjWOMOWl0EbXy+c3pIHsi93y3viyuDiD69UG6BCxMIv9smnKir67iawMF3KYOn
         oEsuGSFHNH1ULEm2/QCtmZoFKHUYoAKDw6CVIoqks7ZnAg0o497lBXvwBB+ArgOUKs+S
         j2vA==
X-Gm-Message-State: ACgBeo28b0j2ZQ3OkJNhsoH02HzAutIn6h+ao8l81oPaoMX4WXT2efSI
        XA8IIecpMI/VQOt+HVPTSw==
X-Google-Smtp-Source: AA6agR668eUSdnZqdBay4V9Aq6oNAIkQMLIpEKENvEi+6h503C9fT6UWB59Pv0MxZ3BI3X6lMS+Mig==
X-Received: by 2002:a17:902:b60a:b0:170:91fb:84c7 with SMTP id b10-20020a170902b60a00b0017091fb84c7mr1608306pls.101.1660808075881;
        Thu, 18 Aug 2022 00:34:35 -0700 (PDT)
Received: from localhost.localdomain ([166.111.133.51])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090a280c00b001f3244768d4sm2786862pjd.13.2022.08.18.00.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 00:34:35 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Zheyu Ma <zheyuma97@gmail.com>, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtl8xxxu: Simplify the error handling code
Date:   Thu, 18 Aug 2022 15:33:52 +0800
Message-Id: <20220818073352.3156288-1-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the logic of the driver's error handling code has changed, the
previous dead store and checks are not needed.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c66f0726b253..e97e35b39225 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6657,7 +6657,6 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	hw = ieee80211_alloc_hw(sizeof(struct rtl8xxxu_priv), &rtl8xxxu_ops);
 	if (!hw) {
 		ret = -ENOMEM;
-		priv = NULL;
 		goto err_put_dev;
 	}
 
@@ -6768,11 +6767,9 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 err_set_intfdata:
 	usb_set_intfdata(interface, NULL);
 
-	if (priv) {
-		kfree(priv->fw_data);
-		mutex_destroy(&priv->usb_buf_mutex);
-		mutex_destroy(&priv->h2c_mutex);
-	}
+	kfree(priv->fw_data);
+	mutex_destroy(&priv->usb_buf_mutex);
+	mutex_destroy(&priv->h2c_mutex);
 
 	ieee80211_free_hw(hw);
 err_put_dev:
-- 
2.25.1

