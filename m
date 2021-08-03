Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAF23DECB9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbhHCLpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235803AbhHCLok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8795460EE9;
        Tue,  3 Aug 2021 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991069;
        bh=Fr9fWJZ6P9hFkMTIaJf8zVHekJKi7LwuDtiSoVlG4Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFFs22OQ+JsStbavg640vVx3m+9lMWoGl5PH5ay4N7OHyKbVXSThMrC/ImkWB6XGY
         hGQNlos52DWQub9ZKu27bhmDszf4YlW3DroqquAJKDA1zKTzwlA7mLOYyIypmkxvmC
         rQVtj+1Gi5+SQhG9Eo2V3K44Xl9WRthiNBVqLsU0Nyv3VoOEJN3gwPi2EJzRJ0skZQ
         JPOJF4oxswbJthA7g6a4uIIPFkUilRCsANSHv2dGS4QveRUDNymenhoCmMeoqkFbNM
         UyZ6yKTPr7VORkudiDF+bBPQGxxHisNM4vstZUt8QzuSk3xNv62hNBJMp5tudXRHjH
         DQVaTMWcGrLAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/6] net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
Date:   Tue,  3 Aug 2021 07:44:21 -0400
Message-Id: <20210803114421.2252840-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114421.2252840-1-sashal@kernel.org>
References: <20210803114421.2252840-1-sashal@kernel.org>
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
index 5dc36c51636c..6ca2216e4058 100644
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

