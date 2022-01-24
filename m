Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD86C4977B1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 04:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiAXDae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 22:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241038AbiAXDad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 22:30:33 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F025C06173B;
        Sun, 23 Jan 2022 19:30:32 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id d5so12651565pjk.5;
        Sun, 23 Jan 2022 19:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RX6Av1jIiyqXvZYjcpZEeGLsyORkpiw+PH/GcVKGsHk=;
        b=TVighjXmld8xjrLsacTJCmUi8xhvnHU+SU2zVkR93VRMOoaA5A+oScrkxaodwFq50j
         78/84wVestiPhMtV2WWr3chJ1UgTcgLk21X1vCXpcT9tjr6Isqd3Aq88uLTDu4l6QeTO
         p2FqyiqbFX6Vqh88Hxkswi+eXed7BvZ5NmtHAMAXow3ydduW6bWMnZBn6EExFHWi9tpK
         CQpBl3KoSRE93i6HsJw1reE+KifNt06FM+UG0NVK6AXRBikPLAJt6SQSMExulX9fcCVv
         cHvmrh8L3NxdjvkxG7HfsSoA81UzF1MR9ckRBb27O8nll8mJvC2UkOUIDXYYA+mNcIQe
         16EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RX6Av1jIiyqXvZYjcpZEeGLsyORkpiw+PH/GcVKGsHk=;
        b=MUzGXrhvvj6i1YKDjDZYkqWeB5hKrqGfyEBN2QpZiaWWbu7Q3oNLzUmGMKGQkhUkAM
         /Ho18jAuwfkW74TOjYzFnOM9fZdu71sMzR4+VCv2oZJWYXI9bc56/qIP41m/FqqJ+6VV
         Xa19xsIMSs5GY9j97XzrhVyeKENxjU0qHHNEJOqc0ew+xu6BWNDlYqSimQ5YY5CWSGqs
         fmegjVUC964dljPxPv0k87gHmJIHInnYAKhY38hcESqzkQGQvqv6zD3CaMb6C+dfpmmw
         fOhyFsFmSsyvw7RnT0MtS6D0wxDZvUA2Ng4OzejpaV7W4FTQsEcw+9C34qmVcXrCEnU/
         wpWQ==
X-Gm-Message-State: AOAM533pkZiBnIUkSoMKNweN9aB6ferfAllNMv+Eql8BjvnYPWHyQrGB
        tXfPz8rRmeIZBKS+DQFNXIc=
X-Google-Smtp-Source: ABdhPJxrBHaemBkBFmBL3KV9+t104TL5EBzibAlxur7Q5S263lmO2RJah0zWLOE2BsDv4OW4o3DJSQ==
X-Received: by 2002:a17:90b:3a85:: with SMTP id om5mr56077pjb.150.1642995032168;
        Sun, 23 Jan 2022 19:30:32 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id g5sm11178639pjj.36.2022.01.23.19.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 19:30:31 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jpr@f6fbb.org, davem@davemloft.net, kuba@kernel.org,
        wang6495@umn.edu
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] yam: fix a memory leak in yam_siocdevprivate()
Date:   Mon, 24 Jan 2022 11:29:54 +0800
Message-Id: <20220124032954.18283-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ym needs to be free when ym->cmd != SIOCYAMSMCS.

Fixes: 0781168e23a2 ("yam: fix a missing-check bug")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/hamradio/yam.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 6376b8485976..980f2be32f05 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -950,9 +950,7 @@ static int yam_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __
 		ym = memdup_user(data, sizeof(struct yamdrv_ioctl_mcs));
 		if (IS_ERR(ym))
 			return PTR_ERR(ym);
-		if (ym->cmd != SIOCYAMSMCS)
-			return -EINVAL;
-		if (ym->bitrate > YAM_MAXBITRATE) {
+		if (ym->cmd != SIOCYAMSMCS || ym->bitrate > YAM_MAXBITRATE) {
 			kfree(ym);
 			return -EINVAL;
 		}
-- 
2.25.1

