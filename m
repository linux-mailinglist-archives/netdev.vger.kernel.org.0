Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CBE3AF3BB
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhFUSDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhFUSBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E03B1613EE;
        Mon, 21 Jun 2021 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298097;
        bh=iBufuNb8wcm7PSw+Q8O6JNA9qhKBaBJUm8eK0yZTf7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtJdWdW2m0FYols9fRPtwKMfgktRDTNnvdgivuoAmUHtzV5RaFNTuYWTF/+YFW5ta
         m5L0j/B9JoR/gqPRU8guWjSZ7tzeQZVaE9fzc9LVQWswLjFLvGEPST9kNYy+Dj07Ue
         X7tPBg3DF01dCiGwqVZGxs4OHUxVVknM7DLZHXUJKoCNiTMay0+epjG0BSh/jVSoV3
         38Z8EZ+0D03rlIIXURGuG7BML7BrRkyooYIqkmR+t7y7LJqcDLppVzveVjxLcgK1fx
         Zo7R8IHzWotFkz037PzJNcy6Fpbq2by7TjzSnJSETPWW5m+P2bG1x5toORrlFGOqa8
         f96XMEidBUSZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/16] net: ethtool: clear heap allocations for ethtool function
Date:   Mon, 21 Jun 2021 13:54:38 -0400
Message-Id: <20210621175450.736067-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175450.736067-1-sashal@kernel.org>
References: <20210621175450.736067-1-sashal@kernel.org>
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
 net/core/ethtool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 83028017c26d..4db9512feba8 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1594,7 +1594,7 @@ static int ethtool_get_any_eeprom(struct net_device *dev, void __user *useraddr,
 	if (eeprom.offset + eeprom.len > total_len)
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1659,7 +1659,7 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 	if (eeprom.offset + eeprom.len > ops->get_eeprom_len(dev))
 		return -EINVAL;
 
-	data = kmalloc(PAGE_SIZE, GFP_USER);
+	data = kzalloc(PAGE_SIZE, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -1840,7 +1840,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 		return -EFAULT;
 
 	test.len = test_len;
-	data = kmalloc_array(test_len, sizeof(u64), GFP_USER);
+	data = kcalloc(test_len, sizeof(u64), GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -2372,7 +2372,7 @@ static int ethtool_get_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	ret = ops->get_tunable(dev, &tuna, data);
@@ -2552,7 +2552,7 @@ static int get_phy_tunable(struct net_device *dev, void __user *useraddr)
 	ret = ethtool_phy_tunable_valid(&tuna);
 	if (ret)
 		return ret;
-	data = kmalloc(tuna.len, GFP_USER);
+	data = kzalloc(tuna.len, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 	mutex_lock(&phydev->lock);
-- 
2.30.2

