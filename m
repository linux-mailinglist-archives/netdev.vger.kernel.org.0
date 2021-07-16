Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8FF3CB5B0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbhGPKIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbhGPKIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 06:08:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172E3C061762
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 03:05:50 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i94so11423704wri.4
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 03:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCp/pg+XuWbTvMrNcAeNDWuWAPF6IPK9geF9Qe+H510=;
        b=hAZqa8UOO4TXGs/6z/CGk67n27e/Y/5EuFmH48DrwxhBe52aZGQuzi3R/wIjOY2SU+
         15AHQtjhc/TcuXKCYZ20EDfDYOJhLSaJi6mO2nugyCs/A1tpCAGQlLCnhpN8A7/FyN7B
         gfkTgsh4jmeg/Sg0x9XgFvjKJlNk0VZAUAoI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCp/pg+XuWbTvMrNcAeNDWuWAPF6IPK9geF9Qe+H510=;
        b=p0ODjIwGV/5CeZOJ/LQKbpL7abzxPFueTe0Fo5c78Q4KiOk0GK9BYRXVdRc1rx7NgF
         taQ0SjsSHMRjbFDaw5ormQIsFOdzjPZMVW8qR5Uf5VUAPtVj/DUXeQ/6HwafC/jKYG3n
         rD03O88GQDp6dm+0L0AbRfldm4WkhNtsXgMBkx1igfq/Wz3FPwVqQT3Iy4a3ytlcxK/V
         5aQHmZnEE18OvIZC5Doqytq+477Wo4SnJ/fdentUhkNSPDb/C7dxqJQ62IY8xzxZjrP+
         MhHXoWW4gnX6EEjslmUKqq9h5tIb6kuY89hf67Y18KOlWyjmzkbj7Wb1vqbNturqlHbv
         08XQ==
X-Gm-Message-State: AOAM5333QbJWd6IE50OQvacq4nkvYUSHLaCaiWKS4sccaHqVRWyoAyBt
        dBWYrffUuZyHIsGJ++PaxbkHTw==
X-Google-Smtp-Source: ABdhPJxbdmshTMgk1hQGw8995IwNopd77Ta6sR0JguOOX0cnRDgL6pKDXV+sDGoXUamE+KXaABHP9w==
X-Received: by 2002:a05:6000:180b:: with SMTP id m11mr11367626wrh.6.1626429948500;
        Fri, 16 Jul 2021 03:05:48 -0700 (PDT)
Received: from antares.. (c.b.2.6.f.3.0.0.d.9.9.9.a.0.6.5.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:560a:999d:3f:62bc])
        by smtp.gmail.com with ESMTPSA id l14sm9130706wrs.22.2021.07.16.03.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 03:05:48 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf] bpf: fix OOB read when printing XDP link fdinfo
Date:   Fri, 16 Jul 2021 11:04:52 +0100
Message-Id: <20210716100452.113652-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We got the following UBSAN report on one of our testing machines:

    ================================================================================
    UBSAN: array-index-out-of-bounds in kernel/bpf/syscall.c:2389:24
    index 6 is out of range for type 'char *[6]'
    CPU: 43 PID: 930921 Comm: systemd-coredum Tainted: G           O      5.10.48-cloudflare-kasan-2021.7.0 #1
    Hardware name: <snip>
    Call Trace:
     dump_stack+0x7d/0xa3
     ubsan_epilogue+0x5/0x40
     __ubsan_handle_out_of_bounds.cold+0x43/0x48
     ? seq_printf+0x17d/0x250
     bpf_link_show_fdinfo+0x329/0x380
     ? bpf_map_value_size+0xe0/0xe0
     ? put_files_struct+0x20/0x2d0
     ? __kasan_kmalloc.constprop.0+0xc2/0xd0
     seq_show+0x3f7/0x540
     seq_read_iter+0x3f8/0x1040
     seq_read+0x329/0x500
     ? seq_read_iter+0x1040/0x1040
     ? __fsnotify_parent+0x80/0x820
     ? __fsnotify_update_child_dentry_flags+0x380/0x380
     vfs_read+0x123/0x460
     ksys_read+0xed/0x1c0
     ? __x64_sys_pwrite64+0x1f0/0x1f0
     do_syscall_64+0x33/0x40
     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    <snip>
    ================================================================================
    ================================================================================
    UBSAN: object-size-mismatch in kernel/bpf/syscall.c:2384:2

From the report, we can infer that some array access in bpf_link_show_fdinfo at index 6
is out of bounds. The obvious candidate is bpf_link_type_strs[BPF_LINK_TYPE_XDP] with
BPF_LINK_TYPE_XDP == 6. It turns out that BPF_LINK_TYPE_XDP is missing from bpf_types.h
and therefore doesn't have an entry in bpf_link_type_strs:

    pos:	0
    flags:	02000000
    mnt_id:	13
    link_type:	(null)
    link_id:	4
    prog_tag:	bcf7977d3b93787c
    prog_id:	4
    ifindex:	1

Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index a9db1eae6796..be95f2722ad9 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -135,3 +135,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
 #ifdef CONFIG_NET
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
 #endif
+BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
-- 
2.30.2

