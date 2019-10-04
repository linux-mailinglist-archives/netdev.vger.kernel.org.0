Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01133CBB50
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbfJDNMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:12:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387545AbfJDNMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 09:12:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC339305FC56;
        Fri,  4 Oct 2019 13:12:01 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-58.ams2.redhat.com [10.36.116.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AC6C5C1D8;
        Fri,  4 Oct 2019 13:11:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, lbianconi@redhat.com,
        xmu@redhat.com
Subject: [PATCH net] net: ipv4: avoid mixed n_redirects and rate_tokens usage
Date:   Fri,  4 Oct 2019 15:11:17 +0200
Message-Id: <25ac83a5c5660b43a27712d692266cd97668a2e4.1570194598.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 04 Oct 2019 13:12:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit c09551c6ff7f ("net: ipv4: use a dedicated counter
for icmp_v4 redirect packets") we use 'n_redirects' to account
for redirect packets, but we still use 'rate_tokens' to compute
the redirect packets exponential backoff.

If the device sent to the relevant peer any ICMP error packet
after sending a redirect, it will also update 'rate_token' according
to the leaking bucket schema; typically 'rate_token' will raise
above BITS_PER_LONG and the redirect packets backoff algorithm
will produce undefined behavior.

Fix the issue using 'n_redirects' to compute the exponential backoff
in ip_rt_send_redirect().

Note that we still clear rate_tokens after a redirect silence period,
to avoid changing an established behaviour.

The root cause predates git history; before the mentioned commit in
the critical scenario, the kernel stopped sending redirects, after
the mentioned commit the behavior more randomic.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: c09551c6ff7f ("net: ipv4: use a dedicated counter for icmp_v4 redirect packets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/route.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 7dcce724c78b..14654876127e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -916,16 +916,15 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	if (peer->rate_tokens == 0 ||
 	    time_after(jiffies,
 		       (peer->rate_last +
-			(ip_rt_redirect_load << peer->rate_tokens)))) {
+			(ip_rt_redirect_load << peer->n_redirects)))) {
 		__be32 gw = rt_nexthop(rt, ip_hdr(skb)->daddr);
 
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
 		peer->rate_last = jiffies;
-		++peer->rate_tokens;
 		++peer->n_redirects;
 #ifdef CONFIG_IP_ROUTE_VERBOSE
 		if (log_martians &&
-		    peer->rate_tokens == ip_rt_redirect_number)
+		    peer->n_redirects == ip_rt_redirect_number)
 			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %pI4\n",
 					     &ip_hdr(skb)->saddr, inet_iif(skb),
 					     &ip_hdr(skb)->daddr, &gw);
-- 
2.21.0

