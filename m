Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9682845D8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgJFGMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327C3C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 34so7378935pgo.13
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BNLKh6X7abDI2ONK24Z9VMkrZsBSfKxmcrOIvLnwVgE=;
        b=ujxaciNgyIGB2h3LssEMVCVlBX94zrlLu3fJguod2tJ+HTSb0vQzi2rQRcUNEj/Tcw
         Yg0FtZgWxBVn8gJj/ElBiAjqWa8R0SL5MLouMjckVL0qjY5XQnqD/++i1qSKzvcRBSI1
         wMIqpx4GHU2K4z0MTs++uEKjttwG+qTOEa9eG4JsAnh5Fb+pHSI716lhUzpag9cCsGHl
         LaGKzy1ZwmKBpKbeLMEsA/DlmGXzRbsCo1Oqv4o9wwX9pm8zQWejhqaBTyNTEVdlU8KT
         JUHUuYEoXE7u0kqFmGe12nbI85kObwfktG98Zr/FI8GOPzX9EFfL7Z0YjiDzSm6MWTJ+
         egMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BNLKh6X7abDI2ONK24Z9VMkrZsBSfKxmcrOIvLnwVgE=;
        b=I5gXPjbB6wzD7Q58HH80I7Kg9eOGIcnnyZrJwErNLSa1rt00uTTZpTFvMU7sMFgmtS
         Qpp15YFD+Ud7EqySNcCKOE3W2nRk1qlsMDmaEVAowmhRVYHsmm1MQCaB/teaIzyVHRfx
         0M0IJSrXIqRfkEEIGQMP6ULBA6858V4RoAGKQmsFw6DFxGd7MfWFJf0iJ2rdn8LYHfKa
         niZ0WxLZFr2eH6E0GD9g09QOhu4wubjADlQmsp5vZZ4bw4VFdblKtnX0pzyQ1g8o2i/h
         oLuzk2RYPdVCZ24W4gQqvYimvFnl22Z9fdlanphaVoR+E8/rTs+90NjGZRP8jjOUVMAq
         lb/A==
X-Gm-Message-State: AOAM533PvPV7MSuOFsZeviBLQKwdFTZc10AS9AL6Tp3WHVfHgkvrFWmi
        gI26tALioPs5kwXougL4mKg=
X-Google-Smtp-Source: ABdhPJz2tMp3zxw37SP4I5yMK7z3BDlb5PY+j6FZWwodBZKmQkb4W27TxZQgRiKzqiy0+eqkho1sMg==
X-Received: by 2002:a65:6a0a:: with SMTP id m10mr1391227pgu.162.1601964758788;
        Mon, 05 Oct 2020 23:12:38 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:38 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 06/10] net: hso: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:55 +0530
Message-Id: <20201006061159.292340-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 2bb28db89..3b08a6b5d 100644
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

