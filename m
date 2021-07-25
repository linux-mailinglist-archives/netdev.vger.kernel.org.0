Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFED03D4D22
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 12:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGYJ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhGYJ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 05:56:08 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1414BC061757;
        Sun, 25 Jul 2021 03:36:39 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id n6so7460371ljp.9;
        Sun, 25 Jul 2021 03:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aarvg0TTfvKjkSQKBsj6uJsxUeEpwsw54ucZqfr+0m8=;
        b=pZBE315Zem6xl19QuzZbVTJiHj8club9EojyADJ1KPPmp7IRobtURFM0nUGbpZn2XN
         0YjwoAVZ4Wp4afGR1XPqedgl/qxXGZwQfryni6/bZ3npA+3nDuxZ7uHDQWgOamui0vbj
         CHvd3nK1FOPmXSgt1WD9rYG7ie78FKkC89nyXkTp+Qx/sL5Jk+z9Gc7+PyeIu1syTdd9
         qT7C3XObRwgLyOfl0CXUC9iOl0OT+MeAV2C3etqJeS2FOc5Hwft0uKlRDXM8V4hHXhJ+
         LohOB8CZsGJQXBW2kYyouC6MMpEKa9L4LWNBniTPewPk1IFx02SyWT7ATEWUneU5NAXL
         U32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aarvg0TTfvKjkSQKBsj6uJsxUeEpwsw54ucZqfr+0m8=;
        b=G0cQVqfHNgsLmnEH3UA5A7B7nz7db+pwNkALX/b5xzSsMAQv/OPJXbyt5pH7ZBwLEj
         y68WQ/mt3S1ymF8JBJp5Wrc+pZsp8A2Pu6iikR6g376GYNHhvuxJSwEe7yIqmizitAix
         Whfo85Maw/xsBW25ZJXeZgZAv5hmNZUD6U7gZty57wNFdGvcLmECDeu43ZoBGqVhl8IT
         Xsd02h2bx1T170gP0irxHQfYyF5RjYSj0ytCd0YzGQ+ZI4eN0iJhEvM5kPNEEi6C5JTS
         HEX6zjthj+ppz79lWEzew0hbGNJArOoZdotiEI/czWHW9kyTk6kLzSkcJO2wiSGkJAbn
         xynw==
X-Gm-Message-State: AOAM5336KxbKujJn+8Cpj7VyxB9Pqd4simujEWril9QCjHO/S8hYG6ZU
        viXrSc8oYAwtSwrvmAKaIFg=
X-Google-Smtp-Source: ABdhPJyrriP/Txq+Lo0VtCC89NtRAXqKJuiwNHXOtwIwokKp6y/aZ59fLsssbeStCA+a/Tt+t/WiuQ==
X-Received: by 2002:a2e:950:: with SMTP id 77mr8806854ljj.438.1627209397132;
        Sun, 25 Jul 2021 03:36:37 -0700 (PDT)
Received: from localhost.localdomain ([2a00:1fa0:81a:8fc0:522:ed96:7da0:a814])
        by smtp.gmail.com with ESMTPSA id y27sm94421lfa.260.2021.07.25.03.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 03:36:36 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mkl@pengutronix.de, yasushi.shoji@gmail.com, wg@grandegger.com
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: can: add missing urb->transfer_dma initialization
Date:   Sun, 25 Jul 2021 13:36:30 +0300
Message-Id: <20210725103630.23864-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210725094246.pkdpvl5aaaftur3a@pengutronix.de>
References: <20210725094246.pkdpvl5aaaftur3a@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yasushi reported, that his Microchip CAN Analyzer stopped working since
commit 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb").
The problem was in missing urb->transfer_dma initialization.

In my previous patch to this driver I refactored mcba_usb_start() code to
avoid leaking usb coherent buffers. To achive it, I passed local stack
variable to usb_alloc_coherent() and then saved it to private array to
correctly free all coherent buffers on ->close() call. But I forgot to
inialize urb->transfer_dma with variable passed to usb_alloc_coherent().

All of this was causing device to not work, since dma addr 0 is not valid
and following log can be found on bug report page, which points exactly to
problem described above.

[   33.862175] DMAR: [DMA Write] Request device [00:14.0] PASID ffffffff fault addr 0 [fault reason 05] PTE Write access is not set

Bug report: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=990850

Reported-by: Yasushi SHOJI <yasushi.shoji@gmail.com>
Fixes: 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/mcba_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index a45865bd7254..a1a154c08b7f 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -653,6 +653,8 @@ static int mcba_usb_start(struct mcba_priv *priv)
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, priv->udev,
 				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
 				  buf, MCBA_USB_RX_BUFF_SIZE,
-- 
2.32.0

