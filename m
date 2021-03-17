Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6293A33E55E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhCQBDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231730AbhCQBAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE54B65018;
        Wed, 17 Mar 2021 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942815;
        bh=6MbzyU9GObKJwUVNcrbuVtXcHk0CIpvCUAPQlbRkRwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dycHkxu7fJizlf5wMahZ23XIoUP0OYtggPXOp2tVUeLZnYHjpq+NGZGlZ+iP1duR6
         ItL3GVa2a+W8HI3HrhmCFoJiIA5iGzyTXxR+N3R16Tx4cg+wLSQbGm0zPMacPM9+QI
         l6kqYusRtvaLC0I8M4MctLkCzq7S2fPDmcRc8ZltwXsYBveQcNRI6BXQfll84gRftt
         ULl2ik6j0fowTbfloLcmd+wz2DOoJhUqJN7w8SkgeN/Ytk6rUxyQlfCxZBvKs3ahAR
         0UOIc/qJyTdLgV/Kwq4eYaaq3+hYC4J04alJKVdMYsTkveqZq4lGEt7pE03jm38CJk
         cFN1g+DHmSRJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/14] net: tehuti: fix error return code in bdx_probe()
Date:   Tue, 16 Mar 2021 20:59:59 -0400
Message-Id: <20210317010008.727496-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317010008.727496-1-sashal@kernel.org>
References: <20210317010008.727496-1-sashal@kernel.org>
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
index 14c9d1baa85c..19c832aaecf0 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2068,6 +2068,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.30.1

