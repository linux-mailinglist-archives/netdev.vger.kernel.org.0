Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632D8215952
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgGFO0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgGFO0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:26:43 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6AEC061755;
        Mon,  6 Jul 2020 07:26:43 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e4so45644813ljn.4;
        Mon, 06 Jul 2020 07:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UOEVL4GhyWIgjIGro4u3aeU8FKwvHOzzUyyl/y7LzzM=;
        b=GwJgFzF4vwHAAJ9Igj1btv4X98+abEBXTkXaJZd4XUjoI3wQ49U2dO6cr6EZOncZjV
         8CUGnb3yaqduB61MnMIh8tjAfEaEEsxmY87gbpyUU1pfCt8hMZqQMXzNcHtMsrXApMrH
         uoHJc/INvyON42mOvXlO9pHWffZ5vHgEHFkWpePEqTq5WQ8piQL7rE1Zwq+UzRDcu7Hh
         BfBhV0UBxuq0rNCbskU41ZQ28yaq4HhXOa4+InYgMl3Svv+PqbLDyBDPcnxMQdCLLpgo
         PlRkzWkNnMLTRIbq/kSIBW0ChTMaghoE5ZIjHTMZTUohzZAC+TQzT98L36cf4FkWrVfW
         9HLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UOEVL4GhyWIgjIGro4u3aeU8FKwvHOzzUyyl/y7LzzM=;
        b=OeMVgEt/76BMl8BypoY0xYkLg14qQC0bzeQp8Q5KbTdyFMQGbHC99IkWhZJR0ca7v1
         FPnPZVBP4rtsMa3idoGlWeBA29ZhNitrjPCsziM7np85hnJFhJSyjwkgGTf2nOz54stX
         8t5jGLyQDhbP0+eY4pcr3lW0JvT2OkB1hx8D4xzV6sGTJEoyk0dWXqLwn0C5X0fov9SV
         mvhy2ZCpYAcxtHQB3bSrcGbzIsIq2G3aWguKXOVXpmEOEV1EaPsY/3VyYXT8Vmng2mib
         LI9JFcLnLgytKZ/xaqe7jiEjiBD5qxLwwsyDYnq81fuwHeJDjsAdgEXVk++4Ma4B+4yd
         BztA==
X-Gm-Message-State: AOAM53029FMEaQFl/k2epMr1JBC2DVG7nDnTG3GiXA2AtyZ/bBvXIrud
        npaBygFwjo1G+ZyRTTSMdesd0TO6
X-Google-Smtp-Source: ABdhPJx65mOdy4rdE4Yc/AybeGLiQPj1+soHDPM5kdQ/ZJFnf7yWRwT7qVEAbIJIHh5LjyiOSBty/g==
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr27224758ljp.266.1594045601430;
        Mon, 06 Jul 2020 07:26:41 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m14sm11744638lfp.18.2020.07.06.07.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:26:40 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH  3/5] net: fec: initialize clock with 0 rather than current kernel time
Date:   Mon,  6 Jul 2020 17:26:14 +0300
Message-Id: <20200706142616.25192-4-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200706142616.25192-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initializing with 0 makes it much easier to identify time stamps from
otherwise uninitialized clock.

Initialization of PTP clock with current kernel time makes little sense as
PTP time scale differs from UTC time scale that kernel time represents.
It only leads to confusion when no actual PTP initialization happens, as
these time scales differ in a small integer number of seconds (37 at the
time of writing.)

Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 4a12086..e455343 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -264,7 +264,7 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
 	fep->cc.mult = FEC_CC_MULT;
 
 	/* reset the ns time counter */
-	timecounter_init(&fep->tc, &fep->cc, ktime_to_ns(ktime_get_real()));
+	timecounter_init(&fep->tc, &fep->cc, 0);
 
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 }
-- 
2.10.0.1.g57b01a3

