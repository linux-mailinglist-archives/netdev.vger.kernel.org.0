Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00E4C3165
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfJAK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:29:41 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36534 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfJAK3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:29:40 -0400
Received: by mail-lf1-f67.google.com with SMTP id x80so9464818lff.3;
        Tue, 01 Oct 2019 03:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4ymK0rjtC21S8mmu+jb54BEtu4vxPDPz2X3rodFDcE=;
        b=TnL/GwWiqoCUYpg7TGWhrqsur1ks3G/DOLPZ3RASf66fdoCOvQxM3ZGUMPkbvwnDo6
         HewIHxAHJ/2lwkEi1h6Bhpuj88XAZm5eLz8KJVs02VWEIqjCMghmehJh3FxJEcO9FVOU
         mxByDRbJsCiBwnlo4Q0gJCBFdTjx3EPdxe3J7i6i/lzVpV9JqOKQQ2l1su3TjXk1v2n9
         ycEIkuqOD4Ry+5oBkowhJVQUtQHXKYs+yHnSSh7xy7U1Ly4cUxXGEuu6/FLYJtci/8As
         BIfF1Jvt22zj+C2R+zW3B0PDSDCR9a458YT4oF5dcvhzs2pMOLkMgvhsvaXgCsYaM3Lh
         by3g==
X-Gm-Message-State: APjAAAXvp4xyCbvNUhq1YT+AmBHIlXPDI1QYM7vBvwz5ntLhiaJNl2aT
        7TRvLAUI/xXCK44xDBEE/54=
X-Google-Smtp-Source: APXvYqzp2qPO8N0e/hx+heiBHZfiYdwL3P95gV/OAEGpNUR+SKZqRYWURTv0EzcOfWr70QTJy/lj/Q==
X-Received: by 2002:a19:ef17:: with SMTP id n23mr13859903lfh.109.1569925778475;
        Tue, 01 Oct 2019 03:29:38 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id s7sm3921124ljs.16.2019.10.01.03.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 03:29:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iFFPd-000365-VW; Tue, 01 Oct 2019 12:29:46 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>,
        syzbot+e29b17e5042bbc56fae9@syzkaller.appspotmail.com
Subject: [PATCH 1/2] can: mcba_usb: fix use-after-free on disconnect
Date:   Tue,  1 Oct 2019 12:29:13 +0200
Message-Id: <20191001102914.4567-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191001102914.4567-1-johan@kernel.org>
References: <20191001102914.4567-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was accessing its driver data after having freed it.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Cc: stable <stable@vger.kernel.org>     # 4.12
Cc: Remigiusz Kołłątaj <remigiusz.kollataj@mobica.com>
Reported-by: syzbot+e29b17e5042bbc56fae9@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/can/usb/mcba_usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 19a702ac49e4..21faa2ec4632 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -876,9 +876,8 @@ static void mcba_usb_disconnect(struct usb_interface *intf)
 	netdev_info(priv->netdev, "device disconnected\n");
 
 	unregister_candev(priv->netdev);
-	free_candev(priv->netdev);
-
 	mcba_urb_unlink(priv);
+	free_candev(priv->netdev);
 }
 
 static struct usb_driver mcba_usb_driver = {
-- 
2.23.0

