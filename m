Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3EB6E142A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390324AbfJWI13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:27:29 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45076 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390260AbfJWI13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:27:29 -0400
Received: by mail-lf1-f68.google.com with SMTP id v8so14738739lfa.12;
        Wed, 23 Oct 2019 01:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+BrgSnZCer5UhRsZl4X7zqgqCerRzQvBH6cwLmm1CnM=;
        b=HI/6Ls542Gr4OKd2Ngr8Ak3SU1zpNWkkmq+6GBvXR8AHzw+qZOmWsyGKHHxpnEOnpz
         YLSzpQGx67Xkx/cXesSM20PlRkyOrX9/RUsnb6PV63EEq8hY6YFHYMgCFl+iaW28J6qB
         5ZPNIh0Reh509Rddtku+ngn+DbbVK/k8PXxIIOTek1XmebPVTCL4D/inITSNk0PoQ98o
         1P4IGRJ4AOL5D/08h9OJKNG148BhQDovoUDgjeU5t19FPRuovYRjBhHNI1YneNu7VUvA
         O9DzPPieGsRlCxQLD/O42wqtFakq+kfpP6TE8m0PhigGhmRELZYU3KzY347tHU0dX3gH
         bFbg==
X-Gm-Message-State: APjAAAXlui92r8iAVPdlkt5Vr9e9sF3n+np3ABK/yGuIToOuIFyjeG6X
        ViAWiZ1HcUKsWJrvy9Asgh6esPiW
X-Google-Smtp-Source: APXvYqw+9/yUnQGsArwINEUVGFu4MzLP/NJVoAT3Vw0w3glyFhkEnq2gFz1VWCtf6lPdUnJevJNOzg==
X-Received: by 2002:ac2:5507:: with SMTP id j7mr22043724lfk.75.1571819247001;
        Wed, 23 Oct 2019 01:27:27 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id n3sm9001439lfl.62.2019.10.23.01.27.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 01:27:26 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iNBza-00064N-Md; Wed, 23 Oct 2019 10:27:42 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+863724e7128e14b26732@syzkaller.appspotmail.com
Subject: [PATCH] can: peak_usb: fix slab info leak
Date:   Wed, 23 Oct 2019 10:27:05 +0200
Message-Id: <20191023082705.23283-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <0000000000007a638805951153c5@google.com>
References: <0000000000007a638805951153c5@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a small slab info leak due to a failure to clear the command buffer
at allocation.

The first 16 bytes of the command buffer are always sent to the device
in pcan_usb_send_cmd() even though only the first two may have been
initialised in case no argument payload is provided (e.g. when waiting
for a response).

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Cc: stable <stable@vger.kernel.org>     # 3.4
Reported-by: syzbot+863724e7128e14b26732@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 65dce642b86b..0b7766b715fd 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -750,7 +750,7 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 	dev = netdev_priv(netdev);
 
 	/* allocate a buffer large enough to send commands */
-	dev->cmd_buf = kmalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
+	dev->cmd_buf = kzalloc(PCAN_USB_MAX_CMD_LEN, GFP_KERNEL);
 	if (!dev->cmd_buf) {
 		err = -ENOMEM;
 		goto lbl_free_candev;
-- 
2.23.0

