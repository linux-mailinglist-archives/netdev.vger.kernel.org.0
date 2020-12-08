Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5F2D21A4
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgLHD4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:56:48 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26140 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgLHD4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:56:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607399782; h=Message-ID: Subject: Cc: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=eNPWnHWu3TuWmb9NdNGVKyIhVVzr6ljVp2PxpHRckYI=; b=cVVaoZOBeOyo6JwqtH3P92dynrDxbsZR+q47nTRsNqbA6YjjKLfJ72PTBePPYTodJdA/Ovlw
 BsevZOM5MTOuh6L1dFzWkDJfK36bIzmJRzhOSACoeS7Q2y4/CrQxnHT0KgWAmJ8dljCLx643
 +E24KHK6ks9ot5tNez3Mrow9hOs=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fcef948eb348d1ba23369a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 03:55:52
 GMT
Sender: stranche=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 64033C433C6; Tue,  8 Dec 2020 03:55:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9963FC433ED;
        Tue,  8 Dec 2020 03:55:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 07 Dec 2020 20:55:51 -0700
From:   stranche@codeaurora.org
To:     dsahern@gmail.com, weiwan@google.com, kafai@fb.com,
        maheshb@google.com, kuba@kernel.org, netdev@vger.kernel.org
Cc:     subashab@codeaurora.org
Subject: Refcount mismatch when unregistering netdevice from kernel
Message-ID: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

We've recently been investigating a refcount problem when unregistering 
a netdevice from the kernel. It seems that the IPv6 module is still 
holding various references to the inet6_dev associated with the main 
netdevice struct that are not being released, preventing the 
unregistration from completing.

After tracing the various locations that take/release refcounts to these 
two structs, we see that there are mismatches in the refcount for the 
inet6_dev in the DST path when there are routes flushed with the 
rt6_uncached_list_flush_dev() function during rt6_disable_ip() when the 
device is unregistering. It seems that usually these references are 
freed via ip6_dst_ifdown() in the dst_ops->ifdown callback from 
dst_dev_put(), but this callback is not executed in the 
rt6_uncached_list_flush_dev() function. Instead, a reference to the 
inet6_dev is simply dropped to account for the inet6_dev_get() in 
ip6_rt_copy_init().

Unfortunately, this does not seem to be sufficient, as these uncached 
routes have an additional refcount on the inet6_device attached to them 
from the DST allocation. In the normal case, this reference from the DST 
allocation will happen in the dst_ops->destroy() callback in the 
dst_destroy() function when the DST is being freed. However, since 
rt6_uncached_list_flush_dev() changes the inet6_device stored in the DST 
to the loopback device, the dst_ops->destroy() callback doesn't 
decrement the refcount on the correct inet6_dev struct.

We're wondering if it would be appropriate to put() the refcount 
additionally for the uncached routes when flushing out the list for the 
unregistering device. Perhaps something like the following?

diff --git a/net/ipv6/route.c b/net/ipv6/route.c index 6602f43..554b07b 
100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -156,9 +156,11 @@ void rt6_uncached_list_del(struct rt6_info *rt)

   char rt6_uncached_list_flush_dev_log1[1000][512];
   int rt6_uncached_list_flush_dev_log1_iter = 0; -static void 
rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
+static void rt6_uncached_list_flush_dev(struct net *net, struct 
net_device *dev,
+                                        unsigned long event)
   {
          struct net_device *loopback_dev = net->loopback_dev;
+       bool unreg = event == NETDEV_UNREGISTER;
          int cpu;

          if (dev == loopback_dev)
@@ -190,6 +192,10 @@ static void rt6_uncached_list_flush_dev(struct net 
*net, struct net_device *dev)
                          }

                          if (rt_idev->dev == dev) {
+                               if (rt->dst.ops->ifdown)
+                                       rt->dst.ops->ifdown(&rt->dst, 
dev,
+                                                           unreg);
+
                                  rt->rt6i_idev = 
in6_dev_get(loopback_dev);
                                  in6_dev_put(rt_idev);
                          }
@@ -4781,7 +4787,7 @@ void rt6_sync_down_dev(struct net_device *dev, 
unsigned long event)
   void rt6_disable_ip(struct net_device *dev, unsigned long event)
   {
          rt6_sync_down_dev(dev, event);
-       rt6_uncached_list_flush_dev(dev_net(dev), dev);
+       rt6_uncached_list_flush_dev(dev_net(dev), dev, event);
          neigh_ifdown(&nd_tbl, dev);
   }


For reference, here are some samples of the refcounts on the 
inet6_device. In this log we saw the inet6_device had a final refcount 
of 4 while unregistering.
holds                 puts
ip6_rt_copy_init 17   13 ip6_dst_ifdown
xfrm6_fill_dst   6     5 xfrm6_dst_destroy
                        1 rt6_disable_ip
icmp6_dst_alloc  28   25 ip6_dst_destroy
                        3 rt6_disable_ip

Thanks,
Sean
