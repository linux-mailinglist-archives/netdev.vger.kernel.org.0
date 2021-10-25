Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E3C439D09
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhJYRLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234597AbhJYRDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED89360F22;
        Mon, 25 Oct 2021 17:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181275;
        bh=rnDD4WDFpKG1cuRhyxUS8s2pHW8MRe+5G+WBOMj0Oj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kM7Y4KKCZyYEDlQwEYz/QgSuvgGZGLBFU/BO5UnfPprShjN/N/JkOIusg/eCgsttd
         BlEJU+ed9/Zy5nw2EafIMbL0Dx0lbsg+wP0byZFa+6ZLK0KqemH+SwdaWaw3HJ//dn
         q/4y4Bsef1qGvxaFWhOpw1mEwEw0CGg9x7td5/hIzj9Py9yS1R/yn4AwrGyOeN18Em
         s68z/3LZnVeUqd7bcoMG+cJ8drXhMkK2XAW2Hil4MHytrA0kjtZwcZJoRxPS/oluKn
         ZhpxTXvCdmV0zIAt3rXhafA/CjDDRCAqy2JCOaVJt/FjZNAYdX0NSNchFJqJ4MOPGr
         WBtwv932WwoZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/7] cavium: Fix return values of the probe function
Date:   Mon, 25 Oct 2021 13:00:59 -0400
Message-Id: <20211025170103.1394651-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170103.1394651-1-sashal@kernel.org>
References: <20211025170103.1394651-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit c69b2f46876825c726bd8a97c7fa852d8932bc32 ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 99eea9e6a8ea..0fbb0dee2dcf 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1223,7 +1223,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (ret < 0) {
 		netdev_err(nic->netdev,
 			   "Req for #%d msix vectors failed\n", nic->num_vec);
-		return 1;
+		return ret;
 	}
 
 	sprintf(nic->irq_name[irq], "%s Mbox", "NICVF");
@@ -1242,7 +1242,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (!nicvf_check_pf_ready(nic)) {
 		nicvf_disable_intr(nic, NICVF_INTR_MBOX, 0);
 		nicvf_unregister_interrupts(nic);
-		return 1;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.33.0

