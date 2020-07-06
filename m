Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C724F2155D6
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgGFKuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgGFKuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:50:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228AEC061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 03:50:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so37873898wrp.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 03:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkSmHrh2ZLGv5grEC4R+w7X480jRmn+K+RayTDZm/VE=;
        b=eoNrCMZ1nUAfBNcD+5Yp6sOEVG/vjD6KRDgq7SsNTE5jFZbs4YfVuYPN2zk/dAvt/m
         qx+y+htTtTy0uFH6eoJAXITxPHjhTd3UtDIyQDFkkJJTTgXHrCoXATzGZY8jCIqUQ5fg
         2jMSStUMklSG6rt4S33VNj3ktWwzIjza2zwCnCHAodwvYp4NfH1jQDqyLwKHibN/bRF9
         PSHNxNyC0FrDRrRlT4socqBWsyTm1QJc1Q8lUNMYyvxNsz9KlscxAGa0jV3XeqWh88+M
         T8jRUf6WIkHNuEjgWRU+Eoaa6iFffCIYmHezFEbHBWFAb+IU9aZW0XKC9PnSaJqZSGj/
         oqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkSmHrh2ZLGv5grEC4R+w7X480jRmn+K+RayTDZm/VE=;
        b=U7NLFpGiu2KXEb7c9lc7wsRh/3W5CFhDZcN/3CPvlmdGQVTUs4ooYTsILZIRL6U9Lu
         g4eo9JOecxGjjPw80fzJMoEFaSJ+j3PjzaRifvoCfKpgg5HKVjYTpywhYaLEqFTLn7Wv
         I+jRL25yZfq6053+VFfpNptZEUh+F8JOqiHdo4bdI3kmWnO8c8N2knYBipUGCZ3KYG5E
         1EFqtYaYzNNZ9hKtX6+jmdI33F9XR52O0QRen2X5gxwfN0MnWnOUy3LfXr9FQjHluJu0
         OYuloMuAraQl/UDJ0t/t7c7hpbYxHYynnE01/9abCDjvAwyP5Gahab1fF0GZFDDoVe1J
         4zsA==
X-Gm-Message-State: AOAM532MbSrygZbm6Nfaq48dh6bNCq6R6XvmXfXm0S4yT7lgL6pX46Fp
        zjimg4vWhXvJGoCf4rSE32C5phnXeSE=
X-Google-Smtp-Source: ABdhPJyIVUgkaDkHh+n/UXkPIWY11npPKo8XeeNqpvqx/TSEEqqLA2ObkdwpLsW+ZZP2uqfom2TvHA==
X-Received: by 2002:a05:6000:cf:: with SMTP id q15mr49240629wrx.203.1594032610421;
        Mon, 06 Jul 2020 03:50:10 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id 190sm11583226wmb.15.2020.07.06.03.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 03:50:09 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2] ip xfrm: policy: support policies with IF_ID in get/delete/deleteall
Date:   Mon,  6 Jul 2020 13:47:56 +0300
Message-Id: <20200706104756.3546238-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
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
 ip/xfrm_policy.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

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
 
-- 
2.25.1

