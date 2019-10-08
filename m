Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45A6CF70F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfJHKbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:31:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33525 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbfJHKbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 06:31:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so18803617wrs.0
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 03:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1e8KokhtAJu9Ixng89AHaYGeVagnVGaJRUSPgNUrOhE=;
        b=CYj2nJmQPmE9B4FmMF1QNVJbK8yv//1rTgkR+aXTWhC3ngE4e50izF/qWYSpmQ0cEb
         DC3iyjfosnrA12ifj3pEzbn6o8hBg+V0SUtItz/bkuV+ElxVAaF4CAJqrSuaiINF9gB6
         HiRTq5R46DqXsS5TVmC+BcrKrLRyD3D2uEudNn2wQiwqu9uXGiukwD/CsV1Puj515AP+
         vYqtINzmeYhkgkvyOdVtQFYp7bBaNbXahlEEr3L0rpf+dczCFXopg6+k6fZxlxgOV/Y7
         cCiPj6ZsLpIDKv8Ce5ETJj5a0dYqkWICbqslVaiC5G0cHBN60Rdnjac5pBT8Tu1+3uk3
         +IUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1e8KokhtAJu9Ixng89AHaYGeVagnVGaJRUSPgNUrOhE=;
        b=G/8Op9/BeN5i2eTf11iAv0+47nsWodUBt3m6lMvpW/5tYbpAThayf8hgiwLDA/GZ51
         ijbuiyqPtF8TouXA9Mje5yKk7li+lcAjrD88lqRknw8t1DtqYNOJq5yfjA0gEsWuK6vS
         Ihw/lp3R4osWt7j9bRgV+5PxqvHz8gfB6izW8uyrWSfPeYNGmQJMr/4ylCfL1wmeW6D5
         7AhsRCCfQlSp36qu5ZpgWRdWeWdkVlGKyWAu5e5hzuSqu6H9Q8IfuKSWsiG1XFNyHrub
         4JhZGUh182/Ylcx/8wZLKlwDVlCFTmenynwB9BkZRorfzUVIbq4R5OJm7GSBMaVxC1kL
         m5iw==
X-Gm-Message-State: APjAAAXT9QqcPTxRlVczhjNzGHmjwC5lgWjTK1YX4X8qSzUJRC832x2E
        cp9T78eq2RT0fDDdHTV2vhjMgRE8cXQ=
X-Google-Smtp-Source: APXvYqyypBktgt//tDD4zNeHb9+pr74jfaKblkaeo33RkYsyr2sY79BeRAqg8055fF0JgSStABv/0g==
X-Received: by 2002:adf:fa0e:: with SMTP id m14mr21320812wrr.11.1570530704920;
        Tue, 08 Oct 2019 03:31:44 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id e15sm21700035wrt.94.2019.10.08.03.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 03:31:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next] net: genetlink: always allocate separate attrs for dumpit ops,
Date:   Tue,  8 Oct 2019 12:31:43 +0200
Message-Id: <20191008103143.29200-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Individual dumpit ops (start, dumpit, done) are locked by genl_lock
for if !family->parallel_ops. However, multiple
genl_family_rcv_msg_dumpit() calls may in in flight in parallel.
Each has a separate struct genl_dumpit_info allocated
but they share the same family->attrbuf. Fix this by allocating separate
memory for attrs for dumpit ops, for non-parallel_ops (for parallel_ops
it is done already).

Reported-by: syzbot+495688b736534bb6c6ad@syzkaller.appspotmail.com
Reported-by: syzbot+ff59dc711f2cff879a05@syzkaller.appspotmail.com
Reported-by: syzbot+dbe02e13bcce52bcf182@syzkaller.appspotmail.com
Reported-by: syzbot+9cb7edb2906ea1e83006@syzkaller.appspotmail.com
Fixes: bf813b0afeae ("net: genetlink: parse attrs and store in contect info struct during dumpit")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/netlink/genetlink.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 1b5046436765..ecc2bd3e73e4 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -474,7 +474,8 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 				struct netlink_ext_ack *extack,
 				const struct genl_ops *ops,
 				int hdrlen,
-				enum genl_validate_flags no_strict_flag)
+				enum genl_validate_flags no_strict_flag,
+				bool parallel)
 {
 	enum netlink_validation validate = ops->validate & no_strict_flag ?
 					   NL_VALIDATE_LIBERAL :
@@ -482,7 +483,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	struct nlattr **attrbuf;
 	int err;
 
-	if (family->maxattr && family->parallel_ops) {
+	if (parallel) {
 		attrbuf = kmalloc_array(family->maxattr + 1,
 					sizeof(struct nlattr *), GFP_KERNEL);
 		if (!attrbuf)
@@ -493,7 +494,7 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 
 	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
-	if (err && family->maxattr && family->parallel_ops) {
+	if (err && parallel) {
 		kfree(attrbuf);
 		return ERR_PTR(err);
 	}
@@ -501,9 +502,10 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 }
 
 static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
-					   struct nlattr **attrbuf)
+					   struct nlattr **attrbuf,
+					   bool parallel)
 {
-	if (family->maxattr && family->parallel_ops)
+	if (parallel)
 		kfree(attrbuf);
 }
 
@@ -542,7 +544,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -555,7 +557,7 @@ static int genl_parallel_done(struct netlink_callback *cb)
 
 	if (ops->done)
 		rc = ops->done(cb);
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -585,7 +587,8 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 
 	attrs = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						ops, hdrlen,
-						GENL_DONT_VALIDATE_DUMP_STRICT);
+						GENL_DONT_VALIDATE_DUMP_STRICT,
+						true);
 	if (IS_ERR(attrs))
 		return PTR_ERR(attrs);
 
@@ -593,7 +596,7 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 	/* Allocate dumpit info. It is going to be freed by done() callback. */
 	info = genl_dumpit_info_alloc();
 	if (!info) {
-		genl_family_rcv_msg_attrs_free(family, attrs);
+		genl_family_rcv_msg_attrs_free(family, attrs, true);
 		return -ENOMEM;
 	}
 
@@ -645,7 +648,9 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
-						  GENL_DONT_VALIDATE_STRICT);
+						  GENL_DONT_VALIDATE_STRICT,
+						  family->maxattr &&
+						  family->parallel_ops);
 	if (IS_ERR(attrbuf))
 		return PTR_ERR(attrbuf);
 
@@ -671,7 +676,8 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 		family->post_doit(ops, skb, &info);
 
 out:
-	genl_family_rcv_msg_attrs_free(family, attrbuf);
+	genl_family_rcv_msg_attrs_free(family, attrbuf,
+				       family->maxattr && family->parallel_ops);
 
 	return err;
 }
-- 
2.21.0

