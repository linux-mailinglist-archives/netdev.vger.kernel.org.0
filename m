Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5DE4228C4
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhJENyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235673AbhJENxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 967E261880;
        Tue,  5 Oct 2021 13:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441873;
        bh=fEl8BJgrezmtg7ruCQ4UqWxbxPp54n7YB32+vPu8PqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBd2Y37NI5uoMIAJG29YZnHJQScwvUJmmjqRuAjMJsYdYGcc5I2lfV8qGyIuyk29p
         o4phLh0xh+w5oELlNKXGl8f3z+zG5HZ3zsQhAJXep/k7J7JYU8zfy6k6C7JqyRooEE
         M+GFUHBG0fr4rgVJcz748tclc/Wxcg7t3dYsZ+tqNEVyTco09/7NG61akkpXtiZw66
         6mOPVCFHhC0+Of893WhtRh695FY47e8XDAFMKOIKqSyo8wwNKf914LO994oUx7sNxs
         oDI9IAVNZ31B4HZ6w6nG+lgWrSMnH4vytLh955NJPAj4mSSoe+uAfxgym1N4wUhqob
         7F7U/UdNEjSAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 27/40] net: bgmac-platform: handle mac-address deferral
Date:   Tue,  5 Oct 2021 09:50:06 -0400
Message-Id: <20211005135020.214291-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

[ Upstream commit 763716a55cb1f480ffe1a9702e6b5d9ea1a80a24 ]

This patch is a replication of Christian Lamparter's "net: bgmac-bcma:
handle deferred probe error due to mac-address" patch for the
bgmac-platform driver [1].

As is the case with the bgmac-bcma driver, this change is to cover the
scenario where the MAC address cannot yet be discovered due to reliance
on an nvmem provider which is yet to be instantiated, resulting in a
random address being assigned that has to be manually overridden.

[1] https://lore.kernel.org/netdev/20210919115725.29064-1-chunkeey@gmail.com

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac-platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index 4ab5bf64d353..df8ff839cc62 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -192,6 +192,9 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->dma_dev = &pdev->dev;
 
 	ret = of_get_mac_address(np, bgmac->net_dev->dev_addr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+
 	if (ret)
 		dev_warn(&pdev->dev,
 			 "MAC address not present in device tree\n");
-- 
2.33.0

