Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DF233E553
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhCQBC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhCQBAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D3F364FC3;
        Wed, 17 Mar 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942810;
        bh=L+OjKZDtRg77oC6iupFoK//kSUoajNgKI8lXu5a7W84=;
        h=From:To:Cc:Subject:Date:From;
        b=dIYYF6wHSLD8NseOMUEWHfYwsCJKaQK5Vo6F35S96Nrqm0zkslEQBj3uNqCdlAvGz
         hn/VLlz98zOpsykgMenwjixsJ7haXSaPLLOdMw9C+/I4HIBMw+xcDq15Z1RBv1yah2
         JpmZafkvsiAsdKVIdcuxvwm1HCEVPS5Q01W/75+p3/pgvK2IPZpqMdsgN/7snrcSvR
         8RN/Aj66zTfbPIgjqGbgvIQAvDw8B+5A4neU/vJ5PhP0BzUu4a9fGG3Fi6DfFaM5zd
         wLJx4txJxPHh81BlYjcrWey8HFaurdds9iPIKMXQs6B36zy3xESgEvhTxzQVB4Gfvd
         D36SmMhpPmVNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Thiery <heiko.thiery@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/14] net: fec: ptp: avoid register access when ipg clock is disabled
Date:   Tue, 16 Mar 2021 20:59:55 -0400
Message-Id: <20210317010008.727496-1-sashal@kernel.org>
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
index f9e74461bdc0..123181612595 100644
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

