Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7073FF390
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347311AbhIBSyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347209AbhIBSxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:53:46 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500CBC0613D9
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 11:52:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n27so6706505eja.5
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 11:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RcfKZbBAx6aDUYDkmIUlll5nO38/7sXig1IBG/oje40=;
        b=g1S28H/f87Z5sqhFfFS3DI9Pixx1kHY69WcSKSltZAj3Ajheoi6CYeRQUssB9E88Vh
         03+6Q0O5ZuS1JUqtb3dcVt749A3D+ACrveVL9zgQgH0fAggoOai8TRoAEqdtXzszDDaQ
         GFd1piNGX3KlF1KPUGptl2UD+yUPqBwaKId9Ov4g8Slhohn30OGCRWbKLsk7xt59n5UI
         1s20UB7ecY4iRM9JvVe3Y//m81f1J6azDJodrsmUqytvECSlg5vvxA5H+VdbQk6XjEW8
         gbhqJnQZ4fWztXU5+2iLLvC8Ub2q2Y1ZjhTrR9llsSYux5keGdyIhPH9VVHIYSI3WfRQ
         t2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RcfKZbBAx6aDUYDkmIUlll5nO38/7sXig1IBG/oje40=;
        b=VOs5T5aOXaSxaz1cUOi3rWWveOSTLj1ty4HZ6HqYCfpks7Qi1Uu2OX3yEYDbtf+Vt5
         Cax0/vjEa/Rlj69nEpRTG/6KxNFd7qHt19cHyXV3EDPJVTfl4t5KTfaEFv+LVpNBVwDP
         Ctw/zZ6uBzptksZPf1dOd2rkbz5fox9SxF5s6s4GAhpnzCKdBaZGWyxiV7HZeB4j7+rF
         oJySB5gg0kTPsn6ChOf1vHiEiKJjzYwGNIKwVF651ncSs0SxxIq0wV0aZRjCJJhjNC+p
         iCAn187jM2WpJqZ8bcpBlMldVaxeTT+zJMHstus5PdZxmIYmihFykMLANWy3VLwx8MD8
         4BTA==
X-Gm-Message-State: AOAM532wOsE5gU9YmxRhbBwjvjxNFveVy7AgECUHmpP3IhR+Clirw/xx
        ZCaUZK/ekqN9EsosiQrTgwpSTw==
X-Google-Smtp-Source: ABdhPJxFcR5ruy21ZxtYlgxGrk084CJvT0wmyFZEH5oyh5bAlfdbfsSbJ4E5VQnoF+aGaRR5cCdEew==
X-Received: by 2002:a17:906:d04f:: with SMTP id bo15mr5167197ejb.309.1630608765978;
        Thu, 02 Sep 2021 11:52:45 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id mb14sm1592235ejb.81.2021.09.02.11.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:52:45 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        iii@linux.ibm.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 08/13] bpf/tests: Add test case flag for verifier zero-extension
Date:   Thu,  2 Sep 2021 20:52:24 +0200
Message-Id: <20210902185229.1840281-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new flag to indicate that the verified did insert
zero-extensions, even though the verifier is not being run for any
of the tests.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 3af8421ceb94..183ead9445ba 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -52,6 +52,7 @@
 #define FLAG_NO_DATA		BIT(0)
 #define FLAG_EXPECTED_FAIL	BIT(1)
 #define FLAG_SKB_FRAG		BIT(2)
+#define FLAG_VERIFIER_ZEXT	BIT(3)
 
 enum {
 	CLASSIC  = BIT(6),	/* Old BPF instructions only. */
@@ -11278,6 +11279,8 @@ static struct bpf_prog *generate_filter(int which, int *err)
 		fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
 		memcpy(fp->insnsi, fptr, fp->len * sizeof(struct bpf_insn));
 		fp->aux->stack_depth = tests[which].stack_depth;
+		fp->aux->verifier_zext = !!(tests[which].aux &
+					    FLAG_VERIFIER_ZEXT);
 
 		/* We cannot error here as we don't need type compatibility
 		 * checks.
-- 
2.25.1

