Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4A04830DE
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 13:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiACMJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 07:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiACMJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 07:09:31 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B83C061761;
        Mon,  3 Jan 2022 04:09:30 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id t14so27063490ljh.8;
        Mon, 03 Jan 2022 04:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UukyjmK4YO+JAfUbdkXWjCdeVRCY8BxgquJ5yskx9Jg=;
        b=aWUjFGhW5nXqlUcE7KmEecswKjBKIAnC3Z9I1LFR8jbC/fgxjalQLBA223E/WVevze
         8EV8FDkB45ybcG8GQS5BR0yVpoqbNLDtgjBhiwRR26Lb8HSKecTGYyVYH8UnX/anh/+Y
         N51E050c1fuesDk0W+xjM1XoDfaALSyL6Yf7yQyjhjU8r671dgmSZQqmec9kySaDEy3Q
         MjprMLZUrvf4BkImDsYefPhVpCpVuVe11yylvToXOTMbXdgOmIRZqUM43m7TYFnXrFwu
         ft5JLvOc2RUffhyTPAwenFX1nkfntD9fjB5lKgFuHtx8o+tS4WJaA6zA4A9pXdeixzkU
         AlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UukyjmK4YO+JAfUbdkXWjCdeVRCY8BxgquJ5yskx9Jg=;
        b=Xt8PInwsu22XmEeVtwHr5Jp1EDxFViYPWdL5pTXUKykz/GlWAjp8LjouGj7R3dQKG9
         63BXjwp3k/Wby8iib/9kMaYlH7k+vGyYsX3PbbbVZXs+EraMUGA+7zfV2danpUvALrn9
         BPuqhurRnelQw/jic+utP71zqzYUQ0+gA8CVY5svB2yRgHVX2allMPxZT3EETdYuoGC6
         K1J2vZwxhpTdJ0bbH3ikizpjqiIkq4Q249wHCdL6OGxk0fd1TaCdA2yrpXibEO/bjQMt
         BDYVV78h1k/y2zLH7HtEXgLEPWCMDUh/ahlBjxYT4I1U4TomhCuMw0hVkngnzNZRZi37
         L2Pg==
X-Gm-Message-State: AOAM532o1GvPxi1T3WEg2fNee9C+FUEYgcd81/HJvcwnd+t8SQR+xcFo
        /2i/vKryOyKZIqQjC6BjLgc=
X-Google-Smtp-Source: ABdhPJweKSRJfLpRC+gpZp4f8LcMCQwhZRJtQqwFODRf7noArKTJotGPveDtQ0YDV14jVg+24kjkXw==
X-Received: by 2002:a2e:87d6:: with SMTP id v22mr37373886ljj.251.1641211768710;
        Mon, 03 Jan 2022 04:09:28 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.100])
        by smtp.gmail.com with ESMTPSA id y7sm3359433lfb.272.2022.01.03.04.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 04:09:28 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Alexander Potapenko <glider@google.com>
Subject: [PATCH v2] ieee802154: atusb: fix uninit value in atusb_set_extended_addr
Date:   Mon,  3 Jan 2022 15:09:25 +0300
Message-Id: <20220103120925.25207-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
References: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
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
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	- Reworked fix approach, since moving to new USB API is not
	  suitable for backporting to stable kernels

---
 drivers/net/ieee802154/atusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 23ee0b14cbfa..e6cc816dd7a1 100644
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
-- 
2.34.1

