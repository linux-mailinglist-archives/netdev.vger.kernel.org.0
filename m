Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC95D474626
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 16:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhLNPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 10:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhLNPPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 10:15:19 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16D3C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 07:15:19 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id k64so18066555pfd.11
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 07:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0jwVopDsLat0wO71KLYM/6N+mjIlKSzr++OAWcUsCeI=;
        b=aPXoqQGyoWYWsYgJ12U2jZDVwStyjX3hE/9lpHgrrt1AfCQrr/WUv6mdJETqDz6yE4
         2T+ljq8zsbQpE/wmrCWFw0rz1tp2yXXPVVqOfrxWxG6/Q4S6yVdypKJ7tWRqlXhSBlq2
         qHBdxovEAky2hLNomm5L1XC2XfzVTOaObibTIzxJgeggEhntzS/LiqyTezrCh7H/V4fs
         klMBSP1bj4HaYRNvznPAwXCbS2zzzecJRr153w3XrgFFxVk9JOdDFt61/naJVBoVJZUA
         5AHLdoIUf8In1Pa5NJJ6pAT3M5VmLLr8Orh7MtyfwlupWClFyPOF9qlXAP3t6Q2XHma5
         HwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0jwVopDsLat0wO71KLYM/6N+mjIlKSzr++OAWcUsCeI=;
        b=Gqza9UGElvg5jj3Jd9VZkLj4zh4jMcoCQ/5kHBaEklH9ZVRR7Dyex5sUCDdJnbWb8L
         IqNA/M8ACwYJiPUobYjtSCjmfL21YY85fjPyQ92LH5zbYHBAD72U7R3i1GiFmvvvvBfU
         EDdTTbcuHHGOO3cjl5LLoT4GRhsJxmYG3RheE3Tk5LoZxiBgq0kI7Nh9jHH9C0c7F0k9
         BkU3ybOqJgvfvuLGC4/rbV84PwfwTAhdjhhlPaf1wYzWKIJxGapoxf7S+K0FeigNKOjg
         kkg1HHQYbNaD2n0BiD8AuVIXf6x/BHZWeI1Z76OGC4qR1K4U+OwvkX4RfKphDs/jHwH2
         A8Lg==
X-Gm-Message-State: AOAM533J2Q2zKhnXRMC12jVNPWhdDUcxahEptDOMhcYGsOISL4dhTRrB
        gShXF9DDXPlZayOULq5raVo=
X-Google-Smtp-Source: ABdhPJz3NnUpjOcqDEBDv73ux4S9+6drDquV8Fo0ytxap7I3+syggd+tjoXFfeCGZOrSJFEnRXMTiQ==
X-Received: by 2002:a63:1f16:: with SMTP id f22mr3992343pgf.259.1639494919331;
        Tue, 14 Dec 2021 07:15:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id x16sm135338pfo.165.2021.12.14.07.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 07:15:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: dev_replace_track() cleanup
Date:   Tue, 14 Dec 2021 07:15:15 -0800
Message-Id: <20211214151515.312535-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use existing helpers (netdev_tracker_free()
and netdev_tracker_alloc()) to remove ifdefery.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0ed0a6f0d69d3565c1db9203040838801cd71e99..a419718612c6f82530d67a4540cc86c4bf326f98 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3886,16 +3886,14 @@ static inline void dev_replace_track(struct net_device *odev,
 				     netdevice_tracker *tracker,
 				     gfp_t gfp)
 {
-#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
 	if (odev)
-		ref_tracker_free(&odev->refcnt_tracker, tracker);
-#endif
+		netdev_tracker_free(odev, tracker);
+
 	dev_hold(ndev);
 	dev_put(odev);
-#ifdef CONFIG_NET_DEV_REFCNT_TRACKER
+
 	if (ndev)
-		ref_tracker_alloc(&ndev->refcnt_tracker, tracker, gfp);
-#endif
+		netdev_tracker_alloc(ndev, tracker, gfp);
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
-- 
2.34.1.173.g76aa8bc2d0-goog

