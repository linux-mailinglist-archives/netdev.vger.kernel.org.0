Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADB5CCBDF
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfJESEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37366 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfJESEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id p14so9757995wro.4
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zYVCFduKjD7kYjmQfZgN2UlSpaZ0Wvcqz71SMsM3Q2w=;
        b=ZvR3rRvvEYUx5nE9APsJyBzXAXZW86UmojrGXUfUSNjjX2uJ/CPp9dRfr9zS0/dqqI
         j0FVvloaDc91WOsblvkTfy4boZmcK52WYDjgT+D4passM2+UkBK7X6eFvNiG2XEtvOT8
         CVNLr2vVZL8S6/NwXD+kHBx1S0nlIcmSLqpWq4CbRldYWoJmJoUcWEOLvPi3cRdJPrYE
         y9Pqdqvfm7sQh770HQjCnIaADN1LG9YeqFPy4VyADP8+GriGFCkOnM9kG/NxvAfozukF
         3Yk1Ho/6KItMahThQYaAbYtQjEcxZnPDa1CUQCUc4lG5cALsiTF1uUW/TjiFxc3diDk4
         w+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zYVCFduKjD7kYjmQfZgN2UlSpaZ0Wvcqz71SMsM3Q2w=;
        b=ZbOmUY4q/eRaARilthJOi3O6bIEyrxXx9Em8adGpv7b82QREJW6hT3wpiURWUabYZO
         LSFvngD1+uIO7AH5UWuBHPOYqrhsjtWPGJoz24YIadN9sk7zyEbTUNg/cY175QkfC8VI
         JRcAW+Wr6+PuUsKhadxCrTx1D5JxXkv0IwAIaUDu8rSmnYKWGbbz5XS4WI0Zaffr9OdA
         O+/0kL8BrDeOwCyqqS9jG5vfP27+Fg+qP2lb0Eajx3SPDhE9SXRZCHJa28Ig+VG4wQv1
         ONHaXLzdJgeGZ0dOtZQNeJdNKgEv+77RXz6ibur+DpPd9BHL8wNVgqSoXq76rs99/pnX
         eTjA==
X-Gm-Message-State: APjAAAUXwsVB4mc6NBQ49O4CGTxThk9U6x/Pz6XypK4wY/rtqOjgpTzM
        p3uHoR6ze/UGzWi2IBnNWsuYssC+0yY=
X-Google-Smtp-Source: APXvYqwS0Hp18SJPpiPjBMN3mXh30XrFR3t4t6QUWHzF6TY/OpdnY+P/mxnwrNsTMV6BgyY7KxRIUA==
X-Received: by 2002:a5d:630d:: with SMTP id i13mr15788788wru.230.1570298686710;
        Sat, 05 Oct 2019 11:04:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o19sm17306712wmh.27.2019.10.05.11.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 03/10] net: genetlink: push attrbuf allocation and parsing to a separate function
Date:   Sat,  5 Oct 2019 20:04:35 +0200
Message-Id: <20191005180442.11788-4-jiri@resnulli.us>
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

To be re-usable by dumpit as well, push the code that is taking care of
attrbuf allocation and parting from doit into separate function.
Introduce a helper to free the buffer too.

Check family->maxattr too before calling kfree() to be symmetrical with
the allocation check.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/netlink/genetlink.c | 67 +++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index c785080e9401..a98c94594508 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -468,6 +468,45 @@ static void genl_dumpit_info_free(const struct genl_dumpit_info *info)
 	kfree(info);
 }
 
+static struct nlattr **
+genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
+				struct nlmsghdr *nlh,
+				struct netlink_ext_ack *extack,
+				const struct genl_ops *ops,
+				int hdrlen,
+				enum genl_validate_flags no_strict_flag)
+{
+	enum netlink_validation validate = ops->validate & no_strict_flag ?
+					   NL_VALIDATE_LIBERAL :
+					   NL_VALIDATE_STRICT;
+	struct nlattr **attrbuf;
+	int err;
+
+	if (family->maxattr && family->parallel_ops) {
+		attrbuf = kmalloc_array(family->maxattr + 1,
+					sizeof(struct nlattr *), GFP_KERNEL);
+		if (!attrbuf)
+			return ERR_PTR(-ENOMEM);
+	} else {
+		attrbuf = family->attrbuf;
+	}
+
+	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
+			    family->policy, validate, extack);
+	if (err && family->maxattr && family->parallel_ops) {
+		kfree(attrbuf);
+		return ERR_PTR(err);
+	}
+	return attrbuf;
+}
+
+static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
+					   struct nlattr **attrbuf)
+{
+	if (family->maxattr && family->parallel_ops)
+		kfree(attrbuf);
+}
+
 static int genl_lock_start(struct netlink_callback *cb)
 {
 	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
@@ -599,26 +638,11 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	if (!ops->doit)
 		return -EOPNOTSUPP;
 
-	if (family->maxattr && family->parallel_ops) {
-		attrbuf = kmalloc_array(family->maxattr + 1,
-					sizeof(struct nlattr *),
-					GFP_KERNEL);
-		if (attrbuf == NULL)
-			return -ENOMEM;
-	} else
-		attrbuf = family->attrbuf;
-
-	if (attrbuf) {
-		enum netlink_validation validate = NL_VALIDATE_STRICT;
-
-		if (ops->validate & GENL_DONT_VALIDATE_STRICT)
-			validate = NL_VALIDATE_LIBERAL;
-
-		err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
-				    family->policy, validate, extack);
-		if (err < 0)
-			goto out;
-	}
+	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
+						  ops, hdrlen,
+						  GENL_DONT_VALIDATE_STRICT);
+	if (IS_ERR(attrbuf))
+		return PTR_ERR(attrbuf);
 
 	info.snd_seq = nlh->nlmsg_seq;
 	info.snd_portid = NETLINK_CB(skb).portid;
@@ -642,8 +666,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 		family->post_doit(ops, skb, &info);
 
 out:
-	if (family->parallel_ops)
-		kfree(attrbuf);
+	genl_family_rcv_msg_attrs_free(family, attrbuf);
 
 	return err;
 }
-- 
2.21.0

