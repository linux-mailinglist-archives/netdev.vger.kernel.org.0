Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ADC471854
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 06:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhLLFEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 00:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhLLFEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 00:04:22 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4716C061714;
        Sat, 11 Dec 2021 21:04:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id m15so11537781pgu.11;
        Sat, 11 Dec 2021 21:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=oz3vhxEEPbDamv8BpZGdKnIlSqK4/xNum2DQN3KV040=;
        b=dtdBI74AVvKFn2hVSFY1xTijT8b/vroECOjGYYi+ZH6zvqViC5UKg+lE5vdk/7VSGR
         FGMTikEUuO3Ye38rWCx9KyCv7b476yhlhCPgVz8yORhwOZ3/h5sht5pvJ8MRq+gJQtyu
         H/b/7LUipv6UVEGTKq39L5buto4C+p2iOwFEhAg6HjB6wwKNb4t4dAhVegw4GbGJp0+Y
         dj4EQnSjeD8ii3fYC9183OrNFSi/eJri0rxWuLObOjREfTQjaoCxKb3f5HrbDXgLvQSu
         KPSbFXKBOA5Y5LFccwEtewZa39kDmw/kEgkhMDuZ/w4Duz3eKHDKu/mVXtR5wUsT2gok
         k9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oz3vhxEEPbDamv8BpZGdKnIlSqK4/xNum2DQN3KV040=;
        b=guw3/fqm8JVNA/FtzE+BQAjQXuvZl68TRq5vRHFKZTXkGyZfMWXdmuCCrRlwFd5kJb
         +5x4t4w1mksb5SFR8as/KxxVYi+ii0tyWId3ZMAYmnbDzYX9ldtb7VoMIVSGXQWqI69+
         QNsN9Q6CsSTrP98Ll6wlU+hbFxHLXmqHVNpKgOvkyepPwzQAvipeNtqzjKUNdhgG9VBg
         sXPGX4Miu9vPXxGKLbqumorx782uNFSh+0ppkz4l3uwP2nmtGx8l+3MR66lLl3CvZuMi
         PHsy/AJj4IQOqPKoI4fHc1GgNemKA/8jop5ev/NKyRF9smrE3Y5E108sZ0gNqPBT2it7
         shCg==
X-Gm-Message-State: AOAM530dA08pom1KYjEHTil6+PEAdacZDTyHfakpPqwSE8T4zPS4/mg1
        ucrNYzr/SqrAJk8XyRluhfA=
X-Google-Smtp-Source: ABdhPJxp8O7H93R7IQqwX49pF2ZGZ7g34OK0J6VZ9zqALaZxPtmCIxtbSALCuBAkTqsPrz2MtqnyCw==
X-Received: by 2002:a63:8bca:: with SMTP id j193mr9023278pge.293.1639285461166;
        Sat, 11 Dec 2021 21:04:21 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id n22sm7707766pfu.2.2021.12.11.21.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 21:04:20 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hengqi Chen <hengqi.chen@gmail.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpftool: Fix NULL vs IS_ERR() checking
Date:   Sun, 12 Dec 2021 05:04:12 +0000
Message-Id: <20211212050415.17273-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hashmap__new() function does not return NULL on errors. It returns
ERR_PTR(-ENOMEM). Using IS_ERR() to check the return value to fix this.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 tools/bpf/bpftool/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 015d2758f826..4a561ec848c0 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -899,7 +899,7 @@ static int do_show(int argc, char **argv)
 				      equal_fn_for_key_as_id, NULL);
 	btf_map_table = hashmap__new(hash_fn_for_key_as_id,
 				     equal_fn_for_key_as_id, NULL);
-	if (!btf_prog_table || !btf_map_table) {
+	if (IS_ERR(btf_prog_table) || IS_ERR(btf_map_table)) {
 		hashmap__free(btf_prog_table);
 		hashmap__free(btf_map_table);
 		if (fd >= 0)
-- 
2.17.1

