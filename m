Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C778B3FB544
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbhH3MCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237084AbhH3MB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF2C60525;
        Mon, 30 Aug 2021 12:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324863;
        bh=rtIVkDCTJch9eRFY0drIgdPfVahsP3zGcz9F12ZAvFc=;
        h=From:To:Cc:Subject:Date:From;
        b=DiK7LA33gDDy1R+uUiUTmHexubGEwi1VYjl1IecL9QJxqwUiQZmnTsqhGP5ZbVpYz
         8m+QAAcUlOT32fpiwSkqjpRJLauNyGR2KkA4Dw/pScRkuY3gW2L2dhsBUJeZKFx6RV
         D9eeXPLt72lvCsVMjDbbLVhvA1+bsLlHXK8cvWLJ+cS2gLxlrKFPG3LopUPIZYg3A6
         WgOiAxXJv1bMKJyyx6nhotXMAOrZbJeBu1XYMc3nQ2JtX2UfZXifWbaMy+xwhP2QXg
         v02CCzaWKq+0OeRcapdg/OJ8049ScNCVpqPnhOdj8ATy1HDqHr3y3ntgIC5DNubWRs
         r3Sg8nuCivycg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/3] qede: Fix memset corruption
Date:   Mon, 30 Aug 2021 08:00:59 -0400
Message-Id: <20210830120101.1018298-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit e543468869e2532f5d7926e8f417782b48eca3dc ]

Thanks to Kees Cook who detected the problem of memset that starting
from not the first member, but sized for the whole struct.
The better change will be to remove the redundant memset and to clear
only the msix_cnt member.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Reported-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index c677b69bbb0b..22c6eaaf3d9f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1918,6 +1918,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2341,7 +2342,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode)
 
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.30.2

