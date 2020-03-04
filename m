Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB95178BF1
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgCDHvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:51:23 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39657 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCDHvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:51:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id l7so545111pff.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 23:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=24e3swqqvf/16vAYOjRyHuOVu6a4jtSq56QbHslKwTo=;
        b=mNQ8ycTkk5HjJr/6M80V0VCip4jeKRSUD9lG4c//Xgyj2yQwysfJcIB0ZETR9q3dDr
         YBmi5DWdIr9Jn8k/Y8xgwnkJmpFMk7qsrZqBnhUbvex1w5+dL824YRlLWhwxiCtAao+5
         Z0reJ5o78TaSn3JRTkumb+c0vT4VRNH5PfZtv7T4yM4UPglSBnnI1ZAWTkKl6qgrBBGv
         lOwuOiBi+vk/UImfKoU2TMFfTq/HnTU9FONOxYN7CvzvSgIaMoLKZRTIZ7YFBx9TQ5OJ
         4XCJXfZm1FYlRJIZDCL9sqzyH9MPBlrUeBlz3rTDnRCfIPvy4c9RVXZZ+WLZCQU1KJ7o
         AJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=24e3swqqvf/16vAYOjRyHuOVu6a4jtSq56QbHslKwTo=;
        b=FrG4t7nf2w2ypu6fxU3FcMmNN/M7HwMOxaG7j4kjwkwvOZfMJigLeginvSjSR6sWxh
         QxMLJx+jdlP7ITjfkJGTBrWhxJefS1d4aeQ+WjCYm3CpEn5f5CmVKug5gqqtluemCiwf
         ZCQQRz7cygaFR1hbZu04KHBI1PsJbEkyAhIzBFg4Q6rZ2PMOmYErTcpbxH9FhKikOEsB
         5FI7JL1VZQeCYIZN155GZAx973rb6xAMmZuAIVH0UyMjG2fAKub6/SNkgTBeHQsJXd/5
         wY2kC9qdmDTuic9IhzhssAsapTBiINRbua9f4w5ZtnR6pkwOnP5sOxlQ1yB4CZddsR/W
         5pgQ==
X-Gm-Message-State: ANhLgQ2myiHSgDFRbIYOJoVP+1nsHl9PItv3o9a1SN6tqwpAWykmPt2e
        xnuAR8Gpewp44pNe1Bpe3Oo=
X-Google-Smtp-Source: ADFU+vvc+KYIA4spo4O3HxqLveVN4Z0dN7mlwzwQ/TRLJLfzmnOGjRrbi5HVQhTjr5ZW63oy7APeHw==
X-Received: by 2002:a65:5b0f:: with SMTP id y15mr1449707pgq.258.1583308281792;
        Tue, 03 Mar 2020 23:51:21 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d186sm8841988pfc.8.2020.03.03.23.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 23:51:20 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 3/3] net: rmnet: use GFP_KERNEL instead of GFP_ATOMIC
Date:   Wed,  4 Mar 2020 07:51:13 +0000
Message-Id: <20200304075113.23509-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current code, rmnet_register_real_device() and rmnet_newlink()
are using GFP_ATOMIC.
But, these functions are allowed to sleep.
So, GFP_KERNEL can be used in them.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index c2fee2b1e8e4..3d02d56199ca 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -57,7 +57,7 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 	if (rmnet_is_real_dev_registered(real_dev))
 		return 0;
 
-	port = kzalloc(sizeof(*port), GFP_ATOMIC);
+	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
 		return -ENOMEM;
 
@@ -127,7 +127,7 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 		return -ENODEV;
 	}
 
-	ep = kzalloc(sizeof(*ep), GFP_ATOMIC);
+	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
 	if (!ep)
 		return -ENOMEM;
 
-- 
2.17.1

