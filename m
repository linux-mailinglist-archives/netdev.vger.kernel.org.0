Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA34AF30B0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbfKGN46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:56:58 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39470 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731034AbfKGN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:56:58 -0500
Received: by mail-lj1-f193.google.com with SMTP id p18so2381097ljc.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1TX8xaGatMSdm2p99RnjVc360czbsJGz8WZJSaymf6M=;
        b=O8zbOeVrfelqXQlVZ2eNw0YwlQmFt60dOpoM90BkVxQyTr1f3PwwWOzMfp0wKsaIKh
         uWDM1Ug5Dj8FV9k7EVgZ+ii7+cI4M6eDav8lGkSuLUgqKiUI8gAAn96cdKA2Wc17Fa1K
         Tqfmt1Nc8yBcIH2iTGK3/rEyLVB3FffRAsW/SIXC/MQGznKxluoPqZYHnA7R3+xlWbbZ
         WsuNEFnlaGquzh3rDdMtLQHVXsr6HmqrxDbuolCI+aN2VRbHL7DkjlrgR6Eg5UENanWq
         RZQehUOEkOZ74/wLWBOmlkVLYCL/VJ4S9hmpdkPMKKpRRLuvCejLgbSSu0QH+xkr7Ful
         ioLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1TX8xaGatMSdm2p99RnjVc360czbsJGz8WZJSaymf6M=;
        b=dYTBpCFkqn3HlAz2KJno7uuP4tYv4y8PkBPhTeeseEVrhltii8cvncpwMQbPgXUi28
         A4Cr9TIx1tFpV5ilgX0soKPtWAflntLi7CvaFIdB451AimGotMyq423Vc5DSavoBXxnP
         9WF8+ojQRaJ3c+bRIr4KLjQ5e0e+2Ty9vpj5ogGYQhmjX51UcnjktEtq80W8AGcNAW9B
         dFKrqt9pAg7c1h9NHNFGG+NG+rQaSDIgtTyy4Pm7g6NWXLFEPPoV0P+7sgy/VKlWStVe
         oF0bWbVJdSjnuKVypptOoY642iG0YCVFnhvbfeMorz1RuuWOMnDmDMZlpk8D0w8L98zT
         8aLg==
X-Gm-Message-State: APjAAAXAfpeJOYZEIM39xCgEWg/KB32ZjieLulhtednho9gYHJ0eB1ai
        2Z/ezYlUBbjpfxTZXUyxB6HWKtMSBG4=
X-Google-Smtp-Source: APXvYqyMKPS774EcbAo4n0fAANdSNbQkO1urhD95juhkYsbV8+CQRunljHHD9uEEpe58+Xrrcfkj0w==
X-Received: by 2002:a2e:88c9:: with SMTP id a9mr2393868ljk.30.1573135016509;
        Thu, 07 Nov 2019 05:56:56 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id v6sm1067697ljd.15.2019.11.07.05.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:56:55 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v3 1/1] net: ipv6: allow setting address on interface outside current namespace
Date:   Thu,  7 Nov 2019 14:56:52 +0100
Message-Id: <20191107135652.19629-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107132755.8517-7-jonas@norrbonn.se>
References: <20191107132755.8517-7-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows an interface outside of the current namespace to be
selected when setting a new IPv6 address for a device.  This uses the
IFA_TARGET_NETNSID attribute to select the namespace in which to search
for the interface to act upon.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---

I messed up this patch and the cleanup code path wasn't included.  It
should look like this.  Sorry for the noise.

/Jonas

 net/ipv6/addrconf.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 34ccef18b40e..8ef8297db150 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4721,6 +4721,7 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		  struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	struct net *tgt_net = NULL;
 	struct ifaddrmsg *ifm;
 	struct nlattr *tb[IFA_MAX+1];
 	struct in6_addr *peer_pfx;
@@ -4758,9 +4759,23 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		cfg.preferred_lft = ci->ifa_prefered;
 	}
 
+	if (tb[IFA_TARGET_NETNSID]) {
+		s32 netnsid = nla_get_s32(tb[IFA_TARGET_NETNSID]);
+
+		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
+		if (IS_ERR(tgt_net)) {
+			NL_SET_ERR_MSG(extack,
+				"ipv6: Invalid target network namespace id");
+			return PTR_ERR(tgt_net);
+		}
+		net = tgt_net;
+	}
+
 	dev =  __dev_get_by_index(net, ifm->ifa_index);
-	if (!dev)
-		return -ENODEV;
+	if (!dev) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	if (tb[IFA_FLAGS])
 		cfg.ifa_flags = nla_get_u32(tb[IFA_FLAGS]);
@@ -4773,8 +4788,10 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 IFA_F_MCAUTOJOIN | IFA_F_OPTIMISTIC;
 
 	idev = ipv6_find_idev(dev);
-	if (IS_ERR(idev))
-		return PTR_ERR(idev);
+	if (IS_ERR(idev)) {
+		err = PTR_ERR(idev);
+		goto out;
+	}
 
 	if (!ipv6_allow_optimistic_dad(net, idev))
 		cfg.ifa_flags &= ~IFA_F_OPTIMISTIC;
@@ -4782,7 +4799,8 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (cfg.ifa_flags & IFA_F_NODAD &&
 	    cfg.ifa_flags & IFA_F_OPTIMISTIC) {
 		NL_SET_ERR_MSG(extack, "IFA_F_NODAD and IFA_F_OPTIMISTIC are mutually exclusive");
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	ifa = ipv6_get_ifaddr(net, cfg.pfx, dev, 1);
@@ -4791,7 +4809,8 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		 * It would be best to check for !NLM_F_CREATE here but
 		 * userspace already relies on not having to provide this.
 		 */
-		return inet6_addr_add(net, ifm->ifa_index, &cfg, extack);
+		err = inet6_addr_add(net, ifm->ifa_index, &cfg, extack);
+		goto out;
 	}
 
 	if (nlh->nlmsg_flags & NLM_F_EXCL ||
@@ -4802,6 +4821,9 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	in6_ifa_put(ifa);
 
+out:
+	if (tgt_net)
+		put_net(tgt_net);
 	return err;
 }
 
-- 
2.20.1

