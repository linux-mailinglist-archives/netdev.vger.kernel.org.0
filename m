Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9273254DDA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbfFYLld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfFYLld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 07:41:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B77A43082E46;
        Tue, 25 Jun 2019 11:41:32 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12785600CD;
        Tue, 25 Jun 2019 11:41:28 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH iproute2 v2] iproute: Set flags and attributes on dump to get IPv6 cached routes to be flushed
Date:   Tue, 25 Jun 2019 13:41:24 +0200
Message-Id: <9c24a93aa56b843273aa985cc33d962dec7e9d17.1561462692.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 25 Jun 2019 11:41:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a current (5.1) kernel version, IPv6 exception routes can't be listed
(ip -6 route list cache) or flushed (ip -6 route flush cache). Kernel
support for this is being added back. Relevant net-next commits:

  564c91f7e563 fib_frontend, ip6_fib: Select routes or exceptions dump from RTM_F_CLONED
  ef11209d4219 Revert "net/ipv6: Bail early if user only wants cloned entries"
  3401bfb1638e ipv6/route: Don't match on fc_nh_id if not set in ip6_route_del()
  bf9a8a061ddc ipv6/route: Change return code of rt6_dump_route() for partial node dumps
  1e47b4837f3b ipv6: Dump route exceptions if requested
  40cb35d5dc04 ip6_fib: Don't discard nodes with valid routing information in fib6_locate_1()

However, to allow the kernel to filter routes based on the RTM_F_CLONED
flag, we need to make sure this flag is always passed when we want cached
routes to be dumped, and we can also pass table and output interface
attributes to have the kernel filtering on them, if requested by the user.

Use the existing iproute_dump_filter() as a filter for the dump request in
iproute_flush(). This way, 'ip -6 route flush cache' works again.

v2: Instead of creating a separate 'filter' function dealing with
    RTM_F_CACHED only, use the existing iproute_dump_filter() and get
    table and oif kernel filtering for free. Suggested by David Ahern.

Fixes: aba5acdfdb34 ("(Logical change 1.3)")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 ip/iproute.c | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 2b3dcc5dbd53..1669e0138259 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1602,6 +1602,30 @@ static int save_route_prep(void)
 	return 0;
 }
 
+static int iproute_dump_filter(struct nlmsghdr *nlh, int reqlen)
+{
+	struct rtmsg *rtm = NLMSG_DATA(nlh);
+	int err;
+
+	rtm->rtm_protocol = filter.protocol;
+	if (filter.cloned)
+		rtm->rtm_flags |= RTM_F_CLONED;
+
+	if (filter.tb) {
+		err = addattr32(nlh, reqlen, RTA_TABLE, filter.tb);
+		if (err)
+			return err;
+	}
+
+	if (filter.oif) {
+		err = addattr32(nlh, reqlen, RTA_OIF, filter.oif);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int iproute_flush(int family, rtnl_filter_t filter_fn)
 {
 	time_t start = time(0);
@@ -1624,7 +1648,7 @@ static int iproute_flush(int family, rtnl_filter_t filter_fn)
 	filter.flushe = sizeof(flushb);
 
 	for (;;) {
-		if (rtnl_routedump_req(&rth, family, NULL) < 0) {
+		if (rtnl_routedump_req(&rth, family, iproute_dump_filter) < 0) {
 			perror("Cannot send dump request");
 			return -2;
 		}
@@ -1664,30 +1688,6 @@ static int iproute_flush(int family, rtnl_filter_t filter_fn)
 	}
 }
 
-static int iproute_dump_filter(struct nlmsghdr *nlh, int reqlen)
-{
-	struct rtmsg *rtm = NLMSG_DATA(nlh);
-	int err;
-
-	rtm->rtm_protocol = filter.protocol;
-	if (filter.cloned)
-		rtm->rtm_flags |= RTM_F_CLONED;
-
-	if (filter.tb) {
-		err = addattr32(nlh, reqlen, RTA_TABLE, filter.tb);
-		if (err)
-			return err;
-	}
-
-	if (filter.oif) {
-		err = addattr32(nlh, reqlen, RTA_OIF, filter.oif);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static int iproute_list_flush_or_save(int argc, char **argv, int action)
 {
 	int dump_family = preferred_family;
-- 
2.20.1

