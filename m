Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CC96A1F4
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 07:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733110AbfGPFwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 01:52:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37282 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfGPFwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 01:52:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so9513708plr.4
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 22:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QQ2ug0XR7SjX83JZC95By4qdW13anT8lE1WwBsOGg8=;
        b=nBo7wfFcvZKjZ9OuKdL/DisNygkqoFsIXu96HiDI19Ebim+QME0Ukeg6psOUC4Yqz7
         LAWz8JhnJ8BvkDoU6aYz95bRMd33wJyG/b0fKjWBUlTRTs+xIXVBCVLdMDDjziNdLUhl
         yhmLXXu28YsTwUryg/9LWwKte66JxVUfYr92q0kx6Ns7XhIubH2sr87daI5hFFk6Nslm
         uFoqEXNlcoCQsW4/k4Qc6LVGUGDpyLhyBvkCaljRQHB9cv1YfTmnrnwJEloETz8NsQKn
         YBFYEMdqD5C8b7yweuBuCu8XavOsqw9AGHTACT/ZBuRb8g6yx0EwwkziNk3vGSm66Q/Q
         aXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1QQ2ug0XR7SjX83JZC95By4qdW13anT8lE1WwBsOGg8=;
        b=QrXRakoMYQButww6ktuBmZURU1aXKcjgC0NNdlDBtr/dbhMTUGDDcn7hCQPWu64cCp
         AWI5GLJ+vZlnSFLH5+nVh5AZ6SwuuppyLlcUPCJJ7waSiR68okj21U8qD1Ar8tIkUApy
         seSXM2tIcDHYyzE/VWKwUPB2ZzfMxp8FecqE3Vz6cr1t4L3aYHIulleKrEdXaWg2Sg0V
         /rt09+JqHX2Q19qUVT85f1YX4YrF2AhkJ/dG8Ackqvmvuoa8kKnTDe5XLkh98T1sRDZk
         XNtdttfLSGydUsswb54ZZVdKV/6e5bPjc0dCk/EsXAWsYoswjbnNGqNpk1P/spDwTuvC
         uMJA==
X-Gm-Message-State: APjAAAV0aXcjFDEQyqTclkD+uH9FvUDbapYnfok9WCfX7aWGHBgZD+V2
        TNDEGeLICCprQ7zHBSeXyMBdUI2V
X-Google-Smtp-Source: APXvYqyFLKtD/96whBz/OvL24ukHI50LwYBVJZlXB8AYlf7IFtRadLNFfrgv0FtjPnWwaujROGzBqg==
X-Received: by 2002:a17:902:6b85:: with SMTP id p5mr30470844plk.225.1563256355843;
        Mon, 15 Jul 2019 22:52:35 -0700 (PDT)
Received: from localhost.localdomain ([110.227.64.207])
        by smtp.gmail.com with ESMTPSA id p1sm21496992pff.74.2019.07.15.22.52.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 22:52:35 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     alexandre.belloni@bootlin.com, unglinuxdriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: ethernet: mscc: ocelot_board: Add of_node_put() before return
Date:   Tue, 16 Jul 2019 11:22:19 +0530
Message-Id: <20190716055219.3051-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each iteration of for_each_available_child_of_node puts the previous
node, but in the case of a return from the middle of the loop, there is
no put, thus causing a memory leak. Hence add an of_node_put before the
return in two places.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 58bde1a9eacb..2451d4a96490 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -291,8 +291,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			continue;
 
 		err = ocelot_probe_port(ocelot, port, regs, phy);
-		if (err)
+		if (err) {
+			of_node_put(portnp);
 			return err;
+		}
 
 		phy_mode = of_get_phy_mode(portnp);
 		if (phy_mode < 0)
@@ -318,6 +320,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			dev_err(ocelot->dev,
 				"invalid phy mode for port%d, (Q)SGMII only\n",
 				port);
+			of_node_put(portnp);
 			return -EINVAL;
 		}
 
-- 
2.19.1

