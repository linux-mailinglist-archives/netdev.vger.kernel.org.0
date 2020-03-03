Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A50176F8C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCCGhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:37:54 -0500
Received: from mail-qk1-f175.google.com ([209.85.222.175]:46852 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCCGhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:37:54 -0500
Received: by mail-qk1-f175.google.com with SMTP id u124so2299681qkh.13
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 22:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lGc3Egs9/TeIivSWVOX77ZuJYPBuiBATwcZLr/jqM9E=;
        b=u6uyKIeA/OasY2Lzg9aL5khgq0+7mXxO7Vlp7/TOtl2HesalcC50ef7B+FnB0wd2XS
         fYf1INvXBkpRVf4gk8fvMLhkBK8A7QozFSsmqsYMAhZlUmIy1fUpD+Qotxg7VkKFd5V7
         DbOds6rqVPaqHHZ0zAXoE73Bh5OdRdPEoaNTzJb5DMKu0QmEm5cRz3jcK1bd7R60AI9U
         vq51xTqQ76sIShRs3GYpDe/j+2eV9UH4MDV9zStbUtjMJcschgnfwaz8kAAKErQW3jFt
         pb9NQ0akH512PH0kyriZUGNbqIjFkpkjJgMDwIYTfaxtruta57jrM0LxfZBKJnJUK6TT
         qaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGc3Egs9/TeIivSWVOX77ZuJYPBuiBATwcZLr/jqM9E=;
        b=o+ESI29uKIKe8T57hNJz2g8XaE21TN4yeXaZx0NvXBZSA1qWJxNX2Sr+PCbuHk9rzn
         vjNMzPGCOIPKzy5i15S3MLtVAyNrgyUsM7/NJ586mUxP6xRoSubON4W/+z/hxClAATCN
         2/kjhlSN7Lo0Av/nEMTDrr9E+dDl0tGUPOmvtAaYi7kwDBVKUtt+Tr7WhvAy8tW/QdQV
         RUxawHnSafYDAFIe4lGI/1m3/FjWI5l5EWtav7AyJ+rylCxJ9QIFlja3Qx7pB+UYPO2e
         7B4E/mTllXQzm+6eJ7fLtiLxz8Pnfdrg+ZyMtV73ivtFARmDj5B2svsxu8vvg6OGBo/3
         fFgg==
X-Gm-Message-State: ANhLgQ2EmCqggezmijKMZd27tx7W61BYqy2fBcPzvmF+RLbOETLlW9uk
        7FE4+7sylnZCc/QuVTodbyck8lifAg0=
X-Google-Smtp-Source: ADFU+vtED9MUwp415fJOPyBGmgV565mux/Lo0t6mpXYW2j7FU5YvI+ZhzKgWOGpZzoPcsn5oBTjUtQ==
X-Received: by 2002:a37:6e06:: with SMTP id j6mr2771690qkc.171.1583217471503;
        Mon, 02 Mar 2020 22:37:51 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm3599929qto.56.2020.03.02.22.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 22:37:51 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/3] net/ipv6: need update peer route when modify metric
Date:   Tue,  3 Mar 2020 14:37:34 +0800
Message-Id: <20200303063736.4904-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303063736.4904-1-liuhangbin@gmail.com>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we modify the route metric, the peer address's route need also
be updated. Before the fix:

+ ip addr add dev dummy1 2001:db8::1 peer 2001:db8::2 metric 60
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 60 pref medium
2001:db8::2 proto kernel metric 60 pref medium
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::2 metric 61
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 61 pref medium
2001:db8::2 proto kernel metric 60 pref medium

After the fix:
+ ip addr change dev dummy1 2001:db8::1 peer 2001:db8::2 metric 61
+ ip -6 route show dev dummy1
2001:db8::1 proto kernel metric 61 pref medium
2001:db8::2 proto kernel metric 61 pref medium

Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 164c71c54b5c..4fb72028ca45 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4586,12 +4586,14 @@ inet6_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int modify_prefix_route(struct inet6_ifaddr *ifp,
-			       unsigned long expires, u32 flags)
+			       unsigned long expires, u32 flags,
+			       bool modify_peer)
 {
 	struct fib6_info *f6i;
 	u32 prio;
 
-	f6i = addrconf_get_prefix_route(&ifp->addr, ifp->prefix_len,
+	f6i = addrconf_get_prefix_route(modify_peer ? &ifp->peer_addr : &ifp->addr,
+					ifp->prefix_len,
 					ifp->idev->dev, 0, RTF_DEFAULT, true);
 	if (!f6i)
 		return -ENOENT;
@@ -4602,7 +4604,8 @@ static int modify_prefix_route(struct inet6_ifaddr *ifp,
 		ip6_del_rt(dev_net(ifp->idev->dev), f6i);
 
 		/* add new one */
-		addrconf_prefix_route(&ifp->addr, ifp->prefix_len,
+		addrconf_prefix_route(modify_peer ? &ifp->peer_addr : &ifp->addr,
+				      ifp->prefix_len,
 				      ifp->rt_priority, ifp->idev->dev,
 				      expires, flags, GFP_KERNEL);
 	} else {
@@ -4678,7 +4681,7 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 		int rc = -ENOENT;
 
 		if (had_prefixroute)
-			rc = modify_prefix_route(ifp, expires, flags);
+			rc = modify_prefix_route(ifp, expires, flags, false);
 
 		/* prefix route could have been deleted; if so restore it */
 		if (rc == -ENOENT) {
@@ -4686,6 +4689,15 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 					      ifp->rt_priority, ifp->idev->dev,
 					      expires, flags, GFP_KERNEL);
 		}
+
+		if (had_prefixroute && !ipv6_addr_any(&ifp->peer_addr))
+			rc = modify_prefix_route(ifp, expires, flags, true);
+
+		if (rc == -ENOENT && !ipv6_addr_any(&ifp->peer_addr)) {
+			addrconf_prefix_route(&ifp->peer_addr, ifp->prefix_len,
+					      ifp->rt_priority, ifp->idev->dev,
+					      expires, flags, GFP_KERNEL);
+		}
 	} else if (had_prefixroute) {
 		enum cleanup_prefix_rt_t action;
 		unsigned long rt_expires;
-- 
2.19.2

