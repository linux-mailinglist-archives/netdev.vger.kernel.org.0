Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7403AA76D1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfICWTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfICWTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 18:19:25 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2EEC22CF8;
        Tue,  3 Sep 2019 22:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567549164;
        bh=1RCosCggtFnti4YQVu6pERjPdEyXeQdGMitGen2D7Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktwBtjvn6oCUtMUV0Ilqpg3xQlfjcYo/qcSoRZFyWVaMJu30MLK29nOXMrdYPmeo1
         fOH2SMFH+/7+6LwYytIdOeUTBmJpG66rMxFPJux4xV6sR3BaKaDTvS1fjpgWVp71qA
         XyJBsZHqkPMjoKmiW6LNTnBAind+bmgjHpCDv2lE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sharpd@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 1/2] ipv6: Fix RTA_MULTIPATH with nexthop objects
Date:   Tue,  3 Sep 2019 15:22:12 -0700
Message-Id: <20190903222213.7029-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190903222213.7029-1-dsahern@kernel.org>
References: <20190903222213.7029-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A change to the core nla helpers was missed during the push of
the nexthop changes. rt6_fill_node_nexthop should be calling
nla_nest_start_noflag not nla_nest_start. Currently, iproute2
does not print multipath data because of parsing issues with
the attribute.

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 06f2e2d05785..b9b5be1aafff 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5323,7 +5323,7 @@ static int rt6_fill_node_nexthop(struct sk_buff *skb, struct nexthop *nh,
 	if (nexthop_is_multipath(nh)) {
 		struct nlattr *mp;
 
-		mp = nla_nest_start(skb, RTA_MULTIPATH);
+		mp = nla_nest_start_noflag(skb, RTA_MULTIPATH);
 		if (!mp)
 			goto nla_put_failure;
 
-- 
2.11.0

