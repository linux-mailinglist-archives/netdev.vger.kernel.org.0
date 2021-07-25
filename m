Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6A13D4DC8
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 15:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhGYNEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 09:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhGYNEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 09:04:55 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1CEC061757;
        Sun, 25 Jul 2021 06:45:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l19so9146850pjz.0;
        Sun, 25 Jul 2021 06:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CPKcV5apB8857BwhvHUW6j9y3xBf0R05HIIXcW+LSY4=;
        b=n2gJKKRkUbCzf5Hs2VPam4LEhvjmAxzvLF95EdZA9ZgJEQ1val0sheYNX2gLs3RvuE
         /itKSQV4kUZan4uRGqQuBxSEXP1jV2Ok0NlRKpGs1CfUsp2oPfMz7kQFdfh1WkMrFK0j
         x2GA6lvDzfz2s8F13cN+i74dA0wUrJfVacrEuGXFt4AQi9iBDbFbjf+8dPPFhJ7x7tfm
         mKf9Ldz+9SyGhrm2e5R92NMWsctxHNOmaDL1sq+mQJ4LsL6dXgFUJPlwaK1pSB1bjHZe
         SHaol54evRXm6Js1jLO253QORCJWZlyP2xJrV+ZTVjt50Vxb2yu3NSiw1kPDc11Frd6D
         27JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CPKcV5apB8857BwhvHUW6j9y3xBf0R05HIIXcW+LSY4=;
        b=U/EeWhq3i3920aD4CqbnTur5UFUjfWEUIaWiqt49gvgmIONk70fzm1wbt7lO3ZO13G
         IPT5LeE9gfQgz7WAx5rabCVBQd1lIUotkSOSY5SlzNRIH1qMH39wAhbNCzy9n7g1HXsn
         ixaPBPoBho4eXFEDQZP/uxAhGz1b0qBNpOPCbe0D4TXdElq6k8eoH3x6N4W8LmUwQ8rJ
         cOCtAf+T5Z4vWL81DO+zNsusqs8I45H71sSJuWkcQhlLDLAezBG1y8GfH7PM3zVB12g0
         sRILxjoELvcdZF1+CQs6tZCPKMnhp++fGerDWjAEAQViMwAd3nZLs0+1UfiQ4dzST30u
         XRIg==
X-Gm-Message-State: AOAM531PlLym676Ua8B71WJtOooMXRYEHyhWmoU9XcKPgCsdhNIOQ58F
        tORtCwA2QMiV1XkCcvGwCf/j3NxJKBm36CCYNDI=
X-Google-Smtp-Source: ABdhPJyTg2y+y0eDTyVJ0DnhpPnoW2D2ZfdaBaSqY4UW+mdvgWK5Tp0JwP6xSEfBkX3PNYweGHJZnQ==
X-Received: by 2002:a17:902:c950:b029:12b:6dff:737e with SMTP id i16-20020a170902c950b029012b6dff737emr10850220pla.23.1627220724905;
        Sun, 25 Jul 2021 06:45:24 -0700 (PDT)
Received: from fanta-arch.tsinghua.edu.cn ([103.207.71.57])
        by smtp.gmail.com with ESMTPSA id a13sm41608567pfl.92.2021.07.25.06.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 06:45:24 -0700 (PDT)
From:   Letu Ren <fantasquex@gmail.com>
To:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zheyuma97@gmail.com, Letu Ren <fantasquex@gmail.com>
Subject: [PATCH] net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
Date:   Sun, 25 Jul 2021 21:45:12 +0800
Message-Id: <20210725134512.42044-1-fantasquex@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling the 'ql_wait_for_drvr_lock' and 'ql_adapter_reset', the driver
has already acquired the spin lock, so the driver should not call 'ssleep'
in atomic context.

This bug can be fixed by using 'mdelay' instead of 'ssleep'.

Reported-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 2376b2729633..c00ad57575ea 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -154,7 +154,7 @@ static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
 				      "driver lock acquired\n");
 			return 1;
 		}
-		ssleep(1);
+		mdelay(1000);
 	} while (++i < 10);
 
 	netdev_err(qdev->ndev, "Timed out waiting for driver lock...\n");
@@ -3274,7 +3274,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 		if ((value & ISP_CONTROL_SR) == 0)
 			break;
 
-		ssleep(1);
+		mdelay(1000);
 	} while ((--max_wait_time));
 
 	/*
@@ -3310,7 +3310,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 						   ispControlStatus);
 			if ((value & ISP_CONTROL_FSR) == 0)
 				break;
-			ssleep(1);
+			mdelay(1000);
 		} while ((--max_wait_time));
 	}
 	if (max_wait_time == 0)
-- 
2.32.0

