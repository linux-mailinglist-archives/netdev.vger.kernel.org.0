Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769CB34DACA
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhC2WXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232259AbhC2WWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3055F61996;
        Mon, 29 Mar 2021 22:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056572;
        bh=vWRBsgeifkSEGdDN43XjQ99C3pOTI2n8xztY6JaE9is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7iP2TrKDQbh0LZjojiZvWU9uyxNcABR/k9TBZUi5BG669HEkNloppFAzRVgYqCvK
         3QvqGsE1hANe3fq7rh70simzfZXwO2p/dExCwQ9vdIjU17Cyo0zu9Cwd7jQa2fT43o
         wtxiTBwmjDqSBrDlTajG55QJ+6ZfhaKlqhwzKvUNamDRJBNOt4zKg4GIuy6lD5YIuI
         HZkJpPJH0MZnjZvQSiZoW9CGIH3e0aRk2EvGG0t5yUsTy2HSacRUeX6ascPHuadv34
         Pgs0hpCaMAZJBs7NWpVPwADbtAIpeTjEnBVlmwU3sGSbSjbN5N3qmmbDywN+0hohQp
         rH2qduxDZce4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 25/33] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation
Date:   Mon, 29 Mar 2021 18:22:13 -0400
Message-Id: <20210329222222.2382987-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

[ Upstream commit f51d7bf1dbe5522c51c93fe8faa5f4abbdf339cd ]

Current calculation for diff of TMR_ADD register value may have
64-bit overflow in this code line, when long type scaled_ppm is
large.

adj *= scaled_ppm;

This patch is to resolve it by using mul_u64_u64_div_u64().

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_qoriq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index beb5f74944cd..08f4cf0ad9e3 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -189,15 +189,16 @@ int ptp_qoriq_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	tmr_add = ptp_qoriq->tmr_add;
 	adj = tmr_add;
 
-	/* calculate diff as adj*(scaled_ppm/65536)/1000000
-	 * and round() to the nearest integer
+	/*
+	 * Calculate diff and round() to the nearest integer
+	 *
+	 * diff = adj * (ppb / 1000000000)
+	 *      = adj * scaled_ppm / 65536000000
 	 */
-	adj *= scaled_ppm;
-	diff = div_u64(adj, 8000000);
-	diff = (diff >> 13) + ((diff >> 12) & 1);
+	diff = mul_u64_u64_div_u64(adj, scaled_ppm, 32768000000);
+	diff = DIV64_U64_ROUND_UP(diff, 2);
 
 	tmr_add = neg_adj ? tmr_add - diff : tmr_add + diff;
-
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_add, tmr_add);
 
 	return 0;
-- 
2.30.1

