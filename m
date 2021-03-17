Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3633E48A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhCQBAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhCQA6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E398664FCB;
        Wed, 17 Mar 2021 00:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942693;
        bh=/Wev9aWio+1f6LqRo9VXP2U1nNSFmlbOudj9KbBovlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUEK0VJsPWWeOoS40rmM29loDd/+mMVq2+VdgXkZyI0ycpssAbIWvhKj+vlQ2X9HK
         VMJHPdS0LH3PzHvsCkkmyVTKoO3zHX8/YfVIxiBkgJEU73apLslvdlb1JIaMiBIJe2
         L8y7rR7e3XL+TaCgCJJGMj/qCLJD2/J+TJI7geeVlf7RO2dFuDY1zp6b9zwox0I2SD
         T78q5Y9KvYpqmFvWyvbSFhVtk+g5M5SnldeMOJQxiXCCZV/bww7OskPqaCfokwL8cQ
         rWN62TMltkvzvuOwQrZ3DQ7TvBcBdfDl8uyx1lnhSCebDzg7jGJNrOSF8/DeESeANk
         Ql+hjOJOQGVJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/37] net: tehuti: fix error return code in bdx_probe()
Date:   Tue, 16 Mar 2021 20:57:33 -0400
Message-Id: <20210317005802.725825-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index 0f8a924fc60c..c6c1bb15557f 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2052,6 +2052,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.30.1

