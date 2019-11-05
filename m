Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B120FEF6F8
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbfKEILa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:11:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39826 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388209AbfKEIL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:11:29 -0500
Received: by mail-lj1-f195.google.com with SMTP id y3so20717275ljj.6
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=klqYmbmczEVGhdehfFQKE4TvhoA0pT6skr6PYOhJbqI=;
        b=LPY1AHEwlcHdYgDKUWe17uYwR42b71se7FU//Fu2JZLH0VgnIMExoMfoBsjWPNliRw
         peKHrPkoOsV2apKpyp+vwTzV07iNjrC69ZLL8Umg8ZqjwkITG0udRorhFz4Qs0DMcLtP
         YxqrzNqFrIFVjXityA2BQF5TxQ7rAdhA85P0Ej9IRoHiRKnRgrLmaQfAwkEL3mkvjy9f
         lwHsSziuH2lFFvKnP00lgt8nBGF2KIkLotpSwK4KWKNEC67uShov1LjRrjTI2tESXTjh
         HeiRI0ir6pXlJx/eycGkH1LDsFL4iQKdf+DPmBOXsm5P4+fJ13EwlI+ARzFsxAmlUG6n
         eGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=klqYmbmczEVGhdehfFQKE4TvhoA0pT6skr6PYOhJbqI=;
        b=FEEvlUBhDd5NULkffoM0w/DCDWAqjlm3WGXiVi7isJhxp3QnVhSSxGScbF84ehEO+O
         otRH32yd/7GPOuxgbs/dtcCFaNdtG0gOrqpaaFb5NEFA13pqYyImpH9aCGeT4qa4NOd+
         XgedH06vPBmB45qEePEpN46Edu/89422S3aB8nKeqzRr/Wikt7IobFRJu3UqFXuAVMAt
         N9P3l9TWGcro4KnoG3rGYSsluQ1TWb9BXr9i/lr3L2vETbi2cTEJW0ohZay7+f1Vkeaa
         SkJ0hrRGHY9kUdZh3P5IWcR+CfaeDup939/oGwC87GNgrOQ7GrlkJFXVMEPP+0d0D1en
         L3GQ==
X-Gm-Message-State: APjAAAULihiWZqDfQZjCaFE1ESvBlbZitpLNjtKN6heG3L0h29l8crc8
        WDa5aWTHCxpXwHI6ZQ+xK4vQhg==
X-Google-Smtp-Source: APXvYqwHD9dETU8I5NKAVmB0IkOeCI4/N4jQKFGbiVOjLDYEVkQClmBrpHRVoBjfVYOlB4BuBFXdfw==
X-Received: by 2002:a2e:9194:: with SMTP id f20mr10589861ljg.154.1572941486981;
        Tue, 05 Nov 2019 00:11:26 -0800 (PST)
Received: from mimer.lulea.netrounds.lan ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id m7sm7275986lfp.22.2019.11.05.00.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:11:26 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 3/5] rtnetlink: allow RTM_NEWLINK to act upon interfaces in arbitrary namespaces
Date:   Tue,  5 Nov 2019 09:11:10 +0100
Message-Id: <20191105081112.16656-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105081112.16656-1-jonas@norrbonn.se>
References: <20191105081112.16656-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTM_NEWLINK can be used mostly interchangeably with RTM_SETLINK for
modifying device configuration.  As such, this method requires the same
logic as RTM_SETLINK for finding the device to act on.

With this patch, the IFLA_TARGET_NETNSID selects the namespace in which
to search for the interface to act upon.  This allows, for example, to
set the namespace of an interface outside the current namespace by
selecting it with the (IFLA_TARGET_NETNSID,ifi->ifi_index) pair and
specifying the namespace with one of IFLA_NET_NS_[PID|FD].

Since rtnl_newlink branches off into do_setlink, we need to provide the
same backwards compatibility check as we do for RTM_SETLINK:  if the
device is not found in the namespace given by IFLA_TARGET_NETNSID then
we search for it in the current namespace.  If found there, it's
namespace will be changed, as before.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 net/core/rtnetlink.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a6ec1b4ff7cd..3aba9e9d2c32 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3019,6 +3019,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	const struct rtnl_link_ops *m_ops = NULL;
 	struct net_device *master_dev = NULL;
 	struct net *net = sock_net(skb->sk);
+	struct net *tgt_net = NULL;
 	const struct rtnl_link_ops *ops;
 	struct nlattr *tb[IFLA_MAX + 1];
 	struct net *dest_net, *link_net;
@@ -3047,6 +3048,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		ifname[0] = '\0';
 
+	if (tb[IFLA_TARGET_NETNSID]) {
+		int32_t netnsid;
+		netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
+		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
+		if (IS_ERR(tgt_net))
+			return PTR_ERR(tgt_net);
+		net = tgt_net;
+	}
+
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
@@ -3057,6 +3067,23 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			dev = NULL;
 	}
 
+	/* A hack to preserve kernel<->userspace interface.
+	 * It was previously allowed to pass the IFLA_TARGET_NETNSID
+	 * attribute as a way to _set_ the network namespace.  In this
+	 * case, the device interface was assumed to be in the  _current_
+	 * namespace.
+	 * If the device cannot be found in the target namespace then we
+	 * assume that the request is to set the device in the current
+	 * namespace and thus we attempt to find the device there.
+	 */
+	if (!dev && tgt_net) {
+		net = sock_net(skb->sk);
+		if (ifm->ifi_index > 0)
+			dev = __dev_get_by_index(net, ifm->ifi_index);
+		else if (tb[IFLA_IFNAME])
+			dev = __dev_get_by_name(net, ifname);
+	}
+
 	if (dev) {
 		master_dev = netdev_master_upper_dev_get(dev);
 		if (master_dev)
@@ -3251,6 +3278,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto out_unregister;
 	}
 out:
+	if (tgt_net)
+		put_net(tgt_net);
 	if (link_net)
 		put_net(link_net);
 	put_net(dest_net);
-- 
2.20.1

