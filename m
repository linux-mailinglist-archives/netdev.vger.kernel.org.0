Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747C31DFF1C
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgEXN2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 09:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgEXN2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 09:28:03 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19070C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 06:28:03 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so5464130plv.9
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 06:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sG07EjkLbbGHug7gLwBR3OOl8TplxJhMZpXnMWtzsi8=;
        b=DXTWO2TrVdDNW0jDN5GX0XfoT+vM4jXZaOkqToLI+2ejcX0DN54U7rfGEJwJ2Lu1v2
         Ggdgrp/xFOsbwRLTw6RJ0GB1vUs77mXTGnyFBd916fvTqu2mt9U+VE0xDdXCkoH/P8tC
         fPWeXfb9qV2bj2NdHWye99iPpSejJ1JGOrhR2KJFeMQHcMAQqm8Fr21of6WYnH1d/8GM
         4SJdRYegtQhYx41xb+is8X0e+QCKwzbxlLilhm1q1AtA4TckenSYWJ2NhmjRvQE1rJwU
         ispzU32e+DAQsktckY90vmCJOF2WsWItKHzPaYpN577L0w7aydg4P5rH1NoRTUrvmT0U
         5JHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sG07EjkLbbGHug7gLwBR3OOl8TplxJhMZpXnMWtzsi8=;
        b=FckvXgZoOoOeKu1b8MTzi30dF7u6ui6ZoSE4QQyGJZuipJ7P1qWDi0YIrHUmyX4eX3
         K4/bKCW+vGZ8BSFX/nC+Xp4JXZE/wlGP9LyAF9FFUsbWROrjp2besC/M4ho4NZheTrlR
         UOBX5FqMU+R9PobT/jtYy4rS2h8v+0X2MOSgPq8mywVrN80xfncB6i+Bkik6Nke/8pfc
         6rcpNFFlpgS9xW1lmfpqjr0lE7sti7EYoxx/TSum4Q91itT7xS5i6fNiF8CPxPknd7VQ
         IEXWuk52tmeYZv++gZGmJ58OsCvTeT5sGlw/HP2Myds82k0hC4SkJQE7Gf889NbT0aT2
         fN+A==
X-Gm-Message-State: AOAM531fQ4k7jw98JI1X0h3FTVGl+Cs/clQmwgEizzj8pkM/0Uaxfkts
        nI6A5ChAHTVO+lZho02JsRp4GQG7IsQ=
X-Google-Smtp-Source: ABdhPJy0M4+1Sz0XVDahJLkwlYB38js6TZ9ECkJCmDxEyoKmoYoEzhJjRX8s1XaYjYqmLslr482uGQ==
X-Received: by 2002:a17:902:b68d:: with SMTP id c13mr13309818pls.210.1590326882349;
        Sun, 24 May 2020 06:28:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id p1sm2981460pjz.36.2020.05.24.06.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 06:28:01 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next] Let the ADJ_OFFSET interface respect the STA_NANO flag for PHC devices.
Date:   Sun, 24 May 2020 06:28:00 -0700
Message-Id: <20200524132800.20010-1-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 184ecc9eb260d5a3bcdddc5bebd18f285ac004e9 ("ptp: Add adjphase
function to support phase offset control.")  the PTP Hardware Clock
interface expanded to support the ADJ_OFFSET offset mode.  However,
the implementation did not respect the traditional yet pedantic
distinction between units of microseconds and nanoseconds signaled by
the STA_NANO flag.  This patch fixes the issue by adding logic to
handle that flag.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index fc984a8828fb..7ae6e8e85f99 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -147,8 +147,13 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 			err = ops->adjfreq(ops, ppb);
 		ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
-		if (ops->adjphase)
-			err = ops->adjphase(ops, tx->offset);
+		if (ops->adjphase) {
+			s32 offset = tx->offset;
+			if (!(tx->status & STA_NANO)) {
+				offset *= NSEC_PER_USEC;
+			}
+			err = ops->adjphase(ops, offset);
+		}
 	} else if (tx->modes == 0) {
 		tx->freq = ptp->dialed_frequency;
 		err = 0;
-- 
2.20.1

