Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983D7F2F49
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389068AbfKGN2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:28:07 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37048 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389040AbfKGN2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:28:06 -0500
Received: by mail-lj1-f193.google.com with SMTP id l20so2276010lje.4
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=40B2Zn2Vh8quTHaXoUrYBWwbsEUJYUqvqRevZ1/Cbtg=;
        b=yTnr9GzwAmtrT3FypoDLtM77E5ZGvMIEGEA4pDCzlAb2QCnz7SvFAf6i8/kPX6DXkA
         v5WoApRqKL/LKbicI6Dtuq7cHcZWii1Gj6hPHQv67fUeYyaEixQKlUnB1SsP/mVU2t/R
         hubAcvty8aPMeCwQOU0roAwhRqJX6hehAWK6ZoV04ku6O1rz6DqjozHy+TkZvbLaz9bM
         sRTKxGNZBjqDY8wWGu9SEEHN6UCm6fTj4pSoiRjrgD6MpmOpfXduUh3NGzekVs+p+MLg
         yg8GnJ6KJIonIE9stMp8KTpnYSGMPJOI8z0AWuIfm3SsJuVtLofsq78JGVIu3phYIKqy
         GHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40B2Zn2Vh8quTHaXoUrYBWwbsEUJYUqvqRevZ1/Cbtg=;
        b=Q4awsqyoCiHst/z9F1Vn0pV+YXq1HP15tuWreIxgFgllpRH4YmYoyZKCz70TEYgGk4
         rito4pYbGZYQSXxoXdOe+QnFHAzTPTV9c6eDqUAgbCbUuFHRgO1caPqsdRpgw9oQdERW
         G9MNvg/6RVbdAoy4BAYjeIFuDfguf/yiltV+BslWOSbbI9QAEYBNhDT5jteXWM1Hqh+/
         v2+FRshiLXobINdfq3uVyfPUGbsU07QP4wztYKFAmwxqFSFCVNfPSzMnHIV+Rxc0vNT8
         olav38W7CcagdZ2+S1vjEB16274z07BlnIT75Rygl/+uCu49Jpx4KkHHYW55wt0k+/XX
         y0mQ==
X-Gm-Message-State: APjAAAUSu4w/5yvLQwiZMWhNRi7qkfVWMJUcUZSSiPvEih8SCtKaGWfD
        KLKEiwD/mMm7MlEgNF+tUvzWLA==
X-Google-Smtp-Source: APXvYqxptWQiJ6c22NPMOCLPEfahYPLDjhRJVXNYrDQr7bhMA6GXv0HYeEv2xfXyPfWv8U6IxF6dAw==
X-Received: by 2002:a2e:22c1:: with SMTP id i184mr2542820lji.1.1573133283717;
        Thu, 07 Nov 2019 05:28:03 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id y20sm3151507ljd.99.2019.11.07.05.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:28:03 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v3 4/6] net: ipv4: allow setting address on interface outside current namespace
Date:   Thu,  7 Nov 2019 14:27:53 +0100
Message-Id: <20191107132755.8517-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107132755.8517-1-jonas@norrbonn.se>
References: <20191107132755.8517-1-jonas@norrbonn.se>
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
 net/ipv4/devinet.c | 61 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4b5bd4d2c89..eecd1b0bb7d2 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -813,22 +813,17 @@ static void set_ifa_lifetime(struct in_ifaddr *ifa, __u32 valid_lft,
 		ifa->ifa_cstamp = ifa->ifa_tstamp;
 }
 
-static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
+static struct in_ifaddr *rtm_to_ifaddr(struct nlattr *tb[],
+				       struct net *net, struct nlmsghdr *nlh,
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
@@ -922,16 +917,38 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	struct net *tgt_net = NULL;
 	struct in_ifaddr *ifa;
 	struct in_ifaddr *ifa_existing;
 	__u32 valid_lft = INFINITY_LIFE_TIME;
 	__u32 prefered_lft = INFINITY_LIFE_TIME;
+	struct nlattr *tb[IFA_MAX + 1];
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
+		s32 netnsid = nla_get_s32(tb[IFA_TARGET_NETNSID]);
+
+		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
+		if (IS_ERR(tgt_net)) {
+			NL_SET_ERR_MSG(extack,
+				"ipv4: Invalid target network namespace id");
+			return PTR_ERR(tgt_net);
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
@@ -945,19 +962,24 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 			if (ret < 0) {
 				inet_free_ifa(ifa);
-				return ret;
+				err = ret;
+				goto out;
 			}
 		}
-		return __inet_insert_ifa(ifa, nlh, NETLINK_CB(skb).portid,
-					 extack);
+		err = __inet_insert_ifa(ifa, nlh, NETLINK_CB(skb).portid,
+					extack);
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
@@ -971,7 +993,14 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
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

