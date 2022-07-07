Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B93D56AE95
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbiGGWcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiGGWct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:32:49 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C149567587
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 15:32:40 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id t189so25036311oie.8
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 15:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HPI3ojZnM++1c4f61ZRwt4MaisU1ny63+tYPCLxBNyU=;
        b=pPJLzKN/n3H53u85lbMzUgP5UsS4fil38YQ7/dfmeg3M8/AKwxVBk+o8JUNfyzo0BU
         Ma1+B6VEHpA2z1r2kpEhbf43UigQAbI7DljAQ2RMp1GasHdit7vE00Ayz/lHyMPIYe7S
         pfSyPARlPQPu+9DCiuXMHuQvu7ASo5GBxM43g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HPI3ojZnM++1c4f61ZRwt4MaisU1ny63+tYPCLxBNyU=;
        b=3KXl5T/o45MViB59Ji2WFCBPKQdL0pVXzMejDTQpx0dXkSMOId+/nLcZl1l1ronJo0
         ERlzV6ZXQ3qNVcUDs7widt9jDWcwifi5rTtVVfP/DeECblIqR/Bh5YnU4rhtTJPmFmBo
         xa7hf9SSj4aCVq4OSFjEKVdQI3vKKBzrb5IKxEmNMnbOyoMGyFplSE+d9ktPsRERxUAJ
         0HT3zvdZ2d3KUI5J7pn5J2pFRXqt+OF5PlsleQnZSffIOrgQNmNv7mw37tNEmHWtySAR
         l/xt5kYPOrkfPBnHN6+dojHHObf1RYzF8TAMu5+8CC8UUWSWMVz4P0Dk6c9gLLpP09hd
         5yCA==
X-Gm-Message-State: AJIora+vbWJ3o11/GOQZUWtG9mbrY6cmyusI4a/fkroArz2OpT0F4q9H
        q0gocG8A5HLKbuM8v5sXysPCeQ==
X-Google-Smtp-Source: AGRyM1tcIEZsE2gFDfWZ+ydTaErjmU0vLWY1y/NAd+s5mkdDoWOmXG6TCxhhNFR7u0n6nfjScfGdRg==
X-Received: by 2002:a05:6808:11c4:b0:2d9:c395:f15e with SMTP id p4-20020a05680811c400b002d9c395f15emr3824812oiv.47.1657233160506;
        Thu, 07 Jul 2022 15:32:40 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id i16-20020a05683033f000b00616b835f5e7sm16246222otu.43.2022.07.07.15.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:32:39 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH v2 2/4] bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
Date:   Thu,  7 Jul 2022 17:32:26 -0500
Message-Id: <20220707223228.1940249-3-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220707223228.1940249-1-fred@cloudflare.com>
References: <20220707223228.1940249-1-fred@cloudflare.com>
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
Changes since v1:
- None
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

