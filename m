Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5754633E450
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhCQA7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhCQA6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA8064F8F;
        Wed, 17 Mar 2021 00:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942684;
        bh=qX4f7AjnGP5QMjGMo3DlAfac9XnlSecuHhcjJ5ncl5Y=;
        h=From:To:Cc:Subject:Date:From;
        b=RLqEs5bDmzIu6nWTLu/a9VwH2w34DoYC6e8OqS16wbFPrr3p1GzjZYvImpN3F7iPe
         WQ+wefcmDalHVOZxCl1vQPUK0vRnI8o95vup4iUSB1fxqIyxo6MXZhlIh+HIrSrC7U
         fxyP1JVdyz4vJ7Q90S+Thz/KtNCTKqD2fjgCIRIaVctLV39Vhmw80sG1L/0HROKfBM
         Zx96yKG8iYRgyrmM8wHuRFHAdZUxI4iwQfFKxXio+ZEsLdbYZj7as97mcVPsup5rVe
         efS4nEEyMAHYiIR8e1lzn9HpK30Qor/te2mhvTVzX7G1VQYG6TENmIIq4ZXzZTvQIM
         zbJs2M5a0EIWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Thiery <heiko.thiery@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/37] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Tue, 16 Mar 2021 20:57:26 -0400
Message-Id: <20210317005802.725825-1-sashal@kernel.org>
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
index 945643c02615..49fad118988b 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -382,9 +382,16 @@ static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
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

