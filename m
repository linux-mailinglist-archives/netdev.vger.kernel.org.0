Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A850502B95
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354339AbiDOOQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354357AbiDOOQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:16:54 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3722CF4AF
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 07:14:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bx5so7717290pjb.3
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 07:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7pJ87MMKgb5DtroOsn6zX1k9Enz1UopIOm4KxB8CdU=;
        b=cl6RaMXM2TAsZOMW89aMuGQgKEIMl7GsTFPcrv7gyNZd1WPR48gwuVCjmE3gnHj6MM
         kx0a533ilutzRFYcLIfQtywqy5NCvd1VgNO9pK/tt5xuOHORBDeX9jKs5QGJjKGI5YO2
         7VQURjVRDdga27AqW4x9aRdYTYzNcIQutvTEcNAjPflq22e+8XAzskHHnXwjWa6Yuzuq
         ZCBe643HeK945voQ4oLhvyxW4gQ8gRuxCRnRv0OIN9CgPq11WfaGQSszlsHQpbwL/0An
         lxWAIZPK0N+9PmGU/j5fXIM14NiJHnQmlUCoynlpBAMpF/ilxXatwHTfIbC6LjY0BODd
         ZzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7pJ87MMKgb5DtroOsn6zX1k9Enz1UopIOm4KxB8CdU=;
        b=SDET8u0Rr1R2ahYMScSz99HNzcYPXXr7rgjJfERZaP0TGIpT+Dfn3ye0Ft5K4k5AJH
         J4P78lwHYsD4lw31PHSCWJugiAC0m8c42LHX0aIvYLurVR+WsFglzGvBPg/Rwm83Mq5r
         nVK5Ids9ozVHf4E4pcc9DfUesc0meFJtBTWZjRZ+dlvIuyzx27cMFVTz9sJDS5rRriNe
         UfbvPP2sN4K1894LD1s41t39biM7itnW5mmsdJLZihdQnQgtgRiFpFIkxvgQ0X5Yc9e3
         ghTCUDoB0wLGodOKWPAioCkg7nuAxZwCNUfBNm7c+yQ3JZ950OMR/8vXs+0BEZ/6j5UX
         eB7w==
X-Gm-Message-State: AOAM530+kv8NHULc5IX0TKWN76+dQTzgrdSjR5eeo/6etQ0DKycuUcna
        B57+LTwVVNvBEdxymF0iotI+FQ==
X-Google-Smtp-Source: ABdhPJwIMENFkDtZsLGQMuu3vxL5lc0twYuZQL+N4DXflSHdA2RL1NFxd/fLLyIOwAIcuhK3MyNKZA==
X-Received: by 2002:a17:90b:380f:b0:1c7:4403:4e72 with SMTP id mq15-20020a17090b380f00b001c744034e72mr4462158pjb.228.1650032063329;
        Fri, 15 Apr 2022 07:14:23 -0700 (PDT)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id n24-20020aa79058000000b0050612d0fe01sm3012707pfo.2.2022.04.15.07.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 07:14:22 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     andrii.nakryiko@gmail.com
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
Subject: [PATCH v2] bpf: Fix KASAN use-after-free Read in compute_effective_progs
Date:   Fri, 15 Apr 2022 07:13:55 -0700
Message-Id: <20220415141355.4329-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzbiVeQfhxEu908w2mU4d8+5kKeMknuvhzCXuxM9pJ1jmQ@mail.gmail.com>
References: <CAEf4BzbiVeQfhxEu908w2mU4d8+5kKeMknuvhzCXuxM9pJ1jmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a Use After Free bug in compute_effective_progs().
The reproducer creates a number of BPF links, and causes a fault
injected alloc to fail, while calling bpf_link_detach on them.
Link detach triggers the link to be freed by bpf_link_free(),
which calls __cgroup_bpf_detach() and update_effective_progs().
If the memory allocation in this function fails, the function restores
the pointer to the bpf_cgroup_link on the cgroup list, but the memory
gets freed just after it returns. After this, every subsequent call to
update_effective_progs() causes this already deallocated pointer to be
dereferenced in prog_list_length(), and triggers KASAN UAF error.

To fix this issue don't preserve the pointer to the prog or link in the
list, but remove it and rearrange the effective table without
shrinking it. The subsequent call to __cgroup_bpf_detach() or
__cgroup_bpf_detach() will correct it.

Cc: "Alexei Starovoitov" <ast@kernel.org>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>
Cc: "Andrii Nakryiko" <andrii@kernel.org>
Cc: "Martin KaFai Lau" <kafai@fb.com>
Cc: "Song Liu" <songliubraving@fb.com>
Cc: "Yonghong Song" <yhs@fb.com>
Cc: "John Fastabend" <john.fastabend@gmail.com>
Cc: "KP Singh" <kpsingh@kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
v2: Add a fall back path that removes a prog from the effective progs
    table in case detach fails to allocate memory in compute_effective_progs().
---
 kernel/bpf/cgroup.c | 55 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 128028efda64..5a64cece09f3 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -723,10 +723,8 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	pl->link = NULL;
 
 	err = update_effective_progs(cgrp, atype);
-	if (err)
-		goto cleanup;
 
-	/* now can actually delete it from this cgroup list */
+	/* now can delete it from this cgroup list */
 	list_del(&pl->node);
 	kfree(pl);
 	if (list_empty(progs))
@@ -735,12 +733,55 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (old_prog)
 		bpf_prog_put(old_prog);
 	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
-	return 0;
+
+	if (!err)
+		return 0;
 
 cleanup:
-	/* restore back prog or link */
-	pl->prog = old_prog;
-	pl->link = link;
+	/*
+	 * If compute_effective_progs failed with -ENOMEM, i.e. alloc for
+	 * cgrp->bpf.inactive table failed, we can recover by removing
+	 * the detached prog from effective table and rearranging it.
+	 */
+	if (err == -ENOMEM) {
+		struct bpf_prog_array_item *item;
+		struct bpf_prog *prog_tmp, *prog_detach, *prog_last;
+		struct bpf_prog_array *array;
+		int index = 0, index_detach = -1;
+
+		array = cgrp->bpf.effective[atype];
+		item = &array->items[0];
+
+		if (prog)
+			prog_detach = prog;
+		else
+			prog_detach = link->link.prog;
+
+		if (!prog_detach)
+			return -EINVAL;
+
+		while ((prog_tmp = READ_ONCE(item->prog))) {
+			if (prog_tmp == prog_detach)
+				index_detach = index;
+			item++;
+			index++;
+			prog_last = prog_tmp;
+		}
+
+		/* Check if we found what's needed for removing the prog */
+		if (index_detach == -1 || index_detach == index-1)
+			return -EINVAL;
+
+		/* Remove the last program in the array */
+		if (bpf_prog_array_delete_safe_at(array, index-1))
+			return -EINVAL;
+
+		/* and update the detached with the last just removed */
+		if (bpf_prog_array_update_at(array, index_detach, prog_last))
+			return -EINVAL;
+
+		err = 0;
+	}
 	return err;
 }
 
-- 
2.35.1

