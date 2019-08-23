Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25469B12C
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 15:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390250AbfHWNoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 09:44:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731976AbfHWNoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 09:44:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79E14308FBA7;
        Fri, 23 Aug 2019 13:44:16 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.205.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 963F360933;
        Fri, 23 Aug 2019 13:44:15 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net] ipv6: propagate ipv6_add_dev's error returns out of ipv6_find_idev
Date:   Fri, 23 Aug 2019 15:44:36 +0200
Message-Id: <5bc330e3f8123eb139113ae93851cc17100c22da.1566566438.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 23 Aug 2019 13:44:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ipv6_find_idev returns NULL when ipv6_add_dev fails,
ignoring the specific error value. This results in addrconf_add_dev
returning ENOBUFS in all cases, which is unfortunate in cases such as:

    # ip link add dummyX type dummy
    # ip link set dummyX mtu 1200 up
    # ip addr add 2000::/64 dev dummyX
    RTNETLINK answers: No buffer space available

Commit a317a2f19da7 ("ipv6: fail early when creating netdev named all
or default") introduced error returns in ipv6_add_dev. Before that,
that function would simply return NULL for all failures.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv6/addrconf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ced995f3fec4..6a576ff92c39 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -478,7 +478,7 @@ static struct inet6_dev *ipv6_find_idev(struct net_device *dev)
 	if (!idev) {
 		idev = ipv6_add_dev(dev);
 		if (IS_ERR(idev))
-			return NULL;
+			return idev;
 	}
 
 	if (dev->flags&IFF_UP)
@@ -2466,8 +2466,8 @@ static struct inet6_dev *addrconf_add_dev(struct net_device *dev)
 	ASSERT_RTNL();
 
 	idev = ipv6_find_idev(dev);
-	if (!idev)
-		return ERR_PTR(-ENOBUFS);
+	if (IS_ERR(idev))
+		return idev;
 
 	if (idev->cnf.disable_ipv6)
 		return ERR_PTR(-EACCES);
@@ -3159,7 +3159,7 @@ static void init_loopback(struct net_device *dev)
 	ASSERT_RTNL();
 
 	idev = ipv6_find_idev(dev);
-	if (!idev) {
+	if (IS_ERR(idev)) {
 		pr_debug("%s: add_dev failed\n", __func__);
 		return;
 	}
@@ -3374,7 +3374,7 @@ static void addrconf_sit_config(struct net_device *dev)
 	 */
 
 	idev = ipv6_find_idev(dev);
-	if (!idev) {
+	if (IS_ERR(idev)) {
 		pr_debug("%s: add_dev failed\n", __func__);
 		return;
 	}
@@ -3399,7 +3399,7 @@ static void addrconf_gre_config(struct net_device *dev)
 	ASSERT_RTNL();
 
 	idev = ipv6_find_idev(dev);
-	if (!idev) {
+	if (IS_ERR(idev)) {
 		pr_debug("%s: add_dev failed\n", __func__);
 		return;
 	}
@@ -4773,8 +4773,8 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 IFA_F_MCAUTOJOIN | IFA_F_OPTIMISTIC;
 
 	idev = ipv6_find_idev(dev);
-	if (!idev)
-		return -ENOBUFS;
+	if (IS_ERR(idev))
+		return PTR_ERR(idev);
 
 	if (!ipv6_allow_optimistic_dad(net, idev))
 		cfg.ifa_flags &= ~IFA_F_OPTIMISTIC;
-- 
2.22.0

