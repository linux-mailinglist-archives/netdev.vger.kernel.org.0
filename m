Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C9646D8D
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfFOBc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfFOBcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:32:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 490643091753;
        Sat, 15 Jun 2019 01:32:55 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E61CA18228;
        Sat, 15 Jun 2019 01:32:52 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v4 3/8] ipv4/fib_frontend: Allow RTM_F_CLONED flag to be used for filtering
Date:   Sat, 15 Jun 2019 03:32:11 +0200
Message-Id: <3c53c1e5bdab71f7269abfe62bbaf1343767e914.1560561432.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560561432.git.sbrivio@redhat.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sat, 15 Jun 2019 01:32:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This functionally reverts the check introduced by commit
e8ba330ac0c5 ("rtnetlink: Update fib dumps for strict data checking")
as modified by commit e4e92fb160d7 ("net/ipv4: Bail early if user only
wants prefix entries").

As we are preparing to fix listing of IPv4 cached routes, we need to
give userspace a way to request for cached routes only.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v4: New patch

 net/ipv4/fib_frontend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 32a04318d725..815997487247 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -964,8 +964,8 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 		filter.filter_set = 1;
 	}
 
-	/* fib entries are never clones and ipv4 does not use prefix flag */
-	if (filter.flags & (RTM_F_PREFIX | RTM_F_CLONED))
+	/* ipv4 does not use prefix flag */
+	if (filter.flags & RTM_F_PREFIX)
 		return skb->len;
 
 	if (filter.table_id) {
-- 
2.20.1

