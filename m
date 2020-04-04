Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B666B19E2AF
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 06:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDDETK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 00:19:10 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40766 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgDDETJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 00:19:09 -0400
Received: by mail-pj1-f68.google.com with SMTP id kx8so3944489pjb.5;
        Fri, 03 Apr 2020 21:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yq90R1ChPo01DKE+vGGcyZ7cCjwLF959SgoAd6GnpmI=;
        b=TsULofCQUK1SA2fIoyYyeIz9s5LIYrylWbPGTm2KFYcxT/oEwFSYy8E32uJYSBdhXm
         ZXULeo3wGdFrihRrmWAR5P4qIQPkdNP0H7Quyx2MH49EcmhL3DOHpnhbZWSP50DY8rd5
         pIw2sNpHnN08mVR9P1bimUrh4wB8qxf9Jf25fK6JhySUnmwmhdTG7h4KONTmTvXlECiK
         KA2vieZ5xJpZtNjgqL+KlfLcMGVW5t2bTpc9szpoX109/yI3QHB2odSHFms4xN4rqJcj
         xuVOKHv2aZB4X9zM6Wv+UFKT/EIOorEDEKPkITJhF+gUA/f/QJ70ska0JbOMZIEmXz6E
         VYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yq90R1ChPo01DKE+vGGcyZ7cCjwLF959SgoAd6GnpmI=;
        b=V9u4TKjVvBftzD4WsKdduZgD08G0taFMaWjKPUQQy7EUq+EmURTgyUu+HHnTANhDuz
         ndgT3W00TWFSPtPGcJwZGVmqrpQPvabZSQF1262jHMatkhuV85FtzMPrMYpMTd2SmdUp
         8fYe7BBVkUDHOQRD4Exfy/pUWMInhS7jdclnetII7IP9XEvWkIHqgywgv8SYLXyvF9jv
         v+JGCcAZXs/nFpEB2fHPdD5LqpcC7jOiRuv6ftMVOUGKwotJjwCgYpteK+2dU5pVpldv
         rjzI1USEqa4zD9R7oFcrlF/Khkjp7EB7WDwT/7h6uGW8AoiorOBhznNQnKcwnBjtzCHe
         W6bw==
X-Gm-Message-State: AGi0PuZfhWfsNHFqM6n58ROpGArW81ziuWdq+xvI46+qCHj1dyqhZf3N
        HfnsArzdUOWe1iw+JszbBMU=
X-Google-Smtp-Source: APiQypJtSfXYUFG5f6haY403zyeENQ4dYBauWnjYAr/aFINO1gi6ps+kcIQK7oiapM8cO80UVRAcUg==
X-Received: by 2002:a17:902:8492:: with SMTP id c18mr11266104plo.147.1585973947972;
        Fri, 03 Apr 2020 21:19:07 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id b16sm6834500pfb.71.2020.04.03.21.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Apr 2020 21:19:07 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 3/5] ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
Date:   Sat,  4 Apr 2020 12:18:36 +0800
Message-Id: <20200404041838.10426-4-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200404041838.10426-1-hqjagain@gmail.com>
References: <20200404041838.10426-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Write out of slab bounds. We should check epid.

The case reported by syzbot:
https://lore.kernel.org/linux-usb/0000000000006ac55b05a1c05d72@google.com
BUG: KASAN: use-after-free in htc_process_conn_rsp
drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
BUG: KASAN: use-after-free in ath9k_htc_rx_msg+0xa25/0xaf0
drivers/net/wireless/ath/ath9k/htc_hst.c:443
Write of size 2 at addr ffff8881cea291f0 by task swapper/1/0

Call Trace:
 htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131
[inline]
ath9k_htc_rx_msg+0xa25/0xaf0
drivers/net/wireless/ath/ath9k/htc_hst.c:443
ath9k_hif_usb_reg_in_cb+0x1ba/0x630
drivers/net/wireless/ath/ath9k/hif_usb.c:718
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786

Reported-and-tested-by: syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 1bf63a4efb4c..d2e062eaf561 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -113,6 +113,9 @@ static void htc_process_conn_rsp(struct htc_target *target,
 
 	if (svc_rspmsg->status == HTC_SERVICE_SUCCESS) {
 		epid = svc_rspmsg->endpoint_id;
+		if (epid < 0 || epid >= ENDPOINT_MAX)
+			return;
+
 		service_id = be16_to_cpu(svc_rspmsg->service_id);
 		max_msglen = be16_to_cpu(svc_rspmsg->max_msg_len);
 		endpoint = &target->endpoint[epid];
-- 
2.17.1

