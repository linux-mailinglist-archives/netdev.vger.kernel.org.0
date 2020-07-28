Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA452309AA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgG1MLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:11:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45998 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgG1MLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:11:35 -0400
Received: by mail-lj1-f193.google.com with SMTP id r19so20819382ljn.12;
        Tue, 28 Jul 2020 05:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HZihSth8sxHseb5CAqThMzv8CFkUGVPv5HlzdDNm7OM=;
        b=GDqVYmqogkSDDTnW7Z/rcVxLVf3JdisDrRurzlb9Mz5g99op6ls+PFvEqGYF4t7GcG
         j+dYZJNyn4FN3+trOW8w1BVjL4bMAvmSWA/gEg2dgKzv17gA8x5ttSIuXl1hmeaEjUM4
         pBhYNxMZHvj0OKu22Tl2tXRIN03GloifSaAtHebyQsmfMeWT+YKNzNMp7akA9UhvSdhv
         UT0zS0j4yGFu3VlUIjMLrUndeFE27fK9aUtBWZdEsGLosVqNaZJ87FEJse03I3EbtHb2
         caGR5FAkusyyEUrxh1qbrDk8HJgT/lCRkyJlYQkORZpAN/FYjHQCPxiyGMg+vYRV/Pqs
         nQ7w==
X-Gm-Message-State: AOAM533ffAb/ee3XL+UXPxcVDY5b083UrAshNGwDQJAvHa8gjbLYSeEt
        0zgqKDAlGQMTH1ky9sU0+C8=
X-Google-Smtp-Source: ABdhPJyrQt/ZrM783lj6kRb0W8svGfeXFa1wCBVVs2p98sADauOkMGa8ifznUUChWFLcrJmuV79hgA==
X-Received: by 2002:a2e:9555:: with SMTP id t21mr12800427ljh.194.1595938292488;
        Tue, 28 Jul 2020 05:11:32 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id g19sm3749699lfd.28.2020.07.28.05.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:11:30 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1k0OS6-0003Ds-CH; Tue, 28 Jul 2020 14:11:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        "Woojung . Huh @ microchip . com" <Woojung.Huh@microchip.com>
Subject: [PATCH net 2/3] net: lan78xx: fix transfer-buffer memory leak
Date:   Tue, 28 Jul 2020 14:10:30 +0200
Message-Id: <20200728121031.12323-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728121031.12323-1-johan@kernel.org>
References: <20200728121031.12323-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interrupt URB transfer-buffer was never freed on disconnect or after
probe errors.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: Woojung.Huh@microchip.com <Woojung.Huh@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/lan78xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index d7162690e3f3..ee062b27cfa7 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3788,6 +3788,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 			usb_fill_int_urb(dev->urb_intr, dev->udev,
 					 dev->pipe_intr, buf, maxp,
 					 intr_complete, dev, period);
+			dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
 		}
 	}
 
-- 
2.26.2

