Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9924D8DCA0
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfHNSDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:03:49 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38364 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbfHNSDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:03:49 -0400
Received: by mail-yw1-f66.google.com with SMTP id f187so41242220ywa.5;
        Wed, 14 Aug 2019 11:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8roDqYagqdov0dRisOdJRYmdDHGishknZOAa8DLUHlU=;
        b=aE0rMBfmSyfzqK8QLbHMRP0A0gQEvk7MY5SRcvdrq1BUef9yRTPpMovCtoFyh/SIBL
         dkvJ7n0DeVBXW93BrPpsffre2l5ZG3ar5DSoYSC7Xvg4rriE2MEdO7Xz/97gq3IJsrgu
         7iBfI6hnr627S1hSD6iOdx07un4Tn5RXcNp8h+7M+TKdRQvbdz7LEe8C0BhGXzYrQdFz
         14yuX9/BzxW1xiQ/2S4Wnauj0ZQG1b8LGBQ9RXr5bpCcNvEwVSytFAnCu/B6/S8PJhVX
         IKUtIX5qP5oXTaZOonRNJEZc3rTrz3aWa7Xyo2hymrTrL/cTNpQoWg4a8SvkY+DnPi1E
         IA2A==
X-Gm-Message-State: APjAAAWtLYD2+vFkXQZ0g5SwTXAE1OkLDls3Cl6URiLz8h/YTJOtbXDv
        tkwQFQ0MUm/yrpBeL7unY/w=
X-Google-Smtp-Source: APXvYqyGDEqJ6IaHXZtq3dP9X2b7E9LwgRi20nZ+bGBOYSQRnke/5cofy4HqnguV/nHuU5tzbIsczA==
X-Received: by 2002:a81:2c4:: with SMTP id 187mr374868ywc.472.1565805828339;
        Wed, 14 Aug 2019 11:03:48 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id v141sm107387ywe.66.2019.08.14.11.03.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 11:03:47 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Winslow <swinslow@gmail.com>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] cx82310_eth: fix a memory leak bug
Date:   Wed, 14 Aug 2019 13:03:38 -0500
Message-Id: <1565805819-8113-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cx82310_bind(), 'dev->partial_data' is allocated through kmalloc().
Then, the execution waits for the firmware to become ready. If the firmware
is not ready in time, the execution is terminated. However, the allocated
'dev->partial_data' is not deallocated on this path, leading to a memory
leak bug. To fix this issue, free 'dev->partial_data' before returning the
error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/usb/cx82310_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 5519248..32b08b1 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -163,7 +163,8 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 	if (!timeout) {
 		dev_err(&udev->dev, "firmware not ready in time\n");
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto err;
 	}
 
 	/* enable ethernet mode (?) */
-- 
2.7.4

