Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FFDCCBE2
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfJESEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36657 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfJESEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id m18so8685665wmc.1
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sNFu6DoXq1UK9k1WqNOkxOr2J0YgZO9phZ9Wz3HLB5c=;
        b=pmwpNo9zXAMQbW2XodvXiDSIBXRqb3AHNzpO9tFapfLjCra+/Qqz8aUv+bD8Q9UGTh
         1oPOwgMpxw9hw/2hPzsIr2Jpdb/n+cfz6lezs7xeB83omTJfX7ZRMPY7DxcOzwfdEI7t
         D8FcW6jMOCH0rNZko+V+7ZXCNTOlkHgQeLBOHftwFqUx5JNlrBPMDGsIFQA15vmeFTGc
         XFPVmXzcnoa75oaEE383XXvEnccLC31Uf7OR/xHvHuh/InTjdoUa9t3cam2qn7/XiRl6
         BPVM9I0Uy/MRwRs5CJrle5RFA9NswlMnnqc+VKzd7ymeO54HBaH7Chpt9KglDNIPSxy+
         +kbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sNFu6DoXq1UK9k1WqNOkxOr2J0YgZO9phZ9Wz3HLB5c=;
        b=sLDXlC3vEVOnGZ/IEUSwFPlVCXsS/t+mYK27i9UzyVk5d9iFZj9pQeF5F9cF8yEaig
         1E9NmpfubkF8Gqyt3E4F1xeARIQzHHB4YTvGdZ7+oIcwK1FTtpdoBV2tGTSmWKLLWl5Y
         Y18mqH9g98VkkT+h809cQt3aglOG/dpIr6bnV4FxNXVo05FVkdRze5TZaaVz0XQOW58A
         5bA8RSVaDQ3+RuXxN8ixFgzW973zqH1ipSpn1wS+nUMioeKMhfq5TAsMxN7jTjqAoSMs
         4Az446Oy0sFhIpfju6YCPzRERCuZZlwKHJvkdWPkcfLQ6nSxJxxr9TfaaZswvKrGDgkr
         lsNw==
X-Gm-Message-State: APjAAAU/k3N8ZAf0SjNk+r/AXORZUnqpmvjJ2fr8KJhNJfqSokmpPwUJ
        l4H8FSm/tVnH4vlioLz5Uvqq8kUFwwc=
X-Google-Smtp-Source: APXvYqzqny3yMn7yw/2ZjJ6aHhbYGm/YC8lLwopWy4RwTUELbhVp1mgKAVjOhAXNOkGXf5gkrqQ57g==
X-Received: by 2002:a1c:9d15:: with SMTP id g21mr15191375wme.96.1570298687598;
        Sat, 05 Oct 2019 11:04:47 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 59sm18201349wrc.23.2019.10.05.11.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 04/10] net: genetlink: parse attrs and store in contect info struct during dumpit
Date:   Sat,  5 Oct 2019 20:04:36 +0200
Message-Id: <20191005180442.11788-5-jiri@resnulli.us>
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

Extend the dumpit info struct for attrs. Instead of existing attribute
validation do parse them and save in the info struct. Caller can benefit
from this and does not have to do parse itself. In order to properly
free attrs, genl_family pointer needs to be added to dumpit info struct
as well.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/genetlink.h |  4 ++++
 net/netlink/genetlink.c | 39 ++++++++++++++++++++++-----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index fb838f4b0089..922dcc9348b1 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -129,10 +129,14 @@ enum genl_validate_flags {
 
 /**
  * struct genl_info - info that is available during dumpit op call
+ * @family: generic netlink family - for internal genl code usage
  * @ops: generic netlink ops - for internal genl code usage
+ * @attrs: netlink attributes
  */
 struct genl_dumpit_info {
+	const struct genl_family *family;
 	const struct genl_ops *ops;
+	struct nlattr **attrs;
 };
 
 static inline const struct genl_dumpit_info *
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index a98c94594508..8059118ee5a1 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -542,6 +542,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -554,6 +555,7 @@ static int genl_parallel_done(struct netlink_callback *cb)
 
 	if (ops->done)
 		rc = ops->done(cb);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -566,35 +568,38 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 				      int hdrlen, struct net *net)
 {
 	struct genl_dumpit_info *info;
+	struct nlattr **attrs = NULL;
 	int err;
 
 	if (!ops->dumpit)
 		return -EOPNOTSUPP;
 
-	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP)) {
-		if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
-			return -EINVAL;
+	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
+		goto no_attrs;
 
-		if (family->maxattr) {
-			unsigned int validate = NL_VALIDATE_STRICT;
-
-			if (ops->validate & GENL_DONT_VALIDATE_DUMP_STRICT)
-				validate = NL_VALIDATE_LIBERAL;
-			err = __nla_validate(nlmsg_attrdata(nlh, hdrlen),
-					     nlmsg_attrlen(nlh, hdrlen),
-					     family->maxattr, family->policy,
-					     validate, extack);
-			if (err)
-				return err;
-		}
-	}
+	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
+		return -EINVAL;
+
+	if (!family->maxattr)
+		goto no_attrs;
 
+	attrs = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
+						ops, hdrlen,
+						GENL_DONT_VALIDATE_DUMP_STRICT);
+	if (IS_ERR(attrs))
+		return PTR_ERR(attrs);
+
+no_attrs:
 	/* Allocate dumpit info. It is going to be freed by done() callback. */
 	info = genl_dumpit_info_alloc();
-	if (!info)
+	if (!info) {
+		genl_family_rcv_msg_attrs_free(family, attrs);
 		return -ENOMEM;
+	}
 
+	info->family = family;
 	info->ops = ops;
+	info->attrs = attrs;
 
 	if (!family->parallel_ops) {
 		struct netlink_dump_control c = {
-- 
2.21.0

