Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5327A33E4EF
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhCQBA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhCQA7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 916E264F8F;
        Wed, 17 Mar 2021 00:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942762;
        bh=Coa8wXmQ4nAITFXwC39SY+BgDdXcMylHXeG7flgVsoA=;
        h=From:To:Cc:Subject:Date:From;
        b=PKhpymkYWqluE/YlVdJdilKrU1YcwDIjXB13dqnNROStVtQohetMXl5tbqvtETpK8
         WakV67+s9S0yuwoGUSM3H+ZHJEHEVWWIB4w8L3J9H6dgkMINmjjkhlJSr6Q277zHoo
         rAr4IRufmyKoKIKWJRQdk8kAQFW13s2+2btJlgaG3gDc42AS9g4sWF0SkJ8b+M6DpI
         q7dwl0ZcJ/gp7GPCiqRA3/B/oHihzs9laBe45gxMaZ34VADctOrbzq77xnBONpvHkD
         zBjxd9DvkIfGBNRaRHP4rSAJb9f7dDS2ucB2Ug5H9rmO9L8Y2WuH/Glyvis6gRIPjy
         zovpFJNHAoDjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Thiery <heiko.thiery@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/21] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Tue, 16 Mar 2021 20:59:00 -0400
Message-Id: <20210317005920.726931-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Thiery <heiko.thiery@gmail.com>

[ Upstream commit 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5 ]

When accessing the timecounter register on an i.MX8MQ the kernel hangs.
This is only the case when the interface is down. This can be reproduced
by reading with 'phc_ctrl eth0 get'.

Like described in the change in 91c0d987a9788dcc5fe26baafd73bf9242b68900
the igp clock is disabled when the interface is down and leads to a
system hang.

So we check if the ptp clock status before reading the timecounter
register.

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20210225211514.9115-1-heiko.thiery@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 6ebad3fac81d..e63df6455fba 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -396,9 +396,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	u64 ns;
 	unsigned long flags;
 
+	mutex_lock(&adapter->ptp_clk_mutex);
+	/* Check the ptp clock */
+	if (!adapter->ptp_clk_on) {
+		mutex_unlock(&adapter->ptp_clk_mutex);
+		return -EINVAL;
+	}
 	spin_lock_irqsave(&adapter->tmreg_lock, flags);
 	ns = timecounter_read(&adapter->tc);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
+	mutex_unlock(&adapter->ptp_clk_mutex);
 
 	*ts = ns_to_timespec64(ns);
 
-- 
2.30.1

