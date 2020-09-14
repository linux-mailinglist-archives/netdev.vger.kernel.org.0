Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73EB268614
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgINHds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgINHcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045EAC061788;
        Mon, 14 Sep 2020 00:32:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id v14so3569801pjd.4;
        Mon, 14 Sep 2020 00:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vXVn2f2CIbFk/dtG+DnZgKzF4bw+yeaDsB5JX4aytA8=;
        b=Fhnc0u7/xXp5L8O7sHdpLvzT28gX2N1VjTFJz5kOgLz2knWODextBYJwoa0N/71bI9
         7XBRXxHlw2SCrC7UWbrOO7S03aoPlTuqb6A13U/EH6b0VMZhvjpv2Q2M3+J2gVCwWuZP
         Pna9VshaGE2oFwJrGos6KgqzWOwf49KZYUap6uAwV/bkW6ivj3zXmS3/AgsxmCY96wga
         w8dVsptH03Wa2oYIBYG/A8T2jOEhj6goTBwZOhNP9Y5ssLg2x9GhiT5lwf0bY1ZLOwRV
         KCBtowYImV67Xr2NhTenRmCr8nKpV54GgTggZBb92SEpJanQx8xTSOCZDkF0p1y4XKQB
         wxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXVn2f2CIbFk/dtG+DnZgKzF4bw+yeaDsB5JX4aytA8=;
        b=EWrPmBN3Yv3942rMKQiG6sbsj8Fa2FGq25Z0sowb6Qmj+2/cy1cKM5o63BveLoKvCA
         OunUcT2HV5F5am75+1iiSjhjz/V7kRgs3kRptxDaHAdLdCehazP9yNhyoLOKqdNOrerQ
         pXbX+nnDz8dU/KRD2E7Yw4uE52fVE4mPe7yEprgQKzDJqjIeHOLK2ZY5toTdL9u9MBV5
         30mN9XAe2Fene9nKqKKoCOPb5EitUeP3y/LUwA5O/o62MbIdQsD0uKEQDlcu4Rh35Wh2
         q309sgC8ub6aUMqwsELJJiT0XmlTDHUZyUNlMBHW0YibroDjqp3ia3Lp1D2f2hOqCsT+
         4vYg==
X-Gm-Message-State: AOAM531UiImaZSdimywpvkhcNvaXJ2ZFjGln6HS49KdWwNFlaqHC43cq
        uwUguWfTsDEmBLZa/OkGy/4=
X-Google-Smtp-Source: ABdhPJw7dqp1dh8Kwsl4s5SEoaDCbfDmR3ZWlmjMgVAkvwkGRtX9Id5c/g+PqPJG9HSGwkaL+zQYiA==
X-Received: by 2002:a17:90a:f187:: with SMTP id bv7mr11756514pjb.63.1600068731511;
        Mon, 14 Sep 2020 00:32:11 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:11 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 07/12] net: hso: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:26 +0530
Message-Id: <20200914073131.803374-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/usb/hso.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 2bb28db89432..3b08a6b5db05 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1213,9 +1213,10 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
  * This needs to be a tasklet otherwise we will
  * end up recursively calling this function.
  */
-static void hso_unthrottle_tasklet(unsigned long data)
+static void hso_unthrottle_tasklet(struct tasklet_struct *t)
 {
-	struct hso_serial *serial = (struct hso_serial *)data;
+	struct hso_serial *serial = from_tasklet(serial, t,
+						 unthrottle_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -1264,9 +1265,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
-		tasklet_init(&serial->unthrottle_tasklet,
-			     hso_unthrottle_tasklet,
-			     (unsigned long)serial);
+		tasklet_setup(&serial->unthrottle_tasklet,
+			      hso_unthrottle_tasklet);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
 			hso_stop_serial_device(serial->parent);
-- 
2.25.1

