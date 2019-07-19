Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2AB6E4A2
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfGSLAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43581 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfGSLAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so31796875wru.10
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2kVRorh4Er67N5RUpFrIDdGNLfzkgzYTozOGh2fttWY=;
        b=CEQc7SwbJSXld9Jpv/t/+qUArWsFjcfjcPUHXf5x8MbgkQAM6vcYP/BICWoIWh5S4V
         waapnI/CwlVz1FQJcv2r05gXN3At2s5g0XCn8gONtRN1Gix79RHM86i+8nEpRowoDxyG
         2FBAJ7w3b6ONTv3+UP1CcOfLbrjDTsq2D+vnkkZkKHYwbTxLREi2sDtwH/Aw97p+gnns
         NcT9cjtyJl54asSfizDBt3+FK0M6YOixOnEDBQwjEaTaQHZB0JueIJeL6SuqnFKJEFq+
         reCB7e/OMF6o+HxwSEJIhfM1/jEf5eCF2n2C62PbcHXRIoVHjL7HM0HhQ8RBuzATEZks
         Rw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2kVRorh4Er67N5RUpFrIDdGNLfzkgzYTozOGh2fttWY=;
        b=thTIronRwA7sYTELlOdlsPSNJzjmZuG1soikThXH+irrI//Hqo/HL0zg8pDBaDvLIz
         JgdyjAtRGv7QFlQgOw/MTksWFi/TN8epHcwmH5M80QCOb5dMDJBJR5anKhAkFMbJn90r
         THZXJPM0OGExdsKEbD+cJvLspm4fFf6lFPt9msH+tHjYIReCbjKFGK7aSfqilgizB4T2
         DsQpNa/CAfzNeAE1jqqeCwD8DEfksIkbao0Ks19KHFABl0WG2bRAJ+G1AOA9RtnomwUC
         EsdpsJ1d/7ZL1ZrkMc3MpBOHS+S6dcj4rZhCGB/lT8hKvwxBBgFR2JkF09O8LeQeavwk
         XNHg==
X-Gm-Message-State: APjAAAU8amK3os3HyvmuVPYmWVYfEGEFeBWHDwF9tCjroeD5Pjb0Y6Ej
        QpdyaEI4on/2x2g7oQ7V6nYsdrfJ
X-Google-Smtp-Source: APXvYqymyjHyjv9ssEFFtmStD0rZm412hzoL44eQ87p2jCUpFLL0HKq0NGnX3ApQZ2OE668xarmyqA==
X-Received: by 2002:adf:fa42:: with SMTP id y2mr36144918wrr.170.1563534037291;
        Fri, 19 Jul 2019 04:00:37 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id l9sm26659989wmh.36.2019.07.19.04.00.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:37 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 7/7] net: rtnetlink: add possibility to use alternative names as message handle
Date:   Fri, 19 Jul 2019 13:00:29 +0200
Message-Id: <20190719110029.29466-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
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
 net/core/rtnetlink.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1fa30d514e3f..68ad12a7fc4d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1793,6 +1793,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
 	[IFLA_ALT_IFNAME_MOD]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
+	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
+				    .len = ALTIFNAMSIZ - 1 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2767,14 +2769,17 @@ static int do_setlink(const struct sk_buff *skb,
 
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
@@ -2810,8 +2815,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(net, NULL, ifname);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
 	else
 		goto errout;
 
@@ -2908,8 +2913,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -3080,8 +3086,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME])
-		dev = rtnl_dev_get(net, NULL, ifname);
+	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
 	else
 		dev = NULL;
 
@@ -3345,6 +3351,7 @@ static int rtnl_valid_getlink_req(struct sk_buff *skb,
 
 		switch (i) {
 		case IFLA_IFNAME:
+		case IFLA_ALT_IFNAME:
 		case IFLA_EXT_MASK:
 		case IFLA_TARGET_NETNSID:
 			break;
@@ -3392,8 +3399,9 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
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
 
@@ -3444,8 +3452,9 @@ static int rtnl_newaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
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
 
@@ -3491,8 +3500,9 @@ static int rtnl_delaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
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

