Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054151F2DB9
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgFIAgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgFHXOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2495D212CC;
        Mon,  8 Jun 2020 23:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658054;
        bh=r/ZhJS3TFnJvUkfTEaJFVxbdWUpnvSUCDvWHnEm187c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boo7EgIUVSUFiRTsHjcbIIArJhYnUZTk9C4L4XzferlIfQfGaEsLkptYueJGX9CBS
         5k2LEVBRTuXjBczfOrXKZEQLMY6Wc/ZoygTmsyC0KCMNtmqR1+tarAo3su+w+TqXeX
         vbNZECTn3TpXxwrAV07QcAIkoN2ki6NT/OEUbfzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 102/606] net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()
Date:   Mon,  8 Jun 2020 19:03:47 -0400
Message-Id: <20200608231211.3363633-102-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
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
index 2ab668461463..f68bc373544a 100644
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
2.25.1

