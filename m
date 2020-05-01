Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445611C0CCE
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEADv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:51:57 -0400
Received: from fgont.go6lab.si ([91.239.96.14]:52746 "EHLO fgont.go6lab.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgEADv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 23:51:57 -0400
Received: from localhost (unknown [181.45.84.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fgont.go6lab.si (Postfix) with ESMTPSA id 5FA1281B60;
        Fri,  1 May 2020 05:51:52 +0200 (CEST)
Date:   Fri, 1 May 2020 00:51:47 -0300
From:   Fernando Gont <fgont@si6networks.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH v3 net-next] ipv6: Implement draft-ietf-6man-rfc4941bis
Message-ID: <20200501035147.GA1587@archlinux-current.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the upcoming rev of RFC4941 (IPv6 temporary addresses):
https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-09

* Reduces the default Valid Lifetime to 2 days
  The number of extra addresses employed when Valid Lifetime was
  7 days exacerbated the stress caused on network
  elements/devices. Additionally, the motivation for temporary
  addresses is indeed privacy and reduced exposure. With a
  default Valid Lifetime of 7 days, an address that becomes
  revealed by active communication is reachable and exposed for
  one whole week. The only use case for a Valid Lifetime of 7
  days could be some application that is expecting to have long
  lived connections. But if you want to have a long lived
  connections, you shouldn't be using a temporary address in the
  first place. Additionally, in the era of mobile devices, general
  applications should nevertheless be prepared and robust to
  address changes (e.g. nodes swap wifi <-> 4G, etc.)

* Employs different IIDs for different prefixes
  To avoid network activity correlation among addresses configured
  for different prefixes

* Uses a simpler algorithm for IID generation
  No need to store "history" anywhere

Signed-off-by: Fernando Gont <fgont@si6networks.com>
---
 Documentation/networking/ip-sysctl.rst |  2 +-
 include/net/if_inet6.h                 |  1 -
 net/ipv6/addrconf.c                    | 91 +++++++++++---------------
 3 files changed, 40 insertions(+), 54 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 50b440d29a13..b72f89d5694c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2065,7 +2065,7 @@ use_tempaddr - INTEGER
 temp_valid_lft - INTEGER
 	valid lifetime (in seconds) for temporary addresses.
 
-	Default: 604800 (7 days)
+	Default: 172800 (2 days)
 
 temp_prefered_lft - INTEGER
 	Preferred lifetime (in seconds) for temporary addresses.
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index a01981d7108f..212eb278bda6 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -190,7 +190,6 @@ struct inet6_dev {
 	int			dead;
 
 	u32			desync_factor;
-	u8			rndid[8];
 	struct list_head	tempaddr_list;
 
 	struct in6_addr		token;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 2c4f20ec1e2a..247aef55b24d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -135,8 +135,7 @@ static inline void addrconf_sysctl_unregister(struct inet6_dev *idev)
 }
 #endif
 
-static void ipv6_regen_rndid(struct inet6_dev *idev);
-static void ipv6_try_regen_rndid(struct inet6_dev *idev, struct in6_addr *tmpaddr);
+static void ipv6_gen_rnd_iid(struct in6_addr *addr);
 
 static int ipv6_generate_eui64(u8 *eui, struct net_device *dev);
 static int ipv6_count_addresses(const struct inet6_dev *idev);
@@ -432,8 +431,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	    dev->type == ARPHRD_SIT ||
 	    dev->type == ARPHRD_NONE) {
 		ndev->cnf.use_tempaddr = -1;
-	} else
-		ipv6_regen_rndid(ndev);
+	}
 
 	ndev->token = in6addr_any;
 
@@ -1306,29 +1304,21 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
 	in6_ifa_put(ifp);
 }
 
-static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
-				struct inet6_ifaddr *ift,
-				bool block)
+static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 {
 	struct inet6_dev *idev = ifp->idev;
-	struct in6_addr addr, *tmpaddr;
 	unsigned long tmp_tstamp, age;
 	unsigned long regen_advance;
-	struct ifa6_config cfg;
-	int ret = 0;
 	unsigned long now = jiffies;
-	long max_desync_factor;
 	s32 cnf_temp_preferred_lft;
+	struct inet6_ifaddr *ift;
+	struct ifa6_config cfg;
+	long max_desync_factor;
+	struct in6_addr addr;
+	int ret = 0;
 
 	write_lock_bh(&idev->lock);
-	if (ift) {
-		spin_lock_bh(&ift->lock);
-		memcpy(&addr.s6_addr[8], &ift->addr.s6_addr[8], 8);
-		spin_unlock_bh(&ift->lock);
-		tmpaddr = &addr;
-	} else {
-		tmpaddr = NULL;
-	}
+
 retry:
 	in6_dev_hold(idev);
 	if (idev->cnf.use_tempaddr <= 0) {
@@ -1351,8 +1341,8 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
 	}
 	in6_ifa_hold(ifp);
 	memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
-	ipv6_try_regen_rndid(idev, tmpaddr);
-	memcpy(&addr.s6_addr[8], idev->rndid, 8);
+	ipv6_gen_rnd_iid(&addr);
+
 	age = (now - ifp->tstamp) / HZ;
 
 	regen_advance = idev->cnf.regen_max_retry *
@@ -1417,7 +1407,6 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
 		in6_ifa_put(ifp);
 		in6_dev_put(idev);
 		pr_info("%s: retry temporary address regeneration\n", __func__);
-		tmpaddr = &addr;
 		write_lock_bh(&idev->lock);
 		goto retry;
 	}
