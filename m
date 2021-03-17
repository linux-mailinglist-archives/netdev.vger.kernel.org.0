Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75EF33E3DB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCQA5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231157AbhCQA5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B04E064FC0;
        Wed, 17 Mar 2021 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942630;
        bh=wzE1/pH3sttOMtpx9P/3mP60bD/P+dRiprD1JqRIWPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbekOeMI1G+pXOA83eBOpiG4qGWljOZFG6EEMb66go0mZuY1dA+y7TkKoHx7HKH/l
         zbK9W+3xPy8Pn/5BIqdNj8FJsaDLbj4DSSttIuVp1cGgCVIeRR8tncJ+KbXRk7Nhdq
         KQ7jx0CL2hSzmABxTaaIt9igYcMP16SpNL6qTqrDu9WpvlyiWwiL4Oa53St3DfgO2V
         4FwYWV2q9LKp35C+zDpWPtxoG3nZCv8X4R6Nl3zVgSE+w//y1AlBsLeGtFi6ctimwD
         OtW6rNY5ahuHr/kj4sMvZa2221R25mPTmCE2wPxX5wwETwmbhVJHQC+cb2PsKBNMDB
         eMcq6HpcvvfDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/54] net: tehuti: fix error return code in bdx_probe()
Date:   Tue, 16 Mar 2021 20:56:11 -0400
Message-Id: <20210317005654.724862-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index b8f4f419173f..d054c6e83b1c 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2044,6 +2044,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.30.1

