Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082842198AE
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgGIGaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgGIGaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:30:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0C3C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 23:30:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id a6so5497959wmm.0
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ww/enzP452BGCBC/bQOZJWzgEyqmgDQ14Qk4+WNZW3U=;
        b=nAhl6JYpOclqHzUyh+5RrEfXV1yYu5DeoClCSWtgMG/Ly9lCd6Ot9Kn2aAwQg6REIL
         U0LA3YGxpX0slEjRWr6fK7scr28dLxsY4OZZZzzqWODyLLZGUvMW6xb1v43BxuXSuyPu
         mBFGXLKV6tU7pTKOhmCPaJgit/FS5qr5LjuBc23HvV8jnKIATgNp5TOSkU7rpAQUgH0n
         iIiJDDJ4svHDTUtz+muZ5egWBgDH1GVYcptuFg40rTdzi2QalzkCp8fJMlsiHvqsj61g
         E14J2tLfsXXANzXszjrrEX5+XKk83NDOxtN5pN6X4R8EdDb7PSgvflnQvPNujK6aPGhl
         5yvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ww/enzP452BGCBC/bQOZJWzgEyqmgDQ14Qk4+WNZW3U=;
        b=PlbWycZMxyDHYfbYc+kLNqEvtpxD5S0+GazlPIn/yLC4exZneJ1Kzcwf7IiofJ8iIU
         LjCf4N6ncy1QqWcjgGqBRrovrFdSHaXSKXfOb1giWvUlg52E9ExYygljVinh5uPW8XUF
         pQ9MucpDRmtP8JMKZ2GYMt2VF2Zs4gpoX7uQsUV8TgxIGI6rHl1dTywrClZ6/uiXEup0
         WCMS9p209ZHDztVxHI67ckiqFjXhfvmUCBq1qIZWrERUm4xX8kH4mRaMkCqggwHor3uL
         wl81jCtwkG8OuFeMAX2PWeLU8vGr4jvzGlTIqAsu8YUVBk20PRSEbDyI+IMh6nxijWVW
         3t5A==
X-Gm-Message-State: AOAM530tWC24V6Ntd5QzuOk2ZM3zP0nJ0+JVNXLoxix6PMC2lhJmbZp5
        BSHs35b50KOwZFY7VkeMglZ+GMOfFWo=
X-Google-Smtp-Source: ABdhPJzcHPLwVscIKMTW74nMzVYIHPWf11bHzZCuPH3WHzMSkWmblPOGs+TWLMLibQyFlg5YCU7poQ==
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr13088519wml.142.1594276215892;
        Wed, 08 Jul 2020 23:30:15 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id l8sm3777854wrq.15.2020.07.08.23.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 23:30:15 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2,v2 2/2] ip xfrm: policy: support policies with IF_ID in get/delete/deleteall
Date:   Thu,  9 Jul 2020 09:29:48 +0300
Message-Id: <20200709062948.1762006-3-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709062948.1762006-1-eyal.birger@gmail.com>
References: <20200709062948.1762006-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XFRMA_IF_ID attribute is set in policies for them to be
associated with an XFRM interface (4.19+).

Add support for getting/deleting policies with this attribute.

For supporting 'deleteall' the XFRMA_IF_ID attribute needs to be
explicitly copied.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 ip/xfrm_policy.c   | 17 ++++++++++++++++-
 man/man8/ip-xfrm.8 |  2 ++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index d3c706d3..7cc00e7c 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -59,6 +59,7 @@ static void usage(void)
 		"	[ if_id IF_ID ] [ LIMIT-LIST ] [ TMPL-LIST ]\n"
 		"Usage: ip xfrm policy { delete | get } { SELECTOR | index INDEX } dir DIR\n"
 		"	[ ctx CTX ] [ mark MARK [ mask MASK ] ] [ ptype PTYPE ]\n"
+		"	[ if_id IF_ID ]\n"
 		"Usage: ip xfrm policy { deleteall | list } [ nosock ] [ SELECTOR ] [ dir DIR ]\n"
 		"	[ index INDEX ] [ ptype PTYPE ] [ action ACTION ] [ priority PRIORITY ]\n"
 		"	[ flag FLAG-LIST ]\n"
@@ -582,6 +583,8 @@ static int xfrm_policy_get_or_delete(int argc, char **argv, int delete,
 		struct xfrm_user_sec_ctx sctx;
 		char    str[CTX_BUF_SIZE];
 	} ctx = {};
+	bool is_if_id_set = false;
+	__u32 if_id = 0;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "dir") == 0) {
@@ -619,7 +622,11 @@ static int xfrm_policy_get_or_delete(int argc, char **argv, int delete,
 
 			NEXT_ARG();
 			xfrm_policy_ptype_parse(&upt.type, &argc, &argv);
-
+		} else if (strcmp(*argv, "if_id") == 0) {
+			NEXT_ARG();
+			if (get_u32(&if_id, *argv, 0))
+				invarg("IF_ID value is invalid", *argv);
+			is_if_id_set = true;
 		} else {
 			if (selp)
 				invarg("unknown", *argv);
@@ -669,6 +676,9 @@ static int xfrm_policy_get_or_delete(int argc, char **argv, int delete,
 			  (void *)&ctx, ctx.sctx.len);
 	}
 
+	if (is_if_id_set)
+		addattr32(&req.n, sizeof(req.buf), XFRMA_IF_ID, if_id);
+
 	if (rtnl_talk(&rth, &req.n, answer) < 0)
 		exit(2);
 
@@ -767,6 +777,11 @@ static int xfrm_policy_keep(struct nlmsghdr *n, void *arg)
 		}
 	}
 
+	if (tb[XFRMA_IF_ID]) {
+		addattr32(new_n, xb->size, XFRMA_IF_ID,
+			  rta_getattr_u32(tb[XFRMA_IF_ID]));
+	}
+
 	xb->offset += new_n->nlmsg_len;
 	xb->nlmsg_count++;
 
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index d717205d..aa28db49 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -259,6 +259,8 @@ ip-xfrm \- transform configuration
 .IR MASK " ] ]"
 .RB "[ " ptype
 .IR PTYPE " ]"
+.RB "[ " if_id
+.IR IF-ID " ]"
 
 .ti -8
 .BR ip " [ " -4 " | " -6 " ] " "xfrm policy" " { " deleteall " | " list " }"
-- 
2.25.1

