Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919E44C448
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbfFTAA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:00:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfFTAA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 20:00:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BED259454;
        Thu, 20 Jun 2019 00:00:26 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCC1919C5B;
        Thu, 20 Jun 2019 00:00:23 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v6 05/11] Revert "net/ipv6: Bail early if user only wants cloned entries"
Date:   Thu, 20 Jun 2019 01:59:45 +0200
Message-Id: <32a674ac61d26523647c8fbad4eb55b6f830a730.1560987611.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560987611.git.sbrivio@redhat.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 20 Jun 2019 00:00:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 08e814c9e8eb5a982cbd1e8f6bd255d97c51026f: as we
are preparing to fix listing and dumping of IPv6 cached routes, we
need to allow RTM_F_CLONED as a flag to match routes against while
dumping them.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
v6: No changes

v5: No changes

v4: New patch

 net/ipv6/ip6_fib.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index f2a3cc4c8f12..2baca6ef9e01 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -572,13 +572,10 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
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

