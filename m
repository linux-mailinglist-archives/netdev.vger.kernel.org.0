Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DF03AF2F7
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhFUR6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232921AbhFUR4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E9E8613B0;
        Mon, 21 Jun 2021 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298001;
        bh=K4bp04oCwEygH4Z7SCz/2azf7J8VoGYWQeQxCcZc/9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPztXOZwEqGus81lz423emv+bWU4qSU1TXyfTGENGWlnpuUPJIgIzqvbcBBJyasiv
         vsAOEtY9By+8+mam/+0Kn94p4CfNZPDyqt0VNByjPHAQrmVW4duzUh6k893EhpadQf
         v0N2BfjgZX1g/AVHmPW1afTuTkQvzSMu5WPCZlZiOLTgov2gK+5cIMpNctgJHGyFG3
         DaWsotcJdqWJz3oqiyMfEwUunyLMJNPmTfApvjgnzKgsOfcoizNEXlWdHTQV56cJVc
         kCN+htCfM/A+RLjmgCN1quhcFxhLBFIQ4lwHX7OdXeKz5pEcZBgVXl+OP8UfQ8P2Rs
         7XqgZr1OwwpNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/35] net: ethtool: clear heap allocations for ethtool function
Date:   Mon, 21 Jun 2021 13:52:39 -0400
Message-Id: <20210621175300.735437-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 80ec82e3d2c1fab42eeb730aaa7985494a963d3f ]

Several ethtool functions leave heap uncleared (potentially) by
drivers. This will leave the unused portion of heap unchanged and
might copy the full contents back to userspace.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 2917af3f5ac1..68ff19af195c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1421,7 +1421,7 @@ static int ethtool_get_any_eeprom(struct net_device *dev, void __user *useraddr,
 	if (eeprom.offset + eeprom.len > total_len)
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1486,7 +1486,7 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 	if (eeprom.offset + eeprom.len > ops->get_eeprom_len(dev))
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1765,7 +1765,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 		return -EFAULT;
 
 	test.len = test_len;
-	data = kmalloc_array(test_len, sizeof(u64), GFP_USER);
+	data = kcalloc(test_len, sizeof(u64), GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -2281,7 +2281,7 @@ static int ethtool_get_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	ret = ops->get_tunable(dev, &tuna, data);
@@ -2473,7 +2473,7 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_phy_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	if (phy_drv_tunable) {
-- 
2.30.2

