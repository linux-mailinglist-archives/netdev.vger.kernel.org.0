Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4A71ABBE6
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503136AbgDPI6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 04:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502996AbgDPI5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 04:57:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A0CC061A10
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:57:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b72so1357166pfb.11
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 01:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WhoZsJiZov2jfSxLGEtmiUut+TNZxfA/4UuVClNzr0=;
        b=jHpY8l5EA3+YW5OG9e0VYhz/NzapK19wtLTeBckhDS8G0iv/JnvFI3KhBgA8HT2kUm
         RO5bKx47ZhsvpuMwnd2IJwj42Dhl33PVwuPNE0XV3HKVl+qOreRwv9BsZI1Vs69c5qjt
         gi2UdrnPZ2bnv4UmSfjz8GQQMZBIGSHi4oYN9Paocq9BJBmgwxcmLwcN7T859cjKUjhk
         SmIrs9QoojeRFbklXMWVouoeyvytOMMuz2kZKnk/P8HH7EBnnQlNIIuo4+geFzJ7EapO
         P3N4mUBxWGjasviGxpAW1cGtu3IQoi9LX90RCU11vvuIY7MLRqBwK+9rDpNdc5Gt+XXE
         hjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WhoZsJiZov2jfSxLGEtmiUut+TNZxfA/4UuVClNzr0=;
        b=PLteYo/knvPCN3g9cOruKNWPJU6gchyxWT4SiNtD2ZFgLUjqy35k2Sh9db7j+l9O5l
         w7uEImBVev+Y4sSgyGRNAAv8cwLSZFVtNBAFT3s/PxoKC7PUHyeEbV91LbB77ZGFZy9p
         bmfujrBMR20OwxNvReFmKwfaZ7Yi6+NMoo0rM3ue8RY64d4zhGbDs/rJ4uXSqDGNyehq
         z3tpIqiBM3ZVXDxo/NXs11+0I2B+oZ6G9F/yaCkGYynzaYPRLFX8W7OovH4O6XRKIDpK
         wiUXjOBqct/S2bBEm0tRtmoCDfRW+YtEs1lIRQfYoJULjlDjW/lmOitzHWTxtMwQzIwh
         s++w==
X-Gm-Message-State: AGi0PuaZt5HPQ67ysKzjonE6Plbl8yh8xFVKtyxWNTBAoXrnhoSrNt5W
        lmCD6QDzstRKFHb/abyIMIaR
X-Google-Smtp-Source: APiQypLtw7jKrx1finbL2m0OXLHS4c3y7qRzSB9kUcdRDN8RB6LcSHAIJ0x1AUc/8C91ijJiX9g75w==
X-Received: by 2002:a63:6f84:: with SMTP id k126mr31197858pgc.391.1587027473270;
        Thu, 16 Apr 2020 01:57:53 -0700 (PDT)
Received: from localhost.localdomain ([47.156.151.166])
        by smtp.googlemail.com with ESMTPSA id x10sm88957pgq.79.2020.04.16.01.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 01:57:52 -0700 (PDT)
From:   Clay McClure <clay@daemons.net>
Cc:     Clay McClure <clay@daemons.net>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
Date:   Thu, 16 Apr 2020 01:56:26 -0700
Message-Id: <20200416085627.1882-1-clay@daemons.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPTS_MOD merely implies PTP_1588_CLOCK; it is possible to build cpts
without PTP clock support. In that case, ptp_clock_register() returns
NULL and we should not WARN_ON(cpts->clock) when downing the interface.
The ptp_*() functions are stubbed without PTP_1588_CLOCK, so it's safe
to pass them a null pointer.

Signed-off-by: Clay McClure <clay@daemons.net>
---
 drivers/net/ethernet/ti/cpts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index fd214f8730a9..daf4505f4a70 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -646,7 +646,7 @@ EXPORT_SYMBOL_GPL(cpts_register);
 
 void cpts_unregister(struct cpts *cpts)
 {
-	if (WARN_ON(!cpts->clock))
+	if (IS_REACHABLE(PTP_1588_CLOCK) && WARN_ON(!cpts->clock))
 		return;
 
 	ptp_clock_unregister(cpts->clock);
-- 
2.20.1

