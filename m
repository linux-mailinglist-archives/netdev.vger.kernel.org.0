Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFD2553F19
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiFUXjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiFUXju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:39:50 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C05431222
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:39:47 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id w16so19077105oie.5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R2mtRCui72arwwdDzhHcYMhEmif96x0EwcrauisT3VI=;
        b=OKq+JTNlWYyJIGaHUB9FKXgvMsyco0CeOWV1KYGWQohAZt5NFz5zqXeDRWNKqF0Aqt
         GOLRsh7mIOUphoH/n2W4X+nfqb4ogdgJU1DmkO3+vV9csNfMd8uYI2VVWvf1QxtvoGND
         znZdRcMnCbbdIrTnDFZCu2eAdFbusULqHF9wI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R2mtRCui72arwwdDzhHcYMhEmif96x0EwcrauisT3VI=;
        b=adumyI8ONhNnOJW6bmAg29EuMMQFyxSVEWasvALUKyIkm+f2/e+NI0l2NBC4XoQVLl
         Q7Lhhf2LmtPdKKdmor4nXWg9U01RRJL5p2G1IxIX7G8kS2/iKfkKOz00vClaexZkqkQ9
         CDmtBu3T4FkFJDlNGdAjJisqmyGGTaKmtsGFDIccS2Ewd8MuXPuZCZ4xer10Ry3dMgBx
         VNd6GyAWCZ5usB+sDRn4cGLaPvQUCsxLeReHVaxqzAxk+2L7l4M+UIF5RX3Hd7QL3n60
         R1E06o9Gu4Cacz5nA1wcy8Jd8828QCU1DNUD2UG6Mt1T+7cZjjP3xOYWlinBIccVFzIp
         GWbA==
X-Gm-Message-State: AJIora8zC/4TbEjkRkrWtf+OQjtvzdNA/TK2PlqFhqtzPK7ujWEf3k0s
        JzrtE7wjM/cc+ppv59Rfqe6Zzw==
X-Google-Smtp-Source: AGRyM1ts+C26w140QWlx3d+zDUAjQ78qI7RFoU1b/uc+4z1s7d/teJ2UVJd9we/sAYT8ZD8v8Ai1ZQ==
X-Received: by 2002:a05:6808:150e:b0:331:39bf:2228 with SMTP id u14-20020a056808150e00b0033139bf2228mr329850oiw.9.1655854786546;
        Tue, 21 Jun 2022 16:39:46 -0700 (PDT)
Received: from localhost.localdomain ([172.58.70.161])
        by smtp.gmail.com with ESMTPSA id v73-20020acaac4c000000b00326414c1bb7sm9839181oie.35.2022.06.21.16.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:39:46 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     brauner@kernel.org, casey@schaufler-ca.com, paul@paul-moore.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com, Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH 0/2] Introduce security_create_user_ns()
Date:   Tue, 21 Jun 2022 18:39:37 -0500
Message-Id: <20220621233939.993579-1-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
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

While creating a LSM BPF MAC policy to block user namespace creation, we
used the LSM cred_prepare hook because that is the closest hook to prevent
a call to create_user_ns().

The calls look something like this:

    cred = prepare_creds()
        security_prepare_creds()
            call_int_hook(cred_prepare, ...
    if (cred)
        create_user_ns(cred)

We noticed that error codes were not propagated from this hook and
introduced a patch [1] to propagate those errors.

The discussion notes that security_prepare_creds()
is not appropriate for MAC policies, and instead the hook is
meant for LSM authors to prepare credentials for mutation. [2]

Ultimately, we concluded that a better course of action is to introduce
a new security hook for LSM authors. [3]

This patch set first introduces a new security_create_user_ns() function
and create_user_ns LSM hook, then marks the hook as sleepable in BPF.

Links:
1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/

Frederick Lawler (2):
  security, lsm: Introduce security_create_user_ns()
  bpf-lsm: Make bpf_lsm_create_user_ns() sleepable

 include/linux/lsm_hook_defs.h | 2 ++
 include/linux/lsm_hooks.h     | 5 +++++
 include/linux/security.h      | 8 ++++++++
 kernel/bpf/bpf_lsm.c          | 1 +
 kernel/user_namespace.c       | 5 +++++
 security/security.c           | 6 ++++++
 6 files changed, 27 insertions(+)

--
2.30.2

