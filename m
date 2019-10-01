Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DE9C3168
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbfJAK3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:29:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40220 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfJAK3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:29:41 -0400
Received: by mail-lf1-f67.google.com with SMTP id d17so9452530lfa.7;
        Tue, 01 Oct 2019 03:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEBOz+FE2mSzj8bTRRBXElsPNG8TwUlMu3OH4VYCIKE=;
        b=naeKcQB6yQnQ+b9vyQKNOIoHnXnYPnL5nFnfd+2afwOHI8jPJhslaKcYNYm3eUOksW
         qYqcm3wnmSJG73TcFrcfKzDalgyfVAYgS7XVDNVQCAhXJfSt6ku2C0xqocvyt83s3g4/
         S5MGIbLHFhgyuHCAN3VDiY+CWmWmIbFKNCVHbNOhNODfZ6J0OkGTf/sW4nipFZ+whHfj
         TRkaTevcseTGMtmHbrmREwc5DJRme7kmfIgnOBqSIhgPA6/4eCyKFBHppwhE8qWtTBbg
         7TgqvqDE3KOoZthtIQUMyVPvqwgJYSHKZUwo4J6qM6YnMD2gWm+feWbHNaCPN9b/xJ4I
         3FJw==
X-Gm-Message-State: APjAAAVf+Xdari43MNKHE1WBsILbeA+ZydlnicUs7SAI4rBphLoYfI8F
        AC6+NhIRVUy/R0gNkoEJ+lw=
X-Google-Smtp-Source: APXvYqyTHGCN3wYKNli04woh59rO57J3qnF9hWbaIix7kDk0xpaeXe/u/OtF/L7xZBxd3GVR+r4haw==
X-Received: by 2002:a19:2313:: with SMTP id j19mr12881735lfj.138.1569925779217;
        Tue, 01 Oct 2019 03:29:39 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id t16sm3920399ljj.29.2019.10.01.03.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 03:29:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFFPe-00036A-2a; Tue, 01 Oct 2019 12:29:46 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Bernd Krumboeck <b.krumboeck@gmail.com>
Subject: [PATCH 2/2] can: usb_8dev: fix use-after-free on disconnect
Date:   Tue,  1 Oct 2019 12:29:14 +0200
Message-Id: <20191001102914.4567-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001102914.4567-1-johan@kernel.org>
References: <20191001102914.4567-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was accessing its driver data after having freed it.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Cc: stable <stable@vger.kernel.org>     # 3.9
Cc: Bernd Krumboeck <b.krumboeck@gmail.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/can/usb/usb_8dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index d596a2ad7f78..8fa224b28218 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -996,9 +996,8 @@ static void usb_8dev_disconnect(struct usb_interface *intf)
 		netdev_info(priv->netdev, "device disconnected\n");
 
 		unregister_netdev(priv->netdev);
-		free_candev(priv->netdev);
-
 		unlink_all_urbs(priv);
+		free_candev(priv->netdev);
 	}
 
 }
-- 
2.23.0

