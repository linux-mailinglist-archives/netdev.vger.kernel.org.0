Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6323455C1
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhCWCvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhCWCvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:51:38 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBF4C061574;
        Mon, 22 Mar 2021 19:51:36 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i9so12960333qka.2;
        Mon, 22 Mar 2021 19:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ptq96JfaAwnF7JCWYyRFzxbIiqtchclo0BTDiv9S/Wk=;
        b=YfdKwY6l+UiL6SO97vppfXP0/18kSVySI/bGL12f7axAMlgizwigCeGO7zHYKa7leS
         uxGuoBaT+HH4RU0BuHVmcmqozwVLJ7QFFWstjHABRSomlsLaNU+Xu8NH8/FVgp8Rko/G
         lpKN3ta7W/wUQuPN45GYlv/BXvhxiBca+K1z/ZMVlSniIs5qu3M5s5OpP5i7C/pZKY24
         9v5Tvj01jhZ+GgMj3ccw5SR2r1M7c/TVZh3vQs+3GIryMwuQzwVOQ2d1Fpfqy5579mvl
         Ev4QYn+EdRBGnGXos9vEZ7GvK2p6EvwpB2Yv5Eb1DAa7mTDS5eU5Y5HrUhBL0N1GQKYE
         wK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ptq96JfaAwnF7JCWYyRFzxbIiqtchclo0BTDiv9S/Wk=;
        b=LO8OntzWronFGUCNJ/dvLwMZW7a7oeiDmvbuRjg4QQxEBrTKhvt3wEqPm/M+gI6PZk
         a2Eg3i2BHNTo/F3ki9CEuEy1ZZ19JbFON/utne0VPjWFcg4TO+srJquR+w7HBaW7nrv8
         Igr5/JAB2xz8wWnG9yqbl5pYh28ucDdR2UzRyxbI34PmFSTsjUo7afjft877UhkEyBMJ
         R69/A00ON9deOkur7sjUyezdB2Eh7tGn12VoJBmWG2dXjmqLoqdA00qrvfkcoLeFkqNX
         8btDRfNv9yd5y70bH8ebCsVpx6HHo8vRHYvBshwfvQvt6l3VvQS1HfJL15wFa0N0W+30
         5SCg==
X-Gm-Message-State: AOAM5311oZlcHFGthx16MQX/OPf0WBSlaSrm9rFW2Bh6/t+yRhnuNZiP
        OMq1gPql7hdWBv3CPFktzEE=
X-Google-Smtp-Source: ABdhPJyrDLNwa9vOgD7S+DxD/8ZF1lJdxwqEtepBPaA6ozDvH2mjwsGEM6ntAKQ4gQy3wfl//an36A==
X-Received: by 2002:ae9:ee07:: with SMTP id i7mr3271884qkg.233.1616467896061;
        Mon, 22 Mar 2021 19:51:36 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id h13sm292265qtn.26.2021.03.22.19.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 19:51:35 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] bpf: add support for batched ops in LPM trie maps
Date:   Mon, 22 Mar 2021 23:50:53 -0300
Message-Id: <20210323025058.315763-2-pctammela@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323025058.315763-1-pctammela@gmail.com>
References: <20210323025058.315763-1-pctammela@gmail.com>
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

