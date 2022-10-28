Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD28610C66
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJ1Im4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJ1Imw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:42:52 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE2F1C4EEA
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:42:51 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id cr19so3105665qtb.0
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=silz/H1ihrcKl+22xXTaBMhUl1iDmzl/I3emayNPFLM=;
        b=lOD4HM9OTtL1CJ3bxaD5D8YqHTqvG7uy/iiSg2zerZYf1/agR1p80JQ1K/gQYZtZzX
         S6i9iyknyjNXefd3d1+vkO4RosXUndXsAJkRf77xoBNKh20mS7pnFNdqxa4UJ8+6dvte
         b1SKkQT5ZJ1Q8jpyKllql2g6bxtlrPzgWK82r5BtVER2cWL31JTK8QfwgN59KMisz3tk
         F7nB4xHgm8drSV5at6Ujt9hNWiCsFMrHC9BotWF8Nzebykree6/Y7gy5Es3MfdYsEg2w
         GZLzUgDFWXnymtvEfwaf4oXGSVDZIchBNMQQddwNCwXrueBGFBtrSOfSxm+LPas1uBP3
         dumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=silz/H1ihrcKl+22xXTaBMhUl1iDmzl/I3emayNPFLM=;
        b=hKc754/7VO9vXJ0dgpsB3wGEsqLKV4v6GaZ1A3lOw0gte/XRqnXLqm+URDd4Xphq0c
         dYg1dBZDVEfUMPAN5Xzd/60osRL2+nBE66AwOcuf1HmkA3LVU3n6nh/6N2+auNtutAGy
         I/1xQtlMRFNTAyEYCDq8jK/6rVPPKu5R05iZMouOjkB2cqdmYX1qf7XTfINpyIeufAf3
         jDXiQD9b1l1GsP4oBk7mXDCe0AfRLJcAJkmPrlqm4prhHq+CAp2AbrsKvqBDzIONEYX4
         6tQ1LyLn+pYHHluHFw/rU2DxkwQwQKb9I3olCoj76lMEP1ri4nUmOY1VNzFnRsrRvhQo
         j/sA==
X-Gm-Message-State: ACrzQf3gqnzCrUTNhfnq4HtT27LlAcKmEfQ073T3Hl7VPvwjhxmWbs+d
        7W/Je9Fut2vT57I7C5saWEHXe/nSVI4nIA==
X-Google-Smtp-Source: AMsMyM6TVwkJ/PufoPw3qNFCWnYCNA+9LjNlf04MtWZPJR3auuXTX5JEVF1Ggdg70FJ/boAj+05VWw==
X-Received: by 2002:ac8:5aca:0:b0:3a5:73a:1aa5 with SMTP id d10-20020ac85aca000000b003a5073a1aa5mr1548231qtd.579.1666946569913;
        Fri, 28 Oct 2022 01:42:49 -0700 (PDT)
Received: from dell-per730-23.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id br40-20020a05620a462800b006ec9f5e3396sm2510706qkb.72.2022.10.28.01.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 01:42:49 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv7 net-next 1/4] rtnetlink: pass netlink message header and portid to rtnl_configure_link()
Date:   Fri, 28 Oct 2022 04:42:21 -0400
Message-Id: <20221028084224.3509611-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221028084224.3509611-1-liuhangbin@gmail.com>
References: <20221028084224.3509611-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch pass netlink message header and portid to rtnl_configure_link()
All the functions in this call chain need to add the parameters so we can
use them in the last call rtnl_notify(), and notify the userspace about
the new link info if NLM_F_ECHO flag is set.

- rtnl_configure_link()
  - __dev_notify_flags()
    - rtmsg_ifinfo()
      - rtmsg_ifinfo_event()
        - rtmsg_ifinfo_build_skb()
        - rtmsg_ifinfo_send()
	  - rtnl_notify()

