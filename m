Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92F41FDC43
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgFRBSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727098AbgFRBSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6119821D7E;
        Thu, 18 Jun 2020 01:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443090;
        bh=2qodh3uYCK+UWwNLdpcdGPCezWMVsZdyfkfnb++3Vr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkAgnsYv0HB2NgMG1TiZYCvO06Vvdo3vIyrK61uZrDt6cuvCt84PCDtuYwZbKEaQU
         dYehMWaquGKo1oXmTdkLY7wzfU9QEZoqWp0DmQx651ZX+14KenKfFRJmf+AW7cLADD
         cjK/X4v6mWlo7v9dV38xpPuzBH4kayX5dYEyM69s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 071/266] yam: fix possible memory leak in yam_init_driver
Date:   Wed, 17 Jun 2020 21:13:16 -0400
Message-Id: <20200618011631.604574-71-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
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
index 71cdef9fb56b..5ab53e9942f3 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1133,6 +1133,7 @@ static int __init yam_init_driver(void)
 		err = register_netdev(dev);
 		if (err) {
 			printk(KERN_WARNING "yam: cannot register net device %s\n", dev->name);
+			free_netdev(dev);
 			goto error;
 		}
 		yam_devs[i] = dev;
-- 
2.25.1

