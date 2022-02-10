Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EFB4B17CC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344758AbiBJVmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:42:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240940AbiBJVmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:42:42 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAB71D1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:42 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso10052992pjg.0
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=njF4HQAZAt6kM3R0jZtNL7OgZ6d6AF7n7BTmiezE6WA=;
        b=bhW+fgGZIKWEufEeCdadEwlg6thJoUzanLFTVkr6D1UQjaETkRLUMzGtVuuIuTVv8E
         C6yj+QT+4l1ZSSmIBO0C0bi9FNqeuGWs2ejKbqNvspT5H78z8L2/SEvFEIi2HZGl3p01
         x26m7FL6qrCjvq+XsDFbzk1XKY767qa6se/TJ2YAfsvvRDGdb8Wkp7VS03MyYyuSW7Ay
         EWybbYvuHLY86Ck74ikOgQmFrwOf5xFm83VAeSeo8cyyo+i4YBJ50SxXYMLIr9b6Es3h
         06CIxOcQPjJ2dj2lmTpxHX0ge80hguD/rCl5th50tF3dGRblFbwnaLmRznNDij5o6Cdk
         vTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=njF4HQAZAt6kM3R0jZtNL7OgZ6d6AF7n7BTmiezE6WA=;
        b=kkVV6Y8H8VDZDh9rqzJwRQSp7d9aMuW9jfnN7UDADT+DvSbFdep+3vwuCzu5bblTvF
         EX/bdF5tpR4cnkfSEWFHhBe5VRqcB5Kvl8ExsWuBIQcBI7QAPkYRh+X3fFVMrSEKXE/u
         ndhJekCbUPrf7ZoacNmJMEf3Vxfk3gYUGfQVlVboWpmnpyvGP6hoRm0R8h/xb7YyKLd2
         IThx2jfr9Dx6CTcTGRoLxcTm+jUJrS+dMoutgcJvj23CsyFyYDwAlmShCG4qPpAUWcCR
         SR1kBw1z/lZBmTUT+LUixgnzLGd1VTcKpS3bh8fz0vpqkQf+f/3Md4iZB1OKDyxWQuXt
         QWrQ==
X-Gm-Message-State: AOAM530joaCK4qSBTndSoD3DgBrtJtKA+Y0rzQVqxMfkve4IrotTj6I8
        6B8IKc5VRVqXGKalf4pHPUY=
X-Google-Smtp-Source: ABdhPJy2tZOVsJsdeAQSV/eOOkVoaOjFczzIIrofTmbMb6xTu932trDFspv+XV5oPccqPiOJdrqRWw==
X-Received: by 2002:a17:903:3009:: with SMTP id o9mr1752742pla.163.1644529361844;
        Thu, 10 Feb 2022 13:42:41 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:60c1:10c1:3f4f:199d])
        by smtp.gmail.com with ESMTPSA id s19sm23824098pfu.34.2022.02.10.13.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:42:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] ipv6: give an IPv6 dev to blackhole_netdev
Date:   Thu, 10 Feb 2022 13:42:29 -0800
Message-Id: <20220210214231.2420942-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210214231.2420942-1-eric.dumazet@gmail.com>
References: <20220210214231.2420942-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

IPv6 addrconf notifiers wants the loopback device to
be the last device being dismantled at netns deletion.

This caused many limitations and work arounds.

Back in linux-5.3, Mahesh added a per host blackhole_netdev
that can be used whenever we need to make sure objects no longer
refer to a disappearing device.

If we attach to blackhole_netdev an ip6_ptr (allocate an idev),
then we can use this special device (which is never freed)
in place of the loopback_dev (which can be freed).

This will permit improvements in netdev_run_todo() and other parts
of the stack where had steps to make sure loopback_dev was
the last device to disappear.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mahesh Bandewar <maheshb@google.com>
---
 net/ipv6/addrconf.c | 78 +++++++++++++++++++--------------------------
 net/ipv6/route.c    | 21 +++++-------
 2 files changed, 40 insertions(+), 59 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4f402bc38f056e08f3761e63a7bc7a51e54e9384..02d31d4fcab3b3d529c4fe3260216ecee1108e82 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -372,7 +372,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 
 	ASSERT_RTNL();
 
-	if (dev->mtu < IPV6_MIN_MTU)
+	if (dev->mtu < IPV6_MIN_MTU && dev != blackhole_netdev)
 		return ERR_PTR(-EINVAL);
 
 	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
@@ -400,21 +400,22 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	/* We refer to the device */
 	dev_hold_track(dev, &ndev->dev_tracker, GFP_KERNEL);
 
-	if (snmp6_alloc_dev(ndev) < 0) {
-		netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
-			   __func__);
-		neigh_parms_release(&nd_tbl, ndev->nd_parms);
-		dev_put_track(dev, &ndev->dev_tracker);
-		kfree(ndev);
-		return ERR_PTR(err);
-	}
+	if (dev != blackhole_netdev) {
+		if (snmp6_alloc_dev(ndev) < 0) {
+			netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
+				   __func__);
+			neigh_parms_release(&nd_tbl, ndev->nd_parms);
+			dev_put_track(dev, &ndev->dev_tracker);
+			kfree(ndev);
+			return ERR_PTR(err);
+		}
 
