Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50038C3D68
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbfJAQ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbfJAQlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77382168B;
        Tue,  1 Oct 2019 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948067;
        bh=nXIOzN763RWaREdN4K1IvJJoC/Zr8O0a/qtWgH4HEl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfzGWZoFO9QEgCQr8LDv6nBDm48auW6iA1FvAcCzs4xKH8WZ+byuVG393Pjn/E7GD
         M4MVJmBbfll8BKQBHNPygSggzs6eQM3xkiIXmE5xz7a/WU/NH5V18Zz/v6ZneVkX0o
         4SzFJjX89tQdZOqbXSXTndE27Drrsf3BkXViXeAo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Patrick Ruddy <pruddy@vyatta.att-mail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 64/71] vrf: Do not attempt to create IPv6 mcast rule if IPv6 is disabled
Date:   Tue,  1 Oct 2019 12:39:14 -0400
Message-Id: <20191001163922.14735-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit dac91170f8e9c73784af5fad6225e954b795601c ]

A user reported that vrf create fails when IPv6 is disabled at boot using
'ipv6.disable=1':
   https://bugzilla.kernel.org/show_bug.cgi?id=204903

The failure is adding fib rules at create time. Add RTNL_FAMILY_IP6MR to
the check in vrf_fib_rule if ipv6_mod_enabled is disabled.

Fixes: e4a38c0c4b27 ("ipv6: add vrf table handling code for ipv6 mcast")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Patrick Ruddy <pruddy@vyatta.att-mail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 6e84328bdd402..a4b38a980c3cb 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1154,7 +1154,8 @@ static int vrf_fib_rule(const struct net_device *dev, __u8 family, bool add_it)
 	struct sk_buff *skb;
 	int err;
 
-	if (family == AF_INET6 && !ipv6_mod_enabled())
+	if ((family == AF_INET6 || family == RTNL_FAMILY_IP6MR) &&
+	    !ipv6_mod_enabled())
 		return 0;
 
 	skb = nlmsg_new(vrf_fib_rule_nl_size(), GFP_KERNEL);
-- 
2.20.1

