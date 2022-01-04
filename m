Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28704847D7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiADS2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiADS2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:28:18 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DC0C061761;
        Tue,  4 Jan 2022 10:28:17 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id x6so30783811lfa.5;
        Tue, 04 Jan 2022 10:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kOvNpEQcBPJr05GLCmJ/AWrJaYJ4SSJmOSNygEHkrtE=;
        b=HMs/PkrHfTWIjr3rVqqrMJ/3V+BrhpJtllKuP+dNqnNGottQyxJrcae0KeuNhirJWz
         64RMK4Ml62l+iPxoCXwrfknYWbI2G2WX2HQNYKChHCflebzL/VoSQh6teGvm4EbTtr36
         UwWcu3/a5Yq9mgTaho1gz0eJTjNfdcbyKzzl3mddQY2d6s+x14tZFS9JYVL3uesigSZr
         QidUwiCg2039upoh4X8IjXDj30cnbnntsGz+OWEG4B9AJp1Ts1O0963nB2WqOuelrKFh
         iwzubGUsTRE14VytBy/HYLqM1+aFgQcMw/P8ofwnx8jtiQrI6GDq0aD9rgJRyArFm+76
         4Qnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kOvNpEQcBPJr05GLCmJ/AWrJaYJ4SSJmOSNygEHkrtE=;
        b=1mheMO1K8UA0kJOaCzo22s7CM6OSfGTrU0cFs0FtU2BlM2Zy6SL9hqepxQUxQZi48Y
         ne04e/ZteEjyGgZvzYpJrvRa7bg5zYUrWgd4EHj+kzberrzeQb33K02pMxfMCjUb3g//
         9rXXbviIuaLcYA5F0gWg6XIFANlZI1NERI6arE76UYqEzKeraEG1bSlqtWkYz8yXhwYA
         jP141MyGAhT/zKIeDuQGhoP/wMBMZI8izzOtQbqLuLU0I1f9GuCUPSdb+fErIecK5yYS
         dRPMQCoOaAKyjJ0ue6MvZmUhet0hw+pCquINOdqH/L8sX98Zc33Jxu4/FnrbZSkKWElR
         S0ew==
X-Gm-Message-State: AOAM531+5BGnuCBLaRGmPveekbvSoTOJC0HcXIi+g1RUBkYFdtyzVHhe
        TzTsdOA2/N5oTZoJ+seYEyE=
X-Google-Smtp-Source: ABdhPJxUNOd+tte3KsNMLGZDZlP5K6G9WefrsczD8MfLDc4KrwRIcd7qMIUF9Qn6S8JuJZdf6GXKlQ==
X-Received: by 2002:a05:6512:2116:: with SMTP id q22mr44591832lfr.258.1641320895886;
        Tue, 04 Jan 2022 10:28:15 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.38])
        by smtp.gmail.com with ESMTPSA id o5sm3916843lfk.162.2022.01.04.10.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 10:28:15 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCH v3] ieee802154: atusb: fix uninit value in atusb_set_extended_addr
Date:   Tue,  4 Jan 2022 21:28:06 +0300
Message-Id: <20220104182806.7188-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e8e73fcc-b902-4972-6001-84671361146d@datenfreihafen.org>
References: <e8e73fcc-b902-4972-6001-84671361146d@datenfreihafen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander reported a use of uninitialized value in
atusb_set_extended_addr(), that is caused by reading 0 bytes via
usb_control_msg().

Fix it by validating if the number of bytes transferred is actually
correct, since usb_control_msg() may read less bytes, than was requested
by caller.

Fail log:

BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
 ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
 atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
 atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
 usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396

Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
Reported-by: Alexander Potapenko <glider@google.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v3:
	- Changed atusb_control_msg() to usb_control_msg() in
	  atusb_get_and_show_build(), since request there may read various length
	  data

Changes in v2:
	- Reworked fix approach, since moving to new USB API is not
	  suitable for backporting to stable kernels

---
 drivers/net/ieee802154/atusb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 23ee0b14cbfa..2f5e7b31032a 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -93,7 +93,9 @@ static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
 
 	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
 			      value, index, data, size, timeout);
-	if (ret < 0) {
+	if (ret < size) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		atusb->err = ret;
 		dev_err(&usb_dev->dev,
 			"%s: req 0x%02x val 0x%x idx 0x%x, error %d\n",
@@ -861,9 +863,9 @@ static int atusb_get_and_show_build(struct atusb *atusb)
 	if (!build)
 		return -ENOMEM;
 
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_BUILD, ATUSB_REQ_FROM_DEV, 0, 0,
-				build, ATUSB_BUILD_SIZE, 1000);
+	/* We cannot call atusb_control_msg() here, since this request may read various length data */
+	ret = usb_control_msg(atusb->usb_dev, usb_rcvctrlpipe(usb_dev, 0), ATUSB_BUILD,
+			      ATUSB_REQ_FROM_DEV, 0, 0, build, ATUSB_BUILD_SIZE, 1000);
 	if (ret >= 0) {
 		build[ret] = 0;
 		dev_info(&usb_dev->dev, "Firmware: build %s\n", build);
-- 
2.34.1

