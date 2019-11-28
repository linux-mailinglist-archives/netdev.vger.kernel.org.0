Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBFD10CE84
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 19:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfK1S0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 13:26:18 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37424 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1S0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 13:26:18 -0500
Received: by mail-lj1-f196.google.com with SMTP id u17so2033007lja.4;
        Thu, 28 Nov 2019 10:26:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MPGcMjX+exMTcSub0NHeiUr4q94MYBuhn57bxnmgtrs=;
        b=BdSf6Z4KoSpTq+PZluOnpZ/TjnSw+CqZqt4sbLp0x7oZdnZ3eVJ58bM6XAvy4QasmG
         22iYfdX4NTpyxet6IwcJkyTAiR/SfhBE0DKVxuFEUpPdCtFERhhJjjv3xbOz6IHMzSbY
         61TnkqA+ZdsHnC9VJUJq3FI1jCW6d3tF2hwQlYjFp0DvQCiyYXNXcqZ0D7GUgccDU3h5
         aBwT+1w0/zeGT6+lqgfvmVbWCHOZ9HuJxTUjSCcb0qlMi9x9CqaM50aeti3YvFcW48WP
         ltQfr37ws/MPl7md7/9oTO6e1jqd0doO+OsbUUddn7GGQi0I39wv+UG5EQrSu8zeO3sW
         4zvw==
X-Gm-Message-State: APjAAAU+N6NQb+83Gbu9NRYR/ZSL/1N1rneECHnRoY30f0IaYbzo8hvI
        Gmo9l69nI+0f+bJHFxifjhA=
X-Google-Smtp-Source: APXvYqyyQNNbUPNAYvnWV/W9viAgSmzyIoof4zKbnAnEuo52U8xx7P9LUj/6AouADm199i5O2qTkRg==
X-Received: by 2002:a2e:970a:: with SMTP id r10mr36166349lji.142.1574965576587;
        Thu, 28 Nov 2019 10:26:16 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id t6sm8980610lfb.74.2019.11.28.10.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 10:26:15 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaOUa-0005jd-6G; Thu, 28 Nov 2019 19:26:16 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Subject: [PATCH] can: ucan: fix non-atomic allocation in completion handler
Date:   Thu, 28 Nov 2019 19:26:03 +0100
Message-Id: <20191128182603.22004-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB completion handlers are called in atomic context and must
specifically not allocate memory using GFP_KERNEL.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable <stable@vger.kernel.org>     # 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Cc: Martin Elshuber <martin.elshuber@theobroma-systems.com>
Cc: Philipp Tomsich <philipp.tomsich@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/can/usb/ucan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 04aac3bb54ef..81e942f713e6 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -792,7 +792,7 @@ static void ucan_read_bulk_callback(struct urb *urb)
 			  up);
 
 	usb_anchor_urb(urb, &up->rx_urbs);
-	ret = usb_submit_urb(urb, GFP_KERNEL);
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (ret < 0) {
 		netdev_err(up->netdev,
-- 
2.24.0

