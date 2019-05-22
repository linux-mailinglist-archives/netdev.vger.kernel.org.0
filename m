Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD41E27212
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfEVWMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfEVWMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 18:12:22 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0AF320881;
        Wed, 22 May 2019 22:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558563141;
        bh=71Pyo2o7di0ISO4h7d1mSIIc9hWspC7A1hQ0hIjz7+I=;
        h=From:To:Cc:Subject:Date:From;
        b=TCIQBzX+XH1+S/pu1mPPxB1XciS5doi10qlxY6bj5M0Bbo7tZP7WlLfShUx1voKdZ
         fyMI6NOHGoVWG9XpxF0s6RxvmBFFUjOgNCpUn1BE1FQpICM2h8deSTsGCijnO8Pdy6
         5JQk1s0N7Aoc67MmfjOcweWR2EOdK/HjBSeaYOOY=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: Fix redirect with VRF
Date:   Wed, 22 May 2019 15:12:18 -0700
Message-Id: <20190522221218.9839-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

IPv6 redirect is broken for VRF. __ip6_route_redirect walks the FIB
entries looking for an exact match on ifindex. With VRF the flowi6_oif
is updated by l3mdev_update_flow to the l3mdev index and the
FLOWI_FLAG_SKIP_NH_OIF set in the flags to tell the lookup to skip the
device match. For redirects the device match is requires so use that
flag to know when the oif needs to be reset to the skb device index.

Fixes: ca254490c8df ("net: Add VRF support to IPv6 stack")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7a014ca877ed..848e944f07df 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2512,6 +2512,12 @@ static struct rt6_info *__ip6_route_redirect(struct net *net,
 	struct fib6_info *rt;
 	struct fib6_node *fn;
 
+	/* l3mdev_update_flow overrides oif if the device is enslaved; in
+	 * this case we must match on the real ingress device, so reset it
+	 */
+	if (fl6->flowi6_flags & FLOWI_FLAG_SKIP_NH_OIF)
+		fl6->flowi6_oif = skb->dev->ifindex;
+
 	/* Get the "current" route for this destination and
 	 * check if the redirect has come from appropriate router.
 	 *
-- 
2.11.0

