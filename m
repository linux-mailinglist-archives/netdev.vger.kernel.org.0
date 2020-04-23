Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7361B62D7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgDWR7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729991AbgDWR7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:59:18 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B385C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:59:17 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x8so5595232qtp.13
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 10:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HlujGU4QAmoJJjC4H1VIbxZpaXDbVuqwLNt0ptJyVII=;
        b=ejwCA4rj/FBdWHIGWOxClHE80vBZxqw/j2G/BvW9BW0LjoBEjFth+8++p13D1F1+Mx
         Xdh3O3V8RLWnzNYP/tIIJz1Xg4wzVDTxT1pk3LQPqRfMhGtM+xktEoa50lWBPrnjemas
         qPfXgzBe3bqO2ZXpidUvpF77bCoSTgm4CL/cuJxZP/bJxLyhZ2FhJNPmv/3BD5C98h1v
         5miAIKis/s6x7syaOuAOWYZ/fq2e/rxizsbajoKmZJEN6aFi4muEt1RYH1OrVDe966U0
         6aMeyR83+27PYk/aA24hqoxYReQd+OhFKjyd6XL/yLlnph1jWgtKfTyHmNGtfdbUPalR
         49Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HlujGU4QAmoJJjC4H1VIbxZpaXDbVuqwLNt0ptJyVII=;
        b=BFvIRU8E3/ercwGCN9naqYV2fHOsnNh0dBOgPCToAKvEsqbVPrgtnbhWbuVrTvj6az
         m+6nTnhDOIJq/FEgZjoxL2bN6EMvTxQCGF9MVZdNRPvULzDL8nqxYNMSiA3YrX9hy2sh
         /ilqXaTmRTvkmJwxWG4WYD29PiKMOuBe+bE5hRkpL301hU3wYT/fOHAM1sLrqDeVuBWs
         OmFUHyUP7A3Rq1V5bwwYvGv9d4AgRnpKhsJwTj6d3fQqPbFaIDdtRuwXk+ry+XQY15mB
         3eKsGSp0HcoSVt/2MtdqoPFAFEGKvNgcKRKzq1XUsxZyrNLuApxtPGo4WhADqVXJxvaV
         s9pw==
X-Gm-Message-State: AGi0PuYgJfisL8twJLl+QFJAHEFgQbCb9P5Od3S8mTA6FmlS5wy+yyuy
        NamHDxWS5ZeXZ9orOfIidB4r/w==
X-Google-Smtp-Source: APiQypJAZfM0tAAo0UPGJ11+8DvZIsIdP0UgdmfZY0/HMH+d6T1cJpSR2kFfFDCMGw3gY6sJxUT7PQ==
X-Received: by 2002:ac8:2a70:: with SMTP id l45mr5444934qtl.232.1587664756638;
        Thu, 23 Apr 2020 10:59:16 -0700 (PDT)
Received: from mojaone.lan (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id 205sm2003040qkj.1.2020.04.23.10.59.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:59:16 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 v3 1/2] bpf: Fix segfault when custom pinning is used
Date:   Thu, 23 Apr 2020 13:58:56 -0400
Message-Id: <20200423175857.20180-2-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200423175857.20180-1-jhs@emojatatu.com>
References: <20200423175857.20180-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <jhs@mojatatu.com>

How to recreate:
1) Create a custome pinned map - example something along
   the lines of:

   struct bpf_elf_map SEC("maps") my_map = {
        .type = BPF_MAP_TYPE_HASH,
        .size_key = sizeof(struct my_key),
        .size_value = sizeof(struct my_value),
        .pinning = 6,
        .max_elem = 16,
   };

2) load the program with tc filter and tc will segfault.

The reason is we strcat past memory allocated using asprintf.
Solution - just use a static buffer of max possible size of 4k.

Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 lib/bpf.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 10cf9bf4..73f3a590 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1509,16 +1509,12 @@ out:
 static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 				const char *todo)
 {
-	char *tmp = NULL;
+	char tmp[PATH_MAX];
 	char *rem = NULL;
 	char *sub;
 	int ret;
 
-	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
+	snprintf(tmp, PATH_MAX, "%s/../", bpf_get_work_dir(ctx->type));
 
 	ret = asprintf(&rem, "%s/", todo);
 	if (ret < 0) {
@@ -1547,7 +1543,6 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 	ret = 0;
 out:
 	free(rem);
-	free(tmp);
 	return ret;
 }
 
-- 
2.20.1

