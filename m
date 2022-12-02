Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A60C640AC8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiLBQaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiLBQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:30:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC59E368B;
        Fri,  2 Dec 2022 08:29:12 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q1so4760364pgl.11;
        Fri, 02 Dec 2022 08:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=acpzyOeZw6sYRPpn3989BmT54E7u3z+H4u+6EjuyQA0=;
        b=iOgA1ZOrh3PEuuR9D272sCYvElipPKe3w+HPmvUgBDilSHN9Q2JFoHZRHvSDlVSpXN
         eDgczsrdK2HUGMNyNR3zQypSJdQ93RCZRrzGpYZrvvYjUgI9jkC2Ti8sZzYrs7g5hh2J
         RQM9ycR9bTJb6Yxp9lWkdzYQ5fZ+EM8i+zk8r6fYIoQ120kMfG+JPlT+uU1o/ciZvjFG
         ANe1g74h1luXy4pdp1LpnpfGmlhTwBjT/IZWxVJLcDM5rAP8RUe2jbVKiA1M/D05cqu7
         bjmjJxL/WoWyw0N3vbt7Ly+GpfRf2ukMyOzuOWPz7VXJn2hAgOytGMZ/oRRc1KK7vao9
         U7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=acpzyOeZw6sYRPpn3989BmT54E7u3z+H4u+6EjuyQA0=;
        b=sb3bHIOx351uLTA2IideIuwhsnqctnWJQjYjQRmYJKartlVXiHHNsdAaJt4nEHuKP5
         GJFPyttiOw3rDZxclV8QD2EDblXrLo6Pi2G0oWjEdc0ueV7QrS7Mm47ZSY+g6N/Gpo7j
         ImX2qEDrKrZ3l3OuGJgo7aQiomYiBdwUGZTjgt95+2WRentJzz3s+473FN3e2CXoTgs2
         U6QFRv5hFQ0Fb9SD7N0DX3gKUjb4OLqwiqkjwxbB3Jm+0MWr6zYkctJ0zgTqPm1XHt9V
         S3+WELVoWAYflm0v0veSXRIqEWtcmM26GHlJztd6lfPebi2F7myvVxmvAS0Kfjf3ByBt
         8N1A==
X-Gm-Message-State: ANoB5pkPupn3Rl6UkXJZN/DpdPQ85zEyw/cYZuBmNUgOU3N9UE24JHB1
        mdVfYgteMGm6Sf58KL3zUUt/9Ml22Q==
X-Google-Smtp-Source: AA0mqf5fQADGE40zm69RZ8G1PW8BsW4CoP80+gkBWRUiCv7jfAegLNGkOo2SkNOn7kj9doTtlOsHNw==
X-Received: by 2002:a63:5b44:0:b0:46f:c9e8:5752 with SMTP id l4-20020a635b44000000b0046fc9e85752mr46198325pgm.157.1669998551450;
        Fri, 02 Dec 2022 08:29:11 -0800 (PST)
Received: from WDIR.. ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id g3-20020aa79f03000000b00565c8634e55sm5300123pfr.135.2022.12.02.08.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:29:10 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] samples: bpf: fix broken behavior of tracex2 write_size count
Date:   Sat,  3 Dec 2022 01:29:07 +0900
Message-Id: <20221202162907.26721-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Currently, there is a problem with tracex2, as it doesn't print the
histogram properly and the results are misleading. (all results report
as 0)

The problem is caused by a change in arguments of the function to which
the kprobe connects. This tracex2 bpf program uses kprobe (attached
to __x64_sys_write) to figure out the size of the write system call. In
order to achieve this, the third argument 'count' must be intact.

The following is a prototype of the sys_write variant. (checked with
pfunct)

    ~/git/linux$ pfunct -P fs/read_write.o | grep sys_write
    ssize_t ksys_write(unsigned int fd, const char  * buf, size_t count);
    long int __x64_sys_write(const struct pt_regs  * regs);
    ... cross compile with s390x ...
    long int __s390_sys_write(struct pt_regs * regs);

Since the __x64_sys_write (or s390x also) doesn't have the proper
argument, changing the kprobe event to ksys_write will fix the problem.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/tracex2_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 93e0b7680b4f..fc65c589e87f 100644
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
2.34.1

