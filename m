Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34859482805
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 18:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiAARWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 12:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiAARWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 12:22:53 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD0AC061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 09:22:52 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w16so119438183edc.11
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 09:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toye.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hc+07H6dH46gQr5iS1ZC+n4VxoHVX1nqU+9tIGJPDqU=;
        b=RjwQypmp9IOpEvvHdM457I/4/S0qTZGYJm2S3tSD4aXoH9OTGPd4JEHL9hbBZTP9wC
         sOhiHlnYm/faNkCQoB42QD+Xv2+y/L8n9mkWLBkNc4cfe5gBANgWFAlKbAf3GQPul5KN
         g7b+D/xFt9IsNyDjEXadcS9bOLKlt2XOsiakI1SUhBewk2GmsX1Gqqjl21sobSnYi4Il
         3rk50j7NzbY0189GeTj+pDqKTmgtqf/6NxwCuJpPr+jaMoToSzB3qoYgM5pmUrr43T47
         B6Kvi7XyIWflikgUYmsSFETyfZlFrcCnAUa0ALlNkUzaSdYANtXj/bMZG2Gu/a/HXX+X
         eFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hc+07H6dH46gQr5iS1ZC+n4VxoHVX1nqU+9tIGJPDqU=;
        b=p4BiEVNxBtwWO3WvCtLKqklfw0jywdlOk9ht46U370Lvy7R7CKbA5hYXzcBXVnPMAy
         PH5RmfTX1uXR8QMqcf2p1VaYwdd0hsoHVGzvuuvLCxYcBdi4VVnWBKLEHmS/01bAtqLW
         RBdldSHMVj9LwxXDzVFfawPd06p+E+sXMUKZS9bjGDQcCHx3LbUWLsaywOEWcetjT1lr
         XL11mybCJcPknZ1F7nIAKY8F8chCCGSQ/7rNmQZRh8oaS/mjBsiNkXpGZ6T66KbZxk/d
         uU8oNv/Xcg/or4yCAwkWZym5DnrpEGWta9OlnnUv8obNWxoQYFCQwINV0ns78klFnIeu
         1IXA==
X-Gm-Message-State: AOAM533nrV3BAF+8ZQmWSpsSAQg4Pfys/4HpVmn8lOwJh0qrCZo33ukZ
        aZWfXShXEUjcw4A+VTNuaQgqng==
X-Google-Smtp-Source: ABdhPJyTdxmgSKSToze3ox6Jj9Ts8iaqUSjgeoCLLna9AChKfVYVmutkdUmMwJNHsE1uwa+y+erzmg==
X-Received: by 2002:a17:907:2ce2:: with SMTP id hz2mr33246500ejc.133.1641057770982;
        Sat, 01 Jan 2022 09:22:50 -0800 (PST)
Received: from DV-30001.fritz.box (94.105.124.19.dyn.edpnet.net. [94.105.124.19])
        by smtp.gmail.com with ESMTPSA id 26sm9297432ejk.166.2022.01.01.09.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jan 2022 09:22:50 -0800 (PST)
From:   Thomas Toye <thomas@toye.io>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Thomas Toye <thomas@toye.io>
Subject: [PATCH] rndis_host: support Hytera digital radios
Date:   Sat,  1 Jan 2022 18:22:07 +0100
Message-Id: <20220101172207.129863-1-thomas@toye.io>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hytera makes a range of digital (DMR) radios. These radios can be
programmed to a allow a computer to control them over Ethernet over USB,
either using NCM or RNDIS.

This commit adds support for RNDIS for Hytera radios. I tested with a
Hytera PD785 and a Hytera MD785G. When these radios are programmed to
set up a Radio to PC Network using RNDIS, an USB interface will be added
with class 2 (Communications), subclass 2 (Abstract Modem Control) and
an interface protocol of 255 ("vendor specific" - lsusb even hints "MSFT
RNDIS?").

This patch is similar to the solution of this StackOverflow user, but
that only works for the Hytera MD785:
https://stackoverflow.com/a/53550858

To use the "Radio to PC Network" functionality of Hytera DMR radios, the
radios need to be programmed correctly in CPS (Hytera's Customer
Programming Software). "Forward to PC" should be checked in "Network"
(under "General Setting" in "Conventional") and the "USB Network
Communication Protocol" should be set to RNDIS.

Signed-off-by: Thomas Toye <thomas@toye.io>
---
 drivers/net/usb/rndis_host.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 4a84f90e377c..247f58cb0f84 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -608,6 +608,11 @@ static const struct usb_device_id	products [] = {
 	USB_DEVICE_AND_INTERFACE_INFO(0x1630, 0x0042,
 				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
 	.driver_info = (unsigned long) &rndis_poll_status_info,
+}, {
+	/* Hytera Communications DMR radios' "Radio to PC Network" */
+	USB_VENDOR_AND_INTERFACE_INFO(0x238b,
+				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
+	.driver_info = (unsigned long)&rndis_info,
 }, {
 	/* RNDIS is MSFT's un-official variant of CDC ACM */
 	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
-- 
2.31.1

