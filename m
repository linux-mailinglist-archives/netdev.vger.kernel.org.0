Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1878221167
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGOPnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgGOPnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:43:09 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F56C061755;
        Wed, 15 Jul 2020 08:43:09 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id t9so1313516lfl.5;
        Wed, 15 Jul 2020 08:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1aHu1Z5oC5ObOqs/+6g63oI0o5o93R9RpXFU6u5G/HM=;
        b=ZhuvGLSWsiH2pw+v4+oVujCGhm89HXMlPDUbPQ9wUjGrthgFMyt0zt1I2iEdBEMhXV
         yg5GL+cryij6SoQ5ikSpzX4c8pwy8AL5mvHANN0Z4rmT+dy51QlXOaTEwv6svhFF8R2A
         e6iJCqHprGbwYuh1u1I7ycYALuI/jk4sZvgHqHfsNSMnrUjAUZAveYMdQKi/4KkjxN1g
         brexi5Yl1gOkSwpxrxl8rk9jeBbwdiKRPGfkGAc0TBEwljomxblr1MlxZK7rf1UTwhBq
         OO5RsN3h/T77YaY5voKZ6Y7Qj2JAdSKJ+6BuGvVqYEf9ig5u1uA/NB4y3mzH3+7g1mFb
         q21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aHu1Z5oC5ObOqs/+6g63oI0o5o93R9RpXFU6u5G/HM=;
        b=XGeoQRSPK3r9jkqv2lv7NGLoI1n1pFGRRT/6FeHe26DPvGMXEaTY8xRiu3mBYJ7erm
         4mC4BfmfgViopFY1R+bWRQp7addaXHwqrWGGsBaigGApIhHYyQ2SZ0Bdp2aMx0G+/rE6
         NmfEHI/2Zw/KmBiSXOCXZBXvxpUfD/S3s0TWMn06zv6YMqPsbOOx9uw4pA3SZtR5Eytm
         yxiVVWplTinUyPT1viVevsbhWYF/0HyPPwLe+NP/+rz8AhRwo+uUtldHa5ZM454NokZY
         7D/kxTpNOrhTC8u+ymwHocgOsO7oSyqMm1fsfvFlpz7lj+K8lVQqFElCwsNbemPsndgR
         rY1g==
X-Gm-Message-State: AOAM533Ri4AD02y6RisrEM9QBAh2uNrgcMGofQYTxD8XmYzFHxalIsuu
        1UsEtrpVDQLi2hMrCO8LFqYVdhVD
X-Google-Smtp-Source: ABdhPJzKwvJ4zlI/+N/diNAQxT0W1RRuu+6jSnRydOQl4XxFD6fO69JzKQPe4moJxrxaxwyTreUqDw==
X-Received: by 2002:ac2:52af:: with SMTP id r15mr5087333lfm.24.1594827787270;
        Wed, 15 Jul 2020 08:43:07 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id c6sm563955lff.77.2020.07.15.08.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 08:43:06 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH net-next v2 1/4] net: fec: enable to use PPS feature without time stamping
Date:   Wed, 15 Jul 2020 18:42:57 +0300
Message-Id: <20200715154300.13933-2-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715154300.13933-1-sorganov@gmail.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200715154300.13933-1-sorganov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPS feature could be useful even when hardware time stamping
of network packets is not in use, so remove offending check
for this condition from fec_ptp_enable_pps().

Signed-off-by: Sergey Organov <sorganov@gmail.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 945643c02615..fda306b3e21f 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -103,11 +103,6 @@ static int fec_ptp_enable_pps(struct fec_enet_private *fep, uint enable)
 	u64 ns;
 	val = 0;
 
-	if (!(fep->hwts_tx_en || fep->hwts_rx_en)) {
-		dev_err(&fep->pdev->dev, "No ptp stack is running\n");
-		return -EINVAL;
-	}
-
 	if (fep->pps_enable == enable)
 		return 0;
 
-- 
2.10.0.1.g57b01a3

