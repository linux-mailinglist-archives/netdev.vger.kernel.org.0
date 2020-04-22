Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32051B3EB8
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 12:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgDVKa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 06:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731003AbgDVK2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 06:28:31 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114C9C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 03:28:31 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id t3so1830721qkg.1
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 03:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hy/Ktw/WIQpfzZT8igDmzHAnYkpUxpGcZah1zMZs3z8=;
        b=eyPNSVB8V6Wn1vYjmCc9ZBz8w7d2+TTjkMQKOODE4x7YWPiSUg2KbT1I7Xqh+RkxDx
         ZrznN86hSflt30MqRWhZ4vSXCfyh34GhNduBb1dgSPowrznwc6QSwkOzs6VpXA5PE8qU
         P4UgF2wkOU54VspXGGkU3bVLh9X0EOoR/T96DWVIwSfcCd2c5nG/L2KmgGIcB9wlSM9q
         Nu1kGfmyO3KqUi6PReOxxnk1eO1NibCYTGomXHkg+IKTB74qY8LwIanlQKe4IwBPrv4i
         QwFfqLQ+7j7AzYG2VRDO9rJ/TBenTZ8iMm/sPOpSAK4g9tnL4gvEvW5DhcTdF9K2alyS
         DDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hy/Ktw/WIQpfzZT8igDmzHAnYkpUxpGcZah1zMZs3z8=;
        b=txJepyfbd6/u6XFMvYOM6AHbtc3zX1zGM8ExYl6+Z7QPIwVmNd6yvGWvxOmrZyMzdK
         bBbbg3ZYCsZkoFcA5EDrLi8BIb9iTzFdzG7O9Yth3d0S+LTWp+RSTAww44PZfS4Sa9r3
         +xcbVO5D6WsQuaLkUHtFr1VJEfKaMDSI73t6JIPc7IFmYbfGvkhXdTBiyR8iShTsptv9
         WHMXTwgpYeVbE3C6HdedKjWJl5dN3jUxS5i1v2YYB9BYoENd0iqNszUOSCItACfk3o3H
         xY3kyhEUNBf7AduJcN/Jki3+1gRKOKAZXf8hf2EKJbcwkNrxyR+3bx5j4L5Bk88BswVb
         o2dA==
X-Gm-Message-State: AGi0PuaUm+Km0FmcmZ+B7lUVNUEkZLVfHZpXip9/oLORE+I9WukKdr2T
        Q4i+l87hiJNPePhK7INfkIgYkw==
X-Google-Smtp-Source: APiQypKEXAwNBiQJBYoyktH0un2zQu8I8qmzoAYP6ZZMeXe+UdPEUcHsJP6GCJgRQX4wEEeSWmQaVQ==
X-Received: by 2002:a37:7a85:: with SMTP id v127mr15782329qkc.385.1587551310366;
        Wed, 22 Apr 2020 03:28:30 -0700 (PDT)
Received: from localhost.localdomain (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id h3sm3531964qkf.15.2020.04.22.03.28.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 03:28:29 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 v2 1/2] bpf: Fix segfault when custom pinning is used
Date:   Wed, 22 Apr 2020 06:28:07 -0400
Message-Id: <20200422102808.9197-2-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200422102808.9197-1-jhs@emojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <hadi@mojatatu.com>

Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 lib/bpf.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 10cf9bf4..656cad02 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1509,15 +1509,15 @@ out:
 static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 				const char *todo)
 {
-	char *tmp = NULL;
+	char tmp[PATH_MAX] = {};
 	char *rem = NULL;
 	char *sub;
 	int ret;
 
-	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
+	ret = snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));
 	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
+		fprintf(stderr, "snprintf failed: %s\n", strerror(errno));
+		return ret;
 	}
 
 	ret = asprintf(&rem, "%s/", todo);
@@ -1547,7 +1547,6 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 	ret = 0;
 out:
 	free(rem);
-	free(tmp);
 	return ret;
 }
 
-- 
2.20.1

