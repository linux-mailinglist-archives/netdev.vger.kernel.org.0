Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD07049C03A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiAZAiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33936 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiAZAiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08A90B81B9F
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8FDC340EB;
        Wed, 26 Jan 2022 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643157487;
        bh=XIKhWG/yrRc9acbEBo5t9YJGBTtlszI2HeaFhi/4TRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OgdxwivgzWmvyidgBjcRhuuUBPsgDyZ8GbOsoixEo4N6pOiXvFuVfjDYQX8sKQ8+X
         ws9La5cpfAd8hVymz440zUtGLWHxVcNcfCbUAbxR7FeiBjB7KcNpY1aFcay9c8PFc8
         ie9NtI1mb7apCkZCi8Lnkopu/VEVRHv4LE6yM4R+MuItRfUvUFvhtB0KpEmA6hhpSC
         dgm87CFAeWoWFlBq0CgIdcGbHWRF1Jzo4TJgKPRtXoJt7WRzAkdNpuMFNlaJ8NcDJ0
         tvMXz98xY0l9FD/RI4rzO2gjDc8SAttXvpB7ijkS9pTTlxwJSS8oKSVlz/knkTxQ3B
         +SeBS4fbIs6NA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 6/6] ethernet: seeq/ether3: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 16:38:01 -0800
Message-Id: <20220126003801.1736586-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126003801.1736586-1-kuba@kernel.org>
References: <20220126003801.1736586-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr is const now.

Compile tested rpc_defconfig w/ GCC 8.5.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/seeq/ether3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 16a4cbae9326..c672f92d65e9 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -749,6 +749,7 @@ ether3_probe(struct expansion_card *ec, const struct ecard_id *id)
 	const struct ether3_data *data = id->data;
 	struct net_device *dev;
 	int bus_type, ret;
+	u8 addr[ETH_ALEN];
 
 	ether3_banner();
 
@@ -776,7 +777,8 @@ ether3_probe(struct expansion_card *ec, const struct ecard_id *id)
 	priv(dev)->seeq = priv(dev)->base + data->base_offset;
 	dev->irq = ec->irq;
 
-	ether3_addr(dev->dev_addr, ec);
+	ether3_addr(addr, ec);
+	eth_hw_addr_set(dev, addr);
 
 	priv(dev)->dev = dev;
 	timer_setup(&priv(dev)->timer, ether3_ledoff, 0);
-- 
2.34.1

