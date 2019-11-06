Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696C9F0E79
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfKFFjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:39:33 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40742 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfKFFjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:39:33 -0500
Received: by mail-lf1-f67.google.com with SMTP id f4so17005859lfk.7
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 21:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wSwx/i+WwwJmrxYKeVfTDBu2PjF/3pT9RRbXzXS9QpQ=;
        b=CqoVZz9DoKI6YVD+iEAh07hY4rk1ayREQJjsFaxixnTFGphXQlI/+kVU+WWIydnOCH
         4kIiloNskrK0S0AB69/9bgDJmUnc+vbN8r2C6m5P9Hbq7Nid4Iwbjvr3Xcc6ue9VFuR9
         il9LZUVWLOM8HjitHH+4hrGYeUqTTBQduHLh6Yvbv3jDPb+49fIUFhuomE3mFqs2aauq
         +cxfybObqYiqhm3HitYgfuRA7Wcqh6csgojfZhQBV9sDJ1CdSZV83QhM+/+sbOE7Afxg
         /y9EzgTuPBpyYDSTpwqRCRBqvXiHSWewAFNfb0AbEWsH1Voxf++Ii2bWVts76RVeCJDM
         48tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSwx/i+WwwJmrxYKeVfTDBu2PjF/3pT9RRbXzXS9QpQ=;
        b=lKseAcDukQI5Esv5iDBY8Dcm32jeU9LHX3mtqHHASmtvnCAiq9ANyxYbHE5f/FdzVm
         gHJ+zUfeN0dcm6NApJUP9gpoeTYpAmQjvInrjNI6lcDc4iPPeo7rbYpWjT7+Yg1Gb420
         EpOreKVVQJLrjllou5VxvX78AnC1d1XfzHTuUD3ODOIwGlFKpEuY8RlwRbT/JFM34kHt
         P5EXDqMwDGXdMHSUNQR+Vf8AEP680gkKYJkCzjgvUpMrXcngH9eg3yNYPX6Kbtqvu1XR
         2svif2ZfL0IQNjVsyWac40abRmF/zU/wLerbdFpX98wGgaoLvOUGIgqnHW87HsKjnsQ5
         XCEg==
X-Gm-Message-State: APjAAAUP4STwX5ACKidGTfngvBGbxgHdvhuDkv3U1/0C6SxyEucf+NuL
        d35AFZo7B3sLDE0WoAOmiPuB4w==
X-Google-Smtp-Source: APXvYqxrxYh7ALbOJl5NC5UPeYNm1YTYUIpYWIPlpu9hqzrlt6pcpvjF05r3XVQ1GlNbHDWiVUnYNQ==
X-Received: by 2002:a19:c354:: with SMTP id t81mr8985047lff.179.1573018768876;
        Tue, 05 Nov 2019 21:39:28 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c22sm754737ljk.43.2019.11.05.21.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:39:28 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v2 1/5] rtnetlink: allow RTM_SETLINK to reference other namespaces
Date:   Wed,  6 Nov 2019 06:39:19 +0100
Message-Id: <20191106053923.10414-2-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106053923.10414-1-jonas@norrbonn.se>
References: <20191106053923.10414-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink currently has partial support for acting on interfaces outside
the current namespace.  This patch extends RTM_SETLINK with this
functionality.

The current implementation has an unfortunate semantic ambiguity in the
IFLA_TARGET_NETNSID attribute.  For setting the interface namespace, one
may pass the IFLA_TARGET_NETNSID attribute with the namespace to move the
interface to.  This conflicts with the meaning of this attribute for all
other methods where IFLA_TARGET_NETNSID identifies the namespace in
which to search for the interface to act upon:  the pair (namespace,
ifindex) is generally given by (IFLA_TARGET_NETNSID, ifi->ifi_index).

In order to change the namespace of an interface outside the current
namespace, we would need to specify both an IFLA_TARGET_NETNSID
attribute and a namespace to move to using IFLA_NET_NS_[PID|FD].  This is
currently now allowed as only one of these three flags may be specified.

This patch loosens the restrictions a bit but tries to maintain
compatibility with the previous behaviour:
i)  IFLA_TARGET_NETNSID may be passed together with one of
IFLA_NET_NS_[PID|FD]
ii)  IFLA_TARGET_NETNSID is primarily defined to be the namespace in
which to find the interface to act upon
iii)  In order to maintain backwards compatibility, if the device is not
found in the specified namespace, we also look for it in the current
namespace
iv)  If only IFLA_TARGET_NETNSID is given, the device is still moved to
that namespace, as before; and, as before, IFLA_NET_NS_[PID|FD] take
precedence as namespace selectors

Ideally, IFLA_TARGET_NETNSID would only ever have been used to select the
namespace of the device to act upon.  A separate flag, IFLA_NET_NS_ID
would have been made available for changing namespaces

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/rtnetlink.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..269d1afefceb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2109,13 +2109,7 @@ static int rtnl_ensure_unique_netns(struct nlattr *tb[],
 		return -EOPNOTSUPP;
 	}
 
-	if (tb[IFLA_TARGET_NETNSID] && (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD]))
-		goto invalid_attr;
-
-	if (tb[IFLA_NET_NS_PID] && (tb[IFLA_TARGET_NETNSID] || tb[IFLA_NET_NS_FD]))
-		goto invalid_attr;
-
-	if (tb[IFLA_NET_NS_FD] && (tb[IFLA_TARGET_NETNSID] || tb[IFLA_NET_NS_PID]))
+	if (tb[IFLA_NET_NS_PID] && tb[IFLA_NET_NS_FD])
 		goto invalid_attr;
 
 	return 0;
@@ -2726,6 +2720,7 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(skb->sk);
+	struct net *tgt_net = NULL;
 	struct ifinfomsg *ifm;
 	struct net_device *dev;
 	int err;
@@ -2741,6 +2736,14 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		goto errout;
 
+	if (tb[IFLA_TARGET_NETNSID]) {
+		int32_t netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
+		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
+		if (IS_ERR(net))
+			return PTR_ERR(net);
+		net = tgt_net;
+	}
+
 	if (tb[IFLA_IFNAME])
 		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
@@ -2755,6 +2758,23 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		goto errout;
 
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
 	if (dev == NULL) {
 		err = -ENODEV;
 		goto errout;
@@ -2762,6 +2782,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = do_setlink(skb, dev, ifm, extack, tb, ifname, 0);
 errout:
+	if (tgt_net)
+		put_net(tgt_net);
 	return err;
 }
 
-- 
2.20.1

