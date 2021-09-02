Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6E3FEC78
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245618AbhIBKxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245639AbhIBKxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 06:53:03 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4096C0613CF;
        Thu,  2 Sep 2021 03:51:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id h9so3313330ejs.4;
        Thu, 02 Sep 2021 03:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=aYQipJ0VMF+DJ82QPsrjzMV+k5CzDhFuEU93kEuX82M=;
        b=oSIRzt5gChqkaNbV8/wJNwARxCL7JtebiV8t2ngO6VYDd2zzyriuQ+WyZK21Fs337V
         k3OmWs481pjYukCG29l1cwbFKQqw0Bxs5qR65YZisFwr5MyWdpvRbp2/jENh76qcRArv
         By/uLlSkMZfU4dGxeFbRhrVC2VFdOJUTW2Z5kooyZtq6cQXtJ6XvS2a7w5bn7r014QFI
         h22bQ4+RHBI7huXc8JyNw/zwwlkTL0RzkbGk10QaMg3YBVxKLM0tl4zHONFo6iC/f5OS
         lztDmtXKgnsIGX+M3zHpNsSLb/3PuBA9gfS3IR2AbFlI9OGUJSDaSW8VP/LbBfJSG1Ny
         jq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aYQipJ0VMF+DJ82QPsrjzMV+k5CzDhFuEU93kEuX82M=;
        b=ow5eybAqI+uOybgsqqHwMEFe99lOwYrWT2eyarSYrFH8kXdlAjSYdG0waofjqgg2P2
         DVwsQ9yRdvBErbyeq6234JfsFuNSn//1bJZCgoPV3jg1gipDtZv9nmk0UqbnlIwpQLMt
         ass6ylBHsPyZcwOLon/oZu0keByBTaZ9A1kk3bQRV4KjIM4g3eFGNHry2q3QK+5LbsCa
         +nU9h1rU5Zbw8UBWRbuZXDNwzYCfxg6ijEic6C5f2nFWo2IeNqODXxsVYGWEgu9ITJkH
         38Zeso8edBLWu5wHCDv/dLAJSh64YeHyFYF0GvhlBhQhQR4nVynNlaawct4f/IKUL7b6
         132w==
X-Gm-Message-State: AOAM531K5p7iDua+jWEfPYl63W48DTAfEetmx6iJBV7RcL/uVE6S2TUu
        x6dWe0IfObfc9TRXQhEbTCc=
X-Google-Smtp-Source: ABdhPJwJOtx5inNKHHk4KT8J6wOt8/wbdbp1oqbFpafKfTniu+CYMt5ESwJmUR2TlzJ0nfg7UxFqfg==
X-Received: by 2002:a17:906:a399:: with SMTP id k25mr3141961ejz.514.1630579898095;
        Thu, 02 Sep 2021 03:51:38 -0700 (PDT)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id s20sm938798ejx.82.2021.09.02.03.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 03:51:37 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
Date:   Thu,  2 Sep 2021 12:51:22 +0200
Message-Id: <20210902105122.15689-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit LN920
0x1061 composition in order to avoid bind error.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 4c4ab7b38d78..82bb5ed94c48 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -654,6 +654,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit LN920 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1061, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.17.1

