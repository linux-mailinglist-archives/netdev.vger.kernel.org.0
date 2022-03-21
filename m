Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47D44E227F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 09:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345431AbiCUItt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 04:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345423AbiCUItr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 04:49:47 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8398B35DFE;
        Mon, 21 Mar 2022 01:48:20 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:46324.1934642690
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 2AC6728009C;
        Mon, 21 Mar 2022 16:48:11 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 68f84a2ebadc4056bd544c1d8a6c547b for j.vosburgh@gmail.com;
        Mon, 21 Mar 2022 16:48:20 CST
X-Transaction-ID: 68f84a2ebadc4056bd544c1d8a6c547b
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v5 1/4] net:ipv6:Add void *data to ndisc_send_na function
Date:   Mon, 21 Mar 2022 04:47:01 -0400
Message-Id: <20220321084704.36370-2-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220321084704.36370-1-sunshouxin@chinatelecom.cn>
References: <20220321084704.36370-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds void *data to ndisc_send_na stub function and
ndisc_send_na direct function. Update all places that
use both ndisc_send_na to pass NULL as the data parameter.

Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/usb/cdc_mbim.c | 3 ++-
 include/net/ipv6_stubs.h   | 3 ++-
 include/net/ndisc.h        | 3 ++-
 net/ipv6/addrconf.c        | 2 +-
 net/ipv6/ndisc.c           | 9 +++++----
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c89639381eca..fa3869b214a9 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -347,7 +347,8 @@ static void do_neigh_solicit(struct usbnet *dev, u8 *buf, u16 tci)
 				 is_router /* router */,
 				 true /* solicited */,
 				 false /* override */,
-				 true /* inc_opt */);
+				 true /* inc_opt */,
+				 NULL);
 out:
 	dev_put(netdev);
 }
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 45e0339be6fa..2b64ea6590b6 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -56,7 +56,8 @@ struct ipv6_stub {
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
-			      bool router, bool solicited, bool override, bool inc_opt);
+			      bool router, bool solicited, bool override,
+			      bool inc_opt, void *data);
 #if IS_ENABLED(CONFIG_XFRM)
 	void (*xfrm6_local_rxpmtu)(struct sk_buff *skb, u32 mtu);
 	int (*xfrm6_udp_encap_rcv)(struct sock *sk, struct sk_buff *skb);
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index da7eec8669ec..24cf6e92fecc 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -460,7 +460,8 @@ void ndisc_send_rs(struct net_device *dev,
 		   const struct in6_addr *saddr, const struct in6_addr *daddr);
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
-		   bool router, bool solicited, bool override, bool inc_opt);
+		   bool router, bool solicited, bool override, bool inc_opt,
+		   void *data);
 
 void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target);
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..bb1912eacd90 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4217,7 +4217,7 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 		ndisc_send_na(dev, &in6addr_linklocal_allnodes, &ifp->addr,
 			      /*router=*/ !!ifp->idev->cnf.forwarding,
 			      /*solicited=*/ false, /*override=*/ true,
-			      /*inc_opt=*/ true);
+			      /*inc_opt=*/ true, NULL);
 	}
 
 	if (send_rs) {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index fcb288b0ae13..f7bd7082abb4 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -518,7 +518,8 @@ EXPORT_SYMBOL(ndisc_send_skb);
 
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
-		   bool router, bool solicited, bool override, bool inc_opt)
+		   bool router, bool solicited, bool override, bool inc_opt,
+		   void *data)
 {
 	struct sk_buff *skb;
 	struct in6_addr tmpaddr;
@@ -591,7 +592,7 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 		ndisc_send_na(dev, &in6addr_linklocal_allnodes, &ifa->addr,
 			      /*router=*/ !!idev->cnf.forwarding,
 			      /*solicited=*/ false, /*override=*/ true,
-			      /*inc_opt=*/ true);
+			      /*inc_opt=*/ true, NULL);
 	}
 	read_unlock_bh(&idev->lock);
 
@@ -932,7 +933,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 
 	if (dad) {
 		ndisc_send_na(dev, &in6addr_linklocal_allnodes, &msg->target,
-			      !!is_router, false, (ifp != NULL), true);
+			      !!is_router, false, ifp, true, NULL);
 		goto out;
 	}
 
@@ -954,7 +955,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 			     NDISC_NEIGHBOUR_SOLICITATION, &ndopts);
 	if (neigh || !dev->header_ops) {
 		ndisc_send_na(dev, saddr, &msg->target, !!is_router,
-			      true, (ifp != NULL && inc), inc);
+			      true, (ifp && inc), inc, NULL);
 		if (neigh)
 			neigh_release(neigh);
 	}
-- 
2.27.0