Also move __dev_notify_flags() declaration to net/core/dev.h, as Jakub
suggested.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/can/vxcan.c        |  2 +-
 drivers/net/geneve.c           |  2 +-
 drivers/net/veth.c             |  2 +-
 drivers/net/vxlan/vxlan_core.c |  4 ++--
 drivers/net/wwan/wwan_core.c   |  2 +-
 include/linux/netdevice.h      |  2 --
 include/linux/rtnetlink.h      |  9 +++++----
 include/net/netlink.h          | 11 +++++++++++
 include/net/rtnetlink.h        |  3 ++-
 net/core/dev.c                 | 25 ++++++++++++------------
 net/core/dev.h                 |  4 ++++
 net/core/rtnetlink.c           | 35 ++++++++++++++++++----------------
 net/ipv4/ip_gre.c              |  2 +-
 13 files changed, 61 insertions(+), 42 deletions(-)

diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 26a472d2ea58..4068d962203d 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -236,7 +236,7 @@ static int vxcan_newlink(struct net *net, struct net_device *dev,
 
 	netif_carrier_off(peer);
 
-	err = rtnl_configure_link(peer, ifmp);
+	err = rtnl_configure_link(peer, ifmp, 0, NULL);
 	if (err < 0)
 		goto unregister_network_device;
 
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index f393e454f45c..89ff7f8e8c7e 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1907,7 +1907,7 @@ struct net_device *geneve_dev_create_fb(struct net *net, const char *name,
 	if (err)
 		goto err;
 
-	err = rtnl_configure_link(dev, NULL);
+	err = rtnl_configure_link(dev, NULL, 0, NULL);
 	if (err < 0)
 		goto err;
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 09682ea3354e..1cc92225b2f0 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1773,7 +1773,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	veth_disable_gro(peer);
 	netif_carrier_off(peer);
 
-	err = rtnl_configure_link(peer, ifmp);
+	err = rtnl_configure_link(peer, ifmp, 0, NULL);
 	if (err < 0)
 		goto err_configure_peer;
 
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 6ab669dcd1c6..92224b36787a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3794,7 +3794,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 			goto errout;
 	}
 
-	err = rtnl_configure_link(dev, NULL);
+	err = rtnl_configure_link(dev, NULL, 0, NULL);
 	if (err < 0)
 		goto unlink;
 
@@ -4416,7 +4416,7 @@ struct net_device *vxlan_dev_create(struct net *net, const char *name,
 		return ERR_PTR(err);
 	}
 
-	err = rtnl_configure_link(dev, NULL);
+	err = rtnl_configure_link(dev, NULL, 0, NULL);
 	if (err < 0) {
 		LIST_HEAD(list_kill);
 
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 62e9f7d6c9fe..d72ee18476d1 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -1058,7 +1058,7 @@ static void wwan_create_default_link(struct wwan_device *wwandev,
 		goto unlock;
 	}
 
-	rtnl_configure_link(dev, NULL); /* Link initialized, notify new link */
+	rtnl_configure_link(dev, NULL, 0, NULL); /* Link initialized, notify new link */
 
 unlock:
 	rtnl_unlock();
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eddf8ee270e7..b727ed06e582 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3855,8 +3855,6 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
 		       struct netlink_ext_ack *extack);
 int dev_change_flags(struct net_device *dev, unsigned int flags,
 		     struct netlink_ext_ack *extack);
-void __dev_notify_flags(struct net_device *, unsigned int old_flags,
-			unsigned int gchanges);
 int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
 int __dev_change_net_namespace(struct net_device *dev, struct net *net,
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index ae2c6a3cec5d..92ad75549e9c 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -12,21 +12,22 @@
 extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
 extern int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid);
 extern void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid,
-			u32 group, struct nlmsghdr *nlh, gfp_t flags);
+			u32 group, const struct nlmsghdr *nlh, gfp_t flags);
 extern void rtnl_set_sk_err(struct net *net, u32 group, int error);
 extern int rtnetlink_put_metrics(struct sk_buff *skb, u32 *metrics);
 extern int rtnl_put_cacheinfo(struct sk_buff *skb, struct dst_entry *dst,
 			      u32 id, long expires, u32 error);
 
