Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249C93FB570
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhH3MDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236875AbhH3MBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8193611C5;
        Mon, 30 Aug 2021 12:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324837;
        bh=33DcH61tLZwlM98lnoBTHq6zyViBcn+gEVHifLvuihA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePnfIhc34Ks267VK4qSeSH0hlighED3PZUUWlYmPrgunNIh93T/6jZy9PsDueXn5K
         QAv5xmMK0WUzEZQ4J9ViHnM6BXF1F4UbwEYm26F0KxDo4axWJghwPiWIxxsRfIvhA6
         KspoFGHo4zyfOriqo30W0bOTHyzLQvyKz/MMKrCINmxqw69OVhbe7Qlq/VN20Xnq2+
         Q29SvdsA14CR+i1AbfeD6y1tfRZBs/Uytt3PCIFg64tVfd0TY8ttZERHWVVN0/7hJv
         hUFsnoh6p2ZRuBVPUwZGW+EKN0u2dJhgvXqkcD2RQbL//ZibQ+4iao0reytLFGv7an
         0G6fGl160AEMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/8] qede: Fix memset corruption
Date:   Mon, 30 Aug 2021 08:00:27 -0400
Message-Id: <20210830120031.1017977-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120031.1017977-1-sashal@kernel.org>
References: <20210830120031.1017977-1-sashal@kernel.org>
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
index 1aabb2e7a38b..756c5943f5e0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1676,6 +1676,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2193,7 +2194,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.30.2

