Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC023E04E6
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbhHDPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239602AbhHDPwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:52:38 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E00C0613D5;
        Wed,  4 Aug 2021 08:52:24 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t9so5268886lfc.6;
        Wed, 04 Aug 2021 08:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MBriIZ2G2M2XCFCkysf4584gS82vV2S0w04vsL/TpMs=;
        b=Y+U0o5F1svs/jTON0xwzaWelTku7kmvUmxAofy1IhwBSR4dN39oirQHZVq3+yvAv5k
         p9u1r/2yjY/OLkP3dRaDCqcd6udg+WW6lbe31uc1DqqPnPt14dT3Smwqcp45n746S2SJ
         xHanq1vCz360Bo5WqUKNIWZVFbEpLHQ9DZHvuumR7mY3oezazl75yzcP2vSJqhFKDcAy
         WGWgjMANS2Bp9rJzjyfsnpUWHbRFufaaL/7gUWBJMgVxes806gB8hpOO6dFXo/s2p4ur
         m2BK1vC/9+3cWLd1J66LYrnZ3Ps5iTBRngnahhoKBQCR7CmHLP17Q8ZM9XJMsjwdwJ94
         Q26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MBriIZ2G2M2XCFCkysf4584gS82vV2S0w04vsL/TpMs=;
        b=kHuj+/qYRhx2HEET/rMKQnPbdxMZ+e8kP9eA8/j3bfEfiet5nQ9vRfmI9n1ORjmVYS
         54MWHS+eLTX4m7xkibflGP3JXOWRwm2v9vJVpRs47MzbidFN1TKBLOXoojnSUqvtRgvp
         M5yJ4Jwghz8JdSl5U5lCn1R6WULmbZVAkMtDuqTfy9nr+8mEQeeeKf8BX4C/Mmyq0rq1
         5ZrDvwPxV9lba4cZ3xspcbVre0HSsgxdhJwqas59lJo8/7WSidSUmIaeop6u3j0EXl1p
         lW43+JfJE7350SGSRXc0+ZWTqv+Ub5UU8DmGpz2sYtpAEVfbHmqLsYDKvBvFx2qs6Yr9
         JtLQ==
X-Gm-Message-State: AOAM531V/jlHFFsaJx9WWHEnOnNm6KkncMr2DY/LamR0vvXOAmzvLmG5
        S53LvoxNIxUNIy/IYE+H7U8=
X-Google-Smtp-Source: ABdhPJz3DE5NVTPwgg425Om0rpKX0sRS9HYPJc2IW5qT9x5uY5l/znGh/nF+XmkrVs1LYNeZTGE8dg==
X-Received: by 2002:ac2:57c5:: with SMTP id k5mr21398920lfo.72.1628092343168;
        Wed, 04 Aug 2021 08:52:23 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id x16sm230198lfa.244.2021.08.04.08.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:52:22 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, jdmason@kudzu.us,
        jesse.brandeburg@intel.com, colin.king@canonical.com
Cc:     dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 2/2] net: vxge: fix use-after-free in vxge_device_unregister
Date:   Wed,  4 Aug 2021 18:52:20 +0300
Message-Id: <cf7e28fc0aaac4263564db2e21f22b07928fec87.1628091954.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628091954.git.paskripkin@gmail.com>
References: <cover.1628091954.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch says:
drivers/net/ethernet/neterion/vxge/vxge-main.c:3518 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);
drivers/net/ethernet/neterion/vxge/vxge-main.c:3518 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);
drivers/net/ethernet/neterion/vxge/vxge-main.c:3520 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);
drivers/net/ethernet/neterion/vxge/vxge-main.c:3520 vxge_device_unregister() error: Using vdev after free_{netdev,candev}(dev);

Since vdev pointer is netdev private data accessing it after free_netdev()
call can cause use-after-free bug. Fix it by moving free_netdev() call at
the end of the function

Fixes: 6cca200362b4 ("vxge: cleanup probe error paths")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 82eef4c72f01..7abd13e69471 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3512,13 +3512,13 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
 
 	kfree(vdev->vpaths);
 
-	/* we are safe to free it now */
-	free_netdev(dev);
-
 	vxge_debug_init(vdev->level_trace, "%s: ethernet device unregistered",
 			buf);
 	vxge_debug_entryexit(vdev->level_trace,	"%s: %s:%d  Exiting...", buf,
 			     __func__, __LINE__);
+
+	/* we are safe to free it now */
+	free_netdev(dev);
 }
 
 /*
-- 
2.32.0

