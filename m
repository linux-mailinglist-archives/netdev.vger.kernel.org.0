Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298EA1D3C96
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgENTIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgENSxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:53:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3333A2074A;
        Thu, 14 May 2020 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482395;
        bh=Nq/lZfg+QlhWGRQesG+N0mdw+neI0bArwUPu2n8rJ18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8KfGRWD+wJ/KmxT2Oj9B0WTGKOxyFctOpBIkziYRYYzlMzd94ndxsdQx5EKw09jm
         YXkB3lrmPPBYNUh8dwM2tdgGDr79NeVKvc2YtRHXfDZUMC5nVXp/nZO+Vl1AKG2Vd1
         JdD/sNIqKx38+G0sO+lgNWhm7MmDaOajm6mKVJpA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/49] net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()
Date:   Thu, 14 May 2020 14:52:23 -0400
Message-Id: <20200514185311.20294-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1cd9b3abf5332102d4d967555e7ed861a75094bf ]

In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.

The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
from being 'm' when NET_DEVLINK=y.

With the planned Kconfig change that relaxes the 'imply', the
combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.

Use IS_REACHABLE() to avoid the vmlinux link error for this case.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/drop_monitor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/drop_monitor.h b/include/net/drop_monitor.h
index 2ab668461463e..f68bc373544a9 100644
--- a/include/net/drop_monitor.h
+++ b/include/net/drop_monitor.h
@@ -19,7 +19,7 @@ struct net_dm_hw_metadata {
 	struct net_device *input_dev;
 };
 
-#if IS_ENABLED(CONFIG_NET_DROP_MONITOR)
+#if IS_REACHABLE(CONFIG_NET_DROP_MONITOR)
 void net_dm_hw_report(struct sk_buff *skb,
 		      const struct net_dm_hw_metadata *hw_metadata);
 #else
-- 
2.20.1

