Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1650673646
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjASLC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjASLCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:02:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99EB6FF9B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:01:56 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id i10-20020a25f20a000000b006ea4f43c0ddso1780115ybe.21
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=io89/iae7nEhAJuIV5UweCse0MN5T7ZDEnSPGBYrpE0=;
        b=iEuXkADF3ngjWSZhSRQoKm2CMQcMY7iXTsYuk/ID4N2twZ4vghSpN5TgZnFLAFM8RK
         kLoddrVi/ToGXMSI80KRkRGXi/WDP+79dHcJ7NYyaYvASnjJ1fvJNIoATRU0TeM5p/qx
         bdjtkZi9QwRAKgK2ivUqDrl3NvxSke6+KumhJ/eFjxSFMKrFKfSGcr+Cv2PBWlusnJev
         pukt2r3jH/GW8WFcjjBaCmCAPv6wi0cHxarAsrwobCoDrz3DOUxKpB7/vzUx7fT+iLWj
         ZcQO86d5KTOlkd5hXFwqtZVhNPsnWj9NJAflfRVDUwbnOgo37LZa++h/c1cFlAKW6Res
         At0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=io89/iae7nEhAJuIV5UweCse0MN5T7ZDEnSPGBYrpE0=;
        b=zp7Zv2KOjZaSHcceg/0AfXgYNp/9zt1I1UDh+6VZBo5MiulYaq2QOIJF0C4sAJX0+0
         IRygevrpTwHP5fZhLAHUXvc5xe2P5yRbgxCpXKae0MOt0Jjl6YRDaSJclJG1IFTZwxsa
         Lh6Bk8PYuWNvkQEcYPAmF4GHjwVooe+d3TzuSR0wpFwSQE+KmstYrYcFEzZm68DDtkOq
         +6lcVLVkb9VH+pApaeRaqXzW6Lofbobkd3+OPrdBORSahH+i3d4Ed6Eg+xUfy8ox87nX
         86c1BFCqawW1mppv1l59G7IPRcnaxlJ9/S7onlGdFutTLQJrkjptKGkQCl2DtDEXaes6
         FtVg==
X-Gm-Message-State: AFqh2koSEp7ke9+2oCAdM9ugUftpukaX8Cmd7zIuPwGTXBTqa1O8G+8k
        GC3LrFkXylAyBs7t3Y5N2sv6hXzx8uiI6Q==
X-Google-Smtp-Source: AMrXdXsYjpL9+FbWC7PSC/Ye4OAnlubrKCKkN7GEoQuBQGbea7sO2jSM1sHfj4djq19fOSKJFVVZxCGWa1PSmA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d043:0:b0:7c8:accc:5788 with SMTP id
 h64-20020a25d043000000b007c8accc5788mr1258376ybg.634.1674126116139; Thu, 19
 Jan 2023 03:01:56 -0800 (PST)
Date:   Thu, 19 Jan 2023 11:01:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230119110150.2678537-1-edumazet@google.com>
Subject: [PATCH net] netlink: prevent potential spectre v1 gadgets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most netlink attributes are parsed and validated from
__nla_validate_parse() or validate_nla()

    u16 type = nla_type(nla);

    if (type == 0 || type > maxtype) {
        /* error or continue */
    }

@type is then used as an array index and can be used
as a Spectre v1 gadget.

array_index_nospec() can be used to prevent leaking
content of kernel memory to malicious users.

This should take care of vast majority of netlink uses,
but an audit is needed to take care of others where
validation is not yet centralized in core netlink functions.

Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 lib/nlattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 9055e8b4d144e4c9fc0de6f6d8bbab0d7620932e..489e15bde5c1d248ba4914da2aa4839f1084f5b7 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/jiffies.h>
+#include <linux/nospec.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -381,6 +382,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	if (type <= 0 || type > maxtype)
 		return 0;
 
+	type = array_index_nospec(type, maxtype + 1);
 	pt = &policy[type];
 
 	BUG_ON(pt->type > NLA_TYPE_MAX);
@@ -596,6 +598,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 			}
 			continue;
 		}
+		type = array_index_nospec(type, maxtype + 1);
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
 					       validate, extack, depth);
-- 
2.39.1.405.gd4c25cc71f-goog

