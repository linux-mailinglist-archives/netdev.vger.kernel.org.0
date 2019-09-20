Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E3DB8F90
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 14:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408909AbfITMQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 08:16:30 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:52780 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404469AbfITMQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 08:16:30 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id F3A6B2E14DB;
        Fri, 20 Sep 2019 15:16:26 +0300 (MSK)
Received: from sas2-62907d92d1d8.qloud-c.yandex.net (sas2-62907d92d1d8.qloud-c.yandex.net [2a02:6b8:c08:b895:0:640:6290:7d92])
        by mxbackcorp1j.mail.yandex.net (nwsmtp/Yandex) with ESMTP id fS5BXxHn5R-GQEuAlfH;
        Fri, 20 Sep 2019 15:16:26 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1568981786; bh=m0kOZQ+NbkgkNFNOM54nV5mVzumrbV1VUrvfSfcmBVU=;
        h=Message-ID:Date:To:From:Subject;
        b=nFFgEkeSMm81Eoh3LZ7/fB8Zga1/6FKvvpdBH5tRhZplrZWTPWDfeavElB4mRinlV
         5OEFZifgePxtVrEmMz/KpjnLSDhc9eKdRSQDG9S7PoXjQJbkklelYCUO9EpTRenwrE
         uzL5CudQAXeqZDtbuD6/M8fBgVTpBMk3oqBOqAGo=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:344a:8fe6:6594:f7b2])
        by sas2-62907d92d1d8.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id yq1VmGiOn3-GQH8bUdm;
        Fri, 20 Sep 2019 15:16:26 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] ipv6/addrconf: use netdev_info()/netdev_warn()/netdev_dbg()
 for logging
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date:   Fri, 20 Sep 2019 15:16:25 +0300
Message-ID: <156898178548.7462.12354601250888514977.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print prefix "<driver> <pci_dev> <dev_name>: " or "<kind> <dev_name>: ".
Add "IPv6: " into format: netdev_info() does not use macro pr_fmt().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 net/ipv6/addrconf.c      |   28 ++++++++++++----------------
 net/ipv6/addrconf_core.c |    2 +-
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c39..0d1568cf1e89 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -417,7 +417,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 
 #if IS_ENABLED(CONFIG_IPV6_SIT)
 	if (dev->type == ARPHRD_SIT && (dev->priv_flags & IFF_ISATAP)) {
-		pr_info("%s: Disabled Multicast RS\n", dev->name);
+		netdev_info(dev, "IPv6: Disabled Multicast RS\n");
 		ndev->cnf.rtr_solicits = 0;
 	}
 #endif
@@ -951,7 +951,7 @@ void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp)
 	WARN_ON(!hlist_unhashed(&ifp->addr_lst));
 
 #ifdef NET_REFCNT_DEBUG
-	pr_debug("%s\n", __func__);
+	netdev_dbg(ifp->idev->dev, "%s\n", __func__);
 #endif
 
 	in6_dev_put(ifp->idev);
@@ -1329,7 +1329,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
 	in6_dev_hold(idev);
 	if (idev->cnf.use_tempaddr <= 0) {
 		write_unlock_bh(&idev->lock);
-		pr_info("%s: use_tempaddr is disabled\n", __func__);
+		netdev_info(idev->dev, "IPv6: use_tempaddr is disabled\n");
 		in6_dev_put(idev);
 		ret = -1;
 		goto out;
@@ -1339,8 +1339,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
 		idev->cnf.use_tempaddr = -1;	/*XXX*/
 		spin_unlock_bh(&ifp->lock);
 		write_unlock_bh(&idev->lock);
-		pr_warn("%s: regeneration time exceeded - disabled temporary address support\n",
-			__func__);
+		netdev_warn(idev->dev, "IPv6: regeneration time exceeded - disabled temporary address support\n");
 		in6_dev_put(idev);
 		ret = -1;
 		goto out;
@@ -1412,7 +1411,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
 	if (IS_ERR(ift)) {
 		in6_ifa_put(ifp);
 		in6_dev_put(idev);
-		pr_info("%s: retry temporary address regeneration\n", __func__);
+		netdev_info(idev->dev, "IPv6: retry temporary address regeneration\n");
 		tmpaddr = &addr;
 		write_lock_bh(&idev->lock);
 		goto retry;
@@ -3160,7 +3159,7 @@ static void init_loopback(struct net_device *dev)
 
 	idev = ipv6_find_idev(dev);
 	if (IS_ERR(idev)) {
-		pr_debug("%s: add_dev failed\n", __func__);
+		netdev_dbg(dev, "IPv6: %s: add_dev failed\n", __func__);
 		return;
 	}
 
@@ -3375,7 +3374,7 @@ static void addrconf_sit_config(struct net_device *dev)
 
 	idev = ipv6_find_idev(dev);
 	if (IS_ERR(idev)) {
-		pr_debug("%s: add_dev failed\n", __func__);
+		netdev_dbg(dev, "IPv6: %s: add_dev failed\n", __func__);
 		return;
 	}
 
@@ -3400,7 +3399,7 @@ static void addrconf_gre_config(struct net_device *dev)
 
 	idev = ipv6_find_idev(dev);
 	if (IS_ERR(idev)) {
-		pr_debug("%s: add_dev failed\n", __func__);
+		netdev_dbg(dev, "IPv6: %s: add_dev failed\n", __func__);
 		return;
 	}
 
@@ -3534,8 +3533,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 
 			if (!addrconf_link_ready(dev)) {
 				/* device is not ready yet. */
-				pr_debug("ADDRCONF(NETDEV_UP): %s: link is not ready\n",
-					 dev->name);
+				netdev_dbg(dev, "IPv6: ADDRCONF(NETDEV_UP): link is not ready\n");
 				break;
 			}
 
@@ -3570,8 +3568,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 				idev->if_flags |= IF_READY;
 			}
 
-			pr_info("ADDRCONF(NETDEV_CHANGE): %s: link becomes ready\n",
-				dev->name);
+			netdev_info(dev, "IPv6: ADDRCONF(NETDEV_CHANGE): link becomes ready\n");
 
 			run_pending = 1;
 		}
@@ -3894,7 +3891,7 @@ static void addrconf_rs_timer(struct timer_list *t)
 		 * Note: we do not support deprecated "all on-link"
 		 * assumption any longer.
 		 */
-		pr_debug("%s: no IPv6 routers present\n", idev->dev->name);
+		netdev_dbg(dev, "no IPv6 routers present\n");
 	}
 
 out:
@@ -4054,8 +4051,7 @@ static void addrconf_dad_work(struct work_struct *w)
 				/* DAD failed for link-local based on MAC */
 				idev->cnf.disable_ipv6 = 1;
 
-				pr_info("%s: IPv6 being disabled!\n",
-					ifp->idev->dev->name);
+				netdev_info(idev->dev, "IPv6 being disabled!\n");
 				disable_ipv6 = true;
 			}
 		}
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index 783f3c1466da..d2b589fb6889 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -243,7 +243,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev)
 	WARN_ON(timer_pending(&idev->rs_timer));
 
 #ifdef NET_REFCNT_DEBUG
-	pr_debug("%s: %s\n", __func__, dev ? dev->name : "NIL");
+	netdev_dbg(dev, "%s\n", __func__);
 #endif
 	dev_put(dev);
 	if (!idev->dead) {

