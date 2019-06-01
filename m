Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97EA831959
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfFADgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfFADgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:23 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E543270E2;
        Sat,  1 Jun 2019 03:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360182;
        bh=7C08nLAnUxphEvbQe9pjioFxgmUGLQafOQ5X2+jGbgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zalrSZSvBW+PzuxncU46ILJKNfQj4qeEIfGAQJ2+83t0oo9BITQg+YvC/N6yq2TSV
         eg9q/PiTVRssZrNHSlqS+UWaeu+RaDoxqfTGXZdx4K1uOUptqbBNfC1I5NA/SVq7FG
         1JqDegcghGZamMV27jc/E+fY9iO2+nydhQPD6HFg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 13/27] ipv6: Handle all fib6_nh in a nexthop in fib6_info_uses_dev
Date:   Fri, 31 May 2019 20:36:04 -0700
Message-Id: <20190601033618.27702-14-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
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
index 0c9ba144b8d0..680d61b65647 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5202,9 +5202,27 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
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