-void rtmsg_ifinfo(int type, struct net_device *dev, unsigned change, gfp_t flags);
+void rtmsg_ifinfo(int type, struct net_device *dev, unsigned int change, gfp_t flags,
+		  u32 portid, const struct nlmsghdr *nlh);
 void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 			 gfp_t flags, int *new_nsid, int new_ifindex);
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned change, u32 event,
 				       gfp_t flags, int *new_nsid,
-				       int new_ifindex);
+				       int new_ifindex, u32 portid, u32 seq);
 void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev,
-		       gfp_t flags);
+		       gfp_t flags, u32 portid, const struct nlmsghdr *nlh);
 
 
 /* RTNL is used as a global lock for all changes to network configuration  */
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 4418b1981e31..c65ea95e2f4a 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -899,6 +899,17 @@ static inline int nlmsg_report(const struct nlmsghdr *nlh)
 	return nlh ? !!(nlh->nlmsg_flags & NLM_F_ECHO) : 0;
 }
 
+/**
+ * nlmsg_seq - return the seq number of netlink message
+ * @nlh: netlink message header
+ *
+ * Returns 0 if netlink message is NULL
+ */
+static inline u32 nlmsg_seq(const struct nlmsghdr *nlh)
+{
+	return nlh ? nlh->nlmsg_seq : 0;
+}
+
 /**
  * nlmsg_for_each_attr - iterate over a stream of attributes
  * @pos: loop counter, set to current attribute
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index bf8bb3357825..cd94f65dc2a9 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -187,7 +187,8 @@ struct net_device *rtnl_create_link(struct net *net, const char *ifname,
 				    struct nlattr *tb[],
 				    struct netlink_ext_ack *extack);
 int rtnl_delete_link(struct net_device *dev);
-int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm);
+int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm,
+			u32 portid, const struct nlmsghdr *nlh);
 
 int rtnl_nla_parse_ifla(struct nlattr **tb, const struct nlattr *head, int len,
 			struct netlink_ext_ack *exterr);
diff --git a/net/core/dev.c b/net/core/dev.c
index fff62068a53d..ce61ebaaae19 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1333,7 +1333,7 @@ void netdev_state_change(struct net_device *dev)
 
 		call_netdevice_notifiers_info(NETDEV_CHANGE,
 					      &change_info.info);
-		rtmsg_ifinfo(RTM_NEWLINK, dev, 0, GFP_KERNEL);
+		rtmsg_ifinfo(RTM_NEWLINK, dev, 0, GFP_KERNEL, 0, NULL);
 	}
 }
 EXPORT_SYMBOL(netdev_state_change);
@@ -1469,7 +1469,7 @@ int dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (ret < 0)
 		return ret;
 
-	rtmsg_ifinfo(RTM_NEWLINK, dev, IFF_UP|IFF_RUNNING, GFP_KERNEL);
+	rtmsg_ifinfo(RTM_NEWLINK, dev, IFF_UP | IFF_RUNNING, GFP_KERNEL, 0, NULL);
 	call_netdevice_notifiers(NETDEV_UP, dev);
 
 	return ret;
@@ -1541,7 +1541,7 @@ void dev_close_many(struct list_head *head, bool unlink)
 	__dev_close_many(head);
 
 	list_for_each_entry_safe(dev, tmp, head, close_list) {
-		rtmsg_ifinfo(RTM_NEWLINK, dev, IFF_UP|IFF_RUNNING, GFP_KERNEL);
+		rtmsg_ifinfo(RTM_NEWLINK, dev, IFF_UP | IFF_RUNNING, GFP_KERNEL, 0, NULL);
 		call_netdevice_notifiers(NETDEV_DOWN, dev);
 		if (unlink)
 			list_del_init(&dev->close_list);
@@ -8351,7 +8351,7 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
 		dev_change_rx_flags(dev, IFF_PROMISC);
 	}
 	if (notify)
-		__dev_notify_flags(dev, old_flags, IFF_PROMISC);
+		__dev_notify_flags(dev, old_flags, IFF_PROMISC, 0, NULL);
 	return 0;
 }
 
@@ -8406,7 +8406,7 @@ static int __dev_set_allmulti(struct net_device *dev, int inc, bool notify)
 		dev_set_rx_mode(dev);
 		if (notify)
 			__dev_notify_flags(dev, old_flags,
-					   dev->gflags ^ old_gflags);
+					   dev->gflags ^ old_gflags, 0, NULL);
 	}
 	return 0;
 }
@@ -8569,12 +8569,13 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
 }
 
 void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
-			unsigned int gchanges)
+			unsigned int gchanges, u32 portid,
+			const struct nlmsghdr *nlh)
 {
 	unsigned int changes = dev->flags ^ old_flags;
 
 	if (gchanges)
-		rtmsg_ifinfo(RTM_NEWLINK, dev, gchanges, GFP_ATOMIC);
+		rtmsg_ifinfo(RTM_NEWLINK, dev, gchanges, GFP_ATOMIC, portid, nlh);
 
 	if (changes & IFF_UP) {
 		if (dev->flags & IFF_UP)
@@ -8616,7 +8617,7 @@ int dev_change_flags(struct net_device *dev, unsigned int flags,
 		return ret;
 
 	changes = (old_flags ^ dev->flags) | (old_gflags ^ dev->gflags);
-	__dev_notify_flags(dev, old_flags, changes);
+	__dev_notify_flags(dev, old_flags, changes, 0, NULL);
 	return ret;
 }
 EXPORT_SYMBOL(dev_change_flags);
@@ -10101,7 +10102,7 @@ int register_netdevice(struct net_device *dev)
 	 */
 	if (!dev->rtnl_link_ops ||
 	    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
-		rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
+		rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL, 0, NULL);
 
 out:
 	return ret;
