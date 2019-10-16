Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDEBD9994
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394426AbfJPSw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394422AbfJPSw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 14:52:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B175308449A;
        Wed, 16 Oct 2019 18:52:26 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-65.ams2.redhat.com [10.36.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D7595B69A;
        Wed, 16 Oct 2019 18:52:22 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Stefan Walter <walteste@inf.ethz.ch>,
        Benjamin Coddington <bcodding@redhat.com>,
        Gonzalo Siero <gsierohu@redhat.com>,
        =?UTF-8?q?Nikola=20Forr=C3=B3?= <nforro@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net v2] ipv4: Return -ENETUNREACH if we can't create route but saddr is valid
Date:   Wed, 16 Oct 2019 20:52:09 +0200
Message-Id: <25812471222471a51caf0a749c7bbc321047ae5e.1571251375.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 16 Oct 2019 18:52:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...instead of -EINVAL. An issue was found with older kernel versions
while unplugging a NFS client with pending RPCs, and the wrong error
code here prevented it from recovering once link is back up with a
configured address.

Incidentally, this is not an issue anymore since commit 4f8943f80883
("SUNRPC: Replace direct task wakeups from softirq context"), included
in 5.2-rc7, had the effect of decoupling the forwarding of this error
by using SO_ERROR in xs_wake_error(), as pointed out by Benjamin
Coddington.

To the best of my knowledge, this isn't currently causing any further
issue, but the error code doesn't look appropriate anyway, and we
might hit this in other paths as well.

In detail, as analysed by Gonzalo Siero, once the route is deleted
because the interface is down, and can't be resolved and we return
-EINVAL here, this ends up, courtesy of inet_sk_rebuild_header(),
as the socket error seen by tcp_write_err(), called by
tcp_retransmit_timer().

In turn, tcp_write_err() indirectly calls xs_error_report(), which
wakes up the RPC pending tasks with a status of -EINVAL. This is then
seen by call_status() in the SUN RPC implementation, which aborts the
RPC call calling rpc_exit(), instead of handling this as a
potentially temporary condition, i.e. as a timeout.

Return -EINVAL only if the input parameters passed to
ip_route_output_key_hash_rcu() are actually invalid (this is the case
if the specified source address is multicast, limited broadcast or
all zeroes), but return -ENETUNREACH in all cases where, at the given
moment, the given source address doesn't allow resolving the route.

While at it, drop the initialisation of err to -ENETUNREACH, which
was added to __ip_route_output_key() back then by commit
0315e3827048 ("net: Fix behaviour of unreachable, blackhole and
prohibit routes"), but actually had no effect, as it was, and is,
overwritten by the fib_lookup() return code assignment, and anyway
ignored in all other branches, including the if (fl4->saddr) one:
I find this rather confusing, as it would look like -ENETUNREACH is
the "default" error, while that statement has no effect.

Also note that after commit fc75fc8339e7 ("ipv4: dont create routes
on down devices"), we would get -ENETUNREACH if the device is down,
but -EINVAL if the source address is specified and we can't resolve
the route, and this appears to be rather inconsistent.

Reported-by: Stefan Walter <walteste@inf.ethz.ch>
Analysed-by: Benjamin Coddington <bcodding@redhat.com>
Analysed-by: Gonzalo Siero <gsierohu@redhat.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: No changes, submitting for net instead of net-next and removing
    explanation why v1 was targeted for net-next from commit message

I think this should be considered for -stable, < 5.2

 net/ipv4/route.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 14654876127e..5bc172abd143 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2470,14 +2470,17 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 	int orig_oif = fl4->flowi4_oif;
 	unsigned int flags = 0;
 	struct rtable *rth;
-	int err = -ENETUNREACH;
+	int err;
 
 	if (fl4->saddr) {
-		rth = ERR_PTR(-EINVAL);
 		if (ipv4_is_multicast(fl4->saddr) ||
 		    ipv4_is_lbcast(fl4->saddr) ||
-		    ipv4_is_zeronet(fl4->saddr))
+		    ipv4_is_zeronet(fl4->saddr)) {
+			rth = ERR_PTR(-EINVAL);
 			goto out;
+		}
+
+		rth = ERR_PTR(-ENETUNREACH);
 
 		/* I removed check for oif == dev_out->oif here.
 		   It was wrong for two reasons:
-- 
2.20.1

