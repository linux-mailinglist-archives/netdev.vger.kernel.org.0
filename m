Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27545B897D
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 04:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394717AbfITCo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 22:44:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33290 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388350AbfITCo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 22:44:56 -0400
Received: by mail-io1-f65.google.com with SMTP id m11so12846595ioo.0;
        Thu, 19 Sep 2019 19:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sq73DcwGjyNmmgxGHw+k0dldxyOr7gBfelRaWt6f/sI=;
        b=mU4mom415tumOzOlJX5UYVvszXzNI8OeaB9j5CpxyZiC2hZczbAeYMRxgZ2wdNp1Hb
         e0/S4Jr5p69syNrqQjw78QYV1TCAJbNxLiPKQx0zI38u5U003BD+e+YUVOL3FtPGwFi5
         1Vl5j/WRznRIe7aRxZBUnewmy6+lsVRp7xy4XAeHhsIeCJp3X9p2oBnvNA13NtXhcmtR
         3ISLKBi0tuAyGTckZoXvDAblKVIMHsGPVVSGcEPfA2mWiD0heol4yLiLoloKxv4cVgko
         SYLvGAyGJn1mB/T7D85zgvoFzD9uyiw64xSHQB8Yl6am1d4W/3PS+OjylC1pzKWSyN34
         d71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sq73DcwGjyNmmgxGHw+k0dldxyOr7gBfelRaWt6f/sI=;
        b=jBYBoEfNQN5JKwJXRqjFxyQNCgsyYDLqJ/Y7N3ICIcjJVsMcDA7EsAvEoJMe5DG+3B
         Vu9Q8wCKefUKEr6yX2Shz2YfwFpfczqTT7jG8UDvgb2Sye+ccgPvQtIhI0i3WbvGeUWo
         DNVA1aQ92stajVyyyNThq6mXXpuue+YYLYv/1nn2/JC69dWf/ubwFNcJTCBWFJbBh5Ab
         lGDPJCLGIsIh1Yd15tlCc9uWwhWyK68QH0xwY0cW9p7u3WWNf5Oi75ex/ixQqXk4GLO4
         +i67tyzMXdgco9a5hchLx71FWqmxNsAHUEIld7qSezUOpY7E2SXFof6Uk3XQY9KftVWg
         z1uA==
X-Gm-Message-State: APjAAAXf7lzk6y4UeYkyX6eW1xHEvc2atjYFrpiv+ubgbxOxjwQV+zL/
        f+XPqfr0nHjIqNIybsLssD4=
X-Google-Smtp-Source: APXvYqy1d9AIVd0rkjbrgoInrlqMcm8Ak9F/O7xocoraAdmwNmGsmgzo2PH1zC9UCfF+OqwGymXXMA==
X-Received: by 2002:a6b:254:: with SMTP id 81mr16130169ioc.17.1568947495860;
        Thu, 19 Sep 2019 19:44:55 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id b8sm453375ior.49.2019.09.19.19.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 19:44:55 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: gs_usb: prevent memory leak
Date:   Thu, 19 Sep 2019 21:44:38 -0500
Message-Id: <20190920024445.28214-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gs_can_open if usb_submit_urb fails the allocated urb should be
released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/can/usb/gs_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index bd6eb9967630..2f74f6704c12 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -623,6 +623,7 @@ static int gs_can_open(struct net_device *netdev)
 					   rc);
 
 				usb_unanchor_urb(urb);
+				usb_free_urb(urb);
 				break;
 			}
 
-- 
2.17.1

