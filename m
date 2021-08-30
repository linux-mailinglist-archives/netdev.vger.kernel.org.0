Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D973FB54D
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhH3MCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237037AbhH3MBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE806115B;
        Mon, 30 Aug 2021 12:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324856;
        bh=FFHLL3awDRe9A6BYmS2lonDjSAQGE4YHpgoABqyor48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzY1+36eIA9NP+1J0f+fcWGVhHeR3roTid59KutHdUSqrxQInYfr41oiIxDdWiJwX
         RZIQLRw/5EVZ5tq6IphOsR96JHWhhMDL/Ow+Hx3MjeM8nFBfV1zueoke77BzTZAdSX
         1qCkMrmyOImK9koQYSVzOscSxX9HRYw5NOwedPPlTyXHZEMhxpWRC4v23VEEFc06SZ
         Kc2aSiqvoRpjhHkhXCRQ4SuLaFCMbU8Po8BucHxFdNM5SRagVdHNyZf4tQzMvY1lzV
         OzhbU0ttRopSecz1jcSYPRV3zF0q9Hw9FzLjtFnkbrmOcXkiFVDzUO+SfSctkjzAB0
         yUqO61dZivIzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/5] qede: Fix memset corruption
Date:   Mon, 30 Aug 2021 08:00:50 -0400
Message-Id: <20210830120053.1018205-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120053.1018205-1-sashal@kernel.org>
References: <20210830120053.1018205-1-sashal@kernel.org>
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
index 9b1920b58594..d21a73bc4cde 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -3145,6 +3145,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -3644,7 +3645,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode)
 
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.30.2

