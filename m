Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CC51D3B3D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgENTAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbgENSz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:55:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ABBB207F9;
        Thu, 14 May 2020 18:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482558;
        bh=IdxDJ4cILLHt9n5npaAJu5uSTm4NIboZYU9S0usFxPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDJNivmpaI9nH0Eqh1NA92+M3cpyXgLRsZAJ2++p7N7MWTAWMmL2ya50f9tghtIAQ
         NhWMN19HiQTPUFCEL1/BoPscyu/a6OyRIyKYtCgzhEhXIK7Bt3CgLvn+8MtVzvZDqz
         BsK9R7Kc5mhFNgQEikWv2knXEdFS0NWD5lbIpUaA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sasha Levin <sashal@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/27] batman-adv: Fix refcnt leak in batadv_store_throughput_override
Date:   Thu, 14 May 2020 14:55:29 -0400
Message-Id: <20200514185550.21462-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 6107c5da0fca8b50b4d3215e94d619d38cc4a18c ]

batadv_show_throughput_override() invokes batadv_hardif_get_by_netdev(),
which gets a batadv_hard_iface object from net_dev with increased refcnt
and its reference is assigned to a local pointer 'hard_iface'.

When batadv_store_throughput_override() returns, "hard_iface" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The issue happens in one error path of
batadv_store_throughput_override(). When batadv_parse_throughput()
returns NULL, the refcnt increased by batadv_hardif_get_by_netdev() is
not decreased, causing a refcnt leak.

Fix this issue by jumping to "out" label when batadv_parse_throughput()
returns NULL.

Fixes: 0b5ecc6811bd ("batman-adv: add throughput override attribute to hard_ifaces")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
index d3fb5396f9473..121e9e7d28cc5 100644
--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -1087,7 +1087,7 @@ static ssize_t batadv_store_throughput_override(struct kobject *kobj,
 	ret = batadv_parse_throughput(net_dev, buff, "throughput_override",
 				      &tp_override);
 	if (!ret)
-		return count;
+		goto out;
 
 	old_tp_override = atomic_read(&hard_iface->bat_v.throughput_override);
 	if (old_tp_override == tp_override)
-- 
2.20.1

