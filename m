Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D942628C070
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391280AbgJLTEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391125AbgJLTDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F245221EB;
        Mon, 12 Oct 2020 19:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529424;
        bh=FdKkHw142Ymy1pcCgYSA/nu3Kwz934UC6NVmpqHPRaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ju96/DRH2UINsuvYEmi14ZCvQnHSVCP1p5PUMCnlEFQWZ1zHNbj+D5HLlv+AWNWBL
         LwNCy5Q91CHQtYCcGTnlaDOatjVSvSHnsBCOvVvCN9ak+St6K3kRbxNshQK2lwoia1
         ZkQe/irnUGmikGnoDnraoO930A63dQjzVvvOvWsA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/12] via-rhine: Fix for the hardware having a reset failure after resume
Date:   Mon, 12 Oct 2020 15:03:29 -0400
Message-Id: <20201012190335.3279538-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190335.3279538-1-sashal@kernel.org>
References: <20201012190335.3279538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

[ Upstream commit d120c9a81e32c43cba8017dec873b6a414898716 ]

In rhine_resume() and rhine_suspend(), the code calls netif_running()
to see if the network interface is down or not.  If it is down (i.e.,
netif_running() returning false), they will skip any housekeeping work
within the function relating to the hardware.  This becomes a problem
when the hardware resumes from a standby since it is counting on
rhine_resume() to map its MMIO and power up rest of the hardware.
Not getting its MMIO remapped and rest of the hardware powered
up lead to a soft reset failure and hardware disappearance.  The
solution is to map its MMIO and power up rest of the hardware inside
rhine_open() before soft reset is to be performed.  This solution was
verified on ASUS P5V800-VM mainboard's integrated Rhine-II Ethernet
MAC inside VIA Technologies VT8251 South Bridge.

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/via/via-rhine.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 33949248c829e..b38ab17e9b132 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1710,6 +1710,8 @@ static int rhine_open(struct net_device *dev)
 		goto out_free_ring;
 
 	alloc_tbufs(dev);
+	enable_mmio(rp->pioaddr, rp->quirks);
+	rhine_power_init(dev);
 	rhine_chip_reset(dev);
 	rhine_task_enable(rp);
 	init_registers(dev);
-- 
2.25.1

