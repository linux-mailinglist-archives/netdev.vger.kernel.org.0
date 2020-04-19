Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43E21AF9F4
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 14:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSMZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 08:25:04 -0400
Received: from fgont.go6lab.si ([91.239.96.14]:52276 "EHLO fgont.go6lab.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgDSMZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 08:25:04 -0400
Received: from localhost (unknown [181.45.84.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fgont.go6lab.si (Postfix) with ESMTPSA id D24358056C;
        Sun, 19 Apr 2020 14:25:02 +0200 (CEST)
Date:   Sun, 19 Apr 2020 09:24:57 -0300
From:   Fernando Gont <fgont@si6networks.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH net-next] ipv6: Honor all IPv6 PIO Valid Lifetime values
Message-ID: <20200419122457.GA971@archlinux-current.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC4862 5.5.3 e) prevents received Router Advertisements from reducing
the Valid Lifetime of configured addresses to less than two hours, thus
preventing hosts from reacting to the information provided by a router
that has positive knowledge that a prefix has become invalid.

This patch makes hosts honor all Valid Lifetime values, as per
draft-gont-6man-slaac-renum-06, Section 4.2. This is meant to help
mitigate the problem discussed in draft-ietf-v6ops-slaac-renum.

Note: Attacks aiming at disabling an advertised prefix via a Valid
Lifetime of 0 are not really more harmful than other attacks
that can be performed via forged RA messages, such as those
aiming at completely disabling a next-hop router via an RA that
advertises a Router Lifetime of 0, or performing a Denial of
Service (DoS) attack by advertising illegitimate prefixes via
forged PIOs.  In scenarios where RA-based attacks are of concern,
proper mitigations such as RA-Guard [RFC6105] [RFC7113] should
be implemented.

Signed-off-by: Fernando Gont <fgont@si6networks.com>
---
 include/net/addrconf.h |  2 --
 net/ipv6/addrconf.c    | 27 +++++++--------------------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index e0eabe58aa8b..fdb07105384c 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -6,8 +6,6 @@
 #define RTR_SOLICITATION_INTERVAL	(4*HZ)
 #define RTR_SOLICITATION_MAX_INTERVAL	(3600*HZ)	/* 1 hour */
 
-#define MIN_VALID_LIFETIME		(2*3600)	/* 2 hours */
-
 #define TEMP_VALID_LIFETIME		(7*86400)
 #define TEMP_PREFERRED_LIFETIME		(86400)
 #define REGEN_MAX_RETRY			(3)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 24e319dfb510..27b4fb6e452b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2564,7 +2564,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 __u32 valid_lft, u32 prefered_lft)
 {
 	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
-	int create = 0, update_lft = 0;
+	int create = 0;
 
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
@@ -2608,32 +2608,19 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 		unsigned long now;
 		u32 stored_lft;
 
-		/* update lifetime (RFC2462 5.5.3 e) */
+		/* Update lifetime (RFC4862 5.5.3 e)
+		 * We deviate from RFC4862 by honoring all Valid Lifetimes to
+		 * improve the reaction of SLAAC to renumbering events
+		 * (draft-gont-6man-slaac-renum-06, Section 4.2)
+		 */
 		spin_lock_bh(&ifp->lock);
 		now = jiffies;
 		if (ifp->valid_lft > (now - ifp->tstamp) / HZ)
 			stored_lft = ifp->valid_lft - (now - ifp->tstamp) / HZ;
 		else
 			stored_lft = 0;
-		if (!create && stored_lft) {
-			const u32 minimum_lft = min_t(u32,
-				stored_lft, MIN_VALID_LIFETIME);
-			valid_lft = max(valid_lft, minimum_lft);
-
-			/* RFC4862 Section 5.5.3e:
-			 * "Note that the preferred lifetime of the
-			 *  corresponding address is always reset to
-			 *  the Preferred Lifetime in the received
-			 *  Prefix Information option, regardless of
-			 *  whether the valid lifetime is also reset or
-			 *  ignored."
-			 *
-			 * So we should always update prefered_lft here.
-			 */
-			update_lft = 1;
-		}
 
-		if (update_lft) {
+		if (!create && stored_lft) {
 			ifp->valid_lft = valid_lft;
 			ifp->prefered_lft = prefered_lft;
 			ifp->tstamp = now;
-- 
2.26.0

