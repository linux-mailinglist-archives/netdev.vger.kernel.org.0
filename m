Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7C93CCFCB
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhGSIUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:20:20 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:40947 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbhGSIUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:20:14 -0400
Received: by mail-wm1-f46.google.com with SMTP id f8-20020a1c1f080000b029022d4c6cfc37so11013419wmf.5
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NxO5u2m/WVWG39hgIbDJ0ZUbjUb2aBaNDMtLZUWAtSE=;
        b=zEq+wT3EN0r60MoQF4ywKFoXQfty/1PcTdDVXUsST7Y52y/FRB4+4ivyI+celySiBP
         FyujFSndPF96XRaAXUb2SPPhj6Op97PPzEZ8YRG44JPTworVmaBAYrX4eKX/EJFq9cTR
         YzMiSb8LFfujoOsWxIT1JvFl0GBAExIrdntSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NxO5u2m/WVWG39hgIbDJ0ZUbjUb2aBaNDMtLZUWAtSE=;
        b=pUhEmHXSVvWHhsys3Qh/J9cFRcakrj+fRTCdGTqOuY9uZ73T9bR0lvGDXqOoAm/6xR
         HrB70PAClBvRevFVGupL+stsWcZU1KfbjBgKaafgvtYc5lYjvotNJmVlpBYkcXWd1B+P
         vKVpvMlGSB1WXA0fgcUQeJumq1N6VfppGWfx5/A69WaI2Oanc9Xetc5/LM9ihCSQOdri
         0mffZtZMgWeLoB8T7S7gNr2N0TyIrrvTO4ErDCUbZfEvXTIM3lZogeDCSFite50s6TmX
         g449lMVEHOKjpOUK6/mtgAd4rAiFWpOp/rZFNO/mGLsgevjjiF4PHwFb7Ykx8nXRNpKg
         WB5g==
X-Gm-Message-State: AOAM533G+4eUqi313L5XULXWmsYLPBoof1r+8BFVbu0kPr23GKvKqEZw
        DTYnTQHt6sXgSCm8/2E2I8/cnwETimOk2A==
X-Google-Smtp-Source: ABdhPJwiRWzVkYTeESpwfioliaNRShYfOHT5QlSdrSw9nFeeAoQoqRUtoY3NQ9Iu3AVxcVqZVWsZLw==
X-Received: by 2002:a05:600c:3b93:: with SMTP id n19mr30885778wms.3.1626684714205;
        Mon, 19 Jul 2021 01:51:54 -0700 (PDT)
Received: from antares.. (8.5.4.3.6.6.4.c.b.0.4.b.8.b.e.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4eb8:b40b:c466:3458])
        by smtp.gmail.com with ESMTPSA id 12sm20079763wme.28.2021.07.19.01.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 01:51:53 -0700 (PDT)
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
Subject: [PATCH bpf v2 1/1] bpf: fix OOB read when printing XDP link fdinfo
Date:   Mon, 19 Jul 2021 09:51:34 +0100
Message-Id: <20210719085134.43325-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719085134.43325-1-lmb@cloudflare.com>
References: <20210719085134.43325-1-lmb@cloudflare.com>
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
index a9db1eae6796..ae3ac3a2018c 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -134,4 +134,5 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
 BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
 #ifdef CONFIG_NET
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
+BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #endif
-- 
2.30.2

