Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F15A491BB9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbiARDIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352263AbiARC7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:59:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCFCC0619CA;
        Mon, 17 Jan 2022 18:34:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623E2B81244;
        Tue, 18 Jan 2022 02:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702C7C36AE3;
        Tue, 18 Jan 2022 02:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473241;
        bh=hYeI/RffiKpdM6X+dBkRzZja9+0y5/A2IGZkn+XN/zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ih9v1Ts4fFchorqZYMce6HMEq0Zj+TB1pNH8vSt7pYSjC11viYvElTqcPYjrwtq41
         UF04GAx8QXEZQYCyMs3KvlGD/zPGynCYJx5vdiI7vFq1VaPgAkoTMQ8oxP7gv3/0Qx
         viWB5vObGduOK/+ZLIfnf/kcCYvA4M2gC1eCAWDFV9N8Vm++zkimUMR5pz7sgR5Sgs
         ksnoG7gagXcTIpfnSU9Fi+MlVfCQLjueLAQ1pnZEvnqCIfPUM5UHBmxrCqh8HEQ0ck
         5XdmPS+QQCCAXDBwAA7k5crmQutRi6HyuT6Exvu7mbuKmgKyfglXM2xoOqDDCSQL8g
         1EXMadcj6wnGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 037/188] 8390: wd: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:21 -0500
Message-Id: <20220118023152.1948105-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f95f8e890a2aa576425402fea44bfa657e8ccaa6 ]

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/wd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index 263a942d81fad..5b00c452bede6 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -168,6 +168,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 	int checksum = 0;
 	int ancient = 0;			/* An old card without config registers. */
 	int word16 = 0;				/* 0 = 8 bit, 1 = 16 bit */
+	u8 addr[ETH_ALEN];
 	const char *model_name;
 	static unsigned version_printed;
 	struct ei_device *ei_local = netdev_priv(dev);
@@ -191,7 +192,8 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 		netdev_info(dev, version);
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(ioaddr + 8 + i);
+		addr[i] = inb(ioaddr + 8 + i);
+	eth_hw_addr_set(dev, addr);
 
 	netdev_info(dev, "WD80x3 at %#3x, %pM", ioaddr, dev->dev_addr);
 
-- 
2.34.1

