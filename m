Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0FF0E77
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfKFFjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:39:35 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46497 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfKFFje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:39:34 -0500
Received: by mail-lf1-f67.google.com with SMTP id 19so11844443lft.13
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 21:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Y4vRgLCCst6/pB0O3I9R6t/HFVPS2O+ldq3N0SHJ6Q=;
        b=MvHhyk6etNd4IQPjPN9G/2nEmK3mt3BOu/DJZUm0GrdawOYoCxh3/N0JuF0bW5uFjm
         1fxNyKOpkkrzhDeeLllwFJVnBGefFPJFZVZ5dluOlWpdM34bx5YB1adx3TOMc8Nn49QP
         w3ZQirN5VsP8YvNSuePCB0LtPEotaBJC+NEs/4A94mbwEkyAAhYKIgSG82UM9SMg1+/M
         p5YWgHmyQE3NQYe35aObj4T7Hri0jJ5zykwn6+OroLIElZ2IfwMtA75+Ne59Nz67Ne80
         TzuVgzRtq7RA+aYxoFWgl1wgZ1UxTeyWuH/M/buUAg+B+FemTu5Ftnn9gZHELLZDSn3x
         DNiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Y4vRgLCCst6/pB0O3I9R6t/HFVPS2O+ldq3N0SHJ6Q=;
        b=hez3rV697iagRdLZkrCU+DEYhtwzgNjDyIezn8rtV16rdd/cdN1rr0fQo+4UTdOGAf
         /mmYWqqnv2My0hHOnNvmJX+m+T5gymuk1Y/DhJJe+i2LWjcYiYYsMWb0tB5AFEtr8dXz
         VLnrGHx5oXpCiPVk+3SOmex0iTagmbN6tlTts0+Mu0ARca7htsnow4PHxv9nxPYSL1Rj
         n11ck9sittAqPHR/fXpYb+mkVvFJE9Q4L26MIjxcLh6jWrCbLM03eDB+gfC6FzLP8w3T
         gvfh48rhd0ESiotAP2bSAIKDuIuQtJKfSzC4garo69ivquMEDig5KtdV29ImQIBf4CJh
         AHeA==
X-Gm-Message-State: APjAAAURRui8f0XGwEWNycm9FPAC8xb6k6XMhVBlNO1sc460q5t/LhZL
        kICYxYr1j2dXZ/nm2319qDibLQ==
X-Google-Smtp-Source: APXvYqxjh1O2nWeFW5IKa1oMLy7wWDIMODJotp4kvsyBqXfo0uCJdW3qTPrcNtuh+aN6eb8Jy6bGSA==
X-Received: by 2002:a19:6a03:: with SMTP id u3mr21258664lfu.190.1573018772372;
        Tue, 05 Nov 2019 21:39:32 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c22sm754737ljk.43.2019.11.05.21.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:39:31 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v2 3/5] rtnetlink: allow RTM_NEWLINK to act upon interfaces in arbitrary namespaces
Date:   Wed,  6 Nov 2019 06:39:21 +0100
Message-Id: <20191106053923.10414-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106053923.10414-1-jonas@norrbonn.se>
References: <20191106053923.10414-1-jonas@norrbonn.se>
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
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
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

