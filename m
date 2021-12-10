Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD546FFB3
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbhLJLXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbhLJLXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 06:23:00 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A60C061746;
        Fri, 10 Dec 2021 03:19:25 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p18so6037070plf.13;
        Fri, 10 Dec 2021 03:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kwY1VEJYtn6EcwuoRvcNTGc/ITcR071MZ71xACzBa7E=;
        b=JqaNxKBRyYRNjkWHb4KB4MlHqiH/nBtS+xL+sTmy2s17+eUTNwNJ3aWfnnUjudYq6P
         hwO3027g9XMt+dhzBLVf1FRm23P+ayxjvHvHqdn/aF4j3SQ9H5gHQPmaWwxS5yy/bIo9
         l80t5ZbFcSkbzq3+3KAbQ/MoK83Q+gwhLbR+40X1zh51zEZile1/Cayd66mWFJpwPTnG
         xAjxfO4q0Mkg5xWu6KAF+Qb/vZ/OjuqWiGSkFOz/LEUWXUgBRi6bovsMu7KNFg5tyKIR
         RPH+8vQ4H1JF0/Xl94wpjHNCn2CTWeFlhmaHUUm4d8cmUgFg15qglSBODKR0gGlUKzfJ
         pHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kwY1VEJYtn6EcwuoRvcNTGc/ITcR071MZ71xACzBa7E=;
        b=cCVyLttdbYvPu+FyIhiKzVJCAYH9kLsGKtwpduyfbwez1nUsaC7bJe9jqg3IBQfaSF
         Tar8IJebiDYrlFxwxKHUeUj7VklbgZcB/l3O6Iyj6wMxDjeZMX6n3X/IYBzkdks6Hn9g
         7AEH3TY/JnwGaPWQMqf2nbdHqobSMvqSDrFuO/yFhhiF0g+YkJWS+IdC9jKA9/eQ4K/z
         moYksa/cRJsX+CpUSl4OGPQPplZaURzNyjUXFqXM2gTJOPhVYNoUtJH9U4vFywm+17tM
         lxQZKvp7hHrAxAF9DeuMB5Rh0SZrOtZA1SnuBl5DrNslkKZ4DAErf3kqgrYJvwHrPdlo
         s/qg==
X-Gm-Message-State: AOAM533WsG6cz863LrmiU+FlcStpCSxSpjWNrYxJF49PjER5Axe6talz
        5yjQTcAtFRfbRh2+KcCS0Q==
X-Google-Smtp-Source: ABdhPJzjb13cgS6Gop9dqMs3tqx7PwRGIwgV+Ze2Tw44iMAuusqOVvTzvw+xyi/MpyrqbRjd7kfEgg==
X-Received: by 2002:a17:902:ba84:b0:142:5514:8dd7 with SMTP id k4-20020a170902ba8400b0014255148dd7mr75348793pls.87.1639135165246;
        Fri, 10 Dec 2021 03:19:25 -0800 (PST)
Received: from u-u2110-5.. ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id x6sm2529197pga.14.2021.12.10.03.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:19:24 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] samples: bpf: fix tracex2 due to empty sys_write count argument
Date:   Fri, 10 Dec 2021 11:19:18 +0000
Message-Id: <20211210111918.4904-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently from syscall entry, argument can't be fetched correctly as a
result of register cleanup.

    commit 6b8cf5cc9965 ("x86/entry/64/compat: Clear registers for compat syscalls, to reduce speculation attack surface")

For example in upper commit, registers are cleaned prior to syscall.
To be more specific, sys_write syscall has count size as a third argument.
But this can't be fetched from __x64_sys_enter/__s390x_sys_enter due to
register cleanup. (e.g. [x86] xorl %r8d, %r8d / [s390x] xgr %r7, %r7)

This commit fix this problem by modifying the trace event to ksys_write
instead of sys_write syscall entry.

    # Wrong example of 'write()' syscall argument fetching
    # ./tracex2
    ...
    pid 50909 cmd dd uid 0
           syscall write() stats
     byte_size       : count     distribution
       1 -> 1        : 4968837  |************************************* |

    # Successful example of 'write()' syscall argument fetching
    # (dd's write bytes at a time defaults to 512)
    # ./tracex2
    ...
    pid 3095 cmd dd uid 0
           syscall write() stats
     byte_size       : count     distribution
    ...
     256 -> 511      : 0        |                                      |
     512 -> 1023     : 4968844  |************************************* |

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/tracex2_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 5bc696bac27d..96dff3bea227 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -78,7 +78,7 @@ struct {
 	__uint(max_entries, 1024);
 } my_hist_map SEC(".maps");
 
-SEC("kprobe/" SYSCALL(sys_write))
+SEC("kprobe/ksys_write")
 int bpf_prog3(struct pt_regs *ctx)
 {
 	long write_size = PT_REGS_PARM3(ctx);
-- 
2.32.0

