Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2E6C8F95
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbfJBRSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:18:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37695 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbfJBRSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:18:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so7779498wmc.2;
        Wed, 02 Oct 2019 10:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BV6L+hqk4XyUS3SFdDC/o0QqOdSd75QbKfMgEhSqMZk=;
        b=QPnQjoVRc9XWitabtC+modVMCOV0bDKc/xLUe34HxD+QsKRGVsbl61I0nr5W74fz6A
         MBp9Y+hJScDUrmrhVsN87QLHk9EbwI2ds8NuFeq6XOvbN5ZNJRimL0Pj/SluMpXfiOxe
         nH09w8hZRIlRuamkBQM17CxZu1cXi9dIFGSnUthAxujeMkJNHts6t65gw9Pi+ulqCFHV
         +oGi9IkE48+YjjB1NduiP0dwrsR1z9nJpOUI3FRM4m4/fRwZHY9GhiX3GLkcEPrWmYF8
         odiqL9s8XP/TJ4gFA7dgDvqAU6R71ND/m6HRMSMyi/6xrtlrMhv5bH39T5FKUvPAwAzN
         BhlQ==
X-Gm-Message-State: APjAAAWGRPtFvsu3xcdqXfuMbZG4q1Xm22ERdCeFXYQUSbrTAnwowL65
        xNTGuPUg674IcQuPMYnfYNVnDlYY1b8=
X-Google-Smtp-Source: APXvYqwG+lrHPxsU/31EHxrkr+onnLQnUGFoFEHXHnVaGTdpXMUNuXO0ovVWYKr/r2+jbzGpMEvIag==
X-Received: by 2002:a1c:1f47:: with SMTP id f68mr4015480wmf.78.1570036706910;
        Wed, 02 Oct 2019 10:18:26 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id y8sm20691987wrm.64.2019.10.02.10.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:18:26 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-wireless@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] rsi: fix potential null dereference in rsi_probe()
Date:   Wed,  2 Oct 2019 20:18:11 +0300
Message-Id: <20191002171811.23993-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The id pointer can be NULL in rsi_probe(). It is checked everywhere except
for the else branch in the idProduct condition. The patch adds NULL check
before the id dereference in the rsi_dbg() call.

Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 760eaffeebd6..23a1d00b5f38 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -793,7 +793,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 		adapter->device_model = RSI_DEV_9116;
 	} else {
 		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
-			__func__, id->idProduct);
+			__func__, id ? id->idProduct : 0x0);
 		goto err1;
 	}
 
-- 
2.21.0

