Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F243FB4F8
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhH3MAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236636AbhH3MAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 428EE60232;
        Mon, 30 Aug 2021 11:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324794;
        bh=abuErqcroEVMRrvQQG4hxa9a9UeiyGaWc4yYlMcyEpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+umHg0B6OwckneYPe5qB3IWP43p6+qiLOTW2mnjAM0nGzTpLHsvQfYJQqnZdFz16
         y7caCVbToNR0YCFZgo3A8ZUZKQhBZuXxtpRmtFY6pJIo8ies4pDaX0LPxfUQ1FfV7w
         88uH+JAfSqw+pcgcFBSNhyO7cjpzt/HrraXa384oV8uCp7hql1wA28rlSAyX3mLVMi
         jDMHZS/8WaYYfxKixoxaOGBsUPF4S+yTC6zULfYBbidR+r5c+CEudItTPesC4ZUbcG
         iCHkcnxyQXh1zvnSjuOmt8yEv3cTVbSp0H9RpouthSJ6mkIB5KuM4/+YfVx7qgtiY9
         7nmrTOcaq67zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 08/14] qede: Fix memset corruption
Date:   Mon, 30 Aug 2021 07:59:36 -0400
Message-Id: <20210830115942.1017300-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
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
index 7c6064baeba2..1c7f9ed6f1c1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1874,6 +1874,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2427,7 +2428,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
-- 
2.30.2

