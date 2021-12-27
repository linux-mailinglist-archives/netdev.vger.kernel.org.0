Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AC47FD4B
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 14:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhL0NTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 08:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhL0NTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 08:19:22 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3205DC06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 05:19:21 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id m200so8572859vka.6
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 05:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=a38JSinn6KGDl7s2dZ5j9DvJA5cTm6pRNLn1Do3OpbM=;
        b=Td9zBgf+8LvoYGqM1W1HTekFTTSf5ZLojhZlPd1gOuSmOlralfxnewnCu9/57IyXQC
         htUK71RuhW1e+WC7G/K/vxZ6AGGQ13f2m9+yTiitCwmcA3Mph2lqTERZC8bjMCLdBAlz
         y6gqTqPIq46bjMxYj5uZSoqOVPmaOld+DgO8gIJW0RpUBu/UUSkdqVnSPZNSKfesLCNo
         dtdMvL4+Zzjc66O0KXodrywD4eyumjcE9V6Nak0jshBfeD/y+4Mlbv+5EQliHOVPQnFy
         ci8LVRb7i2Kz/34fQn0uDpiNUb9pyskRP0WZp6KS01C6ZQSmabEl12CEUVNyzOLR25+X
         YNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=a38JSinn6KGDl7s2dZ5j9DvJA5cTm6pRNLn1Do3OpbM=;
        b=HYgcTrkCytbMjvXxmUT0UZJbtBrZLQJCpjsx8UBH/lHSq+SfmExtZVj1F2HzyQt3vb
         0x0H1dF7gBBVdFej1gwqeRB5hwc0pMLErmwbzjdu7MmNKcm+UIB6dVWqpMlCYHHzuwFQ
         40Zsy4zWMvLXWuBCDqVG453Vnsr2M7G2djZEuWbIPIn/x7xB+QOY0g9JoA4t3XT+GBYI
         vuRtdKNL2bqd5UBaVNKn4p8jU6KjWMCAbXU1lt1CnZ66m6w8Ka9nlgso9MCbJHMM/XH1
         r5x8Ya08/v+DVx2u/6Dfkom15Rbs5L3dNRYDxf+iuJQNzlSWzb6kw88vk6N/r2UyTA5J
         qiWw==
X-Gm-Message-State: AOAM533k/yLpDzRLUJcniTerb23hnR6UWObO/Ouia3xAfh+0WEa16tMA
        DndAVvuRVFw9C1l6LMHxOsYxPOKnYqGKI2LRUTnJVyuGMdU=
X-Google-Smtp-Source: ABdhPJxOlPkSAUR0PoLL5+VRcmCBcY35kR+I9xvdCz17NSXH1FlWClSZH1LvpwpXp67hHa5swHQNQsrd8pGtxsIMM1E=
X-Received: by 2002:a05:6122:178d:: with SMTP id o13mr4725985vkf.15.1640611160867;
 Mon, 27 Dec 2021 05:19:20 -0800 (PST)
MIME-Version: 1.0
From:   Adam Kandur <sys.arch.adam@gmail.com>
Date:   Mon, 27 Dec 2021 16:19:10 +0300
Message-ID: <CAE28pkNNsUnp4UiaKX-OjAQHPGjSNY6+hn-oK39m8w=ybXSO6Q@mail.gmail.com>
Subject: [PATCH] qlge: rewrite qlge_change_rx_buffers()
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I replaced while loop with for. It looks nicer to me.

Signed-off-by: Adam Kandur <sys.arch.adam@gmail.com>

---
 drivers/staging/qlge/qlge_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9873bb2a9ee4..69d57c2e199a 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4012,19 +4012,17 @@ static int qlge_change_rx_buffers(struct
qlge_adapter *qdev)

        /* Wait for an outstanding reset to complete. */
        if (!test_bit(QL_ADAPTER_UP, &qdev->flags)) {
-               int i = 4;
+               for (int i = 4; !test_bit(QL_ADAPTER_UP, &qdev->flags); i--) {
+                       if (!i) {
+                               netif_err(qdev, ifup, qdev->ndev,
+                                         "Timed out waiting for adapter UP\n");
+                               return -ETIMEDOUT;
+                       }

-               while (--i && !test_bit(QL_ADAPTER_UP, &qdev->flags)) {
                        netif_err(qdev, ifup, qdev->ndev,
                                  "Waiting for adapter UP...\n");
                        ssleep(1);
                }
-
-               if (!i) {
-                       netif_err(qdev, ifup, qdev->ndev,
-                                 "Timed out waiting for adapter UP\n");
-                       return -ETIMEDOUT;
-               }
        }

        status = qlge_adapter_down(qdev);
-- 
2.34.0