@@ -2032,7 +2021,7 @@ static void addrconf_dad_stop(struct inet6_ifaddr *ifp, int dad_failed)
 		if (ifpub) {
 			in6_ifa_hold(ifpub);
 			spin_unlock_bh(&ifp->lock);
-			ipv6_create_tempaddr(ifpub, ifp, true);
+			ipv6_create_tempaddr(ifpub, true);
 			in6_ifa_put(ifpub);
 		} else {
 			spin_unlock_bh(&ifp->lock);
@@ -2329,40 +2318,38 @@ static int ipv6_inherit_eui64(u8 *eui, struct inet6_dev *idev)
 	return err;
 }
 
-/* (re)generation of randomized interface identifier (RFC 3041 3.2, 3.5) */
-static void ipv6_regen_rndid(struct inet6_dev *idev)
+/* Generation of a randomized Interface Identifier
+ * draft-ietf-6man-rfc4941bis, Section 3.3.1
+ */
+
+static void ipv6_gen_rnd_iid(struct in6_addr *addr)
 {
 regen:
-	get_random_bytes(idev->rndid, sizeof(idev->rndid));
-	idev->rndid[0] &= ~0x02;
+	get_random_bytes(&addr->s6_addr[8], 8);
 
-	/*
-	 * <draft-ietf-ipngwg-temp-addresses-v2-00.txt>:
-	 * check if generated address is not inappropriate
+	/* <draft-ietf-6man-rfc4941bis-08.txt>, Section 3.3.1:
+	 * check if generated address is not inappropriate:
 	 *
-	 *  - Reserved subnet anycast (RFC 2526)
-	 *	11111101 11....11 1xxxxxxx
-	 *  - ISATAP (RFC4214) 6.1
-	 *	00-00-5E-FE-xx-xx-xx-xx
-	 *  - value 0
-	 *  - XXX: already assigned to an address on the device
+	 * - Reserved IPv6 Interface Identifers
+	 * - XXX: already assigned to an address on the device
 	 */
-	if (idev->rndid[0] == 0xfd &&
-	    (idev->rndid[1]&idev->rndid[2]&idev->rndid[3]&idev->rndid[4]&idev->rndid[5]&idev->rndid[6]) == 0xff &&
-	    (idev->rndid[7]&0x80))
+
+	/* Subnet-router anycast: 0000:0000:0000:0000 */
+	if (!(addr->s6_addr32[2] | addr->s6_addr32[3]))
 		goto regen;
-	if ((idev->rndid[0]|idev->rndid[1]) == 0) {
-		if (idev->rndid[2] == 0x5e && idev->rndid[3] == 0xfe)
-			goto regen;
-		if ((idev->rndid[2]|idev->rndid[3]|idev->rndid[4]|idev->rndid[5]|idev->rndid[6]|idev->rndid[7]) == 0x00)
-			goto regen;
-	}
-}
 
-static void  ipv6_try_regen_rndid(struct inet6_dev *idev, struct in6_addr *tmpaddr)
-{
-	if (tmpaddr && memcmp(idev->rndid, &tmpaddr->s6_addr[8], 8) == 0)
-		ipv6_regen_rndid(idev);
+	/* IANA Ethernet block: 0200:5EFF:FE00:0000-0200:5EFF:FE00:5212
+	 * Proxy Mobile IPv6:   0200:5EFF:FE00:5213
+	 * IANA Ethernet block: 0200:5EFF:FE00:5214-0200:5EFF:FEFF:FFFF
+	 */
+	if (ntohl(addr->s6_addr32[2]) == 0x02005eff &&
+	    (ntohl(addr->s6_addr32[3]) & 0Xff000000) == 0xfe000000)
+		goto regen;
+
+	/* Reserved subnet anycast addresses */
+	if (ntohl(addr->s6_addr32[2]) == 0xfdffffff &&
+	    ntohl(addr->s6_addr32[3]) >= 0Xffffff80)
+		goto regen;
 }
 
 /*
@@ -2544,7 +2531,7 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 		 * no temporary address currently exists.
 		 */
 		read_unlock_bh(&idev->lock);
-		ipv6_create_tempaddr(ifp, NULL, false);
+		ipv6_create_tempaddr(ifp, false);
 	} else {
 		read_unlock_bh(&idev->lock);
 	}
@@ -4531,7 +4518,7 @@ static void addrconf_verify_rtnl(void)
 						ifpub->regen_count = 0;
 						spin_unlock(&ifpub->lock);
 						rcu_read_unlock_bh();
-						ipv6_create_tempaddr(ifpub, ifp, true);
+						ipv6_create_tempaddr(ifpub, true);
 						in6_ifa_put(ifpub);
 						in6_ifa_put(ifp);
 						rcu_read_lock_bh();
-- 
2.26.0

