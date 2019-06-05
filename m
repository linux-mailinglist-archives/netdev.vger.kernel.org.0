Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12D367B7
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfFEXP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfFEXP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:15:27 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C466208C0;
        Wed,  5 Jun 2019 23:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559776526;
        bh=jcNU7NyfUkMhFOxF5gJmExhA06vhcK4YLfhdMUcuukw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MI9Pb2Onhswr497jfK10/6j7fQBlYtVPhSqCRG5XFW3Ato5kC32G42tWEiW4EYrt3
         een9pUpmpMgsYGhxGP81bShNKov5ESYRTt+CgbNRUmMsJjXS0bXJpfek5mRjBVzIrm
         21BSljRFFHkVsQ2Teim+Muqs+4AHVyTRDIhA4m3A=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 06/19] ipv6: Handle all fib6_nh in a nexthop in fib6_info_uses_dev
Date:   Wed,  5 Jun 2019 16:15:10 -0700
Message-Id: <20190605231523.18424-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605231523.18424-1-dsahern@kernel.org>
References: <20190605231523.18424-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a hook in fib6_info_uses_dev to handle nexthop struct in a fib6_info.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index aaa10e716115..6f4bd971df70 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5194,9 +5194,27 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
+static int fib6_info_nh_uses_dev(struct fib6_nh *nh, void *arg)
+{
+	const struct net_device *dev = arg;
+
+	if (nh->fib_nh_dev == dev)
+		return 1;
+
+	return 0;
+}
+
 static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 			       const struct net_device *dev)
 {
+	if (f6i->nh) {
+		struct net_device *_dev = (struct net_device *)dev;
+
+		return !!nexthop_for_each_fib6_nh(f6i->nh,
+						  fib6_info_nh_uses_dev,
+						  _dev);
+	}
+
 	if (f6i->fib6_nh->fib_nh_dev == dev)
 		return true;
 
-- 
2.11.0

