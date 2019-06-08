Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2572A3A25B
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfFHWWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727679AbfFHWWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:23 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A8142173E;
        Sat,  8 Jun 2019 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030825;
        bh=2xx3Ks2+rTgbnXWjQYaWsVDdImaJgErh6uArKwBCUAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFXf1Om+wyu2CE3/KWkFUSf++ZwyQmylrN7eRxyMoux+LX+Vad/qdnJEHnw8p8Y8C
         /d3Ldxuc5Zn1QbHynCl3aPQ6BztS+SjHcRhmX637WLEXAoWMDGLOFrwUhnJYpyKcW7
         ZolVjmQj9if1ags6urDV3xaehKpeiNd9Px47SKAI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 06/20] ipv6: Handle all fib6_nh in a nexthop in fib6_info_uses_dev
Date:   Sat,  8 Jun 2019 14:53:27 -0700
Message-Id: <20190608215341.26592-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
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
index d1139ef077cd..d56e1ff49e47 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5190,9 +5190,27 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
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

