Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7877FB7906
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390192AbfISMNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:13:00 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44585 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388792AbfISMNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:13:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id q11so2160228lfc.11;
        Thu, 19 Sep 2019 05:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AAGhvqwd75jlWoyN7RtLuLmQlBabVo3K+eJUc/Gzlw8=;
        b=I+fWSqLXskt+W9JCVUaVDdgxCjnHs9SngDhZ6ddtTpEHqRqALggs0Pzu9DGLeyUmlU
         s5SntY7fIS15FYNNcS7Bgu8ZuXvdbUE1C0isqFYgjIdHMvI52zPc5si6SWtWbUHvPKI0
         b0EXSvCx5+4/5aIMXUlky8wKD8nv3geoGMhf7Rn80LlcWTxVb8k/MBvu4ogIrQmTa1Bu
         RXvZRgQqaMzIlwFvA+fueRmaT3PU3dgwXup/5ot7kwAgPgVQ4xDRgMJw8sWgHsPrEdkd
         80Wbqpnjqske0K4nPjpA1l5wJdekIJV9rSXiSAbbXl6hJjXX+k/ZuhilCnnflRgBv2Tp
         dhCw==
X-Gm-Message-State: APjAAAUmCei2Y1na09s+VmqxpF5e9VLOhhYNyCng+upbeCL3Q/4uaBPK
        qTO3LCZFmWVgzivdkTgT4Lzgac3/
X-Google-Smtp-Source: APXvYqxkxMhx6AXLEzlWI2uF4kvz8bcFVDoGXg87MGyIpnW1DMdRhVl7Zz7XRH8wHiKEdibwpDoJ3Q==
X-Received: by 2002:a05:6512:251:: with SMTP id b17mr5172700lfo.35.1568895177514;
        Thu, 19 Sep 2019 05:12:57 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id x76sm1859097ljb.81.2019.09.19.05.12.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 05:12:56 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iAvIu-0007yb-AS; Thu, 19 Sep 2019 14:12:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andreyknvl@google.com,
        syzkaller-bugs@googlegroups.com, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com
Subject: [PATCH] ieee802154: atusb: fix use-after-free at disconnect
Date:   Thu, 19 Sep 2019 14:12:34 +0200
Message-Id: <20190919121234.30620-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The disconnect callback was accessing the hardware-descriptor private
data after having having freed it.

Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
Cc: stable <stable@vger.kernel.org>     # 4.2
Cc: Alexander Aring <alex.aring@gmail.com>
Reported-by: syzbot+f4509a9138a1472e7e80@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---

#syz test: https://github.com/google/kasan.git f0df5c1b

 drivers/net/ieee802154/atusb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index ceddb424f887..0dd0ba915ab9 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -1137,10 +1137,11 @@ static void atusb_disconnect(struct usb_interface *interface)
 
 	ieee802154_unregister_hw(atusb->hw);
 
+	usb_put_dev(atusb->usb_dev);
+
 	ieee802154_free_hw(atusb->hw);
 
 	usb_set_intfdata(interface, NULL);
-	usb_put_dev(atusb->usb_dev);
 
 	pr_debug("%s done\n", __func__);
 }
-- 
2.23.0

