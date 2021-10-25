Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A667439C82
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhJYRDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234415AbhJYRDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF52860E97;
        Mon, 25 Oct 2021 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181239;
        bh=vQzakjc0BySDq1ORHnMLe2nf6/fKoVvOou4ryuYrTTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpEKwkU1/vaf6GBpB3UPRRYyCQoIs8VjCol0/9WzRQo2+k/dUrxo8sQF3B7lMKfIq
         ttQPS6QrWM0Sa/WAQIsEiX4GA90NLgwVBDNK6j7WjTvGnfXeH4sudHHrcUa1U6NcBv
         FIeRcr0MFsVDVPb4PCOHtk5bj5PK7K+13XZXi0MIsPNC9685AQLggvh5k2QdHn/bAp
         8V31wEe1LxLtpmMEvww5A1EaXMhqv47cia/1mtGIvVwhbyBG0CQQtJAQ7WPTlpIzuo
         ZLGDkQIgCTePju0LPXMozx+T+bFFk3mlXjqTuX6Se7LpxopDmOncck/0Ml/nDq7wgD
         xMfL6S2UOZ6ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/13] cavium: Fix return values of the probe function
Date:   Mon, 25 Oct 2021 13:00:17 -0400
Message-Id: <20211025170023.1394358-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
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
index f3b7b443f964..c00f1a7ffc15 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1226,7 +1226,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (ret < 0) {
 		netdev_err(nic->netdev,
 			   "Req for #%d msix vectors failed\n", nic->num_vec);
-		return 1;
+		return ret;
 	}
 
 	sprintf(nic->irq_name[irq], "%s Mbox", "NICVF");
@@ -1245,7 +1245,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (!nicvf_check_pf_ready(nic)) {
 		nicvf_disable_intr(nic, NICVF_INTR_MBOX, 0);
 		nicvf_unregister_interrupts(nic);
-		return 1;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.33.0

