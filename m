Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881122DA5F5
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLOCFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgLOCFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 21:05:16 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CC5C061793;
        Mon, 14 Dec 2020 18:04:35 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id e2so2946595plt.12;
        Mon, 14 Dec 2020 18:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Eh2C6JhMn6ot8VqihWEIpVJROCk+GI8Jpaj5L4a5XnI=;
        b=YRz/4Q/Dqe0PTPPyib99YyLo46g5hr1sxInIM40YKTgguntMCIiIlyotvxInQR3tdq
         TgLbwcWF8t3o/JBL4fOE5w70S5CPhLwgbNBFLMnE+89AeYKy/jUc2rPkDvXV6uksKEwJ
         N9TsMljCaEDLbhlhGI1ugsaOoOz6IvijKSMFpOLkR1ldv8XoJAiPUhnvkEeWv7zMX8kQ
         nk6oZKtdBGpqDXalWaLT/AfQH0FDk/vK3CR/JkRVDR+O7k5l+sFxExOSzd9pejNmjED6
         2CGtQsbfPBfY8nKI4IiE3gQo+0MEOdryDEQVJsw+huNJZ02AYgaDfp9BNacX7AY832od
         MO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Eh2C6JhMn6ot8VqihWEIpVJROCk+GI8Jpaj5L4a5XnI=;
        b=SDmzieF56TNZLZcIqWya5NsJdk9DTp30MQrk6haM+CkDOAbFIcOowWA4eFjlKFpXYn
         513LwmzIv/f7L9KTZ7GdmoZzD3BVnQDWX8oiiH1fJodsH0s8Py6pOAXTZ6SDyG+SqRpz
         E7Ddy6ZYI9NTnNOZ9Xhw09N3s/4Ph2qzhHVckRb30vj3k8rYxajAq8AGkrmAXp5RIpqn
         O8/OymCyibD6bIB7XeAGrDAHWqIAUUiaXTES0oijnMtoFQEqNukgzo6dO1+C3p7/FbrP
         qEql4TRDhhTbGtmilHnL7lYFKaqCkVVvnM+hUp6hBKQoXFA+LgnoP70mfwVKhGpS+wQt
         ePTQ==
X-Gm-Message-State: AOAM531J3hTyALj47/hWiY4msmqso+i9J9CJksl9DEWo1iVyNfaCmFII
        eEhhfWy8pptIz9j+F7LBOPY=
X-Google-Smtp-Source: ABdhPJyf+V+BLO/6fgkbqziDEhx9el4b2aFE5jP2q6F/nbIljpi7O4xo/UF+nwUUHViOw+ul5s2xzw==
X-Received: by 2002:a17:902:c244:b029:da:e63c:cede with SMTP id 4-20020a170902c244b02900dae63ccedemr479597plg.0.1607997875535;
        Mon, 14 Dec 2020 18:04:35 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id y15sm19347840pju.13.2020.12.14.18.04.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Dec 2020 18:04:34 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, jiri@mellanox.com, edumazet@google.com,
        ap420073@gmail.com, bjorn.topel@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net: core: fix msleep() is not accurate
Date:   Tue, 15 Dec 2020 10:04:25 +0800
Message-Id: <1607997865-3437-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

See Documentation/timers/timers-howto.rst, msleep() is not
for (1ms - 20ms), use usleep_range() instead.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d33099f..c0aa52f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6726,9 +6726,9 @@ void napi_disable(struct napi_struct *n)
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
 	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-		msleep(1);
+		usleep_range(10, 200);
 	while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
-		msleep(1);
+		usleep_range(10, 200);
 
 	hrtimer_cancel(&n->timer);
 
-- 
1.9.1

