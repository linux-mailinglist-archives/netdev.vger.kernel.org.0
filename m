Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD7732ED1F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhCEO3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:29:23 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:46706 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhCEO3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 09:29:08 -0500
Received: by mail-lf1-f54.google.com with SMTP id v5so3867749lft.13;
        Fri, 05 Mar 2021 06:29:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5eGMjW0/0FS8wcIYA9qrwriQ7+t9gtpkbJxLpQkObag=;
        b=YAdqN4T6q1MOyCXJfFgu0+MJoIveiMOFyg3NorUXJn51wMHoUjh2NecXuJtqwYgUfQ
         g5GRHDVM3LtwcVZsY3vlBlMZlmIhFCL2A6QUrix6upKqSENi7elSpD8nO0Pq3FqFcpgG
         9qKPSMTB5bs3lquEZnjq65CCFfKqnTXsuBvoA1c7F7Q6Tx//MzQGEwFx+hkSnwcaHL7Z
         W0fDUdX8KF21sL9Zd1boenUfX/aGHkwmaAl4ApKZ3pHStFSiUoVd6aGBklrHA0NRPq1i
         LOo/Ul1xR+76qYK+f78ZV4u4P3Sh2jJO0ODrSXwix3xMUuzMkfwioNaINXxTHkAy6dze
         Ir2A==
X-Gm-Message-State: AOAM530q5mcV7suYLuJh4m0M1Vsww8bJ8d5vOUNvOHtq6K9wTt1ymxMO
        67cUmE2KdtM1W+IQ7KOia1w=
X-Google-Smtp-Source: ABdhPJzeAIriOu+fmgUmq9fOPTAYqN45YFxQPaxFMOARDr2Wh/Br4w0m1/haldLk75HzbOBWAEywrQ==
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr5787673lfq.258.1614954546496;
        Fri, 05 Mar 2021 06:29:06 -0800 (PST)
Received: from localhost.. (broadband-188-32-236-56.ip.moscow.rt.ru. [188.32.236.56])
        by smtp.googlemail.com with ESMTPSA id d4sm331040lfs.45.2021.03.05.06.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 06:29:05 -0800 (PST)
From:   Denis Efremov <efremov@linux.com>
To:     Andreas Koensgen <ajk@comnets.uni-bremen.de>
Cc:     Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/hamradio/6pack: remove redundant check in sp_encaps()
Date:   Fri,  5 Mar 2021 19:26:22 +0300
Message-Id: <20210305162622.67993-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"len > sp->mtu" checked twice in a row in sp_encaps().
Remove the second check.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/hamradio/6pack.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 71d6629e65c9..9f5b5614a150 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -171,11 +171,6 @@ static void sp_encaps(struct sixpack *sp, unsigned char *icp, int len)
 		goto out_drop;
 	}
 
-	if (len > sp->mtu) {	/* sp->mtu = AX25_MTU = max. PACLEN = 256 */
-		msg = "oversized transmit packet!";
-		goto out_drop;
-	}
-
 	if (p[0] > 5) {
 		msg = "invalid KISS command";
 		goto out_drop;
-- 
2.26.2

