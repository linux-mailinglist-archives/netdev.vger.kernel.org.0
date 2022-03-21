Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB33D4E227D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 09:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345423AbiCUIuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 04:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345451AbiCUIuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 04:50:01 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BC8C369D9;
        Mon, 21 Mar 2022 01:48:30 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:46324.1934642690
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 5CF6628009F;
        Mon, 21 Mar 2022 16:48:25 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id ccaead6419ac45009a69f4ba5d1b8b2a for j.vosburgh@gmail.com;
        Mon, 21 Mar 2022 16:48:29 CST
X-Transaction-ID: ccaead6419ac45009a69f4ba5d1b8b2a
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
Subject: [PATCH v5 2/4] net:ipv6:Refactor ndisc_send_na to support sending na by slave directly
Date:   Mon, 21 Mar 2022 04:47:02 -0400
Message-Id: <20220321084704.36370-3-sunshouxin@chinatelecom.cn>
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

Refactor ndisc_send_na to support sending na by slave directly.

Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 include/net/ndisc.h |  6 +++++
 net/ipv6/ndisc.c    | 55 +++++++++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 24cf6e92fecc..e71702a44a3d 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -107,6 +107,12 @@ struct nd_opt_hdr {
 	__u8		nd_opt_len;
 } __packed;
 
+struct nd_sendinfo {
+	__u16 vlanid;
+	void *mac_dst;
+	const void *mac_src;
+};
+
 /* ND options */
 struct ndisc_options {
 	struct nd_opt_hdr *nd_opt_array[__ND_OPT_ARRAY_MAX];
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f7bd7082abb4..47875aab86e5 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -526,22 +526,29 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 	struct inet6_ifaddr *ifp;
 	const struct in6_addr *src_addr;
 	struct nd_msg *msg;
+	struct nd_sendinfo *sendinfo = data;
+	struct net *net = dev_net(dev);
+	struct sock *sk = net->ipv6.ndisc_sk;
 	int optlen = 0;
 
-	/* for anycast or proxy, solicited_addr != src_addr */
-	ifp = ipv6_get_ifaddr(dev_net(dev), solicited_addr, dev, 1);
-	if (ifp) {
-		src_addr = solicited_addr;
-		if (ifp->flags & IFA_F_OPTIMISTIC)
-			override = false;
-		inc_opt |= ifp->idev->cnf.force_tllao;
-		in6_ifa_put(ifp);
+	if (!sendinfo) {
+		/* for anycast or proxy, solicited_addr != src_addr */
+		ifp = ipv6_get_ifaddr(dev_net(dev), solicited_addr, dev, 1);
+		if (ifp) {
+			src_addr = solicited_addr;
+			if (ifp->flags & IFA_F_OPTIMISTIC)
+				override = false;
+			inc_opt |= ifp->idev->cnf.force_tllao;
+			in6_ifa_put(ifp);
+		} else {
+			if (ipv6_dev_get_saddr(dev_net(dev), dev, daddr,
+					       inet6_sk(dev_net(dev)->ipv6.ndisc_sk)->srcprefs,
+					       &tmpaddr))
+				return;
+			src_addr = &tmpaddr;
+		}
 	} else {
-		if (ipv6_dev_get_saddr(dev_net(dev), dev, daddr,
-				       inet6_sk(dev_net(dev)->ipv6.ndisc_sk)->srcprefs,
-				       &tmpaddr))
-			return;
-		src_addr = &tmpaddr;
+		src_addr = solicited_addr;
 	}
 
 	if (!dev->addr_len)
@@ -569,8 +576,28 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		ndisc_fill_addr_option(skb, ND_OPT_TARGET_LL_ADDR,
 				       dev->dev_addr,
 				       NDISC_NEIGHBOUR_ADVERTISEMENT);
+	if (!sendinfo) {
+		ndisc_send_skb(skb, daddr, src_addr);
+	} else {
+		if (sendinfo->vlanid)
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       sendinfo->vlanid);
+
+		msg->icmph.icmp6_cksum = csum_ipv6_magic(src_addr, daddr, skb->len,
+							 IPPROTO_ICMPV6,
+							 csum_partial(&msg->icmph,
+								      skb->len, 0));
 
-	ndisc_send_skb(skb, daddr, src_addr);
+		ip6_nd_hdr(skb, src_addr, daddr, inet6_sk(sk)->hop_limit, skb->len);
+
+		skb->protocol = htons(ETH_P_IPV6);
+		skb->dev = dev;
+		if (dev_hard_header(skb, dev, ETH_P_IPV6, sendinfo->mac_dst,
+				    sendinfo->mac_src, skb->len) < 0)
+			return;
+
+		dev_queue_xmit(skb);
+	}
 }
 
 static void ndisc_send_unsol_na(struct net_device *dev)
-- 
2.27.0

