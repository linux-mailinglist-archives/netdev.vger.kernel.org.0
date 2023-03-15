Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA066BBFE0
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCOWgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjCOWgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:36:20 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2726A19F11;
        Wed, 15 Mar 2023 15:36:13 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso4384595pjc.1;
        Wed, 15 Mar 2023 15:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678919772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IOEmBovj2FFZNdFqth1MLg0JBxKL+SDjtFZi3HGAywg=;
        b=LAB8ckQg5cPH+QV81C2+sSLpl7QdDsZTBnCxky5YEQ6/HHnpCNqHfL0ZIvsw4Rw1Ty
         UFU23AsSJyMltPRYieqBs/2PbqjL/70ndl+eIGgiJDb+A4awjig6BvDEKDUUB1v1LTgv
         vsndA7dhP64n91Fl1cBS3XaXE9MI5sHA6V20YClUfCEYCUbgeUQvFf0dAzf5NhIhndSW
         Kox20rmnAym9AGhZr8uiB1EIwZWYP+LxQFsoLfCstwl39PKULQYnu6ygZ15jflOLJfMP
         tu+6ZRjjqCUlusHJBTCr8NgwHZEGQaHRew+lL5jHzqS4kFnlZbQ6rluy+/clg1qvXR7i
         fz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678919772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IOEmBovj2FFZNdFqth1MLg0JBxKL+SDjtFZi3HGAywg=;
        b=2DqbjWFlzdWPghIIMWXRFs+7+dAOowNC2SIAsFvChNHOe/B694IKlj8fQJTsCTRcg/
         PuS0qW9jEN8mru2j4UkYIBUwXa2ax4lNhiRs4F4YE7xQUTvdMPYmuh3M3baBBWBImYNy
         oIKClCU7NbvJwLlU9VuNozazQvo+JwKQpbCx5Vt+99BoJi8necxkwC+yHCpvxD/2p+4L
         rIOuVMuzcwrIFqISFSdHv9HlQU1tHbmx+wDL5eqNtC9p17W4bUOKzub9HG5arW+GNYPg
         OGu60HX9Q95wsTbFAXpYvr2xnXFm+9H46Z4rECizLVAZ9F65e+Zxwnm1wxUoeM/dhBIs
         2aCg==
X-Gm-Message-State: AO0yUKXMndNdkO+HViwXfDwLcOHVbmlyM8o64grf+t0mq5kvd11DIluk
        8stkXdz9+rb4NUrVulGgaxM=
X-Google-Smtp-Source: AK7set/VdZFKwsda61FTqz6SCPVdpdJnP9M2iGBRlb8+35ARJNeL0bukbmTy6kkMCG+avV9UiwJjwQ==
X-Received: by 2002:a05:6a20:3aa1:b0:d5:9216:9182 with SMTP id d33-20020a056a203aa100b000d592169182mr1374928pzh.9.1678919772264;
        Wed, 15 Mar 2023 15:36:12 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id e5-20020aa78c45000000b005e5861932c9sm106710pfd.129.2023.03.15.15.36.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Mar 2023 15:36:11 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 0/2] bpf: Add detection of kfuncs.
Date:   Wed, 15 Mar 2023 15:36:05 -0700
Message-Id: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Allow BPF programs detect at load time whether particular kfunc exists.

Alexei Starovoitov (2):
  bpf: Allow ld_imm64 instruction to point to kfunc.
  selftests/bpf: Add test for bpf_kfunc_exists().

 kernel/bpf/verifier.c                              |  7 +++++--
 tools/lib/bpf/bpf_helpers.h                        |  3 +++
 .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.34.1

