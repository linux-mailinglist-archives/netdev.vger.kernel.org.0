Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FB246D8C
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfFOBcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfFOBcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:32:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 342CE30821BE;
        Sat, 15 Jun 2019 01:32:52 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA3875C548;
        Sat, 15 Jun 2019 01:32:47 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v4 2/8] ipv4: Honour NLM_F_MATCH, make semantics of NETLINK_GET_STRICT_CHK consistent
Date:   Sat, 15 Jun 2019 03:32:10 +0200
Message-Id: <58865c4c143d0da40cd417b5b87b49d292d8129d.1560561432.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560561432.git.sbrivio@redhat.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sat, 15 Jun 2019 01:32:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Socket option NETLINK_GET_STRICT_CHK, quoting from commit 89d35528d17d
("netlink: Add new socket option to enable strict checking on dumps"),
is used to "request strict checking of headers and attributes on dump
requests".

If some attributes are set (including flags), setting this option causes
dump functions to filter results according to these attributes, via the
filter_set flag. However, if strict checking is requested, this should
imply that we also filter results based on flags that are *not* set.

This is currently not the case, at least for IPv4 FIB dumps: if the
RTM_F_CLONED flag is not set, and strict checking is required, we should
not return routes with the RTM_F_CLONED flag set.

Set the filter_set flag whenever strict checking is requested, limiting
the scope to IPv4 FIB dumps for the moment being, as other users of the
flag might not present this inconsistency.

Note that this partially duplicates the semantics of NLM_F_MATCH as
described by RFC 3549, par. 3.1.1. Instead of setting a filter based on
the size of the netlink message, properly support NLM_F_MATCH, by
setting a filter via ip_filter_fib_dump_req() and setting the filter_set
flag.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v4: New patch

 net/ipv4/fib_frontend.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 873fc5c4721c..32a04318d725 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -954,10 +954,14 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 		err = ip_filter_fib_dump_req(net, nlh, &filter, cb, true);
 		if (err < 0)
 			return err;
-	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
-		struct rtmsg *rtm = nlmsg_data(nlh);
-
-		filter.flags = rtm->rtm_flags & (RTM_F_PREFIX | RTM_F_CLONED);
+		filter.filter_set = 1;
+	} else if (nlh->nlmsg_flags & NLM_F_MATCH) {
+		err = ip_filter_fib_dump_req(net, nlh, &filter, cb, false);
+		if (err == -ENODEV)
+			return skb->len;
+		if (err)
+			return err;
+		filter.filter_set = 1;
 	}
 
 	/* fib entries are never clones and ipv4 does not use prefix flag */
-- 
2.20.1

