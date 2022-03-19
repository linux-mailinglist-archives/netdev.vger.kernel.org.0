Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA874DE995
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243676AbiCSRcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243386AbiCSRcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9CB4550E;
        Sat, 19 Mar 2022 10:30:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gb19so9875707pjb.1;
        Sat, 19 Mar 2022 10:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3WuzE/uAtr18lGVaEOIViWaXXDGLmE8cOvzc322Vqig=;
        b=U3gnt1odSsXS96u0KSUsMa4JdEK+c88qDiumrnoW9VlEI1drFOGmZFEJk8GSvB/T6x
         qa99pBmwoBsTYcODdLG0t69lxdoFOF5JsrU5lR4OYVfWG/dqOWi8GzPw93QkywOcu0BK
         Zr+I2xakib/C99HXmI0AH8SjCqKug9WUTf1MLAcMiG7bfjZp1jfLgUwez3Zf4kgdGKq1
         b+h+fwMAdWHAIMzPxwpm2/hWyM7NvwOz/+kMxwpRQ7A7ojh4BAailix4UWwAMZGFPBPe
         z7jjQmG/12K/lofHz2tTdldjKW2Q0G+Lb6wfZSDVEBtNCKzj7QYL0oofFaQkPOBVFJmh
         czpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3WuzE/uAtr18lGVaEOIViWaXXDGLmE8cOvzc322Vqig=;
        b=6u7PDM9UyOjlPRW90+IVnixC4C46GcPg2IcRPFnI8eZOw7I6VaqGGUYGohyE/IePCy
         xiVok9jvPXduqe37c0W60XmDQt1YXI8wa/lX7g+d4H0afA7IUXbkIL6qlIIl0rDz1bLi
         tuUNM1DdD4Gms2Sn5TPkww6tM5TIJY/+UfmmwjRY6UqtF5d2+1p2lzF3x9CcLvFHkUGg
         2V6+WlRYQDu5xqY5Gq1vrnlLkfCYibUXF1k2RpOt08Y1PsAOS7Jr0mCWxPqZAqjmeRay
         2bq8yClBSP+leYfhORa+IogImJQa8ZFUb+9IsRYf9nYIoFwpXB7x/ldHbuTE+ln2pKMY
         fMLA==
X-Gm-Message-State: AOAM532p7l3xohrres5+zHpPyRlKv3tTT+Ir+Cb6nOHLkYhUD7zCqURa
        30JBrWTH/6EHJbXaFY5velc=
X-Google-Smtp-Source: ABdhPJw9FIF9vgwyN8OREh52A/jGghm9PrNkyABokhdKcaIawAJarKGKDk7JTox59oPleyl7Um+K3w==
X-Received: by 2002:a17:90a:d584:b0:1b8:7864:1735 with SMTP id v4-20020a17090ad58400b001b878641735mr17400048pju.126.1647711046284;
        Sat, 19 Mar 2022 10:30:46 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:45 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 05/14] bpf: Allow no charge in bpf_map_area_alloc
Date:   Sat, 19 Mar 2022 17:30:27 +0000
Message-Id: <20220319173036.23352-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helper we introduced before to decide whether set the
__GFP_ACCOUNT or not.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f70a7067ef4a..add3b4045b4d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -307,7 +307,7 @@ static void *__bpf_map_area_alloc(u64 size, union bpf_attr *attr, bool mmapable)
 	 * __GFP_RETRY_MAYFAIL to avoid such situations.
 	 */
 
-	const gfp_t gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_ACCOUNT;
+	const gfp_t gfp = map_flags_no_charge(__GFP_NOWARN | __GFP_ZERO, attr);
 	int numa_node = bpf_map_attr_numa_node(attr);
 	unsigned long align = 1;
 	unsigned int flags = 0;
-- 
2.17.1

