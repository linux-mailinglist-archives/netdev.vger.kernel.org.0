Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC94EC77
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfFUPrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:47:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfFUPrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:47:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39A57C0528CB;
        Fri, 21 Jun 2019 15:46:53 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C72D19C6A;
        Fri, 21 Jun 2019 15:46:48 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v7 02/11] ipv4/fib_frontend: Allow RTM_F_CLONED flag to be used for filtering
Date:   Fri, 21 Jun 2019 17:45:21 +0200
Message-Id: <f40fe3e485e7bd09def3242a79c78aff07ffadae.1561131177.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 21 Jun 2019 15:47:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This functionally reverts the check introduced by commit
e8ba330ac0c5 ("rtnetlink: Update fib dumps for strict data checking")
as modified by commit e4e92fb160d7 ("net/ipv4: Bail early if user only
wants prefix entries").

As we are preparing to fix listing of IPv4 cached routes, we need to
give userspace a way to request them.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
v7: No changes

v6: Rebase onto net-next, no changes

v5: No changes

v4: New patch

 net/ipv4/fib_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index ed7fb5fd885c..317339cd7f03 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -987,8 +987,8 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 		filter.flags = rtm->rtm_flags & (RTM_F_PREFIX | RTM_F_CLONED);
 	}
 
-	/* fib entries are never clones and ipv4 does not use prefix flag */
-	if (filter.flags & (RTM_F_PREFIX | RTM_F_CLONED))
+	/* ipv4 does not use prefix flag */
+	if (filter.flags & RTM_F_PREFIX)
 		return skb->len;
 
 	if (filter.table_id) {
-- 
2.20.1

