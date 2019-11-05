Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D18EF6FA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbfKEILo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:11:44 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33563 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388228AbfKEILa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:11:30 -0500
Received: by mail-lj1-f196.google.com with SMTP id t5so20730976ljk.0
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JtZli8T/5qgvjqfbtGkN60omtz/hTR9rSjR6Y0rKHM=;
        b=CJVbbECj6aGGg+hIEEbocCgkrdm3AsQikzYGksyN7i+sRa0JA1gHmPanR+8G/jHFed
         MvZZlYzB53BSiaFvsEzagYf1Zyks6Z4u+sNNfl5OvKx11lvVTHM33SfwyEdoXkyRTYqP
         XjSAgtoBmvGeYTOhVQLwXOmJ3Psj7gcnJmIJ1Cw6EaSqzn0ZLef6GAB+8KrZRPQ5mfUP
         DRXAflKYdwl3//Qvvbe15+bbr8ogA0F4zPjQFsxtNxFRSevE8+dVYuzUDXUpKIoyrrM9
         nLmqFizdZiStkfHqo4nRGDT85qI0ZNdpaGadP8TN8QT2le0ZP2ZlMMYfMFzvfZUq4R6i
         D56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JtZli8T/5qgvjqfbtGkN60omtz/hTR9rSjR6Y0rKHM=;
        b=NLwk23KLE0YZvkhYCf20DA1kSECnGiRoVVezFFPrd8seS/cDPBCSliW6MRPTE8T+Ou
         dsF566JnU5agvuaPMl5ggTtKEMroCTBnFhZm/PJ0ql54+ePkEASW5i7lZGqS2wPDC5t8
         rQqLIPYkgw9sL+eRXoFM4RlOVDTscd1W49f5ugC3eblA/Qh5bUR1iTkgu1CbYWOz7Dys
         Dck7dbKvg43hhvW8UkJWR5/dQ8Cr5f0WaYfNkaYMlAoLjD9aHwtRA4WOqoXFDUzs2fuZ
         jmPOff0RBkzcDfM+wW95ul+Av9zdllnXDBQ9mHJuyF8iLxlit0dioEPrD4t2l3z0MI1V
         Nq6Q==
X-Gm-Message-State: APjAAAUa4TfXLnxvGGMRMu2kmHsLEchNY4FZ36+aM0Em5QKJXl3kktj0
        xvLkK9Owtu3fBgUiKFA/usY5dnPT1n4=
X-Google-Smtp-Source: APXvYqwz+EmUOpdm0CS5RAurWJx0lENtb4ciG3VnxkE+bHHGopgI9a7R34AyduqQQ2JtEwEUJapT0w==
X-Received: by 2002:a05:651c:10e:: with SMTP id a14mr21359869ljb.177.1572941488657;
        Tue, 05 Nov 2019 00:11:28 -0800 (PST)
Received: from mimer.lulea.netrounds.lan ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id m7sm7275986lfp.22.2019.11.05.00.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:11:28 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 4/5] net: ipv4: allow setting address on interface outside current namespace
Date:   Tue,  5 Nov 2019 09:11:11 +0100
Message-Id: <20191105081112.16656-5-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105081112.16656-1-jonas@norrbonn.se>
References: <20191105081112.16656-1-jonas@norrbonn.se>
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
 net/ipv4/devinet.c | 56 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a4b5bd4d2c89..459fb39b4a56 100644
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
@@ -945,10 +961,11 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
 	} else {
 		u32 new_metric = ifa->ifa_rt_priority;
@@ -956,8 +973,10 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -971,7 +990,14 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
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

