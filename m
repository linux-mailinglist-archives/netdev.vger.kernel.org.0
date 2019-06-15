Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A576D46D90
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfFOBdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:33:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbfFOBdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:33:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A95685539;
        Sat, 15 Jun 2019 01:33:01 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD06B5C257;
        Sat, 15 Jun 2019 01:32:58 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH 5/8] Revert "net/ipv6: Bail early if user only wants cloned entries"
Date:   Sat, 15 Jun 2019 03:32:13 +0200
Message-Id: <0f750fef3b8f3b7130e4a756622fa46c13ca46cf.1560561432.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560561432.git.sbrivio@redhat.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sat, 15 Jun 2019 01:33:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 08e814c9e8eb5a982cbd1e8f6bd255d97c51026f: as we
are preparing to fix listing and dumping of IPv6 cached routes, we
need to allow RTM_F_CLONED as a flag to match routes against while
dumping them.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v4: New patch, split from 6/8

 net/ipv6/ip6_fib.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index b21a9ec02891..bc5cb359c8a6 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -577,13 +577,10 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
 		struct rtmsg *rtm = nlmsg_data(nlh);
 
-		arg.filter.flags = rtm->rtm_flags & (RTM_F_PREFIX|RTM_F_CLONED);
+		if (rtm->rtm_flags & RTM_F_PREFIX)
+			arg.filter.flags = RTM_F_PREFIX;
 	}
 
-	/* fib entries are never clones */
-	if (arg.filter.flags & RTM_F_CLONED)
-		goto out;
-
 	w = (void *)cb->args[2];
 	if (!w) {
 		/* New dump:
-- 
2.20.1

