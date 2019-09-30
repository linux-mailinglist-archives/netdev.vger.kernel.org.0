Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B666EC1E69
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbfI3Jse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50264 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbfI3Jsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so12623118wmg.0
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f8rZTVjaaec8t7RV3d8ECYfmQI75rdG94Qh5vZ7OeXA=;
        b=kiuG9daVQunt8MKwFD0BAyXbApDEdU0dc7RpXDR25vIhsa3kNfGL1u/pQurvcY7uMf
         XQEKLL/+NLvxiWoKmNx5ulZG09rgH4kq61CFdWQawU6dN/P8U+6h/mNwuixxg+b23hee
         sRsIiarJZAY0gVoH2tkiCa5Rv4GaLod98VI/JaBheRehg/A0pJq4GOGZcrvWFVa7SMo3
         BbR3SXPaArmE1FHSxGaiC6M+0l8vlbko+GGhggmbeDEuhWA4lqKLck+H1LR0kYYhre0P
         /rin/GuRAxzbBPSOwpLdSccqfnmkv3br4oTwK1MD0MM4T9Ra0SwEhpcWpPQjVdd2vTb7
         1ZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f8rZTVjaaec8t7RV3d8ECYfmQI75rdG94Qh5vZ7OeXA=;
        b=rjBUPphZsGVhjRjQqIjRNdjfnXsebrbMF63h8Faz27w+ec/oh9GY49ZICBJ9pZvQZV
         k5JnmhgQELxD67kGNmVDUHnAm9Q6EOzeeIjGa1MOFlwyoFzyhzzqJ7vMw11dIxtWIWst
         RWSImzGR8OIxz8zYPKyk/EQ5ETpT+EjBnmGPoNs8J1IVfhj/WjcCDq9dff+vU+m+b9Zw
         Ph3MrT8J+3F2IpSG4GiZha+3pbUxfVg3ayG+ONojqzWepP+vITPHubzAUTLRSZWXY604
         Akr24Fj4tAx7tgSXI0Ai7gMT3cWd0BEoKoQfV8UTA/r2TzcC/dHhCAmmPY3nB2HSLZ/G
         O7Bw==
X-Gm-Message-State: APjAAAXnO+lqBATmDk4lFrzuaf29tCvRNEOAnk2vwoS0IgT5AyLZZ4io
        69gcOiJxIfsEdmWEHrqt+OLtJ8fCr7U=
X-Google-Smtp-Source: APXvYqz+uJfiZC/erGKCPm2HUehONzh7sUfHnktP4yItWL/Zxz+HVSjreKW3Td+UtpYN4aPwKFIYGQ==
X-Received: by 2002:a1c:cbcc:: with SMTP id b195mr17553433wmg.80.1569836908729;
        Mon, 30 Sep 2019 02:48:28 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id a14sm17024152wmm.44.2019.09.30.02.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 7/7] net: rtnetlink: add possibility to use alternative names as message handle
Date:   Mon, 30 Sep 2019 11:48:20 +0200
Message-Id: <20190930094820.11281-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend the basic rtnetlink commands to use alternative interface names
as a handle instead of ifindex and ifname.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
rfc->v1:
- rebased on top of changes in the previous patches
---
 net/core/rtnetlink.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 77d4719e5be0..49fa910b58af 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2780,14 +2780,17 @@ static int do_setlink(const struct sk_buff *skb,
 
 static struct net_device *rtnl_dev_get(struct net *net,
 				       struct nlattr *ifname_attr,
+				       struct nlattr *altifname_attr,
 				       char *ifname)
 {
-	char buffer[IFNAMSIZ];
+	char buffer[ALTIFNAMSIZ];
 
 	if (!ifname) {
 		ifname = buffer;
 		if (ifname_attr)
 			nla_strlcpy(ifname, ifname_attr, IFNAMSIZ);
+		else if (altifname_attr)
+			nla_strlcpy(ifname, altifname_attr, ALTIFNAMSIZ);
 		else
 			return NULL;
 	}
@@ -2823,8 +2826,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(net, NULL, ifname);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
 	else
 		goto errout;
 
@@ -2921,8 +2924,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME],
+				   tb[IFLA_ALT_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
 	else
@@ -3093,8 +3097,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(net, NULL, ifname);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
 	else
 		dev = NULL;
 
@@ -3358,6 +3362,7 @@ static int rtnl_valid_getlink_req(struct sk_buff *skb,
 
 		switch (i) {
 		case IFLA_IFNAME:
+		case IFLA_ALT_IFNAME:
 		case IFLA_EXT_MASK:
 		case IFLA_TARGET_NETNSID:
 			break;
@@ -3405,8 +3410,9 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME], NULL);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(tgt_net, tb[IFLA_IFNAME],
+				   tb[IFLA_ALT_IFNAME], NULL);
 	else
 		goto out;
 
@@ -3491,8 +3497,9 @@ static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(net, tb[IFLA_IFNAME], NULL);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(net, tb[IFLA_IFNAME],
+				   tb[IFLA_ALT_IFNAME], NULL);
 	else
 		return -EINVAL;
 
-- 
2.21.0

