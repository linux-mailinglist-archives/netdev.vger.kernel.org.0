Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05A63B07C6
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhFVOrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:47:05 -0400
Received: from relay.sw.ru ([185.231.240.75]:34904 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhFVOrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 10:47:01 -0400
X-Greylist: delayed 2292 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2021 10:47:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=cXVrQPmKPtaz2B0OL/bqqIQGRshh1tX59zroIcYoP0c=; b=rkre/3ZjdSlT
        naXKoIBK8IAChwqd74ARMWRc7rJZ0AGGpG+7RcBVlDoyvRrLtpTsnwet23szh08FkLiq8gR4D7tRw
        hHe+0GVNncaXyD3ffmjgcACFGGtLBYMsvtu4aXraIgYeN3taugVcc7PzgcTvdnMxDsfuP0LKQUZiP
        915Ss=;
Received: from [192.168.15.175] (helo=mikhalitsyn-laptop.sw.ru)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lVOh8-001U6O-4H; Tue, 22 Jun 2021 17:44:43 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: [PATCH iproute2] ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped
Date:   Tue, 22 Jun 2021 17:44:34 +0300
Message-Id: <20210622144434.27129-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We started to use in-kernel filtering feature which allows to get only needed
tables (see iproute_dump_filter()). From the kernel side it's implemented in
net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
The problem here is that behaviour of "ip route save" was changed after
c7e6371bc ("ip route: Add protocol, table id and device to dump request").
If filters are used, then kernel returns ENOENT error if requested table is absent,
but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
It is really allocated, for instance, after issuing "ip l set lo up".

Reproducer is fairly simple:
Error: ipv4: FIB table does not exist.
Dump terminated

Expected result here is to get empty dump file (as it was before this change).

This affects on CRIU [1] because we use ip route save in dump process, to workaround
problem in tests we just put loopback interface up in each net namespace.

Links:
[1] https://github.com/checkpoint-restore/criu/issues/747
[2] https://www.spinics.net/lists/netdev/msg559739.html

Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")

Cc: David Ahern <dsahern@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 ip/iproute.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 5853f026..b70acc00 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1734,6 +1734,7 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
 	char *od = NULL;
 	unsigned int mark = 0;
 	rtnl_filter_t filter_fn;
+	int ret;
 
 	if (action == IPROUTE_SAVE) {
 		if (save_route_prep())
@@ -1939,7 +1940,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
 
 	new_json_obj(json);
 
-	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
+	ret = rtnl_dump_filter(&rth, filter_fn, stdout);
+
+	/* Let's ignore ENOENT error if we want to dump RT_TABLE_MAIN table */
+	if (ret < 0 &&
+	    !(errno == ENOENT && filter.tb == RT_TABLE_MAIN)) {
 		fprintf(stderr, "Dump terminated\n");
 		return -2;
 	}
-- 
2.31.1

