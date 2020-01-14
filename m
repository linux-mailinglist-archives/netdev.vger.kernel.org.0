Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372A413A2F6
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 09:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgANI3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 03:29:03 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46709 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgANI3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 03:29:03 -0500
Received: by mail-lf1-f67.google.com with SMTP id f15so9097256lfl.13;
        Tue, 14 Jan 2020 00:29:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6JoWQ6c1nI2a/4KAhe2hXUFPgw3zf5cddEwtK221+k=;
        b=r/ngl09PBg3qqHFbgm5ihX0AvJwJ+5bxMaCtiRWPGB5CC5g9ixPItUwP8BbkGxKU2h
         hGJPiTUWnV8TdqmMHs2ROH9KkrBheCtrWpOs+iKl0ZyH6v30OQPm5RY6J5OWQzcGgIM6
         ckH4wJbdhOGqhQu94QsVGOX4wkNXM0gd9WKX6fAeHB60VScPNMfluPGGOSii9Kgdq7/k
         mylplU0pwvs9He4Ue7Mnyf/0yaGFHlp65soIknlRnaIcf20Dc2aZAtetn9xlXvJ4gN9R
         PRq4R974fTpkcTLdyux9H/Jwgw8SHLAj9YtQZQi9UZiZlysidzV2tUdRjPLmMfONGSE5
         C1iw==
X-Gm-Message-State: APjAAAVj0WC69ymqszXl/nbzt4LV3bxcDRJ+yXBmeplc5DCPN5Dq3bdm
        ljfsGNzUEYIYy8iCZ3Z9xZRicc3B
X-Google-Smtp-Source: APXvYqyWanTlOyahhkpu8/BqBLzTlgcmC909vzkkKNRx43lDdFz0JG8FFqfN0wFAur+QrcIaWcPHjg==
X-Received: by 2002:a19:710a:: with SMTP id m10mr949535lfc.58.1578990540854;
        Tue, 14 Jan 2020 00:29:00 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id m189sm6881108lfd.92.2020.01.14.00.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 00:28:59 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1irHZL-0006HH-MC; Tue, 14 Jan 2020 09:28:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        hayeswang <hayeswang@realtek.com>
Subject: [PATCH] r8152: add missing endpoint sanity check
Date:   Tue, 14 Jan 2020 09:27:29 +0100
Message-Id: <20200114082729.24063-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing endpoint sanity check to probe in order to prevent a
NULL-pointer dereference (or slab out-of-bounds access) when retrieving
the interrupt-endpoint bInterval on ndo_open() in case a device lacks
the expected endpoints.

Fixes: 40a82917b1d3 ("net/usb/r8152: enable interrupt transfer")
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/r8152.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c5ebf35d2488..031cb8fff909 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6597,6 +6597,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3)
+		return -ENODEV;
+
 	usb_reset_device(udev);
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
-- 
2.24.1

