Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E78553F18
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354624AbiFUXj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiFUXjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:39:52 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B233123A
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:39:51 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101cdfddfacso12247178fac.7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jUmOqM8bvsG8cDfx+XvNCDDl82awPaNafAtF5jFkQEY=;
        b=o5t9urnpI0OdvMgRHCew9GBUrfvNLmNKP8PEUMDjteDWRX9zW0tnOI51xheMxEFYAJ
         5SEdi6X2zEaSJF4Ud4OzuVLtfivzHa7Ctp2wYHZsqHTr8iBuDQVvzZN4vZpmSiqciPwK
         VVjhfdZ+3Ur1hFKuRE3jvHYIR5noV4NdKabvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jUmOqM8bvsG8cDfx+XvNCDDl82awPaNafAtF5jFkQEY=;
        b=qup5C4anO3MGFMzQiq1UxDwU/ofnTXICskzdKgNxdBCLhNINu+I9cuKU3tNhxM6E8X
         lUg3/extTT3tIvMNwETYyPpMAmlERband5wbPXttkQ/8CVGH8itBor1UHBrMjsqIFYtr
         N0Q/7bhUgRGbd1a6jJGcHFe+ouBDK3yTxxb5ZKkvTES/jsuiM4ymBYoVuFHeyYRIwYcj
         YECLgRc/S2Sc5a/sWHutbzqnj2YMCHod6DPonxmymuB8gO+hiy6UjM3TnStaae9S3MZ8
         0LCLpWB+WhyKzFcqRuPo7fy/mkQDYW24tRbW6xtTm+rvXooym/hu+viPIMo68teNkMaU
         fTLw==
X-Gm-Message-State: AJIora8Cr34CDkvDwt5UbKf930t3oRAIgXS65svnoI8kSDmDMA0sTooJ
        NB4SjZLJ1+9DWAP1IcjGjbVDIg==
X-Google-Smtp-Source: AGRyM1t7CRjxualNOBRcURL8BoZp/Y8//UgT00jArGQfdCguxh7jvEelxlI+yNApXmiS4XDdhSPRvQ==
X-Received: by 2002:a05:6870:8909:b0:101:202e:a71d with SMTP id i9-20020a056870890900b00101202ea71dmr371858oao.272.1655854790690;
        Tue, 21 Jun 2022 16:39:50 -0700 (PDT)
Received: from localhost.localdomain ([172.58.70.161])
        by smtp.gmail.com with ESMTPSA id v73-20020acaac4c000000b00326414c1bb7sm9839181oie.35.2022.06.21.16.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:39:50 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     brauner@kernel.org, casey@schaufler-ca.com, paul@paul-moore.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH 2/2] bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
Date:   Tue, 21 Jun 2022 18:39:39 -0500
Message-Id: <20220621233939.993579-3-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621233939.993579-1-fred@cloudflare.com>
References: <20220621233939.993579-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users may want to audit calls to security_create_user_ns() and access
user space memory. Also create_user_ns() runs without
pagefault_disabled(). Therefore, make bpf_lsm_create_user_ns() sleepable
for mandatory access control policies.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>
---
 kernel/bpf/bpf_lsm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c1351df9f7ee..75853965e7b0 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -250,6 +250,7 @@ BTF_ID(func, bpf_lsm_task_getsecid_obj)
 BTF_ID(func, bpf_lsm_task_prctl)
 BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_task_to_inode)
+BTF_ID(func, bpf_lsm_create_user_ns)
 BTF_SET_END(sleepable_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
-- 
2.30.2

