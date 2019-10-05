Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8352ECCBDE
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfJESEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36654 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfJESEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id m18so8685609wmc.1
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsH6780qB9NKayuJ/BZOHOFmz8iiuXggY5/BdEGQhhA=;
        b=jvEByrxjH7qlDvTEXjZ6OxQ+lbYvGBduYxGrTg76/J+fYV8w0nmFFRYhu3nGdfqita
         9vqGlq4IW9/DIgwcyupz5OEwwiOpm4kZR2TfijGSoIgYUkogLB+C4h8zwqNpLDmT+KYK
         1Qjpxz09R3EQpoeB3LQBenWqlDwtXWaIq/abJFlyhjpAmw17DuzF8MEdLsCBPIyUyF1w
         Opr1SfY/MwYjCDc9fjxRSNy2ywOZXkZBAHUhnUG1p197xpnzL1RmqXngq9SD9qjikjHW
         xv/EDrEQsMYkBNrFl9gKAYeFP0rhqYkLCXHqb5jGi1elA2/CXdfElGg7Cy7pSlQe4Leg
         ftpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsH6780qB9NKayuJ/BZOHOFmz8iiuXggY5/BdEGQhhA=;
        b=mVucsXeUVgiErn5cr0CgD2Nu0E7EGBbtltUYWIOWfwi9TdqYMtwgEjK7ff7307kBS0
         nqNqqsL/F+PQ7Z0tmSKWM8hOITOdxY8qWjYnclMqbI439Cez9i7h8nEaCJn614J/nSh5
         8XtP1C1oFKf/RVpoX4bUC8ezGEK7/H0xlkZuctyscykwN85K6+lx1HFH9u3i807ZzOQX
         rOHZfdsW9hTKpQ4WUhuliI4TNxc0yU/0nh52y5cpkPOgP9rCCopYDSf/KOV67/0XxZlP
         e7iWBxLRymwSF8RXWFU/5ZRnvl4TR2fM+IKr7993611KxL1IU85u5VTe1CTFCiyO+rtY
         /QQA==
X-Gm-Message-State: APjAAAXYUMkxmOIfi9fhN86tgoA64YCU3eWV6r/T3/YNamyHSoHpoCsT
        kvCa6zHqS9Q+Klgni0gTai0JvsFaYZs=
X-Google-Smtp-Source: APXvYqzgrkvRQADvWBnXpg3jIcKdbg973qPeeUxUl729q2z8/3cskKz9R8+50MQaGFCIIdqDdtzzxQ==
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr9202798wmm.141.1570298684654;
        Sat, 05 Oct 2019 11:04:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b7sm6982635wrx.56.2019.10.05.11.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 01/10] net: genetlink: push doit/dumpit code from genl_family_rcv_msg
Date:   Sat,  5 Oct 2019 20:04:33 +0200
Message-Id: <20191005180442.11788-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005180442.11788-1-jiri@resnulli.us>
References: <20191005180442.11788-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the function genl_family_rcv_msg() is quite big. Since it is
quite convenient, push code that is related to doit and dumpit ops into
separate functions.

Do small changes on the way, like rc/err unification, NULL check etc.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/netlink/genetlink.c | 173 ++++++++++++++++++++++------------------
 1 file changed, 96 insertions(+), 77 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index efccd1ac9a66..b5fa98b1577d 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -498,95 +498,76 @@ static int genl_lock_done(struct netlink_callback *cb)
 	return rc;
 }
 
