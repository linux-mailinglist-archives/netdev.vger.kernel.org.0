Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA3633E4DD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhCQBAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhCQA7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D93A64FB6;
        Wed, 17 Mar 2021 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942739;
        bh=sXnRPHr0FhJAX0X7M0EATilAKgmtpfNIuhcP3QuKYyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbpQDiCMx9WI2I5Ub5mRyb0xUTfJuUdNeebRGJ8U8qxgE2AF6yJN0SHhjhRxDYa4c
         XT+9UeZvoQhgFMfUMGiycSwhuHIosdM+eEX/oyf6rmUrMujS6NYCJdfqpWH/+MQ18R
         +LMbcbUomo1x3iTqma8mcI2NPd5AsJHQsZQhb8H0bB69oOsJjYdmYPdjdhyWIjaZbO
         R+nCT7V22nAn1TXmd14EnsuOQMrvVc8ZDYce5cmCh1TrTmrpUzL42r0anCU7NxX6Y9
         D9/NBBXXuzcW5FKHde1D6XnVkI+GpLYErEp9Umcc1ZW3d8pk8d7wL2crpR/vGzBVrd
         we8MmPX922plQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/23] net: tehuti: fix error return code in bdx_probe()
Date:   Tue, 16 Mar 2021 20:58:33 -0400
Message-Id: <20210317005850.726479-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 38c26ff3048af50eee3fcd591921357ee5bfd9ee ]

When bdx_read_mac() fails, no error return code of bdx_probe()
is assigned.
To fix this bug, err is assigned with -EFAULT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tehuti/tehuti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index dc966ddb6d81..358f911fcd9d 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2056,6 +2056,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.30.1