-	if (snmp6_register_dev(ndev) < 0) {
-		netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
-			   __func__, dev->name);
-		goto err_release;
+		if (snmp6_register_dev(ndev) < 0) {
+			netdev_dbg(dev, "%s: cannot create /proc/net/dev_snmp6/%s\n",
+				   __func__, dev->name);
+			goto err_release;
+		}
 	}
-
 	/* One reference from device. */
 	refcount_set(&ndev->refcnt, 1);
 
@@ -445,25 +446,28 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 
 	ipv6_mc_init_dev(ndev);
 	ndev->tstamp = jiffies;
-	err = addrconf_sysctl_register(ndev);
-	if (err) {
-		ipv6_mc_destroy_dev(ndev);
-		snmp6_unregister_dev(ndev);
-		goto err_release;
+	if (dev != blackhole_netdev) {
+		err = addrconf_sysctl_register(ndev);
+		if (err) {
+			ipv6_mc_destroy_dev(ndev);
+			snmp6_unregister_dev(ndev);
+			goto err_release;
+		}
 	}
 	/* protected by rtnl_lock */
 	rcu_assign_pointer(dev->ip6_ptr, ndev);
 
-	/* Join interface-local all-node multicast group */
-	ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
+	if (dev != blackhole_netdev) {
+		/* Join interface-local all-node multicast group */
+		ipv6_dev_mc_inc(dev, &in6addr_interfacelocal_allnodes);
 
-	/* Join all-node multicast group */
-	ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
-
-	/* Join all-router multicast group if forwarding is set */
-	if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
-		ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
+		/* Join all-node multicast group */
+		ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
 
+		/* Join all-router multicast group if forwarding is set */
+		if (ndev->cnf.forwarding && (dev->flags & IFF_MULTICAST))
+			ipv6_dev_mc_inc(dev, &in6addr_linklocal_allrouters);
+	}
 	return ndev;
 
 err_release:
@@ -7233,26 +7237,8 @@ int __init addrconf_init(void)
 		goto out_nowq;
 	}
 
-	/* The addrconf netdev notifier requires that loopback_dev
-	 * has it's ipv6 private information allocated and setup
-	 * before it can bring up and give link-local addresses
-	 * to other devices which are up.
-	 *
-	 * Unfortunately, loopback_dev is not necessarily the first
-	 * entry in the global dev_base list of net devices.  In fact,
-	 * it is likely to be the very last entry on that list.
-	 * So this causes the notifier registry below to try and
-	 * give link-local addresses to all devices besides loopback_dev
-	 * first, then loopback_dev, which cases all the non-loopback_dev
-	 * devices to fail to get a link-local address.
-	 *
-	 * So, as a temporary fix, allocate the ipv6 structure for
-	 * loopback_dev first by hand.
-	 * Longer term, all of the dependencies ipv6 has upon the loopback
-	 * device and it being up should be removed.
-	 */
 	rtnl_lock();
-	idev = ipv6_add_dev(init_net.loopback_dev);
+	idev = ipv6_add_dev(blackhole_netdev);
 	rtnl_unlock();
 	if (IS_ERR(idev)) {
 		err = PTR_ERR(idev);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 53acd1568ebcceb1a1697579ed505cefc7a35a65..5fc1a1de9481c859adc332746ccfcf237db6541f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -156,14 +156,10 @@ void rt6_uncached_list_del(struct rt6_info *rt)
 	}
 }
 
-static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
+static void rt6_uncached_list_flush_dev(struct net_device *dev)
 {
-	struct net_device *loopback_dev = net->loopback_dev;
 	int cpu;
 
-	if (dev == loopback_dev)
-		return;
-
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
 		struct rt6_info *rt;
@@ -174,7 +170,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 			struct net_device *rt_dev = rt->dst.dev;
 
 			if (rt_idev->dev == dev) {
-				rt->rt6i_idev = in6_dev_get(loopback_dev);
+				rt->rt6i_idev = in6_dev_get(blackhole_netdev);
 				in6_dev_put(rt_idev);
 			}
 
@@ -371,13 +367,12 @@ static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 {
 	struct rt6_info *rt = (struct rt6_info *)dst;
 	struct inet6_dev *idev = rt->rt6i_idev;
-	struct net_device *loopback_dev =
-		dev_net(dev)->loopback_dev;
 
-	if (idev && idev->dev != loopback_dev) {
-		struct inet6_dev *loopback_idev = in6_dev_get(loopback_dev);
-		if (loopback_idev) {
-			rt->rt6i_idev = loopback_idev;
+	if (idev && idev->dev != blackhole_netdev) {
+		struct inet6_dev *blackhole_idev = in6_dev_get(blackhole_netdev);
+
+		if (blackhole_idev) {
+			rt->rt6i_idev = blackhole_idev;
 			in6_dev_put(idev);
 		}
 	}
@@ -4892,7 +4887,7 @@ void rt6_sync_down_dev(struct net_device *dev, unsigned long event)
 void rt6_disable_ip(struct net_device *dev, unsigned long event)
 {
 	rt6_sync_down_dev(dev, event);
-	rt6_uncached_list_flush_dev(dev_net(dev), dev);
+	rt6_uncached_list_flush_dev(dev);
 	neigh_ifdown(&nd_tbl, dev);
 }
 
-- 
2.35.1.265.g69c8d7142f-goog

