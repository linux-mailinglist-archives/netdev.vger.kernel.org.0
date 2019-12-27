Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C402812B805
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbfL0RxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbfL0Rm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B76222C4;
        Fri, 27 Dec 2019 17:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468577;
        bh=cvm6Tubwjns91fkDa13oFdyX0JbQwfytUtvHBYcMnjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2Esipl+vuPOv97eOPGjRIwOPNUwGNXk6byVKE5ztWitvGvqaB0StOt36pdoaDeoY
         omlq7nTpLUihvULrl5/srl88TptKcDivxNV8iw9FUsOd79pDuMaTc8slJh/LqIFCDl
         MpK513NbJPco6o/ZJgLgVf5Umbk4xqm3PRNiprkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 101/187] bnxt: apply computed clamp value for coalece parameter
Date:   Fri, 27 Dec 2019 12:39:29 -0500
Message-Id: <20191227174055.4923-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

[ Upstream commit 6adc4601c2a1ac87b4ab8ed0cb55db6efd0264e8 ]

After executing "ethtool -C eth0 rx-usecs-irq 0", the box becomes
unresponsive, likely due to interrupt livelock.  It appears that
a minimum clamp value for the irq timer is computed, but is never
applied.

Fix by applying the corrected clamp value.

Fixes: 74706afa712d ("bnxt_en: Update interrupt coalescing logic.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 04ec909e06df..d31637da2537 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6170,7 +6170,7 @@ static void bnxt_hwrm_set_coal_params(struct bnxt *bp,
 		tmr = bnxt_usec_to_coal_tmr(bp, hw_coal->coal_ticks_irq);
 		val = clamp_t(u16, tmr, 1,
 			      coal_cap->cmpl_aggr_dma_tmr_during_int_max);
-		req->cmpl_aggr_dma_tmr_during_int = cpu_to_le16(tmr);
+		req->cmpl_aggr_dma_tmr_during_int = cpu_to_le16(val);
 		req->enables |=
 			cpu_to_le16(BNXT_COAL_CMPL_AGGR_TMR_DURING_INT_ENABLE);
 	}
-- 
2.20.1

