Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74932F0E75
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfKFFjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:39:39 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42932 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730992AbfKFFjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:39:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id n5so13569992ljc.9
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 21:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=62AgivX23iWkab0RYIvqAQ2RkfOMlxHmtgjdymznHgU=;
        b=WrF9JWuquuAHTArNYUbxvlZVe7ofHtavwkKqCpYIps2XSLtJQ+tvENjcFD9m6UO3Cy
         VyHXEQL/TMHfVhck+AUD6vhr5LCD8YXMN6LMiJlUaewor/arywWCGy+A4irSqVLW7LI1
         Gjp+nlN0O6tGNpc5a2ywVp5t/gQ+zC8YZEC5rAYD2M+ELwoY1BxbUNhWPQUHuR2Paltf
         Y+u4LYnpKEGfA84ANQOWYD8TVOHdpGN7L1R7eoTP2cH8UdpF/MYv+2x95OBvhZt+ySo5
         ny031qz3F5K3D29ntAd01m8YmIvrvOwv/41gaunOaWsEq7LWlI0wS22gLR7a0/8n6ASk
         JoWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62AgivX23iWkab0RYIvqAQ2RkfOMlxHmtgjdymznHgU=;
        b=SC1MMhlKjTGGf8w9wcBIQGP5Q2PqbHHY606pQccJqlFxrT8VsCeFx1LuhesmowBLrU
         godFXiRDQ80y3xMR/V2oDw/xAj5l9GNQIkqn2fiaL540MZ1P+7nYv9CizJLZaVDc5zLZ
         1ebYecEzmdC8Xybg9n6tMkoztCSHUoc1jp9xlrEE25zSb5Lq10Ovj5Gixmnr1YL4R5jO
         ad9qHffDbHpf+2IX1/vcYIoKv9TyQxvmHelICsBfRa4yBxUQkd3uozY+5+fBrhDrY7jn
         Hq2lgNJloZMLMwGl6zIHtvCSYOMBNfJxL7LNSK9BhHaLWW4xprd6BUkINpXuOOI61PXD
         HhwQ==
X-Gm-Message-State: APjAAAX4CCMfWuqZy6kjmGhIsr3JMRAT/ebxvK9duIXUGfj9JVsXAPtX
        d2yA9RGtAmLQNC9cTlDYIO6sXQ==
X-Google-Smtp-Source: APXvYqwrRqMt+MGLMcgpLFKyY0SX1dMfmL4tRQd3hOPgPivQtIzisSOtzJqLMioZtnbGMQJq3Fjnpw==
X-Received: by 2002:a2e:8e21:: with SMTP id r1mr413935ljk.81.1573018773820;
        Tue, 05 Nov 2019 21:39:33 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c22sm754737ljk.43.2019.11.05.21.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:39:33 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v2 4/5] net: ipv4: allow setting address on interface outside current namespace
Date:   Wed,  6 Nov 2019 06:39:22 +0100
Message-Id: <20191106053923.10414-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106053923.10414-1-jonas@norrbonn.se>
References: <20191106053923.10414-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows an interface outside of the current namespace to be
selected when setting a new IPv4 address for a device.  This uses the
IFA_TARGET_NETNSID attribute to select the namespace in which to search
for the interface to act upon.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 net/ipv4/devinet.c | 58 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4b5bd4d2c89..9c9adfc9d94e 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -813,22 +813,17 @@ static void set_ifa_lifetime(struct in_ifaddr *ifa, __u32 valid_lft,
 		ifa->ifa_cstamp = ifa->ifa_tstamp;
 }
 
-static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
+static struct in_ifaddr *rtm_to_ifaddr(struct nlattr* tb[],
+					struct net *net, struct nlmsghdr *nlh,
 				       __u32 *pvalid_lft, __u32 *pprefered_lft,
 				       struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[IFA_MAX+1];
 	struct in_ifaddr *ifa;
 	struct ifaddrmsg *ifm;
 	struct net_device *dev;
 	struct in_device *in_dev;
 	int err;
 
-	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
-				     ifa_ipv4_policy, extack);
-	if (err < 0)
-		goto errout;
-
 	ifm = nlmsg_data(nlh);
 	err = -EINVAL;
 	if (ifm->ifa_prefixlen > 32 || !tb[IFA_LOCAL])
@@ -922,16 +917,37 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	struct net *tgt_net = NULL;
 	struct in_ifaddr *ifa;
 	struct in_ifaddr *ifa_existing;
 	__u32 valid_lft = INFINITY_LIFE_TIME;
 	__u32 prefered_lft = INFINITY_LIFE_TIME;
+	struct nlattr *tb[IFA_MAX+1];
+	int err;
 
 	ASSERT_RTNL();
 
-	ifa = rtm_to_ifaddr(net, nlh, &valid_lft, &prefered_lft, extack);
-	if (IS_ERR(ifa))
-		return PTR_ERR(ifa);
+	err = nlmsg_parse_deprecated(nlh, sizeof(struct ifaddrmsg), tb, IFA_MAX,
+				     ifa_ipv4_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[IFA_TARGET_NETNSID]) {
+		int32_t netnsid = nla_get_s32(tb[IFA_TARGET_NETNSID]);
+
+		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
+		if (IS_ERR(net)) {
+			NL_SET_ERR_MSG(extack, "ipv4: Invalid target network namespace id");
+			return PTR_ERR(net);
+		}
+		net = tgt_net;
+	}
+
+	ifa = rtm_to_ifaddr(tb, net, nlh, &valid_lft, &prefered_lft, extack);
+	if (IS_ERR(ifa)) {
+		err = PTR_ERR(ifa);
+		goto out;
+	}
 
 	ifa_existing = find_matching_ifa(ifa);
 	if (!ifa_existing) {
@@ -945,19 +961,24 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 			if (ret < 0) {
 				inet_free_ifa(ifa);
-				return ret;
+				err = ret;
+				goto out;
 			}
 		}
-		return __inet_insert_ifa(ifa, nlh, NETLINK_CB(skb).portid,
+		err = __inet_insert_ifa(ifa, nlh, NETLINK_CB(skb).portid,
 					 extack);
+		if (err < 0)
+			goto out;
 	} else {
 		u32 new_metric = ifa->ifa_rt_priority;
 
 		inet_free_ifa(ifa);
 
 		if (nlh->nlmsg_flags & NLM_F_EXCL ||
-		    !(nlh->nlmsg_flags & NLM_F_REPLACE))
-			return -EEXIST;
+		    !(nlh->nlmsg_flags & NLM_F_REPLACE)) {
+			err = -EEXIST;
+			goto out;
+		}
 		ifa = ifa_existing;
 
 		if (ifa->ifa_rt_priority != new_metric) {
@@ -971,7 +992,14 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 				&check_lifetime_work, 0);
 		rtmsg_ifa(RTM_NEWADDR, ifa, nlh, NETLINK_CB(skb).portid);
 	}
-	return 0;
+
+	err = 0;
+
+out:
+	if (tgt_net)
+		put_net(tgt_net);
+
+	return err;
 }
 
 /*
-- 
2.20.1

