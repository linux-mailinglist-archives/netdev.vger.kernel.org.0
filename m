Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BFB3DECF7
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhHCLos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235900AbhHCLoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FFD60F92;
        Tue,  3 Aug 2021 11:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991042;
        bh=btAsWNFwkIaXSn8TsKrBntDZORAVNEY1cv5+S42XIlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvc9wPe7iM53uQXKeloDMdge5FNmnDTni/jHJaO4e/3K/MLKSZzkJMGcXtuc0LYPx
         eIhjc6QphLumyCX9PtMIM7ndGh4Kqbp4kQdOMZi0EpYovLKheb0BeECv5hwYl/Gs9W
         OsaiNuAxr1fQs7Xn4Bqg6q96hMbNzykv1SNAB7Ig9oPYdhNO6gOT+GS2hF81zs08AF
         oQK3DBkbdgaUDgOLDJKaWGwroAQX5Ye1vjgl7qZdJWERCsDB98lz1cZCuNlffAoTwG
         bbpoF7Id8LWbdqIPO/ggnEJTCiZeOz827g/hTrM75irkGFxU/PXGmP8PJTlbzWG39j
         mBMJ+ZMytvF0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 07/11] net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset
Date:   Tue,  3 Aug 2021 07:43:48 -0400
Message-Id: <20210803114352.2252544-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114352.2252544-1-sashal@kernel.org>
References: <20210803114352.2252544-1-sashal@kernel.org>
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
2.30.2

