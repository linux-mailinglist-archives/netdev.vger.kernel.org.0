Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7A33DECDC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhHCLpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236333AbhHCLoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0E36104F;
        Tue,  3 Aug 2021 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991084;
        bh=gMNr1xTa7PcEHktNqKlEk3P0MqfPUA5Xwga69/sqMn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcN3GZcqdMnmQ0TDHuhIphozJZD89QVkYn/57brAuTi4PRs4MBe23UKrcwvRJqicb
         4b3cL49icOFlEZ/u4KnH/yF0NL7Jc3Bd3UwaFNRSmVj3P+PhGcI+sEViPJVTWw4laF
         Qzta0xfbaZRgeq3WfsinkqclWOfcRi4y6YyGsKdDp5dJaYAPmLJ1BpQch6u/IR03W2
         Ro8dXdnpzc1jppBao5KCMhKNoYc3v5cnc8EoDJ4wcEZglpl94mv7X4d98WRjTCSZPG
         Pnp8OTj12zyQSdcRq7Cmg25Mct779Yp4BROqv0+yEP0Ff50bYlfuPJjUSiEz430cTZ
         4BP/30sfejoAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/5] net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
Date:   Tue,  3 Aug 2021 07:44:37 -0400
Message-Id: <20210803114437.2253079-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114437.2253079-1-sashal@kernel.org>
References: <20210803114437.2253079-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit 92766c4628ea349c8ddab0cd7bd0488f36e5c4ce ]

When calling the 'ql_wait_for_drvr_lock' and 'ql_adapter_reset', the driver
has already acquired the spin lock, so the driver should not call 'ssleep'
in atomic context.

This bug can be fixed by using 'mdelay' instead of 'ssleep'.

Reported-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index a8bb061e1a8a..36c7d78ba780 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -155,7 +155,7 @@ static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
 				      "driver lock acquired\n");
 			return 1;
 		}
-		ssleep(1);
+		mdelay(1000);
 	} while (++i < 10);
 
 	netdev_err(qdev->ndev, "Timed out waiting for driver lock...\n");
@@ -3291,7 +3291,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 		if ((value & ISP_CONTROL_SR) == 0)
 			break;
 
-		ssleep(1);
+		mdelay(1000);
 	} while ((--max_wait_time));
 
 	/*
@@ -3327,7 +3327,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 						   ispControlStatus);
 			if ((value & ISP_CONTROL_FSR) == 0)
 				break;
-			ssleep(1);
+			mdelay(1000);
 		} while ((--max_wait_time));
 	}
 	if (max_wait_time == 0)
-- 
2.30.2

