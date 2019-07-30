Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8A779ECE
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 04:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfG3CjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 22:39:24 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39411 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730921AbfG3CjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 22:39:23 -0400
X-IronPort-AV: E=Sophos;i="5.64,325,1559491200"; 
   d="scan'208";a="72493080"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Jul 2019 10:37:03 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 816394CDDAE4;
        Tue, 30 Jul 2019 10:37:00 +0800 (CST)
Received: from localhost.localdomain (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Tue, 30 Jul 2019 10:36:59 +0800
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH net v2] net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a global address
Date:   Tue, 30 Jul 2019 10:35:15 +0800
Message-ID: <1564454115-66184-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: 816394CDDAE4.AE319
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
Changes since V1:
	- Change patch description and code optimization at 
          David Ahern's suggestion
---
 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 34 ++++++++++++++++++++++++++++++++++
 net/ipv6/ndisc.c       |  9 ++++++---
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index becdad5..ce1561e 100644
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
index 521e320..9467457 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1870,6 +1870,40 @@ int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
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
index 083cc1c..156c027 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -603,11 +603,14 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 	int inc_opt = dev->addr_len;
 	int optlen = 0;
 	struct nd_msg *msg;
+	u32 banned_flags = IFA_F_TENTATIVE | IFA_F_OPTIMISTIC;
 
 	if (!saddr) {
-		if (ipv6_get_lladdr(dev, &addr_buf,
-				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
-			return;
+		if (ipv6_get_lladdr(dev, &addr_buf, banned_flags)) {
+			/* try global address */
+			if (ipv6_get_addr(dev, &addr_buf, banned_flags))
+				return;
+		}
 		saddr = &addr_buf;
 	}
 
-- 
2.7.4



