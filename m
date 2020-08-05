Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B5223D3F4
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 00:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHEWeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 18:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHEWeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 18:34:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A379C061574;
        Wed,  5 Aug 2020 15:34:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id r4so15801174pls.2;
        Wed, 05 Aug 2020 15:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZdTcq/NZYZsDLr8NZ6kN0pMeI/mG2A6FgNrtIK20u8=;
        b=efnzvfyee0ptWnJgyCoCPGpeQUBdn+vev8EAk1B18oatjKQBA/ohqf5juKB29kTvR2
         0bh44pyZcarIDHkXBqoF4DrczVn/7Z4/FGcIrAOmO5oU7w3zHfU29NUN8R0d8CV5c7jD
         3T8p8sZflXOn+a/tDqeypSeXuk49CkbgG+vAx0QYemafnyJvFvONq299HB5o93p6figh
         zJKIyHBRvumJa7S5Liv6R8e3zzznix6jjfEcn2sud7e3U5q4fCxD3tC1LAt2x0QAY+oI
         V/d4F3DpUHIrzsmR0sVWkkS/xo3jXbxnRCMHx5iK6frb6i+dl+pp+nMag7ebDuSQAdTX
         LP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZdTcq/NZYZsDLr8NZ6kN0pMeI/mG2A6FgNrtIK20u8=;
        b=JXOIhe+BQ74siP8nLtJ9k6q8Z5w2Y6IPPotgRHvcAXf8s6mWPudGRl92ms/QvNTXIQ
         Mq3YtNJcGeYW3XrjOT8oDkC1ZsFds9UEsYmD8WjMgVsSWhEO0odyurbQwHJ+XoVEKvTD
         PG5H6fKY0LLp2sVww6l2UveDi/et2KnZKLG3fr+Sf94+0fSezpDXyLPR+yzEHnvHYy3D
         vzcjMZHE3EVXVewTnF/u+qWFoYMNuggbtUDpPVb7IYPO1nAEmSWsk4vMZEkw7ozyOOrD
         ol6WkfXyRzR5p/E87de3uUZcjmoUFEdIR26QyTz2IbB6EMAgifZ7fn2oK8Wdqy2RHMhA
         4TVg==
X-Gm-Message-State: AOAM5326kGUyby8IIN4BE/N00Nfd0dGsDQq6UzhlxV+McDUj41kglrPJ
        beTtPeoAzImdwpFIf6Vc4g==
X-Google-Smtp-Source: ABdhPJxkELz7GGUnZ6aDMvAA3OKSilxwOKw0JF7T5PvpGi6BcnozTYXdhHLTe6bb3CB4FZelPysBUA==
X-Received: by 2002:a17:902:aa91:: with SMTP id d17mr5226698plr.27.1596666846471;
        Wed, 05 Aug 2020 15:34:06 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id 35sm3721596pgt.56.2020.08.05.15.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 15:34:05 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbf: fix uninitialized pointer at btf__parse_raw()
Date:   Thu,  6 Aug 2020 07:33:59 +0900
Message-Id: <20200805223359.32109-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, from commit 94a1fedd63ed ("libbpf: Add btf__parse_raw() and
generic btf__parse() APIs"), new API has been added to libbpf that
allows to parse BTF from raw data file (btf__parse_raw()).

The commit derives build failure of samples/bpf due to improper access
of uninitialized pointer at btf_parse_raw().

    btf.c: In function btf__parse_raw:
    btf.c:625:28: error: btf may be used uninitialized in this function
      625 |  return err ? ERR_PTR(err) : btf;
          |         ~~~~~~~~~~~~~~~~~~~^~~~~

This commit fixes the build failure of samples/bpf by adding code of
initializing btf pointer as NULL.

Fixes: 94a1fedd63ed ("libbpf: Add btf__parse_raw() and generic btf__parse() APIs")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 856b09a04563..4843e44916f7 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -564,8 +564,8 @@ struct btf *btf__parse_elf(const char *path, struct btf_ext **btf_ext)
 
 struct btf *btf__parse_raw(const char *path)
 {
+	struct btf *btf = NULL;
 	void *data = NULL;
-	struct btf *btf;
 	FILE *f = NULL;
 	__u16 magic;
 	int err = 0;
-- 
2.25.1

