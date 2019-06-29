Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530875AC1F
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF2PRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:17:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37827 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfF2PRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:17:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id g15so2021600pgi.4
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L1O6hShoZAyH3k160FlbG+43T9P9C6aounc+89AA/Ak=;
        b=dZnkZJw9P/Ha3O6eO1OGu671PF0xE0xRtwjOrMoxjQV3/kjay9U9X2jSe0U67Zn9IY
         87Dh7ZtNAGxr5MM2pCeeUNeHcjsWyzHZsojFg+haMNr7fuZiAq9MgI3Ic8yMFA/ib4Kt
         zVnX2pIVv7tJh/m0mLxA3PhVUy8ily2o8BQfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L1O6hShoZAyH3k160FlbG+43T9P9C6aounc+89AA/Ak=;
        b=bM5sO1mXIse3B/yz2rGFdeAKwCnEupGmRDt5WMRppLFovbfhhjfJbLWm/ehNiIS5L9
         IoFemPjtWPyrl/fjfTwtLz57naoHVIjwvWPXjJSiL99YaojKnnV8wGd9k07i7baU93xp
         5IcohYMAh5mMUkkNcAx0aZ6bx3XGQuGOGJKUOmhC4PW2YE/Q/ZmtR3X7Gb4bfh/Ds6xK
         TvlP3WO8SjH5xP0n/92Ue5PF08sw2ZltUG8RtfaezJhInPq/spvcS4EuZkGTmwM0BQAd
         lXvjCAHes/qrWbI3kAB6MWevi0zw0U++0tqkVkZeO/KjuEzwHRQsqXUrvqa2SgJj3AWL
         Vyrg==
X-Gm-Message-State: APjAAAUJxPdZRO1oGCLBlRLszFFpBdqh/6eu2XZHaJl27M4runf4X0Dc
        kxepjKZqK+U6xG0Z5QsJZjV5cQ==
X-Google-Smtp-Source: APXvYqwuQRTKhC0rPNFaeOCYdtX7w9XP6v8kC8+LORfMOPIa6+0W+9lYWn/GgQ9lvYadHxnFceUkWw==
X-Received: by 2002:a63:607:: with SMTP id 7mr12473542pgg.240.1561821438237;
        Sat, 29 Jun 2019 08:17:18 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z14sm5048233pgs.79.2019.06.29.08.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 08:17:17 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/5] bnxt_en: Fix ethtool selftest crash under error conditions.
Date:   Sat, 29 Jun 2019 11:16:45 -0400
Message-Id: <1561821408-17418-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
References: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After ethtool loopback packet tests, we re-open the nic for the next
IRQ test.  If the open fails, we must not proceed with the IRQ test
or we will crash with NULL pointer dereference.  Fix it by checking
the bnxt_open_nic() return code before proceeding.

Reported-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
Fixes: 67fea463fd87 ("bnxt_en: Add interrupt test to ethtool -t selftest.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a6c7baf..ec68707 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2842,7 +2842,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 	bool offline = false;
 	u8 test_results = 0;
 	u8 test_mask = 0;
-	int rc, i;
+	int rc = 0, i;
 
 	if (!bp->num_tests || !BNXT_SINGLE_PF(bp))
 		return;
@@ -2913,9 +2913,9 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		}
 		bnxt_hwrm_phy_loopback(bp, false, false);
 		bnxt_half_close_nic(bp);
-		bnxt_open_nic(bp, false, true);
+		rc = bnxt_open_nic(bp, false, true);
 	}
-	if (bnxt_test_irq(bp)) {
+	if (rc || bnxt_test_irq(bp)) {
 		buf[BNXT_IRQ_TEST_IDX] = 1;
 		etest->flags |= ETH_TEST_FL_FAILED;
 	}
-- 
2.5.1

