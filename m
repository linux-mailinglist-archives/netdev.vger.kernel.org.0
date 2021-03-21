Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3AA34357D
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 23:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCUWrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 18:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCUWqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 18:46:24 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B3EC061574;
        Sun, 21 Mar 2021 15:46:24 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id x27so7837279qvd.2;
        Sun, 21 Mar 2021 15:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ptq96JfaAwnF7JCWYyRFzxbIiqtchclo0BTDiv9S/Wk=;
        b=A46RN/59frzmi8xXTRMgR3qcn+iO/QIf8ZDC58ZzR4Ii8OHXA3ey4hlzimztmewcER
         xcmZ7U+qKGOPsg1WWiZgo+E9jLfI2V33NGKtncFtqlZ2mP3qVm1K2PlOtDAcpiOXhEQt
         jwGGD3KIucGM89HgeFSfskn1BXpMdvk3+viGhXV/6p0YqRKWDQVSVWDq4TBP5I5Wk2tH
         X/O6nSk2Dgt0e0i/UYqr/GOEn74X21gTBULCc1D34FkSp/mClzxinkxzJI9eWV4Gnji+
         1VCzxOTtbU1ZMcu4Dc3bmoPiNngC1AXY3dMmba64ACGhrbSz4n6aSU83oPhuNAa/6bK1
         NJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ptq96JfaAwnF7JCWYyRFzxbIiqtchclo0BTDiv9S/Wk=;
        b=iS8p3TJwKjRLnRfY7mICJD7Oj9xCnRagFAkrUMD2x+Z7V8aDZlyz1gMlm8/wEByoDY
         g7cwZhIoLyXcy7dMb4VF1sVUlhYzBiClpCv+CUSzSb0NxT6oZCYoYeazM6C2vYDnB0PP
         U2LPMJO5ahdvNvQsIsvqSfRMJngi0w8IVuGIxm023szojRaht2Zapa6WJLUtsxJaKibS
         nwDuPE9c7fUly26EYZjmpDVquBjkaNrssJqTWwKQo7C9Xcp45Sx32nM60JhKYMIxRqfM
         +WXXGUZVgLBqGy/OL3owx9jeZsw5ADUykPSlZU3QuFZsJQO8PdRD9qvonsBtoYDzNdvj
         TEYg==
X-Gm-Message-State: AOAM530kIaX2BRRULdmQ7v9mZsjKi80/ps7/7m0zfn+UYf4Ruz+ez6EI
        g6VkjnHGQf8NmNLkFxHYTTM=
X-Google-Smtp-Source: ABdhPJyIf0xUN3hhCZP8/1QG4wlVUEMxBrMp/mKOIhbY2Bf8kQfZynD3fAi8l8TN/ZMBnOoxL9irYw==
X-Received: by 2002:ad4:470c:: with SMTP id k12mr18834786qvz.9.1616366783461;
        Sun, 21 Mar 2021 15:46:23 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id k16sm6556825qkj.55.2021.03.21.15.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 15:46:23 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     jhs@mojatatu.com, Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf: add support for batched operations in LPM trie maps
Date:   Sun, 21 Mar 2021 19:45:20 -0300
Message-Id: <20210321224525.223432-2-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210321224525.223432-1-pctammela@gmail.com>
References: <20210321224525.223432-1-pctammela@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pedro Tammela <pctammela@mojatatu.com>

Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 kernel/bpf/lpm_trie.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index cec792a17e5f..1b7b8a6f34ee 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -726,6 +726,9 @@ const struct bpf_map_ops trie_map_ops = {
 	.map_lookup_elem = trie_lookup_elem,
 	.map_update_elem = trie_update_elem,
 	.map_delete_elem = trie_delete_elem,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_update_batch = generic_map_update_batch,
+	.map_delete_batch = generic_map_delete_batch,
 	.map_check_btf = trie_check_btf,
 	.map_btf_name = "lpm_trie",
 	.map_btf_id = &trie_map_btf_id,
-- 
2.25.1

