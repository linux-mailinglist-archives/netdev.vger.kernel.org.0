Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE31F2CAE
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgFIA0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgFHXQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C3D2086A;
        Mon,  8 Jun 2020 23:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658205;
        bh=0tYkqIlVSHEhOqCjyDfzJPjMYvUZnf1hmOsYa38BNVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtBgO7/Ym7HNSWGZWR2PqFTp6djqYnB+XkW3GDnH2548AvbcaqwUWUC3hqwtQs5l6
         xMvfiotB4Ohr+R5PIV44ZvAgJBtArx8x57RvIFqgxwEgCC5lUK8sn8FGIA+qv5EnO9
         YRwPnAww4ee6jRkZ9FiHp5MCpPWSD8C3/HEP0SRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        ASSOGBA Emery <assogba.emery@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 224/606] nexthop: Fix attribute checking for groups
Date:   Mon,  8 Jun 2020 19:05:49 -0400
Message-Id: <20200608231211.3363633-224-sashal@kernel.org>
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

From: David Ahern <dsahern@gmail.com>

[ Upstream commit 84be69b869a5a496a6cfde9b3c29509207a1f1fa ]

For nexthop groups, attributes after NHA_GROUP_TYPE are invalid, but
nh_check_attr_group starts checking at NHA_GROUP. The group type defaults
to multipath and the NHA_GROUP_TYPE is currently optional so this has
slipped through so far. Fix the attribute checking to handle support of
new group types.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: ASSOGBA Emery <assogba.emery@gmail.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 489c27f894d7..b03ea728d9a3 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -434,7 +434,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 		if (!valid_group_nh(nh, len, extack))
 			return -EINVAL;
 	}
-	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
+	for (i = NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
 
-- 
2.25.1

