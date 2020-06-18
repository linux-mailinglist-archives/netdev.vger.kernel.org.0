Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475061FE115
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgFRB0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgFRB0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D9F20776;
        Thu, 18 Jun 2020 01:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443600;
        bh=eLj+WZVX7RpEdUqqaCcfffgguX5NmI4xWHrpyxqcq7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI/F9QmNO2nV/RHuuAjyTawetsfqfWoSRMoN5m3tVFzxILj7FMAfK/bwyrqVzBFfN
         V5Cd5qCT7Pf4nZfdqy5f/loh2zEXM0YLAtx4epzx7fvFWPorLgb+EGRYEF9QnPhfxX
         3FKdkDr5fcNeH0F96ryYlwPwjy4k6x8C53ainFhY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 030/108] yam: fix possible memory leak in yam_init_driver
Date:   Wed, 17 Jun 2020 21:24:42 -0400
Message-Id: <20200618012600.608744-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 98749b7188affbf2900c2aab704a8853901d1139 ]

If register_netdev(dev) fails, free_netdev(dev) needs
to be called, otherwise a memory leak will occur.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/yam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 16a6e1193912..b74c735a423d 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1162,6 +1162,7 @@ static int __init yam_init_driver(void)
 		err = register_netdev(dev);
 		if (err) {
 			printk(KERN_WARNING "yam: cannot register net device %s\n", dev->name);
+			free_netdev(dev);
 			goto error;
 		}
 		yam_devs[i] = dev;
-- 
2.25.1