-static int genl_family_rcv_msg(const struct genl_family *family,
-			       struct sk_buff *skb,
-			       struct nlmsghdr *nlh,
-			       struct netlink_ext_ack *extack)
+static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
+				      struct sk_buff *skb,
+				      struct nlmsghdr *nlh,
+				      struct netlink_ext_ack *extack,
+				      const struct genl_ops *ops,
+				      int hdrlen, struct net *net)
 {
-	const struct genl_ops *ops;
-	struct net *net = sock_net(skb->sk);
-	struct genl_info info;
-	struct genlmsghdr *hdr = nlmsg_data(nlh);
-	struct nlattr **attrbuf;
-	int hdrlen, err;
-
-	/* this family doesn't exist in this netns */
-	if (!family->netnsok && !net_eq(net, &init_net))
-		return -ENOENT;
-
-	hdrlen = GENL_HDRLEN + family->hdrsize;
-	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
-		return -EINVAL;
+	int err;
 
-	ops = genl_get_cmd(hdr->cmd, family);
-	if (ops == NULL)
+	if (!ops->dumpit)
 		return -EOPNOTSUPP;
 
-	if ((ops->flags & GENL_ADMIN_PERM) &&
-	    !netlink_capable(skb, CAP_NET_ADMIN))
-		return -EPERM;
-
-	if ((ops->flags & GENL_UNS_ADMIN_PERM) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
-		return -EPERM;
-
-	if ((nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP) {
-		int rc;
-
-		if (ops->dumpit == NULL)
-			return -EOPNOTSUPP;
-
-		if (!(ops->validate & GENL_DONT_VALIDATE_DUMP)) {
-			int hdrlen = GENL_HDRLEN + family->hdrsize;
-
-			if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
-				return -EINVAL;
+	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP)) {
+		if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
+			return -EINVAL;
 
-			if (family->maxattr) {
-				unsigned int validate = NL_VALIDATE_STRICT;
-
-				if (ops->validate &
-				    GENL_DONT_VALIDATE_DUMP_STRICT)
-					validate = NL_VALIDATE_LIBERAL;
-				rc = __nla_validate(nlmsg_attrdata(nlh, hdrlen),
-						    nlmsg_attrlen(nlh, hdrlen),
-						    family->maxattr,
-						    family->policy,
-						    validate, extack);
-				if (rc)
-					return rc;
-			}
+		if (family->maxattr) {
+			unsigned int validate = NL_VALIDATE_STRICT;
+
+			if (ops->validate & GENL_DONT_VALIDATE_DUMP_STRICT)
+				validate = NL_VALIDATE_LIBERAL;
+			err = __nla_validate(nlmsg_attrdata(nlh, hdrlen),
+					     nlmsg_attrlen(nlh, hdrlen),
+					     family->maxattr, family->policy,
+					     validate, extack);
+			if (err)
+				return err;
 		}
+	}
 
-		if (!family->parallel_ops) {
-			struct netlink_dump_control c = {
-				.module = family->module,
-				/* we have const, but the netlink API doesn't */
-				.data = (void *)ops,
-				.start = genl_lock_start,
-				.dump = genl_lock_dumpit,
-				.done = genl_lock_done,
-			};
+	if (!family->parallel_ops) {
+		struct netlink_dump_control c = {
+			.module = family->module,
+			/* we have const, but the netlink API doesn't */
+			.data = (void *)ops,
+			.start = genl_lock_start,
+			.dump = genl_lock_dumpit,
+			.done = genl_lock_done,
+		};
 
-			genl_unlock();
-			rc = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
-			genl_lock();
+		genl_unlock();
+		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
+		genl_lock();
 
-		} else {
-			struct netlink_dump_control c = {
-				.module = family->module,
-				.start = ops->start,
-				.dump = ops->dumpit,
-				.done = ops->done,
-			};
+	} else {
+		struct netlink_dump_control c = {
+			.module = family->module,
+			.start = ops->start,
+			.dump = ops->dumpit,
+			.done = ops->done,
+		};
+
+		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
+	}
 
-			rc = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
-		}
+	return err;
+}
 
-		return rc;
-	}
+static int genl_family_rcv_msg_doit(const struct genl_family *family,
+				    struct sk_buff *skb,
+				    struct nlmsghdr *nlh,
+				    struct netlink_ext_ack *extack,
+				    const struct genl_ops *ops,
+				    int hdrlen, struct net *net)
+{
+	struct nlattr **attrbuf;
+	struct genl_info info;
+	int err;
 
-	if (ops->doit == NULL)
+	if (!ops->doit)
 		return -EOPNOTSUPP;
 
 	if (family->maxattr && family->parallel_ops) {
@@ -638,6 +619,44 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 	return err;
 }
 
+static int genl_family_rcv_msg(const struct genl_family *family,
+			       struct sk_buff *skb,
+			       struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	const struct genl_ops *ops;
+	struct net *net = sock_net(skb->sk);
+	struct genlmsghdr *hdr = nlmsg_data(nlh);
+	int hdrlen;
+
+	/* this family doesn't exist in this netns */
+	if (!family->netnsok && !net_eq(net, &init_net))
+		return -ENOENT;
+
+	hdrlen = GENL_HDRLEN + family->hdrsize;
+	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
+		return -EINVAL;
+
+	ops = genl_get_cmd(hdr->cmd, family);
+	if (ops == NULL)
+		return -EOPNOTSUPP;
+
+	if ((ops->flags & GENL_ADMIN_PERM) &&
+	    !netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if ((ops->flags & GENL_UNS_ADMIN_PERM) &&
+	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if ((nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP)
+		return genl_family_rcv_msg_dumpit(family, skb, nlh, extack,
+						  ops, hdrlen, net);
+	else
+		return genl_family_rcv_msg_doit(family, skb, nlh, extack,
+						ops, hdrlen, net);
+}
+
 static int genl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
-- 
2.21.0

