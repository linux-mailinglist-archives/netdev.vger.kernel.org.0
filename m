Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F232441C29
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhKAOHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhKAOHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:07:09 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE57C061764
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 07:04:36 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b1so12930678pfm.6
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 07:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=o1NeXDfxd5eFMhMhBXrMUaHR3VNkybzQjzcF7o4n7Iw=;
        b=P3plmEuDWMo2nq/h5T8NOdkpbcI1Ib9EuhLtYW9+eoq3vDif/zLQTH8pYaxep8GqCv
         NhELriIn0Mj/fzE7KAwelvfD27lY8j5VB0+oRpfJNfdrhQVUgmH8sZRpMCOlhgURToJ3
         cGp/dVchNIsy7uuzvdDho5e7M+OGSsUnp1+vFFuaHOYbMjrTX7vwQR2lZqq4oyLeUHKS
         rEZtND/K0jCrB30eNqdYBzq19KcJX9iYdyZTs3zAz5lla7Mgskc6efTNBQoj05FX6Qce
         zoEMUs627s4KK/fPxG+RR4vkCL2fWCocj5O7eP0CMJGXeE/zCC4Pf9fARX68eXPgZJng
         tT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=o1NeXDfxd5eFMhMhBXrMUaHR3VNkybzQjzcF7o4n7Iw=;
        b=eB3Q4bFDs6JDTOBojYVjdRxy6NpvJIX3MmdAfMGvTHaG9h4ptsa2aA5esRxGiWEyfJ
         +Zrk0fOooP79M+AgkdSzpkoaKz7kCQgQRtkgP6yOecN4j3Eoa//uNc9l4dU5lsWneTF6
         sZiE1hrSi6aDOEcx92X3lVxk01o6OJEnHRufhn+TN3mauZJ75vCWMRcBrDhIglyy6jBf
         0r0pZntCsxa/+qfYQ264A+87gjqe+zUAn/bdHBDzl0rGtZM5MExDCZcP2k76yMTY1Go+
         1z92D3DDRnEym3djjhBIyP46s5Yos9yAzufT88sqfic1Sbv8xFE1gZAo/ERUBF22bTQe
         4c2A==
X-Gm-Message-State: AOAM531lgUROSRZUv9ATXcSo+nyZAqKJDnR3D8pieaQ4AtJTVGEKCIBf
        PjmIoLIZQTxeQESHlbM8xgg8gT+/ibLv72bX6ks=
X-Received: by 2002:a05:6a00:2390:b0:44d:bccd:7bc with SMTP id
 f16-20020a056a00239000b0044dbccd07bcmt22346100pfc.4.1635775476110; Mon, 01
 Nov 2021 07:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211101092134.3357661-1-bigunclemax@gmail.com>
In-Reply-To: <20211101092134.3357661-1-bigunclemax@gmail.com>
From:   Maxim Kiselev <bigunclemax@gmail.com>
Date:   Mon, 1 Nov 2021 17:03:56 +0300
Message-ID: <CALHCpMjqL2i8rJBR1vVnW1orrY1Y6rSdmKGnL6uNE6tSa6jNYQ@mail.gmail.com>
Subject: Re: [PATCH] net: davinci_emac: Fix interrupt pacing disable
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From ca26bf62366f249a2ed360b00c1883652848bfdc Mon Sep 17 00:00:00 2001
From: Maxim Kiselev <bigunclemax@gmail.com>
Date: Mon, 1 Nov 2021 16:37:12 +0300
Subject: [PATCH v2] net: davinci_emac: Fix interrupt pacing disable

This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
disable rx irq coalescing.

Previously we could enable rx irq coalescing via ethtool
(For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
it because this part rejects 0 value:

       if (!coal->rx_coalesce_usecs)
               return -EINVAL;

Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
functionality.")

Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
---
Changes v1 -> v2 (after review of Grygorii Strashko):

 - Simplify !coal->rx_coalesce_usecs handler

---
 drivers/net/ethernet/ti/davinci_emac.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c
b/drivers/net/ethernet/ti/davinci_emac.c
index e8291d8488391..d243ca5dfde00 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -420,8 +420,20 @@ static int emac_set_coalesce(struct net_device *ndev,
        u32 int_ctrl, num_interrupts = 0;
        u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;

-       if (!coal->rx_coalesce_usecs)
-               return -EINVAL;
+       if (!coal->rx_coalesce_usecs) {
+               priv->coal_intvl = 0;
+
+               switch (priv->version) {
+               case EMAC_VERSION_2:
+                       emac_ctrl_write(EMAC_DM646X_CMINTCTRL, 0);
+                       break;
+               default:
+                       emac_ctrl_write(EMAC_CTRL_EWINTTCNT, 0);
+                       break;
+               }
+
+               return 0;
+       }

        coal_intvl = coal->rx_coalesce_usecs;

-- 
2.30.2