@@ -10849,7 +10850,7 @@ void unregister_netdevice_many(struct list_head *head)
 		if (!dev->rtnl_link_ops ||
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
-						     GFP_KERNEL, NULL, 0);
+						     GFP_KERNEL, NULL, 0, 0, 0);
 
 		/*
 		 *	Flush the unicast and multicast chains
@@ -10864,7 +10865,7 @@ void unregister_netdevice_many(struct list_head *head)
 			dev->netdev_ops->ndo_uninit(dev);
 
 		if (skb)
-			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL);
+			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
 
 		/* Notifier chain MUST detach us all upper devices. */
 		WARN_ON(netdev_has_any_upper_dev(dev));
@@ -11042,7 +11043,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	 *	Prevent userspace races by waiting until the network
 	 *	device is fully setup before sending notifications.
 	 */
-	rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
+	rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL, 0, NULL);
 
 	synchronize_net();
 	err = 0;
diff --git a/net/core/dev.h b/net/core/dev.h
index cbb8a925175a..6b3c7302f570 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -88,6 +88,10 @@ int dev_change_carrier(struct net_device *dev, bool new_carrier);
 
 void __dev_set_rx_mode(struct net_device *dev);
 
+void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
+			unsigned int gchanges, u32 portid,
+			const struct nlmsghdr *nlh);
+
 static inline void netif_set_gso_max_size(struct net_device *dev,
 					  unsigned int size)
 {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 74864dc46a7e..c9dd9730f3c6 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -760,7 +760,7 @@ int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid)
 EXPORT_SYMBOL(rtnl_unicast);
 
 void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid, u32 group,
