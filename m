Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CE47B7DB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfGaBy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:54:56 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48123 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726559AbfGaBy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:54:56 -0400
X-IronPort-AV: E=Sophos;i="5.64,328,1559491200"; 
   d="scan'208";a="72554300"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 09:54:29 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 9C1414CDDAE4;
        Wed, 31 Jul 2019 09:54:27 +0800 (CST)
Received: from localhost.localdomain (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 09:54:29 +0800
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH net v3] net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a global address
Date:   Wed, 31 Jul 2019 09:52:52 +0800
Message-ID: <1564537972-76503-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: 9C1414CDDAE4.AF7E7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the egress interface does not have a link local address, it can
not communicate with other hosts.

In RFC4861, 7.2.2 says
"If the source address of the packet prompting the solicitation is the
same as one of the addresses assigned to the outgoing interface, that
address SHOULD be placed in the IP Source Address of the outgoing
solicitation.  Otherwise, any one of the addresses assigned to the
interface should be used."

In this patch we try get a global address if we get ll address failed.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
Changes since V2:
	- Let banned_flags under the scope of its use.
---
 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 34 ++++++++++++++++++++++++++++++++++
 net/ipv6/ndisc.c       | 10 +++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 269ec27..eae1167 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -107,6 +107,8 @@ int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
 		      u32 banned_flags);
 int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 		    u32 banned_flags);
+int ipv6_get_addr(struct net_device *dev, struct in6_addr *addr,
+		    u32 banned_flags);
 bool inet_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2,
 			  bool match_wildcard);
 bool inet_rcv_saddr_any(const struct sock *sk);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4ae17a9..9e537bd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1873,6 +1873,40 @@ int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 	return err;
 }
 
+int __ipv6_get_addr(struct inet6_dev *idev, struct in6_addr *addr,
+		    u32 banned_flags)
+{
+	struct inet6_ifaddr *ifp;
+	int err = -EADDRNOTAVAIL;
+
+	list_for_each_entry(ifp, &idev->addr_list, if_list) {
+		if (ifp->scope == 0 &&
+		    !(ifp->flags & banned_flags)) {
+			*addr = ifp->addr;
+			err = 0;
+			break;
+		}
+	}
+	return err;
+}
+
+int ipv6_get_addr(struct net_device *dev, struct in6_addr *addr,
+		  u32 banned_flags)
+{
+	struct inet6_dev *idev;
+	int err = -EADDRNOTAVAIL;
+
+	rcu_read_lock();
+	idev = __in6_dev_get(dev);
+	if (idev) {
+		read_lock_bh(&idev->lock);
+		err = __ipv6_get_addr(idev, addr, banned_flags);
+		read_unlock_bh(&idev->lock);
+	}
+	rcu_read_unlock();
+	return err;
+}
+
 static int ipv6_count_addresses(const struct inet6_dev *idev)
 {
 	const struct inet6_ifaddr *ifp;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 659ecf4e..fa58c6e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -592,9 +592,13 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 	struct nd_msg *msg;
 
 	if (!saddr) {
-		if (ipv6_get_lladdr(dev, &addr_buf,
-				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
-			return;
+		u32 banned_flags = IFA_F_TENTATIVE | IFA_F_OPTIMISTIC;
+
+		if (ipv6_get_lladdr(dev, &addr_buf, banned_flags)) {
+			/* try global address */
+			if (ipv6_get_addr(dev, &addr_buf, banned_flags))
+				return;
+		}
 		saddr = &addr_buf;
 	}
 
-- 
2.7.4



