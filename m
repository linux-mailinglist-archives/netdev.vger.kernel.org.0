Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10BF46D94
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFOBeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:34:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfFOBd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:33:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 896CC3082E06;
        Sat, 15 Jun 2019 01:33:59 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC3BC106F752;
        Sat, 15 Jun 2019 01:33:56 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH iproute2] iproute: Pass RTM_F_CLONED on dump to fetch cached routes to be flushed
Date:   Sat, 15 Jun 2019 03:33:50 +0200
Message-Id: <7ae318a8b632c216df95362524cd4bb5f4f1f537.1560561439.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 15 Jun 2019 01:33:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a current (5.1) kernel version, IPv6 exception routes can't be listed
(ip -6 route list cache) or flushed (ip -6 route flush cache). I'm
re-introducing kernel support for this, but, to allow the kernel to filter
routes based on the RTM_F_CLONED flag, we need to make sure this flag is
always passed when we want cached routes to be dumped.

Right now, this is only the case for listing operation. When flushing,
IPv6 routes are first dumped, and then deleted one by one, but the
RTM_F_CLONED flag is not passed depending on the filter during the
dump, so we don't get the routes that we need to flush if requested with
the 'cache' parameter.

Define a filter that is passed to rtnl_routedump_req() on flush and sets
RTM_F_CLONED in rtm_flags on the dump to get routes to be flushed, if
we're dealing with cached routes.

Fixes: aba5acdfdb34 ("(Logical change 1.3)")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 ip/iproute.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 2b3dcc5dbd53..192442b42062 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1602,6 +1602,16 @@ static int save_route_prep(void)
 	return 0;
 }
 
+static int iproute_flush_flags(struct nlmsghdr *nlh, int reqlen)
+{
+	struct rtmsg *rtm = NLMSG_DATA(nlh);
+
+	if (filter.cloned)
+		rtm->rtm_flags |= RTM_F_CLONED;
+
+	return 0;
+}
+
 static int iproute_flush(int family, rtnl_filter_t filter_fn)
 {
 	time_t start = time(0);
@@ -1624,7 +1634,7 @@ static int iproute_flush(int family, rtnl_filter_t filter_fn)
 	filter.flushe = sizeof(flushb);
 
 	for (;;) {
-		if (rtnl_routedump_req(&rth, family, NULL) < 0) {
+		if (rtnl_routedump_req(&rth, family, iproute_flush_flags) < 0) {
 			perror("Cannot send dump request");
 			return -2;
 		}
-- 
2.20.1