-		 struct nlmsghdr *nlh, gfp_t flags)
+		 const struct nlmsghdr *nlh, gfp_t flags)
 {
 	struct sock *rtnl = net->rtnl;
 
@@ -3180,7 +3180,8 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
+int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm,
+			u32 portid, const struct nlmsghdr *nlh)
 {
 	unsigned int old_flags;
 	int err;
@@ -3194,10 +3195,10 @@ int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
 	}
 
 	if (dev->rtnl_link_state == RTNL_LINK_INITIALIZED) {
-		__dev_notify_flags(dev, old_flags, (old_flags ^ dev->flags));
+		__dev_notify_flags(dev, old_flags, (old_flags ^ dev->flags), portid, nlh);
 	} else {
 		dev->rtnl_link_state = RTNL_LINK_INITIALIZED;
-		__dev_notify_flags(dev, old_flags, ~0U);
+		__dev_notify_flags(dev, old_flags, ~0U, portid, nlh);
 	}
 	return 0;
 }
@@ -3369,7 +3370,7 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
 		goto out;
 	}
 
-	err = rtnl_configure_link(dev, ifm);
+	err = rtnl_configure_link(dev, ifm, 0, NULL);
 	if (err < 0)
 		goto out_unregister;
 	if (link_net) {
@@ -3896,7 +3897,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned int change,
 				       u32 event, gfp_t flags, int *new_nsid,
-				       int new_ifindex)
+				       int new_ifindex, u32 portid, u32 seq)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
@@ -3907,7 +3908,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 		goto errout;
 
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
-			       type, 0, 0, change, 0, 0, event,
+			       type, portid, seq, change, 0, 0, event,
 			       new_nsid, new_ifindex, -1, flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
@@ -3922,16 +3923,18 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 	return NULL;
 }
 
-void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev, gfp_t flags)
+void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev, gfp_t flags,
+		       u32 portid, const struct nlmsghdr *nlh)
 {
 	struct net *net = dev_net(dev);
 
-	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, flags);
+	rtnl_notify(skb, net, portid, RTNLGRP_LINK, nlh, flags);
 }
 
 static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 			       unsigned int change, u32 event,
-			       gfp_t flags, int *new_nsid, int new_ifindex)
+			       gfp_t flags, int *new_nsid, int new_ifindex,
+			       u32 portid, const struct nlmsghdr *nlh)
 {
 	struct sk_buff *skb;
 
@@ -3939,23 +3942,23 @@ static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 		return;
 
 	skb = rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_nsid,
-				     new_ifindex);
+				     new_ifindex, portid, nlmsg_seq(nlh));
 	if (skb)
-		rtmsg_ifinfo_send(skb, dev, flags);
+		rtmsg_ifinfo_send(skb, dev, flags, portid, nlh);
 }
 
 void rtmsg_ifinfo(int type, struct net_device *dev, unsigned int change,
-		  gfp_t flags)
+		  gfp_t flags, u32 portid, const struct nlmsghdr *nlh)
 {
 	rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
-			   NULL, 0);
+			   NULL, 0, portid, nlh);
 }
 
 void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 			 gfp_t flags, int *new_nsid, int new_ifindex)
 {
 	rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
-			   new_nsid, new_ifindex);
+			   new_nsid, new_ifindex, 0, NULL);
 }
 
 static int nlmsg_populate_fdb_fill(struct sk_buff *skb,
@@ -6140,7 +6143,7 @@ static int rtnetlink_event(struct notifier_block *this, unsigned long event, voi
 	case NETDEV_CHANGELOWERSTATE:
 	case NETDEV_CHANGE_TX_QUEUE_LEN:
 		rtmsg_ifinfo_event(RTM_NEWLINK, dev, 0, rtnl_get_event(event),
-				   GFP_KERNEL, NULL, 0);
+				   GFP_KERNEL, NULL, 0, 0, NULL);
 		break;
 	default:
 		break;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f866d6282b2b..d8ee5238c395 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1665,7 +1665,7 @@ struct net_device *gretap_fb_dev_create(struct net *net, const char *name,
 	if (err)
 		goto out;
 
-	err = rtnl_configure_link(dev, NULL);
+	err = rtnl_configure_link(dev, NULL, 0, NULL);
 	if (err < 0)
 		goto out;
 
-- 
2.37.3

